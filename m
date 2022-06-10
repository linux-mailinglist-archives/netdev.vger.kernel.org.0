Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891EB545F73
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 10:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243754AbiFJIkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 04:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347270AbiFJIkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 04:40:21 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E601140D7
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 01:40:20 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-3137316bb69so70604337b3.10
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 01:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y9js5siYkXmTlCcqhnBttnSyxADQBz416pvWYIEpQLc=;
        b=MWoSw9aN1k9ACFkxYohmtn6bcP8F/dnn2OkswCnt3jJJOGEEy3u2qjj3YR+DG5NUZ2
         SlVaNtds1yBoe2csJdMH1A2luuJOQ6bGushZRQuEpa357R5UwpahmQdjvhTIaVo0TICK
         HPE1VN2x0+HbMlDA5UrdYbiYS/IFDyncENyuZ+g/xziIpZE9HY3iTOkSpcbAi5hr6Yml
         ZqL/cTZtyR3uJnypqKvu6OY812v8ibuEWo7nO8joVBnoyzZutYTuD5jX6KPT2arjGDif
         aiLu5SFWq7WEpV2GHBUYEk03u1NMoHJgCh0SpA+taNN9pRCYcussMln4izassYh6nfG4
         etVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y9js5siYkXmTlCcqhnBttnSyxADQBz416pvWYIEpQLc=;
        b=IIkwGxYUmmNCdRKboIHslJzgdYGkYy9p/vKjyCOVn5S/U9v6g2+N+QwA5xMZEIqVi3
         7Sa8Mn2DVjgFu09SuUrHO6sv6pltDAVC9K2fSkDbYMQVMDgnDJssTyVToyrTuAdGrnAU
         1Z9AznmJ2rHOi3GwIrtF1wqiGnqRq4UaM6UMjpqxYFsxVSDWuFTutcRAQZdVYXW6U9UK
         ldDpJaGJ9ZxVt/y2MQ1FYe1o4Z3i6fBpETEa5VssT+VfUfUXDh9p+wH08FSaTUFM8Cyk
         9MUI45dGH2axBGjguhyo/vxTVmTVlKvWmpJlTKSR7ytXyf1forzFMnn7ER7VIj542DPU
         oVeQ==
X-Gm-Message-State: AOAM533tvPZiV2370SFdo99+XlxzBvx03OTpJ5lgfQy353aQNsDibCCA
        T0zHafnoo1GJM6zPbGKRWgcjZeiztv/BaYCVBigBzA==
X-Google-Smtp-Source: ABdhPJzTeAzIrk04WGbwRnb/1rU3YjD+kBesukZkSgAMmy++D6UL2koc33Qw5/mwbF66PlaSovKzbvwOVn5rXLM6iJs=
X-Received: by 2002:a81:4909:0:b0:30c:34d5:9f2c with SMTP id
 w9-20020a814909000000b0030c34d59f2cmr47467546ywa.489.1654850418987; Fri, 10
 Jun 2022 01:40:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220610021445.2441579-1-jianhao_xu@smail.nju.edu.cn>
 <3f460707-e267-e749-07fc-c44604cd5713@iogearbox.net> <tencent_29981C021E6150B064C7DBA3@qq.com>
In-Reply-To: <tencent_29981C021E6150B064C7DBA3@qq.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Jun 2022 01:40:06 -0700
Message-ID: <CANn89iKHfi=kQY1FC=07COJfVX4ROTnGkM_1uKvOfPfdhqt4Ow@mail.gmail.com>
Subject: Re: [PATCH] net: sched: fix potential null pointer deref
To:     Jianhao Xu <jianhao_xu@smail.nju.edu.cn>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, jhs <jhs@mojatatu.com>,
        "xiyou.wangcong" <xiyou.wangcong@gmail.com>,
        jiri <jiri@resnulli.us>, davem <davem@davemloft.net>,
        kuba <kuba@kernel.org>, pabeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
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

On Fri, Jun 10, 2022 at 1:09 AM Jianhao Xu <jianhao_xu@smail.nju.edu.cn> wr=
ote:
>
> Hi,
>
> TBH, We do not have a reproducer. This is found by our static analysis to=
ol. We can not see any clue of the context here of mq_queue_get() to ensure=
 it never returns NULL.
>


All netdev devices have their dev->_tx allocated in netif_alloc_netdev_queu=
es()

There is absolutely no way MQ qdisc could be attached to a device that
has failed netif_alloc_netdev_queues() step.



> I would appreciate it if you could tell me why when you found out it was =
our false positive. It will be helpful for us to improve our tool.


Please do not send patches before you can provide a detailed
explanation of a real bug.

If you need help, post instead a [RFC] with a message explaining how
far you went into your analysis.

A patch should be sent only once you are absolutely sure that there is
a real bug to fix.

Thank you.


>
> Thanks.
> ------------------ Original ------------------
> From:  "Daniel Borkmann"<daniel@iogearbox.net>;
> Date:  Fri, Jun 10, 2022 09:14 AM
> To:  "Jianhao Xu"<jianhao_xu@smail.nju.edu.cn>; "jhs"<jhs@mojatatu.com>; =
"xiyou.wangcong"<xiyou.wangcong@gmail.com>; "jiri"<jiri@resnulli.us>; "dave=
m"<davem@davemloft.net>; "edumazet"<edumazet@google.com>; "kuba"<kuba@kerne=
l.org>; "pabeni"<pabeni@redhat.com>;
> Cc:  "netdev"<netdev@vger.kernel.org>; "linux-kernel"<linux-kernel@vger.k=
ernel.org>;
> Subject:  Re: [PATCH] net: sched: fix potential null pointer deref
>
> Hi Jianhao,
>
> On 6/10/22 4:14 AM, Jianhao Xu wrote:
> > mq_queue_get() may return NULL, a check is needed to avoid using
> > the NULL pointer.
> >
> > Signed-off-by: Jianhao Xu <jianhao_xu@smail.nju.edu.cn>
>
> Do you have a reproducer where this is triggered?
>
> > ---
> >   net/sched/sch_mq.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> >
> > diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
> > index 83d2e54bf303..9aca4ca82947 100644
> > --- a/net/sched/sch_mq.c
> > +++ b/net/sched/sch_mq.c
> > @@ -201,6 +201,8 @@ static int mq_graft(struct Qdisc *sch, unsigned lon=
g cl, struct Qdisc *new,
> >   static struct Qdisc *mq_leaf(struct Qdisc *sch, unsigned long cl)
> >   {
> >  struct netdev_queue *dev_queue =3D mq_queue_get(sch, cl);
> > + if (!dev_queue)
> > +return NULL;
> >
> >  return dev_queue->qdisc_sleeping;
> >   }
> > @@ -218,6 +220,8 @@ static int mq_dump_class(struct Qdisc *sch, unsigne=
d long cl,
> >   struct sk_buff *skb, struct tcmsg *tcm)
> >   {
> >  struct netdev_queue *dev_queue =3D mq_queue_get(sch, cl);
> > + if (!dev_queue)
> > +return -1;
> >
> >  tcm->tcm_parent =3D TC_H_ROOT;
> >  tcm->tcm_handle |=3D TC_H_MIN(cl);
> > @@ -229,6 +233,8 @@ static int mq_dump_class_stats(struct Qdisc *sch, u=
nsigned long cl,
> >         struct gnet_dump *d)
> >   {
> >  struct netdev_queue *dev_queue =3D mq_queue_get(sch, cl);
> > + if (!dev_queue)
> > +return -1;
> >
> >  sch =3D dev_queue->qdisc_sleeping;
> >  if (gnet_stats_copy_basic(d, sch->cpu_bstats, &sch->bstats, true) < 0 =
||
> >
>
