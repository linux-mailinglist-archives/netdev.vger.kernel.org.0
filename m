Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E36405483
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356895AbhIIM7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354802AbhIIMvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:51:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81D2463228;
        Thu,  9 Sep 2021 11:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188644;
        bh=wnKwA/60iuYLeWzRlkpXSybYhrzrUEEMFGcIe5dL5PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSob5iHsKPHeRuihd/h0Ovlq0BfARrG5l0iFwsAylJGGh847h8fYxfKlNUAQgCeI+
         xXnjaqAV8Fuz4OSfER1KpkMyn6LJ52GkltIQiJ/CmoY+/LA1K9hYROxMxkaNm8Zvz8
         y9NL7O91VOGsVZLgitVVUV/EaBg1MlJOFBHRoboB0sLuVjxLepmlKTZk1CjV9gommP
         IbddpKM+ah6w63UpuupA3mPuBJjCLqA/g0ZA2SBi2mZalv0N/Ahr9JiX36VtPdISUI
         GP11M7nQGVNpbaS8EOcl6PKlJtvd8tifbNofniv6o0hVRXYdgm4/BcJzwZaZJoL0L1
         mAA/f2gibeI4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>,
        syzbot+2b3e5fb6c7ef285a94f6@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 108/109] fix array-index-out-of-bounds in taprio_change
Date:   Thu,  9 Sep 2021 07:55:05 -0400
Message-Id: <20210909115507.147917-108-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
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
index a4de4853c79d..da9ed0613eb7 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1503,7 +1503,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
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

