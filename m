Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B3BE57FD
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 04:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfJZCIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 22:08:13 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5191 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725954AbfJZCIN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 22:08:13 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5CE66EA7BB546D1EB6EE;
        Sat, 26 Oct 2019 10:08:04 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Sat, 26 Oct 2019 10:07:57 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <epomozov@marvell.com>, <igor.russkikh@aquantia.com>,
        <davem@davemloft.net>, <pavel.belous@aquantia.com>,
        <dmitry.bezrukov@aquantia.com>, <dmitry.bogdanov@aquantia.com>,
        <ndanilov@aquantia.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Mao Wenan <maowenan@huawei.com>
Subject: [PATCH -next] net: aquantia: make two symbols be static
Date:   Sat, 26 Oct 2019 10:07:38 +0800
Message-ID: <20191026020738.130606-1-maowenan@huawei.com>
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

When using ARCH=mips CROSS_COMPILE=mips-linux-gnu-
to build drivers/net/ethernet/aquantia/atlantic/aq_ptp.o
and drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.o,
below errors can be seen:
drivers/net/ethernet/aquantia/atlantic/aq_ptp.c:1378:6:
warning: symbol 'aq_ptp_poll_sync_work_cb' was not declared.
Should it be static?

drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c:1155:5:
warning: symbol 'hw_atl_b0_ts_to_sys_clock' was not declared.
Should it be static?

This patch to make aq_ptp_poll_sync_work_cb and hw_atl_b0_ts_to_sys_clock
be static to fix these warnings.

Fixes: 9c477032f7d0 ("net: aquantia: add support for PIN funcs")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c           | 2 +-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index 3ec0841..d92d119 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -1375,7 +1375,7 @@ static int aq_ptp_check_sync1588(struct aq_ptp_s *aq_ptp)
 	return 0;
 }
 
-void aq_ptp_poll_sync_work_cb(struct work_struct *w)
+static void aq_ptp_poll_sync_work_cb(struct work_struct *w)
 {
 	struct delayed_work *dw = to_delayed_work(w);
 	struct aq_ptp_s *aq_ptp = container_of(dw, struct aq_ptp_s, poll_sync);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 51ecf87..8f866c7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1152,7 +1152,7 @@ static int hw_atl_b0_set_sys_clock(struct aq_hw_s *self, u64 time, u64 ts)
 	return hw_atl_b0_adj_sys_clock(self, delta);
 }
 
-int hw_atl_b0_ts_to_sys_clock(struct aq_hw_s *self, u64 ts, u64 *time)
+static int hw_atl_b0_ts_to_sys_clock(struct aq_hw_s *self, u64 ts, u64 *time)
 {
 	*time = self->ptp_clk_offset + ts;
 	return 0;
-- 
2.7.4

