Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A9C293365
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 04:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390933AbgJTC50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 22:57:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729181AbgJTC50 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 22:57:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 208DF222E9;
        Tue, 20 Oct 2020 02:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603162645;
        bh=qwSN9blogEZVLec+dCJS+sFeJavpar63X669kQYp8rY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hhwqmsA1cgEsFROQBL4byLwoaqAmG2QBWW0ddmocqhrtuk7Rr8x6JMM9GM4fq1HPa
         uzuzs1UkoYq/1DXJb5TuShJqcK5svitoMD+7JZ//UQfv2N59j4olJJIN6NdaZ7Sg2V
         UoBNpABhyynRdhwZqKJIsWIgo6z7AhEo6VDDiYpA=
Date:   Mon, 19 Oct 2020 19:57:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Joel Stanley <joel@jms.id.au>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        BMC-SW <BMC-SW@aspeedtech.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] net: ftgmac100: Fix missing TX-poll issue
Message-ID: <20201019195723.41a5591f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1a02e57b6b7d425a19dc59f84091c38ca4edcf47.camel@kernel.crashing.org>
References: <20201019073908.32262-1-dylan_hung@aspeedtech.com>
        <CACPK8Xfn+Gn0PHCfhX-vgLTA6e2=RT+D+fnLF67_1j1iwqh7yg@mail.gmail.com>
        <20201019120040.3152ea0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1a02e57b6b7d425a19dc59f84091c38ca4edcf47.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 10:23:41 +1100 Benjamin Herrenschmidt wrote:
> On Mon, 2020-10-19 at 12:00 -0700, Jakub Kicinski wrote:
> > On Mon, 19 Oct 2020 08:57:03 +0000 Joel Stanley wrote:  
> > > > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c
> > > > b/drivers/net/ethernet/faraday/ftgmac100.c
> > > > index 00024dd41147..9a99a87f29f3 100644
> > > > --- a/drivers/net/ethernet/faraday/ftgmac100.c
> > > > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> > > > @@ -804,7 +804,8 @@ static netdev_tx_t
> > > > ftgmac100_hard_start_xmit(struct sk_buff *skb,
> > > >          * before setting the OWN bit on the first descriptor.
> > > >          */
> > > >         dma_wmb();
> > > > -       first->txdes0 = cpu_to_le32(f_ctl_stat);
> > > > +       WRITE_ONCE(first->txdes0, cpu_to_le32(f_ctl_stat));
> > > > +       READ_ONCE(first->txdes0);    
> > > 
> > > I understand what you're trying to do here, but I'm not sure that
> > > this
> > > is the correct way to go about it.
> > > 
> > > It does cause the compiler to produce a store and then a load.  
> > 
> > +1 @first is system memory from dma_alloc_coherent(), right?
> > 
> > You shouldn't have to do this. Is coherent DMA memory broken 
> > on your platform?  
> 
> I suspect the problem is that the HW (and yes this would be a HW bug)
> doesn't order the CPU -> memory and the CPU -> MMIO path.
> 
> What I think happens is that the store to txde0 is potentially still in
> a buffer somewhere on its way to memory, gets bypassed by the store to
> MMIO, causing the MAC to try to read the descriptor, and getting the
> "old" data from memory.

I see, but in general this sort of a problem should be resolved by
adding an appropriate memory barrier. And in fact such barrier should
(these days) be implied by a writel (I'm not 100% clear on why this
driver uses iowrite, and if it matters).

> It's ... fishy, but that isn't the first time an Aspeed chip has that
> type of bug (there's a similar one in the USB device controler iirc).

Argh.
