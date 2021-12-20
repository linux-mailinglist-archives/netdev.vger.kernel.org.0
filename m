Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D80647AAC2
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 14:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhLTN6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 08:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbhLTN6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 08:58:07 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC8CC061574
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 05:58:07 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id d10so29092570ybe.3
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 05:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U7jXEwsKTsY9X8qkgMOosutQp4mPxbmylnXoX/pFG5s=;
        b=JRTJGOl/33KmMTvk+sNPVhOi07ABAXCZeMF1HZH63L5kMwM9L5r8bsVy4fWwDncO0V
         l8/YPZR2LDRAOIvUz/x2bTpFr9n0KgYjiFu8lrf+ZAGEuIBUXMZ2QYLgCO3kpe4KvKOi
         wG+sCivkXd30lo4nIbCeTZOksTShfkPpSzfDSu9ZPxZK9UKmTk6alXJsfr8qBOJ1jtcB
         Tu4J7reQkz16zu6U+5PSMGeUA1BCWwfCxln2iX5W3woI7Csxv/+EUtHXcA2dFlrTO2tC
         pLI5t24d1GWOQJ44rBue7z2RAr6y7OOz2jp+1PuGPmpfG3/U+M97VzGCg4ssy3S2u1FU
         eSuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U7jXEwsKTsY9X8qkgMOosutQp4mPxbmylnXoX/pFG5s=;
        b=VnGqXhd27A0Z+De0Ap3gjpo9Hh46YxyGgjQPe4N2LVpBT9gKFWVfYXAICl3ou9hpty
         bl9niGEofMWULdYxRfDhPsrxcZuFc5iWIEoYpYNUtNcFD8UZa0dSRKrM6NsrJXUH5bYu
         7GjAD0Hb9vHtt1w4xchOHDhFmJ13qCS2c0w3GThO0/31Jwx6lFvCJN1Nwzs3BXscxAqE
         ZNbeSjcyxKdOrR33mVcrCiJ3MYICXQSHexglDIqdAHGPxF8Nxip0J88MNxx16CPoWcOv
         MZaGHPrmaGEbmuV1nDgkckGh2o0VOJ/tg+wVwONKRfHyJgHjaPg9GrahUBGlbqSCuquJ
         ncRg==
X-Gm-Message-State: AOAM5308y7yhwhh/CbvNJEgoaKDrdfM64Lz3nxxPn+gG7Rc2pcVUw6N9
        5g5csHHFOWurl08HVhHuA0O6LfU5sXU9VPmEQRAgxg==
X-Google-Smtp-Source: ABdhPJy0RHgWyNgrP172ueCrvTQ2qzfPy4FeVyZdO99/+iWn3ISwnAOSfkPRhXtdgWwusg8EhVEZA8qc7VPF+WPqORI=
X-Received: by 2002:a05:6902:120e:: with SMTP id s14mr24284643ybu.277.1640008686502;
 Mon, 20 Dec 2021 05:58:06 -0800 (PST)
MIME-Version: 1.0
References: <20211220123839.54664-1-xiangxia.m.yue@gmail.com> <20211220123839.54664-2-xiangxia.m.yue@gmail.com>
In-Reply-To: <20211220123839.54664-2-xiangxia.m.yue@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 20 Dec 2021 05:57:55 -0800
Message-ID: <CANn89iLdP061LMUN-gRA8z4=YgMpbxTt7=3_Ny9ZWfKHTA2cpg@mail.gmail.com>
Subject: Re: [net-next v5 1/2] net: sched: use queue_mapping to pick tx queue
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 4:38 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This patch fixes issue:
> * If we install tc filters with act_skbedit in clsact hook.
>   It doesn't work, because netdev_core_pick_tx() overwrites
>   queue_mapping.
>
>   $ tc filter ... action skbedit queue_mapping 1
>
> And this patch is useful:
> * We can use FQ + EDT to implement efficient policies. Tx queues
>   are picked by xps, ndo_select_queue of netdev driver, or skb hash
>   in netdev_core_pick_tx(). In fact, the netdev driver, and skb
>   hash are _not_ under control. xps uses the CPUs map to select Tx
>   queues, but we can't figure out which task_struct of pod/containter
>   running on this cpu in most case. We can use clsact filters to classify
>   one pod/container traffic to one Tx queue. Why ?
>
>   In containter networking environment, there are two kinds of pod/
>   containter/net-namespace. One kind (e.g. P1, P2), the high throughput
>   is key in these applications. But avoid running out of network resource,
>   the outbound traffic of these pods is limited, using or sharing one
>   dedicated Tx queues assigned HTB/TBF/FQ Qdisc. Other kind of pods
>   (e.g. Pn), the low latency of data access is key. And the traffic is not
>   limited. Pods use or share other dedicated Tx queues assigned FIFO Qdisc.
>   This choice provides two benefits. First, contention on the HTB/FQ Qdisc
>   lock is significantly reduced since fewer CPUs contend for the same queue.
>   More importantly, Qdisc contention can be eliminated completely if each
>   CPU has its own FIFO Qdisc for the second kind of pods.
>
>   There must be a mechanism in place to support classifying traffic based on
>   pods/container to different Tx queues. Note that clsact is outside of Qdisc
>   while Qdisc can run a classifier to select a sub-queue under the lock.
>
>   In general recording the decision in the skb seems a little heavy handed.
>   This patch introduces a per-CPU variable, suggested by Eric.
>
>   The xmit.skip_txqueue flag is firstly cleared in __dev_queue_xmit().
>   - Tx Qdisc may install that skbedit actions, then xmit.skip_txqueue flag
>     is set in qdisc->enqueue() though tx queue has been selected in
>     netdev_tx_queue_mapping() or netdev_core_pick_tx(). That flag is cleared
>     firstly in __dev_queue_xmit(), is useful:
>   - Avoid picking Tx queue with netdev_tx_queue_mapping() in next netdev
>     in such case: eth0 macvlan - eth0.3 vlan - eth0 ixgbe-phy:
>     For example, eth0, macvlan in pod, which root Qdisc install skbedit
>     queue_mapping, send packets to eth0.3, vlan in host. In __dev_queue_xmit() of
>     eth0.3, clear the flag, does not select tx queue according to skb->queue_mapping
>     because there is no filters in clsact or tx Qdisc of this netdev.
>     Same action taked in eth0, ixgbe in Host.
>   - Avoid picking Tx queue for next packet. If we set xmit.skip_txqueue
>     in tx Qdisc (qdisc->enqueue()), the proper way to clear it is clearing it
>     in __dev_queue_xmit when processing next packets.
>
>   +----+      +----+      +----+
>   | P1 |      | P2 |      | Pn |
>   +----+      +----+      +----+
>     |           |           |
>     +-----------+-----------+
>                 |
>                 | clsact/skbedit
>                 |      MQ
>                 v
>     +-----------+-----------+
>     | q0        | q1        | qn
>     v           v           v
>   HTB/FQ      HTB/FQ  ...  FIFO
>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Alexander Lobakin <alobakin@pm.me>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Talal Ahmad <talalahmad@google.com>
> Cc: Kevin Hao <haokexin@gmail.com>
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Cc: Antoine Tenart <atenart@kernel.org>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Eric Dumazet <edumazet@google.com>

I have not suggested this patch, only to not add yet another bit in sk_buff.


> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  include/linux/netdevice.h | 19 +++++++++++++++++++
>  net/core/dev.c            |  7 ++++++-
>  net/sched/act_skbedit.c   |  4 +++-
>  3 files changed, 28 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 8b0bdeb4734e..8d02dafb32ba 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3009,6 +3009,7 @@ struct softnet_data {
>         /* written and read only by owning cpu: */
>         struct {
>                 u16 recursion;
> +               u8  skip_txqueue;
>                 u8  more;
>         } xmit;
>  #ifdef CONFIG_RPS
> @@ -4696,6 +4697,24 @@ static inline netdev_tx_t netdev_start_xmit(struct sk_buff *skb, struct net_devi
>         return rc;
>  }
>
> +static inline void netdev_xmit_skip_txqueue(bool skip)
> +{
> +       __this_cpu_write(softnet_data.xmit.skip_txqueue, skip);
> +}
> +
> +static inline bool netdev_xmit_txqueue_skipped(void)
> +{
> +       return __this_cpu_read(softnet_data.xmit.skip_txqueue);
> +}
> +
> +static inline struct netdev_queue *
> +netdev_tx_queue_mapping(struct net_device *dev, struct sk_buff *skb)
> +{
> +       int qm = skb_get_queue_mapping(skb);
> +
> +       return netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, qm));
> +}
> +
>  int netdev_class_create_file_ns(const struct class_attribute *class_attr,
>                                 const void *ns);
>  void netdev_class_remove_file_ns(const struct class_attribute *class_attr,
> diff --git a/net/core/dev.c b/net/core/dev.c
> index a855e41bbe39..e3f548c54dda 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4048,6 +4048,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>         skb_update_prio(skb);
>
>         qdisc_pkt_len_init(skb);
> +       netdev_xmit_skip_txqueue(false);
>  #ifdef CONFIG_NET_CLS_ACT
>         skb->tc_at_ingress = 0;
>  #endif
> @@ -4073,7 +4074,11 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>         else
>                 skb_dst_force(skb);
>
> -       txq = netdev_core_pick_tx(dev, skb, sb_dev);
> +       if (netdev_xmit_txqueue_skipped())
> +               txq = netdev_tx_queue_mapping(dev, skb);
> +       else
> +               txq = netdev_core_pick_tx(dev, skb, sb_dev);
> +

If we really need to add yet another conditional in fast path, I would
suggest using a static key.

Only hosts where SKBEDIT_F_QUEUE_MAPPING is requested would pay the price.


>         q = rcu_dereference_bh(txq->qdisc);
>
>         trace_net_dev_queue(skb);
> diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
> index ceba11b198bb..48504ed3b280 100644
> --- a/net/sched/act_skbedit.c
> +++ b/net/sched/act_skbedit.c
> @@ -58,8 +58,10 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
>                 }
>         }
>         if (params->flags & SKBEDIT_F_QUEUE_MAPPING &&
> -           skb->dev->real_num_tx_queues > params->queue_mapping)
> +           skb->dev->real_num_tx_queues > params->queue_mapping) {
> +               netdev_xmit_skip_txqueue(true);
>                 skb_set_queue_mapping(skb, params->queue_mapping);
> +       }
>         if (params->flags & SKBEDIT_F_MARK) {
>                 skb->mark &= ~params->mask;
>                 skb->mark |= params->mark & params->mask;
> --
> 2.27.0
>
