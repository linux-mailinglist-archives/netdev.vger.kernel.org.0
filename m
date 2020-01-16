Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D89113F32B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407180AbgAPSks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:40:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390348AbgAPRL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1631724697;
        Thu, 16 Jan 2020 17:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194716;
        bh=Ykv5Omqbya/PBFt5kO//PlxFzjN08HDOhhu4rRk4zpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F706h52fC+umY0NE8SqrkycS9SYG2hF17lHoQovdHInH0jkvJqfWBeaVEa5LP3eS0
         29Qy020E8xJqTyffpC66RXJ8PmMM002HElDJKIVe7yzKbKxSFARJtOvNYqquAPa27a
         VYm25FRB3pRFSOxN9bzyIM+dsID2Y4Td9mJ0Ww6Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 553/671] bnxt_en: Increase timeout for HWRM_DBG_COREDUMP_XX commands
Date:   Thu, 16 Jan 2020 12:03:11 -0500
Message-Id: <20200116170509.12787-290-sashal@kernel.org>
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

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 57a8730b1f7a0be7bf8a0a0bb665329074ba764f ]

Firmware coredump messages take much longer than standard messages,
so increase the timeout accordingly.

Fixes: 6c5657d085ae ("bnxt_en: Add support for ethtool get dump.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index f9e253b705ec..585f5aef0a45 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -527,6 +527,7 @@ struct rx_tpa_end_cmp_ext {
 #define DFLT_HWRM_CMD_TIMEOUT		500
 #define HWRM_CMD_TIMEOUT		(bp->hwrm_cmd_timeout)
 #define HWRM_RESET_TIMEOUT		((HWRM_CMD_TIMEOUT) * 4)
+#define HWRM_COREDUMP_TIMEOUT		((HWRM_CMD_TIMEOUT) * 12)
 #define HWRM_RESP_ERR_CODE_MASK		0xffff
 #define HWRM_RESP_LEN_OFFSET		4
 #define HWRM_RESP_LEN_MASK		0xffff0000
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index cdbb8940a4ae..047024717d65 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2833,7 +2833,7 @@ static int bnxt_hwrm_dbg_coredump_initiate(struct bnxt *bp, u16 component_id,
 	req.component_id = cpu_to_le16(component_id);
 	req.segment_id = cpu_to_le16(segment_id);
 
-	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_COREDUMP_TIMEOUT);
 }
 
 static int bnxt_hwrm_dbg_coredump_retrieve(struct bnxt *bp, u16 component_id,
-- 
2.20.1

