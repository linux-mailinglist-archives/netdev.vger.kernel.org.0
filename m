Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FEF6B3B47
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 10:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjCJJsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 04:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjCJJsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 04:48:32 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CC565446;
        Fri, 10 Mar 2023 01:47:58 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id D5BA385A2E;
        Fri, 10 Mar 2023 10:47:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678441676;
        bh=AtAyJXZxxLAkbb+4sWsugabeLxh6plYeWu7LMmy0eP8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K8hAI/cK3xa5dry/OinyifD99bGQUclOZ9TVe4vVTBsFt1T5JH7EsLujp+wZw3Qc3
         zOkkysg+yqY8m5LAXUfGpdebX3/d5z+LidTnNuJgvxfm9oMP1OeRYCo5riMbg8VyiW
         wBnz9Z4hxJkVeu9/zUgevGTLlNd/vKtx6fXCWzYUcNi0GaqaiU8dflxVMcCIrnL8EI
         1SLrkgXfBhcAuAlgDuVoeV/GQglf/dvW3m9nKwu4k3Her3GU4jw1jg4Ejk/uohfRmW
         Cekh4i0WWWKyzF+eJd1fPHPdiPb84WSUP3BalEj64CZE7M8QhJ9b6bar/e+yhk1U+v
         o5bE7rT7XtfjQ==
Date:   Fri, 10 Mar 2023 10:47:55 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] dsa: marvell: Correct value of max_frame_size
 variable after validation
Message-ID: <20230310104755.79b24384@wsk>
In-Reply-To: <ZAn7vkjj0bYdZnhz@shell.armlinux.org.uk>
References: <20230309125421.3900962-1-lukma@denx.de>
        <20230309125421.3900962-7-lukma@denx.de>
        <ZAnnk5MZc0w4VkDE@shell.armlinux.org.uk>
        <20230309154350.0bdc54c8@wsk>
        <ZAn7vkjj0bYdZnhz@shell.armlinux.org.uk>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ZHcuUdRLWXX3ZTVqfJr0udO";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ZHcuUdRLWXX3ZTVqfJr0udO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Russell,

> On Thu, Mar 09, 2023 at 03:43:50PM +0100, Lukasz Majewski wrote:
> > Hi Russell,
> >=20
> > Please correct my understanding - I do see two approaches here:
> >=20
> > A. In patch 1 I do set the max_frame_size values (deduced). Then I
> > add validation function (patch 2). This function shows "BUG:...."
> > only when we do have a mismatch. In patch 3 I do correct the
> > max_frame_size values (according to validation function) and remove
> > the validation function. This is how it is done in v5 and is going
> > to be done in v6. =20
>=20
> I don't see much point in adding the validation, then correcting the
> values that were added in patch 1 that were identified by patch 2 in
> patch 3 - because that means patch 1's deduction was incorrect in
> some way.

Yes. I do agree.

>=20
> If there is any correction to be done, then it should be:
>=20
> patch 1 - add the max_frame_size values
> patch 2 - add validation (which should not produce any errors)
> patch 3 - convert to use max_frame_size, and remove validation,
> stating that the validation had no errors
> patch 4 (if necessary) - corrections to max_frame_size values if they
>   are actually incorrect (in other words, they were buggy before patch
>   1.)
> patch 5 onwards - the rest of the series.
>=20

Ok. I will restructure patches to follow above scheme.

> > B. Having showed the v5 in public, the validation function is known.
> > Then I do prepare v6 with only patch 1 having correct values (from
> > the outset) and provide in the commit message the code for
> > validation function. Then patch 2 and 3 (validation function and
> > the corrected values of max_frame_size) can be omitted in v6.
> >=20
> > For me it would be better to choose approach B. =20
>=20
> I would suggest that is acceptable for the final round of patches, but
> I'm wary about saying "yes" to it because... what if something changes
> in that table between the time you've validated it, and when it
> eventually gets accepted.

The "peace" of changes for this code is rather slow, so the risk is
minimal.

Moreover, next ICs added would _require_ to have the max_frame_size
field set (the WARN_ON() clause).

> Keeping the validation code means that
> during the review of the series, and subsequent updates onto net-next
> (which should of course include re-running the validation code) we
> can be more certain that nothing has changed that would impact it.
>=20
> What I worry about is if something changes, the patch adding the
> values mis-patches (e.g. due to other changes - much of the context
> for each hunk is quite similar) then we will have quite a problem to
> sort it out.
>=20

Ok. I hope that we will avoid this threat.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/ZHcuUdRLWXX3ZTVqfJr0udO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmQK/MsACgkQAR8vZIA0
zr3NxwgAs7xRh+00Knb97P5Wd9XHBQTDtazIpZGz1ajSPwu0nsB96aA34yZfFg+R
fl81Jk9gflwdtGyUJNuH8nGX99jBXC5PfmGourdifsxg+3tBiNGdnpLA7qZZJahi
ydoEv60QUMVdXaMjno/xwRwsTeujt6s43FQ2rlngS+cp76whk0Um6IQZEbAUBuKy
Pfe3JTC/1YQIufghnbDy/uN509cJWfnIZJ/trFytk0byVIT+yQq2sNzQN/HnnD8j
8SLYElVIo5fgMo9/QyO4/YAsT+lqtyqSKWqolJZ8HQLEryFn7aUgTgVj1gZebB68
amJlUSuk8psGIqGr2Gq/rddCLWUSlQ==
=lABy
-----END PGP SIGNATURE-----

--Sig_/ZHcuUdRLWXX3ZTVqfJr0udO--
