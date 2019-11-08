Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 369F3F4AB3
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387817AbfKHLjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:39:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387786AbfKHLjj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E479121D7B;
        Fri,  8 Nov 2019 11:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213178;
        bh=j6XVAzC0ieNUfh1cyp9AOv/YHbTteimGWOdKlSY9CQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bp89k4Iaan+iuvqUJahhB4ndOs9EXCC+Cax/YIqupnKfeausd/6f/kdQrTkgwZTsj
         Ngym/gckvafkGZRHr2ASVxib7ZTJrFJO1nuwFaRnsye2b0P/KE2h3C05JuR0yMquz0
         sjLK00zs0tavyrz/C0A3RWmUZ88ExJHwQhgYQXAM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>, Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 072/205] net: hns3: Fix error of checking used vlan id
Date:   Fri,  8 Nov 2019 06:35:39 -0500
Message-Id: <20191108113752.12502-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 54e97d117bafa161b08c6ade243a335d92890d94 ]

PF uses hdev->vlan_table to manage the port vlan table. In function
hclge_set_vlan_filter_hw(), it checks whether a vlan id has been used,
by foreach all the vport bits. It should use macro HCLGE_VPORT_NUM,
not VLAN_N_VID as the foreach condition.

Fixes: 6c251711b37f ("net: hns3: Disable vf vlan filter when vf vlan table is full")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 44d0cb3f73a44..0e7c92f624e91 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4784,7 +4784,7 @@ static int hclge_set_vlan_filter_hw(struct hclge_dev *hdev, __be16 proto,
 		return -EINVAL;
 	}
 
-	for_each_set_bit(vport_idx, hdev->vlan_table[vlan_id], VLAN_N_VID)
+	for_each_set_bit(vport_idx, hdev->vlan_table[vlan_id], HCLGE_VPORT_NUM)
 		vport_num++;
 
 	if ((is_kill && vport_num == 0) || (!is_kill && vport_num == 1))
-- 
2.20.1

