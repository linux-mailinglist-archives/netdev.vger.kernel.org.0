Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8850C1CA521
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 09:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgEHHXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 03:23:45 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4294 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726207AbgEHHXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 03:23:44 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B262BE723199C5072069;
        Fri,  8 May 2020 15:23:41 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 15:23:35 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Jakub Kicinski <kuba@kernel.org>, Qiushi Wu <wu000273@umn.edu>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <oss-drivers@netronome.com>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] nfp: abm: fix error return code in nfp_abm_vnic_alloc()
Date:   Fri, 8 May 2020 07:27:35 +0000
Message-ID: <20200508072735.61047-1-weiyongjun1@huawei.com>
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

Fix to return negative error code -ENOMEM from the kzalloc() error
handling case instead of 0, as done elsewhere in this function.

Fixes: 174ab544e3bc ("nfp: abm: add cls_u32 offload for simple band classification")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/netronome/nfp/abm/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/main.c b/drivers/net/ethernet/netronome/nfp/abm/main.c
index 354efffac0f9..bdbf0726145e 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/main.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/main.c
@@ -333,8 +333,10 @@ nfp_abm_vnic_alloc(struct nfp_app *app, struct nfp_net *nn, unsigned int id)
 		goto err_free_alink;
 
 	alink->prio_map = kzalloc(abm->prio_map_len, GFP_KERNEL);
-	if (!alink->prio_map)
+	if (!alink->prio_map) {
+		err = -ENOMEM;
 		goto err_free_alink;
+	}
 
 	/* This is a multi-host app, make sure MAC/PHY is up, but don't
 	 * make the MAC/PHY state follow the state of any of the ports.



