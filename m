Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 670BF1465D4
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgAWKdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:33:09 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47579 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726191AbgAWKdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:33:08 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from rondi@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Jan 2020 12:33:01 +0200
Received: from nps-server-35.mtl.labs.mlnx (nps-server-35.mtl.labs.mlnx [10.137.1.140])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00NAX19T002810;
        Thu, 23 Jan 2020 12:33:01 +0200
Received: from nps-server-35.mtl.labs.mlnx (localhost [127.0.0.1])
        by nps-server-35.mtl.labs.mlnx (8.15.2/8.15.2/Debian-11ubuntu1) with ESMTP id 00NAX1AT022715;
        Thu, 23 Jan 2020 12:33:01 +0200
Received: (from rondi@localhost)
        by nps-server-35.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 00NAX1ND022714;
        Thu, 23 Jan 2020 12:33:01 +0200
From:   Ron Diskin <rondi@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>,
        netdev@vger.kernel.org, Ron Diskin <rondi@mellanox.com>
Subject: [PATCH iproute2 2/6] json_print: Add new json object function not as array item
Date:   Thu, 23 Jan 2020 12:32:27 +0200
Message-Id: <1579775551-22659-3-git-send-email-rondi@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579775551-22659-1-git-send-email-rondi@mellanox.com>
References: <1579775551-22659-1-git-send-email-rondi@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently new json object opens (and delete_json_obj closes) the object as
an array, what adds prints for the matching bracket '[' ']' at the
start/end of the object. This patch adds new_json_obj_plain() and the
matching delete_json_obj_plain() to enable opening and closing json object,
not as array and leave it to the using function to decide which type of
object to open/close as the main object.

Signed-off-by: Ron Diskin <rondi@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/json_print.h |  2 ++
 lib/json_print.c     | 30 ++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/json_print.h b/include/json_print.h
index fd76cf75..4bcaccf7 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -31,6 +31,8 @@ enum output_type {
 
 void new_json_obj(int json);
 void delete_json_obj(void);
+void new_json_obj_plain(int json);
+void delete_json_obj_plain(void);
 
 bool is_json_context(void);
 
diff --git a/lib/json_print.c b/lib/json_print.c
index fb5f0e5d..8e7f32dc 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -20,7 +20,7 @@ static json_writer_t *_jw;
 #define _IS_JSON_CONTEXT(type) ((type & PRINT_JSON || type & PRINT_ANY) && _jw)
 #define _IS_FP_CONTEXT(type) (!_jw && (type & PRINT_FP || type & PRINT_ANY))
 
-void new_json_obj(int json)
+static void __new_json_obj(int json, bool have_array)
 {
 	if (json) {
 		_jw = jsonw_new(stdout);
@@ -30,18 +30,40 @@ void new_json_obj(int json)
 		}
 		if (pretty)
 			jsonw_pretty(_jw, true);
-		jsonw_start_array(_jw);
+		if (have_array)
+			jsonw_start_array(_jw);
 	}
 }
 
-void delete_json_obj(void)
+static void __delete_json_obj(bool have_array)
 {
 	if (_jw) {
-		jsonw_end_array(_jw);
+		if (have_array)
+			jsonw_end_array(_jw);
 		jsonw_destroy(&_jw);
 	}
 }
 
+void new_json_obj(int json)
+{
+	__new_json_obj(json, true);
+}
+
+void delete_json_obj(void)
+{
+	__delete_json_obj(true);
+}
+
+void new_json_obj_plain(int json)
+{
+	__new_json_obj(json, false);
+}
+
+void delete_json_obj_plain(void)
+{
+	__delete_json_obj(false);
+}
+
 bool is_json_context(void)
 {
 	return _jw != NULL;
-- 
2.19.1

