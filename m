Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E7042001C
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 07:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhJCFEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 01:04:43 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:54767 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhJCFEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 01:04:41 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id WtdMmhDZXsoWhWteGm9Qbb; Sun, 03 Oct 2021 07:02:54 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sun, 03 Oct 2021 07:02:54 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH v1 1/3] iplink_can: code refactoring of print_ctrlmode()
Date:   Sun,  3 Oct 2021 14:01:45 +0900
Message-Id: <20211003050147.569044-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211003050147.569044-1-mailhol.vincent@wanadoo.fr>
References: <20211003050147.569044-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We do some code refactoring of print_ctrlmode() in prevision of the
upcoming patch:

  - add a new function argument: enum output_type t in order to
    specify the output type (i.e. PRINT_{FP,JSON,ANY}).

  - add a new function argument: const char *key in order to specify
    the name of the json array (e.g. "ctrlmode"). This will be use in
    the upcoming patch to specify other entries: "ctrlmode_supported"
    and "ctrlmode_static".

  - replace the _PF() macro with the print_flag() function to increase
    readability.

  - directly return if none of the flags are set (previously, this
    check was done before calling the function).

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
---
 ip/iplink_can.c | 50 ++++++++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 6a26f3ff..c70c420d 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -88,27 +88,36 @@ static void set_ctrlmode(char *name, char *arg,
 	cm->mask |= flags;
 }
 
-static void print_ctrlmode(FILE *f, __u32 cm)
+static void print_flag(enum output_type t, __u32 *flags, __u32 flag,
+		       const char* name)
 {
-	open_json_array(PRINT_ANY, is_json_context() ? "ctrlmode" : "<");
-#define _PF(cmflag, cmname)						\
-	if (cm & cmflag) {						\
-		cm &= ~cmflag;						\
-		print_string(PRINT_ANY, NULL, cm ? "%s," : "%s", cmname); \
+	if (*flags & flag) {
+		*flags &= ~flag;
+		print_string(t, NULL, *flags ? "%s, " : "%s", name);
 	}
-	_PF(CAN_CTRLMODE_LOOPBACK, "LOOPBACK");
-	_PF(CAN_CTRLMODE_LISTENONLY, "LISTEN-ONLY");
-	_PF(CAN_CTRLMODE_3_SAMPLES, "TRIPLE-SAMPLING");
-	_PF(CAN_CTRLMODE_ONE_SHOT, "ONE-SHOT");
-	_PF(CAN_CTRLMODE_BERR_REPORTING, "BERR-REPORTING");
-	_PF(CAN_CTRLMODE_FD, "FD");
-	_PF(CAN_CTRLMODE_FD_NON_ISO, "FD-NON-ISO");
-	_PF(CAN_CTRLMODE_PRESUME_ACK, "PRESUME-ACK");
-	_PF(CAN_CTRLMODE_CC_LEN8_DLC, "CC-LEN8-DLC");
-#undef _PF
-	if (cm)
-		print_hex(PRINT_ANY, NULL, "%x", cm);
-	close_json_array(PRINT_ANY, "> ");
+}
+
+static void print_ctrlmode(enum output_type t, __u32 flags, const char* key)
+{
+	if (!flags)
+		return;
+
+	open_json_array(t, is_json_context() ? key : "<");
+
+	print_flag(t, &flags, CAN_CTRLMODE_LOOPBACK, "LOOPBACK");
+	print_flag(t, &flags, CAN_CTRLMODE_LISTENONLY, "LISTEN-ONLY");
+	print_flag(t, &flags, CAN_CTRLMODE_3_SAMPLES, "TRIPLE-SAMPLING");
+	print_flag(t, &flags, CAN_CTRLMODE_ONE_SHOT, "ONE-SHOT");
+	print_flag(t, &flags, CAN_CTRLMODE_BERR_REPORTING, "BERR-REPORTING");
+	print_flag(t, &flags, CAN_CTRLMODE_FD, "FD");
+	print_flag(t, &flags, CAN_CTRLMODE_FD_NON_ISO, "FD-NON-ISO");
+	print_flag(t, &flags, CAN_CTRLMODE_PRESUME_ACK, "PRESUME-ACK");
+	print_flag(t, &flags, CAN_CTRLMODE_CC_LEN8_DLC, "CC-LEN8-DLC");
+
+	if (flags)
+		print_hex(t, NULL, "%x", flags);
+
+	close_json_array(t, "> ");
 }
 
 static int can_parse_opt(struct link_util *lu, int argc, char **argv,
@@ -282,8 +291,7 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 	if (tb[IFLA_CAN_CTRLMODE]) {
 		struct can_ctrlmode *cm = RTA_DATA(tb[IFLA_CAN_CTRLMODE]);
 
-		if (cm->flags)
-			print_ctrlmode(f, cm->flags);
+		print_ctrlmode(PRINT_ANY, cm->flags, "ctrlmode");
 	}
 
 	if (tb[IFLA_CAN_STATE]) {
-- 
2.32.0

