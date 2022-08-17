Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9DC596594
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237728AbiHPWj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiHPWj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:39:56 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65B37963B;
        Tue, 16 Aug 2022 15:39:54 -0700 (PDT)
Received: from rustam-GF63-Thin-9RCX.. (unknown [136.169.224.60])
        by mail.ispras.ru (Postfix) with ESMTPSA id 0977B40D403E;
        Tue, 16 Aug 2022 22:39:48 +0000 (UTC)
From:   Rustam Subkhankulov <subkhankulov@ispras.ru>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Rustam Subkhankulov <subkhankulov@ispras.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org
Subject: [PATCH] net: dsa: sja1105: fix buffer overflow in sja1105_setup_devlink_regions()
Date:   Wed, 17 Aug 2022 03:38:45 +0300
Message-Id: <20220817003845.389644-1-subkhankulov@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an error occurs in dsa_devlink_region_create(), then 'priv->regions'
array will be accessed by negative index '-1'.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
Fixes: bf425b82059e ("net: dsa: sja1105: expose static config as devlink region")
---
 drivers/net/dsa/sja1105/sja1105_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index 0569ff066634..10c6fea1227f 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -93,7 +93,7 @@ static int sja1105_setup_devlink_regions(struct dsa_switch *ds)
 
 		region = dsa_devlink_region_create(ds, ops, 1, size);
 		if (IS_ERR(region)) {
-			while (i-- >= 0)
+			while (--i >= 0)
 				dsa_devlink_region_destroy(priv->regions[i]);
 			return PTR_ERR(region);
 		}
-- 
2.34.1

