Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6B21382E
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 10:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfEDIDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 04:03:51 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7719 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726258AbfEDIDv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 04:03:51 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 344A468EBF5E222164BB;
        Sat,  4 May 2019 16:03:47 +0800 (CST)
Received: from [127.0.0.1] (10.184.189.20) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Sat, 4 May 2019
 16:03:40 +0800
From:   linmiaohe <linmiaohe@huawei.com>
Subject: [PATCH] net: route: Fix vrf dst_entry ref count false increasing
To:     <davem@davemloft.net>, <christian@brauner.io>,
        <roopa@cumulusnetworks.com>, <dsahern@gmail.com>,
        <Jason@zx2c4.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     mousuanming <mousuanming@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>
Message-ID: <76551ed7-47ef-7442-69de-6fb42fff4708@huawei.com>
Date:   Sat, 4 May 2019 16:03:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.189.20]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Suanming.Mou <mousuanming@huawei.com>

When config ip in default vrf same as the ip in specified
vrf, fib_lookup will return the route from table local
even if the in device is an enslaved l3mdev. Then the
dst_entry will hold the vrf device rather than loopback
device in local_input of function ip_route_input_slow.
So vrf dst_entry is false increased by route from table
local.

Here is reproduce step:
1.enslave enp4s0 to vrf2, and config ip address:
ip link add vrf2 type vrf table 1
ip link set vrf2 up
ip link set enp4s0 master vrf2
ip addr ad 125.1.1.1/16 dev enp4s0

2.config same ip in default vrf:
ip addr ad 125.1.1.1/16 dev enp6s0

3.config peer and ping:
ip vrf exec vrf2 ping 125.1.1.2 -c 3

4.del vrf2 link:
ip link del vrf2

And "unregister_netdevice: waiting for vrf2 to become free.
Usage count = 1" will occur.

Signed-off-by: Suanming.Mou <mousuanming@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/core/fib_rules.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index ffbb827723a2..1a2c11ed1585 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -263,6 +263,11 @@ static int fib_rule_match(struct fib_rule *rule, struct fib_rules_ops *ops,
 	if (rule->tun_id && (rule->tun_id != fl->flowi_tun_key.tun_id))
 		goto out;

+	if (!rule->l3mdev &&
+	    (netif_index_is_l3_master(rule->fr_net, fl->flowi_iif) ||
+	     netif_index_is_l3_master(rule->fr_net, fl->flowi_oif)))
+		goto out;
+
 	if (rule->l3mdev && !l3mdev_fib_rule_match(rule->fr_net, fl, arg))
 		goto out;

-- 
2.21.GIT


