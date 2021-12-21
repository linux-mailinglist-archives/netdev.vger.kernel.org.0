Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9613047BEFF
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 12:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237164AbhLULeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 06:34:04 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16845 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbhLULeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 06:34:03 -0500
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JJDpw1Dhxz8yfQ;
        Tue, 21 Dec 2021 19:33:12 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 19:34:01 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 21 Dec
 2021 19:34:01 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <ath11k@lists.infradead.org>
CC:     <kvalo@kernel.org>, <akolli@codeaurora.org>
Subject: [PATCH -next] ath11k: add missing of_node_put() to avoid leak
Date:   Tue, 21 Dec 2021 19:40:03 +0800
Message-ID: <20211221114003.335557-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The node pointer is returned by of_find_node_by_type()
or of_parse_phandle() with refcount incremented. Calling
of_node_put() to aovid the refcount leak.

Fixes: 6ac04bdc5edb ("ath11k: Use reserved host DDR addresses from DT for PCI devices")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/wireless/ath/ath11k/mhi.c | 1 +
 drivers/net/wireless/ath/ath11k/qmi.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index e4250ba8dfee..cccaa348cf21 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -332,6 +332,7 @@ static int ath11k_mhi_read_addr_from_dt(struct mhi_controller *mhi_ctrl)
 		return -ENOENT;
 
 	ret = of_address_to_resource(np, 0, &res);
+	of_node_put(np);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 3b9ba0e03a66..2d46c0b07be3 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1892,6 +1892,7 @@ static int ath11k_qmi_assign_target_mem_chunk(struct ath11k_base *ab)
 			}
 
 			ret = of_address_to_resource(hremote_node, 0, &res);
+			of_node_put(hremote_node);
 			if (ret) {
 				ath11k_dbg(ab, ATH11K_DBG_QMI,
 					   "qmi fail to get reg from hremote\n");
-- 
2.25.1

