Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA67603B43
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 10:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiJSIRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 04:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiJSIRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 04:17:30 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFD96C138;
        Wed, 19 Oct 2022 01:17:28 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CC315E0007;
        Wed, 19 Oct 2022 08:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666167447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UU32+FEUcNeioQVGgmPsTUGSpSghEKkfJjXJukxwQLY=;
        b=m7IA5PJ4IYHBkTamrO3HaBtEPqsWflXeAtpwzkccfNeOvHfhYES0RsD7z46xlE0Rk78dVQ
        OfHokeZbwkeKMOcg5YJs5d2BNOzuFUsajf5m1YFpa2cdlddcg39/5RIxprXZg+f+cllXOc
        4dGqnW8k1z9W7wgtHZ0dulYZyU+OZNar50z5j1LsGwyY8oVe7JLozGlAIso5zNL28h9yGf
        7Bi6Q3zqMnkE+yLPYzI+q5vVIcMY48VDtXp9gVzixWZSTGCBJKgkudF9uK83FdDA5al8Pu
        N14M0uJNsyTYQCX/Hh3CupWfLg7ZTvZ7AKXX2eh1Z02G4xO/tzN9vqPhu9KirA==
Date:   Wed, 19 Oct 2022 10:17:25 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <aahringo@redhat.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v5] mac802154: Ensure proper scan-level
 filtering
Message-ID: <20221019101725.650cb04f@xps-13>
In-Reply-To: <154ea7ad-333e-cecd-517b-0a9cf9d1b390@datenfreihafen.org>
References: <20221018183540.806471-1-miquel.raynal@bootlin.com>
        <CAK-6q+gRMG64Ra9ghAUVHXkJoGB1b5Kd6rLTiUK+UArbYhP+BA@mail.gmail.com>
        <20221019000329.2eacd502@xps-13>
        <154ea7ad-333e-cecd-517b-0a9cf9d1b390@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

stefan@datenfreihafen.org wrote on Wed, 19 Oct 2022 10:06:05 +0200:

> Hello.
>=20
> On 19.10.22 00:03, Miquel Raynal wrote:
> > Hi Alexander,
> >=20
> > aahringo@redhat.com wrote on Tue, 18 Oct 2022 16:54:13 -0400:
> >  =20
> >> Hi,
> >>
> >> On Tue, Oct 18, 2022 at 2:35 PM Miquel Raynal <miquel.raynal@bootlin.c=
om> wrote: =20
> >>>
> >>> We now have a fine grained filtering information so let's ensure prop=
er
> >>> filtering in scan mode, which means that only beacons are processed. =
=20
> >>>   >> =20
> >> Is this a fixup? Can you resend the whole series please? =20
> >=20
> > Hmm no? Unless I understood things the wrong way, Stefan applied
> > patches 1 to 7 of my v4, and asked me to make a change on the 8th
> > patch.
> >=20
> > This is v5 just for patch 8/8 of the previous series, I just changed
> > a debug string actually...
> >=20
> > There was a conflict when he applied it but I believe this is because
> > wpan-next did not contain one of the fixes which made it to Linus' tree
> > a month ago. So in my branch I still have this fix prior to this patch,
> > because otherwise there will be a conflict when merging v6.1-rc1 (which
> > I believe was not done yet). =20
>=20
> You believe correctly. :-) In my workflow I normally do not merge in chan=
ges from net-next until after my latest pull-request was pulled in. I do th=
is to avoid extra merge commits.
>=20
> In case I see a merge conflict in my testing before sending the pull requ=
est I add merge guidance to the pull. Which is my plan this time around as =
well.

Do you mean I should drop the fix from my branch and give you a patch
which applies on the current wpan-next instead?

Thanks,
Miqu=C3=A8l
