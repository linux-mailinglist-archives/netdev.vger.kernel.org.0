Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060AF6E4CA2
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjDQPSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjDQPSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:18:47 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C2F72AE;
        Mon, 17 Apr 2023 08:18:39 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-2efac435608so1514727f8f.3;
        Mon, 17 Apr 2023 08:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744717; x=1684336717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1MW6xivzd352Exo6BdAvt5sq+6GrYH5KFNVqtE0mY4=;
        b=Z76/rwOAOzlCNPMvtwsPc95hcbuhG7GML/sUigWaLACArj62a9yF7sWrPfhSrSK2En
         jKiHl2xRx5JVtGPVmB/2wst28I8Sk0dHEkvD6N07F9QVXD0qbmSH2DI9zldH8QzISyo0
         CleUj9QyBl5ze+34wyIQZ+95tWZwTUckG95Y9Et3m/5UCo5cagoDPgBOW/ZbCEp8KVEO
         WC289cFr7Gc2trt/hALwEaQbL9cSjevEkRNi0ykCUrYXyM97mthjBSUCHHzo8EhzVQn/
         uY0V1mWmTZWYZZ8/ZRc2NoFev87B9mvN3ytEyhEtup9gOUl1gmtELDh2z3WcvFG2rmFb
         zfrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744717; x=1684336717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k1MW6xivzd352Exo6BdAvt5sq+6GrYH5KFNVqtE0mY4=;
        b=dSqJoLCk/GsSsWBxFoLJogVC4Ury/nlKbVDHsuqUQ8yyuVT6XAvbca8FA6urxDHT5f
         ChY9BZ3mBg775zcDZxUgdivNnSc3z30Nx7j8yw6JuGlTr6VOzSlVWizwrxGCyRAuN3+j
         6owCsWtNs3r9OY8OKRqGBCHKJECTR7VkD17XRWFg9VSJRe2jozfgrm2Atz0XeYGajj1f
         5PPtER4ijRAdloec3QbsZ20zyqtRTcIqSCkP06LI7lP+r/x7gJdg0Rbfb7OH4uL88cEb
         JcQ/BBW3jxR1+UqWmXmCYeESal9WMrAD3A3utXKjuKIh2McmJ5tAWWOcCCjF3UAzLNpV
         T1fQ==
X-Gm-Message-State: AAQBX9f7vlaALIWWCp/dtFGK4+DuF3Vdh1e99JjPn4BTAL2F2LjDaYVB
        3h4zDL1cdiLT/OJ2yu3LNQA=
X-Google-Smtp-Source: AKy350YfdukjmZAn6zy7Y3dzj+UEoeFI/PVFj+jnOKCyq4V8KA9k1cD0MZFo0ouLfAB5+j7uo6k0tw==
X-Received: by 2002:a5d:6289:0:b0:2f9:357:bb5a with SMTP id k9-20020a5d6289000000b002f90357bb5amr5264134wru.25.1681744716939;
        Mon, 17 Apr 2023 08:18:36 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:18:22 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Cc:     Michal Kubiak <michal.kubiak@intel.com>
Subject: [net-next PATCH v7 01/16] net: dsa: qca8k: move qca8k_port_to_phy() to header
Date:   Mon, 17 Apr 2023 17:17:23 +0200
Message-Id: <20230417151738.19426-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417151738.19426-1-ansuelsmth@gmail.com>
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
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

Move qca8k_port_to_phy() to qca8k header as it's useful for future
reference in Switch LEDs module since the same logic is applied to get
the right index of the switch port.
Make it inline as it's simple function that just decrease the port.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 15 ---------------
 drivers/net/dsa/qca/qca8k.h      | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 62810903f1b3..20acbd0292f1 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -772,21 +772,6 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	return ret;
 }
 
-static u32
-qca8k_port_to_phy(int port)
-{
-	/* From Andrew Lunn:
-	 * Port 0 has no internal phy.
-	 * Port 1 has an internal PHY at MDIO address 0.
-	 * Port 2 has an internal PHY at MDIO address 1.
-	 * ...
-	 * Port 5 has an internal PHY at MDIO address 4.
-	 * Port 6 has no internal PHY.
-	 */
-
-	return port - 1;
-}
-
 static int
 qca8k_mdio_busy_wait(struct mii_bus *bus, u32 reg, u32 mask)
 {
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 7996975d29d3..dd7deb9095d3 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -421,6 +421,20 @@ struct qca8k_fdb {
 	u8 mac[6];
 };
 
+static inline u32 qca8k_port_to_phy(int port)
+{
+	/* From Andrew Lunn:
+	 * Port 0 has no internal phy.
+	 * Port 1 has an internal PHY at MDIO address 0.
+	 * Port 2 has an internal PHY at MDIO address 1.
+	 * ...
+	 * Port 5 has an internal PHY at MDIO address 4.
+	 * Port 6 has no internal PHY.
+	 */
+
+	return port - 1;
+}
+
 /* Common setup function */
 extern const struct qca8k_mib_desc ar8327_mib[];
 extern const struct regmap_access_table qca8k_readable_table;
-- 
2.39.2

