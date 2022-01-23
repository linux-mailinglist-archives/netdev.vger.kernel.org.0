Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111F8496F20
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbiAWAQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:16:26 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46796 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235612AbiAWAOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:14:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E1E5FCE0AD9;
        Sun, 23 Jan 2022 00:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3F5C36AE3;
        Sun, 23 Jan 2022 00:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896869;
        bh=rm783gSObYHPebqbPrvhoi8P/3GU+Dnf/3HnG1sfW2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1g5e08oH8bq02A6Gl0WcV54ghDD3OkNtPGnKZFV34pb/oiGCm17oOzHLSvmz/fdT
         xSnd0ivkepEwl96LgCE2kNmgzqtNzN4v8S8EAkgkwMhD2nGSKgpVYjguBW1n6yfcrx
         8GHiZlszOW1sK5fUNyLZVa0lTvxNvvcmLljk8jk09zpW2fadObxOWx4tLpfz1yrJC0
         BmylErvhcOdeHdcHcnGGVymJkUQ9LLZpX7osWPks/z2leb58hIdvrMgx58QH+YAeXu
         02+z6f12hsJ03gM5/sT2TzmVaJWRP+Zr9t25678y5EnimdDCLSWUgDjhKfCvROkywK
         HvqGvWrhFbJYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, tanghui20@huawei.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/4] net: apple: bmac: Fix build since dev_addr constification
Date:   Sat, 22 Jan 2022 19:14:19 -0500
Message-Id: <20220123001423.2461009-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001423.2461009-1-sashal@kernel.org>
References: <20220123001423.2461009-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit ea938248557a52e231a31f338eac4baee36a8626 ]

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
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/apple/bmac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index ffa7e7e6d18d0..22a5d8bf555b0 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -1247,6 +1247,7 @@ static int bmac_probe(struct macio_dev *mdev, const struct of_device_id *match)
 	struct bmac_data *bp;
 	const unsigned char *prop_addr;
 	unsigned char addr[6];
+	u8 macaddr[6];
 	struct net_device *dev;
 	int is_bmac_plus = ((int)match->data) != 0;
 
@@ -1294,7 +1295,9 @@ static int bmac_probe(struct macio_dev *mdev, const struct of_device_id *match)
 
 	rev = addr[0] == 0 && addr[1] == 0xA0;
 	for (j = 0; j < 6; ++j)
-		dev->dev_addr[j] = rev ? bitrev8(addr[j]): addr[j];
+		macaddr[j] = rev ? bitrev8(addr[j]): addr[j];
+
+	eth_hw_addr_set(dev, macaddr);
 
 	/* Enable chip without interrupts for now */
 	bmac_enable_and_reset_chip(dev);
-- 
2.34.1

