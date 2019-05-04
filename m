Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F702139FC
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 15:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfEDNOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 09:14:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59456 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726529AbfEDNOB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 09:14:01 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7B240A1AF4234E123CF5;
        Sat,  4 May 2019 21:13:58 +0800 (CST)
Received: from [127.0.0.1] (10.184.189.20) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sat, 4 May 2019
 21:13:47 +0800
From:   linmiaohe <linmiaohe@huawei.com>
Subject: [PATCH v2] net: route: Fix vrf dst_entry ref count false increasing
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <dsahern@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     mousuanming <mousuanming@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>
Message-ID: <1a4c0c31-e74c-5167-0668-328dd342005e@huawei.com>
Date:   Sat, 4 May 2019 21:13:44 +0800
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
local because device passed to rt_dst_alloc is in device
rather than fib result device.

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

System hang with del vrf2 ops and "unregister_netdevice:
waiting for vrf2 to become free. Usage count = 1" occur.

Reported-by: Hui Wang <wanghui104@huawei.com>
Signed-off-by: Suanming.Mou <mousuanming@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ipv4/route.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 6fdf1c195d8e..74def8710ae8 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2077,6 +2077,11 @@ out:	return err;
 			}
 			do_cache = true;
 		}
+		/* Use fib res nh_dev as local input device because enslaved
+		 * l3mdev may hit route from other rule table. Dst_entry
+		 * should hold right device.
+		 */
+		dev = FIB_RES_DEV(*res);
 	}

 	rth = rt_dst_alloc(l3mdev_master_dev_rcu(dev) ? : net->loopback_dev,
-- 
2.21.GIT


