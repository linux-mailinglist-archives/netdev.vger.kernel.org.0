Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78D2434F73
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 17:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhJTP6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 11:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhJTP6l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 11:58:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBBAD613A7;
        Wed, 20 Oct 2021 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634745386;
        bh=56uBqX54Cz8tzQrAtZG6EhGIGci5rVwdVzJNP6UWE3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSY52zE1Nb8aN1CLO63kJbAPvhfDLIFtmOcvnjLUSCUny+Z41Kpjo25hDcD8auaoD
         J63Vn0avR7uMtqeoi0KM8NOpvYyWoX0ACUGsxZS5gv1OTu28w4rREP7wtPKY59k1sN
         rOoI0Wg5Xt/8pbSht/3LzuhYEvpjPPOyZRJvCTJWbF9XDmLs51Qcd8zk5u4YIXOB0h
         ING3VydDzEKBffvHqA/4D+4AHuta0EJqq2cQ61oXAj/M8u8jUoShGauVmkDFvwIXFA
         5W57YGQhn7aLMIpSWxpdujN584c5jRB7A7ggovOJR7yfOcoKFNPntCShLsScjarDEb
         KSeJKb/qYKbIg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 07/12] net: fjes: constify and use eth_hw_addr_set()
Date:   Wed, 20 Oct 2021 08:56:12 -0700
Message-Id: <20211020155617.1721694-8-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020155617.1721694-1-kuba@kernel.org>
References: <20211020155617.1721694-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get it ready for constant netdev->dev_addr.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/fjes/fjes_hw.c   |  3 ++-
 drivers/net/fjes/fjes_hw.h   |  2 +-
 drivers/net/fjes/fjes_main.c | 14 ++++++++------
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/fjes/fjes_hw.c b/drivers/net/fjes/fjes_hw.c
index 065bb0a40b1d..704e949484d0 100644
--- a/drivers/net/fjes/fjes_hw.c
+++ b/drivers/net/fjes/fjes_hw.c
@@ -137,7 +137,8 @@ static void fjes_hw_free_epbuf(struct epbuf_handler *epbh)
 	epbh->ring = NULL;
 }
 
-void fjes_hw_setup_epbuf(struct epbuf_handler *epbh, u8 *mac_addr, u32 mtu)
+void fjes_hw_setup_epbuf(struct epbuf_handler *epbh, const u8 *mac_addr,
+			 u32 mtu)
 {
 	union ep_buffer_info *info = epbh->info;
 	u16 vlan_id[EP_BUFFER_SUPPORT_VLAN_MAX];
diff --git a/drivers/net/fjes/fjes_hw.h b/drivers/net/fjes/fjes_hw.h
index b4608ea2a2d5..997c7b37a402 100644
--- a/drivers/net/fjes/fjes_hw.h
+++ b/drivers/net/fjes/fjes_hw.h
@@ -330,7 +330,7 @@ int fjes_hw_register_buff_addr(struct fjes_hw *, int,
 int fjes_hw_unregister_buff_addr(struct fjes_hw *, int);
 void fjes_hw_init_command_registers(struct fjes_hw *,
 				    struct fjes_device_command_param *);
-void fjes_hw_setup_epbuf(struct epbuf_handler *, u8 *, u32);
+void fjes_hw_setup_epbuf(struct epbuf_handler *, const u8 *, u32);
 int fjes_hw_raise_interrupt(struct fjes_hw *, int, enum REG_ICTL_MASK);
 void fjes_hw_set_irqmask(struct fjes_hw *, enum REG_ICTL_MASK, bool);
 u32 fjes_hw_capture_interrupt_status(struct fjes_hw *);
diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index 185c8a398681..b06c17ac8d4e 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1203,6 +1203,7 @@ static int fjes_probe(struct platform_device *plat_dev)
 	struct net_device *netdev;
 	struct resource *res;
 	struct fjes_hw *hw;
+	u8 addr[ETH_ALEN];
 	int err;
 
 	err = -ENOMEM;
@@ -1266,12 +1267,13 @@ static int fjes_probe(struct platform_device *plat_dev)
 		goto err_free_control_wq;
 
 	/* setup MAC address (02:00:00:00:00:[epid])*/
-	netdev->dev_addr[0] = 2;
-	netdev->dev_addr[1] = 0;
-	netdev->dev_addr[2] = 0;
-	netdev->dev_addr[3] = 0;
-	netdev->dev_addr[4] = 0;
-	netdev->dev_addr[5] = hw->my_epid; /* EPID */
+	addr[0] = 2;
+	addr[1] = 0;
+	addr[2] = 0;
+	addr[3] = 0;
+	addr[4] = 0;
+	addr[5] = hw->my_epid; /* EPID */
+	eth_hw_addr_set(netdev, addr);
 
 	err = register_netdev(netdev);
 	if (err)
-- 
2.31.1

