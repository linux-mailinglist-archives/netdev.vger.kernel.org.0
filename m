Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C3E3E175F
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241505AbhHEO4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:56:19 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:50740 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241250AbhHEO4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 10:56:16 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 175Eu08U028585;
        Thu, 5 Aug 2021 09:56:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628175360;
        bh=+Xx3ctyBy/46ncUMIHawBKo4//4hXZidR/MLdUXK4BU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=b5Qy1hLTECYlrxuUMw5++2IRlSmddryT5MeyQsMoJ5KQzZQVMrIIKHw2BFlT/4Tk9
         AAOt1DgPrnJ5WvzKFGek4N01hKJ3J06d1kyk37vPjO8q1/BsCMCkpS7IG7znO6sgyW
         pE1e6lEBtleadPM/dq4/OujBe0swnGmjpyT35/CY=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 175Eu0eQ105105
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 5 Aug 2021 09:56:00 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 5 Aug
 2021 09:56:00 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 5 Aug 2021 09:56:00 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 175EtxGF035289;
        Thu, 5 Aug 2021 09:55:59 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@essensium.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 1/3] net: ethernet: ti: cpsw: switch to use skb_put_padto()
Date:   Thu, 5 Aug 2021 17:55:53 +0300
Message-ID: <20210805145555.12182-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210805145555.12182-1-grygorii.strashko@ti.com>
References: <20210805145555.12182-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use skb_put_padto() instead of skb_padto() so skb->len also got updated, as
preparation for further removing frame padding from cpdma.
It also makes xmit path more clear and linear.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index abf9a2a6f7eb..8e1e582a10c8 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -905,7 +905,7 @@ static netdev_tx_t cpsw_ndo_start_xmit(struct sk_buff *skb,
 	struct cpdma_chan *txch;
 	int ret, q_idx;
 
-	if (skb_padto(skb, CPSW_MIN_PACKET_SIZE)) {
+	if (skb_put_padto(skb, CPSW_MIN_PACKET_SIZE)) {
 		cpsw_err(priv, tx_err, "packet pad failed\n");
 		ndev->stats.tx_dropped++;
 		return NET_XMIT_DROP;
-- 
2.17.1

