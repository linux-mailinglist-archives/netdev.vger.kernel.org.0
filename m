Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CA21BABB4
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 19:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgD0Rv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 13:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726223AbgD0Rv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 13:51:59 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A97C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 10:51:58 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id ck5so19496443qvb.18
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 10:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OYuOx/czNLwKt8O2lBJEBXohGADalS4aNorV3IU9n1I=;
        b=frwf+1VeDygy8ocdMV0L7e1GIz5tNSef5hAvGEolmVem6UL+HZJh0DTS1SeMzYh3TJ
         Dm4kvP9BDL3V0vK/j/l+Py8SxS2H1UjFHUYQP0rZmnRUUgamTDV2VpBsTM9UjZrPcv+l
         go0MkmnRWlSqYPClkRUX/QOTEIk08ysLXvcOBFagjWwnVbGXkciT1OP5CwqZbM3K143F
         MMnLxOO9cKwFdbul1axTcmYMO+Zx5ro2L/pCSRr2Ie8YY7EKXQ6uWZ0n1jSSjdYz6KF/
         YCEXpDg9GueyvdtpGsHiCqu5DtdF9OwwqSSg+kAWaloBFBFTjLqcvXp1TAt3XYiOHWXK
         AK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OYuOx/czNLwKt8O2lBJEBXohGADalS4aNorV3IU9n1I=;
        b=NPL/XJ6UO3+nAnf9nh5q2IofKOnm3rGys/zi9MVu2tkiLNqMnW+JKAyZ3XlxGDjLwL
         UICjYU48wbO9BeRu4wqBdFcQezpW0xOXkuttxA/LUqqtNpI8Ez72Ni/SypRz7rwFriwJ
         7se1Uk3C6RYl3HTQ4oZHrgT1A6UqDBbz1wpbjam4YF4X94+5EkbGunqF8qGYvpdO8Ruc
         f06/LdlUAWHa4Gykv8JZABsOTmncl6oPL0N5Y/zgb+hbxMJhp/X/UZyGpCP+2CU6oTEa
         oL6xLd+REa9Nz9EuKcBsYoL0tb65fDCaPEhssN87JltC5mRgLxSaO5YhuxXQvbNHvM4e
         nZHQ==
X-Gm-Message-State: AGi0PuZ5rjpdXd37YheymNhvNuzRcw3oAiyx9PGVJJbHvdV6I/Dv9J7j
        bzaNE5ZArjKNSuP1v/uDm3CGYQTPLUW+dQ==
X-Google-Smtp-Source: APiQypLBhuPiCY78x+9PSazbILZAkI1psItcV/Z1euDvih/ZrEi1WLn7rX78/3J/a90Vpa4mS7UiVfcAR2dVIA==
X-Received: by 2002:ad4:46b4:: with SMTP id br20mr23483271qvb.62.1588009917980;
 Mon, 27 Apr 2020 10:51:57 -0700 (PDT)
Date:   Mon, 27 Apr 2020 10:51:55 -0700
Message-Id: <20200427175155.227178-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH iproute2] tc: fq_codel: add drop_batch parameter
From:   Eric Dumazet <edumazet@google.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 9d18562a2278 ("fq_codel: add batch ability to fq_codel_drop()")
added the new TCA_FQ_CODEL_DROP_BATCH_SIZE parameter, set by default to 64.

Add to tc command the ability to get/set the drop_batch

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 tc/q_fq_codel.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/tc/q_fq_codel.c b/tc/q_fq_codel.c
index 1c6cf1e0de9ef6aa2400f36008cbc830c37352c0..1a51302e0e2b332a4496965dfeaf520bc843f8ad 100644
--- a/tc/q_fq_codel.c
+++ b/tc/q_fq_codel.c
@@ -54,12 +54,14 @@ static void explain(void)
 					"[ memory_limit BYTES ]\n"
 					"[ target TIME ] [ interval TIME ]\n"
 					"[ quantum BYTES ] [ [no]ecn ]\n"
-					"[ ce_threshold TIME ]\n");
+					"[ ce_threshold TIME ]\n"
+					"[ drop_batch SIZE ]\n");
 }
 
 static int fq_codel_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 			      struct nlmsghdr *n, const char *dev)
 {
+	unsigned int drop_batch = 0;
 	unsigned int limit = 0;
 	unsigned int flows = 0;
 	unsigned int target = 0;
@@ -89,6 +91,12 @@ static int fq_codel_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 				fprintf(stderr, "Illegal \"quantum\"\n");
 				return -1;
 			}
+		} else if (strcmp(*argv, "drop_batch") == 0) {
+			NEXT_ARG();
+			if (get_unsigned(&drop_batch, *argv, 0)) {
+				fprintf(stderr, "Illegal \"drop_batch\"\n");
+				return -1;
+			}
 		} else if (strcmp(*argv, "target") == 0) {
 			NEXT_ARG();
 			if (get_time(&target, *argv)) {
@@ -147,6 +155,8 @@ static int fq_codel_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	if (memory != ~0U)
 		addattr_l(n, 1024, TCA_FQ_CODEL_MEMORY_LIMIT,
 			  &memory, sizeof(memory));
+	if (drop_batch)
+		addattr_l(n, 1024, TCA_FQ_CODEL_DROP_BATCH_SIZE, &drop_batch, sizeof(drop_batch));
 
 	addattr_nest_end(n, tail);
 	return 0;
@@ -163,6 +173,7 @@ static int fq_codel_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt
 	unsigned int quantum;
 	unsigned int ce_threshold;
 	unsigned int memory_limit;
+	unsigned int drop_batch;
 
 	SPRINT_BUF(b1);
 
@@ -220,6 +231,12 @@ static int fq_codel_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt
 		if (ecn)
 			print_bool(PRINT_ANY, "ecn", "ecn ", true);
 	}
+	if (tb[TCA_FQ_CODEL_DROP_BATCH_SIZE] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_CODEL_DROP_BATCH_SIZE]) >= sizeof(__u32)) {
+		drop_batch = rta_getattr_u32(tb[TCA_FQ_CODEL_DROP_BATCH_SIZE]);
+		if (drop_batch)
+			print_uint(PRINT_ANY, "drop_batch", "drop_batch %u ", drop_batch);
+	}
 
 	return 0;
 }
-- 
2.26.2.303.gf8c07b1a785-goog

