Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6CC13F46B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437041AbgAPSth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:49:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389073AbgAPRJV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45837205F4;
        Thu, 16 Jan 2020 17:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194561;
        bh=d7dmRKmohAvZ7kcE70HwAppkH5lbpOz49xer5jIKRIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yN9UDlRJ1GODHpPtJ7ilaeoJJk2vaHr9fFbE8PzQA1YnzQYBLuOqiCsM3r9oQ/K3k
         Fhwa7Bo7Kwh7D6UXIXYAeIcvELkepujhoKqZw2gRHBxvTPp2dufmWc0klgkBtocHaT
         U+yP9/1ZpCK5hv8B1WECx+SWqzUs4BXQdZzC6yxQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 441/671] bnxt_en: Suppress error messages when querying DSCP DCB capabilities.
Date:   Thu, 16 Jan 2020 12:01:19 -0500
Message-Id: <20200116170509.12787-178-sashal@kernel.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 4ca5fa39e1aea2f85eb9c4257075c4077c6531da ]

Some firmware versions do not support this so use the silent variant
to send the message to firmware to suppress the harmless error.  This
error message is unnecessarily alarming the user.

Fixes: afdc8a84844a ("bnxt_en: Add DCBNL DSCP application protocol support.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
index a85d2be986af..0e4e0b47f5d8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -396,7 +396,7 @@ static int bnxt_hwrm_queue_dscp_qcaps(struct bnxt *bp)
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_QUEUE_DSCP_QCAPS, -1, -1);
 	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	rc = _hwrm_send_message_silent(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (!rc) {
 		bp->max_dscp_value = (1 << resp->num_dscp_bits) - 1;
 		if (bp->max_dscp_value < 0x3f)
-- 
2.20.1

