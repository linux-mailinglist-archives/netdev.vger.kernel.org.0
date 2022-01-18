Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD90491CB2
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350890AbiARDRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350241AbiARDIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:08:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE8CC06176F;
        Mon, 17 Jan 2022 18:49:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44DC5612CE;
        Tue, 18 Jan 2022 02:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175E4C36AEB;
        Tue, 18 Jan 2022 02:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474179;
        bh=MW15zVATQ0dCI6mJllBbFO3W70MaQcw1V1EXmb2mNIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0egMBMwnp/Fg5rmLanjUlbgyVr+cse3cRf/vlPB0N7G3P61EJ8D8ZM2njjdBaOEi
         Qn2hzsV8a+jkbzx0gDrD51PE5mUXN1p4mILXu/rcX5/eZ6+53mJvSbdZf2AScnsy0Y
         SE7NUi7V+C0/OqZdBivZakKpp78CLchIDsZ80Z8vm3Scw5VHAZceGN7kI6OGSuUBJg
         CRqnuSoxhKmbQc9EqoBQ9GT/4HbM1Pv57S73McjBoIxwTOuJl6xE6syQ+WnZVPJEAc
         gTjDsByChpGAlETBz9YzOKrCOovwxtGzVxS4zWs/DE4Fmprmrwa5oIRM8zbO6FFJm3
         yUIdjmGtIaUvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/56] 8390: hydra: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:48:22 -0500
Message-Id: <20220118024908.1953673-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024908.1953673-1-sashal@kernel.org>
References: <20220118024908.1953673-1-sashal@kernel.org>
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
index 8ae2491953019..ac452a370f239 100644
--- a/drivers/net/ethernet/8390/hydra.c
+++ b/drivers/net/ethernet/8390/hydra.c
@@ -117,6 +117,7 @@ static int hydra_init(struct zorro_dev *z)
     unsigned long ioaddr = board+HYDRA_NIC_BASE;
     const char name[] = "NE2000";
     int start_page, stop_page;
+    u8 macaddr[ETH_ALEN];
     int j;
     int err;
     struct ei_device *ei_local;
@@ -131,7 +132,8 @@ static int hydra_init(struct zorro_dev *z)
 	return -ENOMEM;
 
     for (j = 0; j < ETH_ALEN; j++)
-	dev->dev_addr[j] = *((u8 *)(board + HYDRA_ADDRPROM + 2*j));
+	macaddr[j] = *((u8 *)(board + HYDRA_ADDRPROM + 2*j));
+    eth_hw_addr_set(dev, macaddr);
 
     /* We must set the 8390 for word mode. */
     z_writeb(0x4b, ioaddr + NE_EN0_DCFG);
-- 
2.34.1

