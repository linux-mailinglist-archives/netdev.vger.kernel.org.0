Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4F337446B
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235783AbhEEQ5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236265AbhEEQxn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:53:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 816206198A;
        Wed,  5 May 2021 16:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232701;
        bh=c9WwFmxOBLGRwULHcpIEda+vh5qxPYLJGDW6aHdicYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcRHy8Lr1hUbFbTCZBGJaEg/3mtZxgY85Bq217POcTMMl4NBmLEKnXV/8+oD5wk/e
         RRT7Hq3zIMYzeK3AhCc3NLQYekYzD6MlOLeCcGQX17Zx4jR4djRO7/o6qxJEIS3+Zw
         RoaWSjDZrpyg95VVFLHgcl6LSglcBIenZSyUNkVPcXvo9RMz9WucWLNhj86Db44s1x
         Wj8Rx2jVwzrAogwF/212aKQTtGtURLpySDhQTxmfKtnMpinPk3tlrzCEux4Vrrpj1H
         8Xfew2+hFKwDQrDp+UyeD1taDVg01EKOvcacm195U6P95ksmCVgr0K9R5MsDSljbrR
         JBHBvGria7DXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Du Cheng <ducheng2@gmail.com>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com,
        Cong Wang <cong.wang@bytedance.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 63/85] net: sched: tapr: prevent cycle_time == 0 in parse_taprio_schedule
Date:   Wed,  5 May 2021 12:36:26 -0400
Message-Id: <20210505163648.3462507-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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
index c966c05a0be9..00853065dfa0 100644
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

