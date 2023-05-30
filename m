Return-Path: <netdev+bounces-6369-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A55671601A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:41:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 799DA2811AE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA5A12B81;
	Tue, 30 May 2023 12:41:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA961C38
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:41:38 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48177E56;
	Tue, 30 May 2023 05:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=xFAjVPiZFt0cfsfW4euVq2yxKK+4k3xHYSHyCDA1Y04=; b=2kJn87YqP/R2SlePmpeEV3zW5d
	4AU/kpWd1WruduBYsQus4+ui0U3wIpyOBW1N30YkSg+J7kuoaMIGKREBCewfQR7+YrJ4UJ8ln53FJ
	BCCQkHCIjar5LYWdu0FKLs3I2lh46jcvWW3vmNeyjG4aXvvxNy3c4ixwJJgOHAwaHarQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3ydl-00EK8L-Vn; Tue, 30 May 2023 14:39:53 +0200
Date: Tue, 30 May 2023 14:39:53 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: phy: fix a signedness bug in genphy_loopback()
Message-ID: <90b1107b-7ea0-4d8f-ad88-ec14fd149582@lunn.ch>
References: <d7bb312e-2428-45f6-b9b3-59ba544e8b94@kili.mountain>
 <20230529215802.70710036@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529215802.70710036@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 09:58:02PM -0700, Jakub Kicinski wrote:
> On Fri, 26 May 2023 14:45:54 +0300 Dan Carpenter wrote:
> > The "val" variable is used to store error codes from phy_read() so
> > it needs to be signed for the error handling to work as expected.
> > 
> > Fixes: 014068dcb5b1 ("net: phy: genphy_loopback: add link speed configuration")
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> 
> Is it going to be obvious to PHY-savvy folks that the val passed to
> phy_read_poll_timeout() must be an int? Is it a very common pattern?
> My outsider intuition is that since regs are 16b, u16 is reasonable,
> and more people may make the same mistake.

It is common to get this wrong in general with PHY drivers. Dan
regularly posts fixes like this soon after a PHY driver patch it
merged. I really wish we could somehow get the compiler to warn when
the result from phy_read() is stored into a unsigned type. It would
save Dan a lot of work.

> Therefore we should try to fix phy_read_poll_timeout() instead to
> use a local variable like it does for __ret.

The problem with that is val is supposed to be available to the
caller. I don't know if it is every actually used, but if it is, using
an internal signed variable and then throwing away the sign bit on
return is going to result in similar bugs.
 
> Weaker version would be to add a compile time check to ensure val 
> is signed (assert(typeof(val)~0ULL < 0) or such?).

I think the BUILD BUG is a better solution, since it catches all
problems. And at developer compile time, rather than at Dan runs his
static checker time.

	Andrew

