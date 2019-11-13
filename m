Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87CE9FAE3E
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 11:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfKMKOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 05:14:07 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53668 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727298AbfKMKOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 05:14:06 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 13 Nov 2019 12:13:59 +0200
Received: from mtr-vdi-191.wap.labs.mlnx. (mtr-vdi-191.wap.labs.mlnx [10.209.100.28])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xADADwQN009511;
        Wed, 13 Nov 2019 12:13:59 +0200
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH iproute2 2/5] tc_util: add an option to print masked numbers with/without a newline
Date:   Wed, 13 Nov 2019 12:12:42 +0200
Message-Id: <20191113101245.182025-3-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20191113101245.182025-1-roid@mellanox.com>
References: <20191113101245.182025-1-roid@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

Add an option to print masked numbers with or without a newline, as a
pre-step towards using a common function.

Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 tc/f_flower.c |  4 ++--
 tc/m_ct.c     |  4 ++--
 tc/tc_util.c  | 17 +++++++++--------
 tc/tc_util.h  |  6 +++---
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index a2a230162f78..41b81217e47e 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -1847,13 +1847,13 @@ static void flower_print_ct_label(struct rtattr *attr,
 static void flower_print_ct_zone(struct rtattr *attr,
 				 struct rtattr *mask_attr)
 {
-	print_masked_u16("ct_zone", attr, mask_attr);
+	print_masked_u16("ct_zone", attr, mask_attr, false);
 }
 
 static void flower_print_ct_mark(struct rtattr *attr,
 				 struct rtattr *mask_attr)
 {
-	print_masked_u32("ct_mark", attr, mask_attr);
+	print_masked_u32("ct_mark", attr, mask_attr, false);
 }
 
 static void flower_print_key_id(const char *name, struct rtattr *attr)
diff --git a/tc/m_ct.c b/tc/m_ct.c
index d79eb5e361ac..8df2f6103601 100644
--- a/tc/m_ct.c
+++ b/tc/m_ct.c
@@ -466,8 +466,8 @@ static int print_ct(struct action_util *au, FILE *f, struct rtattr *arg)
 		print_string(PRINT_ANY, "action", " %s", "clear");
 	}
 
-	print_masked_u32("mark", tb[TCA_CT_MARK], tb[TCA_CT_MARK_MASK]);
-	print_masked_u16("zone", tb[TCA_CT_ZONE], NULL);
+	print_masked_u32("mark", tb[TCA_CT_MARK], tb[TCA_CT_MARK_MASK], false);
+	print_masked_u16("zone", tb[TCA_CT_ZONE], NULL, false);
 	ct_print_labels(tb[TCA_CT_LABELS], tb[TCA_CT_LABELS_MASK]);
 	ct_print_nat(ct_action, tb);
 
diff --git a/tc/tc_util.c b/tc/tc_util.c
index 2b391f182b96..d1ef4fac13f6 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -918,7 +918,7 @@ compat_xstats:
 static void print_masked_type(__u32 type_max,
 			      __u32 (*rta_getattr_type)(const struct rtattr *),
 			      const char *name, struct rtattr *attr,
-			      struct rtattr *mask_attr)
+			      struct rtattr *mask_attr, bool newline)
 {
 	SPRINT_BUF(namefrm);
 	__u32 value, mask;
@@ -945,14 +945,15 @@ static void print_masked_type(__u32 type_max,
 			if (mask != type_max)
 				sprintf(out + done, "/0x%x", mask);
 
-			sprintf(namefrm, "\n  %s %%s", name);
+			sprintf(namefrm, "%s %s %%s", newline ? "\n " : "",
+				name);
 			print_string(PRINT_ANY, name, namefrm, out);
 		}
 	}
 }
 
 void print_masked_u32(const char *name, struct rtattr *attr,
-		      struct rtattr *mask_attr)
+		      struct rtattr *mask_attr, bool newline)
 {
 	__u32 value, mask;
 	SPRINT_BUF(namefrm);
@@ -969,12 +970,12 @@ void print_masked_u32(const char *name, struct rtattr *attr,
 	if (mask != UINT32_MAX)
 		sprintf(out + done, "/0x%x", mask);
 
-	sprintf(namefrm, " %s %%s", name);
+	sprintf(namefrm, "%s %s %%s", newline ? "\n " : "", name);
 	print_string(PRINT_ANY, name, namefrm, out);
 }
 
 void print_masked_u16(const char *name, struct rtattr *attr,
-		      struct rtattr *mask_attr)
+		      struct rtattr *mask_attr, bool newline)
 {
 	__u16 value, mask;
 	SPRINT_BUF(namefrm);
@@ -991,7 +992,7 @@ void print_masked_u16(const char *name, struct rtattr *attr,
 	if (mask != UINT16_MAX)
 		sprintf(out + done, "/0x%x", mask);
 
-	sprintf(namefrm, " %s %%s", name);
+	sprintf(namefrm, "%s %s %%s", newline ? "\n " : "", name);
 	print_string(PRINT_ANY, name, namefrm, out);
 }
 
@@ -1001,8 +1002,8 @@ static __u32 __rta_getattr_u8_u32(const struct rtattr *attr)
 }
 
 void print_masked_u8(const char *name, struct rtattr *attr,
-		     struct rtattr *mask_attr)
+		     struct rtattr *mask_attr, bool newline)
 {
 	print_masked_type(UINT8_MAX,  __rta_getattr_u8_u32, name, attr,
-			  mask_attr);
+			  mask_attr, newline);
 }
diff --git a/tc/tc_util.h b/tc/tc_util.h
index 7e5d93cbac66..9adf2ab42138 100644
--- a/tc/tc_util.h
+++ b/tc/tc_util.h
@@ -128,9 +128,9 @@ int action_a2n(char *arg, int *result, bool allow_num);
 bool tc_qdisc_block_exists(__u32 block_index);
 
 void print_masked_u32(const char *name, struct rtattr *attr,
-		      struct rtattr *mask_attr);
+		      struct rtattr *mask_attr, bool newline);
 void print_masked_u16(const char *name, struct rtattr *attr,
-		      struct rtattr *mask_attr);
+		      struct rtattr *mask_attr, bool newline);
 void print_masked_u8(const char *name, struct rtattr *attr,
-		     struct rtattr *mask_attr);
+		     struct rtattr *mask_attr, bool newline);
 #endif
-- 
2.8.4

