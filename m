Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB4F4A1B4
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbfFRNIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:08:04 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18598 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726518AbfFRNID (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:08:03 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 63AF06C0EBECB7308612;
        Tue, 18 Jun 2019 21:07:58 +0800 (CST)
Received: from huawei.com (10.175.100.202) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 18 Jun 2019
 21:07:51 +0800
From:   luoshijie <luoshijie1@huawei.com>
To:     <davem@davemloft.net>, <tgraf@suug.ch>, <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <liuzhiqiang26@huawei.com>,
        <wangxiaogang3@huawei.com>, <mingfangsen@huawei.com>,
        <zhoukang7@huawei.com>
Subject: [PATCH v2 1/3] ipv4: fix inet_select_addr() when enable route_localnet
Date:   Tue, 18 Jun 2019 15:14:03 +0000
Message-ID: <1560870845-172395-2-git-send-email-luoshijie1@huawei.com>
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

Suppose we have two interfaces eth0 and eth1 in two hosts, follow
the same steps in the two hosts:
 # sysctl -w net.ipv4.conf.eth1.route_localnet=1
 # sysctl -w net.ipv4.conf.eth1.arp_announce=2
 # ip route del 127.0.0.0/8 dev lo table local
and then set ip to eth1 in host1 like:
 # ifconfig eth1 127.25.3.4/24
set ip to eth2 in host2 and ping host1:
 # ifconfig eth1 127.25.3.14/24
 # ping -I eth1 127.25.3.4
Well, host2 cannot connect to host1.

When set a ip address with head 127, the scope of the address defaults
to RT_SCOPE_HOST. In this situation, host2 will use arp_solicit() to
send a arp request for the mac address of host1 with ip
address 127.25.3.14. When arp_announce=2, inet_select_addr() cannot
select a correct saddr with condition ifa->ifa_scope > scope, because
ifa_scope is RT_SCOPE_HOST and scope is RT_SCOPE_LINK. Then,
inet_select_addr() will go to no_in_dev to lookup all interfaces to find
a primary ip and finally get the primary ip of eth0.

Here I add a localnet_scope defaults to RT_SCOPE_HOST, and when
route_localnet is enabled, this value changes to RT_SCOPE_LINK to make
inet_select_addr() find a correct primary ip as saddr of arp request.

Fixes: d0daebc3d622 ("ipv4: Add interface option to enable routing of 127.0.0.0/8")

Signed-off-by: Shijie Luo <luoshijie1@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 net/ipv4/devinet.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index c6bd0f7a020a..08c6c7c41749 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1254,6 +1254,7 @@ static __be32 in_dev_select_addr(const struct in_device *in_dev,
 __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope)
 {
 	__be32 addr = 0;
+	unsigned char localnet_scope = RT_SCOPE_HOST;
 	struct in_device *in_dev;
 	struct net *net = dev_net(dev);
 	int master_idx;
@@ -1263,8 +1264,11 @@ __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope)
 	if (!in_dev)
 		goto no_in_dev;
 
+	if (unlikely(IN_DEV_ROUTE_LOCALNET(in_dev)))
+		localnet_scope = RT_SCOPE_LINK;
+
 	for_primary_ifa(in_dev) {
-		if (ifa->ifa_scope > scope)
+		if (min(ifa->ifa_scope, localnet_scope) > scope)
 			continue;
 		if (!dst || inet_ifa_match(dst, ifa)) {
 			addr = ifa->ifa_local;
-- 
2.19.1

