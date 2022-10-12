Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32335FC880
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 17:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiJLPhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 11:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiJLPho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 11:37:44 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F038DB769
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 08:37:42 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id s20so26303902lfi.11
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 08:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tk1G2RwNRdqz+wGlY+ULMADXguU2rnNvX/4SHP4ZobI=;
        b=gCLPlmA/xQyifU9SScPakk2CDvMJRWLIGdxWcoVEA7tOtElkbkogoOJjhzsgNvmH9a
         lWEAizvMRrYGP+VaVn2+BWOrTVG4OP7lMsw0JZ+awEhYLP8kxWIAfT2WqEqyYVQ15jFd
         vcPqTh6QwrZIDgzArYGj/rzk8nBmikyd/Os8KZBykPWEYZyT6eQSZy6FPG/0uwXE6uJ7
         lneHo7CDvyY1+FxGgLquzJjXAJOi68AtqcAqC3YJqrJDYrichJTqvplX224uoAHgPjqY
         yHcrGlDQj4X2X4mE+vY6Mfzzu2j+WYvBGK82U8mYo4rFfbSYwCJFLdMNIyWlVS7Drcqy
         6M9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tk1G2RwNRdqz+wGlY+ULMADXguU2rnNvX/4SHP4ZobI=;
        b=ekTJoQFrNs/04YYno+agc/Ows1SOoDv3XeL9HXQ9Z1dedwotR7WNMQOzAalK75g4nC
         KGhZGFqvvkjVk5tOXr4V2qRx/xRBC9viUdn9TvHFck2UbJsnEayP5GOTQAG3ihx8P0Iv
         WXVADc0vay5RCfDVzr7LJ44nCvVenMCAIlsdeaIijf5kVXVUGkI0gpApUKKBTVEC/L4A
         UQ46TKhJdkX6fzbyUufqxVvzLnyweh+IS2eX8cWCQ9MzwqkOcR2m2Ik5hdNm0mxCXeah
         vFk9thmcXPYQUyI/8s4oBwLQ2jllwAroXMo1WdohK6Nys8YvWtr/eRmUUtoxwOeg0OHz
         SL5A==
X-Gm-Message-State: ACrzQf0W+OMFXbg3ZEmjE/lj2HUMgDdilQsvnG2mzypkt2HQHIcCBYyu
        0CTu+Ae55y7bL0KODFnv98SXBgTxdAU=
X-Google-Smtp-Source: AMsMyM5AIZEhnAgmiFu16IbnL+1G6zb+9NEhQNntrF0ttWzlX9NvLf37rEotKPSyhU4x9b/wn4NWXw==
X-Received: by 2002:a05:6512:13a4:b0:477:a28a:2280 with SMTP id p36-20020a05651213a400b00477a28a2280mr9989116lfa.689.1665589061099;
        Wed, 12 Oct 2022 08:37:41 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:8077:5514:991f:3a57])
        by smtp.gmail.com with ESMTPSA id e26-20020a2e985a000000b0026c4e922fb2sm6949ljj.48.2022.10.12.08.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 08:37:40 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Sergei Antonov <saproj@gmail.com>
Subject: [PATCH v2 net] net: ftmac100: do not reject packets bigger than 1514
Date:   Wed, 12 Oct 2022 18:37:37 +0300
Message-Id: <20221012153737.128424-1-saproj@gmail.com>
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

Despite the datasheet [1] saying the controller should allow incoming
packets of length >=1518, it only allows packets of length <=1514.

Since 1518 is a standard Ethernet maximum frame size, and it can
easily be encountered (in SSH for example), fix this behavior:

* Set FTMAC100_MACCR_RX_FTL in the MAC Control Register.
* Check for packet size > 1518 in ftmac100_rx_packet_error().

[1]
https://bitbucket.org/Kasreyn/mkrom-uc7112lx/src/master/documents/FIC8120_DS_v1.2.pdf

Fixes: 8d77c036b57c ("net: add Faraday FTMAC100 10/100 Ethernet driver")
Signed-off-by: Sergei Antonov <saproj@gmail.com>
---

v1 -> v2:
* Typos in description fixed.

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

