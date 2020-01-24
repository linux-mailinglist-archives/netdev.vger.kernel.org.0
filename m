Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C09EE148754
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731638AbgAXOWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:22:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730177AbgAXOWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:22:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D1FB24676;
        Fri, 24 Jan 2020 14:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875726;
        bh=DVeTexbQjnRUs8BKffsTZRZmM7OK3bSgOL09DHl0+fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HeHPy4e39xkakBXur/v+yf4tgPmZ1XQWNXEj59l0v+wrflYBsG3Pis/VRQ07X2d2d
         fvaS//VkC+/hg9l6+8XKLhdn6+Aa5EtnOc7xF2h08+/bzEw/QzCBxvi2ddZ/BJqXh5
         5eKom8xOclNtHAg1GY0NbK/laHuICJbea0/thzi8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Markus Theil <markus.theil@tu-ilmenau.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/18] mac80211: mesh: restrict airtime metric to peered established plinks
Date:   Fri, 24 Jan 2020 09:21:45 -0500
Message-Id: <20200124142157.30931-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142157.30931-1-sashal@kernel.org>
References: <20200124142157.30931-1-sashal@kernel.org>
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
index b0acb2961e805..5f4c228b82e56 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -326,6 +326,9 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	u32 tx_time, estimated_retx;
 	u64 result;
 
+	if (sta->mesh->plink_state != NL80211_PLINK_ESTAB)
+		return MAX_METRIC;
+
 	/* Try to get rate based on HW/SW RC algorithm.
 	 * Rate is returned in units of Kbps, correct this
 	 * to comply with airtime calculation units
-- 
2.20.1

