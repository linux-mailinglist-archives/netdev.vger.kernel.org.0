Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21B64BA386
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242134AbiBQOtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:49:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242132AbiBQOtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:49:41 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4F921D0A3
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 06:49:26 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21H9HulU005574;
        Thu, 17 Feb 2022 06:49:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=9iWDxfc95PZ6IETH/zLMhb28iTBoqoFy/PFMZVuC1jE=;
 b=BG4NI6OIY1HjGHqljYS7eVXcY9ZDN1ghCfhv8AVtVIIAG845RdRpD8JuLLdhXAs2D8aK
 kQThcA0kQzuvGfim3bF1Rfp0DY5PKXFCAk94j8NMcLu+8TUrubwPNh6Di7vnvyYaZSBq
 sNIYFGgMywMvQdvClnlOrRLf3JNoo3BDFMQYCpttxckCIyTBmHMk/w8kfn8x+Ur8ySzC
 njiGHLzH7GQ8Yt+bH/Za7LLOwhYIhKJfyESD6miPjoHar3upTn1HKVlwp+QA5yT7Q/Ou
 OjD0orgVsXLcoRlQHEnQYUc+ji2aSzNacwwzWBb0SN6DIyFTfXCEPyH46xVA23YwRZZu wQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3e9kkts6ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 06:49:16 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 06:49:14 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Feb 2022 06:49:14 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 3C1833F704D;
        Thu, 17 Feb 2022 06:49:12 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 1/2] ethtool: add support to set/get completion event size
Date:   Thu, 17 Feb 2022 20:19:05 +0530
Message-ID: <1645109346-27600-2-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1645109346-27600-1-git-send-email-sbhatta@marvell.com>
References: <1645109346-27600-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: CoaKUWDkIOskwsyzJLo_yYA3nHm2Asmz
X-Proofpoint-GUID: CoaKUWDkIOskwsyzJLo_yYA3nHm2Asmz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to set completion event size via ethtool -G
parameter and get it via ethtool -g parameter.

~ # ./ethtool -G eth0 ce-size 512
~ # ./ethtool -g eth0
Ring parameters for eth0:
Pre-set maximums:
RX:             1048576
RX Mini:        n/a
RX Jumbo:       n/a
TX:             1048576
Current hardware settings:
RX:             256
RX Mini:        n/a
RX Jumbo:       n/a
TX:             4096
RX Buf Len:             2048
CE Size:                128

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 Documentation/networking/ethtool-netlink.rst |  2 ++
 include/linux/ethtool.h                      |  3 +++
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/netlink.h                        |  2 +-
 net/ethtool/rings.c                          | 19 +++++++++++++++++--
 5 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index cae28af..e159805 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -861,6 +861,7 @@ Kernel response contents:
   ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
   ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
   ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT``    u8      TCP header / data split
+  ``ETHTOOL_A_RINGS_CE_SIZE``           u32     TX/RX completion event size
   ====================================  ======  ===========================
 
 ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT`` indicates whether the device is usable with
@@ -885,6 +886,7 @@ Request contents:
   ``ETHTOOL_A_RINGS_RX_JUMBO``          u32     size of RX jumbo ring
   ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
   ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
+  ``ETHTOOL_A_RINGS_CE_SIZE``           u32     TX/RX completion event size
   ====================================  ======  ===========================
 
 Kernel checks that requested ring sizes do not exceed limits reported by
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index e0853f4..e3979aa 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -71,10 +71,12 @@ enum {
  * struct kernel_ethtool_ringparam - RX/TX ring configuration
  * @rx_buf_len: Current length of buffers on the rx ring.
  * @tcp_data_split: Scatter packet headers and data to separate buffers
+ * @ce_size: Size of TX/RX completion event
  */
 struct kernel_ethtool_ringparam {
 	u32	rx_buf_len;
 	u8	tcp_data_split;
+	u32	ce_size;
 };
 
 /**
@@ -83,6 +85,7 @@ struct kernel_ethtool_ringparam {
  */
 enum ethtool_supported_ring_param {
 	ETHTOOL_RING_USE_RX_BUF_LEN = BIT(0),
+	ETHTOOL_RING_USE_CE_SIZE    = BIT(1),
 };
 
 #define __ETH_RSS_HASH_BIT(bit)	((u32)1 << (bit))
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 417d428..15fed00 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -337,6 +337,7 @@ enum {
 	ETHTOOL_A_RINGS_TX,				/* u32 */
 	ETHTOOL_A_RINGS_RX_BUF_LEN,                     /* u32 */
 	ETHTOOL_A_RINGS_TCP_DATA_SPLIT,			/* u8 */
+	ETHTOOL_A_RINGS_CE_SIZE,			/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_RINGS_CNT,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 75856db..b7fac61 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -363,7 +363,7 @@ extern const struct nla_policy ethnl_features_set_policy[ETHTOOL_A_FEATURES_WANT
 extern const struct nla_policy ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_HEADER + 1];
 extern const struct nla_policy ethnl_privflags_set_policy[ETHTOOL_A_PRIVFLAGS_FLAGS + 1];
 extern const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_HEADER + 1];
-extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_RX_BUF_LEN + 1];
+extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_CE_SIZE + 1];
 extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_HEADER + 1];
 extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_COMBINED_COUNT + 1];
 extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_HEADER + 1];
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 18a5035..2778368 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -54,7 +54,8 @@ static int rings_reply_size(const struct ethnl_req_info *req_base,
 	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX_JUMBO */
 	       nla_total_size(sizeof(u32)) +	/* _RINGS_TX */
 	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX_BUF_LEN */
-	       nla_total_size(sizeof(u8));	/* _RINGS_TCP_DATA_SPLIT */
+	       nla_total_size(sizeof(u8))  +	/* _RINGS_TCP_DATA_SPLIT */
+	       nla_total_size(sizeof(u32));	/* _RINGS_CE_SIZE */
 }
 
 static int rings_fill_reply(struct sk_buff *skb,
@@ -91,7 +92,9 @@ static int rings_fill_reply(struct sk_buff *skb,
 	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_BUF_LEN, kr->rx_buf_len))) ||
 	    (kr->tcp_data_split &&
 	     (nla_put_u8(skb, ETHTOOL_A_RINGS_TCP_DATA_SPLIT,
-			 kr->tcp_data_split))))
+			 kr->tcp_data_split))) ||
+	    (kr->ce_size &&
+	     (nla_put_u32(skb, ETHTOOL_A_RINGS_CE_SIZE, kr->ce_size))))
 		return -EMSGSIZE;
 
 	return 0;
@@ -119,6 +122,7 @@ const struct nla_policy ethnl_rings_set_policy[] = {
 	[ETHTOOL_A_RINGS_RX_JUMBO]		= { .type = NLA_U32 },
 	[ETHTOOL_A_RINGS_TX]			= { .type = NLA_U32 },
 	[ETHTOOL_A_RINGS_RX_BUF_LEN]            = NLA_POLICY_MIN(NLA_U32, 1),
+	[ETHTOOL_A_RINGS_CE_SIZE]		= NLA_POLICY_MIN(NLA_U32, 1),
 };
 
 int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
@@ -159,6 +163,8 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 	ethnl_update_u32(&ringparam.tx_pending, tb[ETHTOOL_A_RINGS_TX], &mod);
 	ethnl_update_u32(&kernel_ringparam.rx_buf_len,
 			 tb[ETHTOOL_A_RINGS_RX_BUF_LEN], &mod);
+	ethnl_update_u32(&kernel_ringparam.ce_size,
+			 tb[ETHTOOL_A_RINGS_CE_SIZE], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
@@ -190,6 +196,15 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 	}
 
+	if (kernel_ringparam.ce_size &&
+	    !(ops->supported_ring_params & ETHTOOL_RING_USE_CE_SIZE)) {
+		ret = -EOPNOTSUPP;
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[ETHTOOL_A_RINGS_CE_SIZE],
+				    "setting ce size not supported");
+		goto out_ops;
+	}
+
 	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam,
 					      &kernel_ringparam, info->extack);
 	if (ret < 0)
-- 
2.7.4

