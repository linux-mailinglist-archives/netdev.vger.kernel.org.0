Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A305346724D
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 07:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378727AbhLCHBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 02:01:05 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:32874 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345605AbhLCHBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 02:01:05 -0500
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J53Y74W81zcbgT;
        Fri,  3 Dec 2021 14:57:31 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 14:57:40 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Fri, 3 Dec
 2021 14:57:39 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <tchornyi@marvell.com>, <vmytnyk@marvell.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH -next] net: prestera: acl: fix return value check in prestera_acl_rule_entry_find()
Date:   Fri, 3 Dec 2021 15:04:18 +0800
Message-ID: <20211203070418.465144-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rhashtable_lookup_fast() returns NULL pointer not ERR_PTR().
Return rhashtable_lookup_fast() directly to fix this.

Fixes: 47327e198d42 ("net: prestera: acl: migrate to new vTCAM api")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_acl.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index da0b6525ef9a..fc7f2fedafd7 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -419,11 +419,8 @@ struct prestera_acl_rule_entry *
 prestera_acl_rule_entry_find(struct prestera_acl *acl,
 			     struct prestera_acl_rule_entry_key *key)
 {
-	struct prestera_acl_rule_entry *e;
-
-	e = rhashtable_lookup_fast(&acl->acl_rule_entry_ht, key,
-				   __prestera_acl_rule_entry_ht_params);
-	return IS_ERR(e) ? NULL : e;
+	return rhashtable_lookup_fast(&acl->acl_rule_entry_ht, key,
+				      __prestera_acl_rule_entry_ht_params);
 }
 
 static int __prestera_acl_rule_entry2hw_del(struct prestera_switch *sw,
-- 
2.25.1

