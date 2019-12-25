Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6488A12A8FD
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 20:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfLYTEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 14:04:34 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50663 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLYTEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 14:04:34 -0500
Received: by mail-pj1-f66.google.com with SMTP id r67so2498405pjb.0
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 11:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Mvo41UBGA7AjiMNPhpLLI3n0hzH/aO2pyn+RBJk+AjQ=;
        b=H9r8Uom+AmQanBrAW5cUNZOqdSRmu9sWXEcOSYBg/Pla1gByWYTRa2lp+FdyyehAvw
         CftdHSJcUMVn2pb9oSdO2AoMzG4SRiSxXYbE3v9ShW5g9LtWibUzwSkrwgtQqYSJuCx1
         lj/w5hIeg3XR0RdRt15qhqMItD8Nu5tYLp+yl4j7Qfi5xU6AsiU01nlu7EU7WzhYdH3n
         jSBaeVMv7qbLy7peRrep04WWJj6f834IGIRL63Nv0n2Q+qDAw+6XJIL6Mpo63TfEUQe9
         9mMDIfwMg26vWVoVULKZs0kRnAouXbKx3bMfcS/0iuZHOoFGarcUltIOWuwRDeC1H9Jk
         FPwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Mvo41UBGA7AjiMNPhpLLI3n0hzH/aO2pyn+RBJk+AjQ=;
        b=H6gu6NL/n+8QbOftLGxHg84BOxO753H8kdFP9NZfClnzkHTCeH3BD57InrosTUaUbv
         8EJjr1lTvQUXvxcFAyJFRRHecUMisyPo0CHY4jTuwfx807JDLM3yja8qSyU7TaiXH/W1
         Z3lKZMpeDue7Xpx2AqcuFmfeAgemnjmz6bnLR1D1wtTLCg5AOGZZBhK1IqrSnrNpFKJW
         s2pFpFlAvR2xr2vvn4Q0mdaQJnIGdwl2QSfWmEeku9RXfScG5ODcPYYrycv+SYrilz5R
         lVDrPYOCjsxsV+v7IpyhHzH1G1zSOydBGA7uxL58KoAN2NR+/SZi/zmdsIgT88ObEC0X
         +XHQ==
X-Gm-Message-State: APjAAAVy1nDCg8ZJthrtprshWBMD6Sb7egh2QQIXUHlBUxB3PVlLTGRG
        GMvwZcNgn+gQHKML3ItQZE0NbhwTjBA=
X-Google-Smtp-Source: APXvYqw+4qC/y408/du2UalhoUX0g2ib1gYiQSNLBPEcBnrhtCOWSsUPUy1t2kBLHMmaafKUHQ8Ezw==
X-Received: by 2002:a17:90a:c385:: with SMTP id h5mr14379718pjt.122.1577300673298;
        Wed, 25 Dec 2019 11:04:33 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id j28sm30019719pgb.36.2019.12.25.11.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 11:04:32 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 03/10] tc: codel: add support for JSON output
Date:   Thu, 26 Dec 2019 00:34:11 +0530
Message-Id: <20191225190418.8806-4-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191225190418.8806-1-lesliemonis@gmail.com>
References: <20191225190418.8806-1-lesliemonis@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable proper JSON output for the CoDel Qdisc.

Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 tc/q_codel.c | 45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/tc/q_codel.c b/tc/q_codel.c
index 849cc040..c72a5779 100644
--- a/tc/q_codel.c
+++ b/tc/q_codel.c
@@ -144,28 +144,34 @@ static int codel_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (tb[TCA_CODEL_LIMIT] &&
 	    RTA_PAYLOAD(tb[TCA_CODEL_LIMIT]) >= sizeof(__u32)) {
 		limit = rta_getattr_u32(tb[TCA_CODEL_LIMIT]);
-		fprintf(f, "limit %up ", limit);
+		print_uint(PRINT_ANY, "limit", "limit %up ", limit);
 	}
 	if (tb[TCA_CODEL_TARGET] &&
 	    RTA_PAYLOAD(tb[TCA_CODEL_TARGET]) >= sizeof(__u32)) {
 		target = rta_getattr_u32(tb[TCA_CODEL_TARGET]);
-		fprintf(f, "target %s ", sprint_time(target, b1));
+		print_uint(PRINT_JSON, "target", NULL, target);
+		print_string(PRINT_FP, NULL, "target %s ",
+			     sprint_time(target, b1));
 	}
 	if (tb[TCA_CODEL_CE_THRESHOLD] &&
 	    RTA_PAYLOAD(tb[TCA_CODEL_CE_THRESHOLD]) >= sizeof(__u32)) {
 		ce_threshold = rta_getattr_u32(tb[TCA_CODEL_CE_THRESHOLD]);
-		fprintf(f, "ce_threshold %s ", sprint_time(ce_threshold, b1));
+		print_uint(PRINT_JSON, "ce_threshold", NULL, ce_threshold);
+		print_string(PRINT_FP, NULL, "ce_threshold %s ",
+			     sprint_time(ce_threshold, b1));
 	}
 	if (tb[TCA_CODEL_INTERVAL] &&
 	    RTA_PAYLOAD(tb[TCA_CODEL_INTERVAL]) >= sizeof(__u32)) {
 		interval = rta_getattr_u32(tb[TCA_CODEL_INTERVAL]);
-		fprintf(f, "interval %s ", sprint_time(interval, b1));
+		print_uint(PRINT_JSON, "interval", NULL, interval);
+		print_string(PRINT_FP, NULL, "interval %s ",
+			     sprint_time(interval, b1));
 	}
 	if (tb[TCA_CODEL_ECN] &&
 	    RTA_PAYLOAD(tb[TCA_CODEL_ECN]) >= sizeof(__u32)) {
 		ecn = rta_getattr_u32(tb[TCA_CODEL_ECN]);
 		if (ecn)
-			fprintf(f, "ecn ");
+			print_bool(PRINT_ANY, "ecn", "ecn ", true);
 	}
 
 	return 0;
@@ -187,18 +193,31 @@ static int codel_print_xstats(struct qdisc_util *qu, FILE *f,
 		st = &_st;
 	}
 
-	fprintf(f, "  count %u lastcount %u ldelay %s",
-		st->count, st->lastcount, sprint_time(st->ldelay, b1));
+	print_uint(PRINT_ANY, "count", "  count %u", st->count);
+	print_uint(PRINT_ANY, "lastcount", " lastcount %u", st->lastcount);
+	print_uint(PRINT_JSON, "ldelay", NULL, st->ldelay);
+	print_string(PRINT_FP, NULL, " ldelay %s", sprint_time(st->ldelay, b1));
+
 	if (st->dropping)
-		fprintf(f, " dropping");
+		print_bool(PRINT_ANY, "dropping", " dropping", true);
+
+	print_int(PRINT_JSON, "drop_next", NULL, st->drop_next);
 	if (st->drop_next < 0)
-		fprintf(f, " drop_next -%s", sprint_time(-st->drop_next, b1));
+		print_string(PRINT_FP, NULL, " drop_next -%s",
+			     sprint_time(-st->drop_next, b1));
 	else
-		fprintf(f, " drop_next %s", sprint_time(st->drop_next, b1));
-	fprintf(f, "\n  maxpacket %u ecn_mark %u drop_overlimit %u",
-		st->maxpacket, st->ecn_mark, st->drop_overlimit);
+		print_string(PRINT_FP, NULL, " drop_next %s",
+			     sprint_time(st->drop_next, b1));
+
+	print_nl();
+	print_uint(PRINT_ANY, "maxpacket", "  maxpacket %u", st->maxpacket);
+	print_uint(PRINT_ANY, "ecn_mark", " ecn_mark %u", st->ecn_mark);
+	print_uint(PRINT_ANY, "drop_overlimit", " drop_overlimit %u",
+		   st->drop_overlimit);
+
 	if (st->ce_mark)
-		fprintf(f, " ce_mark %u", st->ce_mark);
+		print_uint(PRINT_ANY, "ce_mark", " ce_mark %u", st->ce_mark);
+
 	return 0;
 
 }
-- 
2.17.1

