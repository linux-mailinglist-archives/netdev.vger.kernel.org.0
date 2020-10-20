Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0329B2944E8
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 00:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410322AbgJTWG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 18:06:28 -0400
Received: from kernel.crashing.org ([76.164.61.194]:43502 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391762AbgJTWG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 18:06:28 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 09KM5Zhv006771
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 20 Oct 2020 17:05:44 -0500
Message-ID: <7b44608bed9eccad80457cbfdfcca9043aae56f2.camel@kernel.crashing.org>
Subject: Re: [PATCH] net: ftgmac100: Fix missing TX-poll issue
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     David Laight <David.Laight@ACULAB.COM>,
        "'Dylan Hung'" <dylan_hung@aspeedtech.com>,
        Jakub Kicinski <kuba@kernel.org>, Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Date:   Wed, 21 Oct 2020 09:05:34 +1100
In-Reply-To: <f75555e09d47476a871669ffe017c4f8@AcuMS.aculab.com>
References: <20201019073908.32262-1-dylan_hung@aspeedtech.com>
         <CACPK8Xfn+Gn0PHCfhX-vgLTA6e2=RT+D+fnLF67_1j1iwqh7yg@mail.gmail.com>
         <20201019120040.3152ea0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <PS1PR0601MB1849166CBF6D1678E6E1210C9C1F0@PS1PR0601MB1849.apcprd06.prod.outlook.com>
         <f75555e09d47476a871669ffe017c4f8@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-10-20 at 13:15 +0000, David Laight wrote:
> That rather depends where the data is 'stuck'.
> 
> An old sparc cpu would flush the cpu store buffer before the read.
> But a modern x86 cpu will satisfy the read from the store buffer
> for cached data.
> 
> If the write is 'posted' on a PCI(e) bus then the read can't overtake it.
> But that is a memory access so shouldn't be to a PCI(e) address.
> 
> Shouldn't dma_wb() actually force your 'cpu to dram' queue be flushed?
> In which case you need one after writing the ring descriptor and
> before the poke of the mac engine.
> 
> The barrier before the descriptor write only needs to guarantee
> ordering of the writes - it can probably be a lighter barrier?
> 
> It might be that your dma_wmb() needs to do a write+read of
> an uncached DRAM location in order to empty the cpu to dram queue.

This is a specific bug with how a specific IP block is hooked up in
those SOCs, I wouldn't bloat the global dma_wmb for that. The read back
in the driver with appropriate comment should be enough.

Cheers,
Ben.


