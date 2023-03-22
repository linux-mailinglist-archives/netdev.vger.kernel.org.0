Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B006C4E86
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 15:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjCVOwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 10:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjCVOwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 10:52:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E944169CC0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 07:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679496587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HPCji8KxlP8RVox763kqVVCoDfgGEnOq0lSEgexYy6Y=;
        b=O1Nn4k4El/3Tpbc7Rmu4g5VQdHjDvwhVk5ArDqmBLBuJMdhFUEo+zkLhpMX+L2a45YOspp
        WWdqYILwABkrf29wSWVOjYpMPeVgAEMgapJ305MS4KR1U3YirQOzuJNrGzMcFPydzO1Q2z
        FVFfdSVHFaONwKm2shHGN1q/sHS6Ym0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-7m5P_9ifMeO1kyMJkRMxVw-1; Wed, 22 Mar 2023 10:49:46 -0400
X-MC-Unique: 7m5P_9ifMeO1kyMJkRMxVw-1
Received: by mail-qk1-f200.google.com with SMTP id ou5-20020a05620a620500b007423e532628so8740567qkn.5
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 07:49:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679496585;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HPCji8KxlP8RVox763kqVVCoDfgGEnOq0lSEgexYy6Y=;
        b=avOgMlWcP83SComrd94NWCFEMf+oQGDQ2hToFj7Fwm3oZoYk0pC79hfDY9Mq+ZMxu2
         IXNMhnsJvyRKjO9GWV/Gcl5Ko3/WujePoS4uhUxIblOq8e/uB6l+EVlhOLGJ39MELpGc
         ILalEReJMbYTG/ffZNBgOnRuDonLkcDEhdOpwuJn3i5BJFnuX4axjw6viFqE1cX5DuYs
         3+XiJTdPo0NpFY8gkTt/uiHDU/WZ6Chms01XPNkYPjoSr17N1JjdqWuvqxSJxoUuTcjv
         vAmQbyi34PpuW1zuI9p33L7Ae5e3FRfsizs2AOqz/cc3xr5rvUs6Y0UZrnB1F33MoWkd
         C0/g==
X-Gm-Message-State: AO0yUKWaHJW/2X8tGrZDSEtbm6HID8pixOp09r85H+yjHe0yVQlOsL+n
        mjqYVwozIGlL8X+GqElTikxiPLZd9i+TNhMs9UALK/A3Q/xzpMVAjNT1TCWCuprhTW4INm2V7QM
        +6ssCvVArEBHDustmNh/gvfAd
X-Received: by 2002:a05:622a:198b:b0:3e1:b2b4:f766 with SMTP id u11-20020a05622a198b00b003e1b2b4f766mr10608255qtc.5.1679496585390;
        Wed, 22 Mar 2023 07:49:45 -0700 (PDT)
X-Google-Smtp-Source: AK7set83+n/pztQhG0B5NmXUaaIX9TsRMBjqkX8q3XBT3i8cD2jdTaYA03sxBlOy5HHAN4ULkFjYyg==
X-Received: by 2002:a05:622a:198b:b0:3e1:b2b4:f766 with SMTP id u11-20020a05622a198b00b003e1b2b4f766mr10608233qtc.5.1679496585125;
        Wed, 22 Mar 2023 07:49:45 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-168.dyn.eolo.it. [146.241.244.168])
        by smtp.gmail.com with ESMTPSA id r132-20020a37448a000000b007466432a559sm9267612qka.86.2023.03.22.07.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 07:49:44 -0700 (PDT)
Message-ID: <3b9793e1b2d16c49eb4af40c2c48609a09e2bc5a.camel@redhat.com>
Subject: Re: [PATCH net-next 2/4] net: ethernet: ti: am65-cpsw: Add support
 for SGMII mode
From:   Paolo Abeni <pabeni@redhat.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        rogerq@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
Date:   Wed, 22 Mar 2023 15:49:41 +0100
In-Reply-To: <ZBnPdlFS2P3Iie5k@shell.armlinux.org.uk>
References: <20230321111958.2800005-1-s-vadapalli@ti.com>
         <20230321111958.2800005-3-s-vadapalli@ti.com>
         <ZBmVGu2vf1ADmEuN@shell.armlinux.org.uk>
         <9b9ba199-8379-0840-b99a-d729f8ad33e1@ti.com>
         <ZBnPdlFS2P3Iie5k@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, 2023-03-21 at 15:38 +0000, Russell King (Oracle) wrote:
> On Tue, Mar 21, 2023 at 07:04:50PM +0530, Siddharth Vadapalli wrote:
> > Hello Russell,
> >=20
> > On 21-03-2023 16:59, Russell King (Oracle) wrote:
> > > On Tue, Mar 21, 2023 at 04:49:56PM +0530, Siddharth Vadapalli wrote:
> > > > Add support for configuring the CPSW Ethernet Switch in SGMII mode.
> > > >=20
> > > > Depending on the SoC, allow selecting SGMII mode as a supported int=
erface,
> > > > based on the compatible used.
> > > >=20
> > > > Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> > > > ---
> > > >  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 11 ++++++++++-
> > > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > >=20
> > > > diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net=
/ethernet/ti/am65-cpsw-nuss.c
> > > > index cba8db14e160..d2ca1f2035f4 100644
> > > > --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> > > > +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> > > > @@ -76,6 +76,7 @@
> > > >  #define AM65_CPSW_PORTN_REG_TS_CTL_LTYPE2       0x31C
> > > > =20
> > > >  #define AM65_CPSW_SGMII_CONTROL_REG		0x010
> > > > +#define AM65_CPSW_SGMII_MR_ADV_ABILITY_REG	0x018
> > > >  #define AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE	BIT(0)
> > >=20
> > > Isn't this misplaced? Shouldn't AM65_CPSW_SGMII_MR_ADV_ABILITY_REG co=
me
> > > after AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE, rather than splitting tha=
t
> > > from its register offset definition?
> >=20
> > Thank you for reviewing the patch. The registers are as follows:
> > CONTROL_REG offset 0x10
> > STATUS_REG offset  0x14
> > MR_ADV_REG offset  0x18
> >=20
> > Since the STATUS_REG is not used in the driver, its offset is omitted.
> > The next register is the MR_ADV_REG, which I placed after the
> > CONTROL_REG. I grouped the register offsets together, to represent the
> > order in which the registers are placed. Due to this, the
> > MR_ADV_ABILITY_REG offset is placed after the CONTROL_REG offset define=
.
> >=20
> > Please let me know if I should move it after the CONTROL_MR_AN_ENABLE
> > define instead.
>=20
> Well, it's up to you - whether you wish to group the register offsets
> separately from the bit definitions for those registers, or whether
> you wish to describe the register offset and its associated bit
> definitions in one group before moving on to the next register.
>=20
> > > If the advertisement register is at 0x18, and the lower 16 bits is th=
e
> > > advertisement, are the link partner advertisement found in the upper
> > > 16 bits?
> >=20
> > The MR_LP_ADV_ABILITY_REG is at offset 0x020, which is the the register
> > corresponding to the Link Partner advertised value. Also, the
> > AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE Bit is in the CONTROL_REG. The CPS=
W
> > Hardware specification describes the process of configuring the CPSW MA=
C
> > for SGMII mode as follows:
> > 1. Write 0x1 (ADVERTISE_SGMII) to the MR_ADV_ABILITY_REG register.
> > 2. Enable auto-negotiation in the CONTROL_REG by setting the
> > AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE bit.
>=20
> Good to hear that there is a link partner register.
>=20
> > > >  #define AM65_CPSW_CTL_VLAN_AWARE		BIT(1)
> > > > @@ -1496,9 +1497,14 @@ static void am65_cpsw_nuss_mac_config(struct=
 phylink_config *config, unsigned in
> > > >  	struct am65_cpsw_port *port =3D container_of(slave, struct am65_c=
psw_port, slave);
> > > >  	struct am65_cpsw_common *common =3D port->common;
> > > > =20
> > > > -	if (common->pdata.extra_modes & BIT(state->interface))
> > > > +	if (common->pdata.extra_modes & BIT(state->interface)) {
> > > > +		if (state->interface =3D=3D PHY_INTERFACE_MODE_SGMII)
> > > > +			writel(ADVERTISE_SGMII,
> > > > +			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
> > > > +
> > >=20
> > > I think we can do better with this, by implementing proper PCS suppor=
t.
> > >=20
> > > It seems manufacturers tend to use bought-in IP for this, so have a
> > > look at drivers/net/pcs/ to see whether any of those (or the one in
> > > the Mediatek patch set on netdev that has recently been applied) will
> > > idrive your hardware.
> > >=20
> > > However, given the definition of AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE=
,
> > > I suspect you won't find a compatible implementation.
> >=20
> > I have tested with an SGMII Ethernet PHY in the standard SGMII MAC2PHY
> > configuration. I am not sure if PCS support will be required or not. I
> > hope that the information shared above by me regarding the CPSW
> > Hardware's specification for configuring it in SGMII mode will help
> > determine what the right approach might be. Please let me know whether
> > the current implementation is acceptable or PCS support is necessary.
>=20
> Nevertheless, this SGMII block is a PCS, and if you're going to want to
> support inband mode (e.g. to read the SGMII word from the PHY), or if
> someone ever wants to use 1000base-X, you're going to need to implement
> this properly as a PCS.
>=20
> That said, it can be converted later, so isn't a blocking sisue.

Just to be on the same page, I read all the above as you do accept/do
not oppose to this series in the current form, am I correct?

Thanks,

Paolo

