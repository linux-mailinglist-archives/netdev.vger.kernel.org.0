Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDF55BA365
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 02:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiIOX7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 19:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiIOX7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 19:59:49 -0400
X-Greylist: delayed 573 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 15 Sep 2022 16:59:46 PDT
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16AE27CC0
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 16:59:45 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id EC7E1500593;
        Fri, 16 Sep 2022 02:46:37 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru EC7E1500593
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1663285599; bh=6aPt9MBf7COfRh3LQByXEguEH6aFizaZg7+ISOaVtQQ=;
        h=From:To:Cc:Subject:Date:From;
        b=0K/qPShUrzNRlShGv3UEPnGFQhBRPDdIZBMOasJ15NIb79MblabU4WhifNNBgziRb
         g3a65oeXWgZ5mJGtzz/V6n7lgCt9JVQDXXUOUKsRG6j77Oi0em9Dj9yIYjKyDLxe5u
         ZUBbMR7cF8Mbxg/hqLXCerNTvMoDIMKXdsfGgbzk=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Michael Chan <michael.chan@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        netdev@vger.kernel.org
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH] bnxt_en: fix flags to check for supported fw version
Date:   Fri, 16 Sep 2022 02:49:32 +0300
Message-Id: <20220915234932.25497-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The warning message of unsupported FW appears every time RX timestamps
are disabled on the interface. The patch fixes the flags to correct set
for the check.

Fixes: 66ed81dcedc6 ("bnxt_en: Enable packet timestamping for all RX packets")
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 7f3c0875b6f5..8e316367f6ce 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -317,9 +317,9 @@ void bnxt_ptp_cfg_tstamp_filters(struct bnxt *bp)
 
 	if (!(bp->fw_cap & BNXT_FW_CAP_RX_ALL_PKT_TS) && (ptp->tstamp_filters &
 	    (PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_ENABLE |
-	     PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_DISABLE))) {
+	     PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_DISABLE))) {
 		ptp->tstamp_filters &= ~(PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_ENABLE |
-					 PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_DISABLE);
+					 PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_DISABLE);
 		netdev_warn(bp->dev, "Unsupported FW for all RX pkts timestamp filter\n");
 	}
 
-- 
2.27.0

