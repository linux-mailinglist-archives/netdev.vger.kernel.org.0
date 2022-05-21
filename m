Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D623C52F944
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 08:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354669AbiEUGdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 02:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351693AbiEUGdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 02:33:17 -0400
Received: from smtp.smtpout.orange.fr (smtp06.smtpout.orange.fr [80.12.242.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50CD17CE7C
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 23:33:11 -0700 (PDT)
Received: from pop-os.home ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id sIfgnYsPsxzw2sIfgneAk5; Sat, 21 May 2022 08:33:09 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 21 May 2022 08:33:09 +0200
X-ME-IP: 86.243.180.246
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Aviad Krawczyk <aviad.krawczyk@huawei.com>,
        Zhao Chen <zhaochen6@huawei.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] hinic: Avoid some over memory allocation
Date:   Sat, 21 May 2022 08:33:01 +0200
Message-Id: <b9eb43e831e71b38d4d428dd7a8f4153608a4df6.1653114759.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'prod_idx' (atomic_t) is larger than 'shadow_idx' (u16), so some memory is
over-allocated.

Fixes: b15a9f37be2b ("net-next/hinic: Add wq")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
index f7dc7d825f63..4daf6bf291ec 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
@@ -386,7 +386,7 @@ static int alloc_wqes_shadow(struct hinic_wq *wq)
 		return -ENOMEM;
 
 	wq->shadow_idx = devm_kcalloc(&pdev->dev, wq->num_q_pages,
-				      sizeof(wq->prod_idx), GFP_KERNEL);
+				      sizeof(*wq->shadow_idx), GFP_KERNEL);
 	if (!wq->shadow_idx)
 		goto err_shadow_idx;
 
-- 
2.34.1

