Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D5B295955
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 09:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508692AbgJVHin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 03:38:43 -0400
Received: from kernel.crashing.org ([76.164.61.194]:45132 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2508681AbgJVHin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 03:38:43 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 09M7bwWk027578
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 22 Oct 2020 02:38:04 -0500
Message-ID: <ef0d576f4eba266b60586b93c6ace79ed3cc7096.camel@kernel.crashing.org>
Subject: Re: [PATCH] net: ftgmac100: Ensure tx descriptor updates are visible
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     David Laight <David.Laight@aculab.com>,
        Joel Stanley <joel@jms.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>
Date:   Thu, 22 Oct 2020 18:37:58 +1100
In-Reply-To: <dca2ce4487024eba9398426af86c761d@AcuMS.aculab.com>
References: <20201020220639.130696-1-joel@jms.id.au>
         <86480db3977cfbf6750209c34a28c8f042be55fb.camel@kernel.crashing.org>
         <dca2ce4487024eba9398426af86c761d@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-21 at 08:18 +0000, David Laight wrote:
> From: Benjamin Herrenschmidt
> > Sent: 21 October 2020 01:00
> > 
> > On Wed, 2020-10-21 at 08:36 +1030, Joel Stanley wrote:
> > > We must ensure the tx descriptor updates are visible before updating
> > > the tx pointer.
> > > 
> > > This resolves the tx hangs observed on the 2600 when running iperf:
> > 
> > To clarify the comment here. This doesn't ensure they are visible to
> > the hardware but to other CPUs. This is the ordering vs start_xmit and
> > tx_complete.
> 
> You need two barriers.
> 1) after making the data buffers available before transferring
> the descriptor ownership to the device.
> 2) after transferring the ownership before 'kicking' the mac engine.
> 
> The first is needed because the mac engine can poll the descriptors
> at any time (eg on completing the previous transmit).
> This stops it transmitting garbage.
> 
> The second makes sure it finds the descriptor you've just set.
> This stops delays before sending the packet.
> (But it will get sent later.)

The above is unrelated to this patch. This isn't about fixing any
device <-> CPU ordering or interaction but purely about ensuring proper
ordering between start_xmit and tx packet cleanup. IE. We are looking
at two different issues with this driver.

> For (2) dma_wmb() is the documented barrier.
> 
> I'm not sure which barrier you need for (1).
> smp_wmb() would be right if the reader were another cpu,
> but it is (at most) a compile barrier on UP kernels.
> So you need something stronger than smp_wmb().

There should already be sufficient barriers for that in the driver
(except for the HW bug mentioned earlier).

> On a TSO system (which yours probably is) a compile barrier
> is probably sufficient, but if memory writes can get re-ordered
> it needs to be a stronger barrier - but not necessarily as strong
> as dma_wmb().
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

