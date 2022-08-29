Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F3F5A459E
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiH2JCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiH2JCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:02:07 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426AA4F6A4;
        Mon, 29 Aug 2022 02:02:04 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 63D911C0007;
        Mon, 29 Aug 2022 09:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661763723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=egYd/ufcwWXL/14w2TKnj865Ji/UAFfHPONA/idMp5s=;
        b=J6kXojoty82hma6C/BsEZ05qr9o0SLW+bFmClo+tmyvWVFoeCxyawd+2jzunZbjyqeIP6w
        PLmSL3iOE8ZKjQhLkvTWYf1cC2IVO+weanKRfiU1QudJOqPz8gZKknTAXmtrSJBp1gU4ye
        ZQyUhsGR2xZUhyeonmfM54sUN0caEPtYlnsKe5RK2O8UpX3Tx+cZcXknpLSLmCeFnwqjUz
        fUM3QnycbcTEJhZtN3gdWG9XXlk3HHRYpW706RLscwe5n1Ua9oB4kM5rUImBfzXu46B29G
        YtpfpkVAP0cU7G/z67zkXz+UrfkZuG+X+QDcshTnfuyr6hcmrTr91bE1wBjbYw==
Date:   Mon, 29 Aug 2022 11:01:59 +0200
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] net: mac802154: Fix a condition in the receive path
Message-ID: <20220829110159.6321a85f@xps-13>
In-Reply-To: <57b7d918-1da1-f490-4882-5ed25ea17503@datenfreihafen.org>
References: <20220826142954.254853-1-miquel.raynal@bootlin.com>
        <57b7d918-1da1-f490-4882-5ed25ea17503@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

stefan@datenfreihafen.org wrote on Mon, 29 Aug 2022 10:52:52 +0200:

> Hello Miquel.
>=20
> On 26.08.22 16:29, Miquel Raynal wrote:
> > Upon reception, a packet must be categorized, either it's destination is
> > the host, or it is another host. A packet with no destination addressing
> > fields may be valid in two situations:
> > - the packet has no source field: only ACKs are built like that, we
> >    consider the host as the destination.
> > - the packet has a valid source field: it is directed to the PAN
> >    coordinator, as for know we don't have this information we consider =
we
> >    are not the PAN coordinator.
> >=20
> > There was likely a copy/paste error made during a previous cleanup
> > because the if clause is now containing exactly the same condition as in
> > the switch case, which can never be true. In the past the destination
> > address was used in the switch and the source address was used in the
> > if, which matches what the spec says.
> >=20
> > Cc: stable@vger.kernel.org
> > Fixes: ae531b9475f6 ("ieee802154: use ieee802154_addr instead of *_sa v=
ariants")
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >   net/mac802154/rx.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > index b8ce84618a55..c439125ef2b9 100644
> > --- a/net/mac802154/rx.c
> > +++ b/net/mac802154/rx.c
> > @@ -44,7 +44,7 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data =
*sdata, =20
> >   >   	switch (mac_cb(skb)->dest.mode) { =20
> >   	case IEEE802154_ADDR_NONE:
> > -		if (mac_cb(skb)->dest.mode !=3D IEEE802154_ADDR_NONE)
> > +		if (hdr->source.mode !=3D IEEE802154_ADDR_NONE)
> >   			/* FIXME: check if we are PAN coordinator */
> >   			skb->pkt_type =3D PACKET_OTHERHOST;
> >   		else =20
>=20
>=20
> This patch has been applied to the wpan tree and will be
> part of the next pull request to net. Thanks!

Great, thanks!

We should expect it not to apply until the tag mentioned in Fixes
because in 2015 or so there was some cleaned done by Alexander which
move things around a little bit, but I think we are fine skipping those
older releases anyway.

Thanks,
Miqu=C3=A8l
