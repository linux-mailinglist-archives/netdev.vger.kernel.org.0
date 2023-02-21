Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BE369DF38
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 12:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbjBULrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 06:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbjBULrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 06:47:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37A64484
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 03:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676979940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xdkixFVFU82nxRe/Neoo7hq2DbG+6O5CGX+XkYGCaSA=;
        b=Hj3ciMkK30o0nyFEmvcPZvTdeypNGNntmfyfki6giDR6JRNfq9gIqE4S1lwQiKO05Yj6qN
        10yMsjA7vEVP7joW7Qe+xOZZ8yGKBOxPpoPH1bo0wu6ZAcVod/TYx9jb6/luPtbSDiPE+p
        wJAea3Y7zxueJ3ybVdCbmRE79KEgdB0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-58-4NlWov3cPdKXpp73NhNeGA-1; Tue, 21 Feb 2023 06:45:39 -0500
X-MC-Unique: 4NlWov3cPdKXpp73NhNeGA-1
Received: by mail-wm1-f70.google.com with SMTP id n3-20020a05600c3b8300b003dc5dec2ac6so1947018wms.4
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 03:45:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676979938;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xdkixFVFU82nxRe/Neoo7hq2DbG+6O5CGX+XkYGCaSA=;
        b=PM+N4LyoKmSQ5jXjnQSQmLFOm+DaJVzBtKEa9PWPfXV+tvGW4G1AlybmgKjyMgwS6D
         V7HoP/9vj9ODkyVF05iMIRC4DpLMlah2t2NVqthclipAaYxQQ4H34vs1S8ZsuaQR7Zng
         L7V25u0v8mz5PR9A4dmBp6rg8OZYdQ//hsIdLg3VIOnyTuRSeyoKqh7YcMLl42ZaTGnV
         rV5D2oeX0PTXnZOt8jXg1yeFc75bkHM7Z4Tx7+T5+98bi3ivEsDZ5tTfFi/aUy++Ivxq
         BPRbLbNSp0+kLIOaEBIJN/xcNghO6z+nzuP8RSgVcyumnXXz8g2ieigdG7Z2uQJLslvh
         mDqQ==
X-Gm-Message-State: AO0yUKWhRtwGfBExTa8vF1XJ9UjteObhMM/vEof82H1oaFx6gKm9RIx5
        Pl5hFyF+Dujg0JCxOrAd8ya9rebiTpHuxcxnvt8MEzWStZYXgrn0jJB+VeSMpmmf1FiAsg0ZOMy
        ccDUXd8SyNtchF2Jn
X-Received: by 2002:a5d:58c6:0:b0:2c5:4da3:4e10 with SMTP id o6-20020a5d58c6000000b002c54da34e10mr3083592wrf.4.1676979937981;
        Tue, 21 Feb 2023 03:45:37 -0800 (PST)
X-Google-Smtp-Source: AK7set9imgO7JIMPr+1oBS/NAm2w2BrZ9NYRoob1y00QMEggrPckyI+6L++7LS88bTdC32slUAg6rw==
X-Received: by 2002:a5d:58c6:0:b0:2c5:4da3:4e10 with SMTP id o6-20020a5d58c6000000b002c54da34e10mr3083578wrf.4.1676979937640;
        Tue, 21 Feb 2023 03:45:37 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id h11-20020adff18b000000b002c567b58e9asm6055855wro.56.2023.02.21.03.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 03:45:37 -0800 (PST)
Message-ID: <feb4388052a3f55a869704f204faa7ad39aeff1d.camel@redhat.com>
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
Date:   Tue, 21 Feb 2023 12:45:35 +0100
In-Reply-To: <20230221050334.578012-1-o.rempel@pengutronix.de>
References: <20230221050334.578012-1-o.rempel@pengutronix.de>
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

On Tue, 2023-02-21 at 06:03 +0100, Oleksij Rempel wrote:
> changes v2:
> - restore previous ethtool set logic for the case where advertisements
>   are not provided by user space.
> - use ethtool_convert_legacy_u32_to_link_mode() where possible
> - genphy_c45_an_config_eee_aneg(): move adv initialization in to the if
>   scope.
>=20
> Different EEE related fixes.
>=20
> Oleksij Rempel (4):
>   net: phy: c45: use "supported_eee" instead of supported for access
>     validation
>   net: phy: c45: add genphy_c45_an_config_eee_aneg() function
>   net: phy: do not force EEE support
>   net: phy: c45: genphy_c45_ethtool_set_eee: validate EEE link modes
>=20
>  drivers/net/phy/phy-c45.c    | 55 ++++++++++++++++++++++++++++--------
>  drivers/net/phy/phy_device.c | 21 +++++++++++++-
>  include/linux/phy.h          |  6 ++++
>  3 files changed, 69 insertions(+), 13 deletions(-)
>=20
# Form letter - net-next is closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after Mar 6th.

RFC patches sent for review only are obviously welcome at any time.

