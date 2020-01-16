Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E3D13E7E8
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392612AbgAPR2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:28:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392658AbgAPR2t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:28:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8824B246EE;
        Thu, 16 Jan 2020 17:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195728;
        bh=joW9gCGtn7LIvHqY6FdzL63I+rB36f9vG8zWb0MgOoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OtC/Lj/5wY84wjxqDudsQxiW3FfVwcD0WGJQZutF/zK5yj/dQ0+vi7PnOnHbD0A2B
         I+7wsZfXDe+QwFrMnVFEiKh3fPb2jcOx7qE4ozbuz2tNGGz+HKj0hx1jt0hMwZqR7i
         MsOAOJ3+PWjz6r8aaRKpC//YvO18t5VU9S0GJpf8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 269/371] bnxt_en: Fix handling FRAG_ERR when NVM_INSTALL_UPDATE cmd fails
Date:   Thu, 16 Jan 2020 12:22:21 -0500
Message-Id: <20200116172403.18149-212-sashal@kernel.org>
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

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit dd2ebf3404c7c295014bc025dea23960960ceb1a ]

If FW returns FRAG_ERR in response error code, driver is resending the
command only when HWRM command returns success. Fix the code to resend
NVM_INSTALL_UPDATE command with DEFRAG install flags, if FW returns
FRAG_ERR in its response error code.

Fixes: cb4d1d626145 ("bnxt_en: Retry failed NVM_INSTALL_UPDATE with defragmentation flag enabled.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 963beaa8fabb..3c78cd1cdd6f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1667,21 +1667,19 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
 	mutex_lock(&bp->hwrm_cmd_lock);
 	hwrm_err = _hwrm_send_message(bp, &install, sizeof(install),
 				      INSTALL_PACKAGE_TIMEOUT);
-	if (hwrm_err)
-		goto flash_pkg_exit;
-
-	if (resp->error_code) {
+	if (hwrm_err) {
 		u8 error_code = ((struct hwrm_err_output *)resp)->cmd_err;
 
-		if (error_code == NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR) {
+		if (resp->error_code && error_code ==
+		    NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR) {
 			install.flags |= cpu_to_le16(
 			       NVM_INSTALL_UPDATE_REQ_FLAGS_ALLOWED_TO_DEFRAG);
 			hwrm_err = _hwrm_send_message(bp, &install,
 						      sizeof(install),
 						      INSTALL_PACKAGE_TIMEOUT);
-			if (hwrm_err)
-				goto flash_pkg_exit;
 		}
+		if (hwrm_err)
+			goto flash_pkg_exit;
 	}
 
 	if (resp->result) {
-- 
2.20.1

