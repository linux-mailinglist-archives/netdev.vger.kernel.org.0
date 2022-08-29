Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31795A465E
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiH2Jri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiH2Jrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:47:35 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AE62E684
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 02:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661766452; x=1693302452;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xKLv1G8WfQWG4cBP9vyucBTiuVq6O/R1cI+hNgRFNlU=;
  b=BUZLSiYNv+GgB8gAwWj17Fh1NY5uq5SVxD90Tn/X9Fygdn50Ws9pHWso
   t+7bygvQU177MU2VT/nFOYrxpXda0FPCa6OYNv9uruWpYkbdqIGsSGqj6
   y6wt8ZVfJDMl/xi3h+FHw9lyIBkLSKCWQtZwfaZhbGqMo1lHMVCKGp7ws
   PLQq7t5AJlVHqTwbK/D60vR1gYT3tyKJ6roqdCvF86np2kSBEyoh02n1C
   wYA93AMv5it87vLtgrx88nkDlfkU7nZlOP3qloa4tcQPPljZ4zyvVdItD
   2FNP2/u3yr5d8ojWSabIpB/jqZHo4ug8PFaSe9KGYkrWlFXns8IlWh0iR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="356571099"
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="356571099"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 02:47:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="939518682"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 29 Aug 2022 02:47:25 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27T9lK8f021475;
        Mon, 29 Aug 2022 10:47:23 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcin.szycik@linux.intel.com, michal.swiatkowski@linux.intel.com,
        kurt@linutronix.de, boris.sukholitko@broadcom.com,
        vladbu@nvidia.com, komachi.yoshiki@gmail.com, paulb@nvidia.com,
        baowen.zheng@corigine.com, louis.peens@corigine.com,
        simon.horman@corigine.com, pablo@netfilter.org,
        maksym.glubokiy@plvision.eu, intel-wired-lan@lists.osuosl.org,
        jchapman@katalix.com, gnault@redhat.com
Subject: [RFC PATCH net-next v2 2/5] flow_dissector: Add L2TPv3 dissectors
Date:   Mon, 29 Aug 2022 11:44:09 +0200
Message-Id: <20220829094412.554018-3-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220829094412.554018-1-wojciech.drewek@intel.com>
References: <20220829094412.554018-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to dissect L2TPv3 specific field which is:
- session ID (32 bits)

L2TPv3 might be transported over IP or over UDP,
this ipmplementation is only about L2TPv3 over IP.
IP protocold carries L2TPv3 when ip_proto is
IPPROTO_L2TP (115).

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 include/net/flow_dissector.h |  9 +++++++++
 net/core/flow_dissector.c    | 28 ++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 6c74812d64b2..5ccf52ef8809 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -289,6 +289,14 @@ struct flow_dissector_key_pppoe {
 	__be16 type;
 };
 
+/**
+ * struct flow_dissector_key_l2tpv3:
+ * @session_id: identifier for a l2tp session
+ */
+struct flow_dissector_key_l2tpv3 {
+	__be32 session_id;
+};
+
 enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
 	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
@@ -320,6 +328,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_HASH, /* struct flow_dissector_key_hash */
 	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
 	FLOW_DISSECTOR_KEY_PPPOE, /* struct flow_dissector_key_pppoe */
+	FLOW_DISSECTOR_KEY_L2TPV3, /* struct flow_dissector_key_l2tpv3 */
 
 	FLOW_DISSECTOR_KEY_MAX,
 };
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 764c4cb3fe8f..dbd944de4129 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -204,6 +204,30 @@ static void __skb_flow_dissect_icmp(const struct sk_buff *skb,
 	skb_flow_get_icmp_tci(skb, key_icmp, data, thoff, hlen);
 }
 
+static void __skb_flow_dissect_l2tpv3(const struct sk_buff *skb,
+				      struct flow_dissector *flow_dissector,
+				      void *target_container, const void *data,
+				      int nhoff, int hlen)
+{
+	struct flow_dissector_key_l2tpv3 *key_l2tpv3;
+	struct {
+		__be32 session_id;
+	} *hdr, _hdr;
+
+	hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data, hlen, &_hdr);
+	if (!hdr)
+		return;
+
+	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_L2TPV3))
+		return;
+
+	key_l2tpv3 = skb_flow_dissector_target(flow_dissector,
+					       FLOW_DISSECTOR_KEY_L2TPV3,
+					       target_container);
+
+	key_l2tpv3->session_id = hdr->session_id;
+}
+
 void skb_flow_dissect_meta(const struct sk_buff *skb,
 			   struct flow_dissector *flow_dissector,
 			   void *target_container)
@@ -1497,6 +1521,10 @@ bool __skb_flow_dissect(const struct net *net,
 		__skb_flow_dissect_icmp(skb, flow_dissector, target_container,
 					data, nhoff, hlen);
 		break;
+	case IPPROTO_L2TP:
+		__skb_flow_dissect_l2tpv3(skb, flow_dissector, target_container,
+					  data, nhoff, hlen);
+		break;
 
 	default:
 		break;
-- 
2.31.1

