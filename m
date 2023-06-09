Return-Path: <netdev+bounces-9659-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1917772A22B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:28:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69C0E1C21110
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:28:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA522107D;
	Fri,  9 Jun 2023 18:28:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D7E18C34
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:28:22 +0000 (UTC)
Received: from mail-4318.protonmail.ch (mail-4318.protonmail.ch [185.70.43.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BBA35B6;
	Fri,  9 Jun 2023 11:28:21 -0700 (PDT)
Date: Fri, 09 Jun 2023 18:28:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1686335299; x=1686594499;
	bh=dB2CIMlIx8K8kX4QYd3DEOspDKK7Zaf5MnV9JTtqdRk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=hhNri5fqxPzEnbepKsXoEc5rD4h70EAkS3DQbu566g9behmySfkDJNbHIsqU6YLad
	 n2UyPOMa0Ur9DnJWj5TKxThndAR+aYfTTDEYFo/0NTKZ4ZYaRQd3ieDOLeiuGT4S4X
	 1M3jkCJ1OCgeEpv0Enixze9tSSVM7v7OUSUjILYtec54W7TQq6XoohhbkzsNf7lw3R
	 EgTWgj+N1K8U/ReM5q+HjyPN72kdWeaUT1YI3rkiUG2Gcs6ySLDTawkZSTnhERkarg
	 H7rswzVmYYGR9ei2IMKleuJBSKKix0fK63anpen4ucNDv1cmIc8Oss1mkp4Nm5ZgeX
	 xi26dTAcAYxRg==
To: linux-kernel@vger.kernel.org
From: Raymond Hackley <raymondhackley@protonmail.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Michael Walle <michael@walle.cc>, =?utf-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Jeremy Kerr <jk@codeconstruct.com.au>, Raymond Hackley <raymondhackley@protonmail.com>, netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v3 2/2] NFC: nxp-nci: Add pad supply voltage pvdd-supply
Message-ID: <20230609182729.85088-2-raymondhackley@protonmail.com>
In-Reply-To: <20230609182729.85088-1-raymondhackley@protonmail.com>
References: <20230609182639.85034-1-raymondhackley@protonmail.com> <20230609182729.85088-1-raymondhackley@protonmail.com>
Feedback-ID: 49437091:user:proton
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H5,
	RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PN547/553, QN310/330 chips on some devices require a pad supply voltage
(PVDD). Otherwise, the NFC won't power up.

Implement support for pad supply voltage pvdd-supply that is enabled by
the nxp-nci driver so that the regulator gets enabled when needed.

Signed-off-by: Raymond Hackley <raymondhackley@protonmail.com>
---
 drivers/nfc/nxp-nci/i2c.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index d4c299be7949..6f01152d2c83 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -35,6 +35,7 @@ struct nxp_nci_i2c_phy {
=20
 =09struct gpio_desc *gpiod_en;
 =09struct gpio_desc *gpiod_fw;
+=09struct regulator *pvdd;
=20
 =09int hard_fault; /*
 =09=09=09 * < 0 if hardware error occurred (e.g. i2c err)
@@ -263,6 +264,20 @@ static const struct acpi_gpio_mapping acpi_nxp_nci_gpi=
os[] =3D {
 =09{ }
 };
=20
+static void nxp_nci_i2c_poweroff(void *data)
+{
+=09struct nxp_nci_i2c_phy *phy =3D data;
+=09struct device *dev =3D &phy->i2c_dev->dev;
+=09struct regulator *pvdd =3D phy->pvdd;
+=09int r;
+
+=09if (!IS_ERR(pvdd) && regulator_is_enabled(pvdd)) {
+=09=09r =3D regulator_disable(pvdd);
+=09=09if (r < 0)
+=09=09=09dev_warn(dev, "Failed to disable regulator pvdd: %d\n", r);
+=09}
+}
+
 static int nxp_nci_i2c_probe(struct i2c_client *client)
 {
 =09struct device *dev =3D &client->dev;
@@ -298,6 +313,25 @@ static int nxp_nci_i2c_probe(struct i2c_client *client=
)
 =09=09return PTR_ERR(phy->gpiod_fw);
 =09}
=20
+=09phy->pvdd =3D devm_regulator_get_optional(dev, "pvdd");
+=09if (IS_ERR(phy->pvdd)) {
+=09=09r =3D PTR_ERR(phy->pvdd);
+=09=09if (r !=3D -ENODEV)
+=09=09=09return dev_err_probe(dev, r, "Failed to get regulator pvdd\n");
+=09} else {
+=09=09r =3D regulator_enable(phy->pvdd);
+=09=09if (r < 0) {
+=09=09=09nfc_err(dev, "Failed to enable regulator pvdd: %d\n", r);
+=09=09=09return r;
+=09=09}
+=09}
+
+=09r =3D devm_add_action_or_reset(dev, nxp_nci_i2c_poweroff, phy);
+=09if (r < 0) {
+=09=09nfc_err(dev, "Failed to install poweroff handler: %d\n", r);
+=09=09return r;
+=09}
+
 =09r =3D nxp_nci_probe(phy, &client->dev, &i2c_phy_ops,
 =09=09=09  NXP_NCI_I2C_MAX_PAYLOAD, &phy->ndev);
 =09if (r < 0)
--=20
2.30.2



