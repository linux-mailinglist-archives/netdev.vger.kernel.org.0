Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE57E5E6B8C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 21:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbiIVTLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 15:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbiIVTLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 15:11:18 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B23A106A0D
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 12:11:16 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 81FB2504CFA;
        Thu, 22 Sep 2022 22:07:36 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 81FB2504CFA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1663873657; bh=jGOgYZbK76uQFCTHORPf88UyR8vyLUfDo7yeU1Vp/JI=;
        h=From:To:Cc:Subject:Date:From;
        b=L/q8UH1w11DfH9sdA6n1LSL8d5/4Z8rz6B7DpenWMWVOSxQWCZ9Jpk3WCOtKHugih
         DQfx5RNc5Bjv6kZfSD4DJXw8hA0YmF1f+/Fz+ZWndq080E/mkzI2b4PWzQpEWynFf/
         yip/Y5c9LEwoguVmNOchHBTTnJE87ygubGEz9I9s=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Michael Chan <michael.chan@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next v3] bnxt_en: replace reset with config timestamps
Date:   Thu, 22 Sep 2022 22:10:38 +0300
Message-Id: <20220922191038.29921-1-vfedorenko@novek.ru>
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

Any change to the hardware timestamps configuration triggers nic restart,
which breaks transmition and reception of network packets for a while.
But there is no need to fully restart the device because while configuring
hardware timestamps. The code for changing configuration runs after all
of the initialisation, when the NIC is actually up and running. This patch
changes the code that ioctl will only update configuration registers and
will not trigger carrier status change, but in case of timestamps for
all rx packetes it fallbacks to close()/open() sequnce because of
synchronization issues in the hardware. Tested on BCM57504.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 7f3c0875b6f5..bd86919799ad 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -505,9 +505,13 @@ static int bnxt_hwrm_ptp_cfg(struct bnxt *bp)
 	ptp->tstamp_filters = flags;
 
 	if (netif_running(bp->dev)) {
-		rc = bnxt_close_nic(bp, false, false);
-		if (!rc)
-			rc = bnxt_open_nic(bp, false, false);
+		if (ptp->rx_filter == HWTSTAMP_FILTER_ALL) {
+			rc = bnxt_close_nic(bp, false, false);
+			if (!rc)
+				rc = bnxt_open_nic(bp, false, false);
+		} else {
+			bnxt_ptp_cfg_tstamp_filters(bp);
+		}
 		if (!rc && !ptp->tstamp_filters)
 			rc = -EIO;
 	}
-- 
2.27.0

