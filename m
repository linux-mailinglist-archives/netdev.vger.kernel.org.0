Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7C7600582
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 04:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiJQC61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 22:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbiJQC60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 22:58:26 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21C848E85;
        Sun, 16 Oct 2022 19:58:24 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0VSGBvZK_1665975500;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VSGBvZK_1665975500)
          by smtp.aliyun-inc.com;
          Mon, 17 Oct 2022 10:58:21 +0800
Message-ID: <1665975482.5061383-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH V2 2/2] net: Fixup virtnet_set_affinity() cause cpumask warning
Date:   Mon, 17 Oct 2022 10:58:02 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Guo Ren <guoren@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>,
        andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, yury.norov@gmail.com,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com
References: <20221014030459.3272206-1-guoren@kernel.org>
 <20221014030459.3272206-3-guoren@kernel.org>
 <1665971921.4555926-1-xuanzhuo@linux.alibaba.com>
 <CAJF2gTRYr4XyaHR14_h5tmHpdpnh5j75MeP2V6Au1p3qpABnDQ@mail.gmail.com>
In-Reply-To: <CAJF2gTRYr4XyaHR14_h5tmHpdpnh5j75MeP2V6Au1p3qpABnDQ@mail.gmail.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Oct 2022 10:46:59 +0800, Guo Ren <guoren@kernel.org> wrote:
> On Mon, Oct 17, 2022 at 10:00 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> >
> > On Thu, 13 Oct 2022 23:04:59 -0400, guoren@kernel.org wrote:
> > > From: Guo Ren <guoren@linux.alibaba.com>
> > >
> > > Don't pass nr_bits-1 as arg1 for cpumask_next_wrap, which would
> > > cause warning now 78e5a3399421 ("cpumask: fix checking valid
> > > cpu range").
> > >
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x5c/0x80
> > > Modules linked in:
> > > CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-11659-ge7e38f6cce55-dirty #328
> > > Hardware name: riscv-virtio,qemu (DT)
> > > epc : cpumask_next_wrap+0x5c/0x80
> > >  ra : virtnet_set_affinity+0x1ba/0x1fc
> > > epc : ffffffff808992ca ra : ffffffff805d84ca sp : ff60000002327a50
> > >  gp : ffffffff81602390 tp : ff600000023a0000 t0 : 5f74656e74726976
> > >  t1 : 0000000000000000 t2 : 735f74656e747269 s0 : ff60000002327a90
> > >  s1 : 0000000000000003 a0 : 0000000000000003 a1 : ffffffff816051c0
> > >  a2 : 0000000000000004 a3 : 0000000000000000 a4 : 0000000000000000
> > >  a5 : 0000000000000004 a6 : 0000000000000000 a7 : 0000000000000000
> > >  s2 : 0000000000000000 s3 : ffffffff816051c0 s4 : ffffffff8160224c
> > >  s5 : 0000000000000004 s6 : 0000000000000004 s7 : 0000000000000000
> > >  s8 : 0000000000000003 s9 : ffffffff810aa398 s10: ffffffff80e97d20
> > >  s11: 0000000000000004 t3 : ffffffff819acc97 t4 : ffffffff819acc97
> > >  t5 : ffffffff819acc98 t6 : ff60000002327878
> > > status: 0000000200000120 badaddr: 0000000000000000 cause: 0000000000000003
> > > [<ffffffff805d84ca>] virtnet_set_affinity+0x1ba/0x1fc
> > > [<ffffffff805da7ac>] virtnet_probe+0x832/0xf1e
> > > [<ffffffff804fe61c>] virtio_dev_probe+0x164/0x2de
> > > [<ffffffff8054c4c4>] really_probe+0x82/0x224
> > > [<ffffffff8054c6c0>] __driver_probe_device+0x5a/0xaa
> > > [<ffffffff8054c73c>] driver_probe_device+0x2c/0xb8
> > > [<ffffffff8054cd66>] __driver_attach+0x76/0x108
> > > [<ffffffff8054a482>] bus_for_each_dev+0x52/0x9a
> > > [<ffffffff8054be8c>] driver_attach+0x1a/0x28
> > > [<ffffffff8054b996>] bus_add_driver+0x154/0x1c2
> > > [<ffffffff8054d592>] driver_register+0x52/0x108
> > > [<ffffffff804fe120>] register_virtio_driver+0x1c/0x2c
> > > [<ffffffff80a29142>] virtio_net_driver_init+0x7a/0xb0
> > > [<ffffffff80002854>] do_one_initcall+0x66/0x2e4
> > > [<ffffffff80a01222>] kernel_init_freeable+0x28a/0x304
> > > [<ffffffff808cb1be>] kernel_init+0x1e/0x110
> > > [<ffffffff80003c4e>] ret_from_exception+0x0/0x10
> > > ---[ end trace 0000000000000000 ]---
> > >
> > > Fixes: 2ca653d607ce ("virtio_net: Stripe queue affinities across cores.")
> > > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> > > Signed-off-by: Guo Ren <guoren@kernel.org>
> > > ---
> > >  drivers/net/virtio_net.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 7106932c6f88..e4b56523b2b5 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -2300,6 +2300,8 @@ static void virtnet_set_affinity(struct virtnet_info *vi)
> > >
> > >               for (j = 0; j < group_size; j++) {
> > >                       cpumask_set_cpu(cpu, mask);
> > > +                     if (cpu == (nr_cpu_ids - 1))
> > > +                             break;
> >
> > The problem seems to be a problem with cpumask_next_wrap(), I'm not particularly
> > sure.
> >
> > But I think there is something wrong with your modification, which will cause
> > subsequent queues to be bound to (nr_cpu_ids - 1).
> Yes, it would lose cpu[nr_cpu_ids - 1]. We've moved to reverting the
> patch to fix problem:
> https://lore.kernel.org/all/20221015130548.3634468-1-guoren@kernel.org/

Great!!

Thanks.


>
>
> >
> > Thanks.
> >
> >
> > >                       cpu = cpumask_next_wrap(cpu, cpu_online_mask,
> > >                                               nr_cpu_ids, false);
> > >               }
> > > --
> > > 2.36.1
> > >
>
>
>
> --
> Best Regards
>  Guo Ren
