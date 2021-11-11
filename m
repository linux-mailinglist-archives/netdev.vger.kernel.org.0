Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F20E44D45F
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 10:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbhKKJww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 04:52:52 -0500
Received: from mail-m973.mail.163.com ([123.126.97.3]:46160 "EHLO
        mail-m973.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhKKJwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 04:52:51 -0500
X-Greylist: delayed 931 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Nov 2021 04:52:51 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=cnimH
        2sWS8GES8zs2U4AFCoPOZkNJzoZ57TS+VXGMTg=; b=nVtI0UV7w0qSuAtuhTDm7
        dBweMFgtUaEgT3tuKYTAy7Bot8XR4aUO0oWJkIoKszUidwFNzb6qjdcciw25dodC
        w9lq1cvvTxBLDAr1UnKZNWB7yXcKakDLj2MyG2MeCWmrOqy/Qn5TehS6tsDwwNuc
        d+Zycr28c1uiK65IQUFlHQ=
Received: from localhost.localdomain (unknown [210.22.22.150])
        by smtp3 (Coremail) with SMTP id G9xpCgDXuICl44xhgu3JQA--.3516S2;
        Thu, 11 Nov 2021 17:34:30 +0800 (CST)
From:   15720603159@163.com
To:     netdev@vger.kernel.org
Cc:     jinag <jinag12138@gmail.com>
Subject: [PATCH iproute2] bridge: use strtoi instead of atoi for checking value of cost/priority
Date:   Thu, 11 Nov 2021 17:33:23 +0800
Message-Id: <20211111093323.5129-1-15720603159@163.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: G9xpCgDXuICl44xhgu3JQA--.3516S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7urykZr1rXryfZFWUAF4ruFg_yoW8JF47pr
        ZxKFyq9ryrJr47tayIkFnYva4fG3Z5tr4YyFZF9392yFyrXF4UZa40yF9I9r1kJFWfX398
        Aay5ZFW8uF17ZFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jkCztUUUUU=
X-Originating-IP: [210.22.22.150]
X-CM-SenderInfo: jprvljyqwqjievzbjqqrwthudrp/1tbiXAZIhVXl1bklgQAAsv
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jinag <jinag12138@gmail.com>

Signed-off-by: jinag <jinag12138@gmail.com>
---
 bridge/link.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/bridge/link.c b/bridge/link.c
index 205a2fe7..d60e1106 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -308,13 +308,14 @@ static int brlink_modify(int argc, char **argv)
 	__s8 bpdu_guard = -1;
 	__s8 fast_leave = -1;
 	__s8 root_block = -1;
-	__u32 cost = 0;
+	__s32 cost = 0;
 	__s16 priority = -1;
 	__s8 state = -1;
 	__s16 mode = -1;
 	__u16 flags = 0;
 	struct rtattr *nest;
 	int ret;
+	char *end = NULL;
 
 	while (argc > 0) {
 		if (strcmp(*argv, "dev") == 0) {
@@ -367,10 +368,19 @@ static int brlink_modify(int argc, char **argv)
 				return ret;
 		} else if (strcmp(*argv, "cost") == 0) {
 			NEXT_ARG();
-			cost = atoi(*argv);
+			cost = strtoul(*argv, &end, 10);
+			if ((cost <= 0) || (end == NULL) || (*end != '\0')) {
+				fprintf(stderr, "Error: invalid cost value\n");
+				return -1;
+			}
 		} else if (strcmp(*argv, "priority") == 0) {
 			NEXT_ARG();
 			priority = atoi(*argv);
+			priority = strtol(*argv, &end, 10);
+			if ((priority < 0) || (end == NULL) || (*end != '\0')) {
+				fprintf(stderr, "Error: invalid priority\n");
+				return -1;
+			}
 		} else if (strcmp(*argv, "state") == 0) {
 			NEXT_ARG();
 			char *endptr;
-- 
2.30.0

