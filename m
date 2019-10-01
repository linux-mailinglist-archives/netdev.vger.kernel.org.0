Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8CBC3C1D
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388644AbfJAQtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390158AbfJAQpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:45:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C620621906;
        Tue,  1 Oct 2019 16:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948304;
        bh=/IYo5roa4Q+ctDC9Bvv7wMlZDgCr48KRYi1cp/Ua1hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rX2HMuWYVpnpc6EVoTXV3qtuHUqdZY6k2/ISmyy0+BLxPPXXj8CzFIoEs0fQBkCrC
         7ezhLT9jCnPdH9bYY6XGoV8gDQuBgMFM9dYChi4BkIU+5Quwn3g1veBVq65hJb1mIh
         nQrFOClJQmziPwD/L+hRLBjJPr/4y4W9/cj9fU0U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 29/29] sch_netem: fix a divide by zero in tabledist()
Date:   Tue,  1 Oct 2019 12:44:23 -0400
Message-Id: <20191001164423.16406-29-sashal@kernel.org>
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
index 3d5654333d497..787aa52e5991c 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -708,7 +708,7 @@ static int get_dist_table(struct Qdisc *sch, const struct nlattr *attr)
 	struct disttable *d;
 	int i;
 
-	if (n > NETEM_DIST_MAX)
+	if (!n || n > NETEM_DIST_MAX)
 		return -EINVAL;
 
 	d = kvmalloc(sizeof(struct disttable) + n * sizeof(s16), GFP_KERNEL);
-- 
2.20.1

