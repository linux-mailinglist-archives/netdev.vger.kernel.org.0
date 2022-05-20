Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E5252E734
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 10:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346937AbiETIXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 04:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346932AbiETIXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 04:23:05 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E1F14041B;
        Fri, 20 May 2022 01:23:03 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BB65B60003;
        Fri, 20 May 2022 08:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1653034981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JlS5+Zx7bLL9B/sG6JFr0mdsjKOX7o7My0JbDoCnCW4=;
        b=JR/J206Bb0WHaSd1ufr21uQ7Kvqhz5NK4wj362Aro/gHNsM1fE0vI/9fv0qR6agAde89Jh
        3rnp4LHlhs3Thd3giYMy719Fqrc53Q9hzfUh7Z9OcVdJ1gj+e1KwrKsWcheOAB3e5fwHQt
        F/Zqg2WAsrU8bh5/RGdWZpi174yqUfQIzzcq+qHPcGXY9Sn07CRZy4H1wBc/4CPx9m9HdB
        h+YKP3BkREBvZJktCrGref0FxWtjdNQrr7mnfsFxD72NAKPrh7fstYK1JmVXasgO84ZPsW
        iDYYZXYXceeBYxRr+ODjKiflCRr3gBVSxS6tl30cqgne0cjpUxWoz5MoI7R5UQ==
Date:   Fri, 20 May 2022 10:21:51 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: ocelot: fix wront time_after usage
Message-ID: <20220520102151.411c8e35@fixe.home>
In-Reply-To: <20220519231300.k6hizfdu5chi7lpu@skbuf>
References: <20220519204017.15586-1-paskripkin@gmail.com>
        <20220519231300.k6hizfdu5chi7lpu@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 19 May 2022 23:13:01 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a =C3=A9crit :

> On Thu, May 19, 2022 at 11:40:17PM +0300, Pavel Skripkin wrote:
> > Accidentally noticed, that this driver is the only user of
> > while (timer_after(jiffies...)).
> >=20
> > It looks like typo, because likely this while loop will finish after 1st
> > iteration, because time_after() returns true when 1st argument _is afte=
r_
> > 2nd one.
> >=20
> > Fix it by negating time_after return value inside while loops statement
> >=20
> > Fixes: 753a026cfec1 ("net: ocelot: add FDMA support")
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> > ---
> >  drivers/net/ethernet/mscc/ocelot_fdma.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethe=
rnet/mscc/ocelot_fdma.c
> > index dffa597bffe6..4500fed3ce5c 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_fdma.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_fdma.c
> > @@ -104,7 +104,7 @@ static int ocelot_fdma_wait_chan_safe(struct ocelot=
 *ocelot, int chan)
> >  		safe =3D ocelot_fdma_readl(ocelot, MSCC_FDMA_CH_SAFE);
> >  		if (safe & BIT(chan))
> >  			return 0;
> > -	} while (time_after(jiffies, timeout));
> > +	} while (!time_after(jiffies, timeout));
> > =20
> >  	return -ETIMEDOUT;
> >  }
> > --=20
> > 2.36.1
> > =20
>=20
> +Clement. Also, there seems to be a typo in the commit message (wront -> =
wrong),
> but maybe this isn't so important.

Hi Pavel,

Thanks for this fix which is indeed necessary.

Acked-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>


--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
