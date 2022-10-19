Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B95603AB8
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 09:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiJSHep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 03:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiJSHek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 03:34:40 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C501572B;
        Wed, 19 Oct 2022 00:34:37 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D25451BF206;
        Wed, 19 Oct 2022 07:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666164876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Csp3+K4ux0rFc1Qr1GkVBtAESoa/EJQLPPU3RZVQM/A=;
        b=o/h5eYtnRObqGVd7gCkxO12KWUu4njTFzzpYQ4Yk3zV+Ml3FoTwfM58meT/YG6aiYDgOkI
        oBGJ1Jl87RJWqARNhNMjL3o8xnqlXy/b+8fH9cfvKyOa6QxC6x0f8n9fgOHmqnAv9R8w9h
        DKTjc2p3RVUEl2Uez1V2kTL3iqyf9cP+7LueepfV/s6hDox4bCkDdrPhppK/GNIO90jNVj
        0QRRInk11SeOzOziHCX3E3/rP5rACFob/fOCvfdcZ/8SB0NPEKviX+I58C282GuYPf7Gyt
        PwD/9MEcj6MxzhGOG7w/rUVS2LTii41ywHoFPrPuX8BdFp4AeY6AD9q5Ys7w6w==
Date:   Wed, 19 Oct 2022 09:34:33 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
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
Message-ID: <20221019093433.76f07627@xps-13>
In-Reply-To: <CAK-6q+hB2883Jb=X90-wSj9PAhaAMQtxhbc3y2nYsMW5pb4ZvA@mail.gmail.com>
References: <20221018183540.806471-1-miquel.raynal@bootlin.com>
        <CAK-6q+gRMG64Ra9ghAUVHXkJoGB1b5Kd6rLTiUK+UArbYhP+BA@mail.gmail.com>
        <20221019000329.2eacd502@xps-13>
        <CAK-6q+hB2883Jb=X90-wSj9PAhaAMQtxhbc3y2nYsMW5pb4ZvA@mail.gmail.com>
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

Hi Alexander,

aahringo@redhat.com wrote on Tue, 18 Oct 2022 18:56:49 -0400:

> Hi,
>=20
> On Tue, Oct 18, 2022 at 6:03 PM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Tue, 18 Oct 2022 16:54:13 -0400:
> > =20
> > > Hi,
> > >
> > > On Tue, Oct 18, 2022 at 2:35 PM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote: =20
> > > >
> > > > We now have a fine grained filtering information so let's ensure pr=
oper
> > > > filtering in scan mode, which means that only beacons are processed.
> > > > =20
> > >
> > > Is this a fixup? Can you resend the whole series please? =20
> >
> > Hmm no? Unless I understood things the wrong way, Stefan applied
> > patches 1 to 7 of my v4, and asked me to make a change on the 8th
> > patch.
> >
> > This is v5 just for patch 8/8 of the previous series, I just changed
> > a debug string actually...
> > =20
>=20
> Okay, I see there are multiple new patches on the list, can you resend
> them in one series? Then we have the right order how they need to be
> applied without figuring it "somehow" out.

The order should not matter much, that's why I posted them as individual
patches. But no problem, I'll resent the three "followup" patches in a
series.

However, the patch for allowing coordinator interfaces should be
considered something else, I've sent it to start discussing it as the
other patches should not require a lot of review time I guess. I didn't
think it made sense to wrap it in the followup series as this is
mainly something new, but I'm fine doing it, the first patches can go
in while we still discuss it further.

> > There was a conflict when he applied it but I believe this is because
> > wpan-next did not contain one of the fixes which made it to Linus' tree
> > a month ago. So in my branch I still have this fix prior to this patch,
> > because otherwise there will be a conflict when merging v6.1-rc1 (which
> > I believe was not done yet).
> > =20
>=20
> I see. Thanks.
>=20
> - Alex
>=20

Thanks,
Miqu=C3=A8l
