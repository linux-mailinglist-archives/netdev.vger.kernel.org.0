Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F5F6D4427
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbjDCMMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjDCMMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:12:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B474C0A
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 05:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680523885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b//9TGsjXOvLTeTSaLDQqn5ZoA1MlKmOsXusyAR2pfM=;
        b=JVaBWClOZYseSoMVKZMViM3kCNg2RoWiP/Rl6lIcPz6ufG1Tm/ZioXnU0G83f5wt9pzCBV
        lLYGVrH6o9Sf9QUfnVENFwgAEZW3WuQVXqnkq9bXxprUHKhUB144EGp05j5RXo/ywZ5hqZ
        Ge0GWR/J/Qyy9lnL1+A2X9pGbdUsaHw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-sNjiM207MYGlbnVs3cAkKg-1; Mon, 03 Apr 2023 08:11:22 -0400
X-MC-Unique: sNjiM207MYGlbnVs3cAkKg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CFEE858F09;
        Mon,  3 Apr 2023 12:11:22 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB9004020C80;
        Mon,  3 Apr 2023 12:11:21 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 69ECBA80CED; Mon,  3 Apr 2023 14:11:20 +0200 (CEST)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: [PATCH v2 net] net: stmmac: fix up RX flow hash indirection table when setting channels
Date:   Mon,  3 Apr 2023 14:11:20 +0200
Message-Id: <20230403121120.489138-1-vinschen@redhat.com>
In-Reply-To: <20230331214616.228c458d@kernel.org>
References: <20230331214616.228c458d@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

stmmac_reinit_queues() fails to fix up the RX hash.  Even if the number
of channels gets restricted, the output of `ethtool -x' indicates that
all RX queues are used:

  $ ethtool -l enp0s29f2
  Channel parameters for enp0s29f2:
  Pre-set maximums:
  RX:		8
  TX:		8
  Other:		n/a
  Combined:	n/a
  Current hardware settings:
  RX:		8
  TX:		8
  Other:		n/a
  Combined:	n/a
  $ ethtool -x enp0s29f2
  RX flow hash indirection table for enp0s29f2 with 8 RX ring(s):
      0:      0     1     2     3     4     5     6     7
      8:      0     1     2     3     4     5     6     7
  [...]
  $ ethtool -L enp0s29f2 rx 3
  $ ethtool -x enp0s29f2
  RX flow hash indirection table for enp0s29f2 with 3 RX ring(s):
      0:      0     1     2     3     4     5     6     7
      8:      0     1     2     3     4     5     6     7
  [...]

Fix this by setting the indirection table according to the number
of specified queues.  The result is now as expected:

  $ ethtool -L enp0s29f2 rx 3
  $ ethtool -x enp0s29f2
  RX flow hash indirection table for enp0s29f2 with 3 RX ring(s):
      0:      0     1     2     0     1     2     0     1
      8:      2     0     1     2     0     1     2     0
  [...]

Tested on Intel Elkhart Lake.

Fixes: 0366f7e06a6b ("net: stmmac: add ethtool support for get/set channels")
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c5e74097d9ab..f2eac201174b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6948,7 +6948,7 @@ static void stmmac_napi_del(struct net_device *dev)
 int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
-	int ret = 0;
+	int ret = 0, i;
 
 	if (netif_running(dev))
 		stmmac_release(dev);
@@ -6957,6 +6957,10 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 
 	priv->plat->rx_queues_to_use = rx_cnt;
 	priv->plat->tx_queues_to_use = tx_cnt;
+	if (!netif_is_rxfh_configured(dev))
+		for (i = 0; i < ARRAY_SIZE(priv->rss.table); i++)
+			priv->rss.table[i] = ethtool_rxfh_indir_default(i,
+									rx_cnt);
 
 	stmmac_napi_add(dev);
 
-- 
2.39.2

