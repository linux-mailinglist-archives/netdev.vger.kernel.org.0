Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAD75280D4
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 11:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbiEPJZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 05:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiEPJZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 05:25:14 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026B228733;
        Mon, 16 May 2022 02:25:11 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4L1ty93B0DzCsk9;
        Mon, 16 May 2022 17:20:17 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.58) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 16 May 2022 17:25:10 +0800
From:   Xiu Jianfeng <xiujianfeng@huawei.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <xiujianfeng@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] octeontx2-pf: Use memset_startat() helper in otx2_stop()
Date:   Mon, 16 May 2022 17:23:37 +0800
Message-ID: <20220516092337.131653-1-xiujianfeng@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use memset_startat() helper to simplify the code, there is no functional
change in this patch.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 2b204c1c23de..208c98664ade 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1796,8 +1796,7 @@ int otx2_stop(struct net_device *netdev)
 	kfree(qset->rq);
 	kfree(qset->napi);
 	/* Do not clear RQ/SQ ringsize settings */
-	memset((void *)qset + offsetof(struct otx2_qset, sqe_cnt), 0,
-	       sizeof(*qset) - offsetof(struct otx2_qset, sqe_cnt));
+	memset_startat(qset, 0, sqe_cnt);
 	return 0;
 }
 EXPORT_SYMBOL(otx2_stop);
-- 
2.17.1

