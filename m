Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FFE268BFF
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 15:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgINNQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 09:16:39 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12278 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726389AbgINNQL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 09:16:11 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D2D7447EFABE6A21593C;
        Mon, 14 Sep 2020 21:15:28 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 14 Sep 2020 21:15:27 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <fugang.duan@nxp.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: fec: ptp: remove unused variable 'ns' in fec_time_keep()
Date:   Mon, 14 Sep 2020 21:14:24 +0800
Message-ID: <1600089264-21910-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

drivers/net/ethernet/freescale/fec_ptp.c:523:6: warning:
 variable 'ns' set but not used [-Wunused-but-set-variable]
  523 |  u64 ns;
      |      ^~

After commit 6605b730c061 ("FEC: Add time stamping code and a PTP
hardware clock"), variable 'ns' is never used in fec_time_keep(),
so removing it to avoid build warning.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index a0c1f44..0405a39 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -520,13 +520,12 @@ static void fec_time_keep(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct fec_enet_private *fep = container_of(dwork, struct fec_enet_private, time_keep);
-	u64 ns;
 	unsigned long flags;
 
 	mutex_lock(&fep->ptp_clk_mutex);
 	if (fep->ptp_clk_on) {
 		spin_lock_irqsave(&fep->tmreg_lock, flags);
-		ns = timecounter_read(&fep->tc);
+		timecounter_read(&fep->tc);
 		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 	}
 	mutex_unlock(&fep->ptp_clk_mutex);
-- 
2.9.5

