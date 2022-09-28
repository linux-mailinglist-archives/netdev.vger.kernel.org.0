Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF445EE19A
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbiI1QR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 12:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiI1QRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:17:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D9DE2350;
        Wed, 28 Sep 2022 09:16:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0A21B820C5;
        Wed, 28 Sep 2022 16:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B756DC433C1;
        Wed, 28 Sep 2022 16:15:56 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="pjMvilDn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664381754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IwoahI4fHWNkt2lI5Zc81O+64RjNHUycxlkXNXn41SM=;
        b=pjMvilDndlU8McUx3afUCrmmuOBkwWVTcaWstTX4EmMoBz2SkKQH074Jld9U2ZezS6IhTI
        V/fXml3O8gtC/cAOO4Ck72uuV/dgeFj3+GDW30iBJ8qwkRf+NS/BdlLNClkiqNB7LIndR2
        ZnxiCyuNh+ZgdnI6x4q1TH6EKufUSAw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id dcf31462 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 28 Sep 2022 16:15:53 +0000 (UTC)
Date:   Wed, 28 Sep 2022 18:15:46 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sherry Yang <sherry.yang@oracle.com>,
        Paul Webb <paul.x.webb@oracle.com>,
        Phillip Goerl <phillip.goerl@oracle.com>,
        Jack Vogel <jack.vogel@oracle.com>,
        Nicky Veitch <nicky.veitch@oracle.com>,
        Colm Harrington <colm.harrington@oracle.com>,
        Ramanan Govindarajan <ramanan.govindarajan@oracle.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Tejun Heo <tj@kernel.org>,
        Sultan Alsawaf <sultan@kerneltoast.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] random: use expired per-cpu timer rather than wq for
 mixing fast pool
Message-ID: <YzRzMsORHpzFydO7@zx2c4.com>
References: <YzKy+bNedt2vu+a1@zx2c4.com>
 <20220927104233.1605507-1-Jason@zx2c4.com>
 <YzQ41ZhCojbyZq6L@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YzQ41ZhCojbyZq6L@linutronix.de>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sebastian,

On Wed, Sep 28, 2022 at 02:06:45PM +0200, Sebastian Andrzej Siewior wrote:
> On 2022-09-27 12:42:33 [+0200], Jason A. Donenfeld wrote:
> …
> > This is an ordinary pattern done all over the kernel. However, Sherry
> > noticed a 10% performance regression in qperf TCP over a 40gbps
> > InfiniBand card. Quoting her message:
> > 
> > > MT27500 Family [ConnectX-3] cards:
> > > Infiniband device 'mlx4_0' port 1 status:
> …
> 
> While looking at the mlx4 driver, it looks like they don't use any NAPI
> handling in their interrupt handler which _might_ be the case that they
> handle more than 1k interrupts a second. I'm still curious to get that
> ACKed from Sherry's side.

Are you sure about that? So far as I can tell drivers/net/ethernet/
mellanox/mlx4 has plenty of napi_schedule/napi_enable and such. Or are
you looking at the infiniband driver instead? I don't really know how
these interact.

But yea, if we've got a driver not using NAPI at 40gbps that's obviously
going to be a problem.

> Jason, from random's point of view: deferring until 1k interrupts + 1sec
> delay is not desired due to low entropy, right?

Definitely || is preferable to &&.

> 
> > Rather than incur the scheduling latency from queue_work_on, we can
> > instead switch to running on the next timer tick, on the same core. This
> > also batches things a bit more -- once per jiffy -- which is okay now
> > that mix_interrupt_randomness() can credit multiple bits at once.
> 
> Hmmm. Do you see higher contention on input_pool.lock? Just asking
> because if more than once CPUs invokes this timer callback aligned, then
> they block on the same lock.

I've been doing various experiments, sending mini patches to Oracle and
having them test this in their rig. So far, it looks like the cost of
the body of the worker itself doesn't matter much, but rather the cost
of the enqueueing function is key. Still investigating though.

It's a bit frustrating, as all I have to work with are results from the
tests, and no perf analysis. It'd be great if an engineer at Oracle was
capable of tackling this interactively, but at the moment it's just me
sending them patches. So we'll see. Getting closer though, albeit very
slowly.

Jason
