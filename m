Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF9D5FDDC8
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiJMP55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiJMP54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:57:56 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33701DAC42
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:57:54 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id s20so3133021lfi.11
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XBSMR+VWcdG3MlzVmRYcen8Za5C1KdGsvUIhKapLGWA=;
        b=lkAAP67uo1hrlnRndBBnNHveG/5B1RTg/5eD/kqQ/ogIa3iOt12PutC+uodp07YINj
         2uMTAQ+edjYGlW25T5Yk/mDd5d/eRR08mUQiSVJpEedj777I/B877NmBQbfwIFayIqNZ
         HQxXKp54dV5BSlzEb6NQCB5S9MHl+FuFywjCD6i0JZxIK8SLvpGH7iGf8WSHs2qyrQDA
         cK6o5T6SX6X37aKhC+swEOek+t+c1jI7hDpw3R1iAjQA+dt8erTHi/3wi+84SAPOVxfo
         GMxZMlkr5qo623mU+8VbPlhb8T0yJlr77dy0F0bs8Mw/A1LrI9BYC61Jy71Se7/u/W9L
         IJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XBSMR+VWcdG3MlzVmRYcen8Za5C1KdGsvUIhKapLGWA=;
        b=XJ9C3MjBP01n27ktwamUKvjMRZPkUZhIgfSki7saQkqq4oxHmRjt/e99Umi73QwIZn
         VdkH1LaktEiV5XdpPSkuoAET9hezHkkIp/a1NAxtRj33L0gwLv4KTUPcYfzTMt0qUpGK
         CBnTuRN7k6Ph+PofZ/j7r4pHydxgETXebwG7YKGfMW4fIyDc5iG/8itcJ6XxanhUBEmp
         k/fqsOlLFZJ/uwoY/Tz8Fov48b84RTLBZLxEPpBmZJjmu/sUmYJqkssdIaj5IVli0XPl
         IaUmZl1AR/lPB60cdPSLyZjQhox8Ur0PTO9zwT5Thvu8ErFw84mLkOkLwVZODZoxl8V8
         gumQ==
X-Gm-Message-State: ACrzQf1XgMnAIyTzahJxse736lut/Jrbcr8bt3ZG2ZpzW02a1TrUoWH/
        a2a0fvPprlfgBk4RPz0nLkaFvXtwDGmt/Q==
X-Google-Smtp-Source: AMsMyM4WIq0arHLLdSSmIjOiR3LXyXgqL2Ufj+lhBsznWKcsIT4VnHLo5hPM0WMc5vkSSvWcaS2Zog==
X-Received: by 2002:a05:6512:3d9f:b0:4a2:429b:8df4 with SMTP id k31-20020a0565123d9f00b004a2429b8df4mr106690lfv.63.1665676672430;
        Thu, 13 Oct 2022 08:57:52 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:8a1a:aa7d:a68b:c2b5])
        by smtp.gmail.com with ESMTPSA id c22-20020ac25f76000000b0047f7722b73csm449747lfc.142.2022.10.13.08.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 08:57:52 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        Sergei Antonov <saproj@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net] net: ftmac100: support frames with DSA tag
Date:   Thu, 13 Oct 2022 18:57:24 +0300
Message-Id: <20221013155724.2911050-1-saproj@gmail.com>
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

Fixes the problem when frames coming from DSA were discarded.
DSA tag might make frame size >1518. Such frames are discarded
by the controller when FTMAC100_MACCR_RX_FTL is not set in the
MAC Control Register, see datasheet [1].

Set FTMAC100_MACCR_RX_FTL in the MAC Control Register.
For received packets marked with FTMAC100_RXDES0_FTL check if packet
length (with FCS excluded) is within expected limits, that is not
greater than netdev->mtu + 14 (Ethernet headers). Otherwise trigger
an error. In the presence of DSA netdev->mtu is 1504 to accommodate
for VLAN tag.

[1]
https://bitbucket.org/Kasreyn/mkrom-uc7112lx/src/master/documents/FIC8120_DS_v1.2.pdf

Fixes: 8d77c036b57c ("net: add Faraday FTMAC100 10/100 Ethernet driver")
Signed-off-by: Sergei Antonov <saproj@gmail.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
---

v2 -> v3:
* Corrected the explanation of the problem: datasheet is correct.
* Rewrote the code to use the currently set mtu to handle DSA frames.

v1 -> v2:
* Typos in description fixed.

 drivers/net/ethernet/faraday/ftmac100.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index d95d78230828..9187331e83dc 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -154,6 +154,7 @@ static void ftmac100_set_mac(struct ftmac100 *priv, const unsigned char *mac)
 				 FTMAC100_MACCR_CRC_APD	| \
 				 FTMAC100_MACCR_FULLDUP	| \
 				 FTMAC100_MACCR_RX_RUNT	| \
+				 FTMAC100_MACCR_RX_FTL	| \
 				 FTMAC100_MACCR_RX_BROADPKT)
 
 static int ftmac100_start_hw(struct ftmac100 *priv)
@@ -337,9 +338,18 @@ static bool ftmac100_rx_packet_error(struct ftmac100 *priv,
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

