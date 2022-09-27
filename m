Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558785EBD28
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbiI0IXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiI0IXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:23:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AB6ABF04;
        Tue, 27 Sep 2022 01:23:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EA8EB81991;
        Tue, 27 Sep 2022 08:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1A7C433C1;
        Tue, 27 Sep 2022 08:23:26 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="J3cVgI6h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664267005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wzK6JDZ0KR+H20bRs0fFogH6oAfl1qEY+rsD3GGd+ik=;
        b=J3cVgI6hkgm1dUqwQwW1UevcbFzHP34I2SDjq+5cTd9yDqFKn9/ASp/lgCR3eaTUU4XE3E
        786ATIk/u33X0q+UQ/FgUhEbWWMFi4lNzYewWrNzPdxNn0ngvWdKW1IAHXTlQrsMrv/eN0
        ZEYBeH3Ze9emuMWU/w3hkiIZTK6xorc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5b5765fe (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 27 Sep 2022 08:23:24 +0000 (UTC)
Date:   Tue, 27 Sep 2022 10:23:21 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sherry Yang <sherry.yang@oracle.com>,
        Paul Webb <paul.x.webb@oracle.com>,
        Phillip Goerl <phillip.goerl@oracle.com>,
        Jack Vogel <jack.vogel@oracle.com>,
        Nicky Veitch <nicky.veitch@oracle.com>,
        Colm Harrington <colm.harrington@oracle.com>,
        Ramanan Govindarajan <ramanan.govindarajan@oracle.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tejun Heo <tj@kernel.org>,
        Sultan Alsawaf <sultan@kerneltoast.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] random: use immediate per-cpu timer rather than
 workqueue for mixing fast pool
Message-ID: <YzKy+bNedt2vu+a1@zx2c4.com>
References: <20220922165528.3679479-1-Jason@zx2c4.com>
 <20220926220457.1517120-1-Jason@zx2c4.com>
 <62ae29f10d65401ab79e9bdb6af1576a@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62ae29f10d65401ab79e9bdb6af1576a@AcuMS.aculab.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 07:41:52AM +0000, David Laight wrote:
> From: Jason A. Donenfeld
> > Sent: 26 September 2022 23:05
> > 
> > Previously, the fast pool was dumped into the main pool peroidically in
> > the fast pool's hard IRQ handler. This worked fine and there weren't
> > problems with it, until RT came around. Since RT converts spinlocks into
> > sleeping locks, problems cropped up. Rather than switching to raw
> > spinlocks, the RT developers preferred we make the transformation from
> > originally doing:
> > 
> >     do_some_stuff()
> >     spin_lock()
> >     do_some_other_stuff()
> >     spin_unlock()
> > 
> > to doing:
> > 
> >     do_some_stuff()
> >     queue_work_on(some_other_stuff_worker)
> > 
> > This is an ordinary pattern done all over the kernel. However, Sherry
> > noticed a 10% performance regression in qperf TCP over a 40gbps
> > InfiniBand card. Quoting her message:
> > 
> > > MT27500 Family [ConnectX-3] cards:
> > > Infiniband device 'mlx4_0' port 1 status:
> > > default gid: fe80:0000:0000:0000:0010:e000:0178:9eb1
> > > base lid: 0x6
> > > sm lid: 0x1
> > > state: 4: ACTIVE
> > > phys state: 5: LinkUp
> > > rate: 40 Gb/sec (4X QDR)
> > > link_layer: InfiniBand
> > >
> > > Cards are configured with IP addresses on private subnet for IPoIB
> > > performance testing.
> > > Regression identified in this bug is in TCP latency in this stack as reported
> > > by qperf tcp_lat metric:
> > >
> > > We have one system listen as a qperf server:
> > > [root@yourQperfServer ~]# qperf
> > >
> > > Have the other system connect to qperf server as a client (in this
> > > case, it’s X7 server with Mellanox card):
> > > [root@yourQperfClient ~]# numactl -m0 -N0 qperf 20.20.20.101 -v -uu -ub --time 60 --wait_server 20 -
> > oo msg_size:4K:1024K:*2 tcp_lat
> > 
> > Rather than incur the scheduling latency from queue_work_on, we can
> > instead switch to running on the next timer tick, on the same core,
> > deferrably so. This also batches things a bit more -- once per jiffy --
> > which is probably okay now that mix_interrupt_randomness() can credit
> > multiple bits at once. It still puts a bit of pressure on fast_mix(),
> > but hopefully that's acceptable.
> 
> I though NOHZ systems didn't take a timer interrupt every 'jiffy'.
> If that is true what actually happens?

The TIMER_DEFERRABLE part of this patch is a mistake; I'm going to make
that 0. However, since expires==jiffies, there's no difference. It's
still undesirable though.

Jason
