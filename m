Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F164E7BC8
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiCZAFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 20:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCZAEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 20:04:39 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093D0F47;
        Fri, 25 Mar 2022 17:03:00 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 11A1F22247;
        Sat, 26 Mar 2022 01:02:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648252978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Sra84DTjE201brWQ8eofT4DMokoDMBWu7l5euKhvgwg=;
        b=IF4R6S91gD5IAM8wjUjG2NmHqv6sF16OxPyhxkdCwRdTsHewb3N9sRm4OsrLqu9RYrDFyG
        u+Jto63+MEOtA25hyCWhpgC1zFcBe2ZO2l6bFPXP+DZ9Yw/rNzEbSYmFEmsppLhaDlFVf5
        dEbei53s7npmWGXc/5iXIjuwqWdEZAc=
From:   Michael Walle <michael@walle.cc>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net] net: lan966x: fix kernel oops on ioctl when I/F is down
Date:   Sat, 26 Mar 2022 01:02:51 +0100
Message-Id: <20220326000251.2687897-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A SIOCGMIIPHY ioctl will cause a kernel oops when the interface is down.
Fix it by checking the state and if it's no running, return an error.

Fixes: 735fec995b21 ("net: lan966x: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP")
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index ec42e526f6fb..0adf49d19142 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -399,6 +399,9 @@ static int lan966x_port_ioctl(struct net_device *dev, struct ifreq *ifr,
 {
 	struct lan966x_port *port = netdev_priv(dev);
 
+	if (!netif_running(dev))
+		return -EINVAL;
+
 	if (!phy_has_hwtstamp(dev->phydev) && port->lan966x->ptp) {
 		switch (cmd) {
 		case SIOCSHWTSTAMP:
-- 
2.30.2

