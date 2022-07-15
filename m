Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EA4576272
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 15:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbiGONFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 09:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiGONFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 09:05:06 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DD86447
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 06:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657890304; x=1689426304;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2gPuloWhaxpoc/veSmSyLQ/8KAHfGQeAawY83T0HtB4=;
  b=eI1DbPvURZ+9Z7wsjbHv5zBFh0TeQW4zEyrOZNAxTKokN2+brJ0vGD2Z
   JUqsFxQeebp0BXOJYrpxVgcwdL+nufCT6imwnD2KAeEkFh5lgTjtLUf65
   CQnamOmt1TcRqzdwLCkNqrxg/feKmPJJqul43AHchgxHrkrRpvsL9Crjm
   TwPgGCt+z+XKcuXvRloPoCnGP7/Mh/vUo9Pqoo5spzYBSqEFYCTBwMUWu
   ii/OpX5I8Qr0UyBUEfS6H+8FM3DRfu+i7xMPy54vKO9LAOicRP5RHyQsZ
   SkpkG/g38zPJX3AYPak33n23kanDkquujkjXKicHTt/1DqdQFoYmL9OIa
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="372105960"
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="372105960"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 06:05:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="629099710"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 15 Jul 2022 06:04:59 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26FD4tXL013793;
        Fri, 15 Jul 2022 14:04:57 +0100
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
        mostrows@speakeasy.net, paulus@samba.org
Subject: [RFC PATCH net-next v5 1/4] flow_dissector: Add PPPoE dissectors
Date:   Fri, 15 Jul 2022 15:04:27 +0200
Message-Id: <20220715130430.160029-2-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220715130430.160029-1-marcin.szycik@linux.intel.com>
References: <20220715130430.160029-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Allow to dissect PPPoE specific fields which are:
- session ID (16 bits)
- ppp protocol (16 bits)
- type (16 bits) - this is PPPoE ethertype, for now only
  ETH_P_PPP_SES is supported, possible ETH_P_PPP_DISC
  in the future

The goal is to make the following TC command possible:

  # tc filter add dev ens6f0 ingress prio 1 protocol ppp_ses \
      flower \
        pppoe_sid 12 \
        ppp_proto ip \
      action drop

Note that only PPPoE Session is supported.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
v5: fix endianness when processing compressed protocols
v4:
  * pppoe header validation
  * added MPLS dissection
  * added support for compressed ppp protocol field
  * flow_dissector_key_pppoe::session_id stored in __be16
  * new field: flow_dissector_key_pppoe::type
v3: revert byte order changes in is_ppp_proto_supported from
    previous version
v2: ntohs instead of htons in is_ppp_proto_supported

 include/net/flow_dissector.h | 13 ++++++
 net/core/flow_dissector.c    | 85 +++++++++++++++++++++++++++++++++---
 2 files changed, 91 insertions(+), 7 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 0f9544a9bb9e..6c74812d64b2 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -277,6 +277,18 @@ struct flow_dissector_key_num_of_vlans {
 	u8 num_of_vlans;
 };
 
+/**
+ * struct flow_dissector_key_pppoe:
+ * @session_id: pppoe session id
+ * @ppp_proto: ppp protocol
+ * @type: pppoe eth type
+ */
+struct flow_dissector_key_pppoe {
+	__be16 session_id;
+	__be16 ppp_proto;
+	__be16 type;
+};
+
 enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
 	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
@@ -307,6 +319,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CT, /* struct flow_dissector_key_ct */
 	FLOW_DISSECTOR_KEY_HASH, /* struct flow_dissector_key_hash */
 	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
+	FLOW_DISSECTOR_KEY_PPPOE, /* struct flow_dissector_key_pppoe */
 
 	FLOW_DISSECTOR_KEY_MAX,
 };
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 6aee04f75e3e..e3dfc9e5d095 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -895,6 +895,42 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
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
+static bool is_pppoe_ses_hdr_valid(struct pppoe_hdr hdr)
+{
+	return hdr.ver == 1 && hdr.type == 1 && hdr.code == 0;
+}
+
 /**
  * __skb_flow_dissect - extract the flow_keys struct and return it
  * @net: associated network namespace, derived from @skb if NULL
@@ -1214,26 +1250,61 @@ bool __skb_flow_dissect(const struct net *net,
 			struct pppoe_hdr hdr;
 			__be16 proto;
 		} *hdr, _hdr;
+		u16 ppp_proto;
+
 		hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data, hlen, &_hdr);
 		if (!hdr) {
 			fdret = FLOW_DISSECT_RET_OUT_BAD;
 			break;
 		}
 
-		nhoff += PPPOE_SES_HLEN;
-		switch (hdr->proto) {
-		case htons(PPP_IP):
+		if (!is_pppoe_ses_hdr_valid(hdr->hdr)) {
+			fdret = FLOW_DISSECT_RET_OUT_BAD;
+			break;
+		}
+
+		/* least significant bit of the least significant octet
+		 * indicates if protocol field was compressed
+		 */
+		ppp_proto = ntohs(hdr->proto);
+		if (ppp_proto & 256) {
+			ppp_proto = htons(ppp_proto >> 8);
+			nhoff += PPPOE_SES_HLEN - 1;
+		} else {
+			ppp_proto = htons(ppp_proto);
+			nhoff += PPPOE_SES_HLEN;
+		}
+
+		if (ppp_proto == htons(PPP_IP)) {
 			proto = htons(ETH_P_IP);
 			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
-			break;
-		case htons(PPP_IPV6):
+		} else if (ppp_proto == htons(PPP_IPV6)) {
 			proto = htons(ETH_P_IPV6);
 			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
-			break;
-		default:
+		} else if (ppp_proto == htons(PPP_MPLS_UC)) {
+			proto = htons(ETH_P_MPLS_UC);
+			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
+		} else if (ppp_proto == htons(PPP_MPLS_MC)) {
+			proto = htons(ETH_P_MPLS_MC);
+			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
+		} else if (is_ppp_proto_supported(ppp_proto)) {
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
+			key_pppoe->session_id = hdr->hdr.sid;
+			key_pppoe->ppp_proto = ppp_proto;
+			key_pppoe->type = htons(ETH_P_PPP_SES);
+		}
 		break;
 	}
 	case htons(ETH_P_TIPC): {
-- 
2.35.1

