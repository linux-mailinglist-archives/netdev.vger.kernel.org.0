Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 815B113E77D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403914AbgAPR0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:26:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:35006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391516AbgAPR0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:26:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AC642075B;
        Thu, 16 Jan 2020 17:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195580;
        bh=O/jCVhISa57PYJJCxWkmbSXvuAgtfEKdtNxEF9ZVWj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUaI/7g17qKOatP/5AB1XtrLXhj505fRLZw1dRRCyxJyfA8NI+hwTPx3BEv3JtZa1
         rborgJZrbgWb31CvkBC13GTqmaosTu4M/q0JlOYCU+MY/IkdlQ3/rqBVHigU0GjMO3
         7SPEwHXMfqNSe+ZRADnAWopVXlrYUH3bOvwcGyyo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 161/371] net: hns3: fix for vport->bw_limit overflow problem
Date:   Thu, 16 Jan 2020 12:20:33 -0500
Message-Id: <20200116172403.18149-104-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
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
index 9fcfd9395424..a4c5e72d6012 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -480,7 +480,7 @@ struct hclge_vport {
 	u16 alloc_rss_size;
 
 	u16 qs_offset;
-	u16 bw_limit;		/* VSI BW Limit (0 = disabled) */
+	u32 bw_limit;		/* VSI BW Limit (0 = disabled) */
 	u8  dwrr;
 
 	int vport_id;
-- 
2.20.1

