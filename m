Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6083CC3BEA
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390322AbfJAQpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390314AbfJAQpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:45:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1EA72190F;
        Tue,  1 Oct 2019 16:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948332;
        bh=uiHsB3meyPILAAZDTjLvMiCCFNR9pJuupii+/uI5/FA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDzP/xyOYUJMPuoOUmg9ZRaO2Dw7K3TVjzTWi/NnV0Y0Se5PmHEHyTiV4WK7W9xF1
         ybqkGjK8Oz5p/l+u7dzMTm5PAErKb7Xu0HK5wh08arbJ1GHC4FTtmUvVnbNkBQGKyW
         SDFNV6AUjfINaUqYaliZ5pZOsu/Kgupx6bA/csb4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 19/19] sch_netem: fix a divide by zero in tabledist()
Date:   Tue,  1 Oct 2019 12:45:05 -0400
Message-Id: <20191001164505.16708-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164505.16708-1-sashal@kernel.org>
References: <20191001164505.16708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b41d936b5ecfdb3a4abc525ce6402a6c49cffddc ]

syzbot managed to crash the kernel in tabledist() loading
an empty distribution table.

	t = dist->table[rnd % dist->size];

Simply return an error when such load is attempted.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index e9812e21dbc9b..12e3ae09c4ba1 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -711,7 +711,7 @@ static int get_dist_table(struct Qdisc *sch, const struct nlattr *attr)
 	int i;
 	size_t s;
 
-	if (n > NETEM_DIST_MAX)
+	if (!n || n > NETEM_DIST_MAX)
 		return -EINVAL;
 
 	s = sizeof(struct disttable) + n * sizeof(s16);
-- 
2.20.1

