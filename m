Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437273185A5
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 08:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBKHZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 02:25:17 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:47326 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229642AbhBKHZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 02:25:15 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 092A980C1;
        Wed, 10 Feb 2021 23:24:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 092A980C1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1613028265;
        bh=D+K34WC4fnMrHn85ar18Dlgi5Kj83yb71rGhEak8UOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZpL4KmUXAzFUfwoZjwIlTbJj1LqUDs7PrHXHI0+JT8aN326wClNIzzlkhwG5wPKL
         x/RRvYzPgvYmuQAlK0SPYRvey8nBclC/EzA2Nz75HM/WAro+GDHtsM5QNK5iAsrAOP
         WWtMzQqLu2TVO5e1DAk5apsI1KgsacAoaTRNFBSc=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 1/2] bnxt_en: reverse order of TX disable and carrier off
Date:   Thu, 11 Feb 2021 02:24:23 -0500
Message-Id: <1613028264-20306-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613028264-20306-1-git-send-email-michael.chan@broadcom.com>
References: <1613028264-20306-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

A TX queue can potentially immediately timeout after it is stopped
and the last TX timestamp on that queue was more than 5 seconds ago with
carrier still up.  Prevent these intermittent false TX timeouts
by bringing down carrier first before calling netif_tx_disable().

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d10e4f85dd11..1c96b7ba24f2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8856,9 +8856,10 @@ void bnxt_tx_disable(struct bnxt *bp)
 			txr->dev_state = BNXT_DEV_STATE_CLOSING;
 		}
 	}
+	/* Drop carrier first to prevent TX timeout */
+	netif_carrier_off(bp->dev);
 	/* Stop all TX queues */
 	netif_tx_disable(bp->dev);
-	netif_carrier_off(bp->dev);
 }
 
 void bnxt_tx_enable(struct bnxt *bp)
-- 
2.18.1

