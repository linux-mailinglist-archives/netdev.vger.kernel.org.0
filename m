Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0670365E56
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 19:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbhDTRQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 13:16:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50872 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbhDTRQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 13:16:49 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lYtyw-00060S-P3; Tue, 20 Apr 2021 17:16:14 +0000
From:   Colin King <colin.king@canonical.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: davinci_emac: Fix incorrect masking of tx and rx error channel
Date:   Tue, 20 Apr 2021 18:16:14 +0100
Message-Id: <20210420171614.385721-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The bit-masks used for the TXERRCH and RXERRCH (tx and rx error channels)
are incorrect and always lead to a zero result. The mask values are
currently the incorrect post-right shifted values, fix this by setting
them to the currect values.

(I double checked these against the TMS320TCI6482 data sheet, section
5.30, page 127 to ensure I had the correct mask values for the TXERRCH
and RXERRCH fields in the MACSTATUS register).

Addresses-Coverity: ("Operands don't affect result")
Fixes: a6286ee630f6 ("net: Add TI DaVinci EMAC driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/ti/davinci_emac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 57450b174fc4..fb5eca688af9 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -183,11 +183,11 @@ static const char emac_version_string[] = "TI DaVinci EMAC Linux v6.1";
 /* EMAC mac_status register */
 #define EMAC_MACSTATUS_TXERRCODE_MASK	(0xF00000)
 #define EMAC_MACSTATUS_TXERRCODE_SHIFT	(20)
-#define EMAC_MACSTATUS_TXERRCH_MASK	(0x7)
+#define EMAC_MACSTATUS_TXERRCH_MASK	(0x70000)
 #define EMAC_MACSTATUS_TXERRCH_SHIFT	(16)
 #define EMAC_MACSTATUS_RXERRCODE_MASK	(0xF000)
 #define EMAC_MACSTATUS_RXERRCODE_SHIFT	(12)
-#define EMAC_MACSTATUS_RXERRCH_MASK	(0x7)
+#define EMAC_MACSTATUS_RXERRCH_MASK	(0x700)
 #define EMAC_MACSTATUS_RXERRCH_SHIFT	(8)
 
 /* EMAC RX register masks */
-- 
2.30.2

