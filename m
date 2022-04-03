Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404834F0BA8
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 19:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359716AbiDCR6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 13:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240320AbiDCR6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 13:58:08 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D6738BC5
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 10:56:04 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id i27so8478254ejd.9
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 10:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f6a2ZXW2K0vychsyQbNsHz4PD6ItrRcaItNAke+6Q0s=;
        b=44QPGzoRNmscCxgXfqNl7pINOwqdFty3vVdYHry4mP6KJwfpU18SXUWpXtNdgOPSDm
         W9bmOfNtJi5qbzgClfNeeDMGURpY353UHUHvl6pixfZ/ajYZPJSKEVudBMPcQws/3eWl
         K//1OdLLksCeKBbjEk2D4s6tjgY/oOOlA8276EvryOQunnR8FbB+9RQRqWvLvdnWbAxV
         NJuRKlMfuN4aPC2Dglutwcac2LTjTylxRvTDKOOC43Yvi+nITN3w4mgbLIyFxtIcp1Bs
         2i9Mv8kLmKZ/ZmCTSIPPnV3XCSKv72dveKIkkpx3y4oenqM0vHexSsb1lPvCiefTq25Q
         nRWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f6a2ZXW2K0vychsyQbNsHz4PD6ItrRcaItNAke+6Q0s=;
        b=dhpHmeR7nSlO3WOhHhMwRWJ/m43fxqT0jhjRaTcg6AUg1eFbbO7N/Y5i2CHFn7E7w9
         HpJ42ob02af1OTce7kh3OkG121xave4WTqQdM2NNGBr4bvVeBhqTBq2rUuh2yb4AOTLU
         0wuUc32KEg7rXFpkJPzU0MUPsuzQc6Ff15RV84ywL2qsjJsCBA/cIVIIejyOKIAAcstn
         HM9aeQPKPyi+E3NaTClkPe2HQd03vDN7h/Y9FXd/aWc/tI8EG5pi3oZtKj/QL+PauWXz
         uKpIZA2yT4Id7o1Vmz1ersntxyHofjiFRBS6H6fkFRy/1B3x9SN6xt4LPHB1iNH7wbNf
         RK2Q==
X-Gm-Message-State: AOAM531nPOdwfL5gGprHBoLDT94dGnGuisEE8Y8s2Sv6STL7C+FEYqec
        lk2a5rh+UCRkvL0xXte/riuWrw==
X-Google-Smtp-Source: ABdhPJyQQlYjw9vaDZIDDbR2TuYP3xINBC649e3a4aHK+Kn5bP8Mjbqz9FIyHCC2/rl2sWTkcZprYw==
X-Received: by 2002:a17:907:8d1a:b0:6e0:6db8:8042 with SMTP id tc26-20020a1709078d1a00b006e06db88042mr7851903ejc.300.1649008562958;
        Sun, 03 Apr 2022 10:56:02 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id q7-20020a170906540700b006d5eca5c9cfsm3451065ejo.191.2022.04.03.10.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 10:56:02 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     mlichvar@redhat.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 4/5] ptp: Support late timestamp determination
Date:   Sun,  3 Apr 2022 19:55:43 +0200
Message-Id: <20220403175544.26556-5-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220403175544.26556-1-gerhard@engleder-embedded.com>
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a physical clock supports a free running cycle counter, then
timestamps shall be based on this time too. For TX it is known in
advance before the transmission if a timestamp based on the free running
cycle counter is needed. For RX it is impossible to know which timestamp
is needed before the packet is received and assigned to a socket.

Support late timestamp determination by a network device. Therefore, an
address/cookie is stored within the new netdev_data field of struct
skb_shared_hwtstamps. This address/cookie is provided to a new network
device function called ndo_get_tstamp(), which returns a timestamp based
on the normal/adjustable time or based on the free running cycle
counter. If function is not supported, then timestamp handling is not
changed.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 include/linux/netdevice.h | 21 +++++++++++++++++++++
 include/linux/skbuff.h    | 11 ++++++++---
 net/socket.c              | 30 +++++++++++++++++++-----------
 3 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 59e27a2b7bf0..f6cc4c673082 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1353,6 +1353,12 @@ struct netdev_net_notifier {
  *	The caller must be under RCU read context.
  * int (*ndo_fill_forward_path)(struct net_device_path_ctx *ctx, struct net_device_path *path);
  *     Get the forwarding path to reach the real device from the HW destination address
+ * ktime_t (*ndo_get_tstamp)(struct net_device *dev,
+ *			     const struct skb_shared_hwtstamps *hwtstamps,
+ *			     bool cycles);
+ *	Get hardware timestamp based on normal/adjustable time or free running
+ *	cycle counter. This function is required if physical clock supports a
+ *	free running cycle counter.
  */
 struct net_device_ops {
 	int			(*ndo_init)(struct net_device *dev);
@@ -1570,6 +1576,9 @@ struct net_device_ops {
 	struct net_device *	(*ndo_get_peer_dev)(struct net_device *dev);
 	int                     (*ndo_fill_forward_path)(struct net_device_path_ctx *ctx,
                                                          struct net_device_path *path);
+	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
+						  const struct skb_shared_hwtstamps *hwtstamps,
+						  bool cycles);
 };
 
 /**
@@ -4764,6 +4773,18 @@ static inline void netdev_rx_csum_fault(struct net_device *dev,
 void net_enable_timestamp(void);
 void net_disable_timestamp(void);
 
+static inline ktime_t netdev_get_tstamp(struct net_device *dev,
+					const struct skb_shared_hwtstamps *hwtstamps,
+					bool cycles)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+
+	if (ops->ndo_get_tstamp)
+		return ops->ndo_get_tstamp(dev, hwtstamps, cycles);
+
+	return hwtstamps->hwtstamp;
+}
+
 #ifdef CONFIG_PROC_FS
 int __init dev_proc_init(void);
 #else
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index aeb3ed4d6cf8..c428b678e7f1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -551,8 +551,10 @@ static inline bool skb_frag_must_loop(struct page *p)
 
 /**
  * struct skb_shared_hwtstamps - hardware time stamps
- * @hwtstamp:	hardware time stamp transformed into duration
- *		since arbitrary point in time
+ * @hwtstamp:		hardware time stamp transformed into duration
+ *			since arbitrary point in time
+ * @netdev_data:	address/cookie of network device driver used as
+ *			reference to actual hardware time stamp
  *
  * Software time stamps generated by ktime_get_real() are stored in
  * skb->tstamp.
@@ -564,7 +566,10 @@ static inline bool skb_frag_must_loop(struct page *p)
  * &skb_shared_info. Use skb_hwtstamps() to get a pointer.
  */
 struct skb_shared_hwtstamps {
-	ktime_t	hwtstamp;
+	union {
+		ktime_t	hwtstamp;
+		void *netdev_data;
+	};
 };
 
 /* Definitions for tx_flags in struct skb_shared_info */
diff --git a/net/socket.c b/net/socket.c
index 4801aeaeb285..d64bd3dfcf6a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -805,21 +805,17 @@ static bool skb_is_swtx_tstamp(const struct sk_buff *skb, int false_tstamp)
 	return skb->tstamp && !false_tstamp && skb_is_err_queue(skb);
 }
 
-static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb)
+static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
+			   int if_index)
 {
 	struct scm_ts_pktinfo ts_pktinfo;
-	struct net_device *orig_dev;
 
 	if (!skb_mac_header_was_set(skb))
 		return;
 
 	memset(&ts_pktinfo, 0, sizeof(ts_pktinfo));
 
-	rcu_read_lock();
-	orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
-	if (orig_dev)
-		ts_pktinfo.if_index = orig_dev->ifindex;
-	rcu_read_unlock();
+	ts_pktinfo.if_index = if_index;
 
 	ts_pktinfo.pkt_length = skb->len - skb_mac_offset(skb);
 	put_cmsg(msg, SOL_SOCKET, SCM_TIMESTAMPING_PKTINFO,
@@ -839,6 +835,8 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 	int empty = 1, false_tstamp = 0;
 	struct skb_shared_hwtstamps *shhwtstamps =
 		skb_hwtstamps(skb);
+	struct net_device *orig_dev;
+	int if_index;
 	ktime_t hwtstamp;
 
 	/* Race occurred between timestamp enabling and packet
@@ -887,18 +885,28 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 	if (shhwtstamps &&
 	    (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
 	    !skb_is_swtx_tstamp(skb, false_tstamp)) {
+		rcu_read_lock();
+		orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
+		if (orig_dev) {
+			if_index = orig_dev->ifindex;
+			hwtstamp = netdev_get_tstamp(orig_dev, shhwtstamps,
+						     sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC);
+		} else {
+			if_index = 0;
+			hwtstamp = shhwtstamps->hwtstamp;
+		}
+		rcu_read_unlock();
+
 		if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
-			hwtstamp = ptp_convert_timestamp(&shhwtstamps->hwtstamp,
+			hwtstamp = ptp_convert_timestamp(&hwtstamp,
 							 sk->sk_bind_phc);
-		else
-			hwtstamp = shhwtstamps->hwtstamp;
 
 		if (ktime_to_timespec64_cond(hwtstamp, tss.ts + 2)) {
 			empty = 0;
 
 			if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_PKTINFO) &&
 			    !skb_is_err_queue(skb))
-				put_ts_pktinfo(msg, skb);
+				put_ts_pktinfo(msg, skb, if_index);
 		}
 	}
 	if (!empty) {
-- 
2.20.1

