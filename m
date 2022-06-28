Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BC855D2A6
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345525AbiF1L3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 07:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245301AbiF1L3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 07:29:45 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14386BCB3
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 04:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656415785; x=1687951785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A3r3EmhL3fwtRlg+q82huXXBvvQ6aLsRZ3mOHYUzX74=;
  b=KiU8uZ+VjvGkQ48zWfqtuA1SXrLylktU85Sa6v/lARHm99szr/0h6C9X
   z1tIdkDDnAQBDGhxaELXF4r91uJt9sheDJLhzbVKY0Jvbt5TJgISXt3Zl
   cC5/bEWWtLmNvjJtGve2VVURXEOnCl/LhgzaY/6sLrSJ0VkH+KK3XzrmH
   RoCTM/J2PSkxuV0QVunO21ePLc7q86tlYMeCfJAAWaer15QavAWWzF53y
   +ROMtfDnoUbwXhqLX5/YzDTmQ8CQl8Yj1qW3Yqt6GOM1E4wt/cDi7jBJY
   JUFfIuORtIKF0cHwd4mIlS03J+6jL032O1AY3JJG7uaQNCl0zeSqi6M7a
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281752555"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281752555"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 04:29:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="658104070"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 28 Jun 2022 04:29:40 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SBTb6Y005664;
        Tue, 28 Jun 2022 12:29:39 +0100
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
Subject: [RFC PATCH net-next v2 1/4] flow_dissector: Add PPPoE dissectors
Date:   Tue, 28 Jun 2022 13:29:15 +0200
Message-Id: <20220628112918.11296-2-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628112918.11296-1-marcin.szycik@linux.intel.com>
References: <20220628112918.11296-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Allow to dissect PPPoE specific fields which are:
- session ID (16 bits)
- ppp protocol (16 bits)

The goal is to make the following TC command possible:

  # tc filter add dev ens6f0 ingress prio 1 protocol ppp_ses \
      flower \
        pppoe_sid 12 \
        ppp_proto ip \
      action drop

Note that only PPPoE Session is supported.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
v2: use ntohs instead of htons in is_ppp_proto_supported

 include/net/flow_dissector.h | 11 ++++++++
 net/core/flow_dissector.c    | 51 +++++++++++++++++++++++++++++++-----
 2 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index a4c6057c7097..8ff40c7c3f1c 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -261,6 +261,16 @@ struct flow_dissector_key_num_of_vlans {
 	u8 num_of_vlans;
 };
 
+/**
+ * struct flow_dissector_key_pppoe:
+ * @session_id: pppoe session id
+ * @ppp_proto: ppp protocol
+ */
+struct flow_dissector_key_pppoe {
+	u16 session_id;
+	__be16 ppp_proto;
+};
+
 enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
 	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
@@ -291,6 +301,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CT, /* struct flow_dissector_key_ct */
 	FLOW_DISSECTOR_KEY_HASH, /* struct flow_dissector_key_hash */
 	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
+	FLOW_DISSECTOR_KEY_PPPOE,  /* struct flow_dissector_key_pppoe */
 
 	FLOW_DISSECTOR_KEY_MAX,
 };
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 6aee04f75e3e..a758b1980e4a 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -895,6 +895,35 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 	return result == BPF_OK;
 }
 
+static bool is_ppp_proto_supported(__be16 proto)
+{
+	switch (ntohs(proto)) {
+	case PPP_AT:
+	case PPP_IPX:
+	case PPP_VJC_COMP:
+	case PPP_VJC_UNCOMP:
+	case PPP_MP:
+	case PPP_COMPFRAG:
+	case PPP_COMP:
+	case PPP_MPLS_UC:
+	case PPP_MPLS_MC:
+	case PPP_IPCP:
+	case PPP_ATCP:
+	case PPP_IPXCP:
+	case PPP_IPV6CP:
+	case PPP_CCPFRAG:
+	case PPP_MPLSCP:
+	case PPP_LCP:
+	case PPP_PAP:
+	case PPP_LQR:
+	case PPP_CHAP:
+	case PPP_CBCP:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /**
  * __skb_flow_dissect - extract the flow_keys struct and return it
  * @net: associated network namespace, derived from @skb if NULL
@@ -1221,19 +1250,29 @@ bool __skb_flow_dissect(const struct net *net,
 		}
 
 		nhoff += PPPOE_SES_HLEN;
-		switch (hdr->proto) {
-		case htons(PPP_IP):
+		if (hdr->proto == htons(PPP_IP)) {
 			proto = htons(ETH_P_IP);
 			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
-			break;
-		case htons(PPP_IPV6):
+		} else if (hdr->proto == htons(PPP_IPV6)) {
 			proto = htons(ETH_P_IPV6);
 			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
-			break;
-		default:
+		} else if (is_ppp_proto_supported(hdr->proto)) {
+			fdret = FLOW_DISSECT_RET_OUT_GOOD;
+		} else {
 			fdret = FLOW_DISSECT_RET_OUT_BAD;
 			break;
 		}
+
+		if (dissector_uses_key(flow_dissector,
+				       FLOW_DISSECTOR_KEY_PPPOE)) {
+			struct flow_dissector_key_pppoe *key_pppoe;
+
+			key_pppoe = skb_flow_dissector_target(flow_dissector,
+							      FLOW_DISSECTOR_KEY_PPPOE,
+							      target_container);
+			key_pppoe->session_id = ntohs(hdr->hdr.sid);
+			key_pppoe->ppp_proto = hdr->proto;
+		}
 		break;
 	}
 	case htons(ETH_P_TIPC): {
-- 
2.35.1

