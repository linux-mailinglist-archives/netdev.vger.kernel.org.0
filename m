Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9415D4A1B1
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbfFRNID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:08:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18597 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728884AbfFRNIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:08:02 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5F5092CAC3F956482789;
        Tue, 18 Jun 2019 21:07:58 +0800 (CST)
Received: from huawei.com (10.175.100.202) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 18 Jun 2019
 21:07:51 +0800
From:   luoshijie <luoshijie1@huawei.com>
To:     <davem@davemloft.net>, <tgraf@suug.ch>, <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <liuzhiqiang26@huawei.com>,
        <wangxiaogang3@huawei.com>, <mingfangsen@huawei.com>,
        <zhoukang7@huawei.com>
Subject: [PATCH v2 2/3] ipv4: fix confirm_addr_indev() when enable route_localnet
Date:   Tue, 18 Jun 2019 15:14:04 +0000
Message-ID: <1560870845-172395-3-git-send-email-luoshijie1@huawei.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1560870845-172395-1-git-send-email-luoshijie1@huawei.com>
References: <1560870845-172395-1-git-send-email-luoshijie1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.202]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shijie Luo <luoshijie1@huawei.com>

When arp_ignore=3, the NIC won't reply for scope host addresses, but
if enable route_locanet, we need to reply ip address with head 127 and
scope RT_SCOPE_HOST.

Fixes: d0daebc3d622 ("ipv4: Add interface option to enable routing of 127.0.0.0/8")

Signed-off-by: Shijie Luo <luoshijie1@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 net/ipv4/devinet.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 08c6c7c41749..cfef8df59373 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1321,13 +1321,18 @@ EXPORT_SYMBOL(inet_select_addr);
 static __be32 confirm_addr_indev(struct in_device *in_dev, __be32 dst,
 			      __be32 local, int scope)
 {
+	unsigned char localnet_scope = RT_SCOPE_HOST;
 	int same = 0;
 	__be32 addr = 0;
 
+	if (unlikely(IN_DEV_ROUTE_LOCALNET(in_dev)))
+		localnet_scope = RT_SCOPE_LINK;
+
 	for_ifa(in_dev) {
+		unsigned char min_scope = min(ifa->ifa_scope, localnet_scope);
 		if (!addr &&
 		    (local == ifa->ifa_local || !local) &&
-		    ifa->ifa_scope <= scope) {
+		    min_scope <= scope) {
 			addr = ifa->ifa_local;
 			if (same)
 				break;
@@ -1342,7 +1347,7 @@ static __be32 confirm_addr_indev(struct in_device *in_dev, __be32 dst,
 				if (inet_ifa_match(addr, ifa))
 					break;
 				/* No, then can we use new local src? */
-				if (ifa->ifa_scope <= scope) {
+				if (min_scope <= scope) {
 					addr = ifa->ifa_local;
 					break;
 				}
-- 
2.19.1

