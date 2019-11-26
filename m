Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBB2310A678
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKZWUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:20:44 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:43035 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfKZWUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:20:44 -0500
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iZjCL-0008Na-9s; Tue, 26 Nov 2019 23:20:41 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net 2/2] net: gro: Let the timeout timer expire in softirq context with `threadirqs'
Date:   Tue, 26 Nov 2019 23:20:13 +0100
Message-Id: <20191126222013.1904785-3-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191126222013.1904785-1-bigeasy@linutronix.de>
References: <20191126222013.1904785-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The timer callback (napi_watchdog()) invokes __napi_schedule_irqoff()
with disabled interrupts. With the `threadirqs' commandline option all
interrupt handler are threaded and using __napi_schedule_irqoff() is not
an issue because everyone is using it in threaded context which is
synchronised with local_bh_disable().
The napi_watchdog() timer is still expiring in hardirq context and may
interrupt a threaded handler which is in the middle of
__napi_schedule_irqoff() leading to list corruption.

Let the napi_watchdog() expire in softirq context if `threadirqs' is
used.

Fixes: 3b47d30396bae ("net: gro: add a per device gro flush timer")
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 99ac84ff398f4..ec533d20931bc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5994,6 +5994,8 @@ bool napi_complete_done(struct napi_struct *n, int wo=
rk_done)
 		napi_gro_flush(n, !!timeout);
 		if (timeout)
 			hrtimer_start(&n->timer, ns_to_ktime(timeout),
+				      force_irqthreads ?
+				      HRTIMER_MODE_REL_PINNED_SOFT :
 				      HRTIMER_MODE_REL_PINNED);
 	}
 	if (unlikely(!list_empty(&n->poll_list))) {
@@ -6225,7 +6227,9 @@ void netif_napi_add(struct net_device *dev, struct na=
pi_struct *napi,
 		    int (*poll)(struct napi_struct *, int), int weight)
 {
 	INIT_LIST_HEAD(&napi->poll_list);
-	hrtimer_init(&napi->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
+	hrtimer_init(&napi->timer, CLOCK_MONOTONIC,
+		     force_irqthreads ?
+		     HRTIMER_MODE_REL_PINNED_SOFT : HRTIMER_MODE_REL_PINNED);
 	napi->timer.function =3D napi_watchdog;
 	init_gro_hash(napi);
 	napi->skb =3D NULL;
--=20
2.24.0

