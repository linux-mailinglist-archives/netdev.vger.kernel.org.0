Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D0936A712
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 14:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhDYMP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 08:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhDYMP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 08:15:28 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC225C061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 05:14:47 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id l22so53442947ljc.9
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 05:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flodin-me.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jf2xAu4iyXP92tkgTrL/Ng80d8omZjIG2kpXpSSVHUo=;
        b=RNe0QKD7TRzKtKHVS12G6H9WXd5wZ6/jdwbuxFp7VD+X7hbY+yTzk2Y4m1HBADmY3h
         SfCt468obJbIb5blr7MKWYq1zQ3VyW4/WvUTtHZvlS5QE9rVIBqh8i9aV4K6U3z4YG0v
         k8EUvJ6U8shfa7nbkDypsqYP3wDa2x45DZX5y/bBiUquwbn5Sgg2VHc8lTU9bJw7yoPU
         WzCXNA38lwWC0I/SrZqm1eRVn4yoRq2ERpSBZYecJJTMV1auVIq1zBElP6f4tAO2LG40
         iBlEBXu9YiD2w8xNBf3WK3AjEP+VBIU25C9trNDiyybaFsc3aLWNOMS9rFohSsaSVqOD
         Rzog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jf2xAu4iyXP92tkgTrL/Ng80d8omZjIG2kpXpSSVHUo=;
        b=pRvXg46A/RzUgXWrO8MhfvGbIXpd4xPBoDCugEStz46GnvjD+ifty/DU+ij/okMJSD
         G4tIvTD+4L9dWpgG085H1YEhrprAGvOm7StMpF7VqhmZ9bUDpMxyvJa6PtqCQkEnDVIU
         M48eazQ9MNDEeFTtEpPxNs6ZjWtJCRxDnNAz6x2R+WIW8O9ftEk01xXx5fw+9wCyA6wP
         irG3jfj/87tRiAWzlTWQP0AtNSdSNQG20LMH1ZEzOTY2s9nDPXYnJTZ93wNR9neJlKQa
         5pg+1REbT2NsjG6kY53IuH42U9Mls5P5GJTBUtrB3PinG/yjTlJ8olsUWY4RnMJHraen
         H6Cw==
X-Gm-Message-State: AOAM532wFH9xZai8qxxhPR7CUGvuB80iWB/Y3KeNOKRkZvNmVJ7S/r+7
        W96t5WXM01ykAL8DqlHJ8M2nXQ==
X-Google-Smtp-Source: ABdhPJwthRwCukbeRdgxY9KzpcT6/CF6QLIM9v4bkZdRA7xFk2iMAJunZbzicnyVhFwp1oZ3xSnG3A==
X-Received: by 2002:a2e:a491:: with SMTP id h17mr6373152lji.236.1619352886342;
        Sun, 25 Apr 2021 05:14:46 -0700 (PDT)
Received: from trillian.bjorktomta.lan (h-158-174-77-132.NA.cust.bahnhof.se. [158.174.77.132])
        by smtp.gmail.com with ESMTPSA id w16sm1120049lfu.160.2021.04.25.05.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 05:14:46 -0700 (PDT)
From:   Erik Flodin <erik@flodin.me>
To:     socketcan@hartkopp.net, mkl@pengutronix.de
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, Erik Flodin <erik@flodin.me>
Subject: [PATCH 2/2] can: raw: add CAN_RAW_RECV_OWN_MSGS_ALL socket option
Date:   Sun, 25 Apr 2021 14:12:44 +0200
Message-Id: <20210425121244.217680-3-erik@flodin.me>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210425121244.217680-1-erik@flodin.me>
References: <20210425121244.217680-1-erik@flodin.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CAN_RAW_RECV_OWN_MSGS_ALL works as CAN_RAW_RECV_OWN_MSGS with the
difference that all sent frames are received as no filtering is applied
on the socket's own frames in this case.

Signed-off-by: Erik Flodin <erik@flodin.me>
---
 Documentation/networking/can.rst |  7 +++
 include/uapi/linux/can/raw.h     | 18 ++++---
 net/can/raw.c                    | 91 +++++++++++++++++++++++++++-----
 3 files changed, 95 insertions(+), 21 deletions(-)

diff --git a/Documentation/networking/can.rst b/Documentation/networking/can.rst
index f8dae662e454..86f5c4963d90 100644
--- a/Documentation/networking/can.rst
+++ b/Documentation/networking/can.rst
@@ -609,6 +609,13 @@ demand:
                &recv_own_msgs, sizeof(recv_own_msgs));
 
 
+RAW socket option CAN_RAW_RECV_OWN_MSGS_ALL
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Identical to CAN_RAW_RECV_OWN_MSGS except that all sent messages are
+received. I.e. reception is not subject to filtering.
+
+
 .. _socketcan-rawfd:
 
 RAW Socket Option CAN_RAW_FD_FRAMES
diff --git a/include/uapi/linux/can/raw.h b/include/uapi/linux/can/raw.h
index 3386aa81fdf2..6e29b2b145e2 100644
--- a/include/uapi/linux/can/raw.h
+++ b/include/uapi/linux/can/raw.h
@@ -53,15 +53,17 @@ enum {
 	SCM_CAN_RAW_ERRQUEUE = 1,
 };
 
-/* for socket options affecting the socket (not the global system) */
-
+/* For socket options affecting the socket (not the global system).
+ * Options default to off unless noted otherwise.
+ */
 enum {
-	CAN_RAW_FILTER = 1,	/* set 0 .. n can_filter(s)          */
-	CAN_RAW_ERR_FILTER,	/* set filter for error frames       */
-	CAN_RAW_LOOPBACK,	/* local loopback (default:on)       */
-	CAN_RAW_RECV_OWN_MSGS,	/* receive my own msgs (default:off) */
-	CAN_RAW_FD_FRAMES,	/* allow CAN FD frames (default:off) */
-	CAN_RAW_JOIN_FILTERS,	/* all filters must match to trigger */
+	CAN_RAW_FILTER = 1,	   /* set 0 .. n can_filter(s)          */
+	CAN_RAW_ERR_FILTER,	   /* set filter for error frames       */
+	CAN_RAW_LOOPBACK,	   /* local loopback (default on)       */
+	CAN_RAW_RECV_OWN_MSGS,	   /* receive my own msgs w/ filtering  */
+	CAN_RAW_FD_FRAMES,	   /* allow CAN FD frames               */
+	CAN_RAW_JOIN_FILTERS,	   /* all filters must match to trigger */
+	CAN_RAW_RECV_OWN_MSGS_ALL, /* receive my own msgs w/o filtering */
 };
 
 #endif /* !_UAPI_CAN_RAW_H */
diff --git a/net/can/raw.c b/net/can/raw.c
index 1b6092a0914f..2f5461de5058 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -84,6 +84,7 @@ struct raw_sock {
 	struct notifier_block notifier;
 	int loopback;
 	int recv_own_msgs;
+	int recv_own_msgs_all;
 	int fd_frames;
 	int join_filters;
 	int count;                 /* number of active filters */
@@ -120,7 +121,7 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 	unsigned int *pflags;
 
 	/* check the received tx sock reference */
-	if (!ro->recv_own_msgs && oskb->sk == sk)
+	if (!ro->recv_own_msgs && !ro->recv_own_msgs_all && oskb->sk == sk)
 		return;
 
 	/* do not pass non-CAN2.0 frames to a legacy socket */
@@ -130,7 +131,8 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 	/* eliminate multiple filter matches for the same skb */
 	if (this_cpu_ptr(ro->uniq)->skb == oskb &&
 	    this_cpu_ptr(ro->uniq)->skbcnt == can_skb_prv(oskb)->skbcnt) {
-		if (ro->join_filters) {
+		if (ro->join_filters &&
+		    (!ro->recv_own_msgs_all || oskb->sk != sk)) {
 			this_cpu_inc(ro->uniq->join_rx_count);
 			/* drop frame until all enabled filters matched */
 			if (this_cpu_ptr(ro->uniq)->join_rx_count < ro->count)
@@ -143,8 +145,10 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 		this_cpu_ptr(ro->uniq)->skbcnt = can_skb_prv(oskb)->skbcnt;
 		this_cpu_ptr(ro->uniq)->join_rx_count = 1;
 		/* drop first frame to check all enabled filters? */
-		if (ro->join_filters && ro->count > 1)
+		if (ro->join_filters && ro->count > 1 &&
+		    (!ro->recv_own_msgs_all || oskb->sk != sk)) {
 			return;
+		}
 	}
 
 	/* clone the given skb to be able to enqueue it into the rcv queue */
@@ -212,6 +216,18 @@ static int raw_enable_errfilter(struct net *net, struct net_device *dev,
 	return err;
 }
 
+static int raw_enable_ownfilter(struct net *net, struct net_device *dev,
+				struct sock *sk, bool recv_own_msgs_all)
+{
+	int err = 0;
+
+	if (recv_own_msgs_all)
+		err = can_rx_register(net, dev, 0, MASK_ALL, true, raw_rcv,
+				      sk, "raw", sk);
+
+	return err;
+}
+
 static void raw_disable_filters(struct net *net, struct net_device *dev,
 				struct sock *sk, struct can_filter *filter,
 				int count)
@@ -234,6 +250,13 @@ static inline void raw_disable_errfilter(struct net *net,
 				  false, raw_rcv, sk);
 }
 
+static void raw_disable_ownfilter(struct net *net, struct net_device *dev,
+				  struct sock *sk, bool recv_own_msgs_all)
+{
+	if (recv_own_msgs_all)
+		can_rx_unregister(net, dev, 0, MASK_ALL, true, raw_rcv, sk);
+}
+
 static inline void raw_disable_allfilters(struct net *net,
 					  struct net_device *dev,
 					  struct sock *sk)
@@ -242,6 +265,7 @@ static inline void raw_disable_allfilters(struct net *net,
 
 	raw_disable_filters(net, dev, sk, ro->filter, ro->count);
 	raw_disable_errfilter(net, dev, sk, ro->err_mask);
+	raw_disable_ownfilter(net, dev, sk, ro->recv_own_msgs_all);
 }
 
 static int raw_enable_allfilters(struct net *net, struct net_device *dev,
@@ -251,13 +275,19 @@ static int raw_enable_allfilters(struct net *net, struct net_device *dev,
 	int err;
 
 	err = raw_enable_filters(net, dev, sk, ro->filter, ro->count);
-	if (!err) {
-		err = raw_enable_errfilter(net, dev, sk, ro->err_mask);
-		if (err)
-			raw_disable_filters(net, dev, sk, ro->filter,
-					    ro->count);
-	}
+	if (err)
+		goto out;
+	err = raw_enable_errfilter(net, dev, sk, ro->err_mask);
+	if (err)
+		goto out_disable;
+	err = raw_enable_ownfilter(net, dev, sk, ro->recv_own_msgs_all);
+	if (!err)
+		goto out;
 
+	raw_disable_errfilter(net, dev, sk, ro->err_mask);
+out_disable:
+	raw_disable_filters(net, dev, sk, ro->filter, ro->count);
+out:
 	return err;
 }
 
@@ -321,10 +351,11 @@ static int raw_init(struct sock *sk)
 	ro->count            = 1;
 
 	/* set default loopback behaviour */
-	ro->loopback         = 1;
-	ro->recv_own_msgs    = 0;
-	ro->fd_frames        = 0;
-	ro->join_filters     = 0;
+	ro->loopback          = 1;
+	ro->recv_own_msgs     = 0;
+	ro->recv_own_msgs_all = 0;
+	ro->fd_frames         = 0;
+	ro->join_filters      = 0;
 
 	/* alloc_percpu provides zero'ed memory */
 	ro->uniq = alloc_percpu(struct uniqframe);
@@ -493,6 +524,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 	can_err_mask_t err_mask = 0;
 	int count = 0;
 	int err = 0;
+	int old_val;
 
 	if (level != SOL_CAN_RAW)
 		return -EINVAL;
@@ -637,6 +669,33 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 
 		break;
 
+	case CAN_RAW_RECV_OWN_MSGS_ALL:
+		if (optlen != sizeof(ro->recv_own_msgs_all))
+			return -EINVAL;
+
+		old_val = ro->recv_own_msgs_all;
+		if (copy_from_sockptr(&ro->recv_own_msgs_all, optval, optlen))
+			return -EFAULT;
+
+		lock_sock(sk);
+
+		if (ro->bound && ro->ifindex)
+			dev = dev_get_by_index(sock_net(sk), ro->ifindex);
+
+		if (ro->bound) {
+			if (old_val && !ro->recv_own_msgs_all)
+				raw_disable_ownfilter(sock_net(sk), dev, sk, true);
+			else if (!old_val && ro->recv_own_msgs_all)
+				err = raw_enable_ownfilter(sock_net(sk), dev, sk, true);
+		}
+
+		if (dev)
+			dev_put(dev);
+
+		release_sock(sk);
+
+		break;
+
 	default:
 		return -ENOPROTOOPT;
 	}
@@ -708,6 +767,12 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 		val = &ro->join_filters;
 		break;
 
+	case CAN_RAW_RECV_OWN_MSGS_ALL:
+		if (len > sizeof(int))
+			len = sizeof(int);
+		val = &ro->recv_own_msgs_all;
+		break;
+
 	default:
 		return -ENOPROTOOPT;
 	}
-- 
2.31.0

