Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2595A4C798D
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 21:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiB1UBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 15:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiB1UBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 15:01:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890FD3B01F
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 12:01:14 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646078472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u1m5pCoJvom0vIqm/xFgDt43MCUMa8drTHQud+jI6EE=;
        b=ZuK+V9bp/qlPTgsuXey8FykuvTJHp2aCe70FB/8gtd4+kNoHlGJYHIxsmtWpHQWB5cV9oO
        S2qgzkUznBjCV15WtqdMus3CkXJZgNbHI3kzJB/4wiXuLNFijnn7DeAiL3UI6P+RUIngH2
        roJEW33ZKld1l4C0G0didFLhdkfL/NFfe7fq+OnLFObmgyeInCsghCskc6wOqy4XNRFEcN
        lvGEZZmP+cWJJ3IGrN3voIMkiby73Nmm9UL0jfYKxOlDxUR3sm/D/WjL4JhAidVwjzE167
        j9Z80AOsioGfOWWgWo15i8JulzT1cRXqvv7/Ioq9elh/5MqYPOrQlixIAzqhLg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646078472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u1m5pCoJvom0vIqm/xFgDt43MCUMa8drTHQud+jI6EE=;
        b=9liAXNfR85mJM0hktRza8X4rI94BTSm3+8BJlokbcZ0P3SonsCFeUTfk125RMTq8oyZgLo
        0EgWH3Nh32xgWcBg==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@nvidia.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        zhang kai <zhangkaiheb@126.com>,
        Juhee Kang <claudiajkang@gmail.com>,
        Andreas Oetken <ennoerlangen@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Anthony Harivel <anthony.harivel@linutronix.de>
Subject: [PATCH net-next v1] flow_dissector: Add support for HSR
Date:   Mon, 28 Feb 2022 20:58:56 +0100
Message-Id: <20220228195856.88187-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Network drivers such as igb or igc call eth_get_headlen() to determine the
header length for their to be constructed skbs in receive path.

When running HSR on top of these drivers, it results in triggering BUG_ON() in
skb_pull(). The reason is the skb headlen is not sufficient for HSR to work
correctly. skb_pull() notices that.

For instance, eth_get_headlen() returns 14 bytes for TCP traffic over HSR which
is not correct. The problem is, the flow dissection code does not take HSR into
account. Therefore, add support for it.

Reported-by: Anthony Harivel <anthony.harivel@linutronix.de>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 include/linux/if_hsr.h    | 16 ++++++++++++++++
 net/core/flow_dissector.c | 17 +++++++++++++++++
 net/hsr/hsr_main.h        | 16 ----------------
 3 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/include/linux/if_hsr.h b/include/linux/if_hsr.h
index 38bbc537d4e4..408539d5ea5f 100644
--- a/include/linux/if_hsr.h
+++ b/include/linux/if_hsr.h
@@ -9,6 +9,22 @@ enum hsr_version {
 	PRP_V1,
 };
 
+/* HSR Tag.
+ * As defined in IEC-62439-3:2010, the HSR tag is really { ethertype = 0x88FB,
+ * path, LSDU_size, sequence Nr }. But we let eth_header() create { h_dest,
+ * h_source, h_proto = 0x88FB }, and add { path, LSDU_size, sequence Nr,
+ * encapsulated protocol } instead.
+ *
+ * Field names as defined in the IEC:2010 standard for HSR.
+ */
+struct hsr_tag {
+	__be16		path_and_LSDU_size;
+	__be16		sequence_nr;
+	__be16		encap_proto;
+} __packed;
+
+#define HSR_HLEN	6
+
 #if IS_ENABLED(CONFIG_HSR)
 extern bool is_hsr_master(struct net_device *dev);
 extern int hsr_get_version(struct net_device *dev, enum hsr_version *ver);
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 15833e1d6ea1..34441a32e3be 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -22,6 +22,7 @@
 #include <linux/ppp_defs.h>
 #include <linux/stddef.h>
 #include <linux/if_ether.h>
+#include <linux/if_hsr.h>
 #include <linux/mpls.h>
 #include <linux/tcp.h>
 #include <linux/ptp_classify.h>
@@ -1282,6 +1283,22 @@ bool __skb_flow_dissect(const struct net *net,
 		break;
 	}
 
+	case htons(ETH_P_HSR): {
+		struct hsr_tag *hdr, _hdr;
+
+		hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data, hlen,
+					   &_hdr);
+		if (!hdr) {
+			fdret = FLOW_DISSECT_RET_OUT_BAD;
+			break;
+		}
+
+		proto = hdr->encap_proto;
+		nhoff += HSR_HLEN;
+		fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
+		break;
+	}
+
 	default:
 		fdret = FLOW_DISSECT_RET_OUT_BAD;
 		break;
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index ca556bda3467..b158ba409f9a 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -45,22 +45,6 @@
 /* PRP V1 life redundancy box MAC address */
 #define PRP_TLV_REDBOX_MAC		   30
 
-/* HSR Tag.
- * As defined in IEC-62439-3:2010, the HSR tag is really { ethertype = 0x88FB,
- * path, LSDU_size, sequence Nr }. But we let eth_header() create { h_dest,
- * h_source, h_proto = 0x88FB }, and add { path, LSDU_size, sequence Nr,
- * encapsulated protocol } instead.
- *
- * Field names as defined in the IEC:2010 standard for HSR.
- */
-struct hsr_tag {
-	__be16		path_and_LSDU_size;
-	__be16		sequence_nr;
-	__be16		encap_proto;
-} __packed;
-
-#define HSR_HLEN	6
-
 #define HSR_V1_SUP_LSDUSIZE		52
 
 #define HSR_HSIZE_SHIFT	8
-- 
2.30.2

