Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887D03B4E2F
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 12:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhFZKoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 06:44:46 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12031 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhFZKoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 06:44:44 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GBr2q6CbRzZjyt;
        Sat, 26 Jun 2021 18:39:15 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 26 Jun 2021 18:42:19 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 26
 Jun 2021 18:42:18 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <periyasa@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] mac80211: Reject zero MAC address in sta_info_insert_check()
Date:   Sat, 26 Jun 2021 18:38:56 +0800
Message-ID: <20210626103856.19816-1-yuehaibing@huawei.com>
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

Reported-by: syzbot+ef4ca92d9d6f5ba2f880@syzkaller.appspotmail.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
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
+		    is_valid_ether_addr(sta->sta.addr)))
 		return -EINVAL;
 
 	/* The RCU read lock is required by rhashtable due to
-- 
2.17.1

