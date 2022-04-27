Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E90511EA2
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240265AbiD0PpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240231AbiD0Pos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:44:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E5A3389A
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:41:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D445618E2
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A72C385B1;
        Wed, 27 Apr 2022 15:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074088;
        bh=VVgJTW5MgODJKkM2WWDvGTK+o+CHA/IvC3faoxsut+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPmVghWx9TG/22VQUZaL1wlT/q8bswXfO6fO8mURkSXhXlTIlE3qhTU4cE5LDMSY5
         HyIhKcYbWK48dt+GELSfszi6Dt66bF/d0gmnaQi0H80UxEIjbNLwOXWoE3xFZY2BK/
         w916a5fnQPFzDG8BH9lPfrjjTZy0416InXmV95Awl1wmAl8A+kLBeOskj1rCrvGZc3
         ebZ8Bo2JIeVUtvE9d6MBUPGb0zckWtN68eSK+KFr5ba/yvtjK7vcEiuMWIlPjlfNvB
         IpTpeF/kbqx7zpa2fSKPFmwbfjRVGpzhHPHNZsjCDzS3aFgcFp3TCOs16XoZsgIJE1
         +0+Et5adNEDbw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        romieu@fr.zoreil.com
Subject: [PATCH net-next 14/14] eth: velocity: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Wed, 27 Apr 2022 08:41:11 -0700
Message-Id: <20220427154111.529975-15-kuba@kernel.org>
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
CC: romieu@fr.zoreil.com
---
 drivers/net/ethernet/via/via-velocity.c | 3 +--
 drivers/net/ethernet/via/via-velocity.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index be2b992f24d9..ff0c102cb578 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2846,8 +2846,7 @@ static int velocity_probe(struct device *dev, int irq,
 
 	netdev->netdev_ops = &velocity_netdev_ops;
 	netdev->ethtool_ops = &velocity_ethtool_ops;
-	netif_napi_add(netdev, &vptr->napi, velocity_poll,
-							VELOCITY_NAPI_WEIGHT);
+	netif_napi_add(netdev, &vptr->napi, velocity_poll, NAPI_POLL_WEIGHT);
 
 	netdev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
 			   NETIF_F_HW_VLAN_CTAG_TX;
diff --git a/drivers/net/ethernet/via/via-velocity.h b/drivers/net/ethernet/via/via-velocity.h
index d3f960cc7c6e..c02a9654dce6 100644
--- a/drivers/net/ethernet/via/via-velocity.h
+++ b/drivers/net/ethernet/via/via-velocity.h
@@ -23,7 +23,6 @@
 #define VELOCITY_VERSION       "1.15"
 
 #define VELOCITY_IO_SIZE	256
-#define VELOCITY_NAPI_WEIGHT	64
 
 #define PKT_BUF_SZ          1540
 
-- 
2.34.1

