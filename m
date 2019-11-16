Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF95BFEDAE
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbfKPPqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:46:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729271AbfKPPqC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:02 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B63EE207FA;
        Sat, 16 Nov 2019 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919162;
        bh=2Luct6aeUchWiuAqbQk8IOpLZN3/QWd0Ogx29N2hSO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LlUBYgEeOXCtKO5CzykNtpRewz3OGoFKeNqp84A/2hRKeI2rbbe4oygBOzo1F8sqZ
         bJfisXzb3GZ4apRM/UrRScQR8Z+JthNhWFuN70UtDU/jgBnEJUBWgkYkdMspVE3Bqy
         sfNFf/HULlvXk3YQSVY+S2Q2KR3M2ckdojKfbZqM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 170/237] net: hns3: bugfix for is_valid_csq_clean_head()
Date:   Sat, 16 Nov 2019 10:40:05 -0500
Message-Id: <20191116154113.7417-170-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit 6d71ec6cbf74ac9c2823ef751b1baa5b889bb3ac ]

The HEAD pointer of the hardware command queue maybe equal to the command
queue's next_to_use in the driver, so that does not belong to the invalid
HEAD pointer, since the hardware may not process the command in time,
causing the HEAD pointer to be too late to update. The variables' name
in this function is unreadable, so give them a more readable one.

Fixes: 3ff504908f95 ("net: hns3: fix a dead loop in hclge_cmd_csq_clean")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c   | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 68026a5ad7e77..690f62ed87dca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -24,15 +24,15 @@ static int hclge_ring_space(struct hclge_cmq_ring *ring)
 	return ring->desc_num - used - 1;
 }
 
-static int is_valid_csq_clean_head(struct hclge_cmq_ring *ring, int h)
+static int is_valid_csq_clean_head(struct hclge_cmq_ring *ring, int head)
 {
-	int u = ring->next_to_use;
-	int c = ring->next_to_clean;
+	int ntu = ring->next_to_use;
+	int ntc = ring->next_to_clean;
 
-	if (unlikely(h >= ring->desc_num))
-		return 0;
+	if (ntu > ntc)
+		return head >= ntc && head <= ntu;
 
-	return u > c ? (h > c && h <= u) : (h > c || h <= u);
+	return head >= ntc || head <= ntu;
 }
 
 static int hclge_alloc_cmd_desc(struct hclge_cmq_ring *ring)
-- 
2.20.1

