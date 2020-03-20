Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D31DC18D8EA
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 21:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgCTUVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 16:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgCTUVt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 16:21:49 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E417C2072C;
        Fri, 20 Mar 2020 20:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584735709;
        bh=5MxXiNlaxkSrV5kXV9n5kbNoUGDmotCxPRAYt7ylxmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U81RNk9Sqy4Jxl/5uRbW4XF2/IGO+BtHj46XnVORtAVnTX1Yvj7lIGQYWZrKeRlcP
         6rjFDdwGZPLcl6o+6vn7ONCCEthhSWBRwc3TTgPjuJydSj1kjyzis+7FEVjJEeBvCz
         D8hCJCw6+UB4mpASajaewqbvigJuSYQG2UmtiAX0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        jiri@resnulli.us, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH iproute2-next] tc: m_action: rename hw stats type uAPI
Date:   Fri, 20 Mar 2020 13:21:45 -0700
Message-Id: <20200320202145.149844-1-kuba@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <4e960372-2a5e-5a38-b2ae-843957f0cd67@gmail.com>
References: <4e960372-2a5e-5a38-b2ae-843957f0cd67@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow the kernel rename to shorten the identifiers.
Rename hw_stats_type to hw_stats.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tc/m_action.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/tc/m_action.c b/tc/m_action.c
index 58ae1846033b..2c4b5df6e05c 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -150,31 +150,30 @@ new_cmd(char **argv)
 		(matches(*argv, "add") == 0);
 }
 
-static const struct hw_stats_type_item {
+static const struct hw_stats_item {
 	const char *str;
 	__u8 type;
-} hw_stats_type_items[] = {
-	{ "immediate", TCA_ACT_HW_STATS_TYPE_IMMEDIATE },
-	{ "delayed", TCA_ACT_HW_STATS_TYPE_DELAYED },
+} hw_stats_items[] = {
+	{ "immediate", TCA_ACT_HW_STATS_IMMEDIATE },
+	{ "delayed", TCA_ACT_HW_STATS_DELAYED },
 	{ "disabled", 0 }, /* no bit set */
 };
 
 static void print_hw_stats(const struct rtattr *arg)
 {
-	struct nla_bitfield32 *hw_stats_type_bf = RTA_DATA(arg);
-	__u8 hw_stats_type;
+	struct nla_bitfield32 *hw_stats_bf = RTA_DATA(arg);
+	__u8 hw_stats;
 	int i;
 
-	hw_stats_type = hw_stats_type_bf->value & hw_stats_type_bf->selector;
+	hw_stats = hw_stats_bf->value & hw_stats_bf->selector;
 	print_string(PRINT_FP, NULL, "\t", NULL);
 	open_json_array(PRINT_ANY, "hw_stats");
 
-	for (i = 0; i < ARRAY_SIZE(hw_stats_type_items); i++) {
-		const struct hw_stats_type_item *item;
+	for (i = 0; i < ARRAY_SIZE(hw_stats_items); i++) {
+		const struct hw_stats_item *item;
 
-		item = &hw_stats_type_items[i];
-		if ((!hw_stats_type && !item->type) ||
-		    hw_stats_type & item->type)
+		item = &hw_stats_items[i];
+		if ((!hw_stats && !item->type) || hw_stats & item->type)
 			print_string(PRINT_ANY, NULL, " %s", item->str);
 	}
 	close_json_array(PRINT_JSON, NULL);
@@ -184,18 +183,18 @@ static int parse_hw_stats(const char *str, struct nlmsghdr *n)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(hw_stats_type_items); i++) {
-		const struct hw_stats_type_item *item;
+	for (i = 0; i < ARRAY_SIZE(hw_stats_items); i++) {
+		const struct hw_stats_item *item;
 
-		item = &hw_stats_type_items[i];
+		item = &hw_stats_items[i];
 		if (matches(str, item->str) == 0) {
-			struct nla_bitfield32 hw_stats_type_bf = {
+			struct nla_bitfield32 hw_stats_bf = {
 				.value = item->type,
 				.selector = item->type
 			};
 
-			addattr_l(n, MAX_MSG, TCA_ACT_HW_STATS_TYPE,
-				  &hw_stats_type_bf, sizeof(hw_stats_type_bf));
+			addattr_l(n, MAX_MSG, TCA_ACT_HW_STATS,
+				  &hw_stats_bf, sizeof(hw_stats_bf));
 			return 0;
 		}
 
@@ -399,8 +398,8 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
 				   TCA_ACT_FLAGS_NO_PERCPU_STATS);
 		print_string(PRINT_FP, NULL, "%s", _SL_);
 	}
-	if (tb[TCA_ACT_HW_STATS_TYPE])
-		print_hw_stats(tb[TCA_ACT_HW_STATS_TYPE]);
+	if (tb[TCA_ACT_HW_STATS])
+		print_hw_stats(tb[TCA_ACT_HW_STATS]);
 
 	return 0;
 }
-- 
2.25.1

