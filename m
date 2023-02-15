Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96C4697E68
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 15:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjBOOdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 09:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjBOOde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 09:33:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD9338B7A
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 06:33:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A20861C35
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 14:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445E5C4339B;
        Wed, 15 Feb 2023 14:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676471607;
        bh=Q+9ZjF0KcBLXQM9PU51Z+ALr9pKaDq0llUGeYoSux2c=;
        h=From:To:Cc:Subject:Date:From;
        b=K2enWOipKlXvSt+ryFseNirkJtBSSsl23Ctg4KtC1s0o2m0myv/4lGvjm0Ul6KrhD
         LBLg79knMxNd/IyHQGrpwJ11FvQpz86CYqFgaVFnu0romnVe1pWHEXcHoePsihgXcD
         poGhNvX9F5jxuL3m5P31Fbn/iRnQN+/0zt9oNyqMsna7bx0FvWLX8iN53T3ws4wbvo
         1LzMrajspTRNnMWab8PFvwmpQGc7NAtOam66O8VMc7AZdTjG94fkVqceQCN4uGHCc3
         rXA31F5PqEm2M3M2tnUytGilQT6p0Lna6a2zTk1K+5J63OtooHwx7Z8DczQMCViJ+G
         Vg9JAW0TYFcIw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ioana.ciornei@nxp.com, vladimir.oltean@nxp.com,
        robert-ionut.alexa@nxp.com, radu-andrei.bulie@nxp.com
Subject: [PATCH net-next] net: dpaa2-eth: do not always set xsk support in xdp_features flag
Date:   Wed, 15 Feb 2023 15:32:57 +0100
Message-Id: <3dba6ea42dc343a9f2d7d1a6a6a6c173235e1ebf.1676471386.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not always add NETDEV_XDP_ACT_XSK_ZEROCOPY bit in xdp_features flag
but check if the NIC really supports it.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 746ccfde7255..a62cffaf6ff1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4598,8 +4598,10 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 	net_dev->hw_features = net_dev->features;
 	net_dev->xdp_features = NETDEV_XDP_ACT_BASIC |
 				NETDEV_XDP_ACT_REDIRECT |
-				NETDEV_XDP_ACT_XSK_ZEROCOPY |
 				NETDEV_XDP_ACT_NDO_XMIT;
+	if (priv->dpni_attrs.wriop_version >= DPAA2_WRIOP_VERSION(3, 0, 0) &&
+	    priv->dpni_attrs.num_queues <= 8)
+		net_dev->xdp_features |= NETDEV_XDP_ACT_XSK_ZEROCOPY;
 
 	if (priv->dpni_attrs.vlan_filter_entries)
 		net_dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-- 
2.39.1

