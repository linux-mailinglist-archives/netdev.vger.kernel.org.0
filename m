Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C531D6C2A
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgEQTQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:16:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36148 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgEQTQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 15:16:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nmHCf8WelMUILSz0ftKqp4dywgPe56nqgwOHUvyczNU=; b=hnb8+4je1aHrBVK9uwesMul9JY
        9CAZSrPpSmPQB6jvnhPIrJX9R9U+fEl8VL2kK+4GY1BHfskKtF0tyGOPMd8xL9lvh+Kk1O0Yz6kTt
        9F0b5XFTum1ByGPYl7Vwh+eBzfp2Oh+3JivDQbBcsLz8UXWtwA3AgjdzqMm6e/f+mKUo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jaOm3-002YVi-BD; Sun, 17 May 2020 21:16:35 +0200
Date:   Sun, 17 May 2020 21:16:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     David Miller <davem@davemloft.net>, marex@denx.de,
        netdev@vger.kernel.org, ynezz@true.cz, yuehaibing@huawei.com
Subject: Re: [PATCH V6 00/20] net: ks8851: Unify KS8851 SPI and MLL drivers
Message-ID: <20200517191635.GE606317@lunn.ch>
References: <20200517003354.233373-1-marex@denx.de>
 <20200516.190225.342589110126932388.davem@davemloft.net>
 <20200517071355.ww5xh7fgq7ymztac@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200517071355.ww5xh7fgq7ymztac@wunner.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> However in terms of performance there's a bigger problem:
> 
> Previously ks8851.c (SPI driver) had 8-bit and 32-bit register accessors.
> The present series drops them and performs a 32-bit access as two 16-bit
> accesses and an 8-bit access as one 16-bit access because that's what
> ks8851_mll.c (16-bit parallel bus driver) does.  That has a real,
> measurable performance impact because in the case of 8-bit accesses,
> another 8 bits need to be transferred over the SPI bus, and in the case
> of 32-bit accesses, *two* SPI transfers need to be performed.

How often does this happen on a per packet basis? Packets are
generally a mixture of 50bytes, 576bytes and 1500bytes in size, with
the majority being 576 bytes. Does an extra 8 or 16 bits per packet
really make that much difference? Or is the real problem the overheads
of doing the transaction, not the number of bytes transferred? If so,
maybe the abstractions needs to be slightly higher, not register
access, but basic functionality.

> Nevertheless I was going to repeat the performance measurements on a
> recent kernel but haven't gotten around to that yet because the
> measurements need to be performed with CONFIG_PREEMPT_RT_FULL to
> be reliable (a vanilla kernel is too jittery), so I have to create
> a new branch with RT patches on the test machine, which is fairly
> involved and time consuming.

I assume you will then mainline the changes, so you don't need to do
it again? That is the problem with doing development work on a dead
kernel.

	Andrew
