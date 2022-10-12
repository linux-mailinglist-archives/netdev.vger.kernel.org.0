Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218635FC6B2
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 15:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiJLNqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 09:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJLNqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 09:46:04 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33793B03E8
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 06:46:03 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id bu25so25853161lfb.3
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 06:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KB5pGAjU8oYBFG25BFLphQ6ae7VNq2jH5jjjGZx/bvQ=;
        b=WC7geWwZupuwlE2BKDqTFVFvhbkccGiWfhtg/wJBZunHkLtaviGaThIexqAjqyTOo2
         bMnoultbNT8Ql1x5B0VQF5bOQGUPMhhwQYBcABVg8K68497L4bUpukAEJxrapP0ekxFr
         b7YHpooI8b1ozfphKewCF63uVuXnfABOLCAEl62eIppejC0fQJ8RHRoN9md+VI1KYZPT
         vvCkKvj4llP8oTUdi6AvOrYeSR9IIRo69E78j+Ezugx1ZXO8tOQhxBQTRlVWF0T0ySr9
         LUM6E50HOk4eB25cWlWUGslzk7rs8MJHOo5RHN1WTpiOj1zKX9bWd42kmw9pwLjdcr5S
         4L8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KB5pGAjU8oYBFG25BFLphQ6ae7VNq2jH5jjjGZx/bvQ=;
        b=1Th3fuYymD8wukdAqvsT0uHvDk0Srz4MibYKypxJ6QRToW+3iumqPp6Kn8TbZtX5l3
         F9uN+KDQwgQBjk97cL2UtRLbQZOozEJgaZu+jijj+Y8e9YG5Ryj+lcHEzKJMJx/FERDt
         8mnt/2RiJ4CqatVpKNpt8vZoJT8tkCd7b111BN9tir1P9lZy3SEVybFoBZmzpkx1ZIPH
         adq4AgAkRk6XTGFECYteCSmD/bPHRCVsjxjkWB085a5NJPWyvqCSwAkkiD3xBgqmTq2E
         p12/3GUCg4kCMcdLxO86srOFpYJdT5gNGRKmM47/q03DuTbi8lpLy8CDTifAVd6Nl3x/
         Nhmw==
X-Gm-Message-State: ACrzQf2sPHfGW8RxFnqyl0L5HDUUfppIF3RPfMcACxUupHPyz6UkHOeC
        E2PvF4hAcisqyZ3gEVjwBqgOWKjp9/U=
X-Google-Smtp-Source: AMsMyM44GQDc/Sx6h6nlBemLkWmA/g3M0uMYsMPZjFmb+0Wxsw67nMP/ROIgv2Dz3asvKTwVM3z0jg==
X-Received: by 2002:a05:6512:208a:b0:4a2:6cc7:cee5 with SMTP id t10-20020a056512208a00b004a26cc7cee5mr10706887lfr.153.1665582361359;
        Wed, 12 Oct 2022 06:46:01 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:8077:5514:991f:3a57])
        by smtp.gmail.com with ESMTPSA id f7-20020a056512360700b004996fbfd75esm2310791lfs.71.2022.10.12.06.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 06:46:01 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Sergei Antonov <saproj@gmail.com>
Subject: [PATCH net] net: ftmac100: do not reject packets bigger than 1514
Date:   Wed, 12 Oct 2022 16:45:58 +0300
Message-Id: <20221012134558.79737-1-saproj@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_SBL_A autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dispite datasheet [1] saying the controller should allow incoming
packets of length >=1518, it only allows packets of length <=1514.

Since 1518 is a standard Ethernet maximum frame size, and it can
easily be encountered (in SSH for example), fix this behaviour:

* Set FTMAC100_MACCR_RX_FTL in the MAC Control Register.
* Check for packet size > 1518 in ftmac100_rx_packet_error().

[1]
https://bitbucket.org/Kasreyn/mkrom-uc7112lx/src/master/documents/FIC8120_DS_v1.2.pdf

Fixes: 8d77c036b57c ("net: add Faraday FTMAC100 10/100 Ethernet driver")
Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 drivers/net/ethernet/faraday/ftmac100.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index d95d78230828..34d0284079ff 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -154,6 +154,7 @@ static void ftmac100_set_mac(struct ftmac100 *priv, const unsigned char *mac)
 				 FTMAC100_MACCR_CRC_APD	| \
 				 FTMAC100_MACCR_FULLDUP	| \
 				 FTMAC100_MACCR_RX_RUNT	| \
+				 FTMAC100_MACCR_RX_FTL	| \
 				 FTMAC100_MACCR_RX_BROADPKT)
 
 static int ftmac100_start_hw(struct ftmac100 *priv)
@@ -320,6 +321,7 @@ static bool ftmac100_rx_packet_error(struct ftmac100 *priv,
 {
 	struct net_device *netdev = priv->netdev;
 	bool error = false;
+	const unsigned int length = ftmac100_rxdes_frame_length(rxdes);
 
 	if (unlikely(ftmac100_rxdes_rx_error(rxdes))) {
 		if (net_ratelimit())
@@ -337,9 +339,16 @@ static bool ftmac100_rx_packet_error(struct ftmac100 *priv,
 		error = true;
 	}
 
-	if (unlikely(ftmac100_rxdes_frame_too_long(rxdes))) {
+	/* The frame-too-long flag 'FTMAC100_RXDES0_FTL' is described in the
+	 * datasheet as: "When set, it indicates that the received packet
+	 * length exceeds 1518 bytes." But testing shows that it is also set
+	 * when packet length is equal to 1518.
+	 * Since 1518 is a standard Ethernet maximum frame size, let it pass
+	 * and only trigger an error when packet length really exceeds it.
+	 */
+	if (unlikely(ftmac100_rxdes_frame_too_long(rxdes) && length > 1518)) {
 		if (net_ratelimit())
-			netdev_info(netdev, "rx frame too long\n");
+			netdev_info(netdev, "rx frame too long (%u)\n", length);
 
 		netdev->stats.rx_length_errors++;
 		error = true;
-- 
2.34.1

