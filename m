Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D507456AB2
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhKSHNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233393AbhKSHNo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB9D261B3E;
        Fri, 19 Nov 2021 07:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305843;
        bh=laSwWRMmlBcBKM4pOM68Ipcnt0tEGw4dJJKzl31Sg3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTjqbd9yukTZmN2T34ggUOCE/MiRf8IX+8DddGCCLW52T/9qESJ85oQdNIfIOZLue
         aXn1DkXyQ3uiL76KTysz0eIvwQfGwDRk7F/ogatkciJg1UECYQiQtO5ZuprfLsMXxl
         da02HRQnXllwWzLt5aUL+BF3FK/9jVhbDDasJ4uqtv/9vzfkSLrEDYONFNqeCgWEj8
         Rzx2vZg9+Jh1Vqhp1UIhQBqk1MrMQPKhTRKtZ4cBXr8I8gAWfoAYp994ksgxUq0BFB
         7hqdWAqLjWg8RjCvuAHSzsL4TMwTDdC9zPASTnenQebla6GzPQDBAe4eifmgBE1/g/
         hpUCGrpDrjtuw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 08/15] 8390: hydra: use eth_hw_addr_set()
Date:   Thu, 18 Nov 2021 23:10:26 -0800
Message-Id: <20211119071033.3756560-9-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119071033.3756560-1-kuba@kernel.org>
References: <20211119071033.3756560-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Loop with offsetting to every second byte, so use a temp buffer.

Fixes m68k build.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/8390/hydra.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/hydra.c b/drivers/net/ethernet/8390/hydra.c
index 941754ea78ec..1df7601af86a 100644
--- a/drivers/net/ethernet/8390/hydra.c
+++ b/drivers/net/ethernet/8390/hydra.c
@@ -116,6 +116,7 @@ static int hydra_init(struct zorro_dev *z)
     unsigned long ioaddr = board+HYDRA_NIC_BASE;
     const char name[] = "NE2000";
     int start_page, stop_page;
+    u8 macaddr[ETH_ALEN];
     int j;
     int err;
 
@@ -129,7 +130,8 @@ static int hydra_init(struct zorro_dev *z)
 	return -ENOMEM;
 
     for (j = 0; j < ETH_ALEN; j++)
-	dev->dev_addr[j] = *((u8 *)(board + HYDRA_ADDRPROM + 2*j));
+	macaddr[j] = *((u8 *)(board + HYDRA_ADDRPROM + 2*j));
+    eth_hw_addr_set(dev, macaddr);
 
     /* We must set the 8390 for word mode. */
     z_writeb(0x4b, ioaddr + NE_EN0_DCFG);
-- 
2.31.1

