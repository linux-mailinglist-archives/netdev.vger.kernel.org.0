Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484BE6B2503
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCINOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjCINOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:14:06 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C763DDF0E
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 05:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678367644; x=1709903644;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nxxv3C/m1hZEyXxWe89IvQ81VZgCpfQmtgLVw2eXP0g=;
  b=Kw1pjMu88aKElmqki17iQXJ4qWCkK8TUYBtO5N33I6qcZoRFHV1XIKQd
   c+5ucD4gT4FRHZnhk9rUYbPcXcWqgsn0363FtFMHe1gQDf86/5Jqw+CVq
   YhhstC098Zlhv0cW65sOBKj1L2XXqYZqnBRAXRpKx52+Rlf9cMPFz4I7z
   k=;
X-IronPort-AV: E=Sophos;i="5.98,246,1673913600"; 
   d="scan'208";a="305331578"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-00fceed5.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 13:14:01 +0000
Received: from EX19D010EUA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-00fceed5.us-east-1.amazon.com (Postfix) with ESMTPS id 255C5A03BB;
        Thu,  9 Mar 2023 13:13:59 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D010EUA002.ant.amazon.com (10.252.50.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 9 Mar 2023 13:13:58 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.174) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 9 Mar 2023 13:13:50 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: [PATCH v4 net-next 1/5] ethtool: Add support for configuring tx_push_buf_len
Date:   Thu, 9 Mar 2023 15:13:15 +0200
Message-ID: <20230309131319.2531008-2-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230309131319.2531008-1-shayagr@amazon.com>
References: <20230309131319.2531008-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.174]
X-ClientProxiedBy: EX19D044UWA002.ant.amazon.com (10.13.139.11) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This attribute, which is part of ethtool's ring param configuration
allows the user to specify the maximum number of the packet's payload
that can be written directly to the device.

Example usage:
    # ethtool -G [interface] tx-push-buf-len [number of bytes]

Co-developed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 Documentation/netlink/specs/ethtool.yaml     |  8 ++++
 Documentation/networking/ethtool-netlink.rst | 43 ++++++++++++--------
 include/linux/ethtool.h                      | 14 +++++--
 include/uapi/linux/ethtool_netlink.h         |  2 +
 net/ethtool/netlink.h                        |  2 +-
 net/ethtool/rings.c                          | 33 ++++++++++++++-
 6 files changed, 79 insertions(+), 23 deletions(-)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 08b776908d15..244864c96feb 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -174,6 +174,12 @@ attribute-sets:
       -
         name: rx-push
         type: u8
+      -
+        name: tx-push-buf-len
+        type: u32
+      -
+        name: tx-push-buf-len-max
+        type: u32
 
   -
     name: mm-stat
@@ -324,6 +330,8 @@ operations:
             - cqe-size
             - tx-push
             - rx-push
+            - tx-push-buf-len
+            - tx-push-buf-len-max
       dump: *ring-get-op
     -
       name: rings-set
diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index e1bc6186d7ea..1aa09e7e8dcc 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -860,22 +860,24 @@ Request contents:
 
 Kernel response contents:
 
-  ====================================  ======  ===========================
-  ``ETHTOOL_A_RINGS_HEADER``            nested  reply header
-  ``ETHTOOL_A_RINGS_RX_MAX``            u32     max size of RX ring
-  ``ETHTOOL_A_RINGS_RX_MINI_MAX``       u32     max size of RX mini ring
-  ``ETHTOOL_A_RINGS_RX_JUMBO_MAX``      u32     max size of RX jumbo ring
-  ``ETHTOOL_A_RINGS_TX_MAX``            u32     max size of TX ring
-  ``ETHTOOL_A_RINGS_RX``                u32     size of RX ring
-  ``ETHTOOL_A_RINGS_RX_MINI``           u32     size of RX mini ring
-  ``ETHTOOL_A_RINGS_RX_JUMBO``          u32     size of RX jumbo ring
-  ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
-  ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
-  ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT``    u8      TCP header / data split
-  ``ETHTOOL_A_RINGS_CQE_SIZE``          u32     Size of TX/RX CQE
-  ``ETHTOOL_A_RINGS_TX_PUSH``           u8      flag of TX Push mode
-  ``ETHTOOL_A_RINGS_RX_PUSH``           u8      flag of RX Push mode
-  ====================================  ======  ===========================
+  =======================================   ======  ===========================
+  ``ETHTOOL_A_RINGS_HEADER``                nested  reply header
+  ``ETHTOOL_A_RINGS_RX_MAX``                u32     max size of RX ring
+  ``ETHTOOL_A_RINGS_RX_MINI_MAX``           u32     max size of RX mini ring
+  ``ETHTOOL_A_RINGS_RX_JUMBO_MAX``          u32     max size of RX jumbo ring
+  ``ETHTOOL_A_RINGS_TX_MAX``                u32     max size of TX ring
+  ``ETHTOOL_A_RINGS_RX``                    u32     size of RX ring
+  ``ETHTOOL_A_RINGS_RX_MINI``               u32     size of RX mini ring
+  ``ETHTOOL_A_RINGS_RX_JUMBO``              u32     size of RX jumbo ring
+  ``ETHTOOL_A_RINGS_TX``                    u32     size of TX ring
+  ``ETHTOOL_A_RINGS_RX_BUF_LEN``            u32     size of buffers on the ring
+  ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT``        u8      TCP header / data split
+  ``ETHTOOL_A_RINGS_CQE_SIZE``              u32     Size of TX/RX CQE
+  ``ETHTOOL_A_RINGS_TX_PUSH``               u8      flag of TX Push mode
+  ``ETHTOOL_A_RINGS_RX_PUSH``               u8      flag of RX Push mode
+  ``ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN``       u32     size of TX push buffer
+  ``ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX``   u32     max size of TX push buffer
+  =======================================   ======  ===========================
 
 ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT`` indicates whether the device is usable with
 page-flipping TCP zero-copy receive (``getsockopt(TCP_ZEROCOPY_RECEIVE)``).
@@ -891,6 +893,14 @@ through MMIO writes, thus reducing the latency. However, enabling this feature
 may increase the CPU cost. Drivers may enforce additional per-packet
 eligibility checks (e.g. on packet size).
 
+``ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN`` specifies the maximum number of bytes of a
+transmitted packet a driver can push directly to the underlying device
+('push' mode). Pushing some of the payload bytes to the device has the
+advantages of reducing latency for small packets by avoiding DMA mapping (same
+as ``ETHTOOL_A_RINGS_TX_PUSH`` parameter) as well as allowing the underlying
+device to process packet headers ahead of fetching its payload.
+This can help the device to make fast actions based on the packet's headers.
+
 RINGS_SET
 =========
 
@@ -908,6 +918,7 @@ Request contents:
   ``ETHTOOL_A_RINGS_CQE_SIZE``          u32     Size of TX/RX CQE
   ``ETHTOOL_A_RINGS_TX_PUSH``           u8      flag of TX Push mode
   ``ETHTOOL_A_RINGS_RX_PUSH``           u8      flag of RX Push mode
+  ``ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN``   u32     size of TX push buffer
   ====================================  ======  ===========================
 
 Kernel checks that requested ring sizes do not exceed limits reported by
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 2792185dda22..798d35890118 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -75,6 +75,8 @@ enum {
  * @tx_push: The flag of tx push mode
  * @rx_push: The flag of rx push mode
  * @cqe_size: Size of TX/RX completion queue event
+ * @tx_push_buf_len: Size of TX push buffer
+ * @tx_push_buf_max_len: Maximum allowed size of TX push buffer
  */
 struct kernel_ethtool_ringparam {
 	u32	rx_buf_len;
@@ -82,6 +84,8 @@ struct kernel_ethtool_ringparam {
 	u8	tx_push;
 	u8	rx_push;
 	u32	cqe_size;
+	u32	tx_push_buf_len;
+	u32	tx_push_buf_max_len;
 };
 
 /**
@@ -90,12 +94,14 @@ struct kernel_ethtool_ringparam {
  * @ETHTOOL_RING_USE_CQE_SIZE: capture for setting cqe_size
  * @ETHTOOL_RING_USE_TX_PUSH: capture for setting tx_push
  * @ETHTOOL_RING_USE_RX_PUSH: capture for setting rx_push
+ * @ETHTOOL_RING_USE_TX_PUSH_BUF_LEN: capture for setting tx_push_buf_len
  */
 enum ethtool_supported_ring_param {
-	ETHTOOL_RING_USE_RX_BUF_LEN = BIT(0),
-	ETHTOOL_RING_USE_CQE_SIZE   = BIT(1),
-	ETHTOOL_RING_USE_TX_PUSH    = BIT(2),
-	ETHTOOL_RING_USE_RX_PUSH    = BIT(3),
+	ETHTOOL_RING_USE_RX_BUF_LEN		= BIT(0),
+	ETHTOOL_RING_USE_CQE_SIZE		= BIT(1),
+	ETHTOOL_RING_USE_TX_PUSH		= BIT(2),
+	ETHTOOL_RING_USE_RX_PUSH		= BIT(3),
+	ETHTOOL_RING_USE_TX_PUSH_BUF_LEN	= BIT(4),
 };
 
 #define __ETH_RSS_HASH_BIT(bit)	((u32)1 << (bit))
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index d39ce21381c5..1ebf8d455f07 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -357,6 +357,8 @@ enum {
 	ETHTOOL_A_RINGS_CQE_SIZE,			/* u32 */
 	ETHTOOL_A_RINGS_TX_PUSH,			/* u8 */
 	ETHTOOL_A_RINGS_RX_PUSH,			/* u8 */
+	ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN,		/* u32 */
+	ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX,		/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_RINGS_CNT,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index f7b189ed96b2..79424b34b553 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -413,7 +413,7 @@ extern const struct nla_policy ethnl_features_set_policy[ETHTOOL_A_FEATURES_WANT
 extern const struct nla_policy ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_HEADER + 1];
 extern const struct nla_policy ethnl_privflags_set_policy[ETHTOOL_A_PRIVFLAGS_FLAGS + 1];
 extern const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_HEADER + 1];
-extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_RX_PUSH + 1];
+extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX + 1];
 extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_HEADER + 1];
 extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_COMBINED_COUNT + 1];
 extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_HEADER + 1];
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index f358cd57d094..574a6f2e57af 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -11,6 +11,7 @@ struct rings_reply_data {
 	struct ethnl_reply_data		base;
 	struct ethtool_ringparam	ringparam;
 	struct kernel_ethtool_ringparam	kernel_ringparam;
+	u32				supported_ring_params;
 };
 
 #define RINGS_REPDATA(__reply_base) \
@@ -32,6 +33,8 @@ static int rings_prepare_data(const struct ethnl_req_info *req_base,
 
 	if (!dev->ethtool_ops->get_ringparam)
 		return -EOPNOTSUPP;
+
+	data->supported_ring_params = dev->ethtool_ops->supported_ring_params;
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
@@ -57,7 +60,9 @@ static int rings_reply_size(const struct ethnl_req_info *req_base,
 	       nla_total_size(sizeof(u8))  +	/* _RINGS_TCP_DATA_SPLIT */
 	       nla_total_size(sizeof(u32)  +	/* _RINGS_CQE_SIZE */
 	       nla_total_size(sizeof(u8))  +	/* _RINGS_TX_PUSH */
-	       nla_total_size(sizeof(u8)));	/* _RINGS_RX_PUSH */
+	       nla_total_size(sizeof(u8))) +	/* _RINGS_RX_PUSH */
+	       nla_total_size(sizeof(u32)) +	/* _RINGS_TX_PUSH_BUF_LEN */
+	       nla_total_size(sizeof(u32));	/* _RINGS_TX_PUSH_BUF_LEN_MAX */
 }
 
 static int rings_fill_reply(struct sk_buff *skb,
@@ -67,6 +72,7 @@ static int rings_fill_reply(struct sk_buff *skb,
 	const struct rings_reply_data *data = RINGS_REPDATA(reply_base);
 	const struct kernel_ethtool_ringparam *kr = &data->kernel_ringparam;
 	const struct ethtool_ringparam *ringparam = &data->ringparam;
+	u32 supported_ring_params = data->supported_ring_params;
 
 	WARN_ON(kr->tcp_data_split > ETHTOOL_TCP_DATA_SPLIT_ENABLED);
 
@@ -98,7 +104,12 @@ static int rings_fill_reply(struct sk_buff *skb,
 	    (kr->cqe_size &&
 	     (nla_put_u32(skb, ETHTOOL_A_RINGS_CQE_SIZE, kr->cqe_size))) ||
 	    nla_put_u8(skb, ETHTOOL_A_RINGS_TX_PUSH, !!kr->tx_push) ||
-	    nla_put_u8(skb, ETHTOOL_A_RINGS_RX_PUSH, !!kr->rx_push))
+	    nla_put_u8(skb, ETHTOOL_A_RINGS_RX_PUSH, !!kr->rx_push) ||
+	    ((supported_ring_params & ETHTOOL_RING_USE_TX_PUSH_BUF_LEN) &&
+	     (nla_put_u32(skb, ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX,
+			  kr->tx_push_buf_max_len) ||
+	      nla_put_u32(skb, ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN,
+			  kr->tx_push_buf_len))))
 		return -EMSGSIZE;
 
 	return 0;
@@ -117,6 +128,7 @@ const struct nla_policy ethnl_rings_set_policy[] = {
 	[ETHTOOL_A_RINGS_CQE_SIZE]		= NLA_POLICY_MIN(NLA_U32, 1),
 	[ETHTOOL_A_RINGS_TX_PUSH]		= NLA_POLICY_MAX(NLA_U8, 1),
 	[ETHTOOL_A_RINGS_RX_PUSH]		= NLA_POLICY_MAX(NLA_U8, 1),
+	[ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN]	= { .type = NLA_U32 },
 };
 
 static int
@@ -158,6 +170,14 @@ ethnl_set_rings_validate(struct ethnl_req_info *req_info,
 		return -EOPNOTSUPP;
 	}
 
+	if (tb[ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN] &&
+	    !(ops->supported_ring_params & ETHTOOL_RING_USE_TX_PUSH_BUF_LEN)) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN],
+				    "setting tx push buf len is not supported");
+		return -EOPNOTSUPP;
+	}
+
 	return ops->get_ringparam && ops->set_ringparam ? 1 : -EOPNOTSUPP;
 }
 
@@ -189,6 +209,8 @@ ethnl_set_rings(struct ethnl_req_info *req_info, struct genl_info *info)
 			tb[ETHTOOL_A_RINGS_TX_PUSH], &mod);
 	ethnl_update_u8(&kernel_ringparam.rx_push,
 			tb[ETHTOOL_A_RINGS_RX_PUSH], &mod);
+	ethnl_update_u32(&kernel_ringparam.tx_push_buf_len,
+			 tb[ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN], &mod);
 	if (!mod)
 		return 0;
 
@@ -209,6 +231,13 @@ ethnl_set_rings(struct ethnl_req_info *req_info, struct genl_info *info)
 		return -EINVAL;
 	}
 
+	if (kernel_ringparam.tx_push_buf_len > kernel_ringparam.tx_push_buf_max_len) {
+		NL_SET_ERR_MSG_ATTR(info->extack, tb[ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN],
+				    "Requested TX push buffer exceeds maximum");
+
+		return -EINVAL;
+	}
+
 	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam,
 					      &kernel_ringparam, info->extack);
 	return ret < 0 ? ret : 1;
-- 
2.25.1

