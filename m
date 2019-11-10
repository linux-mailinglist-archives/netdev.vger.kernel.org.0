Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCD4F6695
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfKJCl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:41:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727654AbfKJCl4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:41:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19742214E0;
        Sun, 10 Nov 2019 02:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353715;
        bh=UcedAKmJKOMClQiJe28VF5OGfa6QxtsLch4F49QvOxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHudNbIz1OuZMo5SlwvBlnptuYOwG/supxD/zKadvyaiJJvVj9Qd/e8ctRx+iP6Qb
         VYz550OpVho+2666j8mYteE+hAeWxWA7N9A/tPfbFP73HZJeg1/Ura1ZT1eYW+qbue
         VAn0yJdZNC+6ZEMhElOOUR5ZeiKla3koxagRY1I8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>, Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 050/191] net: hns3: Fix parameter type for q_id in hclge_tm_q_to_qs_map_cfg()
Date:   Sat,  9 Nov 2019 21:37:52 -0500
Message-Id: <20191110024013.29782-50-sashal@kernel.org>
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
index 11e9259ca0407..0d45d045706c7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -298,7 +298,7 @@ static int hclge_tm_qs_to_pri_map_cfg(struct hclge_dev *hdev,
 }
 
 static int hclge_tm_q_to_qs_map_cfg(struct hclge_dev *hdev,
-				    u8 q_id, u16 qs_id)
+				    u16 q_id, u16 qs_id)
 {
 	struct hclge_nq_to_qs_link_cmd *map;
 	struct hclge_desc desc;
-- 
2.20.1

