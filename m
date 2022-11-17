Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB5F62D638
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239802AbiKQJPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239596AbiKQJPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:15:18 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA805BD56
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:15:17 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NCZ1K6nGxzJnpm;
        Thu, 17 Nov 2022 17:12:05 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 17:15:15 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <ericvh@gmail.com>, <lucho@ionkov.net>, <asmadeus@codewreck.org>,
        <linux_oss@crudebyte.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <v9fs-developer@lists.sourceforge.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/3 v2] 9p: Remove redundent checks for message size against msize.
Date:   Thu, 17 Nov 2022 17:11:58 +0800
Message-ID: <20221117091159.31533-3-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221117091159.31533-1-guozihua@huawei.com>
References: <20221117091159.31533-1-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the msize is non-consistant with the capacity of the tag and as we
are now checking message size against capacity directly, there is no
point checking message size against msize. So remove it.

Fixes: 3da2e34b64cd ("9p: Fix write overflow in p9_read_work")
Signed-off-by: GUO Zihua <guozihua@huawei.com>
---
 net/9p/trans_fd.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 30f37bf7c598..4ba602438550 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -322,14 +322,6 @@ static void p9_read_work(struct work_struct *work)
 			goto error;
 		}
 
-		if (m->rc.size >= m->client->msize) {
-			p9_debug(P9_DEBUG_ERROR,
-				 "requested packet size too big: %d\n",
-				 m->rc.size);
-			err = -EIO;
-			goto error;
-		}
-
 		p9_debug(P9_DEBUG_TRANS,
 			 "mux %p pkt: size: %d bytes tag: %d\n",
 			 m, m->rc.size, m->rc.tag);
-- 
2.17.1

