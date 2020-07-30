Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D52232C18
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 08:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgG3GvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 02:51:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8860 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728760AbgG3Gu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 02:50:59 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1369950D6FCD2D5DE4B9;
        Thu, 30 Jul 2020 14:50:57 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Jul 2020
 14:50:50 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <imitsyanko@quantenna.com>, <geomatsi@gmail.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <mst@redhat.com>, <mkarpenko@quantenna.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] qtnfmac: Missing platform_device_unregister() on error in qtnf_core_mac_alloc()
Date:   Thu, 30 Jul 2020 14:49:10 +0800
Message-ID: <20200730064910.37589-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing platform_device_unregister() before return from
qtnf_core_mac_alloc() in the error handling case.

Fixes: 616f5701f4ab ("qtnfmac: assign each wiphy to its own virtual platform device")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/wireless/quantenna/qtnfmac/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index eea777f8acea..6aafff9d4231 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -446,8 +446,11 @@ static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus,
 	}
 
 	wiphy = qtnf_wiphy_allocate(bus, pdev);
-	if (!wiphy)
+	if (!wiphy) {
+		if (pdev)
+			platform_device_unregister(pdev);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	mac = wiphy_priv(wiphy);
 
-- 
2.17.1

