Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55662FA57E
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbfKMBwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:52:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbfKMBwo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C393C222CA;
        Wed, 13 Nov 2019 01:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609963;
        bh=HpJfRrDSSyuLg2DrJFpzk2sKf7uuJaSUC8TTp4L+rU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wYsRJj5LB+Co2fsa5VjjTuLYtkO/N2VDdarEwXBI7fB6msYjx/MbXTFmhtUVA++e
         DNphrX/+fXdY6fWCYf94yU+HBV7OjcpP4BBwffK0DlBWbP/R1gxm8Qj7mPSngpsL3r
         X1ti46jrbU1UvgTLRyZeu8NsOdqeyj/ADs4SgiMQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 094/209] bnxt_en: return proper error when FW returns HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED
Date:   Tue, 12 Nov 2019 20:48:30 -0500
Message-Id: <20191113015025.9685-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 3a1d52a54a6a4030b294e5f5732f0bfbae0e3815 ]

Return proper error code when Firmware returns
HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED for HWRM_NVM_GET/SET_VARIABLE
commands.

Cc: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 790c684f08abc..b178c2e9dc231 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -78,8 +78,12 @@ static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 		memcpy(buf, data_addr, bytesize);
 
 	dma_free_coherent(&bp->pdev->dev, bytesize, data_addr, data_dma_addr);
-	if (rc)
+	if (rc == HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED) {
+		netdev_err(bp->dev, "PF does not have admin privileges to modify NVM config\n");
+		return -EACCES;
+	} else if (rc) {
 		return -EIO;
+	}
 	return 0;
 }
 
-- 
2.20.1

