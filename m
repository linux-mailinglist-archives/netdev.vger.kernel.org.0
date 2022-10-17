Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E626600566
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 04:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiJQCrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 22:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbiJQCrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 22:47:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2BB32A94;
        Sun, 16 Oct 2022 19:47:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFF1160EDE;
        Mon, 17 Oct 2022 02:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510B6C43470;
        Mon, 17 Oct 2022 02:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665974832;
        bh=ypxAg+O7mH3i+8DecFdqTk3eEFBZSUQm3ax++cEOL0E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tmm11IuPP58CR7OL26Hyokf7S84NTRiNl0pnLEhhqgmr/wGVgFhjomA5tMMyinAOU
         ujpgsaISg6xw6eu/k+lPaV0hH8wYlE6ikX9/1MZyN/mf+EsfVQlwg1+wMd8jBK2tD3
         Rice8JnCXfJRUrFr3zvmgIbc2q3pOXxUSooMhMY06D01DgiOP3xRs5cX0EoMY2DiIc
         siei2OxjIoD+L9LmoNy5pkTVnxhnaJV8OAm0p+5fU8VTPXfAalfdUlYkTKfe1ylCAk
         cFU6PQeNrFwPIuKSYZX2mWwWSS4o5UcABIWOb+AJvT7F3TGpDPYT0DHwzO1BSix1CC
         zu51YLFbLV8hw==
Received: by mail-oo1-f54.google.com with SMTP id s1-20020a4a81c1000000b0047d5e28cdc0so2449187oog.12;
        Sun, 16 Oct 2022 19:47:12 -0700 (PDT)
X-Gm-Message-State: ACrzQf048yk+diViANch2y8ldg0qyZ0SgE/+oKWpe8F+y8ZQDXbRvsXU
        xldBPYE4DEhV+kkRzXvRD68jVHN7BLl0kKKYTlU=
X-Google-Smtp-Source: AMsMyM6aQL75voyyFEOZLq0dR0mBGdU9SmCnFtAbjZZiZP+F39r9LHAElMex+yP1f02AG56czAYtz0wa7y1cVzvPeDw=
X-Received: by 2002:a4a:4f84:0:b0:480:8515:ff8d with SMTP id
 c126-20020a4a4f84000000b004808515ff8dmr3375599oob.31.1665974831458; Sun, 16
 Oct 2022 19:47:11 -0700 (PDT)
MIME-Version: 1.0
References: <20221014030459.3272206-1-guoren@kernel.org> <20221014030459.3272206-3-guoren@kernel.org>
 <1665971921.4555926-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1665971921.4555926-1-xuanzhuo@linux.alibaba.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Mon, 17 Oct 2022 10:46:59 +0800
X-Gmail-Original-Message-ID: <CAJF2gTRYr4XyaHR14_h5tmHpdpnh5j75MeP2V6Au1p3qpABnDQ@mail.gmail.com>
Message-ID: <CAJF2gTRYr4XyaHR14_h5tmHpdpnh5j75MeP2V6Au1p3qpABnDQ@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] net: Fixup virtnet_set_affinity() cause cpumask warning
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>,
        andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, yury.norov@gmail.com,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 17, 2022 at 10:00 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> On Thu, 13 Oct 2022 23:04:59 -0400, guoren@kernel.org wrote:
> > From: Guo Ren <guoren@linux.alibaba.com>
> >
> > Don't pass nr_bits-1 as arg1 for cpumask_next_wrap, which would
> > cause warning now 78e5a3399421 ("cpumask: fix checking valid
> > cpu range").
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x5c/0x80
> > Modules linked in:
> > CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-11659-ge7e38f6cce55-dirty #328
> > Hardware name: riscv-virtio,qemu (DT)
> > epc : cpumask_next_wrap+0x5c/0x80
> >  ra : virtnet_set_affinity+0x1ba/0x1fc
> > epc : ffffffff808992ca ra : ffffffff805d84ca sp : ff60000002327a50
> >  gp : ffffffff81602390 tp : ff600000023a0000 t0 : 5f74656e74726976
> >  t1 : 0000000000000000 t2 : 735f74656e747269 s0 : ff60000002327a90
> >  s1 : 0000000000000003 a0 : 0000000000000003 a1 : ffffffff816051c0
> >  a2 : 0000000000000004 a3 : 0000000000000000 a4 : 0000000000000000
> >  a5 : 0000000000000004 a6 : 0000000000000000 a7 : 0000000000000000
> >  s2 : 0000000000000000 s3 : ffffffff816051c0 s4 : ffffffff8160224c
> >  s5 : 0000000000000004 s6 : 0000000000000004 s7 : 0000000000000000
> >  s8 : 0000000000000003 s9 : ffffffff810aa398 s10: ffffffff80e97d20
> >  s11: 0000000000000004 t3 : ffffffff819acc97 t4 : ffffffff819acc97
> >  t5 : ffffffff819acc98 t6 : ff60000002327878
> > status: 0000000200000120 badaddr: 0000000000000000 cause: 0000000000000003
> > [<ffffffff805d84ca>] virtnet_set_affinity+0x1ba/0x1fc
> > [<ffffffff805da7ac>] virtnet_probe+0x832/0xf1e
> > [<ffffffff804fe61c>] virtio_dev_probe+0x164/0x2de
> > [<ffffffff8054c4c4>] really_probe+0x82/0x224
> > [<ffffffff8054c6c0>] __driver_probe_device+0x5a/0xaa
> > [<ffffffff8054c73c>] driver_probe_device+0x2c/0xb8
> > [<ffffffff8054cd66>] __driver_attach+0x76/0x108
> > [<ffffffff8054a482>] bus_for_each_dev+0x52/0x9a
> > [<ffffffff8054be8c>] driver_attach+0x1a/0x28
> > [<ffffffff8054b996>] bus_add_driver+0x154/0x1c2
> > [<ffffffff8054d592>] driver_register+0x52/0x108
> > [<ffffffff804fe120>] register_virtio_driver+0x1c/0x2c
> > [<ffffffff80a29142>] virtio_net_driver_init+0x7a/0xb0
> > [<ffffffff80002854>] do_one_initcall+0x66/0x2e4
> > [<ffffffff80a01222>] kernel_init_freeable+0x28a/0x304
> > [<ffffffff808cb1be>] kernel_init+0x1e/0x110
> > [<ffffffff80003c4e>] ret_from_exception+0x0/0x10
> > ---[ end trace 0000000000000000 ]---
> >
> > Fixes: 2ca653d607ce ("virtio_net: Stripe queue affinities across cores.")
> > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> > Signed-off-by: Guo Ren <guoren@kernel.org>
> > ---
> >  drivers/net/virtio_net.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 7106932c6f88..e4b56523b2b5 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -2300,6 +2300,8 @@ static void virtnet_set_affinity(struct virtnet_info *vi)
> >
> >               for (j = 0; j < group_size; j++) {
> >                       cpumask_set_cpu(cpu, mask);
> > +                     if (cpu == (nr_cpu_ids - 1))
> > +                             break;
>
> The problem seems to be a problem with cpumask_next_wrap(), I'm not particularly
> sure.
>
> But I think there is something wrong with your modification, which will cause
> subsequent queues to be bound to (nr_cpu_ids - 1).
Yes, it would lose cpu[nr_cpu_ids - 1]. We've moved to reverting the
patch to fix problem:
https://lore.kernel.org/all/20221015130548.3634468-1-guoren@kernel.org/


>
> Thanks.
>
>
> >                       cpu = cpumask_next_wrap(cpu, cpu_online_mask,
> >                                               nr_cpu_ids, false);
> >               }
> > --
> > 2.36.1
> >



-- 
Best Regards
 Guo Ren
