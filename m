Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105231C87A9
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 13:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgEGLJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 07:09:38 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3843 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725809AbgEGLJh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 07:09:37 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 77D7E37C0B2A99914725;
        Thu,  7 May 2020 19:09:33 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Thu, 7 May 2020
 19:09:26 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <davem@davemloft.net>, <yanaijie@huawei.com>,
        <netdev@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: tulip: de4x5: make PCI_signature() return void
Date:   Thu, 7 May 2020 19:08:47 +0800
Message-ID: <20200507110847.37940-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function always return 0 now, we can make it return void to
simplify the code. This fixes the following coccicheck warning:

drivers/net/ethernet/dec/tulip/de4x5.c:3908:11-17: Unneeded variable:
"status". Return "0" on line 3912

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/dec/tulip/de4x5.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index f16853c3c851..0ccd9994ad45 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -951,7 +951,7 @@ static void    reset_init_sia(struct net_device *dev, s32 sicr, s32 strr, s32 si
 static int     test_ans(struct net_device *dev, s32 irqs, s32 irq_mask, s32 msec);
 static int     test_tp(struct net_device *dev, s32 msec);
 static int     EISA_signature(char *name, struct device *device);
-static int     PCI_signature(char *name, struct de4x5_private *lp);
+static void    PCI_signature(char *name, struct de4x5_private *lp);
 static void    DevicePresent(struct net_device *dev, u_long iobase);
 static void    enet_addr_rst(u_long aprom_addr);
 static int     de4x5_bad_srom(struct de4x5_private *lp);
@@ -3902,14 +3902,14 @@ EISA_signature(char *name, struct device *device)
 /*
 ** Look for a particular board name in the PCI configuration space
 */
-static int
+static void
 PCI_signature(char *name, struct de4x5_private *lp)
 {
-    int i, status = 0, siglen = ARRAY_SIZE(de4x5_signatures);
+    int i, siglen = ARRAY_SIZE(de4x5_signatures);
 
     if (lp->chipset == DC21040) {
 	strcpy(name, "DE434/5");
-	return status;
+	return;
     } else {                           /* Search for a DEC name in the SROM */
 	int tmp = *((char *)&lp->srom + 19) * 3;
 	strncpy(name, (char *)&lp->srom + 26 + tmp, 8);
@@ -3935,8 +3935,6 @@ PCI_signature(char *name, struct de4x5_private *lp)
     } else if ((lp->chipset & ~0x00ff) == DC2114x) {
 	lp->useSROM = true;
     }
-
-    return status;
 }
 
 /*
-- 
2.21.1

