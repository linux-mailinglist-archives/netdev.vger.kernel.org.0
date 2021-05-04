Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8029737317B
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 22:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhEDUhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 16:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhEDUhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 16:37:13 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD510C06138C
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 13:36:15 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 124so15257953lff.5
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 13:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flodin-me.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iMDuXq8CnWsxBoTteWoy8qTwu96FgJNObP1qaPnL9Fc=;
        b=ZvpLVLF6Bru8xoW0FnZJVcHEz5vB4KG8DmEn2S58qVvUNVonVz9SQFx25kCr8m4QHg
         5mBSVKxjepRbG7l3PoZZiFbh5ADVAZ8eixyqG+P7YPDqviekEeE9tea/V/nt/v5mxSiI
         /8ifZNgs0m1YmAcQt5doYPmg6E8MlxrV/c52Y0S2yu66xzBcxHI3l1Drzfh0qp2p/djt
         9+b4k1IlWYHdW4SBaPefci99pmpNkgsU+1LqWBzdN2v0A/QLo/AryRLM15wZMgRvPZns
         8Yeis8L5JMkakfAawjmvCo5SSN+ulrR81h8GRWfS+IBWPQ+ED+/8IepI+SU2fGV0TTU9
         IJHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iMDuXq8CnWsxBoTteWoy8qTwu96FgJNObP1qaPnL9Fc=;
        b=AJiM/Z87q+aioNrbOVvYlwWdgMJtYFwObbqUf0arNo90LYmktvQiiKS7+dN0q1lbgo
         PbVvFcE5Wdt+Mjw5vE/7OceDX727FmaRPuB1pBfTbfR1UfcUVlPi2Zv+IRR5bPhJIkQi
         oT91DdivnphgSgjoQBeA9XMPYKN4HcfoQf6FDIFUssupoUZSWLI3ad/a87LY7GNxaNxO
         OyC0dlTRMr2taD0rrv7fGA7M1WqLW/HfQoyRshjzP3+x+fLwTD/nQVbDd7Xw8WqUuY6f
         M7Lir91f248IgwEkT+NgDdYWF93EHeqx5W5MWYIRm3U4kMtIuyXAGJ1wBYEBtGEn4ozF
         pogA==
X-Gm-Message-State: AOAM533pI41WHKVfUDysBGHMBikmQSF84IraeN50WYJTHfIGYtqvn0Md
        3KTYELf7sXM9GUkj3UUp46UIGQ==
X-Google-Smtp-Source: ABdhPJy4ppgpyuMkpW1U7TEBPlmF1b3rZpCWlNpGsxNvwVCjUIliXPEIE6KSdJDm888S2Fp+Ac4vUw==
X-Received: by 2002:a05:6512:3f8c:: with SMTP id x12mr17822059lfa.622.1620160573491;
        Tue, 04 May 2021 13:36:13 -0700 (PDT)
Received: from trillian.bjorktomta.lan (h-158-174-77-132.NA.cust.bahnhof.se. [158.174.77.132])
        by smtp.gmail.com with ESMTPSA id v1sm1792222ljj.77.2021.05.04.13.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 13:36:12 -0700 (PDT)
From:   Erik Flodin <erik@flodin.me>
To:     socketcan@hartkopp.net, mkl@pengutronix.de
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, Erik Flodin <erik@flodin.me>
Subject: [PATCH v2 1/2] can: add support for filtering own messages only
Date:   Tue,  4 May 2021 22:35:45 +0200
Message-Id: <20210504203546.115734-2-erik@flodin.me>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210504203546.115734-1-erik@flodin.me>
References: <20210504203546.115734-1-erik@flodin.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new flag to can_rx_register/unregister that, when set, requires
that the received sk_buff's owning socket matches the socket pointer
given when setting the filter. This makes it possible to set a filter
that matches all frames sent on a given socket and nothing else.

Signed-off-by: Erik Flodin <erik@flodin.me>
---
 include/linux/can/core.h |  4 ++--
 net/can/af_can.c         | 50 ++++++++++++++++++++++------------------
 net/can/af_can.h         |  1 +
 net/can/bcm.c            |  9 +++++---
 net/can/gw.c             |  7 +++---
 net/can/isotp.c          |  8 +++----
 net/can/j1939/main.c     |  4 ++--
 net/can/proc.c           | 11 +++++----
 net/can/raw.c            | 10 ++++----
 9 files changed, 58 insertions(+), 46 deletions(-)

diff --git a/include/linux/can/core.h b/include/linux/can/core.h
index 5fb8d0e3f9c1..7ee68128dc10 100644
--- a/include/linux/can/core.h
+++ b/include/linux/can/core.h
@@ -48,12 +48,12 @@ extern int  can_proto_register(const struct can_proto *cp);
 extern void can_proto_unregister(const struct can_proto *cp);
 
 int can_rx_register(struct net *net, struct net_device *dev,
-		    canid_t can_id, canid_t mask,
+		    canid_t can_id, canid_t mask, bool match_sk,
 		    void (*func)(struct sk_buff *, void *),
 		    void *data, char *ident, struct sock *sk);
 
 extern void can_rx_unregister(struct net *net, struct net_device *dev,
-			      canid_t can_id, canid_t mask,
+			      canid_t can_id, canid_t mask, bool match_sk,
 			      void (*func)(struct sk_buff *, void *),
 			      void *data);
 
diff --git a/net/can/af_can.c b/net/can/af_can.c
index cce2af10eb3e..7b639c121653 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -414,6 +414,7 @@ static struct hlist_head *can_rcv_list_find(canid_t *can_id, canid_t *mask,
  * @dev: pointer to netdevice (NULL => subscribe from 'all' CAN devices list)
  * @can_id: CAN identifier (see description)
  * @mask: CAN mask (see description)
+ * @match_sk: match socket pointer on received sk_buff (see description)
  * @func: callback function on filter match
  * @data: returned parameter for callback function
  * @ident: string for calling module identification
@@ -428,6 +429,9 @@ static struct hlist_head *can_rcv_list_find(canid_t *can_id, canid_t *mask,
  *  The filter can be inverted (CAN_INV_FILTER bit set in can_id) or it can
  *  filter for error message frames (CAN_ERR_FLAG bit set in mask).
  *
+ *  If match_sk is true, the received sk_buff's owning socket must also match
+ *  the given socket pointer.
+ *
  *  The provided pointer to the sk_buff is guaranteed to be valid as long as
  *  the callback function is running. The callback function must *not* free
  *  the given sk_buff while processing it's task. When the given sk_buff is
@@ -440,8 +444,9 @@ static struct hlist_head *can_rcv_list_find(canid_t *can_id, canid_t *mask,
  *  -ENODEV unknown device
  */
 int can_rx_register(struct net *net, struct net_device *dev, canid_t can_id,
-		    canid_t mask, void (*func)(struct sk_buff *, void *),
-		    void *data, char *ident, struct sock *sk)
+		    canid_t mask, bool match_sk,
+		    void (*func)(struct sk_buff *, void *), void *data,
+		    char *ident, struct sock *sk)
 {
 	struct receiver *rcv;
 	struct hlist_head *rcv_list;
@@ -468,6 +473,7 @@ int can_rx_register(struct net *net, struct net_device *dev, canid_t can_id,
 
 	rcv->can_id = can_id;
 	rcv->mask = mask;
+	rcv->match_sk = match_sk;
 	rcv->matches = 0;
 	rcv->func = func;
 	rcv->data = data;
@@ -503,6 +509,7 @@ static void can_rx_delete_receiver(struct rcu_head *rp)
  * @dev: pointer to netdevice (NULL => unsubscribe from 'all' CAN devices list)
  * @can_id: CAN identifier
  * @mask: CAN mask
+ * @match_sk: match socket pointer on received sk_buff
  * @func: callback function on filter match
  * @data: returned parameter for callback function
  *
@@ -510,8 +517,8 @@ static void can_rx_delete_receiver(struct rcu_head *rp)
  *  Removes subscription entry depending on given (subscription) values.
  */
 void can_rx_unregister(struct net *net, struct net_device *dev, canid_t can_id,
-		       canid_t mask, void (*func)(struct sk_buff *, void *),
-		       void *data)
+		       canid_t mask, bool match_sk,
+		       void (*func)(struct sk_buff *, void *), void *data)
 {
 	struct receiver *rcv = NULL;
 	struct hlist_head *rcv_list;
@@ -535,7 +542,8 @@ void can_rx_unregister(struct net *net, struct net_device *dev, canid_t can_id,
 	 */
 	hlist_for_each_entry_rcu(rcv, rcv_list, list) {
 		if (rcv->can_id == can_id && rcv->mask == mask &&
-		    rcv->func == func && rcv->data == data)
+		    rcv->match_sk == match_sk && rcv->func == func &&
+		    rcv->data == data)
 			break;
 	}
 
@@ -546,8 +554,8 @@ void can_rx_unregister(struct net *net, struct net_device *dev, canid_t can_id,
 	 * a warning here.
 	 */
 	if (!rcv) {
-		pr_warn("can: receive list entry not found for dev %s, id %03X, mask %03X\n",
-			DNAME(dev), can_id, mask);
+		pr_warn("can: receive list entry not found for dev %s, id %03X, mask %03X%s\n",
+			DNAME(dev), can_id, mask, match_sk ? " (match sk)" : "");
 		goto out;
 	}
 
@@ -569,10 +577,14 @@ void can_rx_unregister(struct net *net, struct net_device *dev, canid_t can_id,
 }
 EXPORT_SYMBOL(can_rx_unregister);
 
-static inline void deliver(struct sk_buff *skb, struct receiver *rcv)
+static inline int deliver(struct sk_buff *skb, struct receiver *rcv)
 {
-	rcv->func(skb, rcv->data);
-	rcv->matches++;
+	if (!rcv->match_sk || skb->sk == rcv->sk) {
+		rcv->func(skb, rcv->data);
+		rcv->matches++;
+		return 1;
+	}
+	return 0;
 }
 
 static int can_rcv_filter(struct can_dev_rcv_lists *dev_rcv_lists, struct sk_buff *skb)
@@ -589,8 +601,7 @@ static int can_rcv_filter(struct can_dev_rcv_lists *dev_rcv_lists, struct sk_buf
 		/* check for error message frame entries only */
 		hlist_for_each_entry_rcu(rcv, &dev_rcv_lists->rx[RX_ERR], list) {
 			if (can_id & rcv->mask) {
-				deliver(skb, rcv);
-				matches++;
+				matches += deliver(skb, rcv);
 			}
 		}
 		return matches;
@@ -598,23 +609,20 @@ static int can_rcv_filter(struct can_dev_rcv_lists *dev_rcv_lists, struct sk_buf
 
 	/* check for unfiltered entries */
 	hlist_for_each_entry_rcu(rcv, &dev_rcv_lists->rx[RX_ALL], list) {
-		deliver(skb, rcv);
-		matches++;
+		matches += deliver(skb, rcv);
 	}
 
 	/* check for can_id/mask entries */
 	hlist_for_each_entry_rcu(rcv, &dev_rcv_lists->rx[RX_FIL], list) {
 		if ((can_id & rcv->mask) == rcv->can_id) {
-			deliver(skb, rcv);
-			matches++;
+			matches += deliver(skb, rcv);
 		}
 	}
 
 	/* check for inverted can_id/mask entries */
 	hlist_for_each_entry_rcu(rcv, &dev_rcv_lists->rx[RX_INV], list) {
 		if ((can_id & rcv->mask) != rcv->can_id) {
-			deliver(skb, rcv);
-			matches++;
+			matches += deliver(skb, rcv);
 		}
 	}
 
@@ -625,15 +633,13 @@ static int can_rcv_filter(struct can_dev_rcv_lists *dev_rcv_lists, struct sk_buf
 	if (can_id & CAN_EFF_FLAG) {
 		hlist_for_each_entry_rcu(rcv, &dev_rcv_lists->rx_eff[effhash(can_id)], list) {
 			if (rcv->can_id == can_id) {
-				deliver(skb, rcv);
-				matches++;
+				matches += deliver(skb, rcv);
 			}
 		}
 	} else {
 		can_id &= CAN_SFF_MASK;
 		hlist_for_each_entry_rcu(rcv, &dev_rcv_lists->rx_sff[can_id], list) {
-			deliver(skb, rcv);
-			matches++;
+			matches += deliver(skb, rcv);
 		}
 	}
 
diff --git a/net/can/af_can.h b/net/can/af_can.h
index 7c2d9161e224..ea98b10d93e7 100644
--- a/net/can/af_can.h
+++ b/net/can/af_can.h
@@ -52,6 +52,7 @@ struct receiver {
 	struct hlist_node list;
 	canid_t can_id;
 	canid_t mask;
+	bool match_sk;
 	unsigned long matches;
 	void (*func)(struct sk_buff *skb, void *data);
 	void *data;
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 909b9e684e04..d89dd82c2178 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -729,7 +729,8 @@ static void bcm_rx_unreg(struct net_device *dev, struct bcm_op *op)
 {
 	if (op->rx_reg_dev == dev) {
 		can_rx_unregister(dev_net(dev), dev, op->can_id,
-				  REGMASK(op->can_id), bcm_rx_handler, op);
+				  REGMASK(op->can_id), false, bcm_rx_handler,
+				  op);
 
 		/* mark as removed subscription */
 		op->rx_reg_dev = NULL;
@@ -775,6 +776,7 @@ static int bcm_delete_rx_op(struct list_head *ops, struct bcm_msg_head *mh,
 				can_rx_unregister(sock_net(op->sk), NULL,
 						  op->can_id,
 						  REGMASK(op->can_id),
+						  false,
 						  bcm_rx_handler, op);
 
 			list_del(&op->list);
@@ -1193,6 +1195,7 @@ static int bcm_rx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 				err = can_rx_register(sock_net(sk), dev,
 						      op->can_id,
 						      REGMASK(op->can_id),
+						      false,
 						      bcm_rx_handler, op,
 						      "bcm", sk);
 
@@ -1202,7 +1205,7 @@ static int bcm_rx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 
 		} else
 			err = can_rx_register(sock_net(sk), NULL, op->can_id,
-					      REGMASK(op->can_id),
+					      REGMASK(op->can_id), false,
 					      bcm_rx_handler, op, "bcm", sk);
 		if (err) {
 			/* this bcm rx op is broken -> remove it */
@@ -1500,7 +1503,7 @@ static int bcm_release(struct socket *sock)
 			}
 		} else
 			can_rx_unregister(net, NULL, op->can_id,
-					  REGMASK(op->can_id),
+					  REGMASK(op->can_id), false,
 					  bcm_rx_handler, op);
 
 		bcm_remove_op(op);
diff --git a/net/can/gw.c b/net/can/gw.c
index ba4124805602..5dbc7b85e0fc 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -567,14 +567,15 @@ static void can_can_gw_rcv(struct sk_buff *skb, void *data)
 static inline int cgw_register_filter(struct net *net, struct cgw_job *gwj)
 {
 	return can_rx_register(net, gwj->src.dev, gwj->ccgw.filter.can_id,
-			       gwj->ccgw.filter.can_mask, can_can_gw_rcv,
-			       gwj, "gw", NULL);
+			       gwj->ccgw.filter.can_mask, false,
+			       can_can_gw_rcv, gwj, "gw", NULL);
 }
 
 static inline void cgw_unregister_filter(struct net *net, struct cgw_job *gwj)
 {
 	can_rx_unregister(net, gwj->src.dev, gwj->ccgw.filter.can_id,
-			  gwj->ccgw.filter.can_mask, can_can_gw_rcv, gwj);
+			  gwj->ccgw.filter.can_mask, false, can_can_gw_rcv,
+			  gwj);
 }
 
 static int cgw_notifier(struct notifier_block *nb,
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 9f94ad3caee9..44d943bbe0b1 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1029,7 +1029,7 @@ static int isotp_release(struct socket *sock)
 			if (dev) {
 				can_rx_unregister(net, dev, so->rxid,
 						  SINGLE_MASK(so->rxid),
-						  isotp_rcv, sk);
+						  false, isotp_rcv, sk);
 				dev_put(dev);
 			}
 		}
@@ -1111,7 +1111,7 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	if (do_rx_reg)
 		can_rx_register(net, dev, addr->can_addr.tp.rx_id,
 				SINGLE_MASK(addr->can_addr.tp.rx_id),
-				isotp_rcv, sk, "isotp", sk);
+				false, isotp_rcv, sk, "isotp", sk);
 
 	dev_put(dev);
 
@@ -1122,7 +1122,7 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 			if (dev) {
 				can_rx_unregister(net, dev, so->rxid,
 						  SINGLE_MASK(so->rxid),
-						  isotp_rcv, sk);
+						  false, isotp_rcv, sk);
 				dev_put(dev);
 			}
 		}
@@ -1323,7 +1323,7 @@ static int isotp_notifier(struct notifier_block *nb, unsigned long msg,
 		if (so->bound && (!(so->opt.flags & CAN_ISOTP_SF_BROADCAST)))
 			can_rx_unregister(dev_net(dev), dev, so->rxid,
 					  SINGLE_MASK(so->rxid),
-					  isotp_rcv, sk);
+					  false, isotp_rcv, sk);
 
 		so->ifindex = 0;
 		so->bound  = 0;
diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index da3a7a7bcff2..466a20c76fb6 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -177,7 +177,7 @@ static int j1939_can_rx_register(struct j1939_priv *priv)
 
 	j1939_priv_get(priv);
 	ret = can_rx_register(dev_net(ndev), ndev, J1939_CAN_ID, J1939_CAN_MASK,
-			      j1939_can_recv, priv, "j1939", NULL);
+			      false, j1939_can_recv, priv, "j1939", NULL);
 	if (ret < 0) {
 		j1939_priv_put(priv);
 		return ret;
@@ -191,7 +191,7 @@ static void j1939_can_rx_unregister(struct j1939_priv *priv)
 	struct net_device *ndev = priv->ndev;
 
 	can_rx_unregister(dev_net(ndev), ndev, J1939_CAN_ID, J1939_CAN_MASK,
-			  j1939_can_recv, priv);
+			  false, j1939_can_recv, priv);
 
 	j1939_priv_put(priv);
 }
diff --git a/net/can/proc.c b/net/can/proc.c
index d1fe49e6f16d..d312077832a6 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -191,11 +191,12 @@ static void can_print_rcvlist(struct seq_file *m, struct hlist_head *rx_list,
 
 	hlist_for_each_entry_rcu(r, rx_list, list) {
 		char *fmt = (r->can_id & CAN_EFF_FLAG)?
-			"   %-5s  %08x  %08x  %pK  %pK  %8ld  %s\n" :
-			"   %-5s     %03x    %08x  %pK  %pK  %8ld  %s\n";
+			"   %-5s  %08x  %08x   %c   %pK  %pK  %8ld  %s\n" :
+			"   %-5s     %03x    %08x   %c   %pK  %pK  %8ld  %s\n";
 
 		seq_printf(m, fmt, DNAME(dev), r->can_id, r->mask,
-				r->func, r->data, r->matches, r->ident);
+				r->match_sk ? '*' : ' ', r->func, r->data,
+				r->matches, r->ident);
 	}
 }
 
@@ -206,9 +207,9 @@ static void can_print_recv_banner(struct seq_file *m)
 	 *                 .......          0  tp20
 	 */
 	if (IS_ENABLED(CONFIG_64BIT))
-		seq_puts(m, "  device   can_id   can_mask      function          userdata       matches  ident\n");
+		seq_puts(m, "  device   can_id   can_mask  own      function          userdata       matches  ident\n");
 	else
-		seq_puts(m, "  device   can_id   can_mask  function  userdata   matches  ident\n");
+		seq_puts(m, "  device   can_id   can_mask  own  function  userdata   matches  ident\n");
 }
 
 static int can_stats_proc_show(struct seq_file *m, void *v)
diff --git a/net/can/raw.c b/net/can/raw.c
index 139d9471ddcf..acfbae28d451 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -187,13 +187,13 @@ static int raw_enable_filters(struct net *net, struct net_device *dev,
 
 	for (i = 0; i < count; i++) {
 		err = can_rx_register(net, dev, filter[i].can_id,
-				      filter[i].can_mask,
+				      filter[i].can_mask, false,
 				      raw_rcv, sk, "raw", sk);
 		if (err) {
 			/* clean up successfully registered filters */
 			while (--i >= 0)
 				can_rx_unregister(net, dev, filter[i].can_id,
-						  filter[i].can_mask,
+						  filter[i].can_mask, false,
 						  raw_rcv, sk);
 			break;
 		}
@@ -209,7 +209,7 @@ static int raw_enable_errfilter(struct net *net, struct net_device *dev,
 
 	if (err_mask)
 		err = can_rx_register(net, dev, 0, err_mask | CAN_ERR_FLAG,
-				      raw_rcv, sk, "raw", sk);
+				      false, raw_rcv, sk, "raw", sk);
 
 	return err;
 }
@@ -222,7 +222,7 @@ static void raw_disable_filters(struct net *net, struct net_device *dev,
 
 	for (i = 0; i < count; i++)
 		can_rx_unregister(net, dev, filter[i].can_id,
-				  filter[i].can_mask, raw_rcv, sk);
+				  filter[i].can_mask, false, raw_rcv, sk);
 }
 
 static inline void raw_disable_errfilter(struct net *net,
@@ -233,7 +233,7 @@ static inline void raw_disable_errfilter(struct net *net,
 {
 	if (err_mask)
 		can_rx_unregister(net, dev, 0, err_mask | CAN_ERR_FLAG,
-				  raw_rcv, sk);
+				  false, raw_rcv, sk);
 }
 
 static inline void raw_disable_allfilters(struct net *net,
-- 
2.31.1

