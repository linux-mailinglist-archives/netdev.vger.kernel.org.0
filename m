Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6D8A5FF44
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 03:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfGEBK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 21:10:26 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58626 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726024AbfGEBK0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 21:10:26 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 26FC33DE9F000274A892;
        Fri,  5 Jul 2019 09:10:22 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Fri, 5 Jul 2019 09:10:15 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] gve: Fix error return code in gve_alloc_qpls()
Date:   Fri, 5 Jul 2019 01:16:42 +0000
Message-ID: <20190705011642.156707-1-weiyongjun1@huawei.com>
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

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index eef500bd2ff7..b65f6b010a82 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -625,8 +625,10 @@ static int gve_alloc_qpls(struct gve_priv *priv)
 				     sizeof(unsigned long) * BITS_PER_BYTE;
 	priv->qpl_cfg.qpl_id_map = kvzalloc(BITS_TO_LONGS(num_qpls) *
 					    sizeof(unsigned long), GFP_KERNEL);
-	if (!priv->qpl_cfg.qpl_id_map)
+	if (!priv->qpl_cfg.qpl_id_map) {
+		err = -ENOMEM;
 		goto free_qpls;
+	}
 
 	return 0;



