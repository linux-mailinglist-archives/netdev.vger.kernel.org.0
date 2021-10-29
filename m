Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594B443F511
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 04:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhJ2Ctn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 22:49:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231594AbhJ2Ctl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 22:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 925E16117A;
        Fri, 29 Oct 2021 02:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635475633;
        bh=5Gb04qljygc1sXdir9npgitxUMTJpYlWA93roAIWTpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zctph1j7xP6VFIPEFiYPCJYqGOm8mVoN3pR8ORm8fWMKNAncfyEvllflplLVEzxpj
         KBnsUb2lLXNdGmoO5IhaUV8jJCCpsT35wdyjrQdcZy4ROzBTONR87B2y56RZaEhVSi
         sZ1XJhGqW72+YE9tm4qzoDudiWjlLC4UVVlkAlcecaE7cWCefblkoS57oOYDjkogxT
         IMSSe4OOlT6yZIRioAWvY69zQBFBNeDFOYANkST9kh6rf4gYA1Kafkuw4uJlagYRPO
         K2bwC2LkCgLi050DSMSJLE6uowQWl0VwDpn0DBE+ddQupgbq4zN7CEqZw2DFQ3x/M1
         kiIOpCN8eYR3g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        chris@zankel.net, jcmvbkbc@gmail.com, geert@linux-m68k.org,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH net-next 3/3] net: xtensa: use eth_hw_addr_set()
Date:   Thu, 28 Oct 2021 19:47:07 -0700
Message-Id: <20211029024707.316066-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029024707.316066-1-kuba@kernel.org>
References: <20211029024707.316066-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it go through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: chris@zankel.net
CC: jcmvbkbc@gmail.com
CC: geert@linux-m68k.org
CC: linux-xtensa@linux-xtensa.org
---
 arch/xtensa/platforms/iss/network.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
index 8b806d305948..962e5e145209 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -124,7 +124,7 @@ static char *split_if_spec(char *str, ...)
 
 static void setup_etheraddr(struct net_device *dev, char *str)
 {
-	unsigned char *addr = dev->dev_addr;
+	u8 addr[ETH_ALEN];
 
 	if (str == NULL)
 		goto random;
@@ -147,6 +147,7 @@ static void setup_etheraddr(struct net_device *dev, char *str)
 	if (!is_local_ether_addr(addr))
 		pr_warn("%s: assigning a globally valid ethernet address\n",
 			dev->name);
+	eth_hw_addr_set(dev, addr);
 	return;
 
 random:
-- 
2.31.1

