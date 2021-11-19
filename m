Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC79456AB0
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhKSHNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233322AbhKSHNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AFEF61B5F;
        Fri, 19 Nov 2021 07:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305842;
        bh=DChFBGcSSk5zCEztXsXF6Wc0kz44CVAWmUR83Jhu06A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEmC+tm3PLoY/NJg05Ij6vJ08gu/ZN21BcfRhxgTYyTIHdQ3qtM2hZMNUmRsCB3e8
         C8qag1l19kwYj2NLAO9AMIijD4uZA6fp9MVFkr7PLrRwPCET5QhUjQU7DUzy2y6Hmu
         TOpmDB97kKRq7CYK0zlReymTDXmOWIQ+EfQ+VbQP1YC/fHzr5sWuEGVZEKTfxda17e
         PFXMyHHC5X9K6bQuCiJuN4UUwzT7XUtLQfTg/Gwk2xGzmhLIlpJGgvB0o23ZsQI0To
         rzb+avfc9mWAdRiql0RNBPw/NrP83XiqXe5OokPdVngy7L3OjRKytAVf1JG8c6ipca
         DurQmk8fR6H4w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/15] amd: mvme147: use eth_hw_addr_set()
Date:   Thu, 18 Nov 2021 23:10:24 -0800
Message-Id: <20211119071033.3756560-7-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119071033.3756560-1-kuba@kernel.org>
References: <20211119071033.3756560-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Byte by byte assignments.

Fixes build on m68k.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/mvme147.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amd/mvme147.c b/drivers/net/ethernet/amd/mvme147.c
index da97fccea9ea..410c7b67eba4 100644
--- a/drivers/net/ethernet/amd/mvme147.c
+++ b/drivers/net/ethernet/amd/mvme147.c
@@ -74,6 +74,7 @@ static struct net_device * __init mvme147lance_probe(void)
 	static int called;
 	static const char name[] = "MVME147 LANCE";
 	struct m147lance_private *lp;
+	u8 macaddr[ETH_ALEN];
 	u_long *addr;
 	u_long address;
 	int err;
@@ -93,15 +94,16 @@ static struct net_device * __init mvme147lance_probe(void)
 
 	addr = (u_long *)ETHERNET_ADDRESS;
 	address = *addr;
-	dev->dev_addr[0] = 0x08;
-	dev->dev_addr[1] = 0x00;
-	dev->dev_addr[2] = 0x3e;
+	macaddr[0] = 0x08;
+	macaddr[1] = 0x00;
+	macaddr[2] = 0x3e;
 	address = address >> 8;
-	dev->dev_addr[5] = address&0xff;
+	macaddr[5] = address&0xff;
 	address = address >> 8;
-	dev->dev_addr[4] = address&0xff;
+	macaddr[4] = address&0xff;
 	address = address >> 8;
-	dev->dev_addr[3] = address&0xff;
+	macaddr[3] = address&0xff;
+	eth_hw_addr_set(dev, macaddr);
 
 	printk("%s: MVME147 at 0x%08lx, irq %d, Hardware Address %pM\n",
 	       dev->name, dev->base_addr, MVME147_LANCE_IRQ,
-- 
2.31.1

