Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F795717BE
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiGLK5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbiGLK52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:57:28 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1173AE575
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:27 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o31-20020a17090a0a2200b001ef7bd037bbso7605020pjo.0
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VGNmWVn47GwbmNQqUc2vBMkpr/Mz4IMDRgmNTmAszqM=;
        b=RLWKa76jBvU79HE3qUEEDneWoQstckX62Wsa1DrLvG8MudJgaIJZ1iiphekShA8Cl5
         kP69CLdNUjOXvQ1TXsxXAHywxZ3RPFvg2ybZ6yfEgXnL3GxpZevuySJlSn16Lnaqu2aE
         ZZSLct1n9GU4O11jUIYEbMRu6V7Fxnt2L+p1SMfDd9/n2BxXTqOyFCihyamUTb7LL67Y
         vnPK8GS0Hlk6HzGN6Y1rj1Av+pTFV53shCM+ptbphX8/gGjnyfp1YmeQdLHQGaY+vxaJ
         pduQYRdBjbUt8naGGdCeN1Eiz0S1LdK8kUYSUXZGO6RJpfMva/zCSabw70GvvCF3ZHDJ
         mZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VGNmWVn47GwbmNQqUc2vBMkpr/Mz4IMDRgmNTmAszqM=;
        b=Gnuvjw/+moK4dIHOAQpY65JLQSe7vINw/ZTeVbMqzBUC66/L3NptXSDLaM0Gt2cPtS
         HMS/BNR3zMW4/az05DyOR4+wJTC36Olh52pcZzLYVbJ+Q3y2kE4aoq4xcglt7bDDG8Ac
         mmrqTaGoDTaMT6puF/5ItXacvLlPEKlt4VNdDNIiUcHc/Y6ZWwZpdoVxPATDnBdOmFB5
         Umu+hUVOp+L0N2oxq2mZ0G3taUPosoXMkkMFz0eDBkS8E8rwNx7NjGSvQvFzvihnv+4L
         jzQbeoZPii3VhCWAA7uW61hPYS+/zL7WIdwyJIhE7pgIyOs2G2xcdfFDUI5YyFWcXzLH
         2PlA==
X-Gm-Message-State: AJIora/GHChLvFs1B8tfWp55N+9/VnVPhjoOj6LF5pcuDCWRE3P7sFGv
        SxWr4O//mlUsLywxf3AcroE=
X-Google-Smtp-Source: AGRyM1tf91OMusciA0DgGDm3Pai8CXeUvwKR/C9hHmEZfp0VOA0RiSZ9N0LnLB82+CK/aOE/WVjvlQ==
X-Received: by 2002:a17:902:c945:b0:16c:49c9:7932 with SMTP id i5-20020a170902c94500b0016c49c97932mr10155314pla.80.1657623447022;
        Tue, 12 Jul 2022 03:57:27 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id im22-20020a170902bb1600b0016c37fe48casm5681714plb.193.2022.07.12.03.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:57:26 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 1/8] amt: use workqueue for gateway side message handling
Date:   Tue, 12 Jul 2022 10:57:07 +0000
Message-Id: <20220712105714.12282-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220712105714.12282-1-ap420073@gmail.com>
References: <20220712105714.12282-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some synchronization issues(amt->status, amt->req_cnt, etc)
if the interface is in gateway mode because gateway message handlers
are processed concurrently.
This applies a work queue for processing these messages instead of
expanding the locking context.

So, the purposes of this patch are to fix exist race conditions and to make
gateway to be able to validate a gateway status more correctly.

When the AMT gateway interface is created, it tries to establish to relay.
The establishment step looks stateless, but it should be managed well.
In order to handle messages in the gateway, it saves the current
status(i.e. AMT_STATUS_XXX).
This patch makes gateway code to be worked with a single thread.

Now, all messages except the multicast are triggered(received or
delay expired), and these messages will be stored in the event
queue(amt->events).
Then, the single worker processes stored messages asynchronously one
by one.
The multicast data message type will be still processed immediately.

Now, amt->lock is only needed to access the event queue(amt->events)
if an interface is the gateway mode.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 158 +++++++++++++++++++++++++++++++++++++++++-----
 include/net/amt.h |  20 ++++++
 2 files changed, 163 insertions(+), 15 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index be2719a3ba70..032c2934e466 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -900,6 +900,28 @@ static void amt_send_mld_gq(struct amt_dev *amt, struct amt_tunnel_list *tunnel)
 }
 #endif
 
+static bool amt_queue_events(struct amt_dev *amt, enum amt_event event,
+			     struct sk_buff *skb)
+{
+	int index;
+
+	spin_lock_bh(&amt->lock);
+	if (amt->nr_events >= AMT_MAX_EVENTS) {
+		spin_unlock_bh(&amt->lock);
+		return 1;
+	}
+
+	index = (amt->event_idx + amt->nr_events) % AMT_MAX_EVENTS;
+	amt->events[index].event = event;
+	amt->events[index].skb = skb;
+	amt->nr_events++;
+	amt->event_idx %= AMT_MAX_EVENTS;
+	queue_work(amt_wq, &amt->event_wq);
+	spin_unlock_bh(&amt->lock);
+
+	return 0;
+}
+
 static void amt_secret_work(struct work_struct *work)
 {
 	struct amt_dev *amt = container_of(to_delayed_work(work),
@@ -913,12 +935,8 @@ static void amt_secret_work(struct work_struct *work)
 			 msecs_to_jiffies(AMT_SECRET_TIMEOUT));
 }
 
-static void amt_discovery_work(struct work_struct *work)
+static void amt_event_send_discovery(struct amt_dev *amt)
 {
-	struct amt_dev *amt = container_of(to_delayed_work(work),
-					   struct amt_dev,
-					   discovery_wq);
-
 	spin_lock_bh(&amt->lock);
 	if (amt->status > AMT_STATUS_SENT_DISCOVERY)
 		goto out;
@@ -933,11 +951,19 @@ static void amt_discovery_work(struct work_struct *work)
 	spin_unlock_bh(&amt->lock);
 }
 
-static void amt_req_work(struct work_struct *work)
+static void amt_discovery_work(struct work_struct *work)
 {
 	struct amt_dev *amt = container_of(to_delayed_work(work),
 					   struct amt_dev,
-					   req_wq);
+					   discovery_wq);
+
+	if (amt_queue_events(amt, AMT_EVENT_SEND_DISCOVERY, NULL))
+		mod_delayed_work(amt_wq, &amt->discovery_wq,
+				 msecs_to_jiffies(AMT_DISCOVERY_TIMEOUT));
+}
+
+static void amt_event_send_request(struct amt_dev *amt)
+{
 	u32 exp;
 
 	spin_lock_bh(&amt->lock);
@@ -967,6 +993,17 @@ static void amt_req_work(struct work_struct *work)
 	spin_unlock_bh(&amt->lock);
 }
 
+static void amt_req_work(struct work_struct *work)
+{
+	struct amt_dev *amt = container_of(to_delayed_work(work),
+					   struct amt_dev,
+					   req_wq);
+
+	if (amt_queue_events(amt, AMT_EVENT_SEND_REQUEST, NULL))
+		mod_delayed_work(amt_wq, &amt->req_wq,
+				 msecs_to_jiffies(100));
+}
+
 static bool amt_send_membership_update(struct amt_dev *amt,
 				       struct sk_buff *skb,
 				       bool v6)
@@ -2392,12 +2429,14 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 	skb->pkt_type = PACKET_MULTICAST;
 	skb->ip_summed = CHECKSUM_NONE;
 	len = skb->len;
+	rcu_read_lock_bh();
 	if (__netif_rx(skb) == NET_RX_SUCCESS) {
 		amt_update_gw_status(amt, AMT_STATUS_RECEIVED_QUERY, true);
 		dev_sw_netstats_rx_add(amt->dev, len);
 	} else {
 		amt->dev->stats.rx_dropped++;
 	}
+	rcu_read_unlock_bh();
 
 	return false;
 }
@@ -2688,6 +2727,38 @@ static bool amt_request_handler(struct amt_dev *amt, struct sk_buff *skb)
 	return false;
 }
 
+static void amt_gw_rcv(struct amt_dev *amt, struct sk_buff *skb)
+{
+	int type = amt_parse_type(skb);
+	int err = 1;
+
+	if (type == -1)
+		goto drop;
+
+	if (amt->mode == AMT_MODE_GATEWAY) {
+		switch (type) {
+		case AMT_MSG_ADVERTISEMENT:
+			err = amt_advertisement_handler(amt, skb);
+			break;
+		case AMT_MSG_MEMBERSHIP_QUERY:
+			err = amt_membership_query_handler(amt, skb);
+			if (!err)
+				return;
+			break;
+		default:
+			netdev_dbg(amt->dev, "Invalid type of Gateway\n");
+			break;
+		}
+	}
+drop:
+	if (err) {
+		amt->dev->stats.rx_dropped++;
+		kfree_skb(skb);
+	} else {
+		consume_skb(skb);
+	}
+}
+
 static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 {
 	struct amt_dev *amt;
@@ -2719,8 +2790,12 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 				err = true;
 				goto drop;
 			}
-			err = amt_advertisement_handler(amt, skb);
-			break;
+			if (amt_queue_events(amt, AMT_EVENT_RECEIVE, skb)) {
+				netdev_dbg(amt->dev, "AMT Event queue full\n");
+				err = true;
+				goto drop;
+			}
+			goto out;
 		case AMT_MSG_MULTICAST_DATA:
 			if (iph->saddr != amt->remote_ip) {
 				netdev_dbg(amt->dev, "Invalid Relay IP\n");
@@ -2738,11 +2813,12 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 				err = true;
 				goto drop;
 			}
-			err = amt_membership_query_handler(amt, skb);
-			if (err)
+			if (amt_queue_events(amt, AMT_EVENT_RECEIVE, skb)) {
+				netdev_dbg(amt->dev, "AMT Event queue full\n");
+				err = true;
 				goto drop;
-			else
-				goto out;
+			}
+			goto out;
 		default:
 			err = true;
 			netdev_dbg(amt->dev, "Invalid type of Gateway\n");
@@ -2780,6 +2856,45 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
+static void amt_event_work(struct work_struct *work)
+{
+	struct amt_dev *amt = container_of(work, struct amt_dev, event_wq);
+	struct sk_buff *skb;
+	u8 event;
+
+	while (1) {
+		spin_lock(&amt->lock);
+		if (amt->nr_events == 0) {
+			spin_unlock(&amt->lock);
+			return;
+		}
+		event = amt->events[amt->event_idx].event;
+		skb = amt->events[amt->event_idx].skb;
+		amt->events[amt->event_idx].event = AMT_EVENT_NONE;
+		amt->events[amt->event_idx].skb = NULL;
+		amt->nr_events--;
+		amt->event_idx++;
+		amt->event_idx %= AMT_MAX_EVENTS;
+		spin_unlock(&amt->lock);
+
+		switch (event) {
+		case AMT_EVENT_RECEIVE:
+			amt_gw_rcv(amt, skb);
+			break;
+		case AMT_EVENT_SEND_DISCOVERY:
+			amt_event_send_discovery(amt);
+			break;
+		case AMT_EVENT_SEND_REQUEST:
+			amt_event_send_request(amt);
+			break;
+		default:
+			if (skb)
+				kfree_skb(skb);
+			break;
+		}
+	}
+}
+
 static int amt_err_lookup(struct sock *sk, struct sk_buff *skb)
 {
 	struct amt_dev *amt;
@@ -2892,10 +3007,21 @@ static int amt_dev_stop(struct net_device *dev)
 	struct amt_dev *amt = netdev_priv(dev);
 	struct amt_tunnel_list *tunnel, *tmp;
 	struct socket *sock;
+	struct sk_buff *skb;
+	int i;
 
 	cancel_delayed_work_sync(&amt->req_wq);
 	cancel_delayed_work_sync(&amt->discovery_wq);
 	cancel_delayed_work_sync(&amt->secret_wq);
+	cancel_work_sync(&amt->event_wq);
+
+	for (i = 0; i < AMT_MAX_EVENTS; i++) {
+		skb = amt->events[i].skb;
+		if (skb)
+			kfree_skb(skb);
+		amt->events[i].event = AMT_EVENT_NONE;
+		amt->events[i].skb = NULL;
+	}
 
 	/* shutdown */
 	sock = rtnl_dereference(amt->sock);
@@ -3051,6 +3177,8 @@ static int amt_newlink(struct net *net, struct net_device *dev,
 		amt->max_tunnels = AMT_MAX_TUNNELS;
 
 	spin_lock_init(&amt->lock);
+	amt->event_idx = 0;
+	amt->nr_events = 0;
 	amt->max_groups = AMT_MAX_GROUP;
 	amt->max_sources = AMT_MAX_SOURCE;
 	amt->hash_buckets = AMT_HSIZE;
@@ -3146,8 +3274,8 @@ static int amt_newlink(struct net *net, struct net_device *dev,
 	INIT_DELAYED_WORK(&amt->discovery_wq, amt_discovery_work);
 	INIT_DELAYED_WORK(&amt->req_wq, amt_req_work);
 	INIT_DELAYED_WORK(&amt->secret_wq, amt_secret_work);
+	INIT_WORK(&amt->event_wq, amt_event_work);
 	INIT_LIST_HEAD(&amt->tunnel_list);
-
 	return 0;
 err:
 	dev_put(amt->stream_dev);
@@ -3280,7 +3408,7 @@ static int __init amt_init(void)
 	if (err < 0)
 		goto unregister_notifier;
 
-	amt_wq = alloc_workqueue("amt", WQ_UNBOUND, 1);
+	amt_wq = alloc_workqueue("amt", WQ_UNBOUND, 0);
 	if (!amt_wq) {
 		err = -ENOMEM;
 		goto rtnl_unregister;
diff --git a/include/net/amt.h b/include/net/amt.h
index 0e40c3d64fcf..08fc30cf2f34 100644
--- a/include/net/amt.h
+++ b/include/net/amt.h
@@ -78,6 +78,15 @@ enum amt_status {
 
 #define AMT_STATUS_MAX (__AMT_STATUS_MAX - 1)
 
+/* Gateway events only */
+enum amt_event {
+	AMT_EVENT_NONE,
+	AMT_EVENT_RECEIVE,
+	AMT_EVENT_SEND_DISCOVERY,
+	AMT_EVENT_SEND_REQUEST,
+	__AMT_EVENT_MAX,
+};
+
 struct amt_header {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	u8 type:4,
@@ -292,6 +301,12 @@ struct amt_group_node {
 	struct hlist_head	sources[];
 };
 
+#define AMT_MAX_EVENTS	16
+struct amt_events {
+	enum amt_event event;
+	struct sk_buff *skb;
+};
+
 struct amt_dev {
 	struct net_device       *dev;
 	struct net_device       *stream_dev;
@@ -308,6 +323,7 @@ struct amt_dev {
 	struct delayed_work     req_wq;
 	/* Protected by RTNL */
 	struct delayed_work     secret_wq;
+	struct work_struct	event_wq;
 	/* AMT status */
 	enum amt_status		status;
 	/* Generated key */
@@ -345,6 +361,10 @@ struct amt_dev {
 	/* Used only in gateway mode */
 	u64			mac:48,
 				reserved:16;
+	/* AMT gateway side message handler queue */
+	struct amt_events	events[AMT_MAX_EVENTS];
+	u8			event_idx;
+	u8			nr_events;
 };
 
 #define AMT_TOS			0xc0
-- 
2.17.1

