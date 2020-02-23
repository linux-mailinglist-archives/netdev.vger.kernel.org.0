Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C110F1694F3
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgBWCeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:34:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728168AbgBWCWZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:22:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D53221D56;
        Sun, 23 Feb 2020 02:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424545;
        bh=gevy0Y7WUjal6/sURl3hPhZqxBEX4jIYewIp5CtAAmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKEGki9xnQOzQxCsiv/Nx55yhzhHUM4JOnoRvili6TFjwthbZmR3LVYaqXmzosVHQ
         5IiWGdVDTKxWye2+I/hVgl3Uj+OGjy6Hndvxxt+j+g/08ybexlfNbF7biImauuQS1q
         YUXf849aDFuahB9sKDSDiT8HJbUSX6FERJMsVGsQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 54/58] net: hns3: fix VF bandwidth does not take effect in some case
Date:   Sat, 22 Feb 2020 21:21:15 -0500
Message-Id: <20200223022119.707-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 19eb1123b4e9337fe20b1763fec528f837ec6568 ]

When enabling 4 TC after setting the bandwidth of VF, the bandwidth
of VF will resume to default value, because of the qset resources
changed in this case.

This patch fixes it by using a fixed VF's qset resources according to
HNAE3_MAX_TC macro.

Fixes: ee9e44248f52 ("net: hns3: add support for configuring bandwidth of VF on the host")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 180224eab1ca4..28db13253a5e7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -566,7 +566,7 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 	 */
 	kinfo->num_tc = vport->vport_id ? 1 :
 			min_t(u16, vport->alloc_tqps, hdev->tm_info.num_tc);
-	vport->qs_offset = (vport->vport_id ? hdev->tm_info.num_tc : 0) +
+	vport->qs_offset = (vport->vport_id ? HNAE3_MAX_TC : 0) +
 				(vport->vport_id ? (vport->vport_id - 1) : 0);
 
 	max_rss_size = min_t(u16, hdev->rss_size_max,
-- 
2.20.1

