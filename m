Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD4969DF50
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 12:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbjBULxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 06:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234264AbjBULxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 06:53:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817DD6A63
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 03:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676980372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HisyEn+uHZRLEH2cb3kCN8KYLXL8X8x9UvfG+UNAQSU=;
        b=Z43+QQo/cSfjWZH/tca1dssmhr4JHEFm0aC1ozxm69GUW2fj5qw4blXk6/xNLekwHL37HA
        1QMq1KXrOCnBex8fP0pBi/IzFzyaphdJovup86Is1vSgD05uWzHuQiEjpK6Iq16rTTR7q/
        lensq7Ye7CV6Wlhxmlot8Nd9LYPghqM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-224-xElViuavOZ-BnjMx15_pSg-1; Tue, 21 Feb 2023 06:52:51 -0500
X-MC-Unique: xElViuavOZ-BnjMx15_pSg-1
Received: by mail-wr1-f70.google.com with SMTP id r3-20020a5d6c63000000b002bff57fc7fcso900914wrz.19
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 03:52:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HisyEn+uHZRLEH2cb3kCN8KYLXL8X8x9UvfG+UNAQSU=;
        b=N1n1qUAE1fULEZzVSbjlw8G4jvJP9ElNZAtasBZVgAfRkkmYdYPaoLCgEC3d1iXuAl
         vAY+eKmyQsRmE9BNzJIefnix+pkw8Yv5mY/qSLudkJtIfsl19w2oyzNFNsuWBI5FzIA8
         sNikDBLJe+UFn8DdKUANauOMY+aD/CHhepAbdoNQg90fxhJk1kkl2ItepcclyzTKFSUu
         72TkoIKk6tQFicmZz8u5X5hDEQqwSjM3e+2U9PUL2w3JCQvr3V43kItGM7GxRre/hFXX
         YsoxX1Egv2OtAPzFras/NAKfLSbFgipWxyGq0flbpneXgTfW7gCNmirRe9P7RlRNz3Ky
         DAZA==
X-Gm-Message-State: AO0yUKVUonUVy8Q4y+1pit96mM3Ydqd4v7SY9D/FZU0SaOviEskZvCrN
        a1eCcsPs+D25uvBbLVIkVaJ7RMf2HmO3bQvn6u7UHBLcKo1JlEUc2CjNSF44UckRTPGU+FDUX0a
        hp7WVtBo04hm7Fj4L
X-Received: by 2002:a05:600c:1d1a:b0:3e0:b1:c12d with SMTP id l26-20020a05600c1d1a00b003e000b1c12dmr4199840wms.1.1676980370477;
        Tue, 21 Feb 2023 03:52:50 -0800 (PST)
X-Google-Smtp-Source: AK7set/kHEnod1nC5mbdGLi9tfyjUtOtTKUhaE63C94xvm2P0Q8iukNIssyB4a12qfJXK9OvlL+V7A==
X-Received: by 2002:a05:600c:1d1a:b0:3e0:b1:c12d with SMTP id l26-20020a05600c1d1a00b003e000b1c12dmr4199825wms.1.1676980370204;
        Tue, 21 Feb 2023 03:52:50 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id x8-20020a1c7c08000000b003dc4480df80sm3473215wmc.34.2023.02.21.03.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 03:52:49 -0800 (PST)
Message-ID: <0c1eaa274b2ef6d63f9f0897024974309a375b4b.camel@redhat.com>
Subject: Re: [PATCH net-next v2 0/4] net: phy: EEE fixes
From:   Paolo Abeni <pabeni@redhat.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Date:   Tue, 21 Feb 2023 12:52:48 +0100
In-Reply-To: <feb4388052a3f55a869704f204faa7ad39aeff1d.camel@redhat.com>
References: <20230221050334.578012-1-o.rempel@pengutronix.de>
         <feb4388052a3f55a869704f204faa7ad39aeff1d.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-21 at 12:45 +0100, Paolo Abeni wrote:
> On Tue, 2023-02-21 at 06:03 +0100, Oleksij Rempel wrote:
> > changes v2:
> > - restore previous ethtool set logic for the case where advertisements
> >   are not provided by user space.
> > - use ethtool_convert_legacy_u32_to_link_mode() where possible
> > - genphy_c45_an_config_eee_aneg(): move adv initialization in to the if
> >   scope.
> >=20
> > Different EEE related fixes.
> >=20
> > Oleksij Rempel (4):
> >   net: phy: c45: use "supported_eee" instead of supported for access
> >     validation
> >   net: phy: c45: add genphy_c45_an_config_eee_aneg() function
> >   net: phy: do not force EEE support
> >   net: phy: c45: genphy_c45_ethtool_set_eee: validate EEE link modes
> >=20
> >  drivers/net/phy/phy-c45.c    | 55 ++++++++++++++++++++++++++++--------
> >  drivers/net/phy/phy_device.c | 21 +++++++++++++-
> >  include/linux/phy.h          |  6 ++++
> >  3 files changed, 69 insertions(+), 13 deletions(-)
> >=20
> # Form letter - net-next is closed
>=20
> The merge window for v6.3 has begun and therefore net-next is closed
> for new drivers, features, code refactoring and optimizations.
> We are currently accepting bug fixes only.
>=20
> Please repost when net-next reopens after Mar 6th.
>=20
> RFC patches sent for review only are obviously welcome at any time.

It looks like I was a little too hasty here; these are fixes for code
currently only on net-next. As such you can re-post (for -net) after
that Linus's net-next pull and subsequent merge into -net.

Thanks,

Paolo

