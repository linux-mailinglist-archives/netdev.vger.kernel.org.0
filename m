Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AACFE1194ED
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbfLJVRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:17:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728006AbfLJVNG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3829520828;
        Tue, 10 Dec 2019 21:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012385;
        bh=RYreaePGYqn6h48jEO9OXHRhf140s7bUrNjGzY8Q2NA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZwiNrQV8BzJKYWLqujm9EZxQJXH7sb2oHLk51ggCp3OYbKpGSF9ZTBmSG2/ZHpR+
         bH0LYuRsk1jGke4g6y7fym0i6yyty3O89ixK2uZ7gNdeX3h5e2k1locdaTHfHKGHG0
         kAcH1maz5MX4minhPETE00bnR1qPAKTSI6YtNceI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 308/350] bnxt_en: Return proper error code for non-existent NVM variable
Date:   Tue, 10 Dec 2019 16:06:53 -0500
Message-Id: <20191210210735.9077-269-sashal@kernel.org>
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

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 05069dd4c577f9b143dfd243d55834333c4470c5 ]

For NVM params that are not supported in the current NVM
configuration, return the error as -EOPNOTSUPP.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 7151244f8c7d2..7d2cfea05737a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -311,10 +311,17 @@ static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 	} else {
 		rc = hwrm_send_message_silent(bp, msg, msg_len,
 					      HWRM_CMD_TIMEOUT);
-		if (!rc)
+		if (!rc) {
 			bnxt_copy_from_nvm_data(val, data,
 						nvm_param.nvm_num_bits,
 						nvm_param.dl_num_bytes);
+		} else {
+			struct hwrm_err_output *resp = bp->hwrm_cmd_resp_addr;
+
+			if (resp->cmd_err ==
+				NVM_GET_VARIABLE_CMD_ERR_CODE_VAR_NOT_EXIST)
+				rc = -EOPNOTSUPP;
+		}
 	}
 	dma_free_coherent(&bp->pdev->dev, sizeof(*data), data, data_dma_addr);
 	if (rc == -EACCES)
-- 
2.20.1

