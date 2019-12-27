Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A93AB12B7D8
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfL0Rv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:51:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:40712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbfL0RnR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:43:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 702652464B;
        Fri, 27 Dec 2019 17:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468597;
        bh=VILDewDdZZ57MJtd8nZfpQtoINtvKmzSvR8cAHZgqHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdaKDxIUyvf74v8V5OR3soE65+kl/S/anRy9N3enL5ocl7uNkSYFf1ONYm9xmkVCc
         ZiiEUkTPGDFBQZ8ixpfHkjvKyId8JWqRzc5MbCRml5Xm5ln7GYtLsrhLvU1DfUQXPs
         TnoYzjPJz284A2t9RtDXadhy8m0KokwrgGCJfwY4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vishal Kulkarni <vishal@chelsio.com>,
        Herat Ramani <herat@chelsio.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 118/187] cxgb4: Fix kernel panic while accessing sge_info
Date:   Fri, 27 Dec 2019 12:39:46 -0500
Message-Id: <20191227174055.4923-118-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>

[ Upstream commit 479a0d1376f6d97c60871442911f1394d4446a25 ]

The sge_info debugfs collects offload queue info even when offload
capability is disabled and leads to panic.

[  144.139871] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  144.139874] CR2: 0000000000000000 CR3: 000000082d456005 CR4: 00000000001606e0
[  144.139876] Call Trace:
[  144.139887]  sge_queue_start+0x12/0x30 [cxgb4]
[  144.139897]  seq_read+0x1d4/0x3d0
[  144.139906]  full_proxy_read+0x50/0x70
[  144.139913]  vfs_read+0x89/0x140
[  144.139916]  ksys_read+0x55/0xd0
[  144.139924]  do_syscall_64+0x5b/0x1d0
[  144.139933]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  144.139936] RIP: 0033:0x7f4b01493990

Fix this crash by skipping the offload queue access in sge_qinfo when
offload capability is disabled

Signed-off-by: Herat Ramani <herat@chelsio.com>
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index ae6a47dd7dc9..fb8ade9a05a9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -2996,6 +2996,9 @@ static int sge_queue_entries(const struct adapter *adap)
 	int tot_uld_entries = 0;
 	int i;
 
+	if (!is_uld(adap))
+		goto lld_only;
+
 	mutex_lock(&uld_mutex);
 	for (i = 0; i < CXGB4_TX_MAX; i++)
 		tot_uld_entries += sge_qinfo_uld_txq_entries(adap, i);
@@ -3006,6 +3009,7 @@ static int sge_queue_entries(const struct adapter *adap)
 	}
 	mutex_unlock(&uld_mutex);
 
+lld_only:
 	return DIV_ROUND_UP(adap->sge.ethqsets, 4) +
 	       tot_uld_entries +
 	       DIV_ROUND_UP(MAX_CTRL_QUEUES, 4) + 1;
-- 
2.20.1

