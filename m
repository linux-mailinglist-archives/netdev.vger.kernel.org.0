Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D044DA4E2
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 22:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352093AbiCOVxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 17:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347332AbiCOVx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 17:53:29 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [202.36.163.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735905BE6B
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 14:52:15 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 9D0CD2C0380;
        Tue, 15 Mar 2022 21:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1647381133;
        bh=zlZqEIEGqiKMEAtztbZeVpfJKsm7kdNzJK4N7UPsXQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4ORk/8gUphDPnIwD+nS5YPKo/0uF2R+IsZp56BYmZsBAIdr0JqsREb870xu98klG
         74vbMvozXU3vNRCEyES8GsqpAHSkUU04mBnMMdRq6C2Ja/e7R4BlQLnSgeCthz+Hxl
         yo9e+KMmYOahio9DNJXr1ch3FifaqJUnYt0RA1XDxha8/CHYrLBvLuVNNMV4xEcJtk
         bjWK6ItuKffqY3ULwYVEW7mDWLGe3aggerX3tbMZ1kmiDyMZcatsbGT7ScG0ON/XXy
         2qCkquCciwc8Dvc+iH3DSgyt94301iZxbbttTipEa3NvBCjxhvnoBP6qQ6pW0wVUPt
         OPpnD6MWFWXpg==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B62310a8d0002>; Wed, 16 Mar 2022 10:52:13 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id 4EA8413EE3F;
        Wed, 16 Mar 2022 10:52:13 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 070B82A2678; Wed, 16 Mar 2022 10:52:10 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        thomas.petazzoni@bootlin.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH net-next v4 2/2] net: mvneta: Add support for 98DX2530 Ethernet port
Date:   Wed, 16 Mar 2022 10:52:07 +1300
Message-Id: <20220315215207.2746793-3-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220315215207.2746793-1-chris.packham@alliedtelesis.co.nz>
References: <20220315215207.2746793-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=Cfh2G4jl c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=o8Y5sQTvuykA:10 a=LxpfyEy1a6e1ozZBTSYA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 98DX2530 SoC is similar to the Armada 3700 except it needs a
different MBUS window configuration. Add a new compatible string to
identify this device and the required MBUS window configuration.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---

Notes:
    Changes in v4:
    - Rebase on top of net-next/master to resolve conflict with 72bb95311=
62a
      ("net: mvneta: reorder initialisation").
    Changes in v3:
    - Split from larger series
    - Add review from Andrew
    Changes in v2:
    - New

 drivers/net/ethernet/marvell/mvneta.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet=
/marvell/mvneta.c
index f1335a1ed695..934f6dd90992 100644
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
@@ -5324,6 +5327,10 @@ static void mvneta_conf_mbus_windows(struct mvneta=
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
@@ -5409,6 +5416,10 @@ static int mvneta_probe(struct platform_device *pd=
ev)
 	/* Get special SoC configurations */
 	if (of_device_is_compatible(dn, "marvell,armada-3700-neta"))
 		pp->neta_armada3700 =3D true;
+	if (of_device_is_compatible(dn, "marvell,armada-ac5-neta")) {
+		pp->neta_armada3700 =3D true;
+		pp->neta_ac5 =3D true;
+	}
=20
 	dev->irq =3D irq_of_parse_and_map(dn, 0);
 	if (dev->irq =3D=3D 0)
@@ -5769,6 +5780,7 @@ static const struct of_device_id mvneta_match[] =3D=
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

