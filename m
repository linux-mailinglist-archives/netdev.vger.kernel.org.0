Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE1048E2DD
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 04:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238872AbiANDNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 22:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiANDNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 22:13:23 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D654C061574
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 19:13:23 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JZmb61hqyz4y4p;
        Fri, 14 Jan 2022 14:13:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1642130002;
        bh=MExLlyR/IIOT8iKRlVUozzhk69cJA71E8WLPA3pYsr0=;
        h=From:To:Cc:Subject:Date:From;
        b=rQxcnPVbHMqRxsWjfshGsSEMtu4UAgGb+W0Iy3IawfURtDeD1E+PQeVqRiYlpiefr
         9VZjtTZAEVdAi+OdGYU7egzLSRxMZ3dimz6MwbYcAZxxc/lnNCIhz/ffS7WlecxqYu
         n/fFpjq8w9G04T3dA2QTxeWaFPkGceZzxv6P8cRcAiQFQyxUgEOxXsS89N2b+tHs3u
         dM0DVJDeNjuamofLuPLjEiZ7tTJS+tURezzCCpL0ehmtBtWgdjErsjJriqpOuWu71J
         QN0EExFJnYh6p2BER9Xx4pEkTQhCyWY5EatHQnjc9ZmTBJHmp1uZappiZ8nmoRe3FP
         hrXPZKiqyZdSA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
Cc:     <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH] net: apple: bmac: Fix build since dev_addr constification
Date:   Fri, 14 Jan 2022 14:13:16 +1100
Message-Id: <20220114031316.2419293-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit adeef3e32146 ("net: constify netdev->dev_addr") the bmac
driver no longer builds with the following errors (pmac32_defconfig):

  linux/drivers/net/ethernet/apple/bmac.c: In function ‘bmac_probe’:
  linux/drivers/net/ethernet/apple/bmac.c:1287:20: error: assignment of read-only location ‘*(dev->dev_addr + (sizetype)j)’
   1287 |   dev->dev_addr[j] = rev ? bitrev8(addr[j]): addr[j];
        |                    ^

Fix it by making the modifications to a local macaddr variable and then
passing that to eth_hw_addr_set().

We don't use the existing addr variable because the bitrev8() would
mutate it, but it is already used unreversed later in the function.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 drivers/net/ethernet/apple/bmac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index 9a650d1c1bdd..4d2ba30c2fbd 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -1237,6 +1237,7 @@ static int bmac_probe(struct macio_dev *mdev, const struct of_device_id *match)
 	struct bmac_data *bp;
 	const unsigned char *prop_addr;
 	unsigned char addr[6];
+	u8 macaddr[6];
 	struct net_device *dev;
 	int is_bmac_plus = ((int)match->data) != 0;
 
@@ -1284,7 +1285,9 @@ static int bmac_probe(struct macio_dev *mdev, const struct of_device_id *match)
 
 	rev = addr[0] == 0 && addr[1] == 0xA0;
 	for (j = 0; j < 6; ++j)
-		dev->dev_addr[j] = rev ? bitrev8(addr[j]): addr[j];
+		macaddr[j] = rev ? bitrev8(addr[j]): addr[j];
+
+	eth_hw_addr_set(dev, macaddr);
 
 	/* Enable chip without interrupts for now */
 	bmac_enable_and_reset_chip(dev);
-- 
2.31.1

