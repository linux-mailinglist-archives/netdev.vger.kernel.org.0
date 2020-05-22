Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C2B1DEA9F
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 16:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731157AbgEVOzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 10:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730046AbgEVOvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 10:51:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE4D72240A;
        Fri, 22 May 2020 14:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159079;
        bh=EttFuyWUsVA2+0so7dutokKTLb7us68VFKlExgm5ag4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9UwBPSMflr2b4itKqsI9BSq9fTI9jPkJUrPbCyx6Vpup0IwDn+gM4CB9vb9yQmIr
         dzcLAEd1uPk5OUgulFnQZPRO60KOSMDTc7+Mu+qN/55ybfz81nTdI+ICMFBW2mblY6
         MrYkkiBM6//zEYs787mCdNROWrPw7GMWVosqWHIo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        syzbot+bb82cafc737c002d11ca@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 32/32] drivers: net: hamradio: Fix suspicious RCU usage warning in bpqether.c
Date:   Fri, 22 May 2020 10:50:44 -0400
Message-Id: <20200522145044.434677-32-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145044.434677-1-sashal@kernel.org>
References: <20200522145044.434677-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit 95f59bf88bb75281cc626e283ecefdd5d5641427 ]

This patch fixes the following warning:
=============================
WARNING: suspicious RCU usage
5.7.0-rc5-next-20200514-syzkaller #0 Not tainted
-----------------------------
drivers/net/hamradio/bpqether.c:149 RCU-list traversed in non-reader section!!

Since rtnl lock is held, pass this cond in list_for_each_entry_rcu().

Reported-by: syzbot+bb82cafc737c002d11ca@syzkaller.appspotmail.com
Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/bpqether.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index fbea6f232819..e2ad3c2e8df5 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -127,7 +127,8 @@ static inline struct net_device *bpq_get_ax25_dev(struct net_device *dev)
 {
 	struct bpqdev *bpq;
 
-	list_for_each_entry_rcu(bpq, &bpq_devices, bpq_list) {
+	list_for_each_entry_rcu(bpq, &bpq_devices, bpq_list,
+				lockdep_rtnl_is_held()) {
 		if (bpq->ethdev == dev)
 			return bpq->axdev;
 	}
-- 
2.25.1

