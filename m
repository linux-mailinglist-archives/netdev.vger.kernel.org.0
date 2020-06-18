Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB021FF47C
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 16:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbgFROQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 10:16:29 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52220 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727078AbgFROQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 10:16:28 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CD63D63B92EC7A708921;
        Thu, 18 Jun 2020 22:16:22 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 18 Jun 2020 22:16:14 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Wei Yongjun <weiyongjun1@huawei.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] iavf: fix error return code in iavf_init_get_resources()
Date:   Thu, 18 Jun 2020 14:19:53 +0000
Message-ID: <20200618141953.29674-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: b66c7bc1cd4d ("iavf: Refactor init state machine")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index fa82768e5eda..bc83e2d99944 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1863,8 +1863,10 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 
 	adapter->rss_key = kzalloc(adapter->rss_key_size, GFP_KERNEL);
 	adapter->rss_lut = kzalloc(adapter->rss_lut_size, GFP_KERNEL);
-	if (!adapter->rss_key || !adapter->rss_lut)
+	if (!adapter->rss_key || !adapter->rss_lut) {
+		err = -ENOMEM;
 		goto err_mem;
+	}
 	if (RSS_AQ(adapter))
 		adapter->aq_required |= IAVF_FLAG_AQ_CONFIGURE_RSS;
 	else



