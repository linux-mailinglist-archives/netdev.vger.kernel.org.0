Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E926F5FF946
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 10:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiJOI6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 04:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJOI6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 04:58:45 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DD25508B;
        Sat, 15 Oct 2022 01:58:43 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 169E11C0003;
        Sat, 15 Oct 2022 08:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1665824322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AXDMrFO8MHVJA4noZ87cqY8A1a/RnA+ssbM13kAd02A=;
        b=KvafdZekCAV1lm6UTLOsNjfGO7LylbD8jnBJoGY+EiLmwNMv0YAJRe7MtPyjXfQNyWnOjp
        C98FOO8IlhoeEhXqSQ/VgQufW9YsqpqWllqUT0yM0dunloUL0UBD14RUEXikai345RCwie
        D1OAHEs3DmPxx8qPh6fd1iOR2sizXDwK8XH09mseIftZ+Hv34WDQ4y/oZ3eovzZkqpXL+h
        nRco8fk7ZaCYmZa/o8TJLzv+yLXE5kji+AKGuM9rC9yeS5zAknH3YMRtwqYQM3VejAg6FR
        9yN1pugJwfED/kkR6/NVUBD8Y98kRVGrQDkknVoOJE8eRWQObmCTI8PnP07cag==
Date:   Sat, 15 Oct 2022 10:58:38 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan/next v4 8/8] mac802154: Ensure proper scan-level
 filtering
Message-ID: <20221012153507.045c3843@xps-13>
In-Reply-To: <e0e2a450-e70a-fffb-9c9d-6108347e2eaa@datenfreihafen.org>
References: <20221007085310.503366-1-miquel.raynal@bootlin.com>
 <20221007085310.503366-9-miquel.raynal@bootlin.com>
 <e0e2a450-e70a-fffb-9c9d-6108347e2eaa@datenfreihafen.org>
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

stefan@datenfreihafen.org wrote on Wed, 12 Oct 2022 12:50:34 +0200:

> Hello Miquel.
>=20
> On 07.10.22 10:53, Miquel Raynal wrote:
> > We now have a fine grained filtering information so let's ensure proper
> > filtering in scan mode, which means that only beacons are processed.
> >=20
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >   net/mac802154/rx.c | 16 ++++++++++++----
> >   1 file changed, 12 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > index 14bc646b9ab7..4d799b477a7f 100644
> > --- a/net/mac802154/rx.c
> > +++ b/net/mac802154/rx.c
> > @@ -34,6 +34,7 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data =
*sdata,
> >   		       struct sk_buff *skb, const struct ieee802154_hdr *hdr)
> >   {
> >   	struct wpan_dev *wpan_dev =3D &sdata->wpan_dev;
> > +	struct wpan_phy *wpan_phy =3D sdata->local->hw.phy;
> >   	__le16 span, sshort;
> >   	int rc; =20
> >   > @@ -42,6 +43,17 @@ ieee802154_subif_frame(struct ieee802154_sub_if_=
data *sdata, =20
> >   	span =3D wpan_dev->pan_id;
> >   	sshort =3D wpan_dev->short_addr; =20
> >   > +	/* Level 3 filtering: Only beacons are accepted during scans */ =
=20
> > +	if (sdata->required_filtering =3D=3D IEEE802154_FILTERING_3_SCAN &&
> > +	    sdata->required_filtering > wpan_phy->filtering) {
> > +		if (mac_cb(skb)->type !=3D IEEE802154_FC_TYPE_BEACON) {
> > +			dev_dbg(&sdata->dev->dev,
> > +				"drop !beacon frame (0x%x) during scan\n", =20
>=20
> This ! before the beacon looks like a typo. Please fix.

Actually it's not, I meant "this is a non-beacon frame", but I might
have been too lazy to write it in plain english. But you're right, it
looks like a typo, so I'll rephrase this string.

>=20
> > +				mac_cb(skb)->type);
> > +			goto fail;
> > +		}
> > +	}
> > +
> >   	switch (mac_cb(skb)->dest.mode) {
> >   	case IEEE802154_ADDR_NONE:
> >   		if (hdr->source.mode !=3D IEEE802154_ADDR_NONE)
> > @@ -277,10 +289,6 @@ void ieee802154_rx(struct ieee802154_local *local,=
 struct sk_buff *skb) =20
> >   >   	ieee802154_monitors_rx(local, skb);
> >   > -	/* TODO: Handle upcomming receive path where the PHY is at the =20
> > -	 * IEEE802154_FILTERING_NONE level during a scan.
> > -	 */
> > -
> >   	/* Level 1 filtering: Check the FCS by software when relevant */
> >   	if (local->hw.phy->filtering =3D=3D IEEE802154_FILTERING_NONE) {
> >   		crc =3D crc_ccitt(0, skb->data, skb->len); =20
>=20
> When trying to apply the patch it did not work:
>=20
> Failed to apply patch:
> error: patch failed: net/mac802154/rx.c:42
> error: net/mac802154/rx.c: patch does not apply
> hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
> Applying: mac802154: Ensure proper scan-level filtering
> Patch failed at 0001 mac802154: Ensure proper scan-level filtering
>=20
> On top of what tree or branch is this? Maybe you based it on some not app=
lied patches? Please rebase against wpan-next and re-submit. The rest of th=
e patches got applied.

This series was based on top of wpan/next, but I assumed it would have
been applied on top of this fix that was picked up a month ago:
https://lkml.kernel.org/stable/57b7d918-1da1-f490-4882-5ed25ea17503@datenfr=
eihafen.org/
I will update the above dev_dbg string, but I suggest we wait for
6.1-rc1 to be out before applying it? Otherwise if I "fix" it for
immediate appliance on the current wpan-next branch, it will likely
conflict with linux-next.
=20
>=20
> Thanks for the ongoing work on this.

You're welcome, thank you both for the reviews and time spent on your
side as well!

Thanks,
Miqu=C3=A8l
