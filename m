Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54C0B119688
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbfLJVZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:25:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728550AbfLJVKg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CF8B246AF;
        Tue, 10 Dec 2019 21:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012236;
        bh=YFrr2dKsgw/OYEzSazEqSFas0GE8kgpRCA6uXMVqqnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQTKPlONZwEZRZGH85z9VjcFewZepXFGI9ZUchYohl4z0U1Un81mjvcTxRfVXTkki
         nx8+Fuvx0XVVSVHE0KrLHqwNiejCVumYikc7LnPX2Zx9c+gkl9dnRcyoKzbil8jCUu
         yh6835wo9dIA5pV59suLpiSrry8uyDk7f4QPaUdk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 185/350] net: hns3: add struct netdev_queue debug info for TX timeout
Date:   Tue, 10 Dec 2019 16:04:50 -0500
Message-Id: <20191210210735.9077-146-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 647522a5ef6401dcdb8ec417421e43fb21910167 ]

When there is a TX timeout, we can tell if the driver or stack
has stopped the queue by looking at state field, and when has
the last packet transmited by looking at trans_start field.

So this patch prints these two field in the
hns3_get_tx_timeo_queue_info().

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 616cad0faa211..84d8816c8681b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1692,6 +1692,9 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 		    time_after(jiffies,
 			       (trans_start + ndev->watchdog_timeo))) {
 			timeout_queue = i;
+			netdev_info(ndev, "queue state: 0x%lx, delta msecs: %u\n",
+				    q->state,
+				    jiffies_to_msecs(jiffies - trans_start));
 			break;
 		}
 	}
-- 
2.20.1

