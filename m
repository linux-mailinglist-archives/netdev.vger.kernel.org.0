Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E13625A4
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391074AbfGHQG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:06:29 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33966 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391036AbfGHQG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:06:28 -0400
Received: by mail-io1-f66.google.com with SMTP id k8so36539097iot.1
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=4CKXMzu9w3TYk+GHBZ3Tl0q3tzR3w2JGmRvyZ5OMhLk=;
        b=mP6A61du0ilH09iTatSfGDZ25En30anjBhp4g+NPHJ0z9neQCj2Or3otiBSq3NqxEf
         eK1CxkXe84aCVI64edMsPlLGQXftDA8IvunbyZ9T2H4CCrbp6OGdUlINIi4CSM0NHMop
         5LN6T6v2SYXyp9w+wTYGqGayYETYAuE7vWnfcSW/yvybdHdJZVFaq5irEWx6+d3dhbGK
         KeD8JK1K7Q4j28ZHXRQxkBEJC55VD9DmnuhaHytabvFdKGND2Qq5H1nGXGEaLbl7X6vS
         BmLJhY4JUl5NO1ijdIGuXymX2TOLYEbCMUEl534uSpbYXWM2uoh4KQ7boQg5msGJ0a19
         28vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4CKXMzu9w3TYk+GHBZ3Tl0q3tzR3w2JGmRvyZ5OMhLk=;
        b=oD0pD5q+NN268IfPu5C9Twn2l/A6/KJ8fB1XhzqqI2cdjZdrLYfW+ZRT+A3moqvghI
         FM36YuvwXjr/cvqC/Xc0IWN/9HhEt08jllGhRXSNsAtUrewywMAL0bk5FR+LM/vBzHVy
         n6w8Tq0N1VJ2Mn6fIwZkICgL1jV+af+CPTBkS3f9jYet5GKKhdVA6LfFQhonkLjxC/gL
         yC4FwS8qoweZN6yhaGRtq3/4tyhIxYlES6/li+ArT0rGAWL18JIGWRLJTOf1cZvixReG
         27sU+jSoHllv7DtZM/d0UX0TSZvtX/xM0ran00lwiTn0X1pEpRMGMieWDjCJDCkMoG4D
         DOTQ==
X-Gm-Message-State: APjAAAWAAvJ/HXLVLy2xuhY5h2sYZQD4zuT9VLVQvJWw1sZyD2RGe7zR
        uDs+oHCoRmsS/m4OJM9/xoPUGg==
X-Google-Smtp-Source: APXvYqwZNImM3CDUInL0ZtsgPhFXX1yD++6ldayI+BDE0p/ZdC6jrezdE4bDgfDwXGQLvkMQKOocFA==
X-Received: by 2002:a6b:730f:: with SMTP id e15mr19384545ioh.74.1562601987335;
        Mon, 08 Jul 2019 09:06:27 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id f20sm16098738ioh.17.2019.07.08.09.06.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 08 Jul 2019 09:06:26 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH iproute2 v2 1/2] tc: added mask parameter in skbedit action
Date:   Mon,  8 Jul 2019 12:06:17 -0400
Message-Id: <1562601978-3611-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 32-bit missing mask attribute in iproute2/tc, which has been long
supported by the kernel side.

v2: print value in hex with print_hex() as suggested by Stephen Hemminger.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 tc/m_skbedit.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/tc/m_skbedit.c b/tc/m_skbedit.c
index b6b839f8ef6c..70e3a2e4eade 100644
--- a/tc/m_skbedit.c
+++ b/tc/m_skbedit.c
@@ -33,7 +33,7 @@ static void explain(void)
 	fprintf(stderr, "Usage: ... skbedit <[QM] [PM] [MM] [PT] [IF]>\n"
 		"QM = queue_mapping QUEUE_MAPPING\n"
 		"PM = priority PRIORITY\n"
-		"MM = mark MARK\n"
+		"MM = mark MARK[/MASK]\n"
 		"PT = ptype PACKETYPE\n"
 		"IF = inheritdsfield\n"
 		"PACKETYPE = is one of:\n"
@@ -41,6 +41,7 @@ static void explain(void)
 		"QUEUE_MAPPING = device transmit queue to use\n"
 		"PRIORITY = classID to assign to priority field\n"
 		"MARK = firewall mark to set\n"
+		"MASK = mask applied to firewall mark (0xffffffff by default)\n"
 		"note: inheritdsfield maps DS field to skb->priority\n");
 }
 
@@ -61,7 +62,7 @@ parse_skbedit(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
 	struct rtattr *tail;
 	unsigned int tmp;
 	__u16 queue_mapping, ptype;
-	__u32 flags = 0, priority, mark;
+	__u32 flags = 0, priority, mark, mask;
 	__u64 pure_flags = 0;
 	struct tc_skbedit sel = { 0 };
 
@@ -89,12 +90,26 @@ parse_skbedit(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
 			}
 			ok++;
 		} else if (matches(*argv, "mark") == 0) {
-			flags |= SKBEDIT_F_MARK;
+			char *slash;
+
 			NEXT_ARG();
+			slash = strchr(*argv, '/');
+			if (slash)
+				*slash = '\0';
+
+			flags |= SKBEDIT_F_MARK;
 			if (get_u32(&mark, *argv, 0)) {
 				fprintf(stderr, "Illegal mark\n");
 				return -1;
 			}
+
+			if (slash) {
+				if (get_u32(&mask, slash + 1, 0)) {
+					fprintf(stderr, "Illegal mask\n");
+					return -1;
+				}
+				flags |= SKBEDIT_F_MASK;
+			}
 			ok++;
 		} else if (matches(*argv, "ptype") == 0) {
 
@@ -133,7 +148,7 @@ parse_skbedit(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
 		if (matches(*argv, "index") == 0) {
 			NEXT_ARG();
 			if (get_u32(&sel.index, *argv, 10)) {
-				fprintf(stderr, "Pedit: Illegal \"index\"\n");
+				fprintf(stderr, "skbedit: Illegal \"index\"\n");
 				return -1;
 			}
 			argc--;
@@ -159,6 +174,9 @@ parse_skbedit(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
 	if (flags & SKBEDIT_F_MARK)
 		addattr_l(n, MAX_MSG, TCA_SKBEDIT_MARK,
 			  &mark, sizeof(mark));
+	if (flags & SKBEDIT_F_MASK)
+		addattr_l(n, MAX_MSG, TCA_SKBEDIT_MASK,
+			  &mask, sizeof(mask));
 	if (flags & SKBEDIT_F_PTYPE)
 		addattr_l(n, MAX_MSG, TCA_SKBEDIT_PTYPE,
 			  &ptype, sizeof(ptype));
@@ -206,6 +224,10 @@ static int print_skbedit(struct action_util *au, FILE *f, struct rtattr *arg)
 		print_uint(PRINT_ANY, "mark", " mark %u",
 			   rta_getattr_u32(tb[TCA_SKBEDIT_MARK]));
 	}
+	if (tb[TCA_SKBEDIT_MASK]) {
+		print_hex(PRINT_ANY, "mask", "/%#x",
+			  rta_getattr_u32(tb[TCA_SKBEDIT_MASK]));
+	}
 	if (tb[TCA_SKBEDIT_PTYPE] != NULL) {
 		ptype = rta_getattr_u16(tb[TCA_SKBEDIT_PTYPE]);
 		if (ptype == PACKET_HOST)
-- 
2.7.4

