Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48135414223
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 08:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhIVGtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 02:49:46 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:52059 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232835AbhIVGtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 02:49:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0UpCfwwN_1632293287;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UpCfwwN_1632293287)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 22 Sep 2021 14:48:08 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <1632293267.9421082-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net v2] napi: fix race inside napi_enable
Date:   Wed, 22 Sep 2021 14:47:47 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?utf-8?q?netdev=40vger=2Ekernel=2Eorg=2C?=@vger.kernel.org,
        =?utf-8?q?_linyunsheng=40huawei=2Ecom=2C?=@vger.kernel.org,
        =?utf-8?q?_David_S=2E_Miller_=3Cdavem=40davemloft=2Enet=3E=2C?=@vger.kernel.org,
        =?utf-8?q?_Eric_Dumazet_=3Cedumazet=40google=2Ecom=3E=2C?=@vger.kernel.org,
        =?utf-8?q?_Daniel_Borkmann_=3Cdaniel=40iogearbox=2Enet=3E=2C?=@vger.kernel.org,
        =?utf-8?q?_Antoine_Tenart_=3Catenart=40kernel=2Eorg=3E=2C?=@vger.kernel.org,
        =?utf-8?q?_Alexander_Lobakin_=3Calobakin=40pm=2Eme=3E=2C?=@vger.kernel.org,
        =?utf-8?q?_Wei_Wang_=3Cweiwan=40google=2Ecom=3E=2C?=@vger.kernel.org,
        =?utf-8?q?_Taehee_Yoo_=3Cap420073=40gmail=2Ecom=3E=2C?=@vger.kernel.org,
        =?utf-8?b?IEJqw7ZybiBUw7ZwZWwgPGJqb3JuQGtlcm5lbC5vcmc+LA==?=@vger.kernel.org,
        =?utf-8?q?_Arnd_Bergmann_=3Carnd=40arndb=2Ede=3E=2C?=@vger.kernel.org,
        =?utf-8?q?_Kumar_Kartikeya_Dwivedi_=3Cmemxor=40gmail=2Ecom=3E=2C?=@vger.kernel.org,
        =?utf-8?q?_Neil_Horman_=3Cnhorman=40redhat=2Ecom=3E=2C?=@vger.kernel.org,
        =?utf-8?q?_Dust_Li_=3Cdust=2Eli=40linux=2Ealibaba=2Ecom=3E?=@vger.kernel.org
In-Reply-To: <20210920122024.283fe8b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Sep 2021 12:20:24 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> On Sat, 18 Sep 2021 16:52:32 +0800 Xuan Zhuo wrote:
> > The process will cause napi.state to contain NAPI_STATE_SCHED and
> > not in the poll_list, which will cause napi_disable() to get stuck.
> >
> > The prefix "NAPI_STATE_" is removed in the figure below, and
> > NAPI_STATE_HASHED is ignored in napi.state.
> >
> >                       CPU0       |                   CPU1       | napi.state
> > ===============================================================================
> > napi_disable()                   |                              | SCHED | NPSVC
> > napi_enable()                    |                              |
> > {                                |                              |
> >     smp_mb__before_atomic();     |                              |
> >     clear_bit(SCHED, &n->state); |                              | NPSVC
> >                                  | napi_schedule_prep()         | SCHED | NPSVC
> >                                  | napi_poll()                  |
> >                                  |   napi_complete_done()       |
> >                                  |   {                          |
> >                                  |      if (n->state & (NPSVC | | (1)
> >                                  |               _BUSY_POLL)))  |
> >                                  |           return false;      |
> >                                  |     ................         |
> >                                  |   }                          | SCHED | NPSVC
> >                                  |                              |
> >     clear_bit(NPSVC, &n->state); |                              | SCHED
> > }                                |                              |
> >                                  |                              |
> > napi_schedule_prep()             |                              | SCHED | MISSED (2)
> >
> > (1) Here return direct. Because of NAPI_STATE_NPSVC exists.
> > (2) NAPI_STATE_SCHED exists. So not add napi.poll_list to sd->poll_list
> >
> > Since NAPI_STATE_SCHED already exists and napi is not in the
> > sd->poll_list queue, NAPI_STATE_SCHED cannot be cleared and will always
> > exist.
> >
> > 1. This will cause this queue to no longer receive packets.
> > 2. If you encounter napi_disable under the protection of rtnl_lock, it
> >    will cause the entire rtnl_lock to be locked, affecting the overall
> >    system.
> >
> > This patch uses cmpxchg to implement napi_enable(), which ensures that
> > there will be no race due to the separation of clear two bits.
> >
> > Fixes: 2d8bff12699abc ("netpoll: Close race condition between poll_one_napi and napi_disable")
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
>
> Why don't you just invert the order of clearing the bits:

I think it should be an atomic operation. The original two-step clear itself is
problematic. So from this perspective, it is not just a solution to this
problem.

Thanks.

>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index a796754f75cc..706eca8112c1 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6953,8 +6953,8 @@ void napi_enable(struct napi_struct *n)
>  {
>         BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
>         smp_mb__before_atomic();
> -       clear_bit(NAPI_STATE_SCHED, &n->state);
>         clear_bit(NAPI_STATE_NPSVC, &n->state);
> +       clear_bit(NAPI_STATE_SCHED, &n->state);
>         if (n->dev->threaded && n->thread)
>                 set_bit(NAPI_STATE_THREADED, &n->state);
>  }
>
> That's simpler and symmetric with the disable path.
