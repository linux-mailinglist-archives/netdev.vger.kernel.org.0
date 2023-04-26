Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E676EEFA6
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 09:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239779AbjDZHz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 03:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239742AbjDZHz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 03:55:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78724DC
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 00:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682495713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZJrA9tGy57oC8Z3S3Mae0l1uoJKXbZPecnkvwql3A/E=;
        b=LgQrInXUYljkLYWvkB6/VEV9JxzBZeh220G6oLDIz2FKqYsagO+Vi/howEnNM1FTaw8Fe6
        W7gjpi7vc6p/i5nQQ8ioX29a5jqBmUYDFbHIF9N8z0SZNxs2Hy44YHU3gaFu41LEkxAWZv
        vJJmqqL6RwP4KXiqlHLe28H4A2xgbgc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-GbzmjYSuNEWrcI8qrDKrOw-1; Wed, 26 Apr 2023 03:55:12 -0400
X-MC-Unique: GbzmjYSuNEWrcI8qrDKrOw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f173b5962dso9847855e9.1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 00:55:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682495711; x=1685087711;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZJrA9tGy57oC8Z3S3Mae0l1uoJKXbZPecnkvwql3A/E=;
        b=S8xKCqCv3fQdrwPdRm1NVy8ooNzPfgB5q7nHcsAJZIa1brOY7naWjy8r3GJEzBF81z
         e93qy/Cj/k8pw+VxaMJFP/e5Lw2M95QSuqaB/t+KTWzJmhp/ZrI6OuPGEa9W/GAJ591Q
         xNBJE01zrGiGQuFDUtJJyfmq9zTFq8stJd2lL3g1rpofNc3d9Sce5JjQMRc5wO47wwip
         pQDR0mQfWyk/KUosNmXHFOMncWWhaY+SR/5zeK4bCWmMMnBwPaA1fXqEM5qrqq3uOutm
         ShXNY+JXACxfm79aAv03jP2r+RMqAHcnKQBk6waC7ClUFJctkgg+WiD2QJGS5e4k8hYG
         MmHw==
X-Gm-Message-State: AAQBX9eEYZR8ngR8iczsk3/kw4B0y6qQzNIumLuAdZXGEjwtTSvT+1Np
        DaqXmRMG6hAuq8YEzX65m0vKYSEv1mxUSzbdDoganrWr0bsNy94+M3wTuvGwVpr4ctqW7zNecVz
        0g+LQ7TxvJ96BpsRE
X-Received: by 2002:a05:600c:458e:b0:3f1:7fd7:addc with SMTP id r14-20020a05600c458e00b003f17fd7addcmr15309412wmo.2.1682495710996;
        Wed, 26 Apr 2023 00:55:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350aq55IgM5HPpmj7GiblSyt5dkL8a2l4O4RAKIpPMoI+S/TYTbgm6KmHjS+5ORHva6qZ9UG9Yw==
X-Received: by 2002:a05:600c:458e:b0:3f1:7fd7:addc with SMTP id r14-20020a05600c458e00b003f17fd7addcmr15309402wmo.2.1682495710695;
        Wed, 26 Apr 2023 00:55:10 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-252-239.dyn.eolo.it. [146.241.252.239])
        by smtp.gmail.com with ESMTPSA id i6-20020a5d6306000000b002fed865c55esm15002198wru.56.2023.04.26.00.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 00:55:10 -0700 (PDT)
Message-ID: <b8a0beced66b0a9ae53e7270cd18ab20873f4131.camel@redhat.com>
Subject: Re: [PATCH net-next] net: phy: drop PHYLIB_LEDS knob
From:   Paolo Abeni <pabeni@redhat.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 26 Apr 2023 09:55:09 +0200
In-Reply-To: <ce81b985-ebcf-46f7-b773-50e42d2d10e7@lunn.ch>
References: <c783f6b8d8cc08100b13ce50a1330913dd95dbce.1682457539.git.pabeni@redhat.com>
         <ce81b985-ebcf-46f7-b773-50e42d2d10e7@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-04-25 at 23:38 +0200, Andrew Lunn wrote:
> On Tue, Apr 25, 2023 at 11:19:11PM +0200, Paolo Abeni wrote:
> > commit 4bb7aac70b5d ("net: phy: fix circular LEDS_CLASS dependencies")
> > solved a build failure, but introduces a new config knob with a default
> > 'y' value: PHYLIB_LEDS.
> >=20
> > The latter is against the current new config policy. The exception
> > was raised to allow the user to catch bad configurations without led
> > support.
> >=20
> > Anyway the current definition of PHYLIB_LEDS does not fit the above
> > goal: if LEDS_CLASS is disabled, the new config will be available
> > only with PHYLIB disabled, too.
> >=20
> > Instead of building a more complex and error-prone dependency definitio=
n
> > it looks simpler and more in line with the mentioned policies use
> > IS_REACHABLE(CONFIG_LEDS_CLASS) instead of the new symbol.
> >=20
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> > @Andrew, @Arnd: the rationale here is to avoid the new config knob=3Dy,
> > which caused in the past a few complains from Linus. In this case I
> > think the raised exception is not valid, for the reason mentioned above=
.
> >=20
> > If you have different preferences or better solutions to address that,
> > please voice them :)
>=20
> Arnd did mention making it an invisible option. That would have the
> advantage of keeping the hundreds of randcomfig builds which have been
> done. How much time do you have now to do that before sending Linus
> the pull request?

Very little, I would say.

> > ---
> >  drivers/net/phy/Kconfig      | 9 ---------
> >  drivers/net/phy/phy_device.c | 2 +-
> >  2 files changed, 1 insertion(+), 10 deletions(-)
> >=20
> > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > index 2f3ddc446cbb..f83420b86794 100644
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -44,15 +44,6 @@ config LED_TRIGGER_PHY
> >  		<Speed in megabits>Mbps OR <Speed in gigabits>Gbps OR link
> >  		for any speed known to the PHY.
> > =20
> > -config PHYLIB_LEDS
> > -	bool "Support probing LEDs from device tree"
>=20
> I don't know Kconfig to well, but i think you just need to remove the
> text, just keep the bool.
>=20
> -       bool "Support probing LEDs from device tree"
> +       bool
>=20
> 	Andrew

I read the following discussion as substantial agreement with the
above. I'll share and use a formal patch with that.

Thanks,

Paolo

