Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC384007B9
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 00:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350291AbhICWEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 18:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350214AbhICWEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 18:04:48 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E46C061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 15:03:47 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id q68so391577pga.9
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 15:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8QCggIwM9lpzvek80XUzGpfAkhOdGK0I55pEp5MGO8I=;
        b=CW4snwocrJiKrygG//WdByLphp2R3fPO8bL/PDcdQ+StADexp2M0Jbm1WdcKkFAmNZ
         7euXAX0iMIwBT2e9FsP6IwcKgakqcHmNuXPO5mK+vn71QFz9pv9ILPsr7UONn98oYMN8
         6RXaLmOWrM6ytMUQryqKY0a/zPiEiUF7G7JoLKbewryibqNSdpH9qTlUq83k3vB9uFfz
         JPcoe6awZZFwCwVGNqOWQt3m/PJO6vZCKEhdOs9LCGiJRpTcTG9xU+JEk8oiE5E4OTEH
         YApqNx925f177xLW/XO3lcPkp9JUqrp4xkH0a31DOsFzO4VQU89Xkzcv73iBp7YXun5f
         pstA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8QCggIwM9lpzvek80XUzGpfAkhOdGK0I55pEp5MGO8I=;
        b=NE9mimkOnaNvrIK63TDIuf7hbc54FxZk3+P5HqCRfAoO0wwRpBmcWvY7HD7n5b4LM/
         tiDC+/HqFL6zKLFV4lBjcOVJlD6uSFwFuI4WqAvEjVTB2Rnr44AgiDfp58hHqe0buUAI
         CHpABq8RftQ9JO2Um4SPrukGfzoW8FpoU5lXmIi8pIEG98ZMEQlRKJbWST/fUK7Ufcpw
         E7248wPaYJ6EjDnOKliYFExQ284qhhM2FSRywYMtMTe/5K/mTbuyMuBsWUR8KTqKvSxx
         SC+hpXR2VDSXWAdL4VB1sM9ibE0eN0WFKSfSkL1YhRs2gbGtExHRYzFydbxR/iabNRBH
         2suA==
X-Gm-Message-State: AOAM531GifydIrKIW7lhpBc880LEHwCMm6g3DBtUZjD/7oFJF306wNDB
        esWInL3xs+hpq6Gh7qbZsvs=
X-Google-Smtp-Source: ABdhPJydyXwrAWrKtekonOf/iAVUeXrU1JuPRdlV0Slc1mWqRy0B2v//1cyE1nOqK/HDPoTcX+dEuQ==
X-Received: by 2002:a63:e408:: with SMTP id a8mr1021023pgi.184.1630706627254;
        Fri, 03 Sep 2021 15:03:47 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f7c8:54ef:9daa:425f])
        by smtp.gmail.com with ESMTPSA id l6sm320647pff.74.2021.09.03.15.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 15:03:46 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] fq_codel: reject silly quantum parameters
Date:   Fri,  3 Sep 2021 15:03:43 -0700
Message-Id: <20210903220343.3961777-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot found that forcing a big quantum attribute would crash hosts fast,
essentially using this:

tc qd replace dev eth0 root fq_codel quantum 4294967295

This is because fq_codel_dequeue() would have to loop
~2^31 times in :

	if (flow->deficit <= 0) {
		flow->deficit += q->quantum;
		list_move_tail(&flow->flowchain, &q->old_flows);
		goto begin;
	}

SFQ max quantum is 2^19 (half a megabyte)
Lets adopt a max quantum of one megabyte for FQ_CODEL.

Fixes: 4b549a2ef4be ("fq_codel: Fair Queue Codel AQM")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/uapi/linux/pkt_sched.h |  2 ++
 net/sched/sch_fq_codel.c       | 12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 79a699f106b14ef36afe459b955ab136326e36a0..ec88590b3198441f18cc9def7bd40c48f0bc82a1 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -827,6 +827,8 @@ struct tc_codel_xstats {
 
 /* FQ_CODEL */
 
+#define FQ_CODEL_QUANTUM_MAX (1 << 20)
+
 enum {
 	TCA_FQ_CODEL_UNSPEC,
 	TCA_FQ_CODEL_TARGET,
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index c4afdd026f5197daf78e942731dfa1eb18a5f777..bb0cd6d3d2c2749d54e26368fb2558beedea85c9 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -369,6 +369,7 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
 {
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
 	struct nlattr *tb[TCA_FQ_CODEL_MAX + 1];
+	u32 quantum = 0;
 	int err;
 
 	if (!opt)
@@ -386,6 +387,13 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
 		    q->flows_cnt > 65536)
 			return -EINVAL;
 	}
+	if (tb[TCA_FQ_CODEL_QUANTUM]) {
+		quantum = max(256U, nla_get_u32(tb[TCA_FQ_CODEL_QUANTUM]));
+		if (quantum > FQ_CODEL_QUANTUM_MAX) {
+			NL_SET_ERR_MSG(extack, "Invalid quantum");
+			return -EINVAL;
+		}
+	}
 	sch_tree_lock(sch);
 
 	if (tb[TCA_FQ_CODEL_TARGET]) {
@@ -412,8 +420,8 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
 	if (tb[TCA_FQ_CODEL_ECN])
 		q->cparams.ecn = !!nla_get_u32(tb[TCA_FQ_CODEL_ECN]);
 
-	if (tb[TCA_FQ_CODEL_QUANTUM])
-		q->quantum = max(256U, nla_get_u32(tb[TCA_FQ_CODEL_QUANTUM]));
+	if (quantum)
+		q->quantum = quantum;
 
 	if (tb[TCA_FQ_CODEL_DROP_BATCH_SIZE])
 		q->drop_batch_size = max(1U, nla_get_u32(tb[TCA_FQ_CODEL_DROP_BATCH_SIZE]));
-- 
2.33.0.153.gba50c8fa24-goog

