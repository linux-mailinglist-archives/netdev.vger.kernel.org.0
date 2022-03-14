Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6A44D8ED3
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 22:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242205AbiCNVeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 17:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245310AbiCNVd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 17:33:28 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31769338AD
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 14:32:16 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 1EA082C0C39;
        Mon, 14 Mar 2022 21:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1647293528;
        bh=punlUPwzhLq2aNImmS3zO5FPIVQncUsJmvgvJZGXmoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wyJDktDKDvdDZGH6CEngzpJbht8r3KGhCjNawk+44Xs21XaSEfY3NVLyX3EXWaDKb
         /8MRkGOScVU3r+DdRImYk3MTyYuEL9OOZQFFqgOe4y7aYohQ9jlgCfbG4X5L316XvU
         uacrNAjOW51NsLNciQAE97fVKjwH1sCQCqxGnUtdm2P3IUAv0dsMDAUg51Dplk6TlX
         TBRd7mIewPw2pT6K5gDWh5gGCUHYHYQtYrevPODna+OHJ/dAf5OKCm4NeEMpfqa4wv
         tpMBH6E9PWw+Wbx7VMUh92iXpMf/EZ5AkaGuP8kowMAuPiyPf9kuH9EX25ibktpLBf
         wixl1rE3q5ZEg==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B622fb4570005>; Tue, 15 Mar 2022 10:32:07 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id 13F3D13EEAA;
        Tue, 15 Mar 2022 10:32:07 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id EEEB72A2678; Tue, 15 Mar 2022 10:32:03 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     huziji@marvell.com, ulf.hansson@linaro.org, robh+dt@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        catalin.marinas@arm.com, will@kernel.org, andrew@lunn.ch,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        adrian.hunter@intel.com, thomas.petazzoni@bootlin.com,
        kostap@marvell.com, robert.marko@sartura.hr
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v2 5/8] net: mvneta: Add support for 98DX2530 Ethernet port
Date:   Tue, 15 Mar 2022 10:31:40 +1300
Message-Id: <20220314213143.2404162-6-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
References: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=Cfh2G4jl c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=o8Y5sQTvuykA:10 a=LxpfyEy1a6e1ozZBTSYA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 98DX2530 SoC is similar to the Armada 3700 except it needs a
different MBUS window configuration. Add a new compatible string to
identify this device and the required MBUS window configuration.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---

Notes:
    Changes in v2:
    - New

 drivers/net/ethernet/marvell/mvneta.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet=
/marvell/mvneta.c
index 83c8908f0cc7..000929794266 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -76,6 +76,8 @@
 #define MVNETA_WIN_SIZE(w)                      (0x2204 + ((w) << 3))
 #define MVNETA_WIN_REMAP(w)                     (0x2280 + ((w) << 2))
 #define MVNETA_BASE_ADDR_ENABLE                 0x2290
+#define      MVNETA_AC5_CNM_DDR_TARGET		0x2
+#define      MVNETA_AC5_CNM_DDR_ATTR		0xb
 #define MVNETA_ACCESS_PROTECT_ENABLE            0x2294
 #define MVNETA_PORT_CONFIG                      0x2400
 #define      MVNETA_UNI_PROMISC_MODE            BIT(0)
@@ -544,6 +546,7 @@ struct mvneta_port {
=20
 	/* Flags for special SoC configurations */
 	bool neta_armada3700;
+	bool neta_ac5;
 	u16 rx_offset_correction;
 	const struct mbus_dram_target_info *dram_target_info;
 };
@@ -5272,6 +5275,10 @@ static void mvneta_conf_mbus_windows(struct mvneta=
_port *pp,
 			win_protect |=3D 3 << (2 * i);
 		}
 	} else {
+		if (pp->neta_ac5)
+			mvreg_write(pp, MVNETA_WIN_BASE(0),
+				    (MVNETA_AC5_CNM_DDR_ATTR << 8) |
+				    MVNETA_AC5_CNM_DDR_TARGET);
 		/* For Armada3700 open default 4GB Mbus window, leaving
 		 * arbitration of target/attribute to a different layer
 		 * of configuration.
@@ -5397,6 +5404,11 @@ static int mvneta_probe(struct platform_device *pd=
ev)
 	/* Get special SoC configurations */
 	if (of_device_is_compatible(dn, "marvell,armada-3700-neta"))
 		pp->neta_armada3700 =3D true;
+	if (of_device_is_compatible(dn, "marvell,armada-ac5-neta")) {
+		pp->neta_armada3700 =3D true;
+		pp->neta_ac5 =3D true;
+	}
+
=20
 	pp->clk =3D devm_clk_get(&pdev->dev, "core");
 	if (IS_ERR(pp->clk))
@@ -5720,6 +5732,7 @@ static const struct of_device_id mvneta_match[] =3D=
 {
 	{ .compatible =3D "marvell,armada-370-neta" },
 	{ .compatible =3D "marvell,armada-xp-neta" },
 	{ .compatible =3D "marvell,armada-3700-neta" },
+	{ .compatible =3D "marvell,armada-ac5-neta" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, mvneta_match);
--=20
2.35.1

