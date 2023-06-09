Return-Path: <netdev+bounces-9644-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC4672A167
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:40:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EBFE281999
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A2E206A6;
	Fri,  9 Jun 2023 17:40:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661B01C76B
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:40:18 +0000 (UTC)
X-Greylist: delayed 7084 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Jun 2023 10:40:16 PDT
Received: from mail-40132.protonmail.ch (mail-40132.protonmail.ch [185.70.40.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B73E4E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:40:16 -0700 (PDT)
Date: Fri, 09 Jun 2023 17:40:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1686332413; x=1686591613;
	bh=6/Y7CL3SycH5fGS6a/sM9Q9CKvQ3tqAcFpzGZckwOSY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=U096p8rXomejIuyeT+ERL5Z5pO/zC4eSv/OnUJT7oxAI+S4c4ekQjhAvcQkpyROvU
	 CFQOGqOI/pXXeBDOmle/dD7ouscyZxAMBazE1jqN0VyldPcyMY+zrs6sgKGNapINYI
	 bFRzEjBvnAXDsTitDgPnQEnHBB/OfqvS6M9GpR5raaENEoFQzNHLm/s7SWPyxgsZlX
	 iUFr0ve/pf6MJN2hWfFOeVxPVN21fr2fKRzBEWIrbceZqFSHWPsEUSOG8dZAFr6r7E
	 U74nYciRJMc4ARSM13/oR1KZL8njQMfM9Cl8XYoTC1iEXI1iFnpMaL4ibIPut+Qzw6
	 aFFTqTgu2kqfg==
To: krzysztof.kozlowski@linaro.org
From: Raymond Hackley <raymondhackley@protonmail.com>
Cc: broonie@kernel.org, davem@davemloft.net, devicetree@vger.kernel.org, edumazet@google.com, jk@codeconstruct.com.au, kuba@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org, michael@walle.cc, netdev@vger.kernel.org, pabeni@redhat.com, raymondhackley@protonmail.com, robh+dt@kernel.org, u.kleine-koenig@pengutronix.de
Subject: Re: [PATCH v2 2/2] NFC: nxp-nci: Add pad supply voltage pvdd-supply
Message-ID: <20230609173935.84424-1-raymondhackley@protonmail.com>
In-Reply-To: <e2bb439c-9b72-991b-00f6-0b5e7602efd9@linaro.org>
References: <20230609154033.3511-1-raymondhackley@protonmail.com> <20230609154200.3620-1-raymondhackley@protonmail.com> <e2bb439c-9b72-991b-00f6-0b5e7602efd9@linaro.org>
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
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Krzysztof,

On Friday, June 9th, 2023 at 3:46 PM, Krzysztof Kozlowski <krzysztof.kozlow=
ski@linaro.org> wrote:


> On 09/06/2023 17:42, Raymond Hackley wrote:
>
> > PN547/553, QN310/330 chips on some devices require a pad supply voltage
> > (PVDD). Otherwise, the NFC won't power up.
> >
> > Implement support for pad supply voltage pvdd-supply that is enabled by
> > the nxp-nci driver so that the regulator gets enabled when needed.
> >
> > Signed-off-by: Raymond Hackley raymondhackley@protonmail.com
> > ---
> > drivers/nfc/nxp-nci/i2c.c | 42 +++++++++++++++++++++++++++++++++++++++
> > 1 file changed, 42 insertions(+)
> >
> > diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
> > index d4c299be7949..1b8877757cee 100644
> > --- a/drivers/nfc/nxp-nci/i2c.c
> > +++ b/drivers/nfc/nxp-nci/i2c.c
> > @@ -35,6 +35,7 @@ struct nxp_nci_i2c_phy {
> >
> > struct gpio_desc *gpiod_en;
> > struct gpio_desc *gpiod_fw;
> > + struct regulator *pvdd;
> >
> > int hard_fault; /*
> > * < 0 if hardware error occurred (e.g. i2c err)
> > @@ -263,6 +264,22 @@ static const struct acpi_gpio_mapping acpi_nxp_nci=
_gpios[] =3D {
> > { }
> > };
> >
> > +static void nxp_nci_i2c_poweroff(void *data)
> > +{
> > + struct nxp_nci_i2c_phy *phy =3D data;
> > + struct device *dev =3D &phy->i2c_dev->dev;
> > + struct regulator *pvdd =3D phy->pvdd;
> > + int r;
> > +
> > + if (!IS_ERR(pvdd) && regulator_is_enabled(pvdd)) {
>
>
> Why do you need these checks? This should be called in correct context,
> so when regulator is valid and enabled. If you have such checks it
> suggests that code is buggy and this is being called in wrong contexts.
>

First condition !IS_ERR(pvdd) is to check if pvdd exists.
Some devices, msm8916-samsung-serranove for example, doesn't need pvdd or
have it bound in the device tree:

https://github.com/torvalds/linux/commit/ab0f0987e035f908d670fed7d86efa6fac=
66c0bb

Without !IS_ERR(pvdd), checking it with regulator_is_enabled(pvdd):

[   50.161882] 8<--- cut here ---
[   50.161906] Unable to handle kernel paging request at virtual address ff=
fffff9 when read
[   50.161916] [fffffff9] *pgd=3Daffff841, *pte=3D00000000, *ppte=3D0000000=
0
[   50.161938] Internal error: Oops: 27 [#1] PREEMPT SMP ARM

Or disabling it directly with regulator_disable(pvdd):

[   69.439827] 8<--- cut here ---
[   69.439841] Unable to handle kernel NULL pointer dereference at virtual =
address 00000045 when read
[   69.439852] [00000045] *pgd=3D00000000
[   69.439864] Internal error: Oops: 5 [#1] PREEMPT SMP ARM

Second condition regulator_is_enabled(pvdd) is to make sure that pvdd is
disabled with balance.

Similar checks can be found here:

https://elixir.bootlin.com/linux/v6.4-rc5/source/drivers/staging/greybus/ar=
che-apb-ctrl.c#L208

> > + r =3D regulator_disable(pvdd);
> > + if (r < 0)
> > + dev_warn(dev,
> > + "Failed to disable regulator pvdd: %d\n",
> > + r);
>
>
> Weird wrapping. Why r is wrapped?
>
> > + }
> > +}
> > +
> > static int nxp_nci_i2c_probe(struct i2c_client *client)
> > {
> > struct device *dev =3D &client->dev;
> > @@ -298,6 +315,29 @@ static int nxp_nci_i2c_probe(struct i2c_client *cl=
ient)
> > return PTR_ERR(phy->gpiod_fw);
> > }
> >
> > + phy->pvdd =3D devm_regulator_get_optional(dev, "pvdd");
> > + if (IS_ERR(phy->pvdd)) {
> > + r =3D PTR_ERR(phy->pvdd);
> > + if (r !=3D -ENODEV)
> > + return dev_err_probe(dev, r,
> > + "Failed to get regulator pvdd\n");
> > + } else {
> > + r =3D regulator_enable(phy->pvdd);
> > + if (r < 0) {
> > + nfc_err(dev,
> > + "Failed to enable regulator pvdd: %d\n",
> > + r);
>
>
> Weird wrapping. Why r is wrapped?
>
> > + return r;
> > + }
> > + }
> > +
> > + r =3D devm_add_action_or_reset(dev, nxp_nci_i2c_poweroff, phy);
> > + if (r < 0) {
> > + nfc_err(dev, "Failed to install poweroff handler: %d\n",
> > + r);
>
>
> Weird wrapping. Why r is wrapped?
>
> Just move it to the success path of enabling regulator.
>

Yes. This will be fixed in v3.

> > + return r;
> > + }
> > +
> > r =3D nxp_nci_probe(phy, &client->dev, &i2c_phy_ops,
> > NXP_NCI_I2C_MAX_PAYLOAD, &phy->ndev);
> > if (r < 0)
> > @@ -319,6 +359,8 @@ static void nxp_nci_i2c_remove(struct i2c_client *c=
lient)
> >
> > nxp_nci_remove(phy->ndev);
> > free_irq(client->irq, phy);
> > +
> > + nxp_nci_i2c_poweroff(phy);
>
>
> Why? This code is buggy...
>

I don't have a good reason to keep it and will drop it in v3.

Regards,
Raymond

>
>
> Best regards,
> Krzysztof


