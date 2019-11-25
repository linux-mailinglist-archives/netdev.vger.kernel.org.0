Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48EB0108E20
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 13:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfKYMnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 07:43:51 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44254 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbfKYMnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 07:43:51 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0B714EF4C4A529C8E644;
        Mon, 25 Nov 2019 20:43:44 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 25 Nov 2019 20:43:36 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Mao Wenan <maowenan@huawei.com>
Subject: [PATCH net v3] net: dsa: ocelot: add dependency for NET_DSA_MSCC_FELIX
Date:   Mon, 25 Nov 2019 20:41:10 +0800
Message-ID: <20191125124110.145595-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <3e9d6100-6965-da85-c310-6e1a9318f61d@huawei.com>
References: <3e9d6100-6965-da85-c310-6e1a9318f61d@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_NET_DSA_MSCC_FELIX=y, and CONFIG_NET_VENDOR_MICROSEMI=n,
below errors can be found:
drivers/net/dsa/ocelot/felix.o: In function `felix_vlan_del':
felix.c:(.text+0x26e): undefined reference to `ocelot_vlan_del'
drivers/net/dsa/ocelot/felix.o: In function `felix_vlan_add':
felix.c:(.text+0x352): undefined reference to `ocelot_vlan_add'

and warning as below:
WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] &&
NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
Selected by [y]:
NET_DSA_MSCC_FELIX [=y] && NETDEVICES [=y] && HAVE_NET_DSA [=y]
&& NET_DSA [=y] && PCI [=y]

This patch is to select NET_VENDOR_MICROSEMI and add dependency
NET_SWITCHDEV, HAS_IOMEM for NET_DSA_MSCC_FELIX.

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 v3: add depends on NET_SWITCHDEV and HAS_IOMEM.
 v2: modify 'depends on' to 'select'.
 drivers/net/dsa/ocelot/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 0031ca814346..1ec2dfbd76ce 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -2,6 +2,9 @@
 config NET_DSA_MSCC_FELIX
 	tristate "Ocelot / Felix Ethernet switch support"
 	depends on NET_DSA && PCI
+	depends on NET_SWITCHDEV
+	depends on HAS_IOMEM
+	select NET_VENDOR_MICROSEMI
 	select MSCC_OCELOT_SWITCH
 	select NET_DSA_TAG_OCELOT
 	help
-- 
2.20.1

