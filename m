Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56BE38D5F9
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 15:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhEVNQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 09:16:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48077 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230466AbhEVNQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 09:16:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621689299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iFg8QwTUxh0ja5IOJu6njrdfhu3mkA1LjZC4P7XEI8E=;
        b=cmUIxWwvS5Uup2NhLWWSAZbhXA5eDpy/EMdoToZvRzFNT+fZVuA1RhRUzZkx8SR2img7EZ
        Tb61xoMg1SLq+2W9613QkZs1iCes2Xq9kLq4h9RK4pWSxxACFePl/+2rm1TcyPT5Ypu0Hu
        FyBfdE38JsoqKxPjJkUPlUIYZiqG8zc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-0PR9d2X0O8-kQ5EDivruDg-1; Sat, 22 May 2021 09:14:57 -0400
X-MC-Unique: 0PR9d2X0O8-kQ5EDivruDg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F24AD180FD62;
        Sat, 22 May 2021 13:14:55 +0000 (UTC)
Received: from dcaratti.station (unknown [10.40.194.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 832AB2C6FD;
        Sat, 22 May 2021 13:14:51 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "V. Saicharan" <vsaicharan1998@gmail.com>,
        "Sachin D. Patil" <sdp.sachin@gmail.com>,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Colin Ian King <colin.king@canonical.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 1/2] net/sched: fq_pie: re-factor fix for fq_pie endless loop
Date:   Sat, 22 May 2021 15:14:45 +0200
Message-Id: <d2b888e712794a7c88f3b0365c4b25635517b341.1621687869.git.dcaratti@redhat.com>
In-Reply-To: <cover.1621687869.git.dcaratti@redhat.com>
References: <cover.1621687869.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the patch that fixed an endless loop in_fq_pie_init() was not considering
that 65535 is a valid class id. The correct bugfix for this infinite loop
is to change 'idx' to become an u32, like Colin proposed in the past [1].

Fix this as follows:
 - restore 65536 as maximum possible values of 'flows_cnt'
 - use u32 'idx' when iterating on 'q->flows'
 - fix the TDC selftest

This reverts commit bb2f930d6dd708469a587dc9ed1efe1ef969c0bf.

[1] https://lore.kernel.org/netdev/20210407163808.499027-1-colin.king@canonical.com/

CC: Colin Ian King <colin.king@canonical.com>
CC: stable@vger.kernel.org
Fixes: bb2f930d6dd7 ("net/sched: fix infinite loop in sch_fq_pie")
Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/sch_fq_pie.c                                 | 10 +++++-----
 .../selftests/tc-testing/tc-tests/qdiscs/fq_pie.json   |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index 949163fe68af..266c7c1869d9 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -297,9 +297,9 @@ static int fq_pie_change(struct Qdisc *sch, struct nlattr *opt,
 			goto flow_error;
 		}
 		q->flows_cnt = nla_get_u32(tb[TCA_FQ_PIE_FLOWS]);
-		if (!q->flows_cnt || q->flows_cnt >= 65536) {
+		if (!q->flows_cnt || q->flows_cnt > 65536) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Number of flows must range in [1..65535]");
+					   "Number of flows must range in [1..65536]");
 			goto flow_error;
 		}
 	}
@@ -367,7 +367,7 @@ static void fq_pie_timer(struct timer_list *t)
 	struct fq_pie_sched_data *q = from_timer(q, t, adapt_timer);
 	struct Qdisc *sch = q->sch;
 	spinlock_t *root_lock; /* to lock qdisc for probability calculations */
-	u16 idx;
+	u32 idx;
 
 	root_lock = qdisc_lock(qdisc_root_sleeping(sch));
 	spin_lock(root_lock);
@@ -388,7 +388,7 @@ static int fq_pie_init(struct Qdisc *sch, struct nlattr *opt,
 {
 	struct fq_pie_sched_data *q = qdisc_priv(sch);
 	int err;
-	u16 idx;
+	u32 idx;
 
 	pie_params_init(&q->p_params);
 	sch->limit = 10 * 1024;
@@ -500,7 +500,7 @@ static int fq_pie_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 static void fq_pie_reset(struct Qdisc *sch)
 {
 	struct fq_pie_sched_data *q = qdisc_priv(sch);
-	u16 idx;
+	u32 idx;
 
 	INIT_LIST_HEAD(&q->new_flows);
 	INIT_LIST_HEAD(&q->old_flows);
diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json
index 1cda2e11b3ad..773c5027553d 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json
@@ -9,11 +9,11 @@
         "setup": [
             "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DUMMY root fq_pie flows 65536",
-        "expExitCode": "2",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_pie flows 65536",
+        "expExitCode": "0",
         "verifyCmd": "$TC qdisc show dev $DUMMY",
-        "matchPattern": "qdisc",
-        "matchCount": "0",
+        "matchPattern": "qdisc fq_pie 1: root refcnt 2 limit 10240p flows 65536",
+        "matchCount": "1",
         "teardown": [
             "$IP link del dev $DUMMY"
         ]
-- 
2.31.1

