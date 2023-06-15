Return-Path: <netdev+bounces-11131-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 997D9731A59
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:44:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA4EB1C20E97
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BC4D15AFC;
	Thu, 15 Jun 2023 13:44:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D35D156DA
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 13:44:34 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A99129;
	Thu, 15 Jun 2023 06:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=SsIYoQKvg5F33gUS1rii7FIH/8v6j9DwA2I0sd8z+E8=; b=U55QfBqIFXe9KXjC0Io6I8NY/f
	O5QHIwCks/rs8Pz9xkidFS2C3jaIlJygMZ2T9XLDxvNLPO+xR1gcrL9dp4fuk8TQVZW2XlJL3COvZ
	ZQXxZXZO7uiGByyyn9rB2sxUcev4RAhW3udj3/C0UYY2/NbzecBfP/lQgSXexq18xpL0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q9nH5-00Gb2J-0P; Thu, 15 Jun 2023 15:44:31 +0200
Date: Thu, 15 Jun 2023 15:44:30 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Benno Lossin <benno.lossin@proton.me>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>, netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org, aliceryhl@google.com,
	miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 2/5] rust: add support for ethernet operations
Message-ID: <61eb0c9c-3de7-42da-bd88-f3e63c7d3687@lunn.ch>
References: <20230613045326.3938283-1-fujita.tomonori@gmail.com>
 <20230613045326.3938283-3-fujita.tomonori@gmail.com>
 <QOy6Y8ZgaRA5ibTXnKAqNpMqJhlV49Jc75QaG-cgmF-MN0brxDFgMbCTIPO8lgZNjxbr3QQZMjTC-Fdl7KMmb6ppcN4Gqs9wvULPHroXWL8=@proton.me>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <QOy6Y8ZgaRA5ibTXnKAqNpMqJhlV49Jc75QaG-cgmF-MN0brxDFgMbCTIPO8lgZNjxbr3QQZMjTC-Fdl7KMmb6ppcN4Gqs9wvULPHroXWL8=@proton.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > +    /// Sets `ethtool_ops` of `net_device`.
> > +    pub fn set_ether_operations<U>(&mut self) -> Result
> > +    where
> > +        U: EtherOperations<D>,
> > +    {
> > +        if self.is_registered {
> > +            return Err(code::EINVAL);
> > +        }
> > +        EtherOperationsAdapter::<U, D>::new().set_ether_ops(&mut self.dev);
> > +        Ok(())
> > +    }
> 
> Is it really necessary for a device to be able to have multiple different
> `EtherOperations`? Couldnt you also just make `T` implement 
> `EtherOperations<D>`?

For 99% of drivers, netdev->ethtool_ops is set once before
register_netdev() is called and never changed.

There is one corner case i know of, and it is a hack:

https://elixir.bootlin.com/linux/v6.4-rc6/source/net/dsa/master.c#L223

Since this is a hack, you can probably skip it in rust. 

      Andrew

