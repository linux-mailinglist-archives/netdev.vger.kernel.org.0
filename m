Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543B92CEA21
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 09:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgLDIr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 03:47:28 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8647 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgLDIr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 03:47:28 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CnRBf0f0tz15WBV;
        Fri,  4 Dec 2020 16:46:18 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 4 Dec 2020 16:46:39 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        "Magnus Karlsson" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] xsk: Fix error return code in __xp_assign_dev()
Date:   Fri, 4 Dec 2020 16:50:19 +0800
Message-ID: <1607071819-34127-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 921b68692abb ("xsk: Enable sharing of dma mappings")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 net/xdp/xsk_buff_pool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 9287edd..d5adeee 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -175,6 +175,7 @@ static int __xp_assign_dev(struct xsk_buff_pool *pool,
 
 	if (!pool->dma_pages) {
 		WARN(1, "Driver did not DMA map zero-copy buffers");
+		err = -EINVAL;
 		goto err_unreg_xsk;
 	}
 	pool->umem->zc = true;
-- 
2.9.5

