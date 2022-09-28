Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281B65EDC49
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 14:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbiI1MGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 08:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiI1MGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 08:06:49 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6E473914;
        Wed, 28 Sep 2022 05:06:48 -0700 (PDT)
Date:   Wed, 28 Sep 2022 14:06:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1664366807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s6lQAgh7enonjhj6PjJx0/AsS46rxYHX/hQJLChO0RM=;
        b=C+rectd6LxzA8wzjvdfl0Rh1UXgpt9QW/NxZ2mspzhqQV1PQNziRV63YtvNgq0NOVsKgF/
        55tMkeDZ0CqFfR6gCuuOno5B/YpfufR5ii2qAZ+82QX0mbHcwhj2NxTcyQkgyvExz7QlAK
        TpGKI6iZiEJAqiKTvV4zo5MWjxn7A35MhCYPwQNdgFJet/oqcjGUMadbMQVLPo9HrblqsV
        GXif2jAcMYFryITVPZWU4McuEBhXcSk73PV5OjD4xn+QWarODTKyrRY+RrpBXqUk49wu5A
        JqYD+lTffSde193nkfjvqMkh80QSJx56Ze2iDrPD2ku9IX430WZBKV6gn28tOg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1664366807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s6lQAgh7enonjhj6PjJx0/AsS46rxYHX/hQJLChO0RM=;
        b=u+d08PNpLEfTCXvR58fhvt2JoqlEDDDVEZ4C9DDFFRADPfI7lx+JSXJS5oFWFjyapmGigx
        DnIYnc/GD6WWBsAw==
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
Message-ID: <YzQ41ZhCojbyZq6L@linutronix.de>
References: <YzKy+bNedt2vu+a1@zx2c4.com>
 <20220927104233.1605507-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220927104233.1605507-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-27 12:42:33 [+0200], Jason A. Donenfeld wrote:
=E2=80=A6
> This is an ordinary pattern done all over the kernel. However, Sherry
> noticed a 10% performance regression in qperf TCP over a 40gbps
> InfiniBand card. Quoting her message:
>=20
> > MT27500 Family [ConnectX-3] cards:
> > Infiniband device 'mlx4_0' port 1 status:
=E2=80=A6

While looking at the mlx4 driver, it looks like they don't use any NAPI
handling in their interrupt handler which _might_ be the case that they
handle more than 1k interrupts a second. I'm still curious to get that
ACKed from Sherry's side.

Jason, from random's point of view: deferring until 1k interrupts + 1sec
delay is not desired due to low entropy, right?

> Rather than incur the scheduling latency from queue_work_on, we can
> instead switch to running on the next timer tick, on the same core. This
> also batches things a bit more -- once per jiffy -- which is okay now
> that mix_interrupt_randomness() can credit multiple bits at once.

Hmmm. Do you see higher contention on input_pool.lock? Just asking
because if more than once CPUs invokes this timer callback aligned, then
they block on the same lock.

Sebastian
