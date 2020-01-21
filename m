Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE3F14354A
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 02:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgAUBk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 20:40:57 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:37266 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726935AbgAUBk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 20:40:57 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4E2F0CAE3A7004B61A4B;
        Tue, 21 Jan 2020 09:40:54 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Tue, 21 Jan 2020 09:40:43 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <davem@davemloft.net>, <mhabets@solarflare.com>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH -next] drivers: net: declance: fix comparing pointer to 0
Date:   Tue, 21 Jan 2020 09:35:53 +0800
Message-ID: <20200121013553.15252-1-chenzhou10@huawei.com>
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

Fixes coccicheck warning:

./drivers/net/ethernet/amd/declance.c:611:14-15:
	WARNING comparing pointer to 0

Compare pointer-typed values to NULL rather than 0.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/net/ethernet/amd/declance.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/declance.c b/drivers/net/ethernet/amd/declance.c
index 6592a2d..7282ce5 100644
--- a/drivers/net/ethernet/amd/declance.c
+++ b/drivers/net/ethernet/amd/declance.c
@@ -608,7 +608,7 @@ static int lance_rx(struct net_device *dev)
 			len = (*rds_ptr(rd, mblength, lp->type) & 0xfff) - 4;
 			skb = netdev_alloc_skb(dev, len + 2);
 
-			if (skb == 0) {
+			if (!skb) {
 				dev->stats.rx_dropped++;
 				*rds_ptr(rd, mblength, lp->type) = 0;
 				*rds_ptr(rd, rmd1, lp->type) =
-- 
2.7.4

