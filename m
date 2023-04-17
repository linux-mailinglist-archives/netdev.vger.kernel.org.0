Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CC16E4616
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 13:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjDQLMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 07:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjDQLMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 07:12:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580AD6A78
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 04:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681729740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JPjIm3Vq19KYZ2oEFTQUD3krJLjmBIkBqTeJ33Vqnrk=;
        b=FE0Aq1aA8HOFuE89asS3TWJyaoUDT10brjzx3lw/2wcvTV0erMdR2Xrr4SlNqB4+ivD2wf
        DHwAxwE1bO8I7gnQ7Gojz274Rzef5v0qXrozqnAhBZysy0BhjKqpv1Kyfb7jTxVzWeEm0w
        QLNbD0qMB5Zfa3sY9VYpIlA4xKCOMGg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-XARlszbgOLCaPY3UiJ_vIA-1; Mon, 17 Apr 2023 07:02:50 -0400
X-MC-Unique: XARlszbgOLCaPY3UiJ_vIA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6D22101A54F;
        Mon, 17 Apr 2023 11:02:49 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.45.226.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6350F1121315;
        Mon, 17 Apr 2023 11:02:48 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Eric Dumazet <edumazet@google.com>,
        Christoph Paasch <cpaasch@apple.com>, netdev@vger.kernel.org
Subject: [PATCH net] net/sched: sch_fq: fix integer overflow of "credit"
Date:   Mon, 17 Apr 2023 13:02:40 +0200
Message-Id: <a5288a1f4b69eb2da3e704d0e1ff082489432d25.1681728988.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if sch_fq is configured with "initial quantum" having values greater than
INT_MAX, the first assignment of "credit" does signed integer overflow to
a very negative value.
In this situation, the syzkaller script provided by Cristoph triggers the
CPU soft-lockup warning even with few sockets. It's not an infinite loop,
but "credit" wasn't probably meant to be minus 2Gb for each new flow.
Capping "initial quantum" to INT_MAX proved to fix the issue.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/377
Fixes: afe4fd062416 ("pkt_sched: fq: Fair Queue packet scheduler")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/sch_fq.c                            | 12 ++++++++--
 .../tc-testing/tc-tests/qdiscs/fq.json        | 22 +++++++++++++++++++
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 48d14fb90ba0..12efbcfc2938 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -842,8 +842,16 @@ static int fq_change(struct Qdisc *sch, struct nlattr *opt,
 		}
 	}
 
-	if (tb[TCA_FQ_INITIAL_QUANTUM])
-		q->initial_quantum = nla_get_u32(tb[TCA_FQ_INITIAL_QUANTUM]);
+	if (tb[TCA_FQ_INITIAL_QUANTUM]) {
+		u32 initial_quantum = nla_get_u32(tb[TCA_FQ_INITIAL_QUANTUM]);
+
+		if (initial_quantum <= INT_MAX) {
+			q->initial_quantum = initial_quantum;
+		} else {
+			NL_SET_ERR_MSG_MOD(extack, "invalid initial quantum");
+			err = -EINVAL;
+		}
+	}
 
 	if (tb[TCA_FQ_FLOW_DEFAULT_RATE])
 		pr_warn_ratelimited("sch_fq: defrate %u ignored.\n",
diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq.json
index 8acb904d1419..3593fb8f79ad 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq.json
@@ -114,6 +114,28 @@
             "$IP link del dev $DUMMY type dummy"
         ]
     },
+    {
+        "id": "10f7",
+        "name": "Create FQ with invalid initial_quantum setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq initial_quantum 0x80000000",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root.*initial_quantum 2048Mb",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
     {
         "id": "9398",
         "name": "Create FQ with maxrate setting",
-- 
2.39.2

