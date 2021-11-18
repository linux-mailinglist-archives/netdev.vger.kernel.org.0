Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F517455372
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 04:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbhKRDh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 22:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbhKRDhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 22:37:53 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D961C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 19:34:53 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id t30so8652337wra.10
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 19:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jRtFMV/osJvgK1V7WSaGHgRkunLHZlIkaEnRGwhTsCg=;
        b=Y1KzxCkdt0hvVfhTYYT7hpXaYiNh++KpgIby/2eD7gUa4jQKKkZoIc6xiCfZJIRnhh
         /eyAGt5EWOaMmJTC90Fd1WAB+SApokHPL4uUpbQDXK2kVhBWnW+Pvr908Dw0PMttelIW
         Myf0eH1/NNEzr+7E5hrzoNNXPgIhea8zCgAsaUQJdDEo3srdKuPl2tySFshQznRbwQHp
         H+a4DETUdNxxiLpz1xCzccSYI3LP7wiEhhAX3iq65jNkEkpGaMd5xwEwD4S+yMj+XEYg
         yX7tnVRmjB247dkfLCHY17zQiX/TfxvnDkVyqXyPynJvwpnlcY4sy5JZ4hRCwQ9A8Pst
         JISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jRtFMV/osJvgK1V7WSaGHgRkunLHZlIkaEnRGwhTsCg=;
        b=NChALe0mEDbTQualwUozF3ZCqxwfbtKk5L04WQaezqWTmkkt2Am6lixyhBpxKRjBET
         aPULpqF34Tz6mqg9+aI7Xekmp6FWESwAtDjoiEVHG4nOt2wBN5jNW1Bs7q6WQd9MHrM9
         ABfq1/d94CP/X5KhjTEtckAKQj5d/S4FR3io3pgoo6O4pAHxT+BOWjMDoL91YROmic9J
         PL8rvi7TF6H/l6M7Fcp7rVtZq9/z4L3dLhk/s7o3Pk/LTPWxb/nhbdiQVYWWY+eUMgJm
         Zo6Rr9YIAQU8scjKF841sTY8KFjHLm9N2YktdZkpZ5jp0Smr+0ba4ya8zlIb9Toz5RLw
         pqoA==
X-Gm-Message-State: AOAM5338bIbh5PwY7PXRw27AnlxidMOPzLjy3JZfJ+H0EyjhRX+8K+BB
        XlwN+jlPadXXRxY8dPMeh6KgJZtsKusNfHja0GcoPw==
X-Google-Smtp-Source: ABdhPJyKMgZ0pPyWDMkxK3ZKRAk28DpriZYI27lKRt1nfByJLVurNYQH5TReo5tEEpopYz+L8hIICK8tP1Kzws0lFIs=
X-Received: by 2002:a5d:4a0a:: with SMTP id m10mr28590961wrq.221.1637206491488;
 Wed, 17 Nov 2021 19:34:51 -0800 (PST)
MIME-Version: 1.0
References: <YZXEY90dRsBjJckd@Laptop-X1>
In-Reply-To: <YZXEY90dRsBjJckd@Laptop-X1>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 17 Nov 2021 19:34:40 -0800
Message-ID: <CANn89iLKKX7+opENOa2oQpH_JmpPYeDPZtb+srYF2O3UgdUT5g@mail.gmail.com>
Subject: Re: [DISCUSS] Bond arp monitor not works with veth due to flag NETIF_F_LLTX.
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <jay.vosburgh@canonical.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 7:11 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Hi,
>
> When I test bond arp monitor with veth interface, the bond link flaps rapidly.
> After checking, in bond_ab_arp_inspect():
>
>                 trans_start = dev_trans_start(slave->dev);
>                 if (bond_is_active_slave(slave) &&
>                     (!bond_time_in_interval(bond, trans_start, bond->params.missed_max) ||
>                      !bond_time_in_interval(bond, last_rx, bond->params.missed_max))) {
>                         bond_propose_link_state(slave, BOND_LINK_DOWN);
>                         commit++;
>                 }
>
> it checks both slave's trans_start and last_rx. While veth interface's
> trans_start never get updated due to flag "NETIF_F_LLTX". As when NETIF_F_LLTX
> set, in netdev_start_xmit() -> txq_trans_update() the txq->trans_start
> never get updated because txq->xmit_lock_owner is always -1.
>
> If we remove the flag NETIF_F_LLTX, the HARD_TX_LOCK() will acquire the
> spin_lock and update txq->xmit_lock_owner. I expected there may have some
> performance drop. But I tested with xdp_redirect_map and pktgen by forwarding
> a 10G NIC's traffic to veth interface and didn't see much performance drop. e.g.
> With xdpgeneric mode, with the flag, it's 2.18M pps, after removing the flag,
> it's 2.11M pps. Not sure if I missed anything.

A non contended lock is not that expensive.

Have you tried using many threads, instead of mono-thread pktgen ?
This will likely be bad.

>
> So what do you think? Should we remove this flag on veth to fix the issue?
> Some user may want to use bonding active-backup arp monitor mode on netns.

Removing LLTX will have performance impact.

Updating ->trans_start at most once per jiffy should be ok.

Here is a patch against net-next

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 750cea23e9cd02bba139a58553c4b1753956ad10..f706efecf0555974e8df562084d5770cc62126e1
100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -356,7 +356,7 @@ static void
am65_cpsw_nuss_ndo_host_tx_timeout(struct net_device *ndev,

        if (netif_tx_queue_stopped(netif_txq)) {
                /* try recover if stopped by us */
-               txq_trans_update(netif_txq);
+               txq_trans_cond_update(netif_txq);
                netif_tx_wake_queue(netif_txq);
        }
 }
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4f4a299e92de7ba9f61507ad4df7e334775c07a6..dfd2f38023c75fb6a4181af4b4a511a9955e6a0b
100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4098,12 +4098,6 @@ static inline void __netif_tx_unlock_bh(struct
netdev_queue *txq)
 /*
  * txq->trans_start can be read locklessly from dev_watchdog()
  */
-static inline void txq_trans_update(struct netdev_queue *txq)
-{
-       if (txq->xmit_lock_owner != -1)
-               WRITE_ONCE(txq->trans_start, jiffies);
-}
-
 static inline void txq_trans_cond_update(struct netdev_queue *txq)
 {
        unsigned long now = jiffies;
@@ -4626,7 +4620,7 @@ static inline netdev_tx_t
netdev_start_xmit(struct sk_buff *skb, struct net_devi

        rc = __netdev_start_xmit(ops, skb, dev, more);
        if (rc == NETDEV_TX_OK)
-               txq_trans_update(txq);
+               txq_trans_cond_update(txq);

        return rc;
 }
