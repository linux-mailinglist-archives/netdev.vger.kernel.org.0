Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCE72934A9
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 08:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403788AbgJTGQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 02:16:41 -0400
Received: from kernel.crashing.org ([76.164.61.194]:42864 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403760AbgJTGQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 02:16:40 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 09K6FhPZ029406
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 20 Oct 2020 01:15:56 -0500
Message-ID: <3ebaa814fe21eb7b4b25a2c9455a34434e0207d6.camel@kernel.crashing.org>
Subject: Re: [PATCH] net: ftgmac100: Fix missing TX-poll issue
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Joel Stanley <joel@jms.id.au>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        BMC-SW <BMC-SW@aspeedtech.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Date:   Tue, 20 Oct 2020 17:15:42 +1100
In-Reply-To: <20201019195723.41a5591f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201019073908.32262-1-dylan_hung@aspeedtech.com>
         <CACPK8Xfn+Gn0PHCfhX-vgLTA6e2=RT+D+fnLF67_1j1iwqh7yg@mail.gmail.com>
         <20201019120040.3152ea0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <1a02e57b6b7d425a19dc59f84091c38ca4edcf47.camel@kernel.crashing.org>
         <20201019195723.41a5591f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-19 at 19:57 -0700, Jakub Kicinski wrote:
> > I suspect the problem is that the HW (and yes this would be a HW bug)
> > doesn't order the CPU -> memory and the CPU -> MMIO path.
> > 
> > What I think happens is that the store to txde0 is potentially still in
> > a buffer somewhere on its way to memory, gets bypassed by the store to
> > MMIO, causing the MAC to try to read the descriptor, and getting the
> > "old" data from memory.
> 
> I see, but in general this sort of a problem should be resolved by
> adding an appropriate memory barrier. And in fact such barrier should
> (these days) be implied by a writel (I'm not 100% clear on why this
> driver uses iowrite, and if it matters).

No, a barrier won't solve this I think.

This is a coherency problem at the fabric/interconnect level. I has to
do with the way they implemented the DMA path from memory to the
ethernet controller using a different "port" of the memory controller
than the one used by the CPU, separately from the MMIO path, with no
proper ordering between those busses. Old school design .... and
broken.

By doing a read back, they probably force the previous write to memory
to get past the point where it will be visible to a subsequent DMA read
by the ethernet controller.

> > It's ... fishy, but that isn't the first time an Aspeed chip has that
> > type of bug (there's a similar one in the USB device controler iirc).

Cheers,
Ben.


