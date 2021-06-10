Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FCE3A2BED
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 14:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhFJMvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 08:51:23 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:5327 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhFJMvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 08:51:18 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G13Zf0xrDz1BK4Z;
        Thu, 10 Jun 2021 20:44:26 +0800 (CST)
Received: from huawei.com (10.175.104.82) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 10
 Jun 2021 20:49:18 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ms@dev.tdt.de>
CC:     <linux-x25@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: x25: Use list_for_each_entry() to simplify code in x25_route.c
Date:   Thu, 10 Jun 2021 20:48:26 +0800
Message-ID: <20210610124826.3833818-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
 net/x25/x25_route.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/net/x25/x25_route.c b/net/x25/x25_route.c
index 9fbe4bb38d94..647f325ed867 100644
--- a/net/x25/x25_route.c
+++ b/net/x25/x25_route.c
@@ -27,14 +27,11 @@ static int x25_add_route(struct x25_address *address, unsigned int sigdigits,
 			 struct net_device *dev)
 {
 	struct x25_route *rt;
-	struct list_head *entry;
 	int rc = -EINVAL;
 
 	write_lock_bh(&x25_route_list_lock);
 
-	list_for_each(entry, &x25_route_list) {
-		rt = list_entry(entry, struct x25_route, node);
-
+	list_for_each_entry(rt, &x25_route_list, node) {
 		if (!memcmp(&rt->address, address, sigdigits) &&
 		    rt->sigdigits == sigdigits)
 			goto out;
@@ -78,14 +75,11 @@ static int x25_del_route(struct x25_address *address, unsigned int sigdigits,
 			 struct net_device *dev)
 {
 	struct x25_route *rt;
-	struct list_head *entry;
 	int rc = -EINVAL;
 
 	write_lock_bh(&x25_route_list_lock);
 
-	list_for_each(entry, &x25_route_list) {
-		rt = list_entry(entry, struct x25_route, node);
-
+	list_for_each_entry(rt, &x25_route_list, node) {
 		if (!memcmp(&rt->address, address, sigdigits) &&
 		    rt->sigdigits == sigdigits && rt->dev == dev) {
 			__x25_remove_route(rt);
@@ -141,13 +135,10 @@ struct net_device *x25_dev_get(char *devname)
 struct x25_route *x25_get_route(struct x25_address *addr)
 {
 	struct x25_route *rt, *use = NULL;
-	struct list_head *entry;
 
 	read_lock_bh(&x25_route_list_lock);
 
-	list_for_each(entry, &x25_route_list) {
-		rt = list_entry(entry, struct x25_route, node);
-
+	list_for_each_entry(rt, &x25_route_list, node) {
 		if (!memcmp(&rt->address, addr, rt->sigdigits)) {
 			if (!use)
 				use = rt;
-- 
2.17.1

