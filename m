Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 533F9697DD
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731606AbfGONsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730691AbfGONsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:48:53 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5253B2067C;
        Mon, 15 Jul 2019 13:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198531;
        bh=uhnvAancAVMkA3TSTecQZgPoV74ngOr7T0pi4tizkbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KqdjIYulVeDvhdEBWuRh0LoZcELnz1h9a8yscmowZAvAVFT4IxVMZxhAL9fy22Um
         uztbBBzD6qSLzzCqFdX4bALTIHGVTq/ZCYe+x8B7TJ+Lws3lwBOd2JjsIuwqYKVrH2
         X6co+4bI+BP5VgSUXwSPFLt29i9wFX4GeprEeLZU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 036/249] net: hns3: fix for FEC configuration
Date:   Mon, 15 Jul 2019 09:43:21 -0400
Message-Id: <20190715134655.4076-36-sashal@kernel.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit f438bfe9d4fe2e491505abfbf04d7c506e00d146 ]

The FEC capbility may be changed with port speed changes. Driver
needs to read the active FEC mode, and update FEC capability
when port speed changes.

Fixes: 7e6ec9148a1d ("net: hns3: add support for FEC encoding control")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d3b1f8cb1155..4d9bcad26f06 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2508,6 +2508,9 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 
 static void hclge_update_port_capability(struct hclge_mac *mac)
 {
+	/* update fec ability by speed */
+	hclge_convert_setting_fec(mac);
+
 	/* firmware can not identify back plane type, the media type
 	 * read from configuration can help deal it
 	 */
@@ -2580,6 +2583,10 @@ static int hclge_get_sfp_info(struct hclge_dev *hdev, struct hclge_mac *mac)
 		mac->speed_ability = le32_to_cpu(resp->speed_ability);
 		mac->autoneg = resp->autoneg;
 		mac->support_autoneg = resp->autoneg_ability;
+		if (!resp->active_fec)
+			mac->fec_mode = 0;
+		else
+			mac->fec_mode = BIT(resp->active_fec);
 	} else {
 		mac->speed_type = QUERY_SFP_SPEED;
 	}
-- 
2.20.1

