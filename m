Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3320E4B8D30
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbiBPQD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:03:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235920AbiBPQDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:03:48 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB232A8D14
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 08:03:35 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x5so4661076edd.11
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 08:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=151KIZ20IIFNSQmdYRUVjHa4bOA5A5/XYS9O5JQklAI=;
        b=lh3mDuwouCECAY9+enH6p3rPY0ru9wMKGNyO9MqYiWkYyUbQ9w1kGH+czehn+i5fyi
         nMUpg2Cl+SpQ4itc4p9VCE3jt5w1fz3F83kS37Rzej4zVEDAPEGDcxplSVqP06mpY3gX
         y6ptlLagUW86rybf2y0knm/Kz8YhnQdbqIvzs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=151KIZ20IIFNSQmdYRUVjHa4bOA5A5/XYS9O5JQklAI=;
        b=p2ojMiHTxxI1b7meiPm9w01++5rzMciBnG6NSBUtRvwts28iXNFqz1jTsAwkc8DIji
         w888kNaLe11TFiS6Z9ts1EL/O5QxiXXJdsCSMLcm+ogB6b+bDR+kRLCCXj9Lwlyf4SEU
         NOsL5KXhkN+uYnPPeEE5ewo3ivfSKUBxkA1xUNP9u/9XxQ9PR3mgq44x3vc1mt8rRCBT
         h8GAfvhu77AGdwwQ8ZVMwxA7ZcgqoPlgsQcPjCucQfA8G30KoAWvB/CqBgbxIfO6PjRU
         ie/PdgxU+fyNuPkSPLTHInF1mqpl2F2EgcSHGfAlLfiPnx3XHedP/QX6RSpgkcmAtVWM
         7SpQ==
X-Gm-Message-State: AOAM533zoHkwyV48iAj9eQHRyP/75FfGnfSXTZiaP7fMrFJuBe2YY3we
        h0H6Jziw1SwLExYg0CUTwnUIZA==
X-Google-Smtp-Source: ABdhPJyEaJ8Ox8sISNJO00yJxKPFNXb76QhHKp48G3ttPeQQuAQlcpLs2UxuAMz7MbXgKfHBoFQdfw==
X-Received: by 2002:a05:6402:190:b0:407:27da:4def with SMTP id r16-20020a056402019000b0040727da4defmr3756454edv.345.1645027414469;
        Wed, 16 Feb 2022 08:03:34 -0800 (PST)
Received: from capella.. ([193.89.194.60])
        by smtp.gmail.com with ESMTPSA id j19sm48365ejm.111.2022.02.16.08.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 08:03:33 -0800 (PST)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: dsa: realtek: rtl8365mb: serialize indirect PHY register access
Date:   Wed, 16 Feb 2022 17:05:00 +0100
Message-Id: <20220216160500.2341255-3-alvin@pqrs.dk>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220216160500.2341255-1-alvin@pqrs.dk>
References: <20220216160500.2341255-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Realtek switches in the rtl8365mb family can access the PHY registers of
the internal PHYs via the switch registers. This method is called
indirect access. At a high level, the indirect PHY register access
method involves reading and writing some special switch registers in a
particular sequence. This works for both SMI and MDIO connected
switches.

Currently the rtl8365mb driver does not take any care to serialize the
aforementioned access to the switch registers. In particular, it is
permitted for other driver code to access other switch registers while
the indirect PHY register access is ongoing. Locking is only done at the
regmap level. This, however, is a bug: concurrent register access, even
to unrelated switch registers, risks corrupting the PHY register value
read back via the indirect access method described above.

Arınç reported that the switch sometimes returns nonsense data when
reading the PHY registers. In particular, a value of 0 causes the
kernel's PHY subsystem to think that the link is down, but since most
reads return correct data, the link then flip-flops between up and down
over a period of time.

The aforementioned bug can be readily observed by:

 1. Enabling ftrace events for regmap and mdio
 2. Polling BSMR PHY register for a connected port;
    it should always read the same (e.g. 0x79ed)
 3. Wait for step 2 to give a different value

Example command for step 2:

    while true; do phytool read swp2/2/0x01; done

On my i.MX8MM, the above steps will yield a bogus value for the BSMR PHY
register within a matter of seconds. The interleaved register access it
then evident in the trace log:

 kworker/3:4-70      [003] .......  1927.139849: regmap_reg_write: ethernet-switch reg=1004 val=bd
     phytool-16816   [002] .......  1927.139979: regmap_reg_read: ethernet-switch reg=1f01 val=0
 kworker/3:4-70      [003] .......  1927.140381: regmap_reg_read: ethernet-switch reg=1005 val=0
     phytool-16816   [002] .......  1927.140468: regmap_reg_read: ethernet-switch reg=1d15 val=a69
 kworker/3:4-70      [003] .......  1927.140864: regmap_reg_read: ethernet-switch reg=1003 val=0
     phytool-16816   [002] .......  1927.140955: regmap_reg_write: ethernet-switch reg=1f02 val=2041
 kworker/3:4-70      [003] .......  1927.141390: regmap_reg_read: ethernet-switch reg=1002 val=0
     phytool-16816   [002] .......  1927.141479: regmap_reg_write: ethernet-switch reg=1f00 val=1
 kworker/3:4-70      [003] .......  1927.142311: regmap_reg_write: ethernet-switch reg=1004 val=be
     phytool-16816   [002] .......  1927.142410: regmap_reg_read: ethernet-switch reg=1f01 val=0
 kworker/3:4-70      [003] .......  1927.142534: regmap_reg_read: ethernet-switch reg=1005 val=0
     phytool-16816   [002] .......  1927.142618: regmap_reg_read: ethernet-switch reg=1f04 val=0
     phytool-16816   [002] .......  1927.142641: mdio_access: SMI-0 read  phy:0x02 reg:0x01 val:0x0000 <- ?!
 kworker/3:4-70      [003] .......  1927.143037: regmap_reg_read: ethernet-switch reg=1001 val=0
 kworker/3:4-70      [003] .......  1927.143133: regmap_reg_read: ethernet-switch reg=1000 val=2d89
 kworker/3:4-70      [003] .......  1927.143213: regmap_reg_write: ethernet-switch reg=1004 val=be
 kworker/3:4-70      [003] .......  1927.143291: regmap_reg_read: ethernet-switch reg=1005 val=0
 kworker/3:4-70      [003] .......  1927.143368: regmap_reg_read: ethernet-switch reg=1003 val=0
 kworker/3:4-70      [003] .......  1927.143443: regmap_reg_read: ethernet-switch reg=1002 val=6

The kworker here is polling MIB counters for stats, as evidenced by the
register 0x1004 that we are writing to (RTL8365MB_MIB_ADDRESS_REG). This
polling is performed every 3 seconds, but is just one example of such
unsynchronized access.

Further investigation reveals the underlying problem: if we read from an
arbitrary register A and this read coincides with the indirect access
method in rtl8365mb_phy_ocp_read, then the final read from
RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG will always return the value in
register A. The value read back can be readily poisoned by repeatedly
reading back the value of another register A via debugfs in a busy loop
via the dd utility or similar.

This issue appears to be unique to the indirect PHY register access
pattern. In particular, it does not seem to impact similar sequential
register operations such MIB counter access.

To fix this problem, one must guard against exactly the scenario seen in
the above trace. In particular, other parts of the driver using the
regmap API must not be permitted to access the switch registers until
the PHY register access is complete. Fix this by using the newly
introduced "nolock" regmap in all PHY-related functions, and by aquiring
the regmap mutex at the top level of the PHY register access callbacks.
Although no issue has been observed with PHY register _writes_, this
change also serializes the indirect access method there. This is done
purely as a matter of convenience.

Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
Link: https://lore.kernel.org/netdev/CAJq09z5FCgG-+jVT7uxh1a-0CiiFsoKoHYsAWJtiKwv7LXKofQ@mail.gmail.com/
Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reported-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 54 ++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 2ed592147c20..c39d6b744597 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -590,7 +590,7 @@ static int rtl8365mb_phy_poll_busy(struct realtek_priv *priv)
 {
 	u32 val;
 
-	return regmap_read_poll_timeout(priv->map,
+	return regmap_read_poll_timeout(priv->map_nolock,
 					RTL8365MB_INDIRECT_ACCESS_STATUS_REG,
 					val, !val, 10, 100);
 }
@@ -604,7 +604,7 @@ static int rtl8365mb_phy_ocp_prepare(struct realtek_priv *priv, int phy,
 	/* Set OCP prefix */
 	val = FIELD_GET(RTL8365MB_PHY_OCP_ADDR_PREFIX_MASK, ocp_addr);
 	ret = regmap_update_bits(
-		priv->map, RTL8365MB_GPHY_OCP_MSB_0_REG,
+		priv->map_nolock, RTL8365MB_GPHY_OCP_MSB_0_REG,
 		RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK,
 		FIELD_PREP(RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK, val));
 	if (ret)
@@ -617,8 +617,8 @@ static int rtl8365mb_phy_ocp_prepare(struct realtek_priv *priv, int phy,
 			  ocp_addr >> 1);
 	val |= FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_9_6_MASK,
 			  ocp_addr >> 6);
-	ret = regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG,
-			   val);
+	ret = regmap_write(priv->map_nolock,
+			   RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG, val);
 	if (ret)
 		return ret;
 
@@ -631,36 +631,42 @@ static int rtl8365mb_phy_ocp_read(struct realtek_priv *priv, int phy,
 	u32 val;
 	int ret;
 
+	mutex_lock(&priv->map_lock);
+
 	ret = rtl8365mb_phy_poll_busy(priv);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = rtl8365mb_phy_ocp_prepare(priv, phy, ocp_addr);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Execute read operation */
 	val = FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_CTRL_CMD_MASK,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_CMD_VALUE) |
 	      FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_CTRL_RW_MASK,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_RW_READ);
-	ret = regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_CTRL_REG, val);
+	ret = regmap_write(priv->map_nolock, RTL8365MB_INDIRECT_ACCESS_CTRL_REG,
+			   val);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = rtl8365mb_phy_poll_busy(priv);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Get PHY register data */
-	ret = regmap_read(priv->map, RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG,
-			  &val);
+	ret = regmap_read(priv->map_nolock,
+			  RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG, &val);
 	if (ret)
-		return ret;
+		goto out;
 
 	*data = val & 0xFFFF;
 
-	return 0;
+out:
+	mutex_unlock(&priv->map_lock);
+
+	return ret;
 }
 
 static int rtl8365mb_phy_ocp_write(struct realtek_priv *priv, int phy,
@@ -669,32 +675,38 @@ static int rtl8365mb_phy_ocp_write(struct realtek_priv *priv, int phy,
 	u32 val;
 	int ret;
 
+	mutex_lock(&priv->map_lock);
+
 	ret = rtl8365mb_phy_poll_busy(priv);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = rtl8365mb_phy_ocp_prepare(priv, phy, ocp_addr);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Set PHY register data */
-	ret = regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_WRITE_DATA_REG,
-			   data);
+	ret = regmap_write(priv->map_nolock,
+			   RTL8365MB_INDIRECT_ACCESS_WRITE_DATA_REG, data);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Execute write operation */
 	val = FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_CTRL_CMD_MASK,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_CMD_VALUE) |
 	      FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_CTRL_RW_MASK,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_RW_WRITE);
-	ret = regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_CTRL_REG, val);
+	ret = regmap_write(priv->map_nolock, RTL8365MB_INDIRECT_ACCESS_CTRL_REG,
+			   val);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = rtl8365mb_phy_poll_busy(priv);
 	if (ret)
-		return ret;
+		goto out;
+
+out:
+	mutex_unlock(&priv->map_lock);
 
 	return 0;
 }
-- 
2.35.0

