Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429E05C03D8
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 18:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiIUQPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 12:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbiIUQO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 12:14:58 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958709E8AA;
        Wed, 21 Sep 2022 09:00:24 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 306581BF205;
        Wed, 21 Sep 2022 15:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1663775988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0n7aSrdrYSw+UI5ucpzj/zIatD/eWGzeiptQTDM8d0U=;
        b=jGKZzSIXrWe5Vtdb0w9b4vZfzkgjnVuoZ6cCybhJQgyMvCd0kiAQ7nZJVAj0EqdE21SxeM
        OHOBtt0W05XrHGFjMt+/r75/BcYxbNS9gojvV4Iq2i0yqndCp52m3LJkPyJOoIPIo4aYxe
        0S+uKhpS10BUUrv0aVpxQs6NNaBwk728qH/hevtdchPKRg9aJTJU2u8ZjNMzrWXiF48WQY
        A2GqbPKZeQGyrNhH2d60/R+edti8qaPDVjxG4GbHKq+56AaHHj3FfX/lRJ7neSHDFYnrT/
        c1rmgCGvSjZtAzom1qEGpbhm5ELe+DfFcqgghUYoTNsbKYHfKTUr03yqDKh5jg==
Date:   Wed, 21 Sep 2022 17:59:43 +0200
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan/next v3 8/9] net: mac802154: Ensure proper general
 purpose frame filtering
Message-ID: <20220921175943.1f871b31@xps-13>
In-Reply-To: <CAK-6q+jB0HQsU_wzr2T-qdGj=YSdf08DTZ0WTmRvDQt0Px7+Rg@mail.gmail.com>
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
        <20220905203412.1322947-9-miquel.raynal@bootlin.com>
        <CAK-6q+jB0HQsU_wzr2T-qdGj=YSdf08DTZ0WTmRvDQt0Px7+Rg@mail.gmail.com>
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

aahringo@redhat.com wrote on Thu, 8 Sep 2022 21:00:37 -0400:

> Hi,
>=20
> On Mon, Sep 5, 2022 at 4:35 PM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
> >
> > Most of the PHYs seem to cope with the standard filtering rules by
> > default. Some of them might not, like hwsim which is only software, and=
 =20
>=20
> yes, as I said before hwsim should pretend to be like all other
> hardware we have.
>=20
> > in this case advertises its real filtering level with the new
> > "filtering" internal value.
> >
> > The core then needs to check what is expected by looking at the PHY
> > requested filtering level and possibly apply additional filtering
> > rules.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/net/ieee802154_netdev.h |  8 ++++
> >  net/mac802154/rx.c              | 78 +++++++++++++++++++++++++++++++++
> >  2 files changed, 86 insertions(+)
> >
> > diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_n=
etdev.h
> > index d0d188c3294b..1b82bbafe8c7 100644
> > --- a/include/net/ieee802154_netdev.h
> > +++ b/include/net/ieee802154_netdev.h
> > @@ -69,6 +69,14 @@ struct ieee802154_hdr_fc {
> >  #endif
> >  };
> >
> > +enum ieee802154_frame_version {
> > +       IEEE802154_2003_STD,
> > +       IEEE802154_2006_STD,
> > +       IEEE802154_STD,
> > +       IEEE802154_RESERVED_STD,
> > +       IEEE802154_MULTIPURPOSE_STD =3D IEEE802154_2003_STD,
> > +};
> > +
> >  struct ieee802154_hdr {
> >         struct ieee802154_hdr_fc fc;
> >         u8 seq;
> > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > index c43289c0fdd7..bc46e4a7669d 100644
> > --- a/net/mac802154/rx.c
> > +++ b/net/mac802154/rx.c
> > @@ -52,6 +52,84 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data=
 *sdata,
> >                                 mac_cb(skb)->type);
> >                         goto fail;
> >                 }
> > +       } else if (sdata->required_filtering =3D=3D IEEE802154_FILTERIN=
G_4_FRAME_FIELDS && =20
>=20
> We switch here from determine that receive path, means way we are
> going from interface type to the required filtering value. Sure there
> is currently a 1:1 mapping for them now but I don't know why we are
> doing that and this is in my opinion wrong. The receive path should
> depend on interface type as it was before and for scanning there is
> some early check like:

Maybe on this one I am not fully convinced yet.

In your opinion (I try to rephrase so that we align on what you told
me) the total lack of filtering is only something that is reserved to
monitor interfaces, so you make an implicit link between interface type
and filtering level.

I would argue that this is true today, but as the "no filtering at all"
level is defined in the spec, I assumed it was a possible level that
one would want to achieve some day (not sure for what purpose yet). So
I assumed it would be more relevant to only work with the
expected filtering level in the receive path rather than on the
interface type, it makes more sense IMHO. In practice I agree it should
be the same filtering-wise, but from a conceptual point of view I find
the current logic partially satisfying.

Would you agree with me only using "expected filtering levels" rather
than:
- sometimes the interface type
- sometimes the mac state (scan)
- otherwise, by default, the highest filtering level
?

I think it would clarify the receive path.

I will of course get rid of most of all the other "nasty"
software filtering additions you nacked in the other threads.

> if (wpan_phy_is_in_scan_mode_state(local)) {
>      do_receive_scanning(...)
>      /* don't do any other delivery because they provide it to upper laye=
r */
>      return;
> }
>=20
> Maybe you should do monitors receive that frame before as well, but
> every other interface type should currently not receive it.
>=20
> - Alex
>=20


Thanks,
Miqu=C3=A8l
