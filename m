Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5A56AD2E9
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 00:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCFXkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 18:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCFXkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 18:40:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0C44B81B;
        Mon,  6 Mar 2023 15:40:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C85C660DB9;
        Mon,  6 Mar 2023 23:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05DAC433EF;
        Mon,  6 Mar 2023 23:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678146002;
        bh=eCpOTQ0/Lt5qkPZVS4C+58a7vx2Eo4kKSq/QZthxn48=;
        h=Date:From:To:Cc:Subject:From;
        b=SMiGFR90uM34CS5CQ4R/loMuIk3job4bqlLvDhnxURYR0lXYfwWEGz37UzqR1EhuQ
         qalYsLAwRL47RRobA4rVlfu0z7vV4LERyPyoDIsl4431iLAwD2mrx7KghFHtITU3/Y
         F1dXJ1/D1EoMBZrczbIL2JB7TFrk/auizjC5g97RV572XYPE6JafiwhR2zxSNGLt6N
         JAPArJGYUzwunWzUIxPGw8sG6FU81FOBSGpyJ2nrOu75m98dbUe2HWnEtKB5ZedO+5
         Mqws940ehWrFga9BNoP2JZsE99TFEM/gEGpxoh9e8OgB5gE8BN30euOpHeKbVRm/zm
         AvCSYtryLHpGg==
Date:   Mon, 6 Mar 2023 17:40:28 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] netxen_nic: Replace fake flex-array with
 flexible-array member
Message-ID: <ZAZ57I6WdQEwWh7v@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays as fake flexible arrays are deprecated and we are
moving towards adopting C99 flexible-array members instead.

Transform zero-length array into flexible-array member in struct
nx_cardrsp_rx_ctx_t.

Address the following warnings found with GCC-13 and
-fstrict-flex-arrays=3 enabled:
drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c:361:26: warning: array subscript <unknown> is outside array bounds of ‘char[0]’ [-Warray-bounds=]
drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c:372:25: warning: array subscript <unknown> is outside array bounds of ‘char[0]’ [-Warray-bounds=]

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

Link: https://github.com/KSPP/linux/issues/21
Link: https://github.com/KSPP/linux/issues/265
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic.h b/drivers/net/ethernet/qlogic/netxen/netxen_nic.h
index f13fa7396aef..3d36d23df0c6 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic.h
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic.h
@@ -854,7 +854,7 @@ typedef struct {
 	   The following is packed:
 	   - N cardrsp_rds_rings
 	   - N cardrs_sds_rings */
-	char data[0];
+	char data[];
 } nx_cardrsp_rx_ctx_t;
 
 #define SIZEOF_HOSTRQ_RX(HOSTRQ_RX, rds_rings, sds_rings)	\
-- 
2.34.1

