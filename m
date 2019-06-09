Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE2FC3A416
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 09:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfFIHDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 03:03:54 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18116 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725850AbfFIHDy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jun 2019 03:03:54 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0B0368A77C38820DB5B9;
        Sun,  9 Jun 2019 15:03:47 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Sun, 9 Jun 2019 15:03:40 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <davem@davemloft.net>
CC:     <alexandre.belloni@bootlin.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH -next] ocelot: remove unused variable 'rc' in vcap_cmd()
Date:   Sun, 9 Jun 2019 15:11:26 +0800
Message-ID: <20190609071126.183505-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/mscc/ocelot_ace.c: In function ‘vcap_cmd’:
drivers/net/ethernet/mscc/ocelot_ace.c:108:6: warning: variable ‘rc’ set
but not used [-Wunused-but-set-variable]
  int rc;
      ^
It's never used since introduction in commit b596229448dd ("net: mscc:
ocelot: Add support for tcam")

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/ethernet/mscc/ocelot_ace.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index f74b98f7d8d1..39aca1ab4687 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -105,7 +105,6 @@ static void vcap_cmd(struct ocelot *oc, u16 ix, int cmd, int sel)
 	u32 value = (S2_CORE_UPDATE_CTRL_UPDATE_CMD(cmd) |
 		     S2_CORE_UPDATE_CTRL_UPDATE_ADDR(ix) |
 		     S2_CORE_UPDATE_CTRL_UPDATE_SHOT);
-	int rc;
 
 	if ((sel & VCAP_SEL_ENTRY) && ix >= vcap_is2.entry_count)
 		return;
@@ -120,7 +119,7 @@ static void vcap_cmd(struct ocelot *oc, u16 ix, int cmd, int sel)
 		value |= S2_CORE_UPDATE_CTRL_UPDATE_CNT_DIS;
 
 	ocelot_write(oc, value, S2_CORE_UPDATE_CTRL);
-	rc = readx_poll_timeout(vcap_s2_read_update_ctrl, oc, value,
+	readx_poll_timeout(vcap_s2_read_update_ctrl, oc, value,
 				(value & S2_CORE_UPDATE_CTRL_UPDATE_SHOT) == 0,
 				10, 100000);
 }
-- 
2.20.1

