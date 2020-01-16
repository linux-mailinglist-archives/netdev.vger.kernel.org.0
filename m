Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0AE613E296
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730718AbgAPQ5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:57:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729252AbgAPQ5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 347742467C;
        Thu, 16 Jan 2020 16:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193821;
        bh=PfQMiGR9EeuM30iGR1FkAL4KQGxNESmN0FOpdtWAy3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtFiP3fDKs7RehezhbXWXGaJiv6EOTgxtzc/jj13Hkyer054qZiG3X8LW7GBF0J/0
         ACbIgHf/m7VP3erwMwSngCp1kDkZ1tjTKH/rvmi4jGAvjK+VHF81ya2LSjJVC/fKX4
         dzmnx5kfjXvhvqyZdjbwBi2yN2fhFdyLOhRfIiNg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 080/671] net: hns3: fix error handling int the hns3_get_vector_ring_chain
Date:   Thu, 16 Jan 2020 11:45:11 -0500
Message-Id: <20200116165502.8838-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit cda69d244585bc4497d3bb878c22fe2b6ad647c1 ]

When hns3_get_vector_ring_chain() failed in the
hns3_nic_init_vector_data(), it should do the error handling instead
of return directly.

Also, cur_chain should be freed instead of chain and head->next should
be set to NULL in error handling of hns3_get_vector_ring_chain.

This patch fixes them.

Fixes: 73b907a083b8 ("net: hns3: bugfix for buffer not free problem during resetting")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 9df807ec8c84..10fa7f5df57e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2605,9 +2605,10 @@ static int hns3_get_vector_ring_chain(struct hns3_enet_tqp_vector *tqp_vector,
 	cur_chain = head->next;
 	while (cur_chain) {
 		chain = cur_chain->next;
-		devm_kfree(&pdev->dev, chain);
+		devm_kfree(&pdev->dev, cur_chain);
 		cur_chain = chain;
 	}
+	head->next = NULL;
 
 	return -ENOMEM;
 }
@@ -2679,7 +2680,7 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 		ret = hns3_get_vector_ring_chain(tqp_vector,
 						 &vector_ring_chain);
 		if (ret)
-			return ret;
+			goto map_ring_fail;
 
 		ret = h->ae_algo->ops->map_ring_to_vector(h,
 			tqp_vector->vector_irq, &vector_ring_chain);
-- 
2.20.1

