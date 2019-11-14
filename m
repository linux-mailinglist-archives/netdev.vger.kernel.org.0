Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB82CFC67B
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 13:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfKNMo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 07:44:58 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33960 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726661AbfKNMo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 07:44:58 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 Nov 2019 14:44:53 +0200
Received: from dev-r-vrt-139.mtr.labs.mlnx (dev-r-vrt-139.mtr.labs.mlnx [10.212.139.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xAECirEF024546;
        Thu, 14 Nov 2019 14:44:53 +0200
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH iproute2 v2 1/5] tc_util: introduce a function to print JSON/non-JSON masked numbers
Date:   Thu, 14 Nov 2019 14:44:37 +0200
Message-Id: <20191114124441.2261-2-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20191114124441.2261-1-roid@mellanox.com>
References: <20191114124441.2261-1-roid@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

Introduce a function to print masked number with a different output for
JSON or non-JSON methods, as a pre-step towards printing numbers using
this common function.

Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---

Notes:
    v2:
    - use _SL_ instead of \n for newline.
    - return earlier if attr is not defined.

 tc/tc_util.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tc/tc_util.h |  2 ++
 2 files changed, 53 insertions(+)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 0eb530408d05..6bd098feff14 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -915,6 +915,45 @@ compat_xstats:
 		*xstats = tb[TCA_XSTATS];
 }
 
+static void print_masked_type(__u32 type_max,
+			      __u32 (*rta_getattr_type)(const struct rtattr *),
+			      const char *name, struct rtattr *attr,
+			      struct rtattr *mask_attr)
+{
+	SPRINT_BUF(namefrm);
+	__u32 value, mask;
+	SPRINT_BUF(out);
+	size_t done;
+
+	if (!attr)
+		return;
+
+	value = rta_getattr_type(attr);
+	mask = mask_attr ? rta_getattr_type(mask_attr) : type_max;
+
+	if (is_json_context()) {
+		sprintf(namefrm, "\n  %s %%u", name);
+		print_hu(PRINT_ANY, name, namefrm,
+			 rta_getattr_type(attr));
+		if (mask != type_max) {
+			char mask_name[SPRINT_BSIZE-6];
+
+			sprintf(mask_name, "%s_mask", name);
+			print_string(PRINT_FP, NULL, "%s  ", _SL_);
+			sprintf(namefrm, "%s %%u", mask_name);
+			print_hu(PRINT_ANY, mask_name, namefrm, mask);
+		}
+	} else {
+		done = sprintf(out, "%u", value);
+		if (mask != type_max)
+			sprintf(out + done, "/0x%x", mask);
+
+		print_string(PRINT_FP, NULL, "%s  ", _SL_);
+		sprintf(namefrm, "%s %%s", name);
+		print_string(PRINT_ANY, name, namefrm, out);
+	}
+}
+
 void print_masked_u32(const char *name, struct rtattr *attr,
 		      struct rtattr *mask_attr)
 {
@@ -958,3 +997,15 @@ void print_masked_u16(const char *name, struct rtattr *attr,
 	sprintf(namefrm, " %s %%s", name);
 	print_string(PRINT_ANY, name, namefrm, out);
 }
+
+static __u32 __rta_getattr_u8_u32(const struct rtattr *attr)
+{
+	return rta_getattr_u8(attr);
+}
+
+void print_masked_u8(const char *name, struct rtattr *attr,
+		     struct rtattr *mask_attr)
+{
+	print_masked_type(UINT8_MAX,  __rta_getattr_u8_u32, name, attr,
+			  mask_attr);
+}
diff --git a/tc/tc_util.h b/tc/tc_util.h
index 0c3425abc62f..7e5d93cbac66 100644
--- a/tc/tc_util.h
+++ b/tc/tc_util.h
@@ -131,4 +131,6 @@ void print_masked_u32(const char *name, struct rtattr *attr,
 		      struct rtattr *mask_attr);
 void print_masked_u16(const char *name, struct rtattr *attr,
 		      struct rtattr *mask_attr);
+void print_masked_u8(const char *name, struct rtattr *attr,
+		     struct rtattr *mask_attr);
 #endif
-- 
2.8.4

