Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569296DF7AB
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjDLNuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbjDLNuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:50:05 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A5E4683
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:50:02 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6E3FAC0004;
        Wed, 12 Apr 2023 13:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1681307400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PpMTl67Oqlz8sv1edilMhBRtkGaGi7sFy2cz3kUBvYk=;
        b=d7RB558OzgPfHPQFTbdOODkYTnXhQgug6KseRuSaFrc9/ELwOdkwbVYhBzLC1wD/hbj6kW
        v+4q/FpK1XmVsi1SxLSABjGmPbfDI8jbLX3T99Sq9elInvR2iDOZUH1AyKxHDGin/ua8xh
        ar2k0nUeViu247BGkFYVqRCvZeDebjt+FjP5/lKzrEWP+eGm2WLbwdw2fDrd+/ucI9lOA0
        9aqiM23A98ah/nNLLWaBsxDv0+YocBEJB8qNS9MOty0h3LIq8PeFpNrX4TjEePiQ3i/7Sp
        lyzfr8wWsJyjyjgcL2aM0CwPIfCjy4b4ca+FdhWMgJ5qaY1i96X54qvMFiWXjQ==
Date:   Wed, 12 Apr 2023 15:49:58 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 1/5] net: ethtool: Refactor identical
 get_ts_info implementations.
Message-ID: <20230412154958.287be686@kmaincent-XPS-13-7390>
In-Reply-To: <20230412131636.qh2mwyoaujrgagp5@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
        <20230406173308.401924-1-kory.maincent@bootlin.com>
        <20230406173308.401924-2-kory.maincent@bootlin.com>
        <20230406173308.401924-2-kory.maincent@bootlin.com>
        <20230412131636.qh2mwyoaujrgagp5@skbuf>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 16:16:36 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Thu, Apr 06, 2023 at 07:33:04PM +0200, K=C3=B6ry Maincent wrote:
> > From: Richard Cochran <richardcochran@gmail.com>
> >=20
> > The vlan, macvlan and the bonding drivers call their "real" device driv=
er
> > in order to report the time stamping capabilities.  Provide a core
> > ethtool helper function to avoid copy/paste in the stack.
> >=20
> > Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> > Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
> > ---
> >  static netdev_features_t macvlan_fix_features(struct net_device *dev,
> > diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> > index 798d35890118..a21302032dfa 100644
> > --- a/include/linux/ethtool.h
> > +++ b/include/linux/ethtool.h
> > @@ -1042,6 +1042,14 @@ static inline int
> > ethtool_mm_frag_size_min_to_add(u32 val_min, u32 *val_add, return -EINV=
AL;
> >  }
> > =20
> > +/**
> > + * ethtool_get_ts_info_by_layer - Obtains time stamping capabilities f=
rom
> > the MAC or PHY layer.
> > + * @dev: pointer to net_device structure
> > + * @info: buffer to hold the result
> > + * Returns zero on sauces, non-zero otherwise. =20
>=20
> Not sure if I'm missing some joke with the sauces here.

mmh don't know. Richards it comes from your code, any joke here?
I think it is merely a brain fart. I will fix it.
