Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98502374551
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238048AbhEEREj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:04:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237072AbhEEQ7Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:59:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D54461581;
        Wed,  5 May 2021 16:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232788;
        bh=ctiHUHaWyX+GfQ91aGObhMCWS66KVMKBlNRVNOIZHFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oeqq22DYX4tHXYdZEKjgusMu/f4rryeXUg8nU4EnCXwX2mZFxlgu7lVsRPNWLz5BJ
         RbmxZ7o6gwoaZYo53LLUmDZyxsaglopOCffppo5TUjUzOLHEEhB4E89F8Ctyyhu3FI
         1HMQwWnmhc/Z4ue8dun0bjpSFtYAsbRXGcJjQ46WE6SDuPt6jMNkqjUxVu9NOyZL9R
         NSYPmnqgThwZAwlQAPl2XPqxDaC6K0SrBwPHL5BkobtWuaCeGx/R96M5HfwILDNz6n
         hZ3CwkvpUUt3uP/Vr2teROSi6yujcQE4vAK4/fvkYy4CvdSipWwRUZCJxFVJjkfNVM
         GIy2WaXCcinhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Du Cheng <ducheng2@gmail.com>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com,
        Cong Wang <cong.wang@bytedance.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 35/46] net: sched: tapr: prevent cycle_time == 0 in parse_taprio_schedule
Date:   Wed,  5 May 2021 12:38:45 -0400
Message-Id: <20210505163856.3463279-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163856.3463279-1-sashal@kernel.org>
References: <20210505163856.3463279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Du Cheng <ducheng2@gmail.com>

[ Upstream commit ed8157f1ebf1ae81a8fa2653e3f20d2076fad1c9 ]

There is a reproducible sequence from the userland that will trigger a WARN_ON()
condition in taprio_get_start_time, which causes kernel to panic if configured
as "panic_on_warn". Catch this condition in parse_taprio_schedule to
prevent this condition.

Reported as bug on syzkaller:
https://syzkaller.appspot.com/bug?extid=d50710fd0873a9c6b40c

Reported-by: syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Signed-off-by: Du Cheng <ducheng2@gmail.com>
Acked-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 09116be99511..a4de4853c79d 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -900,6 +900,12 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 
 		list_for_each_entry(entry, &new->entries, list)
 			cycle = ktime_add_ns(cycle, entry->interval);
+
+		if (!cycle) {
+			NL_SET_ERR_MSG(extack, "'cycle_time' can never be 0");
+			return -EINVAL;
+		}
+
 		new->cycle_time = cycle;
 	}
 
-- 
2.30.2

