Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5148858FA8B
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 12:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbiHKKPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 06:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234400AbiHKKPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 06:15:16 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB5B63C4
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 03:15:15 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id BD1EE7F4F5;
        Thu, 11 Aug 2022 12:15:13 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAACF34064;
        Thu, 11 Aug 2022 12:15:13 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9290B3405A;
        Thu, 11 Aug 2022 12:15:13 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Thu, 11 Aug 2022 12:15:13 +0200 (CEST)
Received: from sinope.intranet.prolan.hu (sinope.intranet.prolan.hu [10.254.0.237])
        by fw2.prolan.hu (Postfix) with ESMTPS id 625C57F4F5;
        Thu, 11 Aug 2022 12:15:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1660212913; bh=5uH9yTf8qvTxMuZEcd37jQba1OMHGjut++dtLZ2CfxM=;
        h=From:To:CC:Subject:Date:From;
        b=Xf+O6iAu5SUk0OEA1bazmRT+UQtSJ7Tl0C69Y57SCVNBsyeNTlwqDNeoVmxwdUjQE
         9UbqZlg5mPZyr6lbnl9C8R3LYEQpCfqlY2RTJPb30ikN0ZEchDZx1b7Dy+L22n0eWv
         SvXiH+K95i77hsZFTWp7vIbqJkdwnUpitTVKeolTYNt9GDBGKlQ3w3k2S2Fo9bfON8
         1QO3mmpc9aw7bf4i5N/lKIXj5foX2orp4YAk+/GsTg9acbWkMAAUmj+RPa8dZ0OpMy
         CcSahjn09jatpjmBi6Zfv60ZCUPYWGU4IgAPdHZAJB+RhZzYDH+YLP3ENURoUvUrk2
         nELiislSHi9AA==
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 sinope.intranet.prolan.hu (10.254.0.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.9; Thu, 11 Aug 2022 12:15:12 +0200
Received: from P-01011.intranet.prolan.hu (10.254.7.28) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server id
 15.1.2507.9 via Frontend Transport; Thu, 11 Aug 2022 12:15:12 +0200
From:   =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
To:     <netdev@vger.kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
Subject: [PATCH] fec: Fix timer capture timing in `fec_ptp_enable_pps()`
Date:   Thu, 11 Aug 2022 12:13:49 +0200
Message-ID: <20220811101348.13755-1-csokas.bence@prolan.hu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ESET-AS: R=OK;S=0;OP=CALC;TIME=1660212912;VERSION=7933;MC=3717483130;TRN=0;CRV=0;IPC=;SP=0;SIPS=0;PI=3;F=0
X-ESET-Antispam: OK
X-EsetResult: clean, is OK
X-EsetId: 37303A29A91EF456617360
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Code reimplements functionality already in `fec_ptp_read()`,
but misses check for FEC_QUIRK_BUG_CAPTURE. Replace with function call.

Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 869d149efc53..11620e2a485c 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -139,11 +139,7 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
 		 * NSEC_PER_SEC - ts.tv_nsec. Add the remaining nanoseconds
 		 * to current timer would be next second.
 		 */
-		tempval = readl(fep->hwp + FEC_ATIME_CTRL);
-		tempval |= FEC_T_CTRL_CAPTURE;
-		writel(tempval, fep->hwp + FEC_ATIME_CTRL);
-
-		tempval = readl(fep->hwp + FEC_ATIME);
+		tempval = fep->cc.read(&fep->cc);
 		/* Convert the ptp local counter to 1588 timestamp */
 		ns = timecounter_cyc2time(&fep->tc, tempval);
 		ts = ns_to_timespec64(ns);
-- 
2.25.1

