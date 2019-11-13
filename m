Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A26DAFA456
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbfKMB4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:56:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728400AbfKMB4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:56:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38FF92245C;
        Wed, 13 Nov 2019 01:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610191;
        bh=LAacLFUZ6peFqOHVPLbtujVYQS0liVSdAa/0Z18JY+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8jgC5Gmqpr7vT3GHqaOlB+SIPzKq1yHuZ/86J8PAZMe/8OwTGRn7xFiE4XrdNG77
         sK1oqEW482st85/6YHCxqQbbTn9BjHNczi7ILrmyndGKH54IUPvxxzE/OU0kUntzc7
         2X/5vbYERpVuW1CEUczIt6CguVevur85euc3XPuA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 005/115] net: hns3: Fix for netdev not up problem when setting mtu
Date:   Tue, 12 Nov 2019 20:54:32 -0500
Message-Id: <20191113015622.11592-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 93d8daf460183871a965dae339839d9e35d44309 ]

Currently hns3_nic_change_mtu will try to down the netdev before
setting mtu, and it does not up the netdev when the setting fails,
which causes netdev not up problem.

This patch fixes it by not returning when the setting fails.

Fixes: a8e8b7ff3517 ("net: hns3: Add support to change MTU in HNS3 hardware")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.c
index 69726908e72c4..5483cb23c08a3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.c
@@ -1307,13 +1307,11 @@ static int hns3_nic_change_mtu(struct net_device *netdev, int new_mtu)
 	}
 
 	ret = h->ae_algo->ops->set_mtu(h, new_mtu);
-	if (ret) {
+	if (ret)
 		netdev_err(netdev, "failed to change MTU in hardware %d\n",
 			   ret);
-		return ret;
-	}
-
-	netdev->mtu = new_mtu;
+	else
+		netdev->mtu = new_mtu;
 
 	/* if the netdev was running earlier, bring it up again */
 	if (if_running && hns3_nic_net_open(netdev))
-- 
2.20.1

