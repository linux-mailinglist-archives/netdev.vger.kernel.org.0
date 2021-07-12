Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A493C5E76
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 16:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbhGLOkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 10:40:49 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:37570
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231194AbhGLOks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 10:40:48 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 24CAA4057E;
        Mon, 12 Jul 2021 14:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626100671;
        bh=0Fb2DTYmyckSADo+MG8A3tiLWuW/JPbmDFjok+wCZlc=;
        h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=gMdixbqI9GaYD+O63wFbCuHysdl2XdINIedaORXhApehUH+rW+0rWiR1S+9pjIuGJ
         MS7dl9Hi3HQIbHBzi40bGTC/QYBE9HROnazq7PRPa4vVTzMe7lZDghJEvad+cUiCam
         CTtNxLAlinxQw+i5q4XqOr1P3MALVeMEKVSk8vu7BGGIhDC/KY3wi7Lvva4qVYiGSf
         5l4Yj/H5JFYx0jMjRGWYAwY9wEdDGbeJYBCLRdmEJRtEXvcULEF24I8re3C7c+idZN
         7Ljb+VFA2fHI+BkXx+6U8c4J1SnsDjCSMFS8jFUufrxsflLKej1v4jRbR//+Gm+Tqc
         c+llUoRbjFzQA==
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] octeontx2-pf: Fix uninitialized boolean variable pps
Date:   Mon, 12 Jul 2021 15:37:50 +0100
Message-Id: <20210712143750.100890-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the case where act->id is FLOW_ACTION_POLICE and also
act->police.rate_bytes_ps > 0 or act->police.rate_pkt_ps is not > 0
the boolean variable pps contains an uninitialized value when
function otx2_tc_act_set_police is called. Fix this by initializing
pps to false.

Addresses-Coverity: ("Uninitialized scalar variable)"
Fixes: 68fbff68dbea ("octeontx2-pf: Add police action for TC flower")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 905fc02a7dfe..972b202b9884 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -288,7 +288,7 @@ static int otx2_tc_parse_actions(struct otx2_nic *nic,
 	struct otx2_nic *priv;
 	u32 burst, mark = 0;
 	u8 nr_police = 0;
-	bool pps;
+	bool pps = false;
 	u64 rate;
 	int i;
 
-- 
2.31.1

