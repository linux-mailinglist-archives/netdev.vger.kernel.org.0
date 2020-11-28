Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B861E2C7435
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389019AbgK1Vtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:49 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37861 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729850AbgK1SbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 13:31:01 -0500
Received: by mail-wr1-f66.google.com with SMTP id i2so9192942wrs.4
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 10:30:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TQCAFHIwRwJz3VY5k7Dsjks9LVp9Lu245Qs5KvBL6r8=;
        b=AGt8Bxydo1D0KDffKVua4QJcycJuw0HrILaaKE6Tkwfc2u9pS2fMXxbPHQXzYEDODh
         Faldx2znfXI0HorY4iW30aR+ZxmpbVhq/McI7NpC3E11489HiwQmnWTDHLxUXWlcwLTG
         xqB/GkwyF7eRS1gJQ40CYOq7Hs2OTSBfCoDovShIYEBDnxuquDrOaqnB5UKUOWgRDrLG
         WFci89r3AuViGTWUsXANlxxCZHZTqwsvnusqhJH5QRHWa7XDrFHIVaq6cxGElRx3arjW
         Jw7xXHV7x4MUnDYweUP9LwC7IAaxe1L1MBQkvmeOoSvibgt2SeNHxNfj0TNTQUCJHvoX
         gmUw==
X-Gm-Message-State: AOAM5320SUoZ+XOvsmvZ13g3wbfkPjnnt9f2wzqRKDrjsmpBHK/g0IVa
        ZXAJ6jJuknQEsMod5qHOm1L4PpvLmc8IOQ==
X-Google-Smtp-Source: ABdhPJw6iF3ygguBR0xPxO2Wz2m5Qg+z+04Z50VW7j8f4ZSivOGhvGN5la12Zam0G1HodbNwcBRKXg==
X-Received: by 2002:adf:a549:: with SMTP id j9mr19130962wrb.199.1606588218586;
        Sat, 28 Nov 2020 10:30:18 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id p19sm22008047wrg.18.2020.11.28.10.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 10:30:17 -0800 (PST)
From:   Luca Boccassi <bluca@debian.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
Subject: [PATCH iproute2 v2] tc/mqprio: json-ify output
Date:   Sat, 28 Nov 2020 18:30:15 +0000
Message-Id: <20201128183015.15889-1-bluca@debian.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127152625.61874-1-bluca@debian.org>
References: <20201127152625.61874-1-bluca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reported by a Debian user, mqprio output in json mode is
invalid:

{
     "kind": "mqprio",
     "handle": "8021:",
     "dev": "enp1s0f0",
     "root": true,
     "options": { tc 2 map 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0
          queues:(0:3) (4:7)
          mode:channel
          shaper:dcb}
}

json-ify it, while trying to maintain the same formatting
for standard output.

New output:

{
    "kind": "mqprio",
    "handle": "8001:",
    "root": true,
    "options": {
        "tc": 2,
        "map": [ 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
        "queues": [ [ 0, 3 ], [ 4, 7 ] ],
        "mode": "channel",
        "shaper": "dcb"
    }
}

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=972784

Reported-by: Roméo GINON <romeo.ginon@ilexia.com>
Signed-off-by: Luca Boccassi <bluca@debian.org>
---
v2: the original reporter tested the patch, new output added to commit message.
    Fixed empty tag in queues nested arrays.
    Output is accepted by python3 -m json.tool

 tc/q_mqprio.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/tc/q_mqprio.c b/tc/q_mqprio.c
index f26ba8d7..a128fc11 100644
--- a/tc/q_mqprio.c
+++ b/tc/q_mqprio.c
@@ -243,13 +243,19 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 
 	qopt = RTA_DATA(opt);
 
-	fprintf(f, " tc %u map ", qopt->num_tc);
+	print_uint(PRINT_ANY, "tc", "tc %u ", qopt->num_tc);
+	open_json_array(PRINT_ANY, is_json_context() ? "map" : "map ");
 	for (i = 0; i <= TC_PRIO_MAX; i++)
-		fprintf(f, "%u ", qopt->prio_tc_map[i]);
-	fprintf(f, "\n             queues:");
-	for (i = 0; i < qopt->num_tc; i++)
-		fprintf(f, "(%u:%u) ", qopt->offset[i],
-			qopt->offset[i] + qopt->count[i] - 1);
+		print_uint(PRINT_ANY, NULL, "%u ", qopt->prio_tc_map[i]);
+	close_json_array(PRINT_ANY, "");
+	open_json_array(PRINT_ANY, is_json_context() ? "queues" : "\n             queues:");
+	for (i = 0; i < qopt->num_tc; i++) {
+		open_json_array(PRINT_JSON, NULL);
+		print_uint(PRINT_ANY, NULL, "(%u:", qopt->offset[i]);
+		print_uint(PRINT_ANY, NULL, "%u) ", qopt->offset[i] + qopt->count[i] - 1);
+		close_json_array(PRINT_JSON, NULL);
+	}
+	close_json_array(PRINT_ANY, "");
 
 	if (len > 0) {
 		struct rtattr *tb[TCA_MQPRIO_MAX + 1];
@@ -262,18 +268,18 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 			__u16 *mode = RTA_DATA(tb[TCA_MQPRIO_MODE]);
 
 			if (*mode == TC_MQPRIO_MODE_CHANNEL)
-				fprintf(f, "\n             mode:channel");
+				print_string(PRINT_ANY, "mode", "\n             mode:%s", "channel");
 		} else {
-			fprintf(f, "\n             mode:dcb");
+			print_string(PRINT_ANY, "mode", "\n             mode:%s", "dcb");
 		}
 
 		if (tb[TCA_MQPRIO_SHAPER]) {
 			__u16 *shaper = RTA_DATA(tb[TCA_MQPRIO_SHAPER]);
 
 			if (*shaper == TC_MQPRIO_SHAPER_BW_RATE)
-				fprintf(f, "\n             shaper:bw_rlimit");
+				print_string(PRINT_ANY, "shaper", "\n             shaper:%s", "bw_rlimit");
 		} else {
-			fprintf(f, "\n             shaper:dcb");
+			print_string(PRINT_ANY, "shaper", "\n             shaper:%s", "dcb");
 		}
 
 		if (tb[TCA_MQPRIO_MIN_RATE64]) {
@@ -287,9 +293,9 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 					return -1;
 				*(min++) = rta_getattr_u64(r);
 			}
-			fprintf(f, "	min_rate:");
+			open_json_array(PRINT_ANY, is_json_context() ? "min_rate" : "	min_rate:");
 			for (i = 0; i < qopt->num_tc; i++)
-				fprintf(f, "%s ", sprint_rate(min_rate64[i], b1));
+				print_string(PRINT_ANY, NULL, "%s ", sprint_rate(min_rate64[i], b1));
 		}
 
 		if (tb[TCA_MQPRIO_MAX_RATE64]) {
@@ -303,9 +309,9 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 					return -1;
 				*(max++) = rta_getattr_u64(r);
 			}
-			fprintf(f, "	max_rate:");
+			open_json_array(PRINT_ANY, is_json_context() ? "max_rate" : "	max_rate:");
 			for (i = 0; i < qopt->num_tc; i++)
-				fprintf(f, "%s ", sprint_rate(max_rate64[i], b1));
+				print_string(PRINT_ANY, NULL, "%s ", sprint_rate(max_rate64[i], b1));
 		}
 	}
 	return 0;
-- 
2.29.2

