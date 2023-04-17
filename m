Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1626E5370
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 22:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjDQU6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 16:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjDQU6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 16:58:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D039747;
        Mon, 17 Apr 2023 13:56:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF82062A6A;
        Mon, 17 Apr 2023 20:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C33C433EF;
        Mon, 17 Apr 2023 20:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681764937;
        bh=buAWzCxZJq6sFI4FVlHCCkhTeXIXRB+HhrOpnqKq2Bo=;
        h=From:To:Cc:Subject:Date:From;
        b=Yi/vRXGl+Fe7SQP2xUdVEqghN1XlXMudVEM97w32prLWMGIYMUIuY0ZcCTdrbu1f5
         J9NkrHqcnFDdmdDp5Pd8Hsf/BGymT+zhvTr/0cTdnZQBTNLlUUdicBBLFR95ShPeA9
         K65/Nr7u7QJ4b/afXFxmGEQsGyxp5wjCRicJt/FpnnRTOR3K8pmhLn9BXllMawhzAe
         S5t2qDBsXvyjNSX3CY9IjGwiBm8UZCA7P2SdwDHuwq4eN4mNjKDsb9ZkEVJCpHLrcZ
         +MldcW6U/WPovGo6wYxJztk4NxK2ZvwjjnTJ3zp+JHeywP0t9UXrYcrYR2Fc0W1RIj
         7mB6ACQheIrkA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: mscc: ocelot: remove incompatible prototypes
Date:   Mon, 17 Apr 2023 22:55:25 +0200
Message-Id: <20230417205531.1880657-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
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

From: Arnd Bergmann <arnd@arndb.de>

The types for the register argument changed recently, but there are
still incompatible prototypes that got left behind, and gcc-13 warns
about these:

In file included from drivers/net/ethernet/mscc/ocelot.c:13:
drivers/net/ethernet/mscc/ocelot.h:97:5: error: conflicting types for 'ocelot_port_readl' due to enum/integer mismatch; have 'u32(struct ocelot_port *, u32)' {aka 'unsigned int(struct ocelot_port *, unsigned int)'} [-Werror=enum-int-mismatch]
   97 | u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
      |     ^~~~~~~~~~~~~~~~~

Just remove the two prototypes, and rely on the copy in the global
header.

Fixes: 9ecd05794b8d ("net: mscc: ocelot: strengthen type of "u32 reg" in I/O accessors")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mscc/ocelot.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index d920ca930690..ed024d6504c5 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -94,9 +94,6 @@ int ocelot_mact_forget(struct ocelot *ocelot,
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
 int ocelot_netdev_to_port(struct net_device *dev);
 
-u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
-void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
-
 int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		      struct device_node *portnp);
 void ocelot_release_port(struct ocelot_port *ocelot_port);
-- 
2.39.2

