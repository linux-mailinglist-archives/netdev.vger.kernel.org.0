Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C144BD6E5
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 08:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345857AbiBUHK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 02:10:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345851AbiBUHK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 02:10:27 -0500
X-Greylist: delayed 2695 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 20 Feb 2022 23:10:04 PST
Received: from mailserv1.kapsi.fi (mailserv1.kapsi.fi [IPv6:2001:67c:1be8::25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6591EE51
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 23:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ext.kapsi.fi; s=20161220; h=Subject:Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ezO+Ykxw2lF1+hzaNXBvIIokwHtrg1e//PjeuJdwFNw=; b=ONX2M/tcAQIUSGst0+pxsQpg5d
        vniSTTFX+LNxdunbhn6voPqd9r2Gvu7U7QT96U9D84bQAliRWOIbIZa+kvQN33v24OOXHcFjdCu8O
        10FWeUvL0MeUL0M2BkimsAFHPKFGProWUjFeh9KDrk16xotBta22sY15BIrqoyUq1hOPViHJQpgqV
        hrwi4aefsfkBcitv/iCVxI0s6d5sQHida4YSPhQAKWfPM9y24dCZFA0YV20FBEdQhiKNZndOoInvb
        h2uZsiO93lfQjzDhyb7BVbHYBerq+SVjzT2CYXa8qMl0SK3NR7bywbuZF8LPNxm+IyZG5bKK/WZEZ
        CaC/97nA==;
Received: from 15-28-196-88.dyn.estpak.ee ([88.196.28.15]:49910 helo=localhost)
        by mailserv1.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <maukka@ext.kapsi.fi>)
        id 1nM287-0002PA-8S; Mon, 21 Feb 2022 08:25:04 +0200
Received: by localhost (sSMTP sendmail emulation); Mon, 21 Feb 2022 08:24:52 +0200
From:   Mauri Sandberg <maukka@ext.kapsi.fi>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauri Sandberg <maukka@ext.kapsi.fi>
Date:   Mon, 21 Feb 2022 08:24:41 +0200
Message-Id: <20220221062441.2685-1-maukka@ext.kapsi.fi>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 88.196.28.15
X-SA-Exim-Mail-From: maukka@ext.kapsi.fi
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
Subject: [PATCH] net: mv643xx_eth: handle EPROBE_DEFER
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on mailserv1.kapsi.fi)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Obtaining MAC address may be deferred in cases when the MAC is stored
in NVMEM block and it may now be ready upon the first retrieval attempt
returing EPROBE_DEFER. Handle it here and leave logic otherwise as it
was.

Signed-off-by: Mauri Sandberg <maukka@ext.kapsi.fi>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 105247582684..0694f53981f2 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2740,7 +2740,10 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
-	of_get_mac_address(pnp, ppd.mac_addr);
+	ret = of_get_mac_address(pnp, ppd.mac_addr);
+
+	if (ret == -EPROBE_DEFER)
+		return ret;
 
 	mv643xx_eth_property(pnp, "tx-queue-size", ppd.tx_queue_size);
 	mv643xx_eth_property(pnp, "tx-sram-addr", ppd.tx_sram_addr);

base-commit: cfb92440ee71adcc2105b0890bb01ac3cddb8507
-- 
2.25.1

