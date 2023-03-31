Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A806D18FB
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjCaHvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjCaHuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:50:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70E31D919;
        Fri, 31 Mar 2023 00:49:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91D116243A;
        Fri, 31 Mar 2023 07:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62B5C433EF;
        Fri, 31 Mar 2023 07:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680248966;
        bh=N52cquANgi8rH2muZ2w4PLKijbErjnK0PBHAsGbh9ZA=;
        h=From:To:Cc:Subject:Date:From;
        b=txDP4opP0hB4ki+4IXdW6ZBivfJPmobPRfqmXFKoadzILc7fafaku2vLt9m1dU71N
         KvtW8HNCEQfIsDb8aGnWq5ZabC6920pWQ1uGwV3LJKh1bEj/S/UUaMJAHvAgXdtzMk
         auA4i74PApfg9l/0yYBHwGHmWcRw32bNbaVJUwRes1ADjJluT9cyxOOc9xCfdHrvLv
         9jRpGDQUx1PplDu03B/KMzqTY8Bjibhc3qJ2BFxfIOScXWxpJuT59a7eNAH4Ky952r
         oDppEQm+oKN2gin7Noi125pvZtpjfD8vQdetVV02Iq/EvRaJNYRcW1u3FBd17RMAae
         v9qRmJ4zHL/QQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Jason Xing <kerneljasonxing@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: netcp: MAX_SKB_FRAGS is now 'int'
Date:   Fri, 31 Mar 2023 09:48:56 +0200
Message-Id: <20230331074919.1299425-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The type of MAX_SKB_FRAGS has changed recently, so the debug printk
needs to be updated:

drivers/net/ethernet/ti/netcp_core.c: In function 'netcp_create_interface':
drivers/net/ethernet/ti/netcp_core.c:2084:30: error: format '%ld' expects argument of type 'long int', but argument 3 has type 'int' [-Werror=format=]
 2084 |                 dev_err(dev, "tx-pool size too small, must be at least %ld\n",
      |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 3948b05950fd ("net: introduce a config option to tweak MAX_SKB_FRAGS")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/ti/netcp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index 1bb596a9d8a2..dfdbcdeb991f 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -2081,7 +2081,7 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 	netcp->tx_pool_region_id = temp[1];
 
 	if (netcp->tx_pool_size < MAX_SKB_FRAGS) {
-		dev_err(dev, "tx-pool size too small, must be at least %ld\n",
+		dev_err(dev, "tx-pool size too small, must be at least %d\n",
 			MAX_SKB_FRAGS);
 		ret = -ENODEV;
 		goto quit;
-- 
2.39.2

