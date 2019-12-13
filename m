Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C65711DBA9
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 02:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731721AbfLMB1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 20:27:09 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7681 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731684AbfLMB1J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 20:27:09 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 84F57648FB05A14B29D8;
        Fri, 13 Dec 2019 09:27:04 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Fri, 13 Dec 2019 09:27:02 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <msinada@codeaurora.org>, <periyasa@codeaurora.org>,
        <mpubbise@codeaurora.org>, <julia.lawall@lip6.fr>,
        <milehu@codeaurora.org>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] ath11k: add dependency for struct ath11k member debug
Date:   Fri, 13 Dec 2019 09:24:17 +0800
Message-ID: <20191213012417.130719-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_ATH11K, CONFIG_MAC80211_DEBUGFS are set,
and CONFIG_ATH11K_DEBUGFS is not set, below error can be found,
drivers/net/wireless/ath/ath11k/debugfs_sta.c: In function ath11k_dbg_sta_open_htt_peer_stats:
drivers/net/wireless/ath/ath11k/debugfs_sta.c:411:4: error: struct ath11k has no member named debug
  ar->debug.htt_stats.stats_req = stats_req;

It is to add the dependency for the member of struct ath11k.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/wireless/ath/ath11k/debugfs_sta.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs_sta.c b/drivers/net/wireless/ath/ath11k/debugfs_sta.c
index 3c5f931..bcc51d7 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs_sta.c
@@ -408,7 +408,9 @@ ath11k_dbg_sta_open_htt_peer_stats(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	mutex_lock(&ar->conf_mutex);
+#ifdef CONFIG_ATH11K_DEBUGFS
 	ar->debug.htt_stats.stats_req = stats_req;
+#endif
 	stats_req->type = ATH11K_DBG_HTT_EXT_STATS_PEER_INFO;
 	memcpy(stats_req->peer_addr, sta->addr, ETH_ALEN);
 	ret = ath11k_dbg_htt_stats_req(ar);
-- 
2.7.4

