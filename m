Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618F5380704
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 12:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhENKSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 06:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbhENKSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 06:18:33 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9560C061574;
        Fri, 14 May 2021 03:17:21 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620987439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=aQbFo382l0WrRlPyWw81sTdqka757jvjmjuI2q0Ks0I=;
        b=LwlwSkqROFUWR2q9nIvclJ+JswaCBlsoPhjpSBEhXDR8vhvwAVhP/x2GhaNbs9eFcII97Y
        j2rCg+EozxT9pt9ftWm8H6wY/KLP0f+fVS0DvVK9xGx7UaJnO8+suqYi96mLWTdYg1fCf3
        CiwHQr7x4Bt0eDcFYiCdAXnA/ytRn76L11V+1nvnxqb/D1mN6LiNSXmZYKc/j+8vkUQeZ5
        5Raz8yL+U2kr6BAfTw9BzvW6K++O3rIlYlD+bZ7RLah4yCxtj8rY4LmwQiGpWAF3G04rTb
        c/J2iV8kqJZ7iM0C9S8tTO/lzC/FZP/HnzvhHFPcljIlIEPdZl8Jjmm85GLuKw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620987439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=aQbFo382l0WrRlPyWw81sTdqka757jvjmjuI2q0Ks0I=;
        b=kMEsLymXP6YQQvNyPfbQaf+rIIfZiyuHz7JtKOB8AzcMe1fxsvvb8e/QSHv3DsWRRx+0z9
        NB/ulEp2c7aKIzCA==
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     Michal Svec <msvec@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Thierry Reding <treding@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH RFC] r8152: Ensure that napi_schedule() is handled
Date:   Fri, 14 May 2021 12:17:19 +0200
Message-ID: <877dk162mo.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 14 May 2021 11:46:08 +0200

The driver invokes napi_schedule() in several places from task
context. napi_schedule() raises the NET_RX softirq bit and relies on the
calling context to ensure that the softirq is handled. That's usually on
return from interrupt or on the outermost local_bh_enable().

But that's not the case here which causes the soft interrupt handling to be
delayed to the next interrupt or local_bh_enable(). If the task in which
context this is invoked is the last runnable task on a CPU and the CPU goes
idle before an interrupt arrives or a local_bh_disable/enable() pair
handles the pending soft interrupt then the NOHZ idle code emits the
following warning.

  NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!

Prevent this by wrapping the napi_schedule() invocation from task context
into a local_bh_disable/enable() pair.

Reported-by: Michal Svec <msvec@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---

Note: That's not the first incident of this. Shouldn't napi_schedule()
      have a debug check (under lockdep) to catch this?

---
 drivers/net/usb/r8152.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1543,6 +1543,17 @@ void write_mii_word(struct net_device *n
 	r8152_mdio_write(tp, reg, val);
 }
 
+/*
+ * Wrapper around napi_schedule() to ensure that the raised network softirq
+ * is actually handled.
+ */
+static void r8152_napi_schedule(struct napi_struct *napi)
+{
+	local_bh_disable();
+	napi_schedule(napi);
+	local_bh_enable();
+}
+
 static int
 r8152_submit_rx(struct r8152 *tp, struct rx_agg *agg, gfp_t mem_flags);
 
@@ -1753,7 +1764,7 @@ static void read_bulk_callback(struct ur
 		spin_lock_irqsave(&tp->rx_lock, flags);
 		list_add_tail(&agg->list, &tp->rx_done);
 		spin_unlock_irqrestore(&tp->rx_lock, flags);
-		napi_schedule(&tp->napi);
+		r8152_napi_schedule(&tp->napi);
 		return;
 	case -ESHUTDOWN:
 		rtl_set_unplug(tp);
@@ -2640,7 +2651,7 @@ int r8152_submit_rx(struct r8152 *tp, st
 		netif_err(tp, rx_err, tp->netdev,
 			  "Couldn't submit rx[%p], ret = %d\n", agg, ret);
 
-		napi_schedule(&tp->napi);
+		r8152_napi_schedule(&tp->napi);
 	}
 
 	return ret;
@@ -8202,7 +8213,7 @@ static int rtl8152_post_reset(struct usb
 	usb_submit_urb(tp->intr_urb, GFP_KERNEL);
 
 	if (!list_empty(&tp->rx_done))
-		napi_schedule(&tp->napi);
+		r8152_napi_schedule(&tp->napi);
 
 	return 0;
 }
@@ -8256,7 +8267,7 @@ static int rtl8152_runtime_resume(struct
 		smp_mb__after_atomic();
 
 		if (!list_empty(&tp->rx_done))
-			napi_schedule(&tp->napi);
+			r8152_napi_schedule(&tp->napi);
 
 		usb_submit_urb(tp->intr_urb, GFP_NOIO);
 	} else {
