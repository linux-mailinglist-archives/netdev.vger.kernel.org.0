Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5978A18CE3
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 17:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfEIPXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 11:23:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:46436 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726187AbfEIPXY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 11:23:24 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B6E4FAADCA029062E2BF;
        Thu,  9 May 2019 23:23:22 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Thu, 9 May 2019 23:23:14 +0800
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
To:     Yana Esina <yana.esina@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] net: aquantia: fix undefined devm_hwmon_device_register_with_info reference
Date:   Thu, 9 May 2019 23:32:35 +0800
Message-ID: <20190509153235.103441-1-wangkefeng.wang@huawei.com>
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

drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.o: In function `aq_drvinfo_init':
aq_drvinfo.c:(.text+0xe8): undefined reference to `devm_hwmon_device_register_with_info'

Fix it by using #if IS_REACHABLE(CONFIG_HWMON).

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.c b/drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.c
index f5a92b2a5cd6..adad6a7acabe 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.c
@@ -13,6 +13,7 @@
 
 #include "aq_drvinfo.h"
 
+#if IS_REACHABLE(CONFIG_HWMON)
 static int aq_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 			 u32 attr, int channel, long *value)
 {
@@ -123,3 +124,7 @@ int aq_drvinfo_init(struct net_device *ndev)
 
 	return err;
 }
+
+#else
+int aq_drvinfo_init(struct net_device *ndev) { return 0; }
+#endif
-- 
2.20.1

