Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8376E924C
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 13:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbjDTLUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 07:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234746AbjDTLUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 07:20:24 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDBFB462
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 04:18:21 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-32a7770f7d1so7692105ab.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 04:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681989426; x=1684581426;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=71XPyFvghrYUg4JlIxRLKYWkY7qzjU28DXhmVVF2TsM=;
        b=2YJjrcmnEsiWUlbrFQ4MShnMtbFqQGT9zAhuauVqisSI+BhJaS0VC9burZOBsFVVPv
         tCzzZMZwqzGO7D0gbepepVEVNAFys03NVHVDcdzJbV2nZm+zFwWfET0E0GeAVyYWAS68
         /qU8+2mDaf76gLIG0JAKiUZ56VjsiH8+CnAfyUr8pUcxBuIPoDsHfoIgV6D3rYSLEB99
         mt8pRHQNQpSOqCy3VXtCFD7UsW802SD8JmurXj1miN6lP8v6ep869Qd6vd5gEELXmA1z
         K9kMm4AE4IXTS+bYyRlKc1pQlrb2Xjdid8C7kWDdvHI8iz+pAdTs8LTXcV4Cku2SmemG
         Gvrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681989426; x=1684581426;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=71XPyFvghrYUg4JlIxRLKYWkY7qzjU28DXhmVVF2TsM=;
        b=SSlBH4pF6Qrzc7762Nq4H8NII/TESqMeTbbXzIL1XgARpCgMAAINP8I6DiUsWCZJ3z
         ia3Ij22DIfInl85dL/oWtNj+/ZVNA7BDjfx55CWyU+Hw2uPhxo/Aw0nucMPWxzOgK2C3
         SV8MB0XKOyUortiaGtrQ2JqzSSjD94WcwaG4Zr9MlTY6HBlZq9TivDojNKU9/8bw+EhG
         e+9kJ5CEaSkaS2zozU06u0eGOiTLViypUDXG/9OGeaQhIJlTMT6iPgA5nhVVi6JeOS9X
         ZZIhkDPK31R/RRNHjxz8YAOcqV34hPgHORyqQYd+ISCpbMGs22rSASxbQUtSYPpVh7lY
         Mszg==
X-Gm-Message-State: AAQBX9fCivddoLPKye5uoplMA1hGydUl6A5Ya7fRrKobjtHy5WUv09lz
        Z0JmsWippExn3Z+R2sotb41bmyeP5KWeCLPfMcxV5g==
X-Google-Smtp-Source: AKy350Ygi0PWL/IHl41WdaOanpGGGBDp0qnN1yJcqXMMLJgBdKADPBX7fji+tcV5Xs6rIm0THleaVuOqLae+Oh5z4Fw=
X-Received: by 2002:a05:6638:4806:b0:3c2:c1c9:8bca with SMTP id
 cp6-20020a056638480600b003c2c1c98bcamr2042751jab.2.1681989425967; Thu, 20 Apr
 2023 04:17:05 -0700 (PDT)
MIME-Version: 1.0
References: <168198515529.808959.12962138073127060724.stgit@firesoul>
In-Reply-To: <168198515529.808959.12962138073127060724.stgit@firesoul>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Apr 2023 13:16:54 +0200
Message-ID: <CANn89iJuEVe72bPmEftyEJHLzzN=QNR2yueFjTxYXCEpS5S8HQ@mail.gmail.com>
Subject: Re: [PATCH net-next V1] net: flush sd->defer_list on unregister_netdevice
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
        hawk@kernel.org, davem@davemloft.net, lorenzo@kernel.org
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

On Thu, Apr 20, 2023 at 12:06=E2=80=AFPM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> When removing a net_device (that use NAPI), the sd->defer_list

Why "(that use NAPI)" is relevant ?

> system can still hold on to SKBs that have a dst_entry which can
> have a netdev_hold reference.

This would be quite a bug really. What makes you think this ?

In order to validate this please post a stack trace if you get a
warning from this debug patch.

(make sure to build with CONFIG_DEBUG_NET=3Dy)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 768f9d04911fb16a40e057aec7bfa2381a40d7a7..56c79bf922ab4045984513de13c=
c946b84fd3675
100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6828,6 +6828,7 @@ nodefer:  __kfree_skb(skb);
                return;
        }

+       DEBUG_NET_WARN_ON_ONCE(skb_dst(skb));
        sd =3D &per_cpu(softnet_data, cpu);
        defer_max =3D READ_ONCE(sysctl_skb_defer_max);
        if (READ_ONCE(sd->defer_count) >=3D defer_max)



>
> Choose simple solution of flushing the softnet_data defer_list
> system as part of unregister_netdevice flush_all_backlogs().

I do not know if adding two conditional tests in the fast path is
worth the pain.

I was thinking of simplifying rules for defer_lock acquisition anyway [1]

If you plan a V2, I would advise to block BH before calling
skb_defer_free_flush.


[1]
diff --git a/net/core/dev.c b/net/core/dev.c
index 3fc4dba71f9dd250c59c0a070566791f0cd27ec4..be68b8f7fe16658f3304696bf3c=
83df4c8af51c7
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6631,11 +6631,11 @@ static void skb_defer_free_flush(struct
softnet_data *sd)
        if (!READ_ONCE(sd->defer_list))
                return;

-       spin_lock_irq(&sd->defer_lock);
+       spin_lock(&sd->defer_lock);
        skb =3D sd->defer_list;
        sd->defer_list =3D NULL;
        sd->defer_count =3D 0;
-       spin_unlock_irq(&sd->defer_lock);
+       spin_unlock(&sd->defer_lock);

        while (skb !=3D NULL) {
                next =3D skb->next;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 768f9d04911fb16a40e057aec7bfa2381a40d7a7..27f6e0042dfe0cbbb362d06b540=
b3ca1567459af
100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6817,7 +6817,6 @@ void skb_attempt_defer_free(struct sk_buff *skb)
 {
        int cpu =3D skb->alloc_cpu;
        struct softnet_data *sd;
-       unsigned long flags;
        unsigned int defer_max;
        bool kick;

@@ -6833,7 +6832,10 @@ nodefer: __kfree_skb(skb);
        if (READ_ONCE(sd->defer_count) >=3D defer_max)
                goto nodefer;

-       spin_lock_irqsave(&sd->defer_lock, flags);
+       /* Strictly speaking, we do not need to block BH to acquire
+        * this spinlock, but lockdep disagrees (unless we add classes)
+       */
+       spin_lock_bh(&sd->defer_lock);
        /* Send an IPI every time queue reaches half capacity. */
        kick =3D sd->defer_count =3D=3D (defer_max >> 1);
        /* Paired with the READ_ONCE() few lines above */
@@ -6842,7 +6844,7 @@ nodefer:  __kfree_skb(skb);
        skb->next =3D sd->defer_list;
        /* Paired with READ_ONCE() in skb_defer_free_flush() */
        WRITE_ONCE(sd->defer_list, skb);
-       spin_unlock_irqrestore(&sd->defer_lock, flags);
+       spin_unlock_bh(&sd->defer_lock);

        /* Make sure to trigger NET_RX_SOFTIRQ on the remote CPU
         * if we are unlucky enough (this seems very unlikely).
