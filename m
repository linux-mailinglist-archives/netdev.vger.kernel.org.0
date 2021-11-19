Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5CB456AAC
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhKSHNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233319AbhKSHNm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 170EA61B3E;
        Fri, 19 Nov 2021 07:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305841;
        bh=0+gPC5VxND32PeDsna8O8iQ7M0U2V298ZHgAmuh9PUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+nnGMnvqih8INvEoWr+Qy3KyCp2m/POa8s3c2NvRM/fycGCWhb3hPOoKNatqw8SV
         s3XbFMcMn++69w9uCmrVPE8P23yUfvRJP+0eHO0Xueao15c5JMMKVvYGrrUNWC0hVs
         eROW7jFzkbE6sFHlGSOmTeVy2A2D0dHoWH1eVinn9CqFsRPb6bd4WIwlPKa7o47uHL
         Ja98VQLR+2G7XFNQi5CeDYzjZQ+W0ha4V+bTzeEXIyCmIkLZX+081xhMz5sBpDRoWQ
         KIt35OIWacmKOoSvUfYhnYFVwKxQAbuKDNiKva3jkSh27pf66lcuLs9IVVW6GX7VKo
         7ReuF1Yki1A2A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/15] amd: ni65: use eth_hw_addr_set()
Date:   Thu, 18 Nov 2021 23:10:20 -0800
Message-Id: <20211119071033.3756560-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119071033.3756560-1-kuba@kernel.org>
References: <20211119071033.3756560-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IO reads, so save to an array then eth_hw_addr_set().

Fixes build on x86 (32bit).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/ni65.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/ni65.c b/drivers/net/ethernet/amd/ni65.c
index 032e8922b482..8ba579b89b75 100644
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
2.31.1

