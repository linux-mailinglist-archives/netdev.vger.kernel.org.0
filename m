Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D7A26E6AB
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgIQUXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgIQUXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:23:00 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F700C061352;
        Thu, 17 Sep 2020 12:26:41 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id r25so3531796ioj.0;
        Thu, 17 Sep 2020 12:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3TXNtgdcOvPDvfQzJPd027khq7jBZS6AzXkTeEFPjmc=;
        b=GJC1E+ucaun6Z/1lMg+BN0opgf1cMzZNMBWHwpvr2hGN5+AxpOOTSbE02wtfP6kzx2
         sJ42/o5JJRYAWyVDICtMrOm9Wh0rDKrJOg/lNEg++XVgq1/HsBErDQGmgreN8YpsCgb5
         BPDpqrLZL+r2ML46Rs2a8SLARzYB8+jJRNx9eRvUjLDbCIk7Fzk609JXyvKZxMNpsfaF
         yH9Y6KvcgNOd9iD3WJ5c7rJLiCwP2z3srQmYBJkk9mocYUaVOMSG/pDWzoh9R2OjN7Ty
         zUeV9Fm5ZliF1pIhT3IZg4eLtCGtUt5SG/JU3X/PAkEg0e4ZeyG6T873vR2EpD7rgYWR
         8i+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3TXNtgdcOvPDvfQzJPd027khq7jBZS6AzXkTeEFPjmc=;
        b=t785vOGSYAy71ckD1XDaT4gWp6sQTzH3XnzAIBpeG0IqdLpuJRAdnKIyS6LHlQIZLg
         ibnGo99YyysoNQD/zny57URHWQajIL9+OYGGDfVfoeaOoiLiPgOmneZ4qs5tBJLN+ZPA
         7cjTElosyNJZfzashZcbYybET2p022pGjGzaUavQwc8lGTosOauvyFrQ8TjtxRMsKp9P
         wV/a3nh3SXhz+a37o5ya2MJuZ1aXNCapJQw30a25szvvT0/S1Cxzt8Q0qRGcnqm0Rle8
         XRe6i2guPulzBZZlzaFABFRtBVHTmxn0DBIpOw+Jw+t7gIylvmoKmKFoh6neimQz7ZWB
         OUmQ==
X-Gm-Message-State: AOAM531CvuDkOjo6UQK7JZTbWQL/N104JN/3XuTzxlA26IenxC8tMLRx
        FSiPx58UtVcMmO52tRa1T0EUeunWCkHSQhEJF0g=
X-Google-Smtp-Source: ABdhPJw/Jbd3HDp0xzaVaMkmlvLgadxgzy51q09cMLezq4V6ckSYclSWF6cytbQJrTUBXc3XdFNJYbmFXfdPvo9m8yw=
X-Received: by 2002:a05:6602:2e81:: with SMTP id m1mr24472969iow.64.1600370800635;
 Thu, 17 Sep 2020 12:26:40 -0700 (PDT)
MIME-Version: 1.0
References: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpX0_mz+McZdzZ7HFTjBihOKz5E6i4qJQSoFbZ=SZkVh=Q@mail.gmail.com> <830f85b5-ef29-c68e-c982-de20ac880bd9@huawei.com>
In-Reply-To: <830f85b5-ef29-c68e-c982-de20ac880bd9@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 17 Sep 2020 12:26:29 -0700
Message-ID: <CAM_iQpU_tbRNO=Lznz_d6YjXmenYhowEfBoOiJgEmo9x8bEevw@mail.gmail.com>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 1:13 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2020/9/11 4:07, Cong Wang wrote:
> > On Tue, Sep 8, 2020 at 4:06 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>
> >> Currently there is concurrent reset and enqueue operation for the
> >> same lockless qdisc when there is no lock to synchronize the
> >> q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
> >> qdisc_deactivate() called by dev_deactivate_queue(), which may cause
> >> out-of-bounds access for priv->ring[] in hns3 driver if user has
> >> requested a smaller queue num when __dev_xmit_skb() still enqueue a
> >> skb with a larger queue_mapping after the corresponding qdisc is
> >> reset, and call hns3_nic_net_xmit() with that skb later.
> >>
> >> Reused the existing synchronize_net() in dev_deactivate_many() to
> >> make sure skb with larger queue_mapping enqueued to old qdisc(which
> >> is saved in dev_queue->qdisc_sleeping) will always be reset when
> >> dev_reset_queue() is called.
> >>
> >> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
> >> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >> ---
> >> ChangeLog V2:
> >>         Reuse existing synchronize_net().
> >> ---
> >>  net/sched/sch_generic.c | 48 +++++++++++++++++++++++++++++++++---------------
> >>  1 file changed, 33 insertions(+), 15 deletions(-)
> >>
> >> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> >> index 265a61d..54c4172 100644
> >> --- a/net/sched/sch_generic.c
> >> +++ b/net/sched/sch_generic.c
> >> @@ -1131,24 +1131,10 @@ EXPORT_SYMBOL(dev_activate);
> >>
> >>  static void qdisc_deactivate(struct Qdisc *qdisc)
> >>  {
> >> -       bool nolock = qdisc->flags & TCQ_F_NOLOCK;
> >> -
> >>         if (qdisc->flags & TCQ_F_BUILTIN)
> >>                 return;
> >> -       if (test_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state))
> >> -               return;
> >> -
> >> -       if (nolock)
> >> -               spin_lock_bh(&qdisc->seqlock);
> >> -       spin_lock_bh(qdisc_lock(qdisc));
> >>
> >>         set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
> >> -
> >> -       qdisc_reset(qdisc);
> >> -
> >> -       spin_unlock_bh(qdisc_lock(qdisc));
> >> -       if (nolock)
> >> -               spin_unlock_bh(&qdisc->seqlock);
> >>  }
> >>
> >>  static void dev_deactivate_queue(struct net_device *dev,
> >> @@ -1165,6 +1151,30 @@ static void dev_deactivate_queue(struct net_device *dev,
> >>         }
> >>  }
> >>
> >> +static void dev_reset_queue(struct net_device *dev,
> >> +                           struct netdev_queue *dev_queue,
> >> +                           void *_unused)
> >> +{
> >> +       struct Qdisc *qdisc;
> >> +       bool nolock;
> >> +
> >> +       qdisc = dev_queue->qdisc_sleeping;
> >> +       if (!qdisc)
> >> +               return;
> >> +
> >> +       nolock = qdisc->flags & TCQ_F_NOLOCK;
> >> +
> >> +       if (nolock)
> >> +               spin_lock_bh(&qdisc->seqlock);
> >> +       spin_lock_bh(qdisc_lock(qdisc));
> >
> >
> > I think you do not need this lock for lockless one.
>
> It seems so.
> Maybe another patch to remove qdisc_lock(qdisc) for lockless
> qdisc?

Yeah, but not sure if we still want this lockless qdisc any more,
it brings more troubles than gains.

>
>
> >
> >> +
> >> +       qdisc_reset(qdisc);
> >> +
> >> +       spin_unlock_bh(qdisc_lock(qdisc));
> >> +       if (nolock)
> >> +               spin_unlock_bh(&qdisc->seqlock);
> >> +}
> >> +
> >>  static bool some_qdisc_is_busy(struct net_device *dev)
> >>  {
> >>         unsigned int i;
> >> @@ -1213,12 +1223,20 @@ void dev_deactivate_many(struct list_head *head)
> >>                 dev_watchdog_down(dev);
> >>         }
> >>
> >> -       /* Wait for outstanding qdisc-less dev_queue_xmit calls.
> >> +       /* Wait for outstanding qdisc-less dev_queue_xmit calls or
> >> +        * outstanding qdisc enqueuing calls.
> >>          * This is avoided if all devices are in dismantle phase :
> >>          * Caller will call synchronize_net() for us
> >>          */
> >>         synchronize_net();
> >>
> >> +       list_for_each_entry(dev, head, close_list) {
> >> +               netdev_for_each_tx_queue(dev, dev_reset_queue, NULL);
> >> +
> >> +               if (dev_ingress_queue(dev))
> >> +                       dev_reset_queue(dev, dev_ingress_queue(dev), NULL);
> >> +       }
> >> +
> >>         /* Wait for outstanding qdisc_run calls. */
> >>         list_for_each_entry(dev, head, close_list) {
> >>                 while (some_qdisc_is_busy(dev)) {
> >
> > Do you want to reset before waiting for TX action?
> >
> > I think it is safer to do it after, at least prior to commit 759ae57f1b
> > we did after.
>
> The reference to the txq->qdisc is always protected by RCU, so the synchronize_net()
> should be enought to ensure there is no skb enqueued to the old qdisc that is saved
> in the dev_queue->qdisc_sleeping, because __dev_queue_xmit can only see the new qdisc
> after synchronize_net(), which is noop_qdisc, and noop_qdisc will make sure any skb
> enqueued to it will be dropped and freed, right?

Hmm? In net_tx_action(), we do not hold RCU read lock, and we do not
reference qdisc via txq->qdisc but via sd->output_queue.


>
> If we do any additional reset that is not related to qdisc in dev_reset_queue(), we
> can move it after some_qdisc_is_busy() checking.

I am not suggesting to do an additional reset, I am suggesting to move
your reset after the busy waiting.

Thanks.
