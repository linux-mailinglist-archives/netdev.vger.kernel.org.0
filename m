Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D074C26503E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgIJUIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgIJUH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:07:28 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA40C061757;
        Thu, 10 Sep 2020 13:07:28 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id u126so8551653iod.12;
        Thu, 10 Sep 2020 13:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+n2q2ZztI3clFNnXJIqUf1kgbD55yE9LCJ4JDaNwh5w=;
        b=TMLGiCK7xoC3OjhJeTN4bXLZ3/DwauBhD46fYLZhw/8Sc3zNePGnXBJyBch83MT+6Z
         VCHnJrRPUg+w23aWdL8YXv+P5U5UKUJzYFtByZUc8U1PA3n5hnghQDT1a8QRmFKBkBsd
         nOZNiAu1lv+QxeHi6oh71DNYVH4DT2ntOZqO3iaedwhKfpXJofXBrBuorsuS/RDedn7m
         eEbtwltN8gZcc8sNDhIVCwU9tqfkV3cR9+HUR5OX4ciJUGNXv3tLN43TpEvpIuO9CGts
         1brH+Piyqm+Yqs1LADsMth+g/6Z4pL1F0elJcIDAOTZfzIdsJMU985H+KMpx5M9NWhaO
         udKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+n2q2ZztI3clFNnXJIqUf1kgbD55yE9LCJ4JDaNwh5w=;
        b=trCM5rNNeoA0qhxP4bf8OxCUSC5JNSy30u8N26gHf4etSEtGYHETMDXVNjhGtVBqi1
         L4oA4Bt2VJHWhXvpGrjWQyOfhgyzIH1B+Gb2PK4W7fN+IJR52g/qtsX51oFijcWeXNzE
         8BMmskfQRf0LI7/qH3akF0nsEaYCfMcu7Vck1W29TO9ugbdM7c3gB/0K19CZJwgT1r65
         e3aQOmeM8AK4E/4h+o5VSgf7JckbptxNqGC1kzyrZ0QLmgK640UuOV5RehyUACjRGE8L
         t2EWs5ojdLyb/GzE9dO6rPSanVklcnkLqNlSjKt8lV0nIZZu3Cv+x9sKFUiEmhTw/AHK
         b3Tw==
X-Gm-Message-State: AOAM532QkbW+AA8YmiSUA21p0isolKoaeOhluCdi/jF3M0tyZb4MAKty
        /cbbC3IvQNj4YyqZjirxdP4fdFo8culDu00mk+E=
X-Google-Smtp-Source: ABdhPJxyqfO7GYZuw+U2BoTySzf81mjPlXOJtnyVi1Q5h4IteEA9Rjmww15QSTTP9f/+7A9S06s4m/AHqyy0mI5ko2o=
X-Received: by 2002:a05:6602:2d55:: with SMTP id d21mr8831249iow.134.1599768447470;
 Thu, 10 Sep 2020 13:07:27 -0700 (PDT)
MIME-Version: 1.0
References: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 10 Sep 2020 13:07:16 -0700
Message-ID: <CAM_iQpX0_mz+McZdzZ7HFTjBihOKz5E6i4qJQSoFbZ=SZkVh=Q@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@huawei.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 4:06 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> Currently there is concurrent reset and enqueue operation for the
> same lockless qdisc when there is no lock to synchronize the
> q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
> qdisc_deactivate() called by dev_deactivate_queue(), which may cause
> out-of-bounds access for priv->ring[] in hns3 driver if user has
> requested a smaller queue num when __dev_xmit_skb() still enqueue a
> skb with a larger queue_mapping after the corresponding qdisc is
> reset, and call hns3_nic_net_xmit() with that skb later.
>
> Reused the existing synchronize_net() in dev_deactivate_many() to
> make sure skb with larger queue_mapping enqueued to old qdisc(which
> is saved in dev_queue->qdisc_sleeping) will always be reset when
> dev_reset_queue() is called.
>
> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> ChangeLog V2:
>         Reuse existing synchronize_net().
> ---
>  net/sched/sch_generic.c | 48 +++++++++++++++++++++++++++++++++---------------
>  1 file changed, 33 insertions(+), 15 deletions(-)
>
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 265a61d..54c4172 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -1131,24 +1131,10 @@ EXPORT_SYMBOL(dev_activate);
>
>  static void qdisc_deactivate(struct Qdisc *qdisc)
>  {
> -       bool nolock = qdisc->flags & TCQ_F_NOLOCK;
> -
>         if (qdisc->flags & TCQ_F_BUILTIN)
>                 return;
> -       if (test_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state))
> -               return;
> -
> -       if (nolock)
> -               spin_lock_bh(&qdisc->seqlock);
> -       spin_lock_bh(qdisc_lock(qdisc));
>
>         set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
> -
> -       qdisc_reset(qdisc);
> -
> -       spin_unlock_bh(qdisc_lock(qdisc));
> -       if (nolock)
> -               spin_unlock_bh(&qdisc->seqlock);
>  }
>
>  static void dev_deactivate_queue(struct net_device *dev,
> @@ -1165,6 +1151,30 @@ static void dev_deactivate_queue(struct net_device *dev,
>         }
>  }
>
> +static void dev_reset_queue(struct net_device *dev,
> +                           struct netdev_queue *dev_queue,
> +                           void *_unused)
> +{
> +       struct Qdisc *qdisc;
> +       bool nolock;
> +
> +       qdisc = dev_queue->qdisc_sleeping;
> +       if (!qdisc)
> +               return;
> +
> +       nolock = qdisc->flags & TCQ_F_NOLOCK;
> +
> +       if (nolock)
> +               spin_lock_bh(&qdisc->seqlock);
> +       spin_lock_bh(qdisc_lock(qdisc));


I think you do not need this lock for lockless one.

> +
> +       qdisc_reset(qdisc);
> +
> +       spin_unlock_bh(qdisc_lock(qdisc));
> +       if (nolock)
> +               spin_unlock_bh(&qdisc->seqlock);
> +}
> +
>  static bool some_qdisc_is_busy(struct net_device *dev)
>  {
>         unsigned int i;
> @@ -1213,12 +1223,20 @@ void dev_deactivate_many(struct list_head *head)
>                 dev_watchdog_down(dev);
>         }
>
> -       /* Wait for outstanding qdisc-less dev_queue_xmit calls.
> +       /* Wait for outstanding qdisc-less dev_queue_xmit calls or
> +        * outstanding qdisc enqueuing calls.
>          * This is avoided if all devices are in dismantle phase :
>          * Caller will call synchronize_net() for us
>          */
>         synchronize_net();
>
> +       list_for_each_entry(dev, head, close_list) {
> +               netdev_for_each_tx_queue(dev, dev_reset_queue, NULL);
> +
> +               if (dev_ingress_queue(dev))
> +                       dev_reset_queue(dev, dev_ingress_queue(dev), NULL);
> +       }
> +
>         /* Wait for outstanding qdisc_run calls. */
>         list_for_each_entry(dev, head, close_list) {
>                 while (some_qdisc_is_busy(dev)) {

Do you want to reset before waiting for TX action?

I think it is safer to do it after, at least prior to commit 759ae57f1b
we did after.

Thanks.
