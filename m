Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9241E6AE3C8
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjCGPDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjCGPDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:03:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5348A81CF2;
        Tue,  7 Mar 2023 06:54:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E303361265;
        Tue,  7 Mar 2023 14:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0293CC433EF;
        Tue,  7 Mar 2023 14:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678200896;
        bh=o5gPeq4QDA4D5M45DH1MR6vMlCRXmlPsUa7kM4g6OJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OoM8vRUHXVTWreqQt3f3H9K2DxMq566IsWxmlqbXPpgMKlXWAMhQgqDPIu8+DBAYG
         vzdB0jMSMC1p6lYA+CQ/S+UyCdHW/R+7FaBH/GAu0JNUliUwKg7lckbfztSTR39lNC
         piBZjS1YDpglIQpEWrj/1ZkJiYIL99gOO6Iawhx88iIrf7dOix8OMzB77Q4EIlEAln
         6oY3GNTvr2//QyYMDxRve7HRj813DgTZuLUPehUTDfUhIZQYCKUwTSJfuOqKsxF5Db
         Qv/89KLCM9ss2/2VtGFYBSF1P9+lzxMt0UrnFxuxBSuuE8Yo2HJfSPPZCtCoi/E0hR
         oh0wEMXXDls6g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com,
        teknoraver@meta.com
Subject: [PATCH net-next 8/8] mvpp2: take care of xdp_features when reconfiguring queues
Date:   Tue,  7 Mar 2023 15:54:05 +0100
Message-Id: <fe34ea957afb95ce255a17ec79df08d9647b72c7.1678200041.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678200041.git.lorenzo@kernel.org>
References: <cover.1678200041.git.lorenzo@kernel.org>
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

From: Matteo Croce <teknoraver@meta.com>

XDP is supported only if enough queues are present, so when reconfiguring
the queues set xdp_features accordingly.

Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
Suggested-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Matteo Croce <teknoraver@meta.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 9b4ecbe4f36d..3ea00bc9b91c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4996,6 +4996,14 @@ static int mvpp2_bm_switch_buffers(struct mvpp2 *priv, bool percpu)
 
 	for (i = 0; i < priv->port_count; i++) {
 		port = priv->port_list[i];
+		if (percpu && port->ntxqs >= num_possible_cpus() * 2)
+			xdp_set_features_flag(port->dev,
+					      NETDEV_XDP_ACT_BASIC |
+					      NETDEV_XDP_ACT_REDIRECT |
+					      NETDEV_XDP_ACT_NDO_XMIT);
+		else
+			xdp_clear_features_flag(port->dev);
+
 		mvpp2_swf_bm_pool_init(port);
 		if (status[i])
 			mvpp2_open(port->dev);
@@ -6863,13 +6871,14 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 
 	if (!port->priv->percpu_pools)
 		mvpp2_set_hw_csum(port, port->pool_long->id);
+	else if (port->ntxqs >= num_possible_cpus() * 2)
+		dev->xdp_features = NETDEV_XDP_ACT_BASIC |
+				    NETDEV_XDP_ACT_REDIRECT |
+				    NETDEV_XDP_ACT_NDO_XMIT;
 
 	dev->vlan_features |= features;
 	netif_set_tso_max_segs(dev, MVPP2_MAX_TSO_SEGS);
 
-	dev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
-			    NETDEV_XDP_ACT_NDO_XMIT;
-
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* MTU range: 68 - 9704 */
-- 
2.39.2

