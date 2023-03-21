Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2BC6C2F1D
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 11:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjCUKfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 06:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjCUKfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 06:35:05 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A221B460A6
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 03:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=6Xbm1i+ZctTp969vSxK1Mnvjcih
        OsRb3M30FMrJKIng=; b=Lm6282Oh3FSc3beYOp09NZn5ZN1iwq/pkKACOnCnr2s
        jxo3sbEZOWM/tc0Fot+OHm8mt5rcVoeczcqMT3btZithWV8c+521cxX3AZMiwEve
        h0Pd3WHje+4xz6+0hHIHi36plt/yKnkoZqSLHozEFj3dKEP46PJEyV3Eoyq3GVKQ
        =
Received: (qmail 1242564 invoked from network); 21 Mar 2023 11:34:00 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 21 Mar 2023 11:34:00 +0100
X-UD-Smtp-Session: l3s3148p1@Y/LmlGb3aMcujnv6
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] ravb: assert PHY reset during probe
Date:   Tue, 21 Mar 2023 11:33:57 +0100
Message-Id: <20230321103357.18940-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The problem: Kernel+initramfs got loaded via TFTP by the bootloader,
thus the PHY reset is deasserted during boot. When suspend is entered
without bringing the interface up before, PHY reset is still deasserted.
Our KSZ9031 PHY doesn't like being suspended with reset deasserted, at
all. When resuming and trying to bring the interface up, we get MDIO bus
timeouts or stalled PHYs, depending on the board.

Once the interface was up once, reset handling is correct. PHY reset is
asserted before suspending. But if it wasn't up, there is this problem.

First, I tried to have a full reset cycle in phy_hw_init() like [1]. But
as expressed there, I had also worries about regressions for other PHYs.

This patch here assumes that the MAC should take care of it after it
claimed responsibility for the PHY PM by setting 'mac_managed_pm'. I am
not sure this is the right layer, though? But I am not sure where to put
it otherwise. Maybe we need something like phy_reset_after_power_on() as
proposed in [2] after all? I'd like to avoid pushing the responsibility
to the firmware but rather let Linux be more robust.

This patch depends on v6.3-rc3 or 7f5ebf5dae42 ("ravb: avoid PHY being
resumed when interface is not up").

Really looking forward to comments or pointers!

Thanks in advance and happy hacking,

   Wolfram

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20211211130146.357794-1-francesco.dolcini@toradex.com/
[2] https://patchwork.kernel.org/project/netdevbpf/list/?series=595347&state=*

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 894e2690c643..d26944c0d4c8 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2404,6 +2404,7 @@ static int ravb_mdio_init(struct ravb_private *priv)
 	phydev = of_phy_find_device(pn);
 	if (phydev) {
 		phydev->mac_managed_pm = true;
+		phy_device_reset(phydev, 1);
 		put_device(&phydev->mdio.dev);
 	}
 	of_node_put(pn);
-- 
2.30.2

