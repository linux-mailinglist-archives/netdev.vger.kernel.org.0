Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A34456AB3
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhKSHNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233161AbhKSHNo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AE5761B6F;
        Fri, 19 Nov 2021 07:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305843;
        bh=RHGoinQWEq/yoEe0JQkSZCW9Hat60Rmg5zLkUgwVRqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8ONZ98jvFmqKGSSLUyZUH5K2uf6E5hVYMQT1NsKW5rCbvYWdMERwtCB1yu78M/gE
         tT6biGJTHyQci6w849lzrBbjoOlNOLJfTvIN3s4L2J3ajeYVNxsTBKzvcgAQNwszLx
         mZwZ/wPD/2bfFtRKLMenn+SEJKhuog3sQpjg0PB9N526vstesMuSA+4tQ4VyDOHFl0
         O+VKQDJg0BCqkyO/RaB8BNurDdcyiOr2dkKXYVoKYTq5XvrZKTc9DrI2j9c+VxCw8d
         rpFZXPJVsQ2lvreFCjWAfdC530ZnHx/SIjVJXysW8SfT74e1jet0PD5HLvOXHljIEd
         vES1ALqHcZFhQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 09/15] 8390: mac8390: use eth_hw_addr_set()
Date:   Thu, 18 Nov 2021 23:10:27 -0800
Message-Id: <20211119071033.3756560-10-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119071033.3756560-1-kuba@kernel.org>
References: <20211119071033.3756560-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use temp to pass to the reading function, the function is generic
so can't fix there.

Fixes m68k build.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/8390/mac8390.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/mac8390.c b/drivers/net/ethernet/8390/mac8390.c
index 91b04abfd687..7fb819b9b89a 100644
--- a/drivers/net/ethernet/8390/mac8390.c
+++ b/drivers/net/ethernet/8390/mac8390.c
@@ -292,6 +292,7 @@ static bool mac8390_rsrc_init(struct net_device *dev,
 	struct nubus_dirent ent;
 	int offset;
 	volatile unsigned short *i;
+	u8 addr[ETH_ALEN];
 
 	dev->irq = SLOT2IRQ(board->slot);
 	/* This is getting to be a habit */
@@ -314,7 +315,8 @@ static bool mac8390_rsrc_init(struct net_device *dev,
 		return false;
 	}
 
-	nubus_get_rsrc_mem(dev->dev_addr, &ent, 6);
+	nubus_get_rsrc_mem(addr, &ent, 6);
+	eth_hw_addr_set(dev, addr);
 
 	if (useresources[cardtype] == 1) {
 		nubus_rewinddir(&dir);
-- 
2.31.1

