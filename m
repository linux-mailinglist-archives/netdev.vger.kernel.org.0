Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FB049171B
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344865AbiARChh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:37:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51206 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343933AbiARCd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:33:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E9F2611DC;
        Tue, 18 Jan 2022 02:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719E1C36AE3;
        Tue, 18 Jan 2022 02:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473235;
        bh=lCt6s1XiY9IrHfXCjB2XzdbfCwBwul/BJaocMzVH0cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5WLvXyUyc+wn5jjfDCf2eQCmeJVKvVc6gwf1RnHOdHDTbqRvO/I6rPBUTXW7/I6o
         RFFsy5l91HZhyrUrGisJ5dRFo1CslWS67B6d4BpGNcXi+5cgLsLJLvqJVzU8UmfJrl
         2Wr/YobRvxQYCBZ879ReKjZqQarjOD1Kvq+JXlgt9WQrgkXzFsuvQqAZbo4ja5qCUF
         0KTj4njIPf+N3CUc1RqFy25JZ6WurH5xgeCkaVCjmy+hoqSil69gIcPWy3UfE0Mq/m
         RwgfOCblc5MX7qRyGzMBFEusm5U+uMrQJ2elXBGzuMvqgkv3JcguEpleGu/niqmNS5
         OKajIXyIwTPcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 035/188] 8390: hydra: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:29:19 -0500
Message-Id: <20220118023152.1948105-35-sashal@kernel.org>
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

[ Upstream commit d7d28e90e229a8af0472421015c5828f5cd1ad2e ]

Loop with offsetting to every second byte, so use a temp buffer.

Fixes m68k build.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/8390/hydra.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/hydra.c b/drivers/net/ethernet/8390/hydra.c
index 941754ea78ecf..1df7601af86a4 100644
--- a/drivers/net/ethernet/8390/hydra.c
+++ b/drivers/net/ethernet/8390/hydra.c
@@ -116,6 +116,7 @@ static int hydra_init(struct zorro_dev *z)
     unsigned long ioaddr = board+HYDRA_NIC_BASE;
     const char name[] = "NE2000";
     int start_page, stop_page;
+    u8 macaddr[ETH_ALEN];
     int j;
     int err;
 
@@ -129,7 +130,8 @@ static int hydra_init(struct zorro_dev *z)
 	return -ENOMEM;
 
     for (j = 0; j < ETH_ALEN; j++)
-	dev->dev_addr[j] = *((u8 *)(board + HYDRA_ADDRPROM + 2*j));
+	macaddr[j] = *((u8 *)(board + HYDRA_ADDRPROM + 2*j));
+    eth_hw_addr_set(dev, macaddr);
 
     /* We must set the 8390 for word mode. */
     z_writeb(0x4b, ioaddr + NE_EN0_DCFG);
-- 
2.34.1

