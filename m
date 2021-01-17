Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E453C2F9602
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 23:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbhAQWsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 17:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbhAQWsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 17:48:37 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE52DC061573;
        Sun, 17 Jan 2021 14:47:56 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id g15so4220919pjd.2;
        Sun, 17 Jan 2021 14:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/2hbi2dKwVl31NeiC0aTSjst7es3pRpjrzEtDyhBGs4=;
        b=tt++JfGFwId8s2GP2L4EAUAuYmqxzm1AEekBQB1+WZyFizrB5C7LV7pot+FLneUCnd
         Xicp67fc4pT/EPYTNSwShPmUd37Daa1VWQyC3tIMoco0IcuYXQ8/Df5LUDn1tmet05Vu
         hRKb1rKORQxhHl+pc7d5L7lR8f+IKpF5H3lWQMVdQgP8il263VjGIU6YN5NQNMlCvwJR
         lN2AEQTFlgABN6kCQIb7WjGomX1cux+b0rYr/FAt5ocw64S45luWU6R3ppRojUNbw8FD
         4icqk5Bc4Cj72ovwNbYCo/4kSi6PvA+xjsddmhdokZBHz/bvVCDOoCC7J4HHHaeFfsIh
         4VKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/2hbi2dKwVl31NeiC0aTSjst7es3pRpjrzEtDyhBGs4=;
        b=P/DHSYiXo/a3xTZIlzNhU882IECr1aFzRaEk1Oc1vtG3Myb5O/tzAGGrfA3OBx7oPX
         EnZcB9LFa8ji+3U3gJzQoKKT+YjRi16qFTyNbFSJyQVS4k2sBdUCjuW5RT4RLB5kRlgW
         PbT5SaZXPOlW+5AcURZSpadVLHKZY7KMdjArIUH7yZW4NHx880SfMzN12uVjC8LRdn5j
         29x5Oz17ZE01kELih79dvizgL8GzFfoJmQs2kLO0RN1/WW36IOSVvQV24jqy6aPnWhcl
         6gHXV4XMwo6Z9hH03K/UZ58w9wR1ZztSsPmq83ydkGs4aJKME5jZBN74VqUkcN+lc6fF
         RJiA==
X-Gm-Message-State: AOAM532pYrbaaEFdCaSTHocVpiyIgdVcMD8Kn6I0m9YJvm2gb+2jeMzO
        LfRpGv1dO82pZ7Z79z8enDk=
X-Google-Smtp-Source: ABdhPJzaIQ0RWrFBEtpJpWqdly5221YaZ8cLWBpB5oET8V4tX0Yb9AicinIt6cvyfCOeP7I6ug071Q==
X-Received: by 2002:a17:902:e887:b029:de:7863:19b0 with SMTP id w7-20020a170902e887b02900de786319b0mr12604455plg.42.1610923676205;
        Sun, 17 Jan 2021 14:47:56 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:c3c5:f7f3:3393:2c9d])
        by smtp.gmail.com with ESMTPSA id x15sm13593068pfa.80.2021.01.17.14.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 14:47:55 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net v2] net: lapb: Add locking to the lapb module
Date:   Sun, 17 Jan 2021 14:47:50 -0800
Message-Id: <20210117224750.6572-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the lapb module, the timers may run concurrently with other code in
this module, and there is currently no locking to prevent the code from
racing on "struct lapb_cb". This patch adds locking to prevent racing.

1. Add "spinlock_t lock" to "struct lapb_cb"; Add "spin_lock_bh" and
"spin_unlock_bh" to APIs, timer functions and notifier functions.

2. Add "bool t1timer_stop, t2timer_stop" to "struct lapb_cb" to make us
able to ask running timers to abort; Modify "lapb_stop_t1timer" and
"lapb_stop_t2timer" to make them able to abort running timers;
Modify "lapb_t2timer_expiry" and "lapb_t1timer_expiry" to make them
abort after they are stopped by "lapb_stop_t1timer", "lapb_stop_t2timer",
and "lapb_start_t1timer", "lapb_start_t2timer".

3. In lapb_unregister, change "lapb_stop_t1timer" and "lapb_stop_t2timer"
to "del_timer_sync" to make sure all running timers have exited.

4. In lapb_device_event, replace the "lapb_disconnect_request" call with
the content of "lapb_disconnect_request", to avoid trying to hold the
lock twice. When I do this, I removed "lapb_start_t1timer" because I
don't think it's necessary to start the timer when "NETDEV_GOING_DOWN".

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 include/net/lapb.h    |  2 ++
 net/lapb/lapb_iface.c | 56 +++++++++++++++++++++++++++++++++++++++----
 net/lapb/lapb_timer.c | 30 +++++++++++++++++++----
 3 files changed, 80 insertions(+), 8 deletions(-)

diff --git a/include/net/lapb.h b/include/net/lapb.h
index ccc3d1f020b0..eee73442a1ba 100644
--- a/include/net/lapb.h
+++ b/include/net/lapb.h
@@ -92,6 +92,7 @@ struct lapb_cb {
 	unsigned short		n2, n2count;
 	unsigned short		t1, t2;
 	struct timer_list	t1timer, t2timer;
+	bool			t1timer_stop, t2timer_stop;
 
 	/* Internal control information */
 	struct sk_buff_head	write_queue;
@@ -103,6 +104,7 @@ struct lapb_cb {
 	struct lapb_frame	frmr_data;
 	unsigned char		frmr_type;
 
+	spinlock_t		lock;
 	refcount_t		refcnt;
 };
 
diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index 40961889e9c0..45f332607685 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -122,6 +122,8 @@ static struct lapb_cb *lapb_create_cb(void)
 
 	timer_setup(&lapb->t1timer, NULL, 0);
 	timer_setup(&lapb->t2timer, NULL, 0);
+	lapb->t1timer_stop = true;
+	lapb->t2timer_stop = true;
 
 	lapb->t1      = LAPB_DEFAULT_T1;
 	lapb->t2      = LAPB_DEFAULT_T2;
@@ -129,6 +131,8 @@ static struct lapb_cb *lapb_create_cb(void)
 	lapb->mode    = LAPB_DEFAULT_MODE;
 	lapb->window  = LAPB_DEFAULT_WINDOW;
 	lapb->state   = LAPB_STATE_0;
+
+	spin_lock_init(&lapb->lock);
 	refcount_set(&lapb->refcnt, 1);
 out:
 	return lapb;
@@ -178,8 +182,8 @@ int lapb_unregister(struct net_device *dev)
 		goto out;
 	lapb_put(lapb);
 
-	lapb_stop_t1timer(lapb);
-	lapb_stop_t2timer(lapb);
+	del_timer_sync(&lapb->t1timer);
+	del_timer_sync(&lapb->t2timer);
 
 	lapb_clear_queues(lapb);
 
@@ -201,6 +205,8 @@ int lapb_getparms(struct net_device *dev, struct lapb_parms_struct *parms)
 	if (!lapb)
 		goto out;
 
+	spin_lock_bh(&lapb->lock);
+
 	parms->t1      = lapb->t1 / HZ;
 	parms->t2      = lapb->t2 / HZ;
 	parms->n2      = lapb->n2;
@@ -219,6 +225,7 @@ int lapb_getparms(struct net_device *dev, struct lapb_parms_struct *parms)
 	else
 		parms->t2timer = (lapb->t2timer.expires - jiffies) / HZ;
 
+	spin_unlock_bh(&lapb->lock);
 	lapb_put(lapb);
 	rc = LAPB_OK;
 out:
@@ -234,6 +241,8 @@ int lapb_setparms(struct net_device *dev, struct lapb_parms_struct *parms)
 	if (!lapb)
 		goto out;
 
+	spin_lock_bh(&lapb->lock);
+
 	rc = LAPB_INVALUE;
 	if (parms->t1 < 1 || parms->t2 < 1 || parms->n2 < 1)
 		goto out_put;
@@ -256,6 +265,7 @@ int lapb_setparms(struct net_device *dev, struct lapb_parms_struct *parms)
 
 	rc = LAPB_OK;
 out_put:
+	spin_unlock_bh(&lapb->lock);
 	lapb_put(lapb);
 out:
 	return rc;
@@ -270,6 +280,8 @@ int lapb_connect_request(struct net_device *dev)
 	if (!lapb)
 		goto out;
 
+	spin_lock_bh(&lapb->lock);
+
 	rc = LAPB_OK;
 	if (lapb->state == LAPB_STATE_1)
 		goto out_put;
@@ -285,6 +297,7 @@ int lapb_connect_request(struct net_device *dev)
 
 	rc = LAPB_OK;
 out_put:
+	spin_unlock_bh(&lapb->lock);
 	lapb_put(lapb);
 out:
 	return rc;
@@ -299,6 +312,8 @@ int lapb_disconnect_request(struct net_device *dev)
 	if (!lapb)
 		goto out;
 
+	spin_lock_bh(&lapb->lock);
+
 	switch (lapb->state) {
 	case LAPB_STATE_0:
 		rc = LAPB_NOTCONNECTED;
@@ -330,6 +345,7 @@ int lapb_disconnect_request(struct net_device *dev)
 
 	rc = LAPB_OK;
 out_put:
+	spin_unlock_bh(&lapb->lock);
 	lapb_put(lapb);
 out:
 	return rc;
@@ -344,6 +360,8 @@ int lapb_data_request(struct net_device *dev, struct sk_buff *skb)
 	if (!lapb)
 		goto out;
 
+	spin_lock_bh(&lapb->lock);
+
 	rc = LAPB_NOTCONNECTED;
 	if (lapb->state != LAPB_STATE_3 && lapb->state != LAPB_STATE_4)
 		goto out_put;
@@ -352,6 +370,7 @@ int lapb_data_request(struct net_device *dev, struct sk_buff *skb)
 	lapb_kick(lapb);
 	rc = LAPB_OK;
 out_put:
+	spin_unlock_bh(&lapb->lock);
 	lapb_put(lapb);
 out:
 	return rc;
@@ -364,7 +383,9 @@ int lapb_data_received(struct net_device *dev, struct sk_buff *skb)
 	int rc = LAPB_BADTOKEN;
 
 	if (lapb) {
+		spin_lock_bh(&lapb->lock);
 		lapb_data_input(lapb, skb);
+		spin_unlock_bh(&lapb->lock);
 		lapb_put(lapb);
 		rc = LAPB_OK;
 	}
@@ -435,6 +456,8 @@ static int lapb_device_event(struct notifier_block *this, unsigned long event,
 	if (!lapb)
 		return NOTIFY_DONE;
 
+	spin_lock_bh(&lapb->lock);
+
 	switch (event) {
 	case NETDEV_UP:
 		lapb_dbg(0, "(%p) Interface up: %s\n", dev, dev->name);
@@ -453,8 +476,32 @@ static int lapb_device_event(struct notifier_block *this, unsigned long event,
 		}
 		break;
 	case NETDEV_GOING_DOWN:
-		if (netif_carrier_ok(dev))
-			lapb_disconnect_request(dev);
+		switch (lapb->state) {
+		case LAPB_STATE_0:
+			break;
+
+		case LAPB_STATE_1:
+			lapb_dbg(1, "(%p) S1 TX DISC(1)\n", lapb->dev);
+			lapb_dbg(0, "(%p) S1 -> S0\n", lapb->dev);
+			lapb_send_control(lapb, LAPB_DISC, LAPB_POLLON,
+					  LAPB_COMMAND);
+			lapb->state = LAPB_STATE_0;
+			break;
+
+		case LAPB_STATE_2:
+			break;
+
+		default:
+			lapb_clear_queues(lapb);
+			lapb->n2count = 0;
+			lapb_send_control(lapb, LAPB_DISC, LAPB_POLLON,
+					  LAPB_COMMAND);
+			lapb_stop_t2timer(lapb);
+			lapb->state = LAPB_STATE_2;
+			lapb_dbg(1, "(%p) S3 DISC(1)\n", lapb->dev);
+			lapb_dbg(0, "(%p) S3 -> S2\n", lapb->dev);
+		}
+
 		break;
 	case NETDEV_DOWN:
 		lapb_dbg(0, "(%p) Interface down: %s\n", dev, dev->name);
@@ -489,6 +536,7 @@ static int lapb_device_event(struct notifier_block *this, unsigned long event,
 		break;
 	}
 
+	spin_unlock_bh(&lapb->lock);
 	lapb_put(lapb);
 	return NOTIFY_DONE;
 }
diff --git a/net/lapb/lapb_timer.c b/net/lapb/lapb_timer.c
index baa247fe4ed0..0230b272b7d1 100644
--- a/net/lapb/lapb_timer.c
+++ b/net/lapb/lapb_timer.c
@@ -40,6 +40,7 @@ void lapb_start_t1timer(struct lapb_cb *lapb)
 	lapb->t1timer.function = lapb_t1timer_expiry;
 	lapb->t1timer.expires  = jiffies + lapb->t1;
 
+	lapb->t1timer_stop = false;
 	add_timer(&lapb->t1timer);
 }
 
@@ -50,16 +51,19 @@ void lapb_start_t2timer(struct lapb_cb *lapb)
 	lapb->t2timer.function = lapb_t2timer_expiry;
 	lapb->t2timer.expires  = jiffies + lapb->t2;
 
+	lapb->t2timer_stop = false;
 	add_timer(&lapb->t2timer);
 }
 
 void lapb_stop_t1timer(struct lapb_cb *lapb)
 {
+	lapb->t1timer_stop = true;
 	del_timer(&lapb->t1timer);
 }
 
 void lapb_stop_t2timer(struct lapb_cb *lapb)
 {
+	lapb->t2timer_stop = true;
 	del_timer(&lapb->t2timer);
 }
 
@@ -72,16 +76,31 @@ static void lapb_t2timer_expiry(struct timer_list *t)
 {
 	struct lapb_cb *lapb = from_timer(lapb, t, t2timer);
 
+	spin_lock_bh(&lapb->lock);
+	if (timer_pending(&lapb->t2timer)) /* A new timer has been set up */
+		goto out;
+	if (lapb->t2timer_stop) /* The timer has been stopped */
+		goto out;
+
 	if (lapb->condition & LAPB_ACK_PENDING_CONDITION) {
 		lapb->condition &= ~LAPB_ACK_PENDING_CONDITION;
 		lapb_timeout_response(lapb);
 	}
+
+out:
+	spin_unlock_bh(&lapb->lock);
 }
 
 static void lapb_t1timer_expiry(struct timer_list *t)
 {
 	struct lapb_cb *lapb = from_timer(lapb, t, t1timer);
 
+	spin_lock_bh(&lapb->lock);
+	if (timer_pending(&lapb->t1timer)) /* A new timer has been set up */
+		goto out;
+	if (lapb->t1timer_stop) /* The timer has been stopped */
+		goto out;
+
 	switch (lapb->state) {
 
 		/*
@@ -108,7 +127,7 @@ static void lapb_t1timer_expiry(struct timer_list *t)
 				lapb->state = LAPB_STATE_0;
 				lapb_disconnect_indication(lapb, LAPB_TIMEDOUT);
 				lapb_dbg(0, "(%p) S1 -> S0\n", lapb->dev);
-				return;
+				goto out;
 			} else {
 				lapb->n2count++;
 				if (lapb->mode & LAPB_EXTENDED) {
@@ -132,7 +151,7 @@ static void lapb_t1timer_expiry(struct timer_list *t)
 				lapb->state = LAPB_STATE_0;
 				lapb_disconnect_confirmation(lapb, LAPB_TIMEDOUT);
 				lapb_dbg(0, "(%p) S2 -> S0\n", lapb->dev);
-				return;
+				goto out;
 			} else {
 				lapb->n2count++;
 				lapb_dbg(1, "(%p) S2 TX DISC(1)\n", lapb->dev);
@@ -150,7 +169,7 @@ static void lapb_t1timer_expiry(struct timer_list *t)
 				lapb_stop_t2timer(lapb);
 				lapb_disconnect_indication(lapb, LAPB_TIMEDOUT);
 				lapb_dbg(0, "(%p) S3 -> S0\n", lapb->dev);
-				return;
+				goto out;
 			} else {
 				lapb->n2count++;
 				lapb_requeue_frames(lapb);
@@ -167,7 +186,7 @@ static void lapb_t1timer_expiry(struct timer_list *t)
 				lapb->state = LAPB_STATE_0;
 				lapb_disconnect_indication(lapb, LAPB_TIMEDOUT);
 				lapb_dbg(0, "(%p) S4 -> S0\n", lapb->dev);
-				return;
+				goto out;
 			} else {
 				lapb->n2count++;
 				lapb_transmit_frmr(lapb);
@@ -176,4 +195,7 @@ static void lapb_t1timer_expiry(struct timer_list *t)
 	}
 
 	lapb_start_t1timer(lapb);
+
+out:
+	spin_unlock_bh(&lapb->lock);
 }
-- 
2.27.0

