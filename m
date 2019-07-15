Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80AAD68D78
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732651AbfGON6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731636AbfGON6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:58:52 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AD7B21530;
        Mon, 15 Jul 2019 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199131;
        bh=ZWj+X78ZEPAHyiyMHCoWF8TDlSZ8suSoMHwF+vXujFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1IUSnb4ujt6K4ZNhSHErAy7Y5nHO7BEgdJxDkpnntTA8Qx//ZKLiIBHvSlyJDKGK
         5VV37lcPIZSXkEuWvwt8hRXW9EHAssWLk3TNWaMJGKwZYfZpVfrnLSP9SFtrzAQM7v
         IacVtqEr5fJUeiJW1OsEzrKpv2+V6ymE35eb+ur4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 200/249] net: hns3: add some error checking in hclge_tm module
Date:   Mon, 15 Jul 2019 09:46:05 -0400
Message-Id: <20190715134655.4076-200-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 04f25edb48c441fc278ecc154c270f16966cbb90 ]

When hdev->tx_sch_mode is HCLGE_FLAG_VNET_BASE_SCH_MODE, the
hclge_tm_schd_mode_vnet_base_cfg calls hclge_tm_pri_schd_mode_cfg
with vport->vport_id as pri_id, which is used as index for
hdev->tm_info.tc_info, it will cause out of bound access issue
if vport_id is equal to or larger than HNAE3_MAX_TC.

Also hardware only support maximum speed of HCLGE_ETHER_MAX_RATE.

So this patch adds two checks for above cases.

Fixes: 848440544b41 ("net: hns3: Add support of TX Scheduler & Shaper to HNS3 driver")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index a7bbb6d3091a..0d53062f7bb5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -54,7 +54,8 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 	u32 tick;
 
 	/* Calc tick */
-	if (shaper_level >= HCLGE_SHAPER_LVL_CNT)
+	if (shaper_level >= HCLGE_SHAPER_LVL_CNT ||
+	    ir > HCLGE_ETHER_MAX_RATE)
 		return -EINVAL;
 
 	tick = tick_array[shaper_level];
@@ -1124,6 +1125,9 @@ static int hclge_tm_schd_mode_vnet_base_cfg(struct hclge_vport *vport)
 	int ret;
 	u8 i;
 
+	if (vport->vport_id >= HNAE3_MAX_TC)
+		return -EINVAL;
+
 	ret = hclge_tm_pri_schd_mode_cfg(hdev, vport->vport_id);
 	if (ret)
 		return ret;
-- 
2.20.1

