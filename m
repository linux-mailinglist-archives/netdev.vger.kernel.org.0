Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED993742D3
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbhEEQse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235989AbhEEQpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:45:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7800561939;
        Wed,  5 May 2021 16:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232573;
        bh=eSy6zKIxXLzxOslN40huBVdUCeubKe8+1nZOsfvq3Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1bTNaxSptNmlKqeZ2y0o/HKsAA2N1OxejN1rASmi+fYyrRRUdBvuCP3TWljnTFE3
         AKaIOZQvNYoCZIeYwfgVzV72AjVBbbqSdpIYRDU1ud49T8rC3LPptGs3gwpts2pe60
         /1QpkprKgJfW6RgLziuS+XU3I9W8cODTBpMHpLC5LSZZnjhO/NBdcpDs7yRjUQtHWO
         Cy5jKeP+nTI/HdAYs6V2DauVlt7w8cWbSp/vJNzrcRw+ae1E4nhOCSnZ+nSefnlFYM
         8ZADvSb0e4mpzx5fC/S50lU8DVnfRCSuGU7XfrDHVQ/XdXvAf5c0jQWNp6Uyt0KZuR
         iPY+Qwz01ncJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Du Cheng <ducheng2@gmail.com>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com,
        Cong Wang <cong.wang@bytedance.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 082/104] net: sched: tapr: prevent cycle_time == 0 in parse_taprio_schedule
Date:   Wed,  5 May 2021 12:33:51 -0400
Message-Id: <20210505163413.3461611-82-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
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
index 6f775275826a..c70f93d64483 100644
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

