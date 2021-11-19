Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34A7456AB6
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhKSHNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233423AbhKSHNo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72D4461B64;
        Fri, 19 Nov 2021 07:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305843;
        bh=TxqNBJBlT2XdQaKwlwGhJXgWHKv9c3nsqPy6t9RMF60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUQMXs31n++jteL6HEbn4Y1WywzMdFpPyDl0udsg6m2Gby/hs+mVMroUmlu0kFUma
         PftOtjANpfRMkIYDXgL7uPlwv1uHgJxn6ZUMe8vNX1kiThCsSrLQbgWnXU18KCq1Sv
         +ous1ABH64AU265zQVuk+MzC9eaI7a6yTpJGBXMzzG0RTwHzXET1iEb24juW7yEP1W
         2GcX9Eq6x5Pk1L9r+aYFcsV6FlFvy+mXzeihshS0a57x8d6dZ1MOHC0I88x0GzvJJ2
         ymYU9zoN3AeGcNKoVeRkVw/coQ3+d4ECS6MIBrVcf3cO/yGB6XC2/UMuK/CsHl/0ot
         97TjEoaEKDprg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 10/15] 8390: wd: use eth_hw_addr_set()
Date:   Thu, 18 Nov 2021 23:10:28 -0800
Message-Id: <20211119071033.3756560-11-kuba@kernel.org>
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
 drivers/net/ethernet/8390/wd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/wd.c b/drivers/net/ethernet/8390/wd.c
index 263a942d81fa..5b00c452bede 100644
--- a/drivers/net/ethernet/8390/wd.c
+++ b/drivers/net/ethernet/8390/wd.c
@@ -168,6 +168,7 @@ static int __init wd_probe1(struct net_device *dev, int ioaddr)
 	int checksum = 0;
 	int ancient = 0;			/* An old card without config registers. */
 	int word16 = 0;				/* 0 = 8 bit, 1 = 16 bit */
+	u8 addr[ETH_ALEN];
 	const char *model_name;
 	static unsigned version_printed;
 	struct ei_device *ei_local = netdev_priv(dev);
@@ -191,7 +192,8 @@ static int __init wd_probe1(struct net_device *dev, int ioaddr)
 		netdev_info(dev, version);
 
 	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = inb(ioaddr + 8 + i);
+		addr[i] = inb(ioaddr + 8 + i);
+	eth_hw_addr_set(dev, addr);
 
 	netdev_info(dev, "WD80x3 at %#3x, %pM", ioaddr, dev->dev_addr);
 
-- 
2.31.1

