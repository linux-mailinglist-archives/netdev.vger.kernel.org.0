Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4585B456AAB
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhKSHNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233161AbhKSHNm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C207361AF0;
        Fri, 19 Nov 2021 07:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305840;
        bh=c+9XSv3MXOShW8sK+6VJvNzYASuMIQ7bNqQjveyZ+QE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MfK2wzvjUvvQMZu4kEzcFRFKrnSkokZaAvfGWSTw1/zryYcgsxAJSfOtixN6OoN1H
         Oaxi8O5lZb6d9OGlhiiMr8pleEC1Ksw2+ST78H1NwhK16AVv/cJpnpYv04uBN3duZv
         rsTXAV5+/4DxweOjAryxxD1S3E/K8nrKp9L/KfTY0l0uGWzmGxDQecXA4CZCh6QfZ1
         abvhY0nPgVlS7hJvHGoKInmBKugnkj1BBeexU2Yd1vMorT07u5//f7MUQS70cO6Gm9
         BA6yQKNrUJcu62c8XuLrc041dUHGLxBs5iRDh6ZkTiTxatwIqXXNYhmXLszBC1vHh3
         6z90IbsWUvgCQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 01/15] amd: lance: use eth_hw_addr_set()
Date:   Thu, 18 Nov 2021 23:10:19 -0800
Message-Id: <20211119071033.3756560-2-kuba@kernel.org>
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
 drivers/net/ethernet/amd/lance.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
index 945bf1d87507..462016666752 100644
--- a/drivers/net/ethernet/amd/lance.c
+++ b/drivers/net/ethernet/amd/lance.c
@@ -480,6 +480,7 @@ static int __init lance_probe1(struct net_device *dev, int ioaddr, int irq, int
 	unsigned long flags;
 	int err = -ENOMEM;
 	void __iomem *bios;
+	u8 addr[ETH_ALEN];
 
 	/* First we look for special cases.
 	   Check for HP's on-board ethernet by looking for 'HP' in the BIOS.
@@ -541,7 +542,8 @@ static int __init lance_probe1(struct net_device *dev, int ioaddr, int irq, int
 	/* There is a 16 byte station address PROM at the base address.
 	   The first six bytes are the station address. */
 	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = inb(ioaddr + i);
+		addr[i] = inb(ioaddr + i);
+	eth_hw_addr_set(dev, addr);
 	printk("%pM", dev->dev_addr);
 
 	dev->base_addr = ioaddr;
-- 
2.31.1

