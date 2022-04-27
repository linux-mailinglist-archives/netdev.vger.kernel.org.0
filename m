Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171E3511E7D
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240277AbiD0Poy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240150AbiD0Pop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:44:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D227A31905
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:41:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44C7FB82876
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5F5C385B3;
        Wed, 27 Apr 2022 15:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074086;
        bh=pKFnkLlSV3w5lA2qNH/13B5W/VVza1dsOWFPcA1sfbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X28T8eJhFJAIxiWJ3bGl9EyczjxtqxUVAIpm3CkA5tm3gKLHttpaALWXZhIp/hQqW
         Ei/fVNl/TurfoIktloLCQI1JbL1YTvAqxlhSR2xuN9CYhMDuCgtOA2LhB1w+2+ACr7
         //J4njlYCxsDM9Z5ImLM1AV4hsqXzmpeLP8clpSyKjPbcMDL1krebVb2P6Qs06dXFE
         /pz7j0jVsOIHHvJwuMa8ZwfxRg9q3gQBdzUNk9hDZRT4uwJIeUjcT2kDCRBAtt9Gkp
         kECErqpfutJie/I0S8mUQL361NIjjTIIeoM2iqo3doGVd1BdIXhpyw1J2tFTWokyBr
         cu+gV1IM3VN1Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH net-next 08/14] eth: bgnet: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Wed, 27 Apr 2022 08:41:05 -0700
Message-Id: <20220427154111.529975-9-kuba@kernel.org>
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
CC: rafal@milecki.pl
CC: bcm-kernel-feedback-list@broadcom.com
---
 drivers/net/ethernet/broadcom/bgmac.c | 2 +-
 drivers/net/ethernet/broadcom/bgmac.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 7b525c65bacb..2dfc1e32bbb3 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1527,7 +1527,7 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 	if (bcm47xx_nvram_getenv("et0_no_txint", NULL, 0) == 0)
 		bgmac->int_mask &= ~BGMAC_IS_TX_MASK;
 
-	netif_napi_add(net_dev, &bgmac->napi, bgmac_poll, BGMAC_WEIGHT);
+	netif_napi_add(net_dev, &bgmac->napi, bgmac_poll, NAPI_POLL_WEIGHT);
 
 	err = bgmac_phy_connect(bgmac);
 	if (err) {
diff --git a/drivers/net/ethernet/broadcom/bgmac.h b/drivers/net/ethernet/broadcom/bgmac.h
index 110088e662ea..e05ac92c0650 100644
--- a/drivers/net/ethernet/broadcom/bgmac.h
+++ b/drivers/net/ethernet/broadcom/bgmac.h
@@ -364,8 +364,6 @@
 #define BGMAC_CHIPCTL_7_IF_TYPE_MII		0x00000040
 #define BGMAC_CHIPCTL_7_IF_TYPE_RGMII		0x00000080
 
-#define BGMAC_WEIGHT	64
-
 #define ETHER_MAX_LEN	(ETH_FRAME_LEN + ETH_FCS_LEN)
 
 /* Feature Flags */
-- 
2.34.1

