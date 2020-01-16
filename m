Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5136E13F50E
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389295AbgAPRII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:08:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:41168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389282AbgAPRIG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE60A21D56;
        Thu, 16 Jan 2020 17:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194485;
        bh=o/vLIVwfHkBmhxUHbHkIUMuS1REF90EwAkADCq6Uy+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTOL3K605iBmV59ksAYhtuH1h/ZB4Ud9PYh5AIi5waSIxnoN4/aOL/nN1HT5m6mF8
         PIB9NygFhMJcr2lMIhBrXpRMAwxJe4Vb/gDdWoDE+FJxH86drn8P8uLhSgdSWsMCH6
         6RxZVjhQcnXU97XEf070ce3s6jm0yG3LHVNxSQW8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 386/671] net: hns3: fix a memory leak issue for hclge_map_unmap_ring_to_vf_vector
Date:   Thu, 16 Jan 2020 12:00:24 -0500
Message-Id: <20200116170509.12787-123-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit 49f971bd308571fe466687227130a7082b662d0e ]

When hclge_bind_ring_with_vector() fails,
hclge_map_unmap_ring_to_vf_vector() returns the error
directly, so nobody will free the memory allocated by
hclge_get_ring_chain_from_mbx().

So hclge_free_vector_ring_chain() should be called no matter
hclge_bind_ring_with_vector() fails or not.

Fixes: 84e095d64ed9 ("net: hns3: Change PF to add ring-vect binding & resetQ to mailbox")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index e08e82020402..997ca79ed892 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -181,12 +181,10 @@ static int hclge_map_unmap_ring_to_vf_vector(struct hclge_vport *vport, bool en,
 		return ret;
 
 	ret = hclge_bind_ring_with_vector(vport, vector_id, en, &ring_chain);
-	if (ret)
-		return ret;
 
 	hclge_free_vector_ring_chain(&ring_chain);
 
-	return 0;
+	return ret;
 }
 
 static int hclge_set_vf_promisc_mode(struct hclge_vport *vport,
-- 
2.20.1

