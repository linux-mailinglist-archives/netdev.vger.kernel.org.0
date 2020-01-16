Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4BEA13F612
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388684AbgAPRF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:05:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388496AbgAPRFz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F22652087E;
        Thu, 16 Jan 2020 17:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194354;
        bh=r0Hju8Iig33dMEeRa4n6KM+9Zi+E5Jv2xj51KuuocEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6Eo7UUAdi9HXdazDytq3SVgvPw1KYLPhvoYeJsLFD1sIhiQ6OfSPct4CBk2huNtu
         he4s7cj/5x7JsHZGPtsPyhwCxljNA5mkmbTAj/3dkqgkn2jjVqOzo40rapZc5OPkzK
         nq0nUO+crNHZe4gprSdM7po0Gnv+0lUW6fb/Yz7g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 293/671] net: hns3: fix for vport->bw_limit overflow problem
Date:   Thu, 16 Jan 2020 11:58:51 -0500
Message-Id: <20200116170509.12787-30-sashal@kernel.org>
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

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 2566f10676ba996b745e138f54f3e2f974311692 ]

When setting vport->bw_limit to hdev->tm_info.pg_info[0].bw_limit
in hclge_tm_vport_tc_info_update, vport->bw_limit can be as big as
HCLGE_ETHER_MAX_RATE (100000), which can not fit into u16 (65535).

So this patch fixes it by using u32 for vport->bw_limit.

Fixes: 848440544b41 ("net: hns3: Add support of TX Scheduler & Shaper to HNS3 driver")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 260b1e779690..d14b7018fdf3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -600,7 +600,7 @@ struct hclge_vport {
 	u16 alloc_rss_size;
 
 	u16 qs_offset;
-	u16 bw_limit;		/* VSI BW Limit (0 = disabled) */
+	u32 bw_limit;		/* VSI BW Limit (0 = disabled) */
 	u8  dwrr;
 
 	struct hclge_tx_vtag_cfg  txvlan_cfg;
-- 
2.20.1

