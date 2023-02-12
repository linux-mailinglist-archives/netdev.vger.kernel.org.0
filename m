Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53D76936D2
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 11:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBLKJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 05:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBLKJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 05:09:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7444D13DCD;
        Sun, 12 Feb 2023 02:09:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A83BB80B99;
        Sun, 12 Feb 2023 10:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D0AC433D2;
        Sun, 12 Feb 2023 10:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676196547;
        bh=yJpJ9U+wsrDkGxRU+Mzf665BnQONWNNupO4Bfze8JEo=;
        h=From:To:Cc:Subject:Date:From;
        b=S6YogIlzFN1exhgVefZrY4axknz7x7bKVFWBbCdpin8e61pnSWZK0eXa/5G1BBAgb
         8WsDWR5bz36IgnSNuQNz71ApsXTBL7ubqnvpmO3UpoOWZImT09QNS27+0rXiNLuEp7
         dcc5ldVzetPk6KwxRH1unBYlVWHu7xMLjCOUhnXXMuE21/oxyUHXLT9+dOQ79yfcLd
         E4jRNUl/9x+IlyTHK3Wsm3tPufOlKAeVF1v8G0aPJjhrrbRZijvcz8w43IEdZ58GXK
         kx3eOrvQhibNu4B8veMbkQQQP55QrdUmLhCPqpbOA3wLVXERogDWN1+WQHWPb0O7kg
         zeOeNT7dviysA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        linux@armlinux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        lorenzo.bianconi@redhat.com, bpf@vger.kernel.org
Subject: [PATCH net-next] net: mvneta: do not set xdp_features for hw buffer devices
Date:   Sun, 12 Feb 2023 11:08:26 +0100
Message-Id: <19b5838bb3e4515750af822edb2fa5e974d0a86b.1676196230.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devices with hardware buffer management do not support XDP, so do not
set xdp_features for them.

Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 1cb4f59c0050..0e39d199ff06 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5612,9 +5612,12 @@ static int mvneta_probe(struct platform_device *pdev)
 			NETIF_F_TSO | NETIF_F_RXCSUM;
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
-	dev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
-			    NETDEV_XDP_ACT_NDO_XMIT | NETDEV_XDP_ACT_RX_SG |
-			    NETDEV_XDP_ACT_NDO_XMIT_SG;
+	if (!pp->bm_priv)
+		dev->xdp_features = NETDEV_XDP_ACT_BASIC |
+				    NETDEV_XDP_ACT_REDIRECT |
+				    NETDEV_XDP_ACT_NDO_XMIT |
+				    NETDEV_XDP_ACT_RX_SG |
+				    NETDEV_XDP_ACT_NDO_XMIT_SG;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	netif_set_tso_max_segs(dev, MVNETA_MAX_TSO_SEGS);
 
-- 
2.39.1

