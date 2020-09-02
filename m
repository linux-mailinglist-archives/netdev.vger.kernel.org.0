Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27D525A4AE
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 06:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgIBElO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 00:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgIBElN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 00:41:13 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA10AC061244;
        Tue,  1 Sep 2020 21:41:13 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id p13so3861390ils.3;
        Tue, 01 Sep 2020 21:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NoUssg8K6LT6ANgsFFz5OTHDN1mgwkLG8uhxUiPJzAM=;
        b=uy0LQ06Y1uqJ7i7iq6BXHfEjLJffm1JjMuYaIbUUmnWgY3ST+iXQuMyHjT1ifBe8ws
         jJFMgdcX+lIoMws9xGe4YJ3y8xd/LzVW3djf/+foTY/yrEV8z4ILAvF/L92p1C3ZApUM
         AJ7nVA2CemlgGrwyVweXAZtQybOVO6PMlOgKfvKZiRp/7S91ql532i6lt5yyl2YWvUD9
         xf3CNFd3/genH2+K6Zionh7pgx4I2dXge3l/0V29nMlUTanwK9kuWAK0qccJUk7sj0xB
         Ex2OdcBtqJWm8mBRPJxmRFXaPCnuqgD6aYdHO7PKAogGZB3JjlLLnmeKX4qJHMvF1Mep
         DKgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NoUssg8K6LT6ANgsFFz5OTHDN1mgwkLG8uhxUiPJzAM=;
        b=sCDq3AqwcdDrQSvQnI5QhF93L7dS1EgVXU5xusn/1udqbUmnc0Z1sb9YLBWLrbeA7A
         1OLeK0DCejSJz9j2gf3zQVjfcP03OnBlLM/+c/13j+biL+P7eJUFBFU1nL8vX7wFh/cd
         V41kwGppIAihCHqu+9oK+QLGLNWUWBUDsaZemTPs90Qm44dKWxS2PCfulyKE05h1I7xD
         4CPljysr9S9DXpaGYZC8O1ewdS6Ey3aAp4I7EIXtMLKIf8s/44e5vEWyMQvtRPtEPusS
         GjpsEQdA2bQ39Mcw+PsksOpJfLiWdD2wcJK2zKNppW3tlen3uWqgiiO5Czdg+d1Znyl0
         9Elg==
X-Gm-Message-State: AOAM5315zKUbQ/QRgYlhU3Vcp/b0vVP9DVBbIlJkzynX3WXSWl5bALIW
        shO2YBy2AQNfWwoAbikArOTrt+zwy4X+VZ5aWwI=
X-Google-Smtp-Source: ABdhPJxST+MY6Y9TedWIDBJx3cuSZVDAhg+e0wqaIPk1rEmHxTEDF+qO6JlYOOxOr5BsdRafZw47r4JzDJuZx0gPCHg=
X-Received: by 2002:a92:9145:: with SMTP id t66mr2181458ild.305.1599021672869;
 Tue, 01 Sep 2020 21:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <1598921718-79505-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpVtb3Cks-LacZ865=C8r-_8ek1cy=n3SxELYGxvNgkPtw@mail.gmail.com> <511bcb5c-b089-ab4e-4424-a83c6e718bfa@huawei.com>
In-Reply-To: <511bcb5c-b089-ab4e-4424-a83c6e718bfa@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 1 Sep 2020 21:41:01 -0700
Message-ID: <CAM_iQpW1c1TOKWLxm4uGvCUzK0mKKeDg1Y+3dGAC04pZXeCXcw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 6:42 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2020/9/2 2:24, Cong Wang wrote:
> > On Mon, Aug 31, 2020 at 5:59 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>
> >> Currently there is concurrent reset and enqueue operation for the
> >> same lockless qdisc when there is no lock to synchronize the
> >> q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
> >> qdisc_deactivate() called by dev_deactivate_queue(), which may cause
> >> out-of-bounds access for priv->ring[] in hns3 driver if user has
> >> requested a smaller queue num when __dev_xmit_skb() still enqueue a
> >> skb with a larger queue_mapping after the corresponding qdisc is
> >> reset, and call hns3_nic_net_xmit() with that skb later.
> >
> > Can you be more specific here? Which call path requests a smaller
> > tx queue num? If you mean netif_set_real_num_tx_queues(), clearly
> > we already have a synchronize_net() there.
>
> When the netdevice is in active state, the synchronize_net() seems to
> do the correct work, as below:
>
> CPU 0:                                       CPU1:
> __dev_queue_xmit()                       netif_set_real_num_tx_queues()
> rcu_read_lock_bh();
> netdev_core_pick_tx(dev, skb, sb_dev);
>         .
>         .                               dev->real_num_tx_queues = txq;
>         .                                       .
>         .                                       .
>         .                               synchronize_net();
>         .                                       .
> q->enqueue()                                    .
>         .                                       .
> rcu_read_unlock_bh()                            .
>                                         qdisc_reset_all_tx_gt
>
>

Right.


> but dev->real_num_tx_queues is not RCU-protected, maybe that is a problem
> too.
>
> The problem we hit is as below:
> In hns3_set_channels(), hns3_reset_notify(h, HNAE3_DOWN_CLIENT) is called
> to deactive the netdevice when user requested a smaller queue num, and
> txq->qdisc is already changed to noop_qdisc when calling
> netif_set_real_num_tx_queues(), so the synchronize_net() in the function
> netif_set_real_num_tx_queues() does not help here.

How could qdisc still be running after deactivating the device?


>
> >
> >>
> >> Avoid the above concurrent op by calling synchronize_rcu_tasks()
> >> after assigning new qdisc to dev_queue->qdisc and before calling
> >> qdisc_deactivate() to make sure skb with larger queue_mapping
> >> enqueued to old qdisc will always be reset when qdisc_deactivate()
> >> is called.
> >
> > Like Eric said, it is not nice to call such a blocking function when
> > we have a large number of TX queues. Possibly we just need to
> > add a synchronize_net() as in netif_set_real_num_tx_queues(),
> > if it is missing.
>
> As above, the synchronize_net() in netif_set_real_num_tx_queues() seems
> to work when netdevice is in active state, but does not work when in
> deactive.

Please explain why deactivated device still has qdisc running?

At least before commit 379349e9bc3b4, we always test deactivate
bit before enqueueing. Are you complaining about that commit?
That commit is indeed suspicious, at least it does not precisely revert
commit ba27b4cdaaa66561aaedb21 as it claims.


>
> And we do not want skb left in the old qdisc when netdevice is deactived,
> right?

Yes, and more importantly, qdisc should not be running after deactivation.

Thanks.
