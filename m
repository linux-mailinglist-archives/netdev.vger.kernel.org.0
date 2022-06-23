Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0EB95571B8
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiFWEjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiFWDCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 23:02:18 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1357F218F;
        Wed, 22 Jun 2022 20:02:11 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 23so11696079pgc.8;
        Wed, 22 Jun 2022 20:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g03u5w/SOP9Sq8BmXmtuOWSKoGMrDR9MfcvEZZfKrFU=;
        b=Srcv5PJSKVOmkMl+WTNEfVKuJeOaOWy2Hq7o0wXx6v1bAJ5fPELPAxr7uZvhbEb78i
         iB1AV+JyJ24VPbRf6fQ4JCZFCyMgZz51q5fRinR9rtrbIAkGtf19M/i6ipD1BGJLryXW
         V1Bi6IYAsLHPE37i+z4036m0RMkZEmzzd3aRN0cP5KdWBoSajL5IiE1bTXY2lVY9dawt
         uX74ZuT/czsYEngTU4fx513grk82zx7u0jNb3ZUxJogrk5PntCwYKxoua0UFVAee5JK+
         aVitLKQTvaMlZpzOwdIzNDCfcE48DD/kPnrXgVLhHlbThjI9l9GIQP75gYeEXtzClXvL
         TC8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g03u5w/SOP9Sq8BmXmtuOWSKoGMrDR9MfcvEZZfKrFU=;
        b=3k3QisUbZOcmje7bItXqe9qdN+LtUvLwZ6gRwBzrZnz18vst4BLhXwGgZC3Kr1NcAm
         1cJ9NZFBykDfVKELBAM7G0IWg7O2EELtrGipcQvyMKrd7fkBoGyh+vR9OAcH+z89pCYG
         hRX+PYsehA88qer6n/bYmi3tUpNshOM54a7h28c4d6cFhCuA3LWRrokmdmXIbDOFkqbu
         pDRPqt/iVDr4M2ztPIlb905ENYw770DUU45Nl0D9VwdZgh63RxTUWdKc0zbcHq7iDAXb
         EsEdMvdcE3vLhIRKxQAdleg43uj8D67E7ZhEBytr3j5sPBcwTS9a3rzIidBTcxagmYH6
         N59w==
X-Gm-Message-State: AJIora8EIFUAmppRlJyoVvfebFWrqmSk/toUnyzQbKkI9+EUkx6V6Tl1
        MxT3qDzLy8r4EhvbQEigow3L8J3IVzo=
X-Google-Smtp-Source: AGRyM1vHQjFvsyICN8eFMWzI33+FYWFTZ5MtZ2VtgSMJzNKyiX9Lqw92Dt4Kucaqoo9zjN8og6oP0A==
X-Received: by 2002:a63:4447:0:b0:3fc:d3d1:cea9 with SMTP id t7-20020a634447000000b003fcd3d1cea9mr5600389pgk.269.1655953329732;
        Wed, 22 Jun 2022 20:02:09 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x16-20020a170902b41000b0016a1c61c603sm7823705plr.154.2022.06.22.20.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 20:02:09 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: bcm_sf2: force pause link settings
Date:   Wed, 22 Jun 2022 20:02:04 -0700
Message-Id: <20220623030204.1966851-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

The pause settings reported by the PHY should also be applied to the GMII port
status override otherwise the switch will not generate pause frames towards the
link partner despite the advertisement saying otherwise.

Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 87e81c636339..be0edfa093d0 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -878,6 +878,11 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 		if (duplex == DUPLEX_FULL)
 			reg |= DUPLX_MODE;
 
+		if (tx_pause)
+			reg |= TXFLOW_CNTL;
+		if (rx_pause)
+			reg |= RXFLOW_CNTL;
+
 		core_writel(priv, reg, offset);
 	}
 
-- 
2.25.1

