Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C15B49170A
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345787AbiARCho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:37:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44883 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245162AbiARCeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:34:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DD46B8124E;
        Tue, 18 Jan 2022 02:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802B5C36AE3;
        Tue, 18 Jan 2022 02:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473211;
        bh=u5JUJtJGtwEbGCXg5DoXmcteX+k+OBcOtiqBHR/BRvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SF/TfakxD0dOMOtJqTpnL/XDUUi+2Dtii4T8nxKhkMLomb8hm0c2dJ7VwvjBeJwcC
         wMw7lGvOrXNQv75JVhc3fJT5e7gzxyUSzCbAzWua1PmMPF7XJkEE9MbyjE7r7ANoeh
         4P+sOcSPFbaAfJcdfkAhGNL0UM9AwWbsRFukdLGwFg+FE+KrhpOaJjAB5gYwCNVD+p
         Hb7vfh6XMZspieT6mvVx2MSAngeGGLBgS25B2r9zzIJsqE5hEeXflOUnbcFlAB652V
         PVjOcU4P79pM5wknWt/5ku7AcRRWIx4LE0Bdz492R8hv2WAvZjw4BkINPkJeGajQhv
         yXem9kR4gqw2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, tanghui20@huawei.com,
        arnd@arndb.de, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 028/188] amd: lance: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:29:12 -0500
Message-Id: <20220118023152.1948105-28-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0222ee53c483df7572eea7ba8585dda59328d46e ]

IO reads, so save to an array then eth_hw_addr_set().

Fixes build on x86 (32bit).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/lance.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
index 945bf1d875072..462016666752c 100644
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
2.34.1

