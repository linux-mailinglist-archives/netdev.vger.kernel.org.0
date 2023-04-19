Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0FA26E7670
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 11:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbjDSJg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 05:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbjDSJgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 05:36:51 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1623A5E2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 02:36:43 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-7606d443bb2so120456239f.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 02:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681897003; x=1684489003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bT1LQ8ZoEbIfdNKr6BxptJ4k7xPh8e3xW8Om+2l6yiQ=;
        b=hVHETwzFeXPm54fKNPHFNs6/olJlv85aiNYBp52ddBaihiei/6sjGNu+UzAc4MxMqE
         eOqp3VZPF8/EpiV1FQmXYuty6QMSKy0agA28Rm10MJNmPkJaZWw3ZCl9esFHdi2BhN/D
         5noDF8RHFIa4XcqKlou4eKLM6pCnoP5qcnwV9fhAbMVh7yaSgr91mEKy+28qa82y+sNG
         bY06GXEob+U/6VLvp8dCnGzWVYvdxIop5pz9O53K0/qWmQWeCDD4feXFnPz/OreLc3cY
         T6uv8enxvfO1Gr4b9pPcviA6ovpyzQHWMJCHVhI0meHDSbxQjRV+c0NqqDCYvBxhXqon
         Eq0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681897003; x=1684489003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bT1LQ8ZoEbIfdNKr6BxptJ4k7xPh8e3xW8Om+2l6yiQ=;
        b=AlJIHL2tlMtiMUa9x6eY/NdQ9CmYvaOof9AXPIICyIisVcbORW/XMbixm8NErc3+I7
         uWtqvO5+nulTmOiLfWbJbRG0X1IlM/E/RuC6yPAyqGN2xF5iszNXbzep1fLCeG4ARVc9
         X6h53fsEhxVq+4suUmRY2TdvDT5j9M6DMQQ90kt0NEK3fWwl1ydZ71Dpq/47LWHpSM1v
         he0Ep9BiEi5kM8a7eEkmQeVkAW2mdInTf7uhGw02Jmy0omwS+LYMr6lFv6qc4umtvieM
         yrife4/HYkNOnqJ3zubhL32nBsfvbe4HvD3JY4uwVPiopsRHT/3f1IkVrNC1i9XVCGWS
         H2Zw==
X-Gm-Message-State: AAQBX9dxu0nDqSADDO5dMg9yIiVJBvxE8BSKOKMjD2mW6YYMjsbxUB/6
        QJpQOPnl0ttF2bxySOUbSkPq/hE1hnWn92cpma3swA==
X-Google-Smtp-Source: AKy350b3SA87McoT79k3Pz059M8y+dWBWsatI1DmbXsbNTAD3d632TasXCS9FpG2+ELaqODtHpqHKatCPHJVWbVykX0=
X-Received: by 2002:a02:2a0d:0:b0:40f:6396:7ec2 with SMTP id
 w13-20020a022a0d000000b0040f63967ec2mr3037490jaw.6.1681897002815; Wed, 19 Apr
 2023 02:36:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230418165426.1869051-1-mbizon@freebox.fr> <20230419085802.GD44666@unreal>
 <20230419090314.GF44666@unreal>
In-Reply-To: <20230419090314.GF44666@unreal>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 19 Apr 2023 11:36:31 +0200
Message-ID: <CANn89i+qdrgifdqBTc2sZMtHG66B6qojzPRLgWcy-97gDiie+A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dst: fix missing initialization of rt_uncached
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Maxime Bizon <mbizon@freebox.fr>, davem@davemloft.net,
        tglx@linutronix.de, wangyang.guo@intel.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 11:03=E2=80=AFAM Leon Romanovsky <leon@kernel.org> =
wrote:
>
> On Wed, Apr 19, 2023 at 11:58:02AM +0300, Leon Romanovsky wrote:
> > On Tue, Apr 18, 2023 at 06:54:26PM +0200, Maxime Bizon wrote:
> > > xfrm_alloc_dst() followed by xfrm4_dst_destroy(), without a
> > > xfrm4_fill_dst() call in between, causes the following BUG:
> > >
> > >  BUG: spinlock bad magic on CPU#0, fbxhostapd/732
> > >   lock: 0x890b7668, .magic: 890b7668, .owner: <none>/-1, .owner_cpu: =
0
> > >  CPU: 0 PID: 732 Comm: fbxhostapd Not tainted 6.3.0-rc6-next-20230414=
-00613-ge8de66369925-dirty #9
> > >  Hardware name: Marvell Kirkwood (Flattened Device Tree)
> > >   unwind_backtrace from show_stack+0x10/0x14
> > >   show_stack from dump_stack_lvl+0x28/0x30
> > >   dump_stack_lvl from do_raw_spin_lock+0x20/0x80
> > >   do_raw_spin_lock from rt_del_uncached_list+0x30/0x64
> > >   rt_del_uncached_list from xfrm4_dst_destroy+0x3c/0xbc
> > >   xfrm4_dst_destroy from dst_destroy+0x5c/0xb0
> > >   dst_destroy from rcu_process_callbacks+0xc4/0xec
> > >   rcu_process_callbacks from __do_softirq+0xb4/0x22c
> > >   __do_softirq from call_with_stack+0x1c/0x24
> > >   call_with_stack from do_softirq+0x60/0x6c
> > >   do_softirq from __local_bh_enable_ip+0xa0/0xcc
> > >
> > > Patch "net: dst: Prevent false sharing vs. dst_entry:: __refcnt" move=
d
> > > rt_uncached and rt_uncached_list fields from rtable struct to dst
> > > struct, so they are more zeroed by memset_after(xdst, 0, u.dst) in
> > > xfrm_alloc_dst().
> > >
> > > Note that rt_uncached (list_head) was never properly initialized at
> > > alloc time, but xfrm[46]_dst_destroy() is written in such a way that
> > > it was not an issue thanks to the memset:
> > >
> > >     if (xdst->u.rt.dst.rt_uncached_list)
> > >             rt_del_uncached_list(&xdst->u.rt);
> > >
> > > The route code does it the other way around: rt_uncached_list is
> > > assumed to be valid IIF rt_uncached list_head is not empty:
> > >
> > > void rt_del_uncached_list(struct rtable *rt)
> > > {
> > >         if (!list_empty(&rt->dst.rt_uncached)) {
> > >                 struct uncached_list *ul =3D rt->dst.rt_uncached_list=
;
> > >
> > >                 spin_lock_bh(&ul->lock);
> > >                 list_del_init(&rt->dst.rt_uncached);
> > >                 spin_unlock_bh(&ul->lock);
> > >         }
> > > }
> > >
> > > This patch adds mandatory rt_uncached list_head initialization in
> > > generic dst_init(), and adapt xfrm[46]_dst_destroy logic to match the
> > > rest of the code.
> > >
> > > Fixes: d288a162dd1c ("net: dst: Prevent false sharing vs. dst_entry::=
 __refcnt")
> > > Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
> > > ---
> > >  net/core/dst.c          | 1 +
> > >  net/ipv4/xfrm4_policy.c | 4 +---
> > >  net/ipv6/route.c        | 1 -
> > >  net/ipv6/xfrm6_policy.c | 4 +---
> > >  4 files changed, 3 insertions(+), 7 deletions(-)
> >
> > It should go to net. Right now -rc7 is broken.
> >
> > Also the change is not complete, you need to delete INIT_LIST_HEAD(..rt=
_uncached)
> > from rt_dst_alloc and rt_dst_clone too.
>
> It will be nice to give a credit to kbuild.
> https://lore.kernel.org/all/202304162125.18b7bcdd-oliver.sang@intel.com
>

It seems Maxime found the issue before kbuild.

But feel free to add additional tags, sure.
