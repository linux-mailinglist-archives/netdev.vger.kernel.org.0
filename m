Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FD91CBB21
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgEHXOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:14:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54522 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbgEHXOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 19:14:50 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jXCCd-00064O-A7; Fri, 08 May 2020 23:14:47 +0000
From:   Colin King <colin.king@canonical.com>
To:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2] net: tg3: tidy up loop, remove need to compute off with a multiply
Date:   Sat,  9 May 2020 00:14:47 +0100
Message-Id: <20200508231447.485241-1-colin.king@canonical.com>
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
multiplication and just increment off by len on each iteration.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: Use reverse Christmas tree variable declaration style

---
 drivers/net/ethernet/broadcom/tg3.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index ff98a82b7bc4..7a3b22b35238 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -10797,17 +10797,15 @@ static int tg3_init_hw(struct tg3 *tp, bool reset_phy)
 #ifdef CONFIG_TIGON3_HWMON
 static void tg3_sd_scan_scratchpad(struct tg3 *tp, struct tg3_ocir *ocir)
 {
+	u32 off, len = TG3_OCIR_LEN;
 	int i;
 
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

