Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEDA4B1BE4
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 03:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347141AbiBKCFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 21:05:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242403AbiBKCFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 21:05:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A17D5FA9
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 18:05:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DDEB5CE2751
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 02:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068C6C004E1;
        Fri, 11 Feb 2022 02:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644545149;
        bh=7KdCtCy6jfuh2yGA5/VNObXj+sbqbE3XeJ+lsmAPVj0=;
        h=From:To:Cc:Subject:Date:From;
        b=JalnvU+QQO06mTn2GftVphlnNUSNnmFhlBGmpiPsu3nowtoxQ9tEV5XUGP2woU+Ur
         QUd9NAkx6deBZKeN7UXUkjBdDxnEDQPHF4QbGmX/52kih21mbVv5S+QVzHZz0fw5/H
         yHLOaAKaW3MXiUod1Od10hDCmEJelxIQkT5u+JyjHGsxNxnkAWne8LibxfZT2FXPOv
         woeAAXBZ1d6KxP9AzTaW3Xssm3EVwEBWYxGwOXAOvF+jHPSY0PrPQH9rH0CoEcGV1F
         bhZZXxSm0v7flngsbPG7IRT4+PniAucbVplUU8obhwmz4EZl/NPXZ/IfidqJ2FJWPV
         s0Lzs45M6z6sg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dchickles@marvell.com,
        fmanlunas@marvell.com, sburla@marvell.com, wangqing@vivo.com,
        Jakub Kicinski <kuba@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH net-next] Revert "net: ethernet: cavium: use div64_u64() instead of do_div()"
Date:   Thu, 10 Feb 2022 18:05:44 -0800
Message-Id: <20220211020544.3262694-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 038fcdaf0470de89619bc4cc199e329391e6566c.

Christophe points out div64_u64() and do_div() have different
calling conventions. One updates the param, the other returns
the result.

Reported-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/all/056a7276-c6f0-cd7e-9e46-1d8507a0b6b1@wanadoo.fr/
Fixes: 038fcdaf0470 ("net: ethernet: cavium: use div64_u64() instead of do_div()")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 8e07192e409f..ba28aa444e5a 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1539,7 +1539,7 @@ static int liquidio_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 	 * compute the delta in terms of coprocessor clocks.
 	 */
 	delta = (u64)ppb << 32;
-	div64_u64(delta, oct->coproc_clock_rate);
+	do_div(delta, oct->coproc_clock_rate);
 
 	spin_lock_irqsave(&lio->ptp_lock, flags);
 	comp = lio_pci_readq(oct, CN6XXX_MIO_PTP_CLOCK_COMP);
@@ -1672,7 +1672,7 @@ static void liquidio_ptp_init(struct octeon_device *oct)
 	u64 clock_comp, cfg;
 
 	clock_comp = (u64)NSEC_PER_SEC << 32;
-	div64_u64(clock_comp, oct->coproc_clock_rate);
+	do_div(clock_comp, oct->coproc_clock_rate);
 	lio_pci_writeq(oct, clock_comp, CN6XXX_MIO_PTP_CLOCK_COMP);
 
 	/* Enable */
-- 
2.34.1

