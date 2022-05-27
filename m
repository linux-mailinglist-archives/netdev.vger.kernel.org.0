Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C1A535941
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 08:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbiE0GYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 02:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiE0GYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 02:24:45 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1DD25C4A;
        Thu, 26 May 2022 23:24:43 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L8ZWH0xDwzjX6Q;
        Fri, 27 May 2022 14:23:39 +0800 (CST)
Received: from dggpemm500018.china.huawei.com (7.185.36.111) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 27 May 2022 14:24:41 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggpemm500018.china.huawei.com (7.185.36.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 27 May 2022 14:24:40 +0800
From:   keliu <liuke94@huawei.com>
To:     <bjorn@kernel.org>, <magnus.karlsson@intel.com>,
        <maciej.fijalkowski@intel.com>, <jonathan.lemon@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     keliu <liuke94@huawei.com>
Subject: [PATCH] net: xdp: Directly use ida_alloc()/free()
Date:   Fri, 27 May 2022 06:46:09 +0000
Message-ID: <20220527064609.2358482-1-liuke94@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500018.china.huawei.com (7.185.36.111)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use ida_alloc()/ida_free() instead of deprecated
ida_simple_get()/ida_simple_remove() .

Signed-off-by: keliu <liuke94@huawei.com>
---
 net/xdp/xdp_umem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index f01ef6bda390..869b9b9b9fad 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -57,7 +57,7 @@ static int xdp_umem_addr_map(struct xdp_umem *umem, struct page **pages,
 static void xdp_umem_release(struct xdp_umem *umem)
 {
 	umem->zc = false;
-	ida_simple_remove(&umem_ida, umem->id);
+	ida_free(&umem_ida, umem->id);
 
 	xdp_umem_addr_unmap(umem);
 	xdp_umem_unpin_pages(umem);
@@ -242,7 +242,7 @@ struct xdp_umem *xdp_umem_create(struct xdp_umem_reg *mr)
 	if (!umem)
 		return ERR_PTR(-ENOMEM);
 
-	err = ida_simple_get(&umem_ida, 0, 0, GFP_KERNEL);
+	err = ida_alloc(&umem_ida, GFP_KERNEL);
 	if (err < 0) {
 		kfree(umem);
 		return ERR_PTR(err);
@@ -251,7 +251,7 @@ struct xdp_umem *xdp_umem_create(struct xdp_umem_reg *mr)
 
 	err = xdp_umem_reg(umem, mr);
 	if (err) {
-		ida_simple_remove(&umem_ida, umem->id);
+		ida_free(&umem_ida, umem->id);
 		kfree(umem);
 		return ERR_PTR(err);
 	}
-- 
2.25.1

