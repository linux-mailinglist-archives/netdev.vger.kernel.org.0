Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D9C5A963F
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbiIAMEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbiIAMEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:04:43 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BA440554
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 05:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662033882; x=1693569882;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4amD39zOEmluCPQYQNAg9eXou38dE6G14ogv0QNFbVo=;
  b=kPH3nEtVY95D1cLi3E6ylhiizYJqILkfAkgK9LIVnsRTN+ZaLlLISp5U
   azo4Y4wEzt2VcB01StbrL2ozqDZIyxrGvFk1ptJtwCJiFuH9GrE+IXVY1
   RGjFj5VF4jniU5F06L6Y3Cfaw0pU+5Bi5OiVN/awoFYehtzAO91z48u/4
   b4k7tLLObwb0qrBVKXcVe95dCV/E/Je3SJDo+ZRn6/A7tlHbOOism9b4h
   KPCl1bwNLLuDCuaiiR+eH3BB1lG3CL3R33ALXWslQzJUEkz5oav44B/ut
   xQDscCt3og51YLZHjIlDlJ7UxusloumcEfEwGQFzADlDzQe3k4qWsDW7F
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="282674254"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="282674254"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 05:04:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="608532261"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 01 Sep 2022 05:04:38 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 281C4XRi024211;
        Thu, 1 Sep 2022 13:04:36 +0100
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
Subject: [RFC PATCH net-next v3 2/5] flow_dissector: Add L2TPv3 dissectors
Date:   Thu,  1 Sep 2022 14:01:28 +0200
Message-Id: <20220901120131.1373568-3-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220901120131.1373568-1-wojciech.drewek@intel.com>
References: <20220901120131.1373568-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

Acked-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
v3: move !dissector_uses_key() check before calling
    __skb_header_pointer
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
index 764c4cb3fe8f..8180e65ab8e2 100644
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
+	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_L2TPV3))
+		return;
+
+	hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data, hlen, &_hdr);
+	if (!hdr)
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

