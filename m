Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC1442289A
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235447AbhJENxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235563AbhJENwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FBDF61980;
        Tue,  5 Oct 2021 13:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441864;
        bh=l2PBwFcwTGHSNqGFtASWv7fKzwQj4tZRL3SFrv8yhiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikU/RhZKu0VeYmfKXrQONH/ZU5U84LXgsH0TU1juvuGfbBUx4zvAm05Mk2C0U/ADs
         kAkOjUHr5gmuBaajaIDrg6Ccq2CGzz28MyD4wqJ0u7Vi1ITGYR7SZsdfcosULeAjhb
         JaEmKYd8tT0NO4fq3G2VlznSXGQxGrB/hqMwWVMCBD+M7Zt5iglpS8iK9p8eeLlDFn
         TF5Qy5Y50087Qg97kQZEV/yaW8HPGJsTe/PCmAH+d38fInIeNtKwT1bHNMvkgTMTiB
         nHVzNXhV4w4t8ghgZxaRkgdRkKWdHFKb6Bh2xtTr62LKSZnwAFd7hOJQ6BGtZCnFF1
         kr7RKEA0LDokg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 21/40] mac80211: Drop frames from invalid MAC address in ad-hoc mode
Date:   Tue,  5 Oct 2021 09:50:00 -0400
Message-Id: <20211005135020.214291-21-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit a6555f844549cd190eb060daef595f94d3de1582 ]

WARNING: CPU: 1 PID: 9 at net/mac80211/sta_info.c:554
sta_info_insert_rcu+0x121/0x12a0
Modules linked in:
CPU: 1 PID: 9 Comm: kworker/u8:1 Not tainted 5.14.0-rc7+ #253
Workqueue: phy3 ieee80211_iface_work
RIP: 0010:sta_info_insert_rcu+0x121/0x12a0
...
Call Trace:
 ieee80211_ibss_finish_sta+0xbc/0x170
 ieee80211_ibss_work+0x13f/0x7d0
 ieee80211_iface_work+0x37a/0x500
 process_one_work+0x357/0x850
 worker_thread+0x41/0x4d0

If an Ad-Hoc node receives packets with invalid source MAC address,
it hits a WARN_ON in sta_info_insert_check(), this can spam the log.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20210827144230.39944-1-yuehaibing@huawei.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 2563473b5cf1..e023e307c0c3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4053,7 +4053,8 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		if (!bssid)
 			return false;
 		if (ether_addr_equal(sdata->vif.addr, hdr->addr2) ||
-		    ether_addr_equal(sdata->u.ibss.bssid, hdr->addr2))
+		    ether_addr_equal(sdata->u.ibss.bssid, hdr->addr2) ||
+		    !is_valid_ether_addr(hdr->addr2))
 			return false;
 		if (ieee80211_is_beacon(hdr->frame_control))
 			return true;
-- 
2.33.0

