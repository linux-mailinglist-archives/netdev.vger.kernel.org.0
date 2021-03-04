Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB7C32D5A7
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 15:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbhCDOrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 09:47:49 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:14514 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbhCDOrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 09:47:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1614869246; x=1646405246;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=yrq2vS3QqX+W8d5Zoonnniw7JITVHBVaHNKpFXbSSxQ=;
  b=sUb8lOgras6TajX+khbN2sh6knKY/QBz4sWt71GZGRHiiAvAjHYr8cK/
   p5A1OtXTGpiRhP65UhT5odTAkMQwGahDVCJVhk6BQQM+GaPA6crgy3Gda
   4BlesxjEjtmML5yArlxoODqCX5K9gmz6PelEEEjTiKyJzOX9OXHsbzv2g
   s=;
X-IronPort-AV: E=Sophos;i="5.81,222,1610409600"; 
   d="scan'208";a="89924695"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 04 Mar 2021 14:43:45 +0000
Received: from EX13D08EUB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id CA5FAA0811;
        Thu,  4 Mar 2021 14:43:42 +0000 (UTC)
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08EUB002.ant.amazon.com (10.43.166.232) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 4 Mar 2021 14:43:41 +0000
Received: from dev-dsk-mheyne-60001.pdx1.corp.amazon.com (10.184.85.242) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 4 Mar 2021 14:43:41 +0000
Received: by dev-dsk-mheyne-60001.pdx1.corp.amazon.com (Postfix, from userid 5466572)
        id 5891D21EA9; Thu,  4 Mar 2021 14:43:40 +0000 (UTC)
From:   Maximilian Heyne <mheyne@amazon.de>
CC:     Maximilian Heyne <mheyne@amazon.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: sched: avoid duplicates in classes dump
Date:   Thu, 4 Mar 2021 14:43:17 +0000
Message-ID: <20210304144317.78065-1-mheyne@amazon.de>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow up of commit ea3274695353 ("net: sched: avoid
duplicates in qdisc dump") which has fixed the issue only for the qdisc
dump.

The duplicate printing also occurs when dumping the classes via
  tc class show dev eth0

Fixes: 59cc1f61f09c ("net: sched: convert qdisc linked list to hashtable")
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
---
 net/sched/sch_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index e2e4353db8a7..f87d07736a14 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -2168,7 +2168,7 @@ static int tc_dump_tclass_qdisc(struct Qdisc *q, struct sk_buff *skb,
 
 static int tc_dump_tclass_root(struct Qdisc *root, struct sk_buff *skb,
 			       struct tcmsg *tcm, struct netlink_callback *cb,
-			       int *t_p, int s_t)
+			       int *t_p, int s_t, bool recur)
 {
 	struct Qdisc *q;
 	int b;
@@ -2179,7 +2179,7 @@ static int tc_dump_tclass_root(struct Qdisc *root, struct sk_buff *skb,
 	if (tc_dump_tclass_qdisc(root, skb, tcm, cb, t_p, s_t) < 0)
 		return -1;
 
-	if (!qdisc_dev(root))
+	if (!qdisc_dev(root) || !recur)
 		return 0;
 
 	if (tcm->tcm_parent) {
@@ -2214,13 +2214,13 @@ static int tc_dump_tclass(struct sk_buff *skb, struct netlink_callback *cb)
 	s_t = cb->args[0];
 	t = 0;
 
-	if (tc_dump_tclass_root(dev->qdisc, skb, tcm, cb, &t, s_t) < 0)
+	if (tc_dump_tclass_root(dev->qdisc, skb, tcm, cb, &t, s_t, true) < 0)
 		goto done;
 
 	dev_queue = dev_ingress_queue(dev);
 	if (dev_queue &&
 	    tc_dump_tclass_root(dev_queue->qdisc_sleeping, skb, tcm, cb,
-				&t, s_t) < 0)
+				&t, s_t, false) < 0)
 		goto done;
 
 done:
-- 
2.16.6




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



