Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B86F374199
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbhEEQkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234332AbhEEQiG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:38:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 619DE61444;
        Wed,  5 May 2021 16:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232415;
        bh=+Lb80RiCQ4DsnEB3+qdr0F/sCYz07DzZ2ogEYRtlZ3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tebqgzFsaxWJlJq2CV0drSB0CgtAeMmnlm58RjySLlbmTZW6jv60hiXs+tbtRU5nR
         m9BbG+B0w2RPdW7fiVKEo76ic5ajZErda9PmQzZJL1o0LAbicTNosWQT0bmpFnO6wa
         36TeC6WyNeWu1ZECGyeLIP7ixsb/FASScvu5uV55fbbm3ldsBJm0/EySFekfzjpzQi
         3Bup/dA0oWjHiGQvg+FJDglz78Q0Gash2tMqDIgotB9qLSHiowbCZcgPBHR1Y7n8KC
         fz/7aDFtBnhHDSMFFbZXkVxPk1lS3pjE4S5/U+Tu1aUhiyFclbLEc+BXSsOPcvIPXg
         2dUBSzzB7x2Xw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Du Cheng <ducheng2@gmail.com>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com,
        Cong Wang <cong.wang@bytedance.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 092/116] net: sched: tapr: prevent cycle_time == 0 in parse_taprio_schedule
Date:   Wed,  5 May 2021 12:31:00 -0400
Message-Id: <20210505163125.3460440-92-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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
index 8287894541e3..909c798b7403 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -901,6 +901,12 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 
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

