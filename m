Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9CBF66B4
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfKJDPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 22:15:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727576AbfKJClq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:41:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24F2621882;
        Sun, 10 Nov 2019 02:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353706;
        bh=SnSXXWbCh4DGjwAfNxcppyi0n+IUynSU9WgHWmixTn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGzySkuveJAksPLxd9DdP0SdcMwojqsQfj/UBZxNujerA4Zf1WiCgIq2+F/nLm8+U
         EJPZFCJOZENrn9S56c4hdeF+yRANkU9bwRHZqNZZeQ4R61bSAV7BpdC+YROwdhlrYz
         ibYHvYYZ9mKHesrisY+F0mc2nFgHk3mN6NoQ4Yt4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>, Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 047/191] net: hns3: Fix cmdq registers initialization issue for vf
Date:   Sat,  9 Nov 2019 21:37:49 -0500
Message-Id: <20191110024013.29782-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 37dc9cdbdc1bd64bd3b6ea285a9c2e811404dc82 ]

According to hardware's description, the head pointer register should
be written before the tail pointer register while initializing the vf
command queue. Otherwise, it may trigger an interrupt even though there
is no command received.

Fixes: fedd0c15d288 ("net: hns3: Add HNS3 VF IMP(Integrated Management Proc) cmd interface")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index fb471fe2c4946..d8c0cc8e04c9d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -132,8 +132,8 @@ static int hclgevf_init_cmd_queue(struct hclgevf_dev *hdev,
 		reg_val |= HCLGEVF_NIC_CMQ_ENABLE;
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_DEPTH_REG, reg_val);
 
-		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_TAIL_REG, 0);
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_HEAD_REG, 0);
+		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_TAIL_REG, 0);
 		break;
 	case HCLGEVF_TYPE_CRQ:
 		reg_val = (u32)ring->desc_dma_addr;
@@ -145,8 +145,8 @@ static int hclgevf_init_cmd_queue(struct hclgevf_dev *hdev,
 		reg_val |= HCLGEVF_NIC_CMQ_ENABLE;
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_DEPTH_REG, reg_val);
 
-		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_TAIL_REG, 0);
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_HEAD_REG, 0);
+		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_TAIL_REG, 0);
 		break;
 	}
 
-- 
2.20.1

