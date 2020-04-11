Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2DE1A5B7C
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgDKXEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:04:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgDKXEJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0E5C214D8;
        Sat, 11 Apr 2020 23:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646249;
        bh=50gf1LNROuN9ofyw0oYtTd+q2+R9ltc6upJCETydXZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wkpQ3BsCSew15zlonw30CLlN0vyRX1G7JpycIxoqxvdL+lR+cajHUxLomQBn3wW2X
         xGmFNcJQneTjxFvCH8E1j28r7VOhqZCFHfcO4GebUvFMlvmpTTRZ+ZLbsW7NnCL/6O
         FAvwU1mi3wsNZhaRaWu8w/dg20BwRO7h2u/56pJM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pravas Kumar Panda <kumarpan@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 017/149] ath11k: Adding proper validation before accessing tx_stats
Date:   Sat, 11 Apr 2020 19:01:34 -0400
Message-Id: <20200411230347.22371-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pravas Kumar Panda <kumarpan@codeaurora.org>

[ Upstream commit fe0ebb51604f190b13b20a5f6c2821772c0cfc22 ]

Before dumping tx_stats proper validation was not been taken care of.
Due to which we were encountering null pointer dereference(kernel panic).
This scenario will arise when a station is getting disconnected and
we are changing the STA state by ath11k_mac_op_sta_state and assigning
tx_stats as NULL and after this the mac80211 will destroy the
debugfs entry from where we are trying to read the stats.

If anyone tries to dump tx_stats for that STA in between setting
tx_stats to NULL and debugfs file removal without checking the NULL
value it will run into a NULL pointer exception.

Proceeding with the analysis of "ARM Kernel Panic".
The APSS crash happened due to OOPS on CPU 3.
Crash Signature : Unable to handle kernel NULL pointer dereference at
virtual address 00000360
During the crash,
PC points to "ath11k_debug_htt_stats_init+0x16ac/0x1acc [ath11k]"
LR points to "ath11k_debug_htt_stats_init+0x1688/0x1acc [ath11k]".
The Backtrace obtained is as follows:
[<ffffffbffcfd8590>] ath11k_debug_htt_stats_init+0x16ac/0x1acc [ath11k]
[<ffffffc000156320>] do_loop_readv_writev+0x60/0xa4
[<ffffffc000156a5c>] do_readv_writev+0xd8/0x19c
[<ffffffc000156b54>] vfs_readv+0x34/0x48
[<ffffffc00017d6f4>] default_file_splice_read+0x1a8/0x2e4
[<ffffffc00017c56c>] do_splice_to+0x78/0x98
[<ffffffc00017c63c>] splice_direct_to_actor+0xb0/0x1a4
[<ffffffc00017c7b4>] do_splice_direct+0x84/0xa8
[<ffffffc000156f40>] do_sendfile+0x160/0x2a4
[<ffffffc000157980>] SyS_sendfile64+0xb4/0xc8

Signed-off-by: Pravas Kumar Panda <kumarpan@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/debugfs_sta.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs_sta.c b/drivers/net/wireless/ath/ath11k/debugfs_sta.c
index 743760c9bcae4..e52f3b079bacc 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs_sta.c
@@ -219,6 +219,9 @@ static ssize_t ath11k_dbg_sta_dump_tx_stats(struct file *file,
 	const int size = 2 * 4096;
 	char *buf;
 
+	if (!arsta->tx_stats)
+		return -ENOENT;
+
 	buf = kzalloc(size, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-- 
2.20.1

