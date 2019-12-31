Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37B4412D891
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 13:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfLaMPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 07:15:08 -0500
Received: from internalmail.cumulusnetworks.com ([45.55.219.144]:47292 "EHLO
        internalmail.cumulusnetworks.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbfLaMPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 07:15:08 -0500
Received: from localhost (fw.cumulusnetworks.com [216.129.126.126])
        by internalmail.cumulusnetworks.com (Postfix) with ESMTPSA id ED22AC11CA;
        Tue, 31 Dec 2019 04:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cumulusnetworks.com;
        s=mail; t=1577794506;
        bh=TgQP8FmSi1MHmH4tJTk5Mz4ONOMqu04+5ygjKqGJ4aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=W40cBbhkRdGOD7gUGtEWgwSh/it2iTLF9CqIcbJcq0W9Jmqh67FjHBqcW0Hn+Xbiw
         s2CBJg4BaRBU7J5NMlXZsXUJ/vm0JS3eWl6grC0VtbywlrUGra7dMwmS+D8/tKORyE
         ODX24MH0NQfqeTddZnrEbPL8bBhsl1sh2UhxQngU=
From:   Andy Roulin <aroulin@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, aroulin@cumulusnetworks.com
Subject: [PATCH iproute2-next v3 2/2] iplink: bond: print lacp actor/partner oper states as strings
Date:   Tue, 31 Dec 2019 04:15:02 -0800
Message-Id: <1577794502-8063-3-git-send-email-aroulin@cumulusnetworks.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1577794502-8063-1-git-send-email-aroulin@cumulusnetworks.com>
References: <1577794502-8063-1-git-send-email-aroulin@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 802.3ad/LACP actor/partner operating states are only printed as
numbers, e.g,

ad_actor_oper_port_state 15

Add an additional output in ip link show that prints a string describing
the individual 3ad bit meanings in the following way:

ad_actor_oper_port_state_str <active,short_timeout,aggregating,in_sync>

JSON output is also supported, the field becomes a json array:

"ad_actor_oper_port_state_str":
	["active","short_timeout","aggregating","in_sync"]

Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
---
 ip/iplink_bond_slave.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/ip/iplink_bond_slave.c b/ip/iplink_bond_slave.c
index 4eaf72b8..34e9d1d6 100644
--- a/ip/iplink_bond_slave.c
+++ b/ip/iplink_bond_slave.c
@@ -68,6 +68,26 @@ static void print_slave_mii_status(FILE *f, struct rtattr *tb)
 			     slave_mii_status[status]);
 }
 
+static void print_slave_oper_state(FILE *fp, const char *name, __u16 state)
+{
+	open_json_array(PRINT_ANY, name);
+	print_string(PRINT_FP, NULL, " <", NULL);
+#define _PF(s, str) if (state & LACP_STATE_##s) {			\
+			state &= ~LACP_STATE_##s;			\
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

