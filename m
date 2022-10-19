Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8138B604D11
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 18:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiJSQVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 12:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJSQVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 12:21:11 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9781418B758
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 09:21:08 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id a13so26089734edj.0
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 09:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CZ7nAXxeNiEPkBF+BWrrkCSvv+94jSgXynCiBbKMTek=;
        b=O4SPCro70vBeFvMuMXEG+b4r44W5mW2uMvCDV4Bwak2QnV4vLnvrg+T73wku0zEqKg
         n2EUr5roy20BCq9NyzeFhhlbVhFFbUdwjYAj8pdz4zUvUqO+uDx+jpNs8lTx1c6Y/5Gh
         QQMer4r3EUtXCZRHADp5NaM/rL3RMmuukdFz+D+BmewdS8V0pJYCQ01f5o5rooU+PHsY
         9zJUiXcSLVXwkbJVDS2Bj68BbMVGOweM+OzowvuBx7herWzDsq3Kmxn4gkmpHhYCey+m
         wDCJROt2rYSgTm0HeCol6/AFjhYUZiEqMbIZiLWe37EcOvT+todqq0wZ2KaW+hbsNhI0
         sxjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CZ7nAXxeNiEPkBF+BWrrkCSvv+94jSgXynCiBbKMTek=;
        b=a7OQf/5+sB0GbOUD55DRd8CqkViaAok1TDpgQugFXcqgKAf6bk+HPukKWtGXH9uFsj
         0PRhug+u0gecMpUWZ0BFEh+ue08E0K6QyVEc9uxzJf2+VXbKML5R/wxoDBaYiUdOWVAm
         AObnBQ873qib5CywKyj+0jAlrBFCD+OnEz/LE2eTaeOTyt2iqFRdR9AY5HRo1fwPKtkB
         YvdAh9LDIS5j7f+x2SFGnBpD4UHVoHu2VF7y6EAugQeF0GS5X0bzDYTZG/k3vFRccahm
         Jq4ywEUoBTUbbTRHXXgQ81unueFw99Ft7N6uqycavpFCTRIRVZb6vPrr2HjCD1Bbh7MQ
         cZpQ==
X-Gm-Message-State: ACrzQf3pHBi+/2LH6jhHMCPqNHE4mcX5w2OumEswtSo8CqHunXJA1+bY
        tMYeG1u+33UK5zKKy4Qe/3noGtMRHi08jg==
X-Google-Smtp-Source: AMsMyM7aDNebVjwGlc2l0wU/qEJQOS4DYCRXd5UAW1BFWktv0bbLl11I3syGyPRLbDwDevYKZNS4WA==
X-Received: by 2002:a05:6402:1842:b0:458:e6f2:bd3d with SMTP id v2-20020a056402184200b00458e6f2bd3dmr8043336edy.169.1666196466860;
        Wed, 19 Oct 2022 09:21:06 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:449e:b0ae:8d1e:9cdb])
        by smtp.gmail.com with ESMTPSA id e16-20020a170906315000b0073d7b876621sm9001905eje.205.2022.10.19.09.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 09:21:06 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andrew@lunn.ch,
        Sergei Antonov <saproj@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next] net: ftmac100: support mtu > 1500
Date:   Wed, 19 Oct 2022 19:20:58 +0300
Message-Id: <20221019162058.289712-1-saproj@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ftmac100 controller considers some packets FTL (frame
too long) and drops them. An example of a dropped packet:
6 bytes - dst MAC
6 bytes - src MAC
2 bytes - EtherType IPv4 (0800)
1504 bytes - IPv4 packet

Do the following to let the driver receive these packets.
Set FTMAC100_MACCR_RX_FTL when mtu>1500 in the MAC Control Register.
For received packets marked with FTMAC100_RXDES0_FTL check if packet
length (with FCS excluded) is within expected limits, that is not
greater than netdev->mtu + 14 (Ethernet headers). Otherwise trigger
an error.

Fixes: 8d77c036b57c ("net: add Faraday FTMAC100 10/100 Ethernet driver")
Signed-off-by: Sergei Antonov <saproj@gmail.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/ethernet/faraday/ftmac100.c | 29 ++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index d95d78230828..f89b53845f21 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -159,6 +159,7 @@ static void ftmac100_set_mac(struct ftmac100 *priv, const unsigned char *mac)
 static int ftmac100_start_hw(struct ftmac100 *priv)
 {
 	struct net_device *netdev = priv->netdev;
+	unsigned int maccr;
 
 	if (ftmac100_reset(priv))
 		return -EIO;
@@ -175,7 +176,20 @@ static int ftmac100_start_hw(struct ftmac100 *priv)
 
 	ftmac100_set_mac(priv, netdev->dev_addr);
 
-	iowrite32(MACCR_ENABLE_ALL, priv->base + FTMAC100_OFFSET_MACCR);
+	maccr = MACCR_ENABLE_ALL;
+
+	/* We have to set FTMAC100_MACCR_RX_FTL in case MTU > 1500
+	 * and do extra length check in ftmac100_rx_packet_error().
+	 * Otherwise the controller silently drops these packets.
+	 *
+	 * When the MTU of the interface is standard 1500, rely on
+	 * the controller's functionality to drop too long packets
+	 * and save some CPU time.
+	 */
+	if (netdev->mtu > 1500)
+		maccr |= FTMAC100_MACCR_RX_FTL;
+
+	iowrite32(maccr, priv->base + FTMAC100_OFFSET_MACCR);
 	return 0;
 }
 
@@ -337,9 +351,18 @@ static bool ftmac100_rx_packet_error(struct ftmac100 *priv,
 		error = true;
 	}
 
-	if (unlikely(ftmac100_rxdes_frame_too_long(rxdes))) {
+	/* If the frame-too-long flag FTMAC100_RXDES0_FTL is set, check
+	 * if ftmac100_rxdes_frame_length(rxdes) exceeds the currently
+	 * set MTU plus ETH_HLEN.
+	 * The controller would set FTMAC100_RXDES0_FTL for all incoming
+	 * frames longer than 1518 (includeing FCS) in the presense of
+	 * FTMAC100_MACCR_RX_FTL in the MAC Control Register.
+	 */
+	if (unlikely(ftmac100_rxdes_frame_too_long(rxdes) &&
+		     ftmac100_rxdes_frame_length(rxdes) > netdev->mtu + ETH_HLEN)) {
 		if (net_ratelimit())
-			netdev_info(netdev, "rx frame too long\n");
+			netdev_info(netdev, "rx frame too long (%u)\n",
+				    ftmac100_rxdes_frame_length(rxdes));
 
 		netdev->stats.rx_length_errors++;
 		error = true;
-- 
2.34.1

