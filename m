Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF24F6532
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbfKJDFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 22:05:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:50534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729100AbfKJCqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:46:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45BD821850;
        Sun, 10 Nov 2019 02:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353997;
        bh=h/3lyAH75L97O26Qlz9BevbzGQLjmYZBXgPyGEqU2pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhR2d7sZC5jYk79e9Z8ADBy/MWuisZYpe6mPVWhFrcyDXUxrML0HZDvTtEGBYNaTB
         lLBmbeSNnr7akiw08jr76It35K6nuY8HrmUjNHTNV0a+f6pUY212H3zUf2KY1S7xSc
         OSmbfufGRO6i2H8R+5Oow6zdHeyA7fFAHaL+T4hY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>, Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 025/109] net: hns3: Fix parameter type for q_id in hclge_tm_q_to_qs_map_cfg()
Date:   Sat,  9 Nov 2019 21:44:17 -0500
Message-Id: <20191110024541.31567-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 32c7fbc8ffd752c6aa05d2dd7c13b0f0aa00ddaa ]

So far all the places calling hclge_tm_q_to_qs_map_cfg() are assigning
an u16 type value to "q_id", and in the processing of
hclge_tm_q_to_qs_map_cfg(), it also converts the "q_id" to le16.

The max tqp number for pf can be more than 256, we should use "u16" to
store the queue id, instead of "u8", which may cause data lost.

Fixes: 848440544b41 ("net: hns3: Add support of TX Scheduler & Shaper to HNS3 driver")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 55228b91d80b6..3799cb2548ce6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -200,7 +200,7 @@ static int hclge_tm_qs_to_pri_map_cfg(struct hclge_dev *hdev,
 }
 
 static int hclge_tm_q_to_qs_map_cfg(struct hclge_dev *hdev,
-				    u8 q_id, u16 qs_id)
+				    u16 q_id, u16 qs_id)
 {
 	struct hclge_nq_to_qs_link_cmd *map;
 	struct hclge_desc desc;
-- 
2.20.1

