Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C4C4FB160
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 03:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244227AbiDKBez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 21:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239660AbiDKBey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 21:34:54 -0400
Received: from mail.meizu.com (unknown [14.29.68.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C864435DCF;
        Sun, 10 Apr 2022 18:32:41 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail04.meizu.com
 (172.16.1.16) with Microsoft SMTP Server (TLS) id 14.3.487.0; Mon, 11 Apr
 2022 09:32:39 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Mon, 11 Apr
 2022 09:32:39 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     Haowen Bai <baihaowen@meizu.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] sfc: ef10: Fix assigning negative value to unsigned variable
Date:   Mon, 11 Apr 2022 09:32:37 +0800
Message-ID: <1649640757-30041-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix warning reported by smatch:
251 drivers/net/ethernet/sfc/ef10.c:2259 efx_ef10_tx_tso_desc()
warn: assigning (-208) to unsigned variable 'ip_tot_len'

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
V1->V2: to assign "0x10000 - EFX_TSO2_MAX_HDRLEN" is the actual 
semantics of the value.

 drivers/net/ethernet/sfc/ef10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 50d535981a35..c9ee5011803f 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2256,7 +2256,7 @@ int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 	 * guaranteed to satisfy the second as we only attempt TSO if
 	 * inner_network_header <= 208.
 	 */
-	ip_tot_len = -EFX_TSO2_MAX_HDRLEN;
+	ip_tot_len = 0x10000 - EFX_TSO2_MAX_HDRLEN;
 	EFX_WARN_ON_ONCE_PARANOID(mss + EFX_TSO2_MAX_HDRLEN +
 				  (tcp->doff << 2u) > ip_tot_len);
 
-- 
2.7.4

