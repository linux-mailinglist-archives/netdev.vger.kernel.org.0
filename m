Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C19D387965
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 14:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbhERNAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 09:00:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4733 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbhERNAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 09:00:41 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FkwwT1tXmzqV5k;
        Tue, 18 May 2021 20:55:53 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 20:59:21 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 18 May
 2021 20:59:21 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <rajur@chelsio.com>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH -next] cxgb4: clip_tbl: use list_del_init instead of list_del/INIT_LIST_HEAD
Date:   Tue, 18 May 2021 21:01:35 +0800
Message-ID: <20210518130135.1303312-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using list_del_init() instead of list_del() + INIT_LIST_HEAD()
to simpify the code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
index 12fcf84d67ad..163efab27e9b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
@@ -106,8 +106,7 @@ int cxgb4_clip_get(const struct net_device *dev, const u32 *lip, u8 v6)
 	if (!list_empty(&ctbl->ce_free_head)) {
 		ce = list_first_entry(&ctbl->ce_free_head,
 				      struct clip_entry, list);
-		list_del(&ce->list);
-		INIT_LIST_HEAD(&ce->list);
+		list_del_init(&ce->list);
 		spin_lock_init(&ce->lock);
 		refcount_set(&ce->refcnt, 0);
 		atomic_dec(&ctbl->nfree);
@@ -179,8 +178,7 @@ void cxgb4_clip_release(const struct net_device *dev, const u32 *lip, u8 v6)
 	write_lock_bh(&ctbl->lock);
 	spin_lock_bh(&ce->lock);
 	if (refcount_dec_and_test(&ce->refcnt)) {
-		list_del(&ce->list);
-		INIT_LIST_HEAD(&ce->list);
+		list_del_init(&ce->list);
 		list_add_tail(&ce->list, &ctbl->ce_free_head);
 		atomic_inc(&ctbl->nfree);
 		if (v6)
-- 
2.25.1

