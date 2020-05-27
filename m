Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5671E3765
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 06:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgE0Ef5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 00:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgE0Efy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 00:35:54 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C187C03E97B
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:35:53 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bg4so4368121plb.3
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/AZAmQTqbydzaxgqXP5EEC8VbRpGCwfPz1YWJZenrqA=;
        b=Kctgp9Xcumlt2TrX8R2o/iVja5OYM34tMqCEUUh27g7JiRDCuhzoiP6UWLLFnekXuz
         od1IwPuZYQE3EKj2X3BKAQ6Ohgw/7Q/NM8h5fxTSmNj82Cg7df9iKPd93B0hXDZFYb3w
         9VZdKplr0m/O+Lposfe0wk1aX8yXn047pM29JurvV0hcuVvOzOxkKDtjOK8NCZ3hOSTi
         APmSAG/Is/ym5RrQXbA0hpHJes5ZbqxlH+I56P8IRfjVAUmznTJUUg8C82lEkOfBoBCw
         i4xEV0Cn6QwrsBr7bWlUnjyeIUsx7OOYli3mV+xAFMuXq0zwEowGx41v+AVHoAPpXY1N
         oExg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/AZAmQTqbydzaxgqXP5EEC8VbRpGCwfPz1YWJZenrqA=;
        b=Weepo7ulB5DyjQ7oH5ne7Jm8vw7CtTavc5k4BAW3aYukgEs5GDg86lT6XVEdFAg6xZ
         7JZF8EZNtUgbbAY93yUYijs5UYbUOGVO7iWeHuda1b3bfGAaUwXbrFc56WNa9Oj6I17s
         xWSgidW+2O00S/UXluqmAbkkmo2rULsGHf6HeYFR9VFan3tjqbdJciRskK5S4B6BJYQ8
         zF31PAxElczUMWlvbkuwWoeULj/+rSqV/DxYx+9wh40RbiVntXC4FTnEP1S5vXzddZQ3
         KJoLGkmQqQjyz3jl7z6n3awdU7hwRZ4dcWUcY0cnjgS34rZmdpXitxnxUKZZYNqyM1ki
         SPiA==
X-Gm-Message-State: AOAM532ZQoBxw5vuiTgey3LzvFtSAA9kYnmVP0LcbfzVBNrDsKTvsn/s
        r0PI+906TGMarXtrqx7MBOWUoXok
X-Google-Smtp-Source: ABdhPJzputeRZ/n6FwzCxtP1s52zCg8fV1TB+YcwBGReUr7Oba0GG2T+IDKtlXFwgqqzn5RkHS+5IQ==
X-Received: by 2002:a17:902:bd42:: with SMTP id b2mr4024348plx.219.1590554152876;
        Tue, 26 May 2020 21:35:52 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id 62sm884990pfc.204.2020.05.26.21.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 21:35:52 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     vaclav.zindulka@tlapnet.cz, Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net-next 4/5] net_sched: avoid resetting active qdisc for multiple times
Date:   Tue, 26 May 2020 21:35:26 -0700
Message-Id: <20200527043527.12287-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527043527.12287-1-xiyou.wangcong@gmail.com>
References: <20200527043527.12287-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Except for sch_mq and sch_mqprio, each dev queue points to the
same root qdisc, so when we reset the dev queues with
netdev_for_each_tx_queue() we end up resetting the same instance
of the root qdisc for multiple times.

Avoid this by checking the __QDISC_STATE_DEACTIVATED bit in
each iteration, so for sch_mq/sch_mqprio, we still reset all
of them like before, for the rest, we only reset it once.

Reported-by: Václav Zindulka <vaclav.zindulka@tlapnet.cz>
Tested-by: Václav Zindulka <vaclav.zindulka@tlapnet.cz>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/sch_generic.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index a4271e47f220..d13e27467470 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1128,6 +1128,28 @@ void dev_activate(struct net_device *dev)
 }
 EXPORT_SYMBOL(dev_activate);
 
+static void qdisc_deactivate(struct Qdisc *qdisc)
+{
+	bool nolock = qdisc->flags & TCQ_F_NOLOCK;
+
+	if (qdisc->flags & TCQ_F_BUILTIN)
+		return;
+	if (test_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state))
+		return;
+
+	if (nolock)
+		spin_lock_bh(&qdisc->seqlock);
+	spin_lock_bh(qdisc_lock(qdisc));
+
+	set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
+
+	qdisc_reset(qdisc);
+
+	spin_unlock_bh(qdisc_lock(qdisc));
+	if (nolock)
+		spin_unlock_bh(&qdisc->seqlock);
+}
+
 static void dev_deactivate_queue(struct net_device *dev,
 				 struct netdev_queue *dev_queue,
 				 void *_qdisc_default)
@@ -1137,21 +1159,8 @@ static void dev_deactivate_queue(struct net_device *dev,
 
 	qdisc = rtnl_dereference(dev_queue->qdisc);
 	if (qdisc) {
-		bool nolock = qdisc->flags & TCQ_F_NOLOCK;
-
-		if (nolock)
-			spin_lock_bh(&qdisc->seqlock);
-		spin_lock_bh(qdisc_lock(qdisc));
-
-		if (!(qdisc->flags & TCQ_F_BUILTIN))
-			set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
-
+		qdisc_deactivate(qdisc);
 		rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
-		qdisc_reset(qdisc);
-
-		spin_unlock_bh(qdisc_lock(qdisc));
-		if (nolock)
-			spin_unlock_bh(&qdisc->seqlock);
 	}
 }
 
-- 
2.26.2

