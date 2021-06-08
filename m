Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521E739F7A5
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhFHNWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 09:22:04 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3909 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbhFHNWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 09:22:02 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzrP86Wkbz6wLK;
        Tue,  8 Jun 2021 21:17:00 +0800 (CST)
Received: from huawei.com (10.175.113.133) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 8 Jun
 2021 21:20:03 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ms@dev.tdt.de>
CC:     <linux-x25@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: x25: Use list_for_each_entry() to simplify code in x25_forward.c
Date:   Tue, 8 Jun 2021 13:30:07 +0000
Message-ID: <20210608133007.69476-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert list_for_each() to list_for_each_entry() where
applicable. This simplifies the code.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/x25/x25_forward.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/x25/x25_forward.c b/net/x25/x25_forward.c
index d48ad6d29197..21b30b56e889 100644
--- a/net/x25/x25_forward.c
+++ b/net/x25/x25_forward.c
@@ -19,7 +19,6 @@ int x25_forward_call(struct x25_address *dest_addr, struct x25_neigh *from,
 {
 	struct x25_route *rt;
 	struct x25_neigh *neigh_new = NULL;
-	struct list_head *entry;
 	struct x25_forward *x25_frwd, *new_frwd;
 	struct sk_buff *skbn;
 	short same_lci = 0;
@@ -46,8 +45,7 @@ int x25_forward_call(struct x25_address *dest_addr, struct x25_neigh *from,
 	 * established LCI? It shouldn't happen, just in case..
 	 */
 	read_lock_bh(&x25_forward_list_lock);
-	list_for_each(entry, &x25_forward_list) {
-		x25_frwd = list_entry(entry, struct x25_forward, node);
+	list_for_each_entry(x25_frwd, &x25_forward_list, node) {
 		if (x25_frwd->lci == lci) {
 			pr_warn("call request for lci which is already registered!, transmitting but not registering new pair\n");
 			same_lci = 1;
@@ -92,15 +90,13 @@ int x25_forward_call(struct x25_address *dest_addr, struct x25_neigh *from,
 int x25_forward_data(int lci, struct x25_neigh *from, struct sk_buff *skb) {
 
 	struct x25_forward *frwd;
-	struct list_head *entry;
 	struct net_device *peer = NULL;
 	struct x25_neigh *nb;
 	struct sk_buff *skbn;
 	int rc = 0;
 
 	read_lock_bh(&x25_forward_list_lock);
-	list_for_each(entry, &x25_forward_list) {
-		frwd = list_entry(entry, struct x25_forward, node);
+	list_for_each_entry(frwd, &x25_forward_list, node) {
 		if (frwd->lci == lci) {
 			/* The call is established, either side can send */
 			if (from->dev == frwd->dev1) {
-- 
2.17.1

