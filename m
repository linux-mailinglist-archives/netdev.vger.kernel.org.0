Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6B75EF82
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 01:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfGCXFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 19:05:44 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46505 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfGCXFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 19:05:43 -0400
Received: by mail-io1-f68.google.com with SMTP id i10so8774223iol.13
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 16:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=+zC9Tzfmx77Wn68Z82+otzkVy3oal99q9oMD5yv/YeY=;
        b=arCqi1Zk3ybTEfXjLajvloOATZNdldDK2hy/yNQKG9QeQzH4X+EOQD0L0RrtAN/Cci
         OThARPe+3p+tFG4TEcjVH2XIk92y3FE1H18EwG5bQt7EUL1/Zd/u2mB5NF1GiZc4INmS
         j/x5gdq4o87pN2DuEIqZnAraKX0eU5lbsWQ4axZ4DZV907cSa1+DwU/tdZ106OUaosru
         WdZzGGsBFzPn1HlhHuIbZrCL+n6gtqSpgVQPGTCSTaA47BP56oPLmPpHU+/ONyINSFkX
         FLEx7FEEakIdbr784YgvDxGXGA0yYetHGuMMeEhmy9NW2kj37P554ww8C5I03KRDNah8
         64mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+zC9Tzfmx77Wn68Z82+otzkVy3oal99q9oMD5yv/YeY=;
        b=otwjPI/burJCGBKoaoY2HL4CTmM5M6EB3vyGwp3jGpSJqxz1PuOhVhV1CTHrEfANpU
         5IqSX/lisSYS5c135U799ROz2xTUKoJZxa7sYX20kvnTuqW0FCZoEP9F++06XfIrAdcx
         +DVt3qhtSMjaJZnVtzBEzR1ASAu5YzBA2T8OkgbBYVBGOiB2XB9CCEpzk+BB0wuImWqN
         ddT70aghGB8gkaoQZFYsZQI+mgQplskmihpA4CjeRNyf6DMAFSFvEcmbB1wLdyTfPI12
         PPCx11SJF0ZOalvIL9gr0xd8YNlrMULZxHoHm0SeniHEE11GRdTilEj1MrYE84F8Yr+S
         yvIg==
X-Gm-Message-State: APjAAAU/jVbtKwPzKxpUuzESgFmYpODDNlTuwSM7WsTDNwCXjMfly0S7
        gvqbe4mNzvW7URiTuYDxh8Jj8Q==
X-Google-Smtp-Source: APXvYqy6NU/col7n1MHi5jMGCYFVR/2E+hHYRlUYkgCrk3lsMCaBOZf15YXMF6CCAUVTPxrLmU8+ow==
X-Received: by 2002:a6b:e615:: with SMTP id g21mr11946263ioh.178.1562195142566;
        Wed, 03 Jul 2019 16:05:42 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id x13sm2803180ioj.18.2019.07.03.16.05.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 03 Jul 2019 16:05:41 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH iproute2 1/2] tc: added mask parameter in skbedit action
Date:   Wed,  3 Jul 2019 19:05:31 -0400
Message-Id: <1562195132-9829-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 32-bit missing mask attribute in iproute2/tc, which has been long
supported by the kernel side.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 tc/m_skbedit.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/tc/m_skbedit.c b/tc/m_skbedit.c
index b6b839f8ef6c..f47c9705a990 100644
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
+		print_uint(PRINT_ANY, "mask", "/0x%x",
+			   rta_getattr_u32(tb[TCA_SKBEDIT_MASK]));
+	}
 	if (tb[TCA_SKBEDIT_PTYPE] != NULL) {
 		ptype = rta_getattr_u16(tb[TCA_SKBEDIT_PTYPE]);
 		if (ptype == PACKET_HOST)
-- 
2.7.4

