Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF63A54E01D
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 13:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376876AbiFPLhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 07:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376865AbiFPLhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 07:37:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553F8766B
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 04:37:35 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o1noV-00066v-DL; Thu, 16 Jun 2022 13:37:27 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o1noS-000rJi-Pu; Thu, 16 Jun 2022 13:37:26 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o1noT-003jnN-Gi; Thu, 16 Jun 2022 13:37:25 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v1 1/1] net: ag71xx: fix discards 'const' qualifier warning
Date:   Thu, 16 Jun 2022 13:37:24 +0200
Message-Id: <20220616113724.890970-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current kernel will compile this driver with warnings. This patch will
fix it.

drivers/net/ethernet/atheros/ag71xx.c: In function 'ag71xx_fast_reset':
drivers/net/ethernet/atheros/ag71xx.c:996:31: warning: passing argument 2 of 'ag71xx_hw_set
_macaddr' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
  996 |  ag71xx_hw_set_macaddr(ag, dev->dev_addr);
      |                            ~~~^~~~~~~~~~
drivers/net/ethernet/atheros/ag71xx.c:951:69: note: expected 'unsigned char *' but argument
 is of type 'const unsigned char *'
  951 | static void ag71xx_hw_set_macaddr(struct ag71xx *ag, unsigned char *mac)
      |                                                      ~~~~~~~~~~~~~~~^~~
drivers/net/ethernet/atheros/ag71xx.c: In function 'ag71xx_open':
drivers/net/ethernet/atheros/ag71xx.c:1441:32: warning: passing argument 2 of 'ag71xx_hw_se
t_macaddr' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
 1441 |  ag71xx_hw_set_macaddr(ag, ndev->dev_addr);
      |                            ~~~~^~~~~~~~~~
drivers/net/ethernet/atheros/ag71xx.c:951:69: note: expected 'unsigned char *' but argument
 is of type 'const unsigned char *'
  951 | static void ag71xx_hw_set_macaddr(struct ag71xx *ag, unsigned char *mac)
      |                                                      ~~~~~~~~~~~~~~~^~~

Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/ethernet/atheros/ag71xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index cac509708e9d..1c6ea6766aa1 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -946,7 +946,7 @@ static unsigned int ag71xx_max_frame_len(unsigned int mtu)
 	return ETH_HLEN + VLAN_HLEN + mtu + ETH_FCS_LEN;
 }
 
-static void ag71xx_hw_set_macaddr(struct ag71xx *ag, unsigned char *mac)
+static void ag71xx_hw_set_macaddr(struct ag71xx *ag, const unsigned char *mac)
 {
 	u32 t;
 
-- 
2.30.2

