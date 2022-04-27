Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E05511D4F
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240211AbiD0Pos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240070AbiD0Poo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:44:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415992E0AC;
        Wed, 27 Apr 2022 08:41:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EB33618DF;
        Wed, 27 Apr 2022 15:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB62CC385AC;
        Wed, 27 Apr 2022 15:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074085;
        bh=Z0xLbXX/H1N+jpH3VVNc2Ehyk/u94AsbE5Ev+LudcuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8TuRH4DIGORfU+hwQ+4vxUQEw5v7TMGR8fxtpHFJ6kbsdzGc0AX27Bfa2bPWCki5
         8nhCNP7IiIBTqsA6l3FAgmd1GmeqW6zkahTiRq6xthq6o3LY6dz/mqXjZt4LTkcXwO
         pXfJk2c66bvUxtP0nSUw8Htq4qS8BIwK7cJd5Xs8lrIFRg6e2Er68DjXZMUkvJZVqW
         jd/JDz3XkJOwpmbp8LEtiEXqSLNlJndRFgVUpy38/uXQoyXtkcP8RQVeg1KNAPxzUp
         KXv/vpluylvjGM/lWGmmOIBpZNs0grHM+nPj0LUASHZVZYQlcEjRE6FfgKW5ZKAqgd
         FjxQd9t2mBQpQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        linux-usb@vger.kernel.org
Subject: [PATCH net-next 06/14] usb: lan78xx: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Wed, 27 Apr 2022 08:41:03 -0700
Message-Id: <20220427154111.529975-7-kuba@kernel.org>
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
CC: woojung.huh@microchip.com
CC: UNGLinuxDriver@microchip.com
CC: linux-usb@vger.kernel.org
---
 drivers/net/usb/lan78xx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 415f16662f88..94e571fb61da 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -92,8 +92,6 @@
 					 WAKE_MCAST | WAKE_BCAST | \
 					 WAKE_ARP | WAKE_MAGIC)
 
-#define LAN78XX_NAPI_WEIGHT		64
-
 #define TX_URB_NUM			10
 #define TX_SS_URB_NUM			TX_URB_NUM
 #define TX_HS_URB_NUM			TX_URB_NUM
@@ -4376,7 +4374,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	netif_set_gso_max_size(netdev, LAN78XX_TSO_SIZE(dev));
 
-	netif_napi_add(netdev, &dev->napi, lan78xx_poll, LAN78XX_NAPI_WEIGHT);
+	netif_napi_add(netdev, &dev->napi, lan78xx_poll, NAPI_POLL_WEIGHT);
 
 	INIT_DELAYED_WORK(&dev->wq, lan78xx_delayedwork);
 	init_usb_anchor(&dev->deferred);
-- 
2.34.1

