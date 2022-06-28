Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3140A55E1D1
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345565AbiF1L3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 07:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345496AbiF1L3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 07:29:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470D16552
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 04:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656415787; x=1687951787;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rp7DqZciaDZD8fI0/PA8Yg3M9PSYbqaDGgFpfZThO5E=;
  b=ir0SQK3ZP1TCWFqC4jQ9B37hhzlrKdQIxJPHBRjNY09XcmkXgpPRHaZT
   p1omGzI1HYV8Cfjk/12iQoqgawV1soVv8raDDP4685tPOIPFgJbdcQq4t
   wFt81vKbAkqRRLm7C/Wkyd1p71949+Kiim+RUx2hhoRI4+DtEpv3YEHGs
   jmwd4NYzqP3HQ0LVJSIk6x2q9GLs8HcwC6yftIFCH/T3/dctiApfc9CPE
   t7zWUepx0r56stcl+DlWx+GPL4CRAEzSYxHSMFWkA7MQz8ez1X4UykXoA
   kLhoN+OylTMiZ006KKcUkgoN8rxoDLoELeB4yEyvF8t8Huhc1bgUPsuAr
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="307195671"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="307195671"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 04:29:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="590283432"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 28 Jun 2022 04:29:42 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SBTb6Z005664;
        Tue, 28 Jun 2022 12:29:40 +0100
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        xiyou.wangcong@gmail.com, jesse.brandeburg@intel.com,
        gustavoars@kernel.org, baowen.zheng@corigine.com,
        boris.sukholitko@broadcom.com, edumazet@google.com,
        kuba@kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        kurt@linutronix.de, pablo@netfilter.org, pabeni@redhat.com,
        paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        intel-wired-lan@lists.osuosl.org,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        alexandr.lobakin@intel.com
Subject: [RFC PATCH net-next v2 2/4] net/sched: flower: Add PPPoE filter
Date:   Tue, 28 Jun 2022 13:29:16 +0200
Message-Id: <20220628112918.11296-3-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628112918.11296-1-marcin.szycik@linux.intel.com>
References: <20220628112918.11296-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Add support for PPPoE specific fields for tc-flower.
Those fields can be provided only when protocol was set
to ETH_P_PPP_SES. Defines, dump, load and set are being done here.

Overwrite basic.n_proto only in case of PPP_IP and PPP_IPV6,
otherwise leave it as ETH_P_PPP_SES.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 include/uapi/linux/pkt_cls.h |  3 +++
 net/sched/cls_flower.c       | 46 ++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 9a2ee1e39fad..a67dcd8294c9 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -589,6 +589,9 @@ enum {
 
 	TCA_FLOWER_KEY_NUM_OF_VLANS,    /* u8 */
 
+	TCA_FLOWER_KEY_PPPOE_SID,	/* u16 */
+	TCA_FLOWER_KEY_PPP_PROTO,	/* be16 */
+
 	__TCA_FLOWER_MAX,
 };
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index dcca70144dff..f6a0bb87f869 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -16,6 +16,7 @@
 #include <linux/in6.h>
 #include <linux/ip.h>
 #include <linux/mpls.h>
+#include <linux/ppp_defs.h>
 
 #include <net/sch_generic.h>
 #include <net/pkt_cls.h>
@@ -73,6 +74,7 @@ struct fl_flow_key {
 	struct flow_dissector_key_ct ct;
 	struct flow_dissector_key_hash hash;
 	struct flow_dissector_key_num_of_vlans num_of_vlans;
+	struct flow_dissector_key_pppoe pppoe;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
 
 struct fl_flow_mask_range {
@@ -714,6 +716,8 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_KEY_HASH]		= { .type = NLA_U32 },
 	[TCA_FLOWER_KEY_HASH_MASK]	= { .type = NLA_U32 },
 	[TCA_FLOWER_KEY_NUM_OF_VLANS]	= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_PPPOE_SID]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_PPP_PROTO]	= { .type = NLA_U16 },
 
 };
 
@@ -1041,6 +1045,32 @@ static void fl_set_key_vlan(struct nlattr **tb,
 	}
 }
 
+static void fl_set_key_pppoe(struct nlattr **tb,
+			     struct flow_dissector_key_pppoe *key_val,
+			     struct flow_dissector_key_pppoe *key_mask,
+			     struct fl_flow_key *key,
+			     struct fl_flow_key *mask)
+{
+	if (tb[TCA_FLOWER_KEY_PPPOE_SID]) {
+		key_val->session_id =
+			nla_get_u16(tb[TCA_FLOWER_KEY_PPPOE_SID]);
+		key_mask->session_id = 0xffff;
+	}
+	if (tb[TCA_FLOWER_KEY_PPP_PROTO]) {
+		key_val->ppp_proto =
+			nla_get_be16(tb[TCA_FLOWER_KEY_PPP_PROTO]);
+		key_mask->ppp_proto = cpu_to_be16(~0);
+
+		if (key_val->ppp_proto == htons(PPP_IP)) {
+			key->basic.n_proto = htons(ETH_P_IP);
+			mask->basic.n_proto = cpu_to_be16(~0);
+		} else if (key_val->ppp_proto == htons(PPP_IPV6)) {
+			key->basic.n_proto = htons(ETH_P_IPV6);
+			mask->basic.n_proto = cpu_to_be16(~0);
+		}
+	}
+}
+
 static void fl_set_key_flag(u32 flower_key, u32 flower_mask,
 			    u32 *dissector_key, u32 *dissector_mask,
 			    u32 flower_flag_bit, u32 dissector_flag_bit)
@@ -1651,6 +1681,9 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 		}
 	}
 
+	if (key->basic.n_proto == htons(ETH_P_PPP_SES))
+		fl_set_key_pppoe(tb, &key->pppoe, &mask->pppoe, key, mask);
+
 	if (key->basic.n_proto == htons(ETH_P_IP) ||
 	    key->basic.n_proto == htons(ETH_P_IPV6)) {
 		fl_set_key_val(tb, &key->basic.ip_proto, TCA_FLOWER_KEY_IP_PROTO,
@@ -1923,6 +1956,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
 			     FLOW_DISSECTOR_KEY_HASH, hash);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_NUM_OF_VLANS, num_of_vlans);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_PPPOE, pppoe);
 
 	skb_flow_dissector_init(dissector, keys, cnt);
 }
@@ -3051,6 +3086,17 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 	    fl_dump_key_ip(skb, false, &key->ip, &mask->ip)))
 		goto nla_put_failure;
 
+	if (mask->pppoe.session_id) {
+		if (nla_put_u16(skb, TCA_FLOWER_KEY_PPPOE_SID,
+				key->pppoe.session_id))
+			goto nla_put_failure;
+	}
+	if (mask->basic.n_proto && mask->pppoe.ppp_proto) {
+		if (nla_put_be16(skb, TCA_FLOWER_KEY_PPP_PROTO,
+				 key->pppoe.ppp_proto))
+			goto nla_put_failure;
+	}
+
 	if (key->control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS &&
 	    (fl_dump_key_val(skb, &key->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC,
 			     &mask->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC_MASK,
-- 
2.35.1

