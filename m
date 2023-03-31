Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C1C6D1C11
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjCaJYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCaJYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:24:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9EF1A457
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 02:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680254640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pDlKauzTuoDqgzcqRWI0/gxf1vVb1NHhoGy1u+TdmTA=;
        b=iqoXrsFZ1LDNwWm1i/DskkteTD879TPLfqVridAagZi/JUUYQYcIgq9o4EaG6OINAJkTnp
        OgZmOGDuRhP9r25Sp4sufYEPcTQw9QrLC/j0/LkjMf0Vgpq1gfSGkizOYPenUsluAVEKSM
        G+T5gCePhTx8jrgqZBP/rJ1oHyeUnFE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-LTZVv6yUN--cqtNNWmyceQ-1; Fri, 31 Mar 2023 05:23:48 -0400
X-MC-Unique: LTZVv6yUN--cqtNNWmyceQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52178280A32A;
        Fri, 31 Mar 2023 09:23:48 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 315CA202701E;
        Fri, 31 Mar 2023 09:23:48 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 33188A80CAB; Fri, 31 Mar 2023 11:23:47 +0200 (CEST)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: [PATCH net] net: stmmac: fix up RX flow hash indirection table when setting channels
Date:   Fri, 31 Mar 2023 11:23:47 +0200
Message-Id: <20230331092347.268996-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c5e74097d9ab..2218b1882f39 100644
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
@@ -6957,6 +6957,8 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 
 	priv->plat->rx_queues_to_use = rx_cnt;
 	priv->plat->tx_queues_to_use = tx_cnt;
+	for (i = 0; i < ARRAY_SIZE(priv->rss.table); i++)
+		priv->rss.table[i] = ethtool_rxfh_indir_default(i, rx_cnt);
 
 	stmmac_napi_add(dev);
 
-- 
2.39.2

