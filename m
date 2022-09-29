Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB8B5EF751
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbiI2OTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbiI2OS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:18:58 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD52A17A5FE;
        Thu, 29 Sep 2022 07:18:57 -0700 (PDT)
Date:   Thu, 29 Sep 2022 16:18:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1664461136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8zj0w2Vgi49HfUr/IZs8+gOkOwPoTluB/6siD/jB8/k=;
        b=lfO4rmZLV2Wi5LX2ZcCR9f5RLRCxPy1zaUwTPlXdl+hg+mYBx3MrzZLWWobgHsD98CGv7H
        MOEw6ZantZNpc+vThhTT+nyFqPlB0DCu9b9Qx3egJo8RsLKYBXY0GCZd3Sxgbl6KcBkSKr
        Rt4A+5+QyDooU3e+RDugj1cILWg/HJ00pe6KScvCm7vxv1JIRFS2k4nbTx7JuTQxrzhpPC
        HAVFBvnUByyRAtDrbSMqfJNzD3gX1s3EhsvnafIVYwEjatH3jttJTG4E2dY4A5Ii+Av9lz
        eGn9Fj1RNNgXMVJlvoXKmA2Bhva2+QAfDRfKhbE/KHwx861t34y4Ed718n0how==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1664461136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8zj0w2Vgi49HfUr/IZs8+gOkOwPoTluB/6siD/jB8/k=;
        b=0eZRfOeH9xxXlSrlwKeTWege4p8EQ4DpWyt/GbShjyrjyv77pQsbMUZqaIeMR3iHPK21dn
        yht3X5Ve6H3MudCQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
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
Message-ID: <YzWpT/NfDzhnsiTI@linutronix.de>
References: <YzKy+bNedt2vu+a1@zx2c4.com>
 <20220927104233.1605507-1-Jason@zx2c4.com>
 <YzQ41ZhCojbyZq6L@linutronix.de>
 <YzRzMsORHpzFydO7@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YzRzMsORHpzFydO7@zx2c4.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-28 18:15:46 [+0200], Jason A. Donenfeld wrote:
> Hi Sebastian,
Hi Jason,

> On Wed, Sep 28, 2022 at 02:06:45PM +0200, Sebastian Andrzej Siewior wrote:
> > On 2022-09-27 12:42:33 [+0200], Jason A. Donenfeld wrote:
> > =E2=80=A6
> > > This is an ordinary pattern done all over the kernel. However, Sherry
> > > noticed a 10% performance regression in qperf TCP over a 40gbps
> > > InfiniBand card. Quoting her message:
> > >=20
> > > > MT27500 Family [ConnectX-3] cards:
> > > > Infiniband device 'mlx4_0' port 1 status:
> > =E2=80=A6
> >=20
> > While looking at the mlx4 driver, it looks like they don't use any NAPI
> > handling in their interrupt handler which _might_ be the case that they
> > handle more than 1k interrupts a second. I'm still curious to get that
> > ACKed from Sherry's side.
>=20
> Are you sure about that? So far as I can tell drivers/net/ethernet/
> mellanox/mlx4 has plenty of napi_schedule/napi_enable and such. Or are
> you looking at the infiniband driver instead? I don't really know how
> these interact.

I've been looking at mlx4_msi_x_interrupt() and it appears that it
iterates over a ring buffer. I guess that mlx4_cq_completion() will
invoke mlx4_en_rx_irq() which schedules NAPI.

> But yea, if we've got a driver not using NAPI at 40gbps that's obviously
> going to be a problem.

So I'm wondering if we get 1 worker a second which kills the performance
or if we get more than 1k interrupts in less than second resulting in
more wakeups within a second..

> > Jason, from random's point of view: deferring until 1k interrupts + 1sec
> > delay is not desired due to low entropy, right?
>=20
> Definitely || is preferable to &&.
>=20
> >=20
> > > Rather than incur the scheduling latency from queue_work_on, we can
> > > instead switch to running on the next timer tick, on the same core. T=
his
> > > also batches things a bit more -- once per jiffy -- which is okay now
> > > that mix_interrupt_randomness() can credit multiple bits at once.
> >=20
> > Hmmm. Do you see higher contention on input_pool.lock? Just asking
> > because if more than once CPUs invokes this timer callback aligned, then
> > they block on the same lock.
>=20
> I've been doing various experiments, sending mini patches to Oracle and
> having them test this in their rig. So far, it looks like the cost of
> the body of the worker itself doesn't matter much, but rather the cost
> of the enqueueing function is key. Still investigating though.
>=20
> It's a bit frustrating, as all I have to work with are results from the
> tests, and no perf analysis. It'd be great if an engineer at Oracle was
> capable of tackling this interactively, but at the moment it's just me
> sending them patches. So we'll see. Getting closer though, albeit very
> slowly.

Oh boy. Okay.

> Jason

Sebastian
