Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 266EC1465D3
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgAWKdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:33:09 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47580 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726026AbgAWKdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:33:08 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from rondi@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Jan 2020 12:33:01 +0200
Received: from nps-server-35.mtl.labs.mlnx (nps-server-35.mtl.labs.mlnx [10.137.1.140])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00NAX1ZN002802;
        Thu, 23 Jan 2020 12:33:01 +0200
Received: from nps-server-35.mtl.labs.mlnx (localhost [127.0.0.1])
        by nps-server-35.mtl.labs.mlnx (8.15.2/8.15.2/Debian-11ubuntu1) with ESMTP id 00NAX1cq022712;
        Thu, 23 Jan 2020 12:33:01 +0200
Received: (from rondi@localhost)
        by nps-server-35.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 00NAX1VZ022711;
        Thu, 23 Jan 2020 12:33:01 +0200
From:   Ron Diskin <rondi@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>,
        netdev@vger.kernel.org, Ron Diskin <rondi@mellanox.com>
Subject: [PATCH iproute2 1/6] json_print: Introduce print_#type_name_value
Date:   Thu, 23 Jan 2020 12:32:26 +0200
Message-Id: <1579775551-22659-2-git-send-email-rondi@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579775551-22659-1-git-send-email-rondi@mellanox.com>
References: <1579775551-22659-1-git-send-email-rondi@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Until now print_#type functions supported printing constant names and
unknown (variable) values only.
Add functions to allow printing when the name is also sent to the
function as a variable.

Signed-off-by: Ron Diskin <rondi@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/json_print.h |  7 +++++++
 lib/json_print.c     | 13 +++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/json_print.h b/include/json_print.h
index 6695654f..fd76cf75 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -72,4 +72,11 @@ _PRINT_FUNC(lluint, unsigned long long)
 _PRINT_FUNC(float, double)
 #undef _PRINT_FUNC
 
+#define _PRINT_NAME_VALUE_FUNC(type_name, type, format_char)		  \
+	void print_##type_name##_name_value(const char *name, type value); \
+
+_PRINT_NAME_VALUE_FUNC(uint, unsigned int, u)
+_PRINT_NAME_VALUE_FUNC(string, const char*, s)
+#undef _PRINT_NAME_VALUE_FUNC
+
 #endif /* _JSON_PRINT_H_ */
diff --git a/lib/json_print.c b/lib/json_print.c
index 43ea69bb..fb5f0e5d 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -127,6 +127,19 @@ _PRINT_FUNC(lluint, unsigned long long);
 _PRINT_FUNC(float, double);
 #undef _PRINT_FUNC
 
+#define _PRINT_NAME_VALUE_FUNC(type_name, type, format_char)		 \
+	void print_##type_name##_name_value(const char *name, type value)\
+	{								 \
+		SPRINT_BUF(format);					 \
+									 \
+		snprintf(format, SPRINT_BSIZE,				 \
+			 "%s %%"#format_char, name);			 \
+		print_##type_name(PRINT_ANY, name, format, value);	 \
+	}
+_PRINT_NAME_VALUE_FUNC(uint, unsigned int, u);
+_PRINT_NAME_VALUE_FUNC(string, const char*, s);
+#undef _PRINT_NAME_VALUE_FUNC
+
 void print_color_string(enum output_type type,
 			enum color_attr color,
 			const char *key,
-- 
2.19.1

