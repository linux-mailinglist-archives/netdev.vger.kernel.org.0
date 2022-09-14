Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C253C5B9019
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 23:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiINV2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 17:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiINV2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 17:28:48 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B51286707
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 14:28:47 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id t7so27662275wrm.10
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 14:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=hMumSe1XLGX5Rh+d8Q9A6pKAL+6adHOGZWqxSoKEP48=;
        b=OaACCVfJTP4oPIY6n4y12IN4NsIXhcu+XbxqCMGmbHYlH39phCeLZB3GlWXvxO85yo
         oZ+6Yp1V46U/ouoqNqu3wwZ8lX4CCCtIcyPWnfc+HauaMtdSki0x0YPd7OfUqWLi5KAM
         t2CJT/p7qM8M5TMWauuUk8COEtddaSg4weXsDhnOk1RLPZ8lEJ6nmu8ECf6Q8AOYnop+
         BwoZdD914OaUAlClEeD9p9Uswsj/pOOnmhVY0rn5mkWhBeQbZKnerPcOo1PzkiopTUvu
         dbS6z2lW91DrOh1r+Rj9zsfVWIup+AaHuzpF4pN82Ak3I3DGv1CxSw1QKNP0B7PPzkJt
         a+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=hMumSe1XLGX5Rh+d8Q9A6pKAL+6adHOGZWqxSoKEP48=;
        b=solJSfAs70lA9ba955Cfhj0GTpzlbyF9G7i7PgK9xuaqipss/lJ/MgLq7EtbyaDSKf
         KeJELi2H0Osw1UC4XospF4w7S2Y3EIr8sfUQDN6uQLexXJwPNJuQkXIzR8hgb+YHyeEY
         u2qLat1LgcMQUzo9C1oHabUPGqIadTA0VlO5oxu7y6h4oaR0JQnjltKyirEHj2pYBByC
         kYG1NTwSdgQzGZQ/e4owtlCIjdcuFEbA3Oh+Xs/XGEbyseS+vhG325Tu13McZ+TdDea8
         +YuEqxbOs6G0XiKa5JMB+oIvTiBpl6U6BTRtApzZtAgx5omqkXiWNW3k7bd/ANbhdCOk
         ywMw==
X-Gm-Message-State: ACgBeo35YkX/+CswmaBfRg77nH9rX+ruz8hDFwSfjgCDTvkf5UAeF0WF
        JT/3pozDQdwiQ8TW+E+Ph16cxg==
X-Google-Smtp-Source: AA6agR6mFue7kmEotmNvPBv7f3MqkKOlWyuaSJE+g4cf9ahOwa21RLJ2XvNNvO3q6I1xY83C93KRYA==
X-Received: by 2002:adf:ef52:0:b0:22a:6ec5:a0fd with SMTP id c18-20020adfef52000000b0022a6ec5a0fdmr12427141wrp.190.1663190926059;
        Wed, 14 Sep 2022 14:28:46 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id e28-20020adf9bdc000000b00228c375d81bsm350898wrc.2.2022.09.14.14.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 14:28:45 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     loic.poulain@linaro.org, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, bryan.odonoghue@linaro.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v2] wcn36xx: Add RX frame SNR as a source of system entropy
Date:   Wed, 14 Sep 2022 22:28:41 +0100
Message-Id: <20220914212841.1407497-2-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220914212841.1407497-1-bryan.odonoghue@linaro.org>
References: <20220914212841.1407497-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The signal-to-noise-ratio SNR is returned by the wcn36xx firmware for each
received frame. SNR represents all of the unwanted interference signal
after filtering out the fundamental frequency and harmonics of the
frequency.

Noise can come from various electromagnetic sources, from temperature
affecting the performance hardware components or quantization effects
converting from analog to digital domains.

The SNR value returned by the WiFi firmware then is a good source of
entropy.

Other WiFi drivers offer up the noise component of the FFT as an entropy
source for the random pool e.g.

commit 2aa56cca3571 ("ath9k: Mix the received FFT bins to the random pool")

I attended Jason's talk on sources of randomness at Plumbers and it
occurred to me that SNR is a reasonable candidate to add.

Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/txrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 8da3955995b6e..b73229776af8b 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -16,6 +16,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/random.h>
 #include "txrx.h"
 
 static inline int get_rssi0(struct wcn36xx_rx_bd *bd)
@@ -297,6 +298,8 @@ static void wcn36xx_update_survey(struct wcn36xx *wcn, int rssi, int snr,
 	wcn->chan_survey[idx].rssi = rssi;
 	wcn->chan_survey[idx].snr = snr;
 	spin_unlock(&wcn->survey_lock);
+
+	add_device_randomness(&snr, sizeof(s8));
 }
 
 int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
-- 
2.37.3

