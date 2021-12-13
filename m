Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253D4472AAE
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhLMKxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:53:32 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:34264 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhLMKxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 05:53:31 -0500
Date:   Mon, 13 Dec 2021 11:53:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639392810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ChV2HXicrhmW0V/a2QgNBzBylHQzSBgaj8QqwJn8Itw=;
        b=pwfkqFaMNzBsmvasVvi6GebTZsP5ccRfFSZNbudvz+BSOdWgeI1Ky0SVTUU604jBddRgeI
        ybCw77CI7/WFc0KJpraju/B6m3qThKtOr60oF2sZdzKegS1cMUfIhA6kBgbJ0KdGjW2KRx
        lEYG/gOsyMHz5W3W1pCO+B1YM8mEXjjPFHuyD1j4AUNsq/rjHIFCx0VhveCT8zN+yQqJwm
        16gvUhCWz3bry9ZTcLZ2TiVgDz/hoEBvi6fkYWCXLN7GuA1mdwGTP3rZG12Jn9MtpONPrg
        NXvk84/4ZCU7b8avGEImkk0hajl9U0AUIgQPi4cVIxRswzRGvDccun/6nOcXvQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639392810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ChV2HXicrhmW0V/a2QgNBzBylHQzSBgaj8QqwJn8Itw=;
        b=vxIxbNgpUkHM3aSM1jfcUlBz8ktSBurQ73BLLfugfiRJR9iNUbo3Jcw/Vto62XRRTAbRNK
        RMmEdyNDHEYPYRCQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 net-next] net: dev: Always serialize on Qdisc::busylock in
 __dev_xmit_skb() on PREEMPT_RT.
Message-ID: <YbcmKeLngWW/pb1V@linutronix.de>
References: <YbN1OL0I1ja4Fwkb@linutronix.de>
 <20211210203256.09eec931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YbckZ8VxICTThXOn@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YbckZ8VxICTThXOn@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The root-lock is dropped before dev_hard_start_xmit() is invoked and after
setting the __QDISC___STATE_RUNNING bit. If the Qdisc owner is preempted
by another sender/task with a higher priority then this new sender won't
be able to submit packets to the NIC directly instead they will be
enqueued into the Qdisc. The NIC will remain idle until the Qdisc owner
is scheduled again and finishes the job.

By serializing every task on the ->busylock then the task will be
preempted by a sender only after the Qdisc has no owner.

Always serialize on the busylock on PREEMPT_RT.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v1=E2=80=A6v2:  =20
  - use "x =3D cond1 || cond2" as suggested by Jakub.

 net/core/dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2a352e668d103..8438553c06b8e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3836,8 +3836,12 @@ static inline int __dev_xmit_skb(struct sk_buff *skb=
, struct Qdisc *q,
 	 * separate lock before trying to get qdisc main lock.
 	 * This permits qdisc->running owner to get the lock more
 	 * often and dequeue packets faster.
+	 * On PREEMPT_RT it is possible to preempt the qdisc owner during xmit
+	 * and then other tasks will only enqueue packets. The packets will be
+	 * sent after the qdisc owner is scheduled again. To prevent this
+	 * scenario the task always serialize on the lock.
 	 */
-	contended =3D qdisc_is_running(q);
+	contended =3D IS_ENABLED(CONFIG_PREEMPT_RT) || qdisc_is_running(q);
 	if (unlikely(contended))
 		spin_lock(&q->busylock);
=20
--=20
2.34.1
