Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E56611C002
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfLKWnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:43:03 -0500
Received: from internalmail.cumulusnetworks.com ([45.55.219.144]:58670 "EHLO
        internalmail.cumulusnetworks.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726592AbfLKWnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:43:00 -0500
Received: from localhost (fw.cumulusnetworks.com [216.129.126.126])
        by internalmail.cumulusnetworks.com (Postfix) with ESMTPSA id ADE20C11F4;
        Wed, 11 Dec 2019 14:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cumulusnetworks.com;
        s=mail; t=1576103598;
        bh=T/7gRR3++Kjp2Vn0XngQq2zHSpnYKpcSG7fy0CEYI5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=J9iUkabI9SsO3IZOiNRBg/fQSazgsuR46kukAAjEAVPmA5I2HTQXPhH22+C98pNa1
         h4urle1y09hT3Ok1bowZoqbTM1GrMBbPUCeim8tc601TJs60pzb9WV9nCYdq/kwuiU
         ypb79d0KjZWn1Q7V7R/Ea/F6us+INQf5b0AhEl+4=
From:   Andy Roulin <aroulin@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, stephen@networkplumber.org
Subject: [PATCH iproute2-next v2 2/2] iplink: bond: print 3ad actor/partner oper states as strings
Date:   Wed, 11 Dec 2019 14:33:15 -0800
Message-Id: <1576103595-23138-3-git-send-email-aroulin@cumulusnetworks.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1576103595-23138-1-git-send-email-aroulin@cumulusnetworks.com>
References: <1576103595-23138-1-git-send-email-aroulin@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 802.3ad actor/partner operating states are only printed as
numbers, e.g,

ad_actor_oper_port_state 15

Add an additional output in ip link show that prints a string describing
the individual 3ad bit meanings in the following way:

ad_actor_oper_port_state_str <active,short_timeout,aggregating,in_sync>

JSON output is also supported, the field becomes a json array:

"ad_actor_oper_port_state_str":
	["active","short_timeout","aggregating","in_sync"]

Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 ip/iplink_bond_slave.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/ip/iplink_bond_slave.c b/ip/iplink_bond_slave.c
index 4eaf72b8..6ecf4ba2 100644
--- a/ip/iplink_bond_slave.c
+++ b/ip/iplink_bond_slave.c
@@ -68,6 +68,26 @@ static void print_slave_mii_status(FILE *f, struct rtattr *tb)
 			     slave_mii_status[status]);
 }
 
+static void print_slave_oper_state(FILE *fp, const char *name, __u16 state)
+{
+	open_json_array(PRINT_ANY, name);
+	print_string(PRINT_FP, NULL, " <", NULL);
+#define _PF(s, str) if (state & AD_STATE_##s) {				\
+			state &= ~AD_STATE_##s;				\
+			print_string(PRINT_ANY, NULL,   		\
+				     state ? "%s," : "%s", str); }
+	_PF(LACP_ACTIVITY, "active");
+	_PF(LACP_TIMEOUT, "short_timeout");
+	_PF(AGGREGATION, "aggregating");
+	_PF(SYNCHRONIZATION, "in_sync");
+	_PF(COLLECTING, "collecting");
+	_PF(DISTRIBUTING, "distributing");
+	_PF(DEFAULTED, "defaulted");
+	_PF(EXPIRED, "expired");
+#undef _PF
+	close_json_array(PRINT_ANY, "> ");
+}
+
 static void bond_slave_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
 	SPRINT_BUF(b1);
@@ -106,17 +126,25 @@ static void bond_slave_print_opt(struct link_util *lu, FILE *f, struct rtattr *t
 			  "ad_aggregator_id %d ",
 			  rta_getattr_u16(tb[IFLA_BOND_SLAVE_AD_AGGREGATOR_ID]));
 
-	if (tb[IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE])
+	if (tb[IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE]) {
+		__u8 state = rta_getattr_u8(tb[IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE]);
+
 		print_int(PRINT_ANY,
 			  "ad_actor_oper_port_state",
 			  "ad_actor_oper_port_state %d ",
-			  rta_getattr_u8(tb[IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE]));
+			  state);
+		print_slave_oper_state(f, "ad_actor_oper_port_state_str", state);
+	}
+
+	if (tb[IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE]) {
+		__u16 state = rta_getattr_u8(tb[IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE]);
 
-	if (tb[IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE])
 		print_int(PRINT_ANY,
 			  "ad_partner_oper_port_state",
 			  "ad_partner_oper_port_state %d ",
-			  rta_getattr_u16(tb[IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE]));
+			  state);
+		print_slave_oper_state(f, "ad_partner_oper_port_state_str", state);
+	}
 }
 
 static int bond_slave_parse_opt(struct link_util *lu, int argc, char **argv,
-- 
2.20.1

