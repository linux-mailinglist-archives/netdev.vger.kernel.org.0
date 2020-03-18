Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 759CD18A603
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgCRVFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728096AbgCRUy6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B484208CA;
        Wed, 18 Mar 2020 20:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564897;
        bh=WrLmrYraf+mK7cIgFLavPmqL/IOaaNICmzVAiwoZoPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SqBKXGfP/vG0GjRfnyuryD8MjLDTytFq3o061l9arshS1snwJjPnzt+qVSARuRFqH
         FcxTNeYoONBxlEN9iVqFw/RJjGkQkHntLQ15U5mSrDntm3W0uKcNRM76FsEl5TN6fC
         DkTN3r9JXtqIV0D3wQvpjgkCQt0M2JZdiv0dwgdI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 65/73] net: hns3: fix "tc qdisc del" failed issue
Date:   Wed, 18 Mar 2020 16:53:29 -0400
Message-Id: <20200318205337.16279-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 5eb01ddfcfb25e6ebc404a41deae946bde776731 ]

The HNS3 driver supports to configure TC numbers and TC to priority
map via "tc" tool. But when delete the rule, will fail, because
the HNS3 driver needs at least one TC, but the "tc" tool sets TC
number to zero when delete.

This patch makes sure that the TC number is at least one.

Fixes: 30d240dfa2e8 ("net: hns3: Add mqprio hardware offload support in hns3 driver")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0c8d2269bc46e..403e0f089f2af 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1596,7 +1596,7 @@ static int hns3_setup_tc(struct net_device *netdev, void *type_data)
 	netif_dbg(h, drv, netdev, "setup tc: num_tc=%u\n", tc);
 
 	return (kinfo->dcb_ops && kinfo->dcb_ops->setup_tc) ?
-		kinfo->dcb_ops->setup_tc(h, tc, prio_tc) : -EOPNOTSUPP;
+		kinfo->dcb_ops->setup_tc(h, tc ? tc : 1, prio_tc) : -EOPNOTSUPP;
 }
 
 static int hns3_nic_setup_tc(struct net_device *dev, enum tc_setup_type type,
-- 
2.20.1

