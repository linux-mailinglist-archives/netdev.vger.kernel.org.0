Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE063B4E89
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 15:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhFZNGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 09:06:35 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5441 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhFZNGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 09:06:35 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GBvBC5nK8z74Px;
        Sat, 26 Jun 2021 21:00:51 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 26 Jun 2021 21:04:10 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 26
 Jun 2021 21:04:09 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <periyasa@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2] mac80211: Reject zero MAC address in sta_info_insert_check()
Date:   Sat, 26 Jun 2021 21:03:34 +0800
Message-ID: <20210626130334.13624-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As commit 52dba8d7d5ab ("mac80211: reject zero MAC address in add station")
said, we don't consider all-zeroes to be a valid MAC address in most places,
so also reject it here.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: Add missing ! operator

 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f2fb69da9b6e..3a6887fc9160 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -547,7 +547,7 @@ static int sta_info_insert_check(struct sta_info *sta)
 		return -ENETDOWN;
 
 	if (WARN_ON(ether_addr_equal(sta->sta.addr, sdata->vif.addr) ||
-		    is_multicast_ether_addr(sta->sta.addr)))
+		    !is_valid_ether_addr(sta->sta.addr)))
 		return -EINVAL;
 
 	/* The RCU read lock is required by rhashtable due to
-- 
2.17.1

