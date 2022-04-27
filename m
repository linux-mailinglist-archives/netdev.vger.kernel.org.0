Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F3B511F6E
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240205AbiD0Por (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240145AbiD0Poo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:44:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611FB1D321
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3635618F9
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247AFC385B0;
        Wed, 27 Apr 2022 15:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074087;
        bh=ix1JmY3/nHR1YjFoqzZ7U4J02sb0Wc79WwQkZ+yRI6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQmiMotsH+pMU/wglhgsMNZET19wmpBSlGPsnPwfKrv/Or3AohSSoW/yABBIom3Dt
         K2XMgcCOBQ7TFpae9Z3HLx6AVuBzG0Qfl2jgMmXDUwqfI92WGgh8Z5alTavdaJz3Oz
         +0Pm1alMsPLWs7lIQX0DwYSQMcd4UxYi4uqCUY6kGthkHwUKCVFmHqsDyExHLfKWer
         6RRjSqxpXm+a+8ujjbQcWD2s/J9siIWfwEhlogCUjjdlgX4tNrxnAs9vMcjKiKjiPw
         K4b501WE2u0f2TvbNTsMTsQu9M+EkOi9fqVaflsQuqE6ttw37RSMJZCDIT2f71a48C
         NsibB21rHx/Hw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        claudiu.manoil@nxp.com
Subject: [PATCH net-next 11/14] eth: gfar: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Wed, 27 Apr 2022 08:41:08 -0700
Message-Id: <20220427154111.529975-12-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220427154111.529975-1-kuba@kernel.org>
References: <20220427154111.529975-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Defining local versions of NAPI_POLL_WEIGHT with the same
values in the drivers just makes refactoring harder.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: claudiu.manoil@nxp.com
---
 drivers/net/ethernet/freescale/gianfar.c | 2 +-
 drivers/net/ethernet/freescale/gianfar.h | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 206b7a35eaf5..f0b652a65043 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3232,7 +3232,7 @@ static int gfar_probe(struct platform_device *ofdev)
 	/* Register for napi ...We are registering NAPI for each grp */
 	for (i = 0; i < priv->num_grps; i++) {
 		netif_napi_add(dev, &priv->gfargrp[i].napi_rx,
-			       gfar_poll_rx_sq, GFAR_DEV_WEIGHT);
+			       gfar_poll_rx_sq, NAPI_POLL_WEIGHT);
 		netif_tx_napi_add(dev, &priv->gfargrp[i].napi_tx,
 				  gfar_poll_tx_sq, 2);
 	}
diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
index ca5e14f908fe..68b59d3202e3 100644
--- a/drivers/net/ethernet/freescale/gianfar.h
+++ b/drivers/net/ethernet/freescale/gianfar.h
@@ -52,9 +52,6 @@ struct ethtool_rx_list {
 	unsigned int count;
 };
 
-/* The maximum number of packets to be handled in one call of gfar_poll */
-#define GFAR_DEV_WEIGHT 64
-
 /* Length for FCB */
 #define GMAC_FCB_LEN 8
 
-- 
2.34.1

