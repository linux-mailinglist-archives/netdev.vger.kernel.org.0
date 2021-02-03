Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC5430E0C3
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 18:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhBCRVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 12:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhBCRVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 12:21:14 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7192C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 09:20:34 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id u20so55068iot.9
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 09:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ByWvC592A/LGQzBJgc4gQ75I04Snr7UIFTVUqbDDCk=;
        b=GIlefd1CBt3UodA74ISRtG5dtbj15w1wCV9FgArEKM2jUnsFjWcQI8zs94Djz97d9B
         JtPsAiN8FvEW7nW4wDwaFxPAD7l23aIHjRxKuD2TolkVv8b1AXOwUm3ivFKoVh6j2HbT
         4dS0nDOzyddE0WqR9qFUK/hOZWpObwr7Vq4DxAj2rQtCoLoAwYSympH7H1QsKBGnQtFJ
         ggUqRGRC+bEnwh0V62xGb2KXWt0AtsGQjnZ0Ot9sSkY6oEUoX+boDCdbSH/XGp4/D8sH
         vnYQ0famb+sVNSOUeoJU1gTSkI8ilv1aDPsPZ89f0J+Q/bLvhZ03J9QuTHDpqOxjd1+c
         M4WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ByWvC592A/LGQzBJgc4gQ75I04Snr7UIFTVUqbDDCk=;
        b=mvsVgLZE6kXynAivGtniaCXtipuAPLR3ABZnKT2xbpTGCBZx+whDMtZSjvrlneDUI9
         iR0A7agBolcFo6g68TEA57uAfJ+N/paO5md4ggAdpILnRmfGlkJqPbHanS4DbcrpYi5B
         Kz1HTRyJMkgMObtKJ5WXXtkq/VxZV2mAstbT7qukQ/47EuE/Bxtg2NdqLCuhL7F0mLPo
         meiGWH4sRI4OBFqbxNELjo8uW9Eg9kZmB3YXCN1K3CQQ93Kk3GBX5Kj8EmHkLmrxn8vF
         ebysW7c4OlsI/vYihmwy/fUQtEqvb0tsNgajvR04hS1fnCw2pWQnDuzvtJlGNpcVLq0I
         8X+g==
X-Gm-Message-State: AOAM532fyVheQVk8DHkHuvLqKlYLWIOPOu2KesEzJixz20ZPoEZ4mnJD
        L2meF4XxYDcNOTCHB/940c/vsBCNYlszbvNaf4U=
X-Google-Smtp-Source: ABdhPJx1Lgwqt7HhCtbYN6UMJGlXCUYRIYeQjG7YilY0tX/EwevJTG7dmSUTlV40Mz8l7EVlIOHPlt7nQF88tuNETSo=
X-Received: by 2002:a6b:d007:: with SMTP id x7mr3348843ioa.88.1612372834134;
 Wed, 03 Feb 2021 09:20:34 -0800 (PST)
MIME-Version: 1.0
References: <20210129181812.256216-1-weiwan@google.com> <20210129181812.256216-3-weiwan@google.com>
In-Reply-To: <20210129181812.256216-3-weiwan@google.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 3 Feb 2021 09:20:23 -0800
Message-ID: <CAKgT0Uc882yDj5Vq-Nt_6U-jz3zWFUWJv0zuaGukb1z7Fy=ASQ@mail.gmail.com>
Subject: Re: [PATCH net-next v9 2/3] net: implement threaded-able napi poll
 loop support
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 10:22 AM Wei Wang <weiwan@google.com> wrote:
>
> This patch allows running each napi poll loop inside its own
> kernel thread.
> The kthread is created during netif_napi_add() if dev->threaded
> is set. And threaded mode is enabled in napi_enable(). We will
> provide a way to set dev->threaded and enable threaded mode
> without a device up/down in the following patch.
>
> Once that threaded mode is enabled and the kthread is
> started, napi_schedule() will wake-up such thread instead
> of scheduling the softirq.
>
> The threaded poll loop behaves quite likely the net_rx_action,
> but it does not have to manipulate local irqs and uses
> an explicit scheduling point based on netdev_budget.
>
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Co-developed-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Wei Wang <weiwan@google.com>
> ---
>  include/linux/netdevice.h |  21 +++----
>  net/core/dev.c            | 117 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 124 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 02dcef4d66e2..f1e9fe9017ac 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -347,6 +347,7 @@ struct napi_struct {
>         struct list_head        dev_list;
>         struct hlist_node       napi_hash_node;
>         unsigned int            napi_id;
> +       struct task_struct      *thread;
>  };
>
>  enum {
> @@ -358,6 +359,7 @@ enum {
>         NAPI_STATE_NO_BUSY_POLL,        /* Do not add in napi_hash, no busy polling */
>         NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() owns this NAPI */
>         NAPI_STATE_PREFER_BUSY_POLL,    /* prefer busy-polling over softirq processing*/
> +       NAPI_STATE_THREADED,            /* The poll is performed inside its own thread*/
>  };
>
>  enum {
> @@ -369,6 +371,7 @@ enum {
>         NAPIF_STATE_NO_BUSY_POLL        = BIT(NAPI_STATE_NO_BUSY_POLL),
>         NAPIF_STATE_IN_BUSY_POLL        = BIT(NAPI_STATE_IN_BUSY_POLL),
>         NAPIF_STATE_PREFER_BUSY_POLL    = BIT(NAPI_STATE_PREFER_BUSY_POLL),
> +       NAPIF_STATE_THREADED            = BIT(NAPI_STATE_THREADED),
>  };
>
>  enum gro_result {
> @@ -503,20 +506,7 @@ static inline bool napi_complete(struct napi_struct *n)
>   */
>  void napi_disable(struct napi_struct *n);
>
> -/**
> - *     napi_enable - enable NAPI scheduling
> - *     @n: NAPI context
> - *
> - * Resume NAPI from being scheduled on this context.
> - * Must be paired with napi_disable.
> - */
> -static inline void napi_enable(struct napi_struct *n)
> -{
> -       BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
> -       smp_mb__before_atomic();
> -       clear_bit(NAPI_STATE_SCHED, &n->state);
> -       clear_bit(NAPI_STATE_NPSVC, &n->state);
> -}
> +void napi_enable(struct napi_struct *n);
>
>  /**
>   *     napi_synchronize - wait until NAPI is not running
> @@ -1826,6 +1816,8 @@ enum netdev_priv_flags {
>   *
>   *     @wol_enabled:   Wake-on-LAN is enabled
>   *
> + *     @threaded:      napi threaded mode is enabled
> + *
>   *     @net_notifier_list:     List of per-net netdev notifier block
>   *                             that follow this device when it is moved
>   *                             to another network namespace.
> @@ -2143,6 +2135,7 @@ struct net_device {
>         struct lock_class_key   *qdisc_running_key;
>         bool                    proto_down;
>         unsigned                wol_enabled:1;
> +       unsigned                threaded:1;
>
>         struct list_head        net_notifier_list;
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 7d23bff03864..743dd69fba19 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -91,6 +91,7 @@
>  #include <linux/etherdevice.h>
>  #include <linux/ethtool.h>
>  #include <linux/skbuff.h>
> +#include <linux/kthread.h>
>  #include <linux/bpf.h>
>  #include <linux/bpf_trace.h>
>  #include <net/net_namespace.h>
> @@ -1493,6 +1494,37 @@ void netdev_notify_peers(struct net_device *dev)
>  }
>  EXPORT_SYMBOL(netdev_notify_peers);
>
> +static int napi_threaded_poll(void *data);
> +
> +static int napi_kthread_create(struct napi_struct *n)
> +{
> +       int err = 0;
> +
> +       /* Create and wake up the kthread once to put it in
> +        * TASK_INTERRUPTIBLE mode to avoid the blocked task
> +        * warning and work with loadavg.
> +        */
> +       n->thread = kthread_run(napi_threaded_poll, n, "napi/%s-%d",
> +                               n->dev->name, n->napi_id);
> +       if (IS_ERR(n->thread)) {
> +               err = PTR_ERR(n->thread);
> +               pr_err("kthread_run failed with err %d\n", err);
> +               n->thread = NULL;
> +       }
> +
> +       return err;
> +}
> +
> +static void napi_kthread_stop(struct napi_struct *n)
> +{
> +       if (!n->thread)
> +               return;
> +
> +       kthread_stop(n->thread);
> +       clear_bit(NAPI_STATE_THREADED, &n->state);
> +       n->thread = NULL;
> +}
> +

So I think the napi_kthread_stop should also be split into two parts
and distributed between the napi_disable and netif_napi_del functions.

We should probably be clearing the NAPI_STATE_THREADED bit in
napi_disable, and freeing the thread in netif_napi_del.

>  static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
>  {
>         const struct net_device_ops *ops = dev->netdev_ops;
> @@ -4252,6 +4284,21 @@ int gro_normal_batch __read_mostly = 8;
>  static inline void ____napi_schedule(struct softnet_data *sd,
>                                      struct napi_struct *napi)
>  {
> +       struct task_struct *thread;
> +
> +       if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
> +               /* Paired with smp_mb__before_atomic() in
> +                * napi_enable(). Use READ_ONCE() to guarantee
> +                * a complete read on napi->thread. Only call
> +                * wake_up_process() when it's not NULL.
> +                */
> +               thread = READ_ONCE(napi->thread);
> +               if (thread) {
> +                       wake_up_process(thread);
> +                       return;
> +               }
> +       }
> +
>         list_add_tail(&napi->poll_list, &sd->poll_list);
>         __raise_softirq_irqoff(NET_RX_SOFTIRQ);
>  }
> @@ -6720,6 +6767,12 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>         set_bit(NAPI_STATE_NPSVC, &napi->state);
>         list_add_rcu(&napi->dev_list, &dev->napi_list);
>         napi_hash_add(napi);
> +       /* Create kthread for this napi if dev->threaded is set.
> +        * Clear dev->threaded if kthread creation failed so that
> +        * threaded mode will not be enabled in napi_enable().
> +        */
> +       if (dev->threaded && napi_kthread_create(napi))
> +               dev->threaded = 0;
>  }
>  EXPORT_SYMBOL(netif_napi_add);
>
> @@ -6734,12 +6787,31 @@ void napi_disable(struct napi_struct *n)
>                 msleep(1);
>
>         hrtimer_cancel(&n->timer);
> +       napi_kthread_stop(n);
>

So I think there may be an issue here since we had netif_napi_add
create the thread, but you are freeing it in napi_kthread_stop if I am
not mistaken. That is why I suggested making this only a clear_bit
call like the ones below to just clear the threaded flag from the
state.

>         clear_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state);
>         clear_bit(NAPI_STATE_DISABLE, &n->state);
>  }
>  EXPORT_SYMBOL(napi_disable);
>
> +/**
> + *     napi_enable - enable NAPI scheduling
> + *     @n: NAPI context
> + *
> + * Resume NAPI from being scheduled on this context.
> + * Must be paired with napi_disable.
> + */
> +void napi_enable(struct napi_struct *n)
> +{
> +       BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
> +       smp_mb__before_atomic();
> +       clear_bit(NAPI_STATE_SCHED, &n->state);
> +       clear_bit(NAPI_STATE_NPSVC, &n->state);
> +       if (n->dev->threaded && n->thread)
> +               set_bit(NAPI_STATE_THREADED, &n->state);
> +}
> +EXPORT_SYMBOL(napi_enable);
> +
>  static void flush_gro_hash(struct napi_struct *napi)
>  {
>         int i;
> @@ -6862,6 +6934,51 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
>         return work;
>  }
>
> +static int napi_thread_wait(struct napi_struct *napi)
> +{
> +       set_current_state(TASK_INTERRUPTIBLE);
> +
> +       while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> +               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> +                       WARN_ON(!list_empty(&napi->poll_list));
> +                       __set_current_state(TASK_RUNNING);
> +                       return 0;
> +               }
> +
> +               schedule();
> +               set_current_state(TASK_INTERRUPTIBLE);
> +       }
> +       __set_current_state(TASK_RUNNING);
> +       return -1;
> +}
> +
> +static int napi_threaded_poll(void *data)
> +{
> +       struct napi_struct *napi = data;
> +       void *have;
> +
> +       while (!napi_thread_wait(napi)) {
> +               for (;;) {
> +                       bool repoll = false;
> +
> +                       local_bh_disable();
> +
> +                       have = netpoll_poll_lock(napi);
> +                       __napi_poll(napi, &repoll);
> +                       netpoll_poll_unlock(have);
> +
> +                       __kfree_skb_flush();
> +                       local_bh_enable();
> +
> +                       if (!repoll)
> +                               break;
> +
> +                       cond_resched();
> +               }
> +       }
> +       return 0;
> +}
> +
>  static __latent_entropy void net_rx_action(struct softirq_action *h)
>  {
>         struct softnet_data *sd = this_cpu_ptr(&softnet_data);
> --
> 2.30.0.365.g02bc693789-goog
>
