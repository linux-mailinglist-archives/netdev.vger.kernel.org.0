Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F0A343A47
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 08:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhCVHJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 03:09:18 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.232.172]:54912 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229941AbhCVHIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 03:08:49 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 99AB421829;
        Mon, 22 Mar 2021 00:08:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 99AB421829
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1616396929;
        bh=T2cUELQFF5uom6yrwynNEWIpoLi03jHjDZjSWIR3k1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBnFlrSdjTN/zQCv472joil210Foa/z+9geMlb60QOP2uPzqsD9qRehPAnAtI4OP9
         xfWiJayOWpkLCUNx4PAm76Q69WWSQ6+AQmRFhwdS2+RR8iJsoS4mTnrUS/4jzOGCkN
         WZGjx0Ujfbq0lvEaEVI/12lKX84Y1xfsa7MsXvWI=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 4/7] bnxt_en: check return value of bnxt_hwrm_func_resc_qcaps
Date:   Mon, 22 Mar 2021 03:08:42 -0400
Message-Id: <1616396925-16596-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
References: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Scott Branden <scott.branden@broadcom.com>

Check return value of call to bnxt_hwrm_func_resc_qcaps in
bnxt_hwrm_if_change and return failure on error.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 3624e79667b6..7f40dd7d847d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9634,6 +9634,9 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 			struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
 
 			rc = bnxt_hwrm_func_resc_qcaps(bp, true);
+			if (rc)
+				netdev_err(bp->dev, "resc_qcaps failed\n");
+
 			hw_resc->resv_cp_rings = 0;
 			hw_resc->resv_stat_ctxs = 0;
 			hw_resc->resv_irqs = 0;
@@ -9647,7 +9650,7 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 			}
 		}
 	}
-	return 0;
+	return rc;
 }
 
 static int bnxt_hwrm_port_led_qcaps(struct bnxt *bp)
-- 
2.18.1

