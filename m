Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53BD1CBAF1
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 00:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgEHWxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 18:53:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54023 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbgEHWxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 18:53:04 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jXBrZ-0002Yc-W6; Fri, 08 May 2020 22:53:02 +0000
From:   Colin King <colin.king@canonical.com>
To:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: tg3: tidy up loop, remove need to compute off with a multiply
Date:   Fri,  8 May 2020 23:53:01 +0100
Message-Id: <20200508225301.484094-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the value for 'off' is computed using a multiplication and
a couple of statements later off is being incremented by len and
this value is never read.  Clean up the code by removing the
multiplication and just increment off by len on each iteration. Also
use len instead of TG3_OCIR_LEN.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index ff98a82b7bc4..9dd9bd506bcc 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -10798,16 +10798,14 @@ static int tg3_init_hw(struct tg3 *tp, bool reset_phy)
 static void tg3_sd_scan_scratchpad(struct tg3 *tp, struct tg3_ocir *ocir)
 {
 	int i;
+	u32 off, len = TG3_OCIR_LEN;
 
-	for (i = 0; i < TG3_SD_NUM_RECS; i++, ocir++) {
-		u32 off = i * TG3_OCIR_LEN, len = TG3_OCIR_LEN;
-
+	for (i = 0, off = 0; i < TG3_SD_NUM_RECS; i++, ocir++, off += len) {
 		tg3_ape_scratchpad_read(tp, (u32 *) ocir, off, len);
-		off += len;
 
 		if (ocir->signature != TG3_OCIR_SIG_MAGIC ||
 		    !(ocir->version_flags & TG3_OCIR_FLAG_ACTIVE))
-			memset(ocir, 0, TG3_OCIR_LEN);
+			memset(ocir, 0, len);
 	}
 }
 
-- 
2.25.1

