Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BD54EF10A
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347985AbiDAOgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348275AbiDAOdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:33:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17831EE8DB;
        Fri,  1 Apr 2022 07:31:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EA0B61C1D;
        Fri,  1 Apr 2022 14:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9386BC34113;
        Fri,  1 Apr 2022 14:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823496;
        bh=uM3lRLTtNLNjHSKFs2iV/4oI8nwpHuOztGJHsJnJs28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nntf+mleNGmL1UxZqkjYgHsTkqMmMReGADdTurUUm2SWBdcjnXkQBGXzi6miT5Irq
         5aHjJnoclyraAR3hxdnbVFx4EFhthIXdlchBmr7R4oPfpSh4ylg5/yQHcPgpYVQDWN
         2JV8mxJMKrzwNTq8L5wWOA0LmcGpj+DnzWRr1kAuXgsnTUflpIS1+sx4tOE67Hud5d
         M5ajvEt4CUrt6ugLtp+H5cJveQYY6blrNIWjKNNTuii9896s5DE1McBs2rePPTQlTC
         XZdXu+PPIhGAIukpUjSRbv4sonpSKtk/CbxjaJhLzUIkacEbEAJC287+3qaKpOz5az
         al3asqvXQo2LA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Colin Winegarden <colin.winegarden@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 119/149] bnxt_en: Eliminate unintended link toggle during FW reset
Date:   Fri,  1 Apr 2022 10:25:06 -0400
Message-Id: <20220401142536.1948161-119-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 7c492a2530c1f05441da541307c2534230dfd59b ]

If the flow control settings have been changed, a subsequent FW reset
may cause the ethernet link to toggle unnecessarily.  This link toggle
will increase the down time by a few seconds.

The problem is caused by bnxt_update_phy_setting() detecting a false
mismatch in the flow control settings between the stored software
settings and the current FW settings after the FW reset.  This mismatch
is caused by the AUTONEG bit added to link_info->req_flow_ctrl in an
inconsistent way in bnxt_set_pauseparam() in autoneg mode.  The AUTONEG
bit should not be added to link_info->req_flow_ctrl.

Reviewed-by: Colin Winegarden <colin.winegarden@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 8aaa2335f848..f09b04556c32 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2101,9 +2101,7 @@ static int bnxt_set_pauseparam(struct net_device *dev,
 		}
 
 		link_info->autoneg |= BNXT_AUTONEG_FLOW_CTRL;
-		if (bp->hwrm_spec_code >= 0x10201)
-			link_info->req_flow_ctrl =
-				PORT_PHY_CFG_REQ_AUTO_PAUSE_AUTONEG_PAUSE;
+		link_info->req_flow_ctrl = 0;
 	} else {
 		/* when transition from auto pause to force pause,
 		 * force a link change
-- 
2.34.1

