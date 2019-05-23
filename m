Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C852E27C59
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 14:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730649AbfEWMCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 08:02:30 -0400
Received: from first.geanix.com ([116.203.34.67]:60910 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728309AbfEWMC2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 08:02:28 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 649FD1162;
        Thu, 23 May 2019 12:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1558612896; bh=MDlnZg47ZOo1eOdvw026imEu0K7kavspLfqysAaRDCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=QRLMv9AMR6yu/5Zzc8RgovsdLZC8PkNs4o1vvs97Tip96nUDXnGrxhI+t4E2XBpK4
         TcgfJAWHa/HoNDWGwUPckipLHoyGZGRSYJj6s2WEqEUb227PV4B3RjGNlGQ/TMNNdx
         nIXZAT5C7KzyR30A6xm7oSnjOGQVWEcFEHHUOpkzwUQr0s3YGYgj/dWxgJezu4mPRg
         WZs0/oYLnbysyqF2Eyk7bkJNK+IRDud3+9lyZH6yCeQkMlXJsyFo2MuTOk0J+wtSUP
         pf8RuHPNZoJylFBGaz+NhHV6ckgChrz186NTPFphOQV6PBmEzb2kIe5W3L5eJDxZhs
         vrrIX6uTdWSSg==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        YueHaibing <yuehaibing@huawei.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] net: ll_temac: Do not make promiscuous mode sticky on multicast
Date:   Thu, 23 May 2019 14:02:19 +0200
Message-Id: <20190523120222.3807-2-esben@geanix.com>
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

When user has requested IFF_ALLMULTI or have set more than 4 multicast
addresses, we should just use promiscuous mode, but not set it in flags,
as it causes the interface to stay in promiscuous mode even when the
non-IFF_PROMISC condition that caused promiscuous mode to be enabled
has gone away.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 47c4515..05195ff 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -388,13 +388,6 @@ static void temac_set_multicast_list(struct net_device *ndev)
 	mutex_lock(lp->indirect_mutex);
 	if (ndev->flags & (IFF_ALLMULTI | IFF_PROMISC) ||
 	    netdev_mc_count(ndev) > MULTICAST_CAM_TABLE_NUM) {
-		/*
-		 *	We must make the kernel realise we had to move
-		 *	into promisc mode or we start all out war on
-		 *	the cable. If it was a promisc request the
-		 *	flag is already set. If not we assert it.
-		 */
-		ndev->flags |= IFF_PROMISC;
 		temac_indirect_out32(lp, XTE_AFM_OFFSET, XTE_AFM_EPPRM_MASK);
 		dev_info(&ndev->dev, "Promiscuous mode enabled.\n");
 	} else if (!netdev_mc_empty(ndev)) {
-- 
2.4.11

