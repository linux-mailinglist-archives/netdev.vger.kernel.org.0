Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D591194BF
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbfLJVMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:12:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727145AbfLJVMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 601682073D;
        Tue, 10 Dec 2019 21:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012356;
        bh=t4qaAVhrByK3X7sketG15UMMUfKrub3CkV0rdYVJWzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsgXqwolKRFzZ1P9HoAsD+gzzqFmcupfgABvGx2SH8BExsMpva8aes38UpRtJKGhw
         iuixVJgZVV5PgaXRnZwAcaqjroEtsl0eAIeoYYpLUUpHdlC2h2U5JL0Kiy8jhmlZQi
         5w1EWaXL0rVHE+sXQiC2JpaKCdM0Gkm4Z1yhT8fM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 284/350] qtnfmac: fix using skb after free
Date:   Tue, 10 Dec 2019 16:06:29 -0500
Message-Id: <20191210210735.9077-245-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit 4a33f21cef84b1b933958c99ed5dac1726214b35 ]

KASAN reported use-after-free error:

[  995.220767] BUG: KASAN: use-after-free in qtnf_cmd_send_with_reply+0x169/0x3e0 [qtnfmac]
[  995.221098] Read of size 2 at addr ffff888213d1ded0 by task kworker/1:1/71

The issue in qtnf_cmd_send_with_reply impacts all the commands that do
not need response other then return code. For such commands, consume_skb
is used for response skb and right after that return code in response
skb is accessed.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index dc0c7244b60e3..c0c32805fb8de 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -83,6 +83,7 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
 	struct qlink_cmd *cmd;
 	struct qlink_resp *resp = NULL;
 	struct sk_buff *resp_skb = NULL;
+	int resp_res = 0;
 	u16 cmd_id;
 	u8 mac_id;
 	u8 vif_id;
@@ -113,6 +114,7 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
 	}
 
 	resp = (struct qlink_resp *)resp_skb->data;
+	resp_res = le16_to_cpu(resp->result);
 	ret = qtnf_cmd_check_reply_header(resp, cmd_id, mac_id, vif_id,
 					  const_resp_size);
 	if (ret)
@@ -128,8 +130,8 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
 	else
 		consume_skb(resp_skb);
 
-	if (!ret && resp)
-		return qtnf_cmd_resp_result_decode(le16_to_cpu(resp->result));
+	if (!ret)
+		return qtnf_cmd_resp_result_decode(resp_res);
 
 	pr_warn("VIF%u.%u: cmd 0x%.4X failed: %d\n",
 		mac_id, vif_id, cmd_id, ret);
-- 
2.20.1

