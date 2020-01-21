Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8574114397C
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 10:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgAUJaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 04:30:02 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10121 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727220AbgAUJaB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 04:30:01 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 77E63953C003BFDE2BD5;
        Tue, 21 Jan 2020 17:29:59 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 21 Jan 2020 17:29:48 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <davem@davemloft.net>, <mhabets@solarflare.com>, <kuba@kernel.org>,
        <sergei.shtylyov@cogentembedded.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH -next v2] drivers: net: declance: fix comparing pointer to 0
Date:   Tue, 21 Jan 2020 17:24:55 +0800
Message-ID: <20200121092455.82983-1-chenzhou10@huawei.com>
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

Replace "skb == 0" with "!skb".

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

