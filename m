Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89835357240
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 18:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245585AbhDGQiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 12:38:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47898 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236269AbhDGQiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 12:38:24 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lUBBx-0003Lg-58; Wed, 07 Apr 2021 16:38:09 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Gautam Ramakrishnan <gautamramk@gmail.com>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: sched: Fix potential infinite loop
Date:   Wed,  7 Apr 2021 17:38:08 +0100
Message-Id: <20210407163808.499027-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The for-loop iterates with a u16 loop counter idx and compares this
with the loop upper limit of q->flows_cnt that is a u32 type.
There is a potential infinite loop if q->flows_cnt is larger than
the u8 loop counter. Fix this by making the loop counter the same
type as q->flows_cnt.

Addresses-Coverity: ("Infinite loop")
Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/sched/sch_fq_pie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index 949163fe68af..00563e137ecb 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -367,7 +367,7 @@ static void fq_pie_timer(struct timer_list *t)
 	struct fq_pie_sched_data *q = from_timer(q, t, adapt_timer);
 	struct Qdisc *sch = q->sch;
 	spinlock_t *root_lock; /* to lock qdisc for probability calculations */
-	u16 idx;
+	u32 idx;
 
 	root_lock = qdisc_lock(qdisc_root_sleeping(sch));
 	spin_lock(root_lock);
-- 
2.30.2

