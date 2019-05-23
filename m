Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F418727C5F
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 14:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730732AbfEWMCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 08:02:44 -0400
Received: from first.geanix.com ([116.203.34.67]:60988 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730718AbfEWMCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 08:02:43 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 9CC971173;
        Thu, 23 May 2019 12:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1558612910; bh=4qHd8Py9Up+qZTBH6TcBDfKSmHpp4v/tKKzuTrnyayg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=SaXnObYzu6eGVxxRWGAjvw1VwK9pIMe87nh05+w8EmbgK4z8skYuqic6khjFx7h2K
         S2I+nK61H8PBRBu3wtK77mwo0HQtFYPIb+OhEdxiAx5MUwgJb5E5vBiAVhqw8xpOiS
         5ch5kIVOWPYK7rcVGM+Oi4X65oF4/yeIflIHqO7odryCv6EbyzgFqvfvQCV2kGpr3G
         /4FSMI1xy/4hcU/g4Jk7wYa90wMTET7u43QigNbT+x0YAzTWpcZopZByjkvqJyKden
         F4Ljg6HFOv1SneD7IpypXmtX0hTdcYXgmOpoKufFew/csKDormdgkpGXNF/3d8fty5
         8JXjBxqHi9KWQ==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        YueHaibing <yuehaibing@huawei.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Yang Wei <yang.wei9@zte.com.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] net: ll_temac: Enable multicast support
Date:   Thu, 23 May 2019 14:02:22 +0200
Message-Id: <20190523120222.3807-5-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523120222.3807-1-esben@geanix.com>
References: <20190523120222.3807-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 796779db2bec
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multicast support have been tested and is working now.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 75da604..5d8894d 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -21,7 +21,6 @@
  *
  * TODO:
  * - Factor out locallink DMA code into separate driver
- * - Fix multicast assignment.
  * - Fix support for hardware checksumming.
  * - Testing.  Lots and lots of testing.
  *
@@ -1096,6 +1095,7 @@ static const struct net_device_ops temac_netdev_ops = {
 	.ndo_open = temac_open,
 	.ndo_stop = temac_stop,
 	.ndo_start_xmit = temac_start_xmit,
+	.ndo_set_rx_mode = temac_set_multicast_list,
 	.ndo_set_mac_address = temac_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_do_ioctl = temac_ioctl,
@@ -1161,7 +1161,6 @@ static int temac_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
-	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
 	ndev->features = NETIF_F_SG;
 	ndev->netdev_ops = &temac_netdev_ops;
 	ndev->ethtool_ops = &temac_ethtool_ops;
-- 
2.4.11

