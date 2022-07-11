Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93F556034F
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbiF2Okb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbiF2Ok2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:40:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B161537020
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 07:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656513627; x=1688049627;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fUfMk8igt3k0bOGaXeDUuKDrHMD7x1pl2PQxNLJeO2s=;
  b=VSn26Ak67cJREUzusxfFsC6tiNq82dE+VWFtTaifZSV17PRD8g6nlamh
   68Z1I1a0423xSIXVPH1I2IB76gudcunQA3u9rQeoDmWbsMsSbkwMqgqCJ
   rgeaVY2xpaeEkUzB1bBK8xAGPPOZ6x6SjZJ3eENnVUDEZ45IhWMo++gZQ
   rx0NTIo3xvSfnN0XMy/psZ9+GTWb480b6+WX7NACODQNcpga2eHfJ54Kp
   v3FFhRHH/ai7UonxZdb4eNAMbE1dxVpTcLTomkWrwnpgt2X/r3/35A4cy
   n/3xcCStf6u/KUksHo5FxZw9OvPDsZYw/QVaI7dUiy5Uqeas0yTJNl3CS
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="343734767"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="343734767"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 07:40:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="595255544"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jun 2022 07:40:22 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25TEeJ3Y022901;
        Wed, 29 Jun 2022 15:40:20 +0100
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
        alexandr.lobakin@intel.com, gnault@redhat.com,
        mostrows@earthlink.net, paulus@samba.org
Subject: [RFC PATCH net-next v3 1/4] flow_dissector: Add PPPoE dissectors
Date:   Wed, 29 Jun 2022 16:38:56 +0200
Message-Id: <20220629143859.209028-2-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220629143859.209028-1-marcin.szycik@linux.intel.com>
References: <20220629143859.209028-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
v3: revert byte order changes in is_ppp_proto_supported from previous 
    version, add kernel-doc for is_ppp_proto_supported
v2: use ntohs instead of htons in is_ppp_proto_supported

 include/net/flow_dissector.h | 11 ++++++++
 net/core/flow_dissector.c    | 55 ++++++++++++++++++++++++++++++++----
 2 files changed, 60 insertions(+), 6 deletions(-)

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
index 6aee04f75e3e..42393af477a2 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -895,6 +895,39 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 	return result == BPF_OK;
 }
 
+/**
+ * is_ppp_proto_supported - checks if inner PPP protocol should be dissected
+ * @proto: protocol type (PPP proto field)
+ */
+static bool is_ppp_proto_supported(__be16 proto)
+{
+	switch (proto) {
+	case htons(PPP_AT):
+	case htons(PPP_IPX):
+	case htons(PPP_VJC_COMP):
+	case htons(PPP_VJC_UNCOMP):
+	case htons(PPP_MP):
+	case htons(PPP_COMPFRAG):
+	case htons(PPP_COMP):
+	case htons(PPP_MPLS_UC):
+	case htons(PPP_MPLS_MC):
+	case htons(PPP_IPCP):
+	case htons(PPP_ATCP):
+	case htons(PPP_IPXCP):
+	case htons(PPP_IPV6CP):
+	case htons(PPP_CCPFRAG):
+	case htons(PPP_MPLSCP):
+	case htons(PPP_LCP):
+	case htons(PPP_PAP):
+	case htons(PPP_LQR):
+	case htons(PPP_CHAP):
+	case htons(PPP_CBCP):
+		return true;
+	default:
+		return false;
+	}
+}
+
 /**
  * __skb_flow_dissect - extract the flow_keys struct and return it
  * @net: associated network namespace, derived from @skb if NULL
@@ -1221,19 +1254,29 @@ bool __skb_flow_dissect(const struct net *net,
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

