Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8BF912A901
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 20:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfLYTEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 14:04:47 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33304 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLYTEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 14:04:46 -0500
Received: by mail-pl1-f193.google.com with SMTP id c13so9679426pls.0
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 11:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8RN6kuhyriHZK/j1hHtEORpizIMkmj/7AdrHVuede8s=;
        b=l+0u5tYQ3NvaFn7G6mi39+gbFcRrG2PbCFfFN/52rzTgdqk330atHjrGxLlJJBrkzt
         7pVfhIs+JZ6tSZpAiAnSlt9XVgb3dHnQEH+gomt+3U9giawKtnft9gEew9o+H8fkCLuD
         3Tqtph5BJt606LZIJbjehRPRuXu/WR+PyEeSKGBSv+VPy7yHB4V7iYOu1v4/3exqQBxZ
         L/gK3MaDcM2qg2+38J51JVcgDEN7imByhJnRXPmKVaJJ9B1hrt1g3SpMFa2s2Kh8gogo
         9bWVRTRuvy592OQU4hrOJvOYFNRwx0GHyvtDWVpcCx+S3cjqeajs9JbrWmW3E48ddZdw
         9cxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8RN6kuhyriHZK/j1hHtEORpizIMkmj/7AdrHVuede8s=;
        b=nTDiA50jN2EfNbW2sOR74UDsbEt7Yxc3ngCbj3/vii25Zfr6c5MPvUZihEoNgf9oIC
         eccVch6maylP8i10HyDL9+lrGGrRkUSdNyp/jMjFI5wstAkMEWjBwQsB+kOwQDwfPITO
         qelH5sBCS3Lhp+ON0jXwE3CaOHVXGPd0PklpEv9Y+6P/Zv1j9Y5ByFBdk5Ohr00gHyiR
         bIMIxOOsgp7z65wi9lC8ap9Zb4v9gSW+qJAPQHItWOZL6mQARpJtr6AAm8aXTTz1Y+sM
         Q2iqoKuavImIxhYwe87PGLVda/ebeIXnakPBw3xefpmIh9+XTKwwOqawey4Hb5FygLjb
         VH0g==
X-Gm-Message-State: APjAAAVwAYMyygVTcM5bEkCxvqhrH7J1mrCesmQ2fvaObwP9VLXbE7kt
        GonzgcV+mtgrSy22nfRn/90TLysHorg=
X-Google-Smtp-Source: APXvYqy8sge1W4VvDIb5BBOK8MNXdcy4mq73GrFBMy+8+MZAeEpFTj1hezEPNrrHNhEYqeS2lVobdw==
X-Received: by 2002:a17:902:ba94:: with SMTP id k20mr4823440pls.60.1577300685567;
        Wed, 25 Dec 2019 11:04:45 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id j28sm30019719pgb.36.2019.12.25.11.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 11:04:45 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 07/10] tc: sfb: add support for JSON output
Date:   Thu, 26 Dec 2019 00:34:15 +0530
Message-Id: <20191225190418.8806-8-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191225190418.8806-1-lesliemonis@gmail.com>
References: <20191225190418.8806-1-lesliemonis@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable proper JSON output for the SFB Qdisc.
Make the output for options "rehash" and "db" explicit.
Use the long double format specifier to print probability values.
Use sprint_time() to print time values.
Also, fix the indentation in sfb_print_opt().

Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 tc/q_sfb.c | 67 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 22 deletions(-)

diff --git a/tc/q_sfb.c b/tc/q_sfb.c
index 7f48c6e0..8af55d98 100644
--- a/tc/q_sfb.c
+++ b/tc/q_sfb.c
@@ -143,6 +143,8 @@ static int sfb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	struct rtattr *tb[__TCA_SFB_MAX];
 	struct tc_sfb_qopt *qopt;
 
+	SPRINT_BUF(b1);
+
 	if (opt == NULL)
 		return 0;
 
@@ -153,14 +155,27 @@ static int sfb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (RTA_PAYLOAD(tb[TCA_SFB_PARMS]) < sizeof(*qopt))
 		return -1;
 
-	fprintf(f,
-		"limit %d max %d target %d\n"
-		"  increment %.5f decrement %.5f penalty rate %d burst %d (%ums %ums)",
-		qopt->limit, qopt->max, qopt->bin_size,
-		(double)qopt->increment / SFB_MAX_PROB,
-		(double)qopt->decrement / SFB_MAX_PROB,
-		qopt->penalty_rate, qopt->penalty_burst,
-		qopt->rehash_interval, qopt->warmup_time);
+	print_uint(PRINT_JSON, "rehash", NULL, qopt->rehash_interval * 1000);
+	print_string(PRINT_FP, NULL, "rehash %s ",
+		     sprint_time(qopt->rehash_interval * 1000, b1));
+
+	print_uint(PRINT_JSON, "db", NULL, qopt->warmup_time * 1000);
+	print_string(PRINT_FP, NULL, "db %s ",
+		     sprint_time(qopt->warmup_time * 1000, b1));
+
+	print_uint(PRINT_ANY, "limit", "limit %up ", qopt->limit);
+	print_uint(PRINT_ANY, "max", "max %up ", qopt->max);
+	print_uint(PRINT_ANY, "target", "target %up ", qopt->bin_size);
+
+	print_float(PRINT_ANY, "increment", "increment %lg ",
+		    (double)qopt->increment / SFB_MAX_PROB);
+	print_float(PRINT_ANY, "decrement", "decrement %lg ",
+		    (double)qopt->decrement / SFB_MAX_PROB);
+
+	print_uint(PRINT_ANY, "penalty_rate", "penalty_rate %upps ",
+		   qopt->penalty_rate);
+	print_uint(PRINT_ANY, "penalty_burst", "penalty_burst %up ",
+		   qopt->penalty_burst);
 
 	return 0;
 }
@@ -168,24 +183,32 @@ static int sfb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 static int sfb_print_xstats(struct qdisc_util *qu, FILE *f,
 			    struct rtattr *xstats)
 {
-    struct tc_sfb_xstats *st;
+	struct tc_sfb_xstats *st;
 
-    if (xstats == NULL)
-	    return 0;
+	if (xstats == NULL)
+		return 0;
+
+	if (RTA_PAYLOAD(xstats) < sizeof(*st))
+		return -1;
 
-    if (RTA_PAYLOAD(xstats) < sizeof(*st))
-	    return -1;
+	st = RTA_DATA(xstats);
 
-    st = RTA_DATA(xstats);
-    fprintf(f,
-	    "  earlydrop %u penaltydrop %u bucketdrop %u queuedrop %u childdrop %u marked %u\n"
-	    "  maxqlen %u maxprob %.5f avgprob %.5f ",
-	    st->earlydrop, st->penaltydrop, st->bucketdrop, st->queuedrop, st->childdrop,
-	    st->marked,
-	    st->maxqlen, (double)st->maxprob / SFB_MAX_PROB,
-		(double)st->avgprob / SFB_MAX_PROB);
+	print_uint(PRINT_ANY, "earlydrop", "  earlydrop %u", st->earlydrop);
+	print_uint(PRINT_ANY, "penaltydrop", " penaltydrop %u",
+		   st->penaltydrop);
+	print_uint(PRINT_ANY, "bucketdrop", " bucketdrop %u", st->bucketdrop);
+	print_uint(PRINT_ANY, "queuedrop", " queuedrop %u", st->queuedrop);
+	print_uint(PRINT_ANY, "childdrop", " childdrop %u", st->childdrop);
+	print_uint(PRINT_ANY, "marked", " marked %u", st->marked);
+	print_nl();
+	print_uint(PRINT_ANY, "maxqlen", "  maxqlen %u", st->maxqlen);
 
-    return 0;
+	print_float(PRINT_ANY, "maxprob", " maxprob %lg",
+		    (double)st->maxprob / SFB_MAX_PROB);
+	print_float(PRINT_ANY, "avgprob", " avgprob %lg",
+		    (double)st->avgprob / SFB_MAX_PROB);
+
+	return 0;
 }
 
 struct qdisc_util sfb_qdisc_util = {
-- 
2.17.1

