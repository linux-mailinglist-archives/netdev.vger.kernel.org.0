Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87898404DA2
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346963AbhIIMEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:04:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343693AbhIIMB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:01:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51AC7615A3;
        Thu,  9 Sep 2021 11:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187991;
        bh=AnqclIy/yhabaP/XcnnT3myiJuVDcV2mN78sB8cMj18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RDm/Df3iV5VFR9LRzMQYYI73JYdnjXy+63sI3X8oFXRPZ6Z+X2Q42GTsxPlJqNRDy
         kBa5tPQsOeXb0AsP58vS6ZGJxvhew96zhU0+7USyY1FfTOQNsaHUI4CXmbsNMs1NUD
         qXhts1JCtTArHef9adcsNXHJ1uTE8xEZ47fvpp0v5PKCwMiAJsMFfbGhukzJr18cjw
         KE4yxp0BDS48xRtxpOPJOMI0Xlvy5wuml9ErACHPkhRsIRst4hdGRXXmheyXiwd99g
         5wma83EKrNgMUNknPWx0lH9kpNcOJSeGWrH4x9Ci52EgBMMwkOw7O22TA8rOtSg94R
         boNopdpNQ7UdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>,
        syzbot+2b3e5fb6c7ef285a94f6@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 250/252] fix array-index-out-of-bounds in taprio_change
Date:   Thu,  9 Sep 2021 07:41:04 -0400
Message-Id: <20210909114106.141462-250-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haimin Zhang <tcs_kernel@tencent.com>

[ Upstream commit efe487fce3061d94222c6501d7be3aa549b3dc78 ]

syzbot report an array-index-out-of-bounds in taprio_change
index 16 is out of range for type '__u16 [16]'
that's because mqprio->num_tc is lager than TC_MAX_QUEUE,so we check
the return value of netdev_set_num_tc.

Reported-by: syzbot+2b3e5fb6c7ef285a94f6@syzkaller.appspotmail.com
Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 9c79374457a0..1ab2fc933a21 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1513,7 +1513,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	taprio_set_picos_per_byte(dev, q);
 
 	if (mqprio) {
-		netdev_set_num_tc(dev, mqprio->num_tc);
+		err = netdev_set_num_tc(dev, mqprio->num_tc);
+		if (err)
+			goto free_sched;
 		for (i = 0; i < mqprio->num_tc; i++)
 			netdev_set_tc_queue(dev, i,
 					    mqprio->count[i],
-- 
2.30.2

