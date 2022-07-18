Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9269157820E
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbiGRMS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234925AbiGRMSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:18:52 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDA1FDA
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 05:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658146730; x=1689682730;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Yu6GSiJBdh7xITPMm8QeqQ8FofLc192P1AewkOJXmo=;
  b=hWYe5IHXnH6L3oMjGtkHgo39gMyQkbHveNQZXmz8WP1IbZgQBMjNjh8i
   MJJ+6thllIu4NUA4Qhs7XNGfdIOnuT07FrhVyM0Q34CRWpI7QBXulR1Mv
   8FEvVU0avRUcHsL49tBKULymYxxbbYF8Zk+ArnRabvf2jZq0mNQ5pJWEa
   4CmCuPIOF+33x88d3rKj2l4E4urf68EI2ZBN0xzh6qoQiDIr6hkk87JBp
   56wqtrXF9zw6fy9+02IVRCI70EozUAxK0e51nWkKgaGLdN1vqqH0ADQJ5
   yGiOKM4FgVz0xcEtY22A7lmBdzhi/49T0I0KFYHiZlz55oYvZSyfH+wk4
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10411"; a="347893759"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="347893759"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 05:18:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="601204856"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 18 Jul 2022 05:18:45 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26ICIfCt016026;
        Mon, 18 Jul 2022 13:18:43 +0100
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
Subject: [RFC PATCH net-next v6 1/4] flow_dissector: Add PPPoE dissectors
Date:   Mon, 18 Jul 2022 14:18:10 +0200
Message-Id: <20220718121813.159102-2-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220718121813.159102-1-marcin.szycik@linux.intel.com>
References: <20220718121813.159102-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
v6:
  * make check for ppp proto more generic
  * fix remaining byte order issues
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

 include/linux/ppp_defs.h     | 14 ++++++++++
 include/net/flow_dissector.h | 13 +++++++++
 net/core/flow_dissector.c    | 53 +++++++++++++++++++++++++++++++-----
 3 files changed, 73 insertions(+), 7 deletions(-)

diff --git a/include/linux/ppp_defs.h b/include/linux/ppp_defs.h
index 9d2b388fae1a..b7e57fdbd413 100644
--- a/include/linux/ppp_defs.h
+++ b/include/linux/ppp_defs.h
@@ -11,4 +11,18 @@
 #include <uapi/linux/ppp_defs.h>
 
 #define PPP_FCS(fcs, c) crc_ccitt_byte(fcs, c)
+
+/**
+ * ppp_proto_is_valid - checks if PPP protocol is valid
+ * @proto: PPP protocol
+ *
+ * Assumes proto is not compressed.
+ * Protocol is valid if the value is odd and the least significant bit of the
+ * most significant octet is 0 (see RFC 1661, section 2).
+ */
+static inline bool ppp_proto_is_valid(u16 proto)
+{
+	return !!((proto & 0x0101) == 0x0001);
+}
+
 #endif /* _PPP_DEFS_H_ */
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
index 6aee04f75e3e..237d396b6e41 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -895,6 +895,11 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 	return result == BPF_OK;
 }
 
+static bool is_pppoe_ses_hdr_valid(struct pppoe_hdr hdr)
+{
+	return hdr.ver == 1 && hdr.type == 1 && hdr.code == 0;
+}
+
 /**
  * __skb_flow_dissect - extract the flow_keys struct and return it
  * @net: associated network namespace, derived from @skb if NULL
@@ -1214,26 +1219,60 @@ bool __skb_flow_dissect(const struct net *net,
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
+		/* least significant bit of the most significant octet
+		 * indicates if protocol field was compressed
+		 */
+		ppp_proto = ntohs(hdr->proto);
+		if (ppp_proto & 0x0100) {
+			ppp_proto = ppp_proto >> 8;
+			nhoff += PPPOE_SES_HLEN - 1;
+		} else {
+			nhoff += PPPOE_SES_HLEN;
+		}
+
+		if (ppp_proto == PPP_IP) {
 			proto = htons(ETH_P_IP);
 			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
-			break;
-		case htons(PPP_IPV6):
+		} else if (ppp_proto == PPP_IPV6) {
 			proto = htons(ETH_P_IPV6);
 			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
-			break;
-		default:
+		} else if (ppp_proto == PPP_MPLS_UC) {
+			proto = htons(ETH_P_MPLS_UC);
+			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
+		} else if (ppp_proto == PPP_MPLS_MC) {
+			proto = htons(ETH_P_MPLS_MC);
+			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
+		} else if (ppp_proto_is_valid(ppp_proto)) {
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
+			key_pppoe->ppp_proto = htons(ppp_proto);
+			key_pppoe->type = htons(ETH_P_PPP_SES);
+		}
 		break;
 	}
 	case htons(ETH_P_TIPC): {
-- 
2.35.1

