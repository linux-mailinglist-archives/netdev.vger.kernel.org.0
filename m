Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB1E604528
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 14:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiJSMW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 08:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbiJSMWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 08:22:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6476E1C5A60;
        Wed, 19 Oct 2022 04:57:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7550CB821CA;
        Wed, 19 Oct 2022 10:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48663C433D6;
        Wed, 19 Oct 2022 10:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666176905;
        bh=idEVXSwxLwj6QnaxcDCI8JDt8n19iJKQG++3Lw7GrNo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rPhQdPp+mGfA8w2CpVUhb0Yfp91/gpA36uNrJBDKa8IlA7XwJuaCOnp2xNuinnkmh
         2KuR8q8ACCHBYBApsVvHboUeWZGUmOa//3GYmVs9L5IfG65oF3bekcZ3g1jS5xAYCo
         tJAMlFk1fVR3sIaQXBBRAqOu8dR7wWT1JEtCDTHIp4kEj/BakjkvtT83Ss+C57KGg0
         w7JrBNwTEtNJSNgzriKaclqZ6e4rwyfPAIbEW0Cb0Pi5U50u26ch7x1R9MJy8sCHxX
         KTBVU+HW2E2JDT124IXNhCdWzVFXlkpFBZzEGa1zrC3yBeVRPlkgswyehR6OxBk9RP
         W5JjwWfnLY2ig==
Date:   Wed, 19 Oct 2022 12:55:00 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH RFC 2/3] net: phy: marvell10g: Add host interface speed
 configuration
Message-ID: <20221019125500.271e4ba3@dellmb>
In-Reply-To: <20221019124839.33ad3458@dellmb>
References: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
        <20221019085052.933385-3-yoshihiro.shimoda.uh@renesas.com>
        <20221019124839.33ad3458@dellmb>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 12:48:39 +0200
Marek Beh=C3=BAn <kabel@kernel.org> wrote:

> On Wed, 19 Oct 2022 17:50:51 +0900
> Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> wrote:
>=20
> > Add support for selecting host speed mode. For now, only support
> > 1000M bps.
> >=20
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  drivers/net/phy/marvell10g.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> >=20
> > diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> > index 383a9c9f36e5..daf3242c6078 100644
> > --- a/drivers/net/phy/marvell10g.c
> > +++ b/drivers/net/phy/marvell10g.c
> > @@ -101,6 +101,10 @@ enum {
> >  	MV_AN_21X0_SERDES_CTRL2_AUTO_INIT_DIS	=3D BIT(13),
> >  	MV_AN_21X0_SERDES_CTRL2_RUN_INIT	=3D BIT(15),
> > =20
> > +	MV_MOD_CONF		=3D 0xf000,
> > +	MV_MOD_CONF_SPEED_MASK	=3D 0x00c0,
> > +	MV_MOD_CONF_SPEED_1000	=3D BIT(7),
> > + =20
>=20
> Where did you get these values from? My documentation says:
>   Mode Configuration
>   Device 31, Register 0xF000
>   Bits
>   7:6   Reserved  R/W  0x3  This must always be 11.

Ah, I see. Probably from the MTD API sources...
But the bits should be set to 0x3 after HW reset, which means 10 Gbps,
and this should not interfere with 1000 Mbps SGMII operation. Do you
really need to set this? Isn't setting the MACTYPE to SGMII sufficient?

Marek
