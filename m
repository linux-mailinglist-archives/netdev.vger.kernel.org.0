Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB23C3B85
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390074AbfJAQor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390061AbfJAQop (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:44:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BC9121924;
        Tue,  1 Oct 2019 16:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948285;
        bh=nuXD4wbneSMpDhykuG26b2NJCMcSOTmYL3uTk8bs/B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mR7ADidclbVp4XmykTuSIEhv2Je7U2BKuu4E+cJGQp/q7Tc3f2SVil+oIz7T+c1n+
         gviQf7yMzU5kxZw0Mt7Mng8ZWFQxXDqV6OlTBQauJMK3I/dyJicwEIXo+poDVr6QaG
         YPdwOhuF/yXwDa/PerBVGpscnM4rJ6+JOs4zArGI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 17/29] net_sched: add max len check for TCA_KIND
Date:   Tue,  1 Oct 2019 12:44:11 -0400
Message-Id: <20191001164423.16406-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164423.16406-1-sashal@kernel.org>
References: <20191001164423.16406-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 62794fc4fbf52f2209dc094ea255eaef760e7d01 ]

The TCA_KIND attribute is of NLA_STRING which does not check
the NUL char. KMSAN reported an uninit-value of TCA_KIND which
is likely caused by the lack of NUL.

Change it to NLA_NUL_STRING and add a max len too.

Fixes: 8b4c3cdd9dd8 ("net: sched: Add policy validation for tc attributes")
Reported-and-tested-by: syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 7b4270987ac16..637949b576c63 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1217,7 +1217,8 @@ check_loop_fn(struct Qdisc *q, unsigned long cl, struct qdisc_walker *w)
  */
 
 const struct nla_policy rtm_tca_policy[TCA_MAX + 1] = {
-	[TCA_KIND]		= { .type = NLA_STRING },
+	[TCA_KIND]		= { .type = NLA_NUL_STRING,
+				    .len = IFNAMSIZ - 1 },
 	[TCA_RATE]		= { .type = NLA_BINARY,
 				    .len = sizeof(struct tc_estimator) },
 	[TCA_STAB]		= { .type = NLA_NESTED },
-- 
2.20.1

