Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D294D667DBF
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbjALSS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240180AbjALSSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:18:01 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749A392
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 09:48:42 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso21767654pjo.3
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 09:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kYVWJ7k+UIIearLYPWflHxKDCw5KkZwLx7uD7gLMcvY=;
        b=le4gQYWqcsLi6cm1r0GlaaA/f2Y9bh5ws97Arg1Pptoibl6tSgsHsNeIH6zbgKZ7Ts
         K3ge4m5QVx1xtODcToUReVsYvRkV6ajalmlNTNvhWIF3SBPrmdRQEYmNG+SAD+8dAtHL
         sCJgcx5mDPOfbuyFQpBmZv8CpQRgpOG84J+ZGJAKQb1KTUmJAUWGDbgPEAScNiMxAFc1
         PTI9C4/Nk06EN/+tkrmDiOBfMgpMdutTX+A2dSOizw3DoJkj3tdq7HCE55VPfCCMeB6D
         E/yMAWzW5W1p30hx0E0WRLfID9QrjLMdyHUK0CdFvgVHn28sLg//QQvaX7n+Jc0uI43e
         0awQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kYVWJ7k+UIIearLYPWflHxKDCw5KkZwLx7uD7gLMcvY=;
        b=B40JGz4yKoPaPTq/nmHbZM2VOOJ/lqviwzqA30QsdQopc7E3Zxs45Ko9AhZw0uTZ5K
         TSJM1a6yCrDtjZAJxy+oKixfkrVMdwNRnilzpPaT+nFJHDFrE+Z6UmKkov8oy/78lGWb
         kSOZLnNl+TCrJ2ID0GZjpUy7i2aFjp6H874MLsg33gby/FdXhOFzQeVIkH+AmfUnIbn6
         E/lXeiMzY30U7eMmtu9xgAx1w5Y7M5Ur3o2iP4xTffiMyT2JQtKy5Rth9uJspdpTiMd5
         yO1X2v6bHv26dASRZUho4ldRCHAiQN+tvMCEtZDzUQMj9OUVlfU2ItK8zTNW42bn3eyR
         NIKA==
X-Gm-Message-State: AFqh2kqi8aP2Jxgn4lhZ7ZiMtP+LRURp6eXmQVFcpMT2OZN79cuORzTQ
        c1OHH9VALRRuSPIh5JAJSMs=
X-Google-Smtp-Source: AMrXdXukPYww9XqE44i3QuCLuKSJYXPEKJZOPV5bZJy9Q/HikQoeNL4IkbmS2nPx+ng+F92vK23hiA==
X-Received: by 2002:a17:90a:8d01:b0:226:e787:d3e8 with SMTP id c1-20020a17090a8d0100b00226e787d3e8mr23389185pjo.38.1673545721882;
        Thu, 12 Jan 2023 09:48:41 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.20])
        by smtp.googlemail.com with ESMTPSA id bj5-20020a17090b088500b00212e5068e17sm11001756pjb.40.2023.01.12.09.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 09:48:41 -0800 (PST)
Message-ID: <0031e545f7f26a36a213712480ed6d157d0fc47a.camel@gmail.com>
Subject: Re: [PATCH net] net: enetc: avoid deadlock in
 enetc_tx_onestep_tstamp()
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Y . b . Lu" <yangbo.lu@nxp.com>
Date:   Thu, 12 Jan 2023 09:48:40 -0800
In-Reply-To: <20230112105440.1786799-1-vladimir.oltean@nxp.com>
References: <20230112105440.1786799-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-01-12 at 12:54 +0200, Vladimir Oltean wrote:
> This lockdep splat says it better than I could:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: inconsistent lock state
> 6.2.0-rc2-07010-ga9b9500ffaac-dirty #967 Not tainted
> --------------------------------
> inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> kworker/1:3/179 [HC0[0]:SC0[0]:HE1:SE1] takes:
> ffff3ec4036ce098 (_xmit_ETHER#2){+.?.}-{3:3}, at: netif_freeze_queues+0x5=
c/0xc0
> {IN-SOFTIRQ-W} state was registered at:
>   _raw_spin_lock+0x5c/0xc0
>   sch_direct_xmit+0x148/0x37c
>   __dev_queue_xmit+0x528/0x111c
>   ip6_finish_output2+0x5ec/0xb7c
>   ip6_finish_output+0x240/0x3f0
>   ip6_output+0x78/0x360
>   ndisc_send_skb+0x33c/0x85c
>   ndisc_send_rs+0x54/0x12c
>   addrconf_rs_timer+0x154/0x260
>   call_timer_fn+0xb8/0x3a0
>   __run_timers.part.0+0x214/0x26c
>   run_timer_softirq+0x3c/0x74
>   __do_softirq+0x14c/0x5d8
>   ____do_softirq+0x10/0x20
>   call_on_irq_stack+0x2c/0x5c
>   do_softirq_own_stack+0x1c/0x30
>   __irq_exit_rcu+0x168/0x1a0
>   irq_exit_rcu+0x10/0x40
>   el1_interrupt+0x38/0x64
> irq event stamp: 7825
> hardirqs last  enabled at (7825): [<ffffdf1f7200cae4>] exit_to_kernel_mod=
e+0x34/0x130
> hardirqs last disabled at (7823): [<ffffdf1f708105f0>] __do_softirq+0x550=
/0x5d8
> softirqs last  enabled at (7824): [<ffffdf1f7081050c>] __do_softirq+0x46c=
/0x5d8
> softirqs last disabled at (7811): [<ffffdf1f708166e0>] ____do_softirq+0x1=
0/0x20
>=20
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>=20
>        CPU0
>        ----
>   lock(_xmit_ETHER#2);
>   <Interrupt>
>     lock(_xmit_ETHER#2);
>=20
>  *** DEADLOCK ***
>=20
> 3 locks held by kworker/1:3/179:
>  #0: ffff3ec400004748 ((wq_completion)events){+.+.}-{0:0}, at: process_on=
e_work+0x1f4/0x6c0
>  #1: ffff80000a0bbdc8 ((work_completion)(&priv->tx_onestep_tstamp)){+.+.}=
-{0:0}, at: process_one_work+0x1f4/0x6c0
>  #2: ffff3ec4036cd438 (&dev->tx_global_lock){+.+.}-{3:3}, at: netif_tx_lo=
ck+0x1c/0x34
>=20
> Workqueue: events enetc_tx_onestep_tstamp
> Call trace:
>  print_usage_bug.part.0+0x208/0x22c
>  mark_lock+0x7f0/0x8b0
>  __lock_acquire+0x7c4/0x1ce0
>  lock_acquire.part.0+0xe0/0x220
>  lock_acquire+0x68/0x84
>  _raw_spin_lock+0x5c/0xc0
>  netif_freeze_queues+0x5c/0xc0
>  netif_tx_lock+0x24/0x34
>  enetc_tx_onestep_tstamp+0x20/0x100
>  process_one_work+0x28c/0x6c0
>  worker_thread+0x74/0x450
>  kthread+0x118/0x11c
>=20
> but I'll say it anyway: the enetc_tx_onestep_tstamp() work item runs in
> process context, therefore with softirqs enabled (i.o.w., it can be
> interrupted by a softirq). If we hold the netif_tx_lock() when there is
> an interrupt, and the NET_TX softirq then gets scheduled, this will take
> the netif_tx_lock() a second time and deadlock the kernel.
>=20
> To solve this, use netif_tx_lock_bh(), which blocks softirqs from
> running.
>=20
> Fixes: 7294380c5211 ("enetc: support PTP Sync packet one-step timestampin=
g")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/e=
thernet/freescale/enetc/enetc.c
> index 5ad0b259e623..0a990d35fe58 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -2288,14 +2288,14 @@ static void enetc_tx_onestep_tstamp(struct work_s=
truct *work)
> =20
>  	priv =3D container_of(work, struct enetc_ndev_priv, tx_onestep_tstamp);
> =20
> -	netif_tx_lock(priv->ndev);
> +	netif_tx_lock_bh(priv->ndev);
> =20
>  	clear_bit_unlock(ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS, &priv->flags);
>  	skb =3D skb_dequeue(&priv->tx_skbs);
>  	if (skb)
>  		enetc_start_xmit(skb, priv->ndev);
> =20
> -	netif_tx_unlock(priv->ndev);
> +	netif_tx_unlock_bh(priv->ndev);
>  }
> =20
>  static void enetc_tx_onestep_tstamp_init(struct enetc_ndev_priv *priv)


Looking at the patch this fixes I had a question. You have the tx_skbs
in the enet_ndev_priv struct and from what I can tell it looks like you
support multiple Tx queues. Is there a risk of corrupting the queue if
multiple Tx queues attempt to request the onestep timestamp?

My thought is that you might be better off looking at splitting your
queues up so that they are contained within the enetc_bdr struct. Then
you would only need the individual Tx queue lock instead of having to
take the global Tx queue lock.

Also I am confused. Why do you clear the TSTAMP_IN_PROGRESS flag in
enetc_tx_onestep_timestamp before checking the state of the queue? It
seems like something you should only be clearing once the queue is
empty.


