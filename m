Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B1D44462D
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbhKCQrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:47:49 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:60692 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbhKCQrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 12:47:46 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id iJNLmc3ywk3HQiJNqmsMyR; Wed, 03 Nov 2021 17:45:09 +0100
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Wed, 03 Nov 2021 17:45:09 +0100
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH iproute2-next 5.16 v6 2/5] iplink_can: code refactoring of print_ctrlmode()
Date:   Thu,  4 Nov 2021 01:44:25 +0900
Message-Id: <20211103164428.692722-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211103164428.692722-1-mailhol.vincent@wanadoo.fr>
References: <20211103164428.692722-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch only does cleanup and do not introduce any functional
changes.

We do some code refactoring of print_ctrlmode() in prevision of the
upcoming patch:

  - remove the first argument of print_ctrlmode(). It is a pointer to
    FILE and is never used.

  - add a new function argument: enum output_type t in order to
    specify the output type (i.e. PRINT_{FP,JSON,ANY}).

  - add a new function argument: const char *key in order to specify
    the name of the json array (e.g. "ctrlmode").

  - replace the _PF() macro with the print_flag() function to increase
    readability.

  - directly return if none of the flags are set (previously, this
    check was done before calling the function).

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 ip/iplink_can.c | 52 ++++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 0b2ff8a3..c910365d 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -88,34 +88,43 @@ static void set_ctrlmode(char *name, char *arg,
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
+		print_string(t, NULL, *flags ? "%s," : "%s", name);
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
 			 struct nlmsghdr *n)
 {
 	struct can_bittiming bt = {}, dbt = {};
-	struct can_ctrlmode cm = {0, 0};
+	struct can_ctrlmode cm = { 0 };
 
 	while (argc > 0) {
 		if (matches(*argv, "bitrate") == 0) {
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

