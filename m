Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAE11488D2
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403820AbgAXObJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:31:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731125AbgAXOUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B93932087E;
        Fri, 24 Jan 2020 14:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875629;
        bh=OHbEb95UQ/uDxKtaT7TWCgF3ujdAcFfh7VMwS96ofwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKXAwtcFg9OdFDhXzP9WZakOLJVTEj6lgRRpY24r46WPdAW9ZSnAUB0ZKf+Wp8Au3
         Mb+nm8tFbEgVYf8prPx3UXycXx4PyjP0xGIqR5Nkc/rkp6CodwL7bLPAcKQnfqC+wD
         F7zY71GQ3QidsRJpgXOqsmqmQB/rJ4pzdxjIxNsE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Markus Theil <markus.theil@tu-ilmenau.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/56] mac80211: mesh: restrict airtime metric to peered established plinks
Date:   Fri, 24 Jan 2020 09:19:30 -0500
Message-Id: <20200124142012.29752-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Theil <markus.theil@tu-ilmenau.de>

[ Upstream commit 02a614499600af836137c3fbc4404cd96365fff2 ]

The following warning is triggered every time an unestablished mesh peer
gets dumped. Checks if a peer link is established before retrieving the
airtime link metric.

[ 9563.022567] WARNING: CPU: 0 PID: 6287 at net/mac80211/mesh_hwmp.c:345
               airtime_link_metric_get+0xa2/0xb0 [mac80211]
[ 9563.022697] Hardware name: PC Engines apu2/apu2, BIOS v4.10.0.3
[ 9563.022756] RIP: 0010:airtime_link_metric_get+0xa2/0xb0 [mac80211]
[ 9563.022838] Call Trace:
[ 9563.022897]  sta_set_sinfo+0x936/0xa10 [mac80211]
[ 9563.022964]  ieee80211_dump_station+0x6d/0x90 [mac80211]
[ 9563.023062]  nl80211_dump_station+0x154/0x2a0 [cfg80211]
[ 9563.023120]  netlink_dump+0x17b/0x370
[ 9563.023130]  netlink_recvmsg+0x2a4/0x480
[ 9563.023140]  ____sys_recvmsg+0xa6/0x160
[ 9563.023154]  ___sys_recvmsg+0x93/0xe0
[ 9563.023169]  __sys_recvmsg+0x7e/0xd0
[ 9563.023210]  do_syscall_64+0x4e/0x140
[ 9563.023217]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
Link: https://lore.kernel.org/r/20191203180644.70653-1-markus.theil@tu-ilmenau.de
[rewrite commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_hwmp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 6950cd0bf5940..740dc9fa127cd 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -326,6 +326,9 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	unsigned long fail_avg =
 		ewma_mesh_fail_avg_read(&sta->mesh->fail_avg);
 
+	if (sta->mesh->plink_state != NL80211_PLINK_ESTAB)
+		return MAX_METRIC;
+
 	/* Try to get rate based on HW/SW RC algorithm.
 	 * Rate is returned in units of Kbps, correct this
 	 * to comply with airtime calculation units
-- 
2.20.1

