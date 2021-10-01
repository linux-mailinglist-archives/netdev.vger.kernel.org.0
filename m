Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC67E41F6F8
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355632AbhJAVeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355542AbhJAVeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 17:34:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B182610A2;
        Fri,  1 Oct 2021 21:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633123953;
        bh=6cx8ggxzqc9m/D/YbelQC9guZeJsyaPdqqXezUeguGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDU+vsx6UlBuoLy6HR4A1ZhBdt92QsZfXfKn3wxcvYXmNinsTCg0WCOo8DGs5yTzP
         sZIX6vbfgxMQp6bQL1yegNbGvqz9Q3iZVkA6sp3wSMFHhPxIFp5umgLqJizBTqAeaa
         AZ7Xg/ED2tdZ2cAxPKpso7VfyorvQf6ZKZNpN2yAsp3s2sBzTueaDKFQ27MRaece72
         kcnhOF/zIEzSQV/hztE+8/5SpRTdOpcXSFIT5ZX1ROoU/O2ETr8hQN0vSqHxqSMv0o
         dmzYZyj7OKY8BdLpVCaExj6G5CJ1weA4/q+za2CpZnfHJATAn/+QlJTyzNXkwfCqkz
         RF+sd2UKibKVw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH net-next 01/11] arch: use eth_hw_addr_set()
Date:   Fri,  1 Oct 2021 14:32:18 -0700
Message-Id: <20211001213228.1735079-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001213228.1735079-1-kuba@kernel.org>
References: <20211001213228.1735079-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Convert misc arch drivers from memcpy(... ETH_ADDR) to eth_hw_addr_set():

  @@
  expression dev, np;
  @@
  - memcpy(dev->dev_addr, np, ETH_ALEN)
  + eth_hw_addr_set(dev, np)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-m68k@lists.linux-m68k.org
CC: Chris Zankel <chris@zankel.net>
CC: Max Filippov <jcmvbkbc@gmail.com>
CC: linux-xtensa@linux-xtensa.org
---
 arch/m68k/emu/nfeth.c               | 2 +-
 arch/xtensa/platforms/iss/network.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/emu/nfeth.c b/arch/m68k/emu/nfeth.c
index 79e55421cfb1..1a5d1e8eb4c8 100644
--- a/arch/m68k/emu/nfeth.c
+++ b/arch/m68k/emu/nfeth.c
@@ -200,7 +200,7 @@ static struct net_device * __init nfeth_probe(int unit)
 	dev->irq = nfEtherIRQ;
 	dev->netdev_ops = &nfeth_netdev_ops;
 
-	memcpy(dev->dev_addr, mac, ETH_ALEN);
+	eth_hw_addr_set(dev, mac);
 
 	priv = netdev_priv(dev);
 	priv->ethX = unit;
diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
index 4986226a5ab2..8b806d305948 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -467,7 +467,7 @@ static int iss_net_set_mac(struct net_device *dev, void *addr)
 	if (!is_valid_ether_addr(hwaddr->sa_data))
 		return -EADDRNOTAVAIL;
 	spin_lock_bh(&lp->lock);
-	memcpy(dev->dev_addr, hwaddr->sa_data, ETH_ALEN);
+	eth_hw_addr_set(dev, hwaddr->sa_data);
 	spin_unlock_bh(&lp->lock);
 	return 0;
 }
-- 
2.31.1

