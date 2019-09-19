Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C924DB731E
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 08:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387832AbfISGVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 02:21:24 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2681 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728230AbfISGVY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 02:21:24 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0E1C4D25D45C7A3AE125;
        Thu, 19 Sep 2019 14:21:22 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 19 Sep 2019 14:21:13 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Mao Wenan <maowenan@huawei.com>
Subject: [PATCH net] net: dsa: sja1105: Add dependency for NET_DSA_SJA1105_TAS
Date:   Thu, 19 Sep 2019 14:38:19 +0800
Message-ID: <20190919063819.164826-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_NET_DSA_SJA1105_TAS=y and CONFIG_NET_SCH_TAPRIO=n,
below error can be found:
drivers/net/dsa/sja1105/sja1105_tas.o: In function `sja1105_setup_tc_taprio':
sja1105_tas.c:(.text+0x318): undefined reference to `taprio_offload_free'
sja1105_tas.c:(.text+0x590): undefined reference to `taprio_offload_get'
drivers/net/dsa/sja1105/sja1105_tas.o: In function `sja1105_tas_teardown':
sja1105_tas.c:(.text+0x610): undefined reference to `taprio_offload_free'
make: *** [vmlinux] Error 1

sja1105_tas needs tc-taprio, so this patch add the dependency for it.

Fixes: 317ab5b86c8e ("net: dsa: sja1105: Configure the Time-Aware Scheduler via tc-taprio offload")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/dsa/sja1105/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 55424f3..f40b248 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -27,6 +27,7 @@ config NET_DSA_SJA1105_PTP
 config NET_DSA_SJA1105_TAS
 	bool "Support for the Time-Aware Scheduler on NXP SJA1105"
 	depends on NET_DSA_SJA1105
+	depends on NET_SCH_TAPRIO
 	help
 	  This enables support for the TTEthernet-based egress scheduling
 	  engine in the SJA1105 DSA driver, which is controlled using a
-- 
2.7.4

