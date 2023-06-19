Return-Path: <netdev+bounces-11969-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1182A73586B
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:20:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 511B52810EB
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C818F10970;
	Mon, 19 Jun 2023 13:20:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC778BE5
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 13:20:54 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5689010C;
	Mon, 19 Jun 2023 06:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=bsP10RTNE6zA+kNWt9nN6vN4Pg4+LkQlDuEbC+rbmHE=; b=lAxGGuG6G4YTVjqwwy66E8JrJX
	uXL+fQXNpYDxOWp+Kiltowi9x81sMeEcSzrKIeNAXnrRGaMtAsi3zHGLWNViy7eC4fpYnVu+ylQcj
	KCME/nVo0+TCcH4bYQw6cB3zyRN2eqKhigs215ESAUr4dugGdcl8IKCCkRm8m2hqxkBA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qBEoI-00GubJ-T6; Mon, 19 Jun 2023 15:20:46 +0200
Date: Mon, 19 Jun 2023 15:20:46 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: greg@kroah.com, alice@ryhl.io, kuba@kernel.org, netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org, aliceryhl@google.com,
	miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Message-ID: <15046eb0-e0bb-4ab3-8d94-0cf9f37acfc2@lunn.ch>
References: <c1b23f21-d161-6241-26fb-7a2cbc4c059c@ryhl.io>
 <20230619.175003.876496330266041709.ubuntu@gmail.com>
 <2023061940-rotting-frequency-765f@gregkh>
 <20230619.200559.1405325531450768221.ubuntu@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619.200559.1405325531450768221.ubuntu@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > Report the error back up the chain and handle it properly, that's the
> > correct thing to do.
> 
> I see. Then netdev_warn() should be used instead.
> 
> Is it possible to handle the case where a device driver wrongly
> doesn't consume a skb object?

The skb is then likely leaked. After a while, you will consume all the
memory, the OOM handler will start killing processes, until eventually
the machine dies.

This is unlikely to happen on the main path, it would be a rather dumb
developer who messed up something so obvious. Leaks are more likely to
happen in the error paths, and that tends to happen less often, and so
the machine is going to live for longer.

But we are talking about different things here. Jakub wanted to ensure
that when the driver does drop an skb, it includes a reason code
indicating why it dropped it. If the driver tries to drop the frame
without providing a reason, we want to know the code path, so it can
be fixed. Even better if this can be done at compile time.

Not releasing the frame at all is a different problem, and probably
not easy to fix. There is some degree of handover of ownership of the
skb. When asked to transmit it, the driver should eventually release
the skb. However, that is often sometime in the future after the
hardware has confirmed it has DMAed a copy of the frame into its own
memory. On the receive side, in the normal path the driver could
allocate an skb, setup the DMA to copy the frame into it, and then
wait for an indication the DMA is complete. Then it passes it to the
network stack, at which point the network stack becomes the owner.

But there are no simple scope rules to detect an skb has been leaked.

    Andrew

