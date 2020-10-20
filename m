Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB4C29415F
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 19:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395412AbgJTRYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 13:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395393AbgJTRYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 13:24:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 432CA22249;
        Tue, 20 Oct 2020 17:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603214658;
        bh=DLOV96T1YAajXeFM85FxC+biug7p9KERA9RpgNy4x2s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kO017b/Y9Z0AmqHgHYhKHLA7oiilB8TKq0BuxXhnKqTDXHTVV9zbakmLO0ZlAsoj4
         Jl7JJ+drc5DUcbWyrGyDqZ4moB6gMhXZOtzvK1pzVX3h8GYTw7Q9GYk7PpSTAK6seP
         15YPqupbXFS1HU7mu/y6I4524h19vfwpGwX6pd90=
Date:   Tue, 20 Oct 2020 10:24:15 -0700
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
        linux-arch@vger.kernel.org, paulmck@kernel.org
Subject: Re: [PATCH] net: ftgmac100: Fix missing TX-poll issue
Message-ID: <20201020102415.52b51895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3ebaa814fe21eb7b4b25a2c9455a34434e0207d6.camel@kernel.crashing.org>
References: <20201019073908.32262-1-dylan_hung@aspeedtech.com>
        <CACPK8Xfn+Gn0PHCfhX-vgLTA6e2=RT+D+fnLF67_1j1iwqh7yg@mail.gmail.com>
        <20201019120040.3152ea0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1a02e57b6b7d425a19dc59f84091c38ca4edcf47.camel@kernel.crashing.org>
        <20201019195723.41a5591f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3ebaa814fe21eb7b4b25a2c9455a34434e0207d6.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 17:15:42 +1100 Benjamin Herrenschmidt wrote:
> On Mon, 2020-10-19 at 19:57 -0700, Jakub Kicinski wrote:
> > > I suspect the problem is that the HW (and yes this would be a HW bug)
> > > doesn't order the CPU -> memory and the CPU -> MMIO path.
> > > 
> > > What I think happens is that the store to txde0 is potentially still in
> > > a buffer somewhere on its way to memory, gets bypassed by the store to
> > > MMIO, causing the MAC to try to read the descriptor, and getting the
> > > "old" data from memory.  
> > 
> > I see, but in general this sort of a problem should be resolved by
> > adding an appropriate memory barrier. And in fact such barrier should
> > (these days) be implied by a writel (I'm not 100% clear on why this
> > driver uses iowrite, and if it matters).  
> 
> No, a barrier won't solve this I think.
> 
> This is a coherency problem at the fabric/interconnect level. I has to
> do with the way they implemented the DMA path from memory to the
> ethernet controller using a different "port" of the memory controller
> than the one used by the CPU, separately from the MMIO path, with no
> proper ordering between those busses. Old school design .... and
> broken.
> 
> By doing a read back, they probably force the previous write to memory
> to get past the point where it will be visible to a subsequent DMA read
> by the ethernet controller.

Thanks for the explanation. How wonderful :/

It'd still be highly, highly preferable if the platform was conforming
to the Linux memory model. IO successors (iowrite32 / writel) must
ensure previous DRAM writes had completed. For performance sensitive
ops, which don't require ordering we have writel_relaxed etc.

I assume the DRAM controller queue is a straight FIFO and we don't have
to worry about hitting the same address, so how about we add a read
of some known uncached address in iowrite32 / writel?
