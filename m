Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7ACB39F9F2
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhFHPJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:09:21 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:33197 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233716AbhFHPJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:09:19 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jun 2021 11:09:19 EDT
Received: from bretzel (unknown [10.16.0.57])
        by proxy.6wind.com (Postfix) with ESMTPS id C6E939F39AB;
        Tue,  8 Jun 2021 16:59:59 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1lqdCx-0006Wa-Ok; Tue, 08 Jun 2021 16:59:59 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH net] vrf: fix maximum MTU
Date:   Tue,  8 Jun 2021 16:59:51 +0200
Message-Id: <20210608145951.24985-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My initial goal was to fix the default MTU, which is set to 65536, ie above
the maximum defined in the driver: 65535 (ETH_MAX_MTU).

In fact, it's seems more consistent, wrt min_mtu, to set the max_mtu to
IP6_MAX_MTU (65535 + sizeof(struct ipv6hdr)) and use it by default.

Let's also, for consistency, set the mtu in vrf_setup(). This function
calls ether_setup(), which set the mtu to 1500. Thus, the whole mtu config
is done in the same function.

Before the patch:
$ ip link add blue type vrf table 1234
$ ip link list blue
9: blue: <NOARP,MASTER> mtu 65536 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether fa:f5:27:70:24:2a brd ff:ff:ff:ff:ff:ff
$ ip link set dev blue mtu 65535
$ ip link set dev blue mtu 65536
Error: mtu greater than device maximum.

Fixes: 5055376a3b44 ("net: vrf: Fix ping failed when vrf mtu is set to 0")
CC: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 drivers/net/vrf.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 503e2fd7ce51..28a6c4cfe9b8 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1183,9 +1183,6 @@ static int vrf_dev_init(struct net_device *dev)
 
 	dev->flags = IFF_MASTER | IFF_NOARP;
 
-	/* MTU is irrelevant for VRF device; set to 64k similar to lo */
-	dev->mtu = 64 * 1024;
-
 	/* similarly, oper state is irrelevant; set to up to avoid confusion */
 	dev->operstate = IF_OPER_UP;
 	netdev_lockdep_set_classes(dev);
@@ -1685,7 +1682,8 @@ static void vrf_setup(struct net_device *dev)
 	 * which breaks networking.
 	 */
 	dev->min_mtu = IPV6_MIN_MTU;
-	dev->max_mtu = ETH_MAX_MTU;
+	dev->max_mtu = IP6_MAX_MTU;
+	dev->mtu = dev->max_mtu;
 }
 
 static int vrf_validate(struct nlattr *tb[], struct nlattr *data[],
-- 
2.30.0

