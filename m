Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA629569D8E
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 10:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234814AbiGGIh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 04:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234779AbiGGIhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 04:37:53 -0400
Received: from syslogsrv (unknown [217.20.186.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F2A4F188;
        Thu,  7 Jul 2022 01:37:52 -0700 (PDT)
Received: from fg200.ow.s ([172.20.254.44] helo=localhost.localdomain)
        by syslogsrv with esmtp (Exim 4.90_1)
        (envelope-from <maksym.glubokiy@plvision.eu>)
        id 1o9MzK-000CqE-RE; Thu, 07 Jul 2022 11:35:55 +0300
From:   Maksym Glubokiy <maksym.glubokiy@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: extract port range fields from fl_flow_key
Date:   Thu,  7 Jul 2022 11:35:38 +0300
Message-Id: <20220707083539.171242-1-maksym.glubokiy@plvision.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
        HELO_NO_DOMAIN,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So it can be used for port range filter offloading.

Co-developed-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
---
 include/net/flow_dissector.h | 16 ++++++++++++++++
 include/net/flow_offload.h   |  6 ++++++
 net/core/flow_offload.c      |  7 +++++++
 net/sched/cls_flower.c       |  8 +-------
 4 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index a4c6057c7097..6341505d0838 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -178,6 +178,22 @@ struct flow_dissector_key_ports {
 	};
 };
 
+/**
+ * flow_dissector_key_ports_range:
+ *		tp:     port number from packet
+ *		tp_min: min port number in range
+ *		tp_max: max port number in range
+ */
+struct flow_dissector_key_ports_range {
+	union {
+		struct flow_dissector_key_ports tp;
+		struct {
+			struct flow_dissector_key_ports tp_min;
+			struct flow_dissector_key_ports tp_max;
+		};
+	};
+};
+
 /**
  * flow_dissector_key_icmp:
  *		type: ICMP type
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 6484095a8c01..c53c3d2d5800 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -48,6 +48,10 @@ struct flow_match_ports {
 	struct flow_dissector_key_ports *key, *mask;
 };
 
+struct flow_match_ports_range {
+	struct flow_dissector_key_ports_range *key, *mask;
+};
+
 struct flow_match_icmp {
 	struct flow_dissector_key_icmp *key, *mask;
 };
@@ -94,6 +98,8 @@ void flow_rule_match_ip(const struct flow_rule *rule,
 			struct flow_match_ip *out);
 void flow_rule_match_ports(const struct flow_rule *rule,
 			   struct flow_match_ports *out);
+void flow_rule_match_ports_range(const struct flow_rule *rule,
+				 struct flow_match_ports_range *out);
 void flow_rule_match_tcp(const struct flow_rule *rule,
 			 struct flow_match_tcp *out);
 void flow_rule_match_icmp(const struct flow_rule *rule,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 929f6379a279..0d3075d3c8fb 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -125,6 +125,13 @@ void flow_rule_match_ports(const struct flow_rule *rule,
 }
 EXPORT_SYMBOL(flow_rule_match_ports);
 
+void flow_rule_match_ports_range(const struct flow_rule *rule,
+				 struct flow_match_ports_range *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_PORTS_RANGE, out);
+}
+EXPORT_SYMBOL(flow_rule_match_ports_range);
+
 void flow_rule_match_tcp(const struct flow_rule *rule,
 			 struct flow_match_tcp *out)
 {
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index dcca70144dff..1a1e34480b7e 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -63,13 +63,7 @@ struct fl_flow_key {
 	struct flow_dissector_key_ip ip;
 	struct flow_dissector_key_ip enc_ip;
 	struct flow_dissector_key_enc_opts enc_opts;
-	union {
-		struct flow_dissector_key_ports tp;
-		struct {
-			struct flow_dissector_key_ports tp_min;
-			struct flow_dissector_key_ports tp_max;
-		};
-	} tp_range;
+	struct flow_dissector_key_ports_range tp_range;
 	struct flow_dissector_key_ct ct;
 	struct flow_dissector_key_hash hash;
 	struct flow_dissector_key_num_of_vlans num_of_vlans;
-- 
2.25.1

