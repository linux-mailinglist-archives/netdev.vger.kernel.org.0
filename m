Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEA86384A7
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 08:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiKYHp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 02:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiKYHpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 02:45:53 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DCF2F03F;
        Thu, 24 Nov 2022 23:45:52 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NJRjS6j9nz15Mr5;
        Fri, 25 Nov 2022 15:45:16 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 15:45:49 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: [PATCH net 2/2] octeontx2-pf: Fix a potential double free in otx2_sq_free_sqbs()
Date:   Fri, 25 Nov 2022 15:45:46 +0800
Message-ID: <047b210eb3b3a2e26703d8b0570a0a017789c169.1669361183.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1669361183.git.william.xuanziyang@huawei.com>
References: <cover.1669361183.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

otx2_sq_free_sqbs() will be called twice when goto "err_free_nix_queues"
label in otx2_init_hw_resources(). The first calling is within
otx2_free_sq_res() at "err_free_nix_queues" label, and the second calling
is at later "err_free_sq_ptrs" label.

In otx2_sq_free_sqbs(), If sq->sqb_ptrs[i] is not 0, the memory page it
points to will be freed, and sq->sqb_ptrs[i] do not be assigned 0 after
memory page be freed. If otx2_sq_free_sqbs() is called twice, the memory
page pointed by sq->sqb_ptrs[i] will be freeed twice. To fix the bug,
assign 0 to sq->sqb_ptrs[i] after memory page be freed.

Fixes: caa2da34fd25 ("octeontx2-pf: Initialize and config queues")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 9e10e7471b88..5a25fe51d102 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1146,6 +1146,7 @@ void otx2_sq_free_sqbs(struct otx2_nic *pfvf)
 					     DMA_FROM_DEVICE,
 					     DMA_ATTR_SKIP_CPU_SYNC);
 			put_page(virt_to_page(phys_to_virt(pa)));
+			sq->sqb_ptrs[sqb] = 0;
 		}
 		sq->sqb_count = 0;
 	}
-- 
2.25.1

