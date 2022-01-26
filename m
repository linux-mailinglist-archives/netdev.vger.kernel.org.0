Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632CE49C039
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 01:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235362AbiAZAiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 19:38:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33922 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbiAZAiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 19:38:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31004B81B9E
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 00:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAC1C340ED;
        Wed, 26 Jan 2022 00:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643157486;
        bh=UYx5U1wg/JjtdQv0R5uX/+FrMhWvP4HtZiJJfP9ep18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qxp2M9TiuL4RSbr1rAIWxoPDu40LvlB1pG8/c5T6OMdFLwylz6g47hcgt+BIJr2Mb
         6z8PsaJ/QMwwnBBKnbi1bzy9jow3dC1uhFZlZueeKHtv9ixzb/xonKfsw5ucadYLw+
         aNQtw4jnnIPM+Oq4uflnIrZWBZmyBMoYfIYBGLxMh5DP4S7dRYrviIWUo6KTF9phWL
         EUZHKEPrMohjHYS7ZPHmcq3y86GiNWO7DIpcgGBGW5UWMV3KO+uAiyQZNFv/NBG725
         Wemrw2ZOWXQjhQhHeX7f3xDVdYE7VKAXmwIaDNj5ch6v/WTEJzTIfHpVJwazu0+wqg
         nz9zfs19ehEKQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dave@thedillows.org, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 4/6] ethernet: i825xx: don't write directly to netdev->dev_addr
Date:   Tue, 25 Jan 2022 16:37:59 -0800
Message-Id: <20220126003801.1736586-5-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126003801.1736586-1-kuba@kernel.org>
References: <20220126003801.1736586-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev->dev_addr is const now.

Compile tested rpc_defconfig w/ GCC 8.5.

Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/i825xx/ether1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
index c612ef526d16..3e7d7c4bafdc 100644
--- a/drivers/net/ethernet/i825xx/ether1.c
+++ b/drivers/net/ethernet/i825xx/ether1.c
@@ -986,6 +986,7 @@ static int
 ether1_probe(struct expansion_card *ec, const struct ecard_id *id)
 {
 	struct net_device *dev;
+	u8 addr[ETH_ALEN];
 	int i, ret = 0;
 
 	ether1_banner();
@@ -1015,7 +1016,8 @@ ether1_probe(struct expansion_card *ec, const struct ecard_id *id)
 	}
 
 	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = readb(IDPROM_ADDRESS + (i << 2));
+		addr[i] = readb(IDPROM_ADDRESS + (i << 2));
+	eth_hw_addr_set(dev, addr);
 
 	if (ether1_init_2(dev)) {
 		ret = -ENODEV;
-- 
2.34.1

