Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555C449147C
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244992AbiARCW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244794AbiARCVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:21:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A60C061749;
        Mon, 17 Jan 2022 18:21:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8958612CD;
        Tue, 18 Jan 2022 02:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4DCC36AE3;
        Tue, 18 Jan 2022 02:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472502;
        bh=dARacxu/D/r3/qAKRLXt0JAPblqXXdVmv79AzCb4CkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVPcSVPuyjYNJqLm9pXpVDJv25MJzQaHu/ywoKuxzk9J/2dtqfvp2GgXMV9+v73Np
         jZErfHmvR31c8EqoTifb3wRBt0zALiop0NSRLZrJ+ePU59n1AItTUzaAXaUFluD7HZ
         PutHXwSx6MBqKGzU5a4KY/+T2S+UImxjqHaJBScorLIdcxG8f/aFSkqANwT2+K3/0u
         JUbCojgmWzawDi35rzW9T/vvKfztTkt+Hnzfuzg05g2xiZSe61kmPTHuWZuSR+q/sN
         a1ZCgUv4+I7Iob5R/GG1wQUdcdZ2/B1N0CaMNWtr9sKcCyIj06M1Sjl9/in0EwngOH
         Gw2cRy1KMPKCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, arnd@arndb.de,
        linux@roeck-us.net, tanghui20@huawei.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 035/217] amd: ni65: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:16:38 -0500
Message-Id: <20220118021940.1942199-35-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 69ede3097b871dbc793dd6e21f38fde56d273963 ]

IO reads, so save to an array then eth_hw_addr_set().

Fixes build on x86 (32bit).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/ni65.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/ni65.c b/drivers/net/ethernet/amd/ni65.c
index 032e8922b4829..8ba579b89b758 100644
--- a/drivers/net/ethernet/amd/ni65.c
+++ b/drivers/net/ethernet/amd/ni65.c
@@ -251,7 +251,7 @@ static void ni65_recv_intr(struct net_device *dev,int);
 static void ni65_xmit_intr(struct net_device *dev,int);
 static int  ni65_open(struct net_device *dev);
 static int  ni65_lance_reinit(struct net_device *dev);
-static void ni65_init_lance(struct priv *p,unsigned char*,int,int);
+static void ni65_init_lance(struct priv *p,const unsigned char*,int,int);
 static netdev_tx_t ni65_send_packet(struct sk_buff *skb,
 				    struct net_device *dev);
 static void  ni65_timeout(struct net_device *dev, unsigned int txqueue);
@@ -418,6 +418,7 @@ static int __init ni65_probe1(struct net_device *dev,int ioaddr)
 {
 	int i,j;
 	struct priv *p;
+	u8 addr[ETH_ALEN];
 	unsigned long flags;
 
 	dev->irq = irq;
@@ -444,7 +445,8 @@ static int __init ni65_probe1(struct net_device *dev,int ioaddr)
 		return -ENODEV;
 
 	for(j=0;j<6;j++)
-		dev->dev_addr[j] = inb(ioaddr+cards[i].addr_offset+j);
+		addr[j] = inb(ioaddr+cards[i].addr_offset+j);
+	eth_hw_addr_set(dev, addr);
 
 	if( (j=ni65_alloc_buffer(dev)) < 0) {
 		release_region(ioaddr, cards[i].total_size);
@@ -566,7 +568,7 @@ static int __init ni65_probe1(struct net_device *dev,int ioaddr)
 /*
  * set lance register and trigger init
  */
-static void ni65_init_lance(struct priv *p,unsigned char *daddr,int filter,int mode)
+static void ni65_init_lance(struct priv *p,const unsigned char *daddr,int filter,int mode)
 {
 	int i;
 	u32 pib;
-- 
2.34.1

