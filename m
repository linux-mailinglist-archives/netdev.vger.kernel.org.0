Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80315B2447
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 19:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiIHRRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 13:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiIHRRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 13:17:21 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AC6CAC78
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 10:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662657441; x=1694193441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S8T0IJZGltHxQ+Ll+F3o2rWmlG/OCDW7S2Zdfooa9Rs=;
  b=ZUcKxBRbU2JFYof5wHOl5UqaM2P4VrRmoTFTQoA25rYsb8yPXQfl2MRJ
   DqcMVSulEeTKm73RPA1v3m549X55gYlnl2h7Lw8Ru5tpVakshMa5z7MMc
   wVUVtGsW5CWdE3AjwRTRgQrdV/1svRlmOsHnyypJMMQiRmSrLXrrva7En
   tbD8d40DGUQtLmG7huJrXr/oy6EnXsXD/2BJe8soDIdQfwpAGDjBGtPug
   v9VKbsLOp/ImbAJz83YQa5woc3+HjPYffeZau+j9vXwJn2ZJ/0wGNcaaS
   AuOdFphJNyAOtP9TWQfnSfpMDEzvPaf2jcJPemfTzRFg9IziJjceQKyRs
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="297267567"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="297267567"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 10:16:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="860117825"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 08 Sep 2022 10:16:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        simon.horman@corigine.com, kurt@linutronix.de,
        komachi.yoshiki@gmail.com, jchapman@katalix.com,
        boris.sukholitko@broadcom.com, louis.peens@corigine.com,
        gnault@redhat.com, vladbu@nvidia.com, pablo@netfilter.org,
        baowen.zheng@corigine.com, maksym.glubokiy@plvision.eu,
        jiri@resnulli.us, paulb@nvidia.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com
Subject: [PATCH net-next v1 2/5] flow_dissector: Add L2TPv3 dissectors
Date:   Thu,  8 Sep 2022 10:16:41 -0700
Message-Id: <20220908171644.1282191-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220908171644.1282191-1-anthony.l.nguyen@intel.com>
References: <20220908171644.1282191-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Allow to dissect L2TPv3 specific field which is:
- session ID (32 bits)

L2TPv3 might be transported over IP or over UDP,
this implementation is only about L2TPv3 over IP.
IP protocol carries L2TPv3 when ip_proto is
IPPROTO_L2TP (115).

Acked-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
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
index 990429c69ccd..2a1f513a2dc8 100644
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
@@ -1501,6 +1525,10 @@ bool __skb_flow_dissect(const struct net *net,
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
2.35.1

