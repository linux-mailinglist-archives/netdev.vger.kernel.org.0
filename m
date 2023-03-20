Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F646C0D13
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 10:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbjCTJVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 05:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbjCTJVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 05:21:10 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F74D2386D
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 02:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=7Zwba6nDD3ZJS5
        L+6Li+wbx6Tde6WzY3HBI8Ie4GLpQ=; b=NQWTAoiZkjUiVwvsNm1tXH25VdagxA
        OYQl1zEN2tIn7jrsIqua5NKHO7dK7G3Wl2RyR04k36cfFqZlWJnjqeVuLQMGKMZE
        itt7uhI8wYTMMatFwMA1YZnYwDHzKFoTJrH1IVRn0x55eLu5oxJO3xUle1y5Bf1m
        zwXMzabmsuRac=
Received: (qmail 860449 invoked from network); 20 Mar 2023 10:20:47 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 20 Mar 2023 10:20:47 +0100
X-UD-Smtp-Session: l3s3148p1@w0M5cVH3Ztwujnuq
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 1/2] smsc911x: only update stats when interface is up
Date:   Mon, 20 Mar 2023 10:20:40 +0100
Message-Id: <20230320092041.1656-2-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230320092041.1656-1-wsa+renesas@sang-engineering.com>
References: <20230320092041.1656-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise the clocks are not enabled and reading registers will BUG.

Fixes: 1e30b8d755b8 ("net: smsc911x: Make Runtime PM handling more fine-grained")
Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
Changes since v1:
* patch is not a revert but a proper fix this time

 drivers/net/ethernet/smsc/smsc911x.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index a2e511912e6a..67cb5eb9c716 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1838,8 +1838,12 @@ smsc911x_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 static struct net_device_stats *smsc911x_get_stats(struct net_device *dev)
 {
 	struct smsc911x_data *pdata = netdev_priv(dev);
-	smsc911x_tx_update_txcounters(dev);
-	dev->stats.rx_dropped += smsc911x_reg_read(pdata, RX_DROP);
+
+	if (netif_running(dev)) {
+		smsc911x_tx_update_txcounters(dev);
+		dev->stats.rx_dropped += smsc911x_reg_read(pdata, RX_DROP);
+	}
+
 	return &dev->stats;
 }
 
-- 
2.30.2

