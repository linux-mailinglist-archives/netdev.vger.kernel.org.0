Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9B36C43EE
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 08:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjCVHUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 03:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjCVHUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 03:20:09 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C261628E5D
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 00:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=f+cPQbgdhiXqSw
        UfD4emFcVbGADPFhBGTPDrLzdP0Mw=; b=YWcPqWledFXd0xvNYDMQseW7qNGgN4
        B7b71mLodxT66Y2tsSNCl/HbEQOwVno9FKKd+hr4yQvg6wdEiUD/nP+sTAORwPMd
        vLjqKzhqfSOaLOEC3LE2zapLsmKT5oRKMJkqXMd4XZLxRnPukHl7j79MQcuT7v0U
        AZC5GdUnJdf08=
Received: (qmail 1526190 invoked from network); 22 Mar 2023 08:20:01 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 22 Mar 2023 08:20:01 +0100
X-UD-Smtp-Session: l3s3148p1@j93//Hf3Gpsujnv6
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Simon Horman <simon.horman@corigine.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH net v3 1/2] smsc911x: only update stats when interface is up
Date:   Wed, 22 Mar 2023 08:19:58 +0100
Message-Id: <20230322071959.9101-2-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230322071959.9101-1-wsa+renesas@sang-engineering.com>
References: <20230322071959.9101-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise the clocks are not enabled and reading registers will BUG.

Fixes: 1e30b8d755b8 ("net: smsc911x: Make Runtime PM handling more fine-grained")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes since v2:
* added tags

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

