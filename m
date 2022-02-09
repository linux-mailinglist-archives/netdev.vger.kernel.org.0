Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C244E4AFE72
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 21:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiBIU1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 15:27:01 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbiBIU05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 15:26:57 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A70C1DC17A
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 12:26:59 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id x52-20020a05683040b400b0059ea92202daso2338316ott.7
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 12:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ow+RYC+KVhGigMCH8M9YWzygFp8IqxsqeVW4LzhfXwQ=;
        b=I/+nTunm7BJY5KGDFrbPJ5upXxXHDPyfwGKzZkMensWA/8yRrN5xfVs2USp8kD8Dqc
         Ubr51z34hkowS3Utw7qYbQ+To4A//x/hS8HAXqmPTSuRkCVYLM3zSZFG1EoL4iP4FdfN
         TfzzKHBJH/T4YsPyu1yEvp0PTO03o9xTR7pGHEj8Wy67rFKbQ1e2EXTDzQm3dfA2SKGo
         mEjlxY1BKPI07IxgcxcrS5SxwwtclDKh3CjH7/NDT+ZkyQiPkwlMaIVy0rcZw6yEm+9y
         DSK66IzYcNJszFz/yRwbONsknLIHrVhXtK92Z9E52fc2WlgcWvkYw/j3ty//TLpckX27
         oHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ow+RYC+KVhGigMCH8M9YWzygFp8IqxsqeVW4LzhfXwQ=;
        b=mpDViMdNQGkuLUmXVC66P+FYrD8EqsTF33bh+6CVpNkQMKELSRbK6Eau/Hd0yD50Eh
         uxEo9HiZYX3iG53zbOjs2BnZz5xUgZbI0yN92bU+KW48X51q2eMo/9OvJJIBqzN+ruSx
         4LLQKbT1cB1PlbXGshqZ04LR1fxsJsJC4RexVsSp00YG5Pwi/SjRznK+m3DHMtmmhzuE
         OWwRuo4pAMKN3HGwahMLRDMW2nHCDiFMJxlMHagPVjW39Y1ZlCXF1eYcdVQMLy/LOY/w
         Wo+1w53jNM2PHGekCL+m+N/9UznTpcAgIjnnbnxr/tOWedNCcaj4LYtfZXrKRGJP+7w6
         /41w==
X-Gm-Message-State: AOAM533b4257LWLLV1Vynd4Ni1ZmRtgmNCXMQo9H2P87ZRdXceAwk5wL
        iZGKR85CrPFEUxKB18MWNjsIXAthS8VDPg==
X-Google-Smtp-Source: ABdhPJxAqu3DQ9Q7b3eR5DuhH6erJ0IJIfmTGKPevy0EWh71STnOioBO2Ss0N/c66jmZyJ+A9pcinw==
X-Received: by 2002:a05:6830:1be7:: with SMTP id k7mr1688301otb.209.1644438418133;
        Wed, 09 Feb 2022 12:26:58 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id a26sm7300634oiy.26.2022.02.09.12.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 12:26:57 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next] net: dsa: realtek: rtl8365mb: read phy regs from memory when MDIO
Date:   Wed,  9 Feb 2022 17:25:09 -0300
Message-Id: <20220209202508.4419-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
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

In a SMI-connected switch, indirect registers are accessed commanding
the switch to access an address by reading and writing a sequence of
chip registers. However, that process might return a null reading
(0x0000) with no errors if the switch is under stress. When that
happens, the system will detect a link down, followed by a link up,
creating temporary link unavailability.

It was observed only with idle SMP devices and interruptions are not in
use (the system was polling each interface status every second). It
happened with both SMI and MDIO-connected switches. If the OS is under
any load, the same problem does not appear, probably because the polling
process is delayed or serialized.

Although that method to read indirect registers work independently from
the management interface, MDIO-connected can skip part of the process.
Instead of commanding the switch to read a register, the driver can read
directly from the region after RTL8365MB_PHY_BASE=0x0200. It was enough
to workaround the null readings.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 115 ++++++++++++++++++++++++----
 1 file changed, 99 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 2ed592147c20..e0c7f64bc56f 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -595,8 +595,7 @@ static int rtl8365mb_phy_poll_busy(struct realtek_priv *priv)
 					val, !val, 10, 100);
 }
 
-static int rtl8365mb_phy_ocp_prepare(struct realtek_priv *priv, int phy,
-				     u32 ocp_addr)
+static int rtl8365mb_phy_set_ocp_prefix(struct realtek_priv *priv, u32 ocp_addr)
 {
 	u32 val;
 	int ret;
@@ -610,19 +609,22 @@ static int rtl8365mb_phy_ocp_prepare(struct realtek_priv *priv, int phy,
 	if (ret)
 		return ret;
 
-	/* Set PHY register address */
-	val = RTL8365MB_PHY_BASE;
-	val |= FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK, phy);
-	val |= FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_5_1_MASK,
+	return 0;
+}
+
+static u32 rtl8365mb_phy_ocp_ind_addr(int phy, u32 ocp_addr)
+{
+	u32 ind_addr;
+
+	ind_addr = RTL8365MB_PHY_BASE;
+	ind_addr |= FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK,
+			       phy);
+	ind_addr |= FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_5_1_MASK,
 			  ocp_addr >> 1);
-	val |= FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_9_6_MASK,
+	ind_addr |= FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_9_6_MASK,
 			  ocp_addr >> 6);
-	ret = regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG,
-			   val);
-	if (ret)
-		return ret;
 
-	return 0;
+	return ind_addr;
 }
 
 static int rtl8365mb_phy_ocp_read(struct realtek_priv *priv, int phy,
@@ -635,7 +637,13 @@ static int rtl8365mb_phy_ocp_read(struct realtek_priv *priv, int phy,
 	if (ret)
 		return ret;
 
-	ret = rtl8365mb_phy_ocp_prepare(priv, phy, ocp_addr);
+	ret = rtl8365mb_phy_set_ocp_prefix(priv, ocp_addr);
+	if (ret)
+		return ret;
+
+	/* Set PHY register address */
+	ret = regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG,
+			   rtl8365mb_phy_ocp_ind_addr(phy, ocp_addr));
 	if (ret)
 		return ret;
 
@@ -673,7 +681,13 @@ static int rtl8365mb_phy_ocp_write(struct realtek_priv *priv, int phy,
 	if (ret)
 		return ret;
 
-	ret = rtl8365mb_phy_ocp_prepare(priv, phy, ocp_addr);
+	ret = rtl8365mb_phy_set_ocp_prefix(priv, ocp_addr);
+	if (ret)
+		return ret;
+
+	/* Set PHY register address */
+	ret = regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG,
+			   rtl8365mb_phy_ocp_ind_addr(phy, ocp_addr));
 	if (ret)
 		return ret;
 
@@ -757,13 +771,82 @@ static int rtl8365mb_phy_write(struct realtek_priv *priv, int phy, int regnum,
 
 static int rtl8365mb_dsa_phy_read(struct dsa_switch *ds, int phy, int regnum)
 {
-	return rtl8365mb_phy_read(ds->priv, phy, regnum);
+	struct realtek_priv *priv = ds->priv;
+	u32 ocp_addr;
+	u32 ind_addr;
+	uint val;
+	int ret;
+
+	if (phy > RTL8365MB_PHYADDRMAX)
+		return -EINVAL;
+
+	if (regnum > RTL8365MB_PHYREGMAX)
+		return -EINVAL;
+
+	ocp_addr = RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE + regnum * 2;
+
+	ret = rtl8365mb_phy_set_ocp_prefix(priv, ocp_addr);
+	if (ret)
+		return ret;
+
+	ind_addr = rtl8365mb_phy_ocp_ind_addr(phy, ocp_addr);
+
+	/* MDIO-connected switches can read directly from ind_addr (0x2000..)
+	 * although using RTL8365MB_INDIRECT_ACCESS_* does work.
+	 */
+	ret = regmap_read(priv->map, ind_addr, &val);
+	if (ret) {
+		dev_err(priv->dev,
+			"failed to read PHY%d reg %02x @ %04x, ret %d\n", phy,
+			regnum, ocp_addr, ret);
+		return ret;
+	}
+
+	val = val & 0xFFFF;
+
+	dev_dbg(priv->dev, "read PHY%d register 0x%02x @ %04x, val <- %04x\n",
+		phy, regnum, ocp_addr, val);
+
+	return val;
 }
 
 static int rtl8365mb_dsa_phy_write(struct dsa_switch *ds, int phy, int regnum,
 				   u16 val)
 {
-	return rtl8365mb_phy_write(ds->priv, phy, regnum, val);
+	struct realtek_priv *priv = ds->priv;
+	u32 ocp_addr;
+	u32 ind_addr;
+	int ret;
+
+	if (phy > RTL8365MB_PHYADDRMAX)
+		return -EINVAL;
+
+	if (regnum > RTL8365MB_PHYREGMAX)
+		return -EINVAL;
+
+	ocp_addr = RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE + regnum * 2;
+
+	ret = rtl8365mb_phy_set_ocp_prefix(priv, ocp_addr);
+	if (ret)
+		return ret;
+
+	ind_addr = rtl8365mb_phy_ocp_ind_addr(phy, ocp_addr);
+
+	/* MDIO-connected switches can write directly from ind_addr (0x2000..)
+	 * although using RTL8365MB_INDIRECT_ACCESS_* does work.
+	 */
+	ret = regmap_write(priv->map, ind_addr, val);
+	if (ret) {
+		dev_err(priv->dev,
+			"failed to write PHY%d reg %02x @ %04x, ret %d\n", phy,
+			regnum, ocp_addr, ret);
+		return ret;
+	}
+
+	dev_dbg(priv->dev, "write PHY%d register 0x%02x @ %04x, val -> %04x\n",
+		phy, regnum, ocp_addr, val);
+
+	return 0;
 }
 
 static enum dsa_tag_protocol
-- 
2.35.1

