Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECDE95BD402
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 19:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiISRoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 13:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiISRoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 13:44:38 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6690C1124
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 10:44:33 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id BB2CE504D10;
        Mon, 19 Sep 2022 20:41:25 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru BB2CE504D10
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1663609287; bh=oCIxLB7BJvm+vLnP4ng1MykNGUgiK9pidDma3iIsBR8=;
        h=From:To:Cc:Subject:Date:From;
        b=N2OD+pllFGjRdMAbOlzrpEoJf7sPkzERw9NljaiECe4lyEN79EASp1Jc6JuA9bPVt
         YupH5dqD9ybNCUU0iB/rHDJxdhyI3qKXAyCu5IuX8rEMIZ3YIzyrzu8tmRxKTIfqAr
         vE15X27ozKhxi0GYgVKJRWNMfGnw5vAAJpZZLHWE=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Michael Chan <michael.chan@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net] net: bnxt: replace reset with config timestamps
Date:   Mon, 19 Sep 2022 20:44:23 +0300
Message-Id: <20220919174423.31146-1-vfedorenko@novek.ru>
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
will not trigger carrier status change. Tested on BCM57504.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 8e316367f6ce..36e9148468b5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -505,10 +505,8 @@ static int bnxt_hwrm_ptp_cfg(struct bnxt *bp)
 	ptp->tstamp_filters = flags;
 
 	if (netif_running(bp->dev)) {
-		rc = bnxt_close_nic(bp, false, false);
-		if (!rc)
-			rc = bnxt_open_nic(bp, false, false);
-		if (!rc && !ptp->tstamp_filters)
+		bnxt_ptp_cfg_tstamp_filters(bp);
+		if (!ptp->tstamp_filters)
 			rc = -EIO;
 	}
 
-- 
2.27.0

