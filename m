Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D5B12A8FF
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 20:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfLYTEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 14:04:41 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36440 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLYTEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 14:04:40 -0500
Received: by mail-pl1-f194.google.com with SMTP id a6so8937657plm.3
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 11:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aTQv0dZQzf9wyCSPINQULSMpdY5/6Oq+U/PQTbi9hZE=;
        b=szGST0eA9jGzEKxF3hM8aBzIng3jwwgnfPwBOf3PUeC5mR+xj0g0ixMWIukrrlpfO1
         V/2sOr9mHX0l/kIavqNoGNXWXIqpYKNc+t+qA09Filp81dpKf3bBy1AgUFYkTut8KvT8
         fPKtHJ0JbIrJSGuAjmgR3Mr/zjPRY1LNfjI/ui6Z7gA4SLESHYjwVCXw1bcwE6KqrD51
         bPzHR+yAsJwlA4IPvHl+4g4J7+QAqIS5+m7RzUQBM8ZkCtB35CcegYFhow56j4kPNcwn
         D7kYCe649ziNzp12y68fdvwOFfbHqYKwo8xQX+m+Q2W8nl0vLStW6t6pakBe1tQF7JL6
         oq2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aTQv0dZQzf9wyCSPINQULSMpdY5/6Oq+U/PQTbi9hZE=;
        b=RqWL3syYEjPig0DxcI38Ihy9sN/pgSHMKyTKsuX2m2oelPesyvtUT2gHOhUYxtMz4u
         7fb0+s4XJj2+dxe2CBro7fi/3ErUbf+gEJlxOYMuEGTXWMX1nBJ3dJ+IWlj4j/zOR5Qs
         q6gbeKOa2A9kKisdXtDUsCFlUwYLjCzisIWgPyOtnBxTVvi7Ki3W8gEPbqjwMvwHZu9q
         GHSEnzarJ3SrkdY6kYrmjmWIxtXrmdAzGKecELvW/aa6ZgMAeyvHqamqoxKg7mOR/sfv
         iRSnuobn6jvbG90CcFtsB2PjVcTe5A7ESL0z/OSR0nAXHeafSrou0IvwIK2vYhehtqYH
         OcKg==
X-Gm-Message-State: APjAAAVT/TC8eXfTmeLHY9aoV9/VB11tlDtGM53L5StmV3gLLmYbcsCn
        K9SJ99vUY0i/W1vH9g86huiOLBGh9KQ=
X-Google-Smtp-Source: APXvYqyPNjdZd9Gq3CyA4sSNuIVVnhzaocd90Dx7RGqS38CT91AqQXpOrQLi+FBu2vrWO5kV+dM2GA==
X-Received: by 2002:a17:902:9b84:: with SMTP id y4mr40907707plp.13.1577300679461;
        Wed, 25 Dec 2019 11:04:39 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id j28sm30019719pgb.36.2019.12.25.11.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 11:04:38 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 05/10] tc: hhf: add support for JSON output
Date:   Thu, 26 Dec 2019 00:34:13 +0530
Message-Id: <20191225190418.8806-6-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191225190418.8806-1-lesliemonis@gmail.com>
References: <20191225190418.8806-1-lesliemonis@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable proper JSON output for the HHF Qdisc.
Also, use sprint_size() to print size values.

Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 tc/q_hhf.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/tc/q_hhf.c b/tc/q_hhf.c
index 5ee6642f..f8888011 100644
--- a/tc/q_hhf.c
+++ b/tc/q_hhf.c
@@ -138,37 +138,46 @@ static int hhf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (tb[TCA_HHF_BACKLOG_LIMIT] &&
 	    RTA_PAYLOAD(tb[TCA_HHF_BACKLOG_LIMIT]) >= sizeof(__u32)) {
 		limit = rta_getattr_u32(tb[TCA_HHF_BACKLOG_LIMIT]);
-		fprintf(f, "limit %up ", limit);
+		print_uint(PRINT_ANY, "limit", "limit %up ", limit);
 	}
 	if (tb[TCA_HHF_QUANTUM] &&
 	    RTA_PAYLOAD(tb[TCA_HHF_QUANTUM]) >= sizeof(__u32)) {
 		quantum = rta_getattr_u32(tb[TCA_HHF_QUANTUM]);
-		fprintf(f, "quantum %u ", quantum);
+		print_uint(PRINT_JSON, "quantum", NULL, quantum);
+		print_string(PRINT_FP, NULL, "quantum %s ",
+			     sprint_size(quantum, b1));
 	}
 	if (tb[TCA_HHF_HH_FLOWS_LIMIT] &&
 	    RTA_PAYLOAD(tb[TCA_HHF_HH_FLOWS_LIMIT]) >= sizeof(__u32)) {
 		hh_limit = rta_getattr_u32(tb[TCA_HHF_HH_FLOWS_LIMIT]);
-		fprintf(f, "hh_limit %u ", hh_limit);
+		print_uint(PRINT_ANY, "hh_limit", "hh_limit %u ", hh_limit);
 	}
 	if (tb[TCA_HHF_RESET_TIMEOUT] &&
 	    RTA_PAYLOAD(tb[TCA_HHF_RESET_TIMEOUT]) >= sizeof(__u32)) {
 		reset_timeout = rta_getattr_u32(tb[TCA_HHF_RESET_TIMEOUT]);
-		fprintf(f, "reset_timeout %s ", sprint_time(reset_timeout, b1));
+		print_uint(PRINT_JSON, "reset_timeout", NULL, reset_timeout);
+		print_string(PRINT_FP, NULL, "reset_timeout %s ",
+			     sprint_time(reset_timeout, b1));
 	}
 	if (tb[TCA_HHF_ADMIT_BYTES] &&
 	    RTA_PAYLOAD(tb[TCA_HHF_ADMIT_BYTES]) >= sizeof(__u32)) {
 		admit_bytes = rta_getattr_u32(tb[TCA_HHF_ADMIT_BYTES]);
-		fprintf(f, "admit_bytes %u ", admit_bytes);
+		print_uint(PRINT_JSON, "admit_bytes", NULL, admit_bytes);
+		print_string(PRINT_FP, NULL, "admit_bytes %s ",
+			     sprint_size(admit_bytes, b1));
 	}
 	if (tb[TCA_HHF_EVICT_TIMEOUT] &&
 	    RTA_PAYLOAD(tb[TCA_HHF_EVICT_TIMEOUT]) >= sizeof(__u32)) {
 		evict_timeout = rta_getattr_u32(tb[TCA_HHF_EVICT_TIMEOUT]);
-		fprintf(f, "evict_timeout %s ", sprint_time(evict_timeout, b1));
+		print_uint(PRINT_JSON, "evict_timeout", NULL, evict_timeout);
+		print_string(PRINT_FP, NULL, "evict_timeout %s ",
+			     sprint_time(evict_timeout, b1));
 	}
 	if (tb[TCA_HHF_NON_HH_WEIGHT] &&
 	    RTA_PAYLOAD(tb[TCA_HHF_NON_HH_WEIGHT]) >= sizeof(__u32)) {
 		non_hh_weight = rta_getattr_u32(tb[TCA_HHF_NON_HH_WEIGHT]);
-		fprintf(f, "non_hh_weight %u ", non_hh_weight);
+		print_uint(PRINT_ANY, "non_hh_weight", "non_hh_weight %u ",
+			   non_hh_weight);
 	}
 	return 0;
 }
@@ -186,9 +195,13 @@ static int hhf_print_xstats(struct qdisc_util *qu, FILE *f,
 
 	st = RTA_DATA(xstats);
 
-	fprintf(f, "  drop_overlimit %u hh_overlimit %u tot_hh %u cur_hh %u",
-		st->drop_overlimit, st->hh_overlimit,
-		st->hh_tot_count, st->hh_cur_count);
+	print_uint(PRINT_ANY, "drop_overlimit", "  drop_overlimit %u",
+		   st->drop_overlimit);
+	print_uint(PRINT_ANY, "hh_overlimit", " hh_overlimit %u",
+		   st->hh_overlimit);
+	print_uint(PRINT_ANY, "tot_hh", " tot_hh %u", st->hh_tot_count);
+	print_uint(PRINT_ANY, "cur_hh", " cur_hh %u", st->hh_cur_count);
+
 	return 0;
 }
 
-- 
2.17.1

