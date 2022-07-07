Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7876569D8A
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 10:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbiGGIht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 04:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiGGIhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 04:37:47 -0400
Received: from syslogsrv (unknown [217.20.186.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C837326D5;
        Thu,  7 Jul 2022 01:37:45 -0700 (PDT)
Received: from fg200.ow.s ([172.20.254.44] helo=localhost.localdomain)
        by syslogsrv with esmtp (Exim 4.90_1)
        (envelope-from <maksym.glubokiy@plvision.eu>)
        id 1o9MzS-000CqE-7C; Thu, 07 Jul 2022 11:36:02 +0300
From:   Maksym Glubokiy <maksym.glubokiy@plvision.eu>
To:     Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: prestera: add support for port range filters
Date:   Thu,  7 Jul 2022 11:35:39 +0300
Message-Id: <20220707083539.171242-2-maksym.glubokiy@plvision.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220707083539.171242-1-maksym.glubokiy@plvision.eu>
References: <20220707083539.171242-1-maksym.glubokiy@plvision.eu>
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

This adds support for port-range rules:

  $ tc qdisc add ... clsact
  $ tc filter add ... flower ... src_port <PMIN>-<PMAX> ...

Co-developed-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
---
 .../marvell/prestera/prestera_flower.c        | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index a54748ac6541..652aa95e65ac 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -202,6 +202,7 @@ static int prestera_flower_parse(struct prestera_flow_block *block,
 	      BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
 	      BIT(FLOW_DISSECTOR_KEY_ICMP) |
 	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
+	      BIT(FLOW_DISSECTOR_KEY_PORTS_RANGE) |
 	      BIT(FLOW_DISSECTOR_KEY_VLAN))) {
 		NL_SET_ERR_MSG_MOD(f->common.extack, "Unsupported key");
 		return -EOPNOTSUPP;
@@ -301,6 +302,29 @@ static int prestera_flower_parse(struct prestera_flow_block *block,
 		rule_match_set(r_match->mask, L4_PORT_DST, match.mask->dst);
 	}
 
+	if (flow_rule_match_key(f_rule, FLOW_DISSECTOR_KEY_PORTS_RANGE)) {
+		struct flow_match_ports_range match;
+		__be32 tp_key, tp_mask;
+
+		flow_rule_match_ports_range(f_rule, &match);
+
+		/* src port range (min, max) */
+		tp_key = htonl(ntohs(match.key->tp_min.src) |
+			       (ntohs(match.key->tp_max.src) << 16));
+		tp_mask = htonl(ntohs(match.mask->tp_min.src) |
+				(ntohs(match.mask->tp_max.src) << 16));
+		rule_match_set(r_match->key, L4_PORT_RANGE_SRC, tp_key);
+		rule_match_set(r_match->mask, L4_PORT_RANGE_SRC, tp_mask);
+
+		/* dst port range (min, max) */
+		tp_key = htonl(ntohs(match.key->tp_min.dst) |
+			       (ntohs(match.key->tp_max.dst) << 16));
+		tp_mask = htonl(ntohs(match.mask->tp_min.dst) |
+				(ntohs(match.mask->tp_max.dst) << 16));
+		rule_match_set(r_match->key, L4_PORT_RANGE_DST, tp_key);
+		rule_match_set(r_match->mask, L4_PORT_RANGE_DST, tp_mask);
+	}
+
 	if (flow_rule_match_key(f_rule, FLOW_DISSECTOR_KEY_VLAN)) {
 		struct flow_match_vlan match;
 
-- 
2.25.1

