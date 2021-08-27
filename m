Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBBE3F9B09
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 16:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245331AbhH0OoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 10:44:16 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14427 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245263AbhH0OoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 10:44:15 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gx2RP4LsNzbdLn;
        Fri, 27 Aug 2021 22:39:29 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 22:43:21 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 27
 Aug 2021 22:43:20 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] mac80211: Drop frames from invalid MAC address in ad-hoc mode
Date:   Fri, 27 Aug 2021 22:42:30 +0800
Message-ID: <20210827144230.39944-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 2563473..e023e30 100644
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
1.8.3.1

