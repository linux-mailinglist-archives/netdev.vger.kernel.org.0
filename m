Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F17D577738
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiGQQM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiGQQMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:12:23 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706C413CD3
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:22 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id b2so7108365plx.7
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Faeb9WST+LXAKImiDS2N+PsjJjwyu4Jg+NnCwxRofSA=;
        b=oy1m4R4MV9w4C/yy5GzL/9QNzDYt7RyZ5wVYdAo+gUIjh+oP2HizIN039fiDSkrpXM
         Y5qVv7JVMf9R9XQ10+OQBl/qiy5C/gfHxN7oIpDhbXDOp+JyxLfiFl99LHuoLMaQwNeu
         G66mrY6Zxuut1SNThAuBSULmFXZYgbLq5VyS1nDSHTu4HT1wsP7n+4psRpBrH0V93VrM
         4+cPAU5jpf8CGLrKnG26kcKjaAqR5CKas8/vn1VJM/nhlYEGvBnWFLmkfrvQdq76wQtj
         H1tFdKvCMg8DgGwZ3ASWyGGce6Xpxu4TVhmQtgEZDqUStzRSSNem2ztSUQVo4caF1van
         7Q2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Faeb9WST+LXAKImiDS2N+PsjJjwyu4Jg+NnCwxRofSA=;
        b=oHatRT1S9VExmsyMaETbTumFT2NKmnc5aT8u/UyeoqPYgz707m8dWxyOen+/ss1nMh
         +dYq6WMnoNegce3AmJH+WvLRf0Qt0kzUfMg7O7ASiHVTea79qrU8DftE82yRABduvEsT
         FSRRggc9eIbQNd4H9+gYRtfAD5e3DM/Zvi4Ub1uSxQ8KhWK0WG2MglracYe18tW+TrvZ
         Xzuah18/GAUW+isloOYzYQ8V6qck2EL2OW+QSFXwFT2VMPvheslXx9a1Qxo0ey8Z9TnH
         Jn0FmlfxudaTHmlEMBitFUjEJ98e2XahA1zxkECB54habv2MlOyj9SBzCthsE/vVb6z1
         rByw==
X-Gm-Message-State: AJIora+mgFijyWnfbH9sxOkMyuk2ZZyRhxDaVZosvR0LisYspu12my5A
        gOo9yLug4Jfay6pyV+VsTNU=
X-Google-Smtp-Source: AGRyM1sJYVtQ7sYX6+DEtVi/z3XioLiI9MwzD43rBqdBQpKPfSzOdE1wKsli15CyvZz7hSKooL0rSw==
X-Received: by 2002:a17:903:32cb:b0:16c:3c8d:380a with SMTP id i11-20020a17090332cb00b0016c3c8d380amr23474228plr.108.1658074341749;
        Sun, 17 Jul 2022 09:12:21 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id x10-20020a170902ec8a00b0016bde5edfb1sm7443026plg.171.2022.07.17.09.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 09:12:21 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 1/8] amt: use workqueue for gateway side message handling
Date:   Sun, 17 Jul 2022 16:09:03 +0000
Message-Id: <20220717160910.19156-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220717160910.19156-1-ap420073@gmail.com>
References: <20220717160910.19156-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

v2:
 - Use local_bh_disable() instead of rcu_read_lock_bh() in
   amt_membership_query_handler.
 - Fix using uninitialized variables.
 - Fix unexpectedly start the event after stopping.
 - Fix possible deadlock in amt_event_work().
 - Add a limit variable in amt_event_work() to prevent infinite working.
 - Rename amt_queue_events() to amt_queue_event().

 drivers/net/amt.c | 159 +++++++++++++++++++++++++++++++++++++++++-----
 include/net/amt.h |  20 ++++++
 2 files changed, 164 insertions(+), 15 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index be2719a3ba70..21104efd803f 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -900,6 +900,28 @@ static void amt_send_mld_gq(struct amt_dev *amt, struct amt_tunnel_list *tunnel)
 }
 #endif
 
+static bool amt_queue_event(struct amt_dev *amt, enum amt_event event,
+			    struct sk_buff *skb)
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
+	if (amt_queue_event(amt, AMT_EVENT_SEND_DISCOVERY, NULL))
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
+	if (amt_queue_event(amt, AMT_EVENT_SEND_REQUEST, NULL))
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
+	local_bh_disable();
 	if (__netif_rx(skb) == NET_RX_SUCCESS) {
 		amt_update_gw_status(amt, AMT_STATUS_RECEIVED_QUERY, true);
 		dev_sw_netstats_rx_add(amt->dev, len);
 	} else {
 		amt->dev->stats.rx_dropped++;
 	}
+	local_bh_enable();
 
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
+			if (amt_queue_event(amt, AMT_EVENT_RECEIVE, skb)) {
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
+			if (amt_queue_event(amt, AMT_EVENT_RECEIVE, skb)) {
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
@@ -2780,6 +2856,46 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
+static void amt_event_work(struct work_struct *work)
+{
+	struct amt_dev *amt = container_of(work, struct amt_dev, event_wq);
+	struct sk_buff *skb;
+	u8 event;
+	int i;
+
+	for (i = 0; i < AMT_MAX_EVENTS; i++) {
+		spin_lock_bh(&amt->lock);
+		if (amt->nr_events == 0) {
+			spin_unlock_bh(&amt->lock);
+			return;
+		}
+		event = amt->events[amt->event_idx].event;
+		skb = amt->events[amt->event_idx].skb;
+		amt->events[amt->event_idx].event = AMT_EVENT_NONE;
+		amt->events[amt->event_idx].skb = NULL;
+		amt->nr_events--;
+		amt->event_idx++;
+		amt->event_idx %= AMT_MAX_EVENTS;
+		spin_unlock_bh(&amt->lock);
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
@@ -2867,6 +2983,8 @@ static int amt_dev_open(struct net_device *dev)
 
 	amt->ready4 = false;
 	amt->ready6 = false;
+	amt->event_idx = 0;
+	amt->nr_events = 0;
 
 	err = amt_socket_create(amt);
 	if (err)
@@ -2892,6 +3010,8 @@ static int amt_dev_stop(struct net_device *dev)
 	struct amt_dev *amt = netdev_priv(dev);
 	struct amt_tunnel_list *tunnel, *tmp;
 	struct socket *sock;
+	struct sk_buff *skb;
+	int i;
 
 	cancel_delayed_work_sync(&amt->req_wq);
 	cancel_delayed_work_sync(&amt->discovery_wq);
@@ -2904,6 +3024,15 @@ static int amt_dev_stop(struct net_device *dev)
 	if (sock)
 		udp_tunnel_sock_release(sock);
 
+	cancel_work_sync(&amt->event_wq);
+	for (i = 0; i < AMT_MAX_EVENTS; i++) {
+		skb = amt->events[i].skb;
+		if (skb)
+			kfree_skb(skb);
+		amt->events[i].event = AMT_EVENT_NONE;
+		amt->events[i].skb = NULL;
+	}
+
 	amt->ready4 = false;
 	amt->ready6 = false;
 	amt->req_cnt = 0;
@@ -3146,8 +3275,8 @@ static int amt_newlink(struct net *net, struct net_device *dev,
 	INIT_DELAYED_WORK(&amt->discovery_wq, amt_discovery_work);
 	INIT_DELAYED_WORK(&amt->req_wq, amt_req_work);
 	INIT_DELAYED_WORK(&amt->secret_wq, amt_secret_work);
+	INIT_WORK(&amt->event_wq, amt_event_work);
 	INIT_LIST_HEAD(&amt->tunnel_list);
-
 	return 0;
 err:
 	dev_put(amt->stream_dev);
@@ -3280,7 +3409,7 @@ static int __init amt_init(void)
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

