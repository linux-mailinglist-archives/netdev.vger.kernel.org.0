Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3716C35B7B7
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbhDLASf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:18:35 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.232.172]:60274 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235781AbhDLASe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 20:18:34 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 9AA5F7DC2;
        Sun, 11 Apr 2021 17:18:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 9AA5F7DC2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1618186697;
        bh=xo8T0y/2DdFGP6awBuMX+kvcsRKlnwGRwlsLAki7OmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRmmfxO/5lfbp37uAC+Z1YcU9cG2pvV2iwn2zt8B5S/anOvrBgOTRc7AfrR5L47Zk
         JnPx91sL3YKe2qDqNxYImZrky19y982ZZgsNm+7F+/wVKymbQfyEZcipzVfiA+2F0s
         hseBBb9tKjCXEqglBR/MzVUSzYKUf19iDm3IhdO0=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 1/5] bnxt_en: Treat health register value 0 as valid in bnxt_try_reover_fw().
Date:   Sun, 11 Apr 2021 20:18:11 -0400
Message-Id: <1618186695-18823-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
References: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The retry loop in bnxt_try_recover_fw() should not abort when the
health register value is 0.  It is a valid value that indicates the
firmware is booting up.

Fixes: 861aae786f2f ("bnxt_en: Enhance retry of the first message to the firmware.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6f13642121c4..3d36f945baf8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9532,8 +9532,8 @@ static int bnxt_try_recover_fw(struct bnxt *bp)
 		do {
 			sts = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
 			rc = __bnxt_hwrm_ver_get(bp, true);
-			if (!sts || (!BNXT_FW_IS_BOOTING(sts) &&
-				     !BNXT_FW_IS_RECOVERING(sts)))
+			if (!BNXT_FW_IS_BOOTING(sts) &&
+			    !BNXT_FW_IS_RECOVERING(sts))
 				break;
 			retry++;
 		} while (rc == -EBUSY && retry < BNXT_FW_RETRY);
-- 
2.18.1

