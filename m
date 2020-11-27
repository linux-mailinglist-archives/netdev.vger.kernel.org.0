Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFE82C68B4
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 16:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgK0P0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 10:26:45 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37101 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgK0P0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 10:26:44 -0500
Received: by mail-wm1-f65.google.com with SMTP id h21so6864647wmb.2
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 07:26:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T5Fs3HgGJqJvQaLbSb5zUH4EUv8ztxWXpi1QPBGWMDo=;
        b=GOU2+rF6Qvj29buMk1GN+i82sckGIjMt8Uk9CUyq9kQ/ZTtKoPGNmOGR96wGzfUBpO
         zEKeZmf5sA4vmT8LyILXF9Xg5iyNZLYnwkIBfOxgrAkVG4Uq9YMwL2aOjEfCg5X2wiUX
         WUYwRQWk7tpTDIiRL2py8tuLa3p1/qKy+tCXRx4dzfjWBa6/pP+pQg8Ki4eFl/z0z6Tu
         2ox52YfEjh5EINc43+gXIS1TY6TXYNjbe0Dbp2PTeUl2FCvNelQJw0PRnret4Bj4BO28
         LPPVQ/RCDutX2dUZRj3bJcr64jfMUHe7CpEBz/1FmVYvEKmzYsFgO7sdxrGcVdchK8vS
         Ze5g==
X-Gm-Message-State: AOAM532l6TBTXXZm7guz5ZPogpW150a8jIP0omi6F8Mo9U7GwzV5jJvh
        /O6LRN/qkNCKdz5wOS5CyIHyD7iwYmxM6A==
X-Google-Smtp-Source: ABdhPJzvp5FdgPqQuW+k0KuqIEb1ej1XgIIKdyt8CWPq7efUqhbWYl6hMowsNXSfHqQGdrYjH7ckaw==
X-Received: by 2002:a7b:c954:: with SMTP id i20mr9735977wml.56.1606490800710;
        Fri, 27 Nov 2020 07:26:40 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id l3sm14975200wrr.89.2020.11.27.07.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 07:26:39 -0800 (PST)
From:   Luca Boccassi <bluca@debian.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, Luca Boccassi <bluca@debian.org>
Subject: [RFC iproute2] tc/mqprio: json-ify output
Date:   Fri, 27 Nov 2020 15:26:25 +0000
Message-Id: <20201127152625.61874-1-bluca@debian.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
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

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=972784

Signed-off-by: Luca Boccassi <bluca@debian.org>
---
I do not have hardware where I can configure mqprio, so I can't really
test this apart from compiling it. Stephen and David, do you have machines
where you can quickly check that this works as expected? Thanks!

 tc/q_mqprio.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/tc/q_mqprio.c b/tc/q_mqprio.c
index f26ba8d7..f62ccbc6 100644
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
+		open_json_array(PRINT_JSON, "");
+		print_uint(PRINT_ANY, NULL, "(%u:", qopt->offset[i]);
+		print_uint(PRINT_ANY, NULL, "%u) ", qopt->offset[i] + qopt->count[i] - 1);
+		close_json_array(PRINT_JSON, "");
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

