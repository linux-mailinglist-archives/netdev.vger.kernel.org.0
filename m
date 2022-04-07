Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252D14F785A
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbiDGH6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242588AbiDGH6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:58:10 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0879D10BC;
        Thu,  7 Apr 2022 00:56:09 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1AF3E40007;
        Thu,  7 Apr 2022 07:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649318168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xzWtQrGhF2FpjlxnqN15bbWBsiH0n20STMCunGqXD5c=;
        b=F46l/X2MljR59/T8b2ny2WoUKrkPmsluEtlliPuM5bcVjt8M5eiAhx5nBv1K3YnRa4Kl9/
        knf0FqVpAKNh/msd17xhC7OIDq62nqFA+FsrZ6lZRfY/QSzBILHzBL+Q+PcYlei/NpMxoh
        gXtxDlfBwL+EpD0FctCZlZLBDmirI5p/sAnx2FCSvhZYa5PdJmKp9q/l+BIbrSbx2+59tw
        5x9YHIio5vNh9EJUY8eOsB9yMD/Xqx0YqgzS/eKXdDrEW4CLbollbFMz4zFUWouvEkBB1q
        zrAbHVs5eD3Orc2AVQRiMwtyDAptAGsBkGcPNwUN6y9b2OTOsiMKGfLmx3x//g==
Date:   Thu, 7 Apr 2022 09:56:05 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v5 05/11] net: mac802154: Create a transmit bus error
 helper
Message-ID: <20220407095605.1ca9f6e6@xps13>
In-Reply-To: <CAB_54W53OrQVYo4pjCpgYaQGVsa-hZ2gBrquFGO_vQ5RMsm-jQ@mail.gmail.com>
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
        <20220406153441.1667375-6-miquel.raynal@bootlin.com>
        <CAB_54W53OrQVYo4pjCpgYaQGVsa-hZ2gBrquFGO_vQ5RMsm-jQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Wed, 6 Apr 2022 17:43:30 -0400:

> Hi,
>=20
> On Wed, Apr 6, 2022 at 11:34 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > A few drivers do the full transmit operation asynchronously, which means
> > that a bus error that happens when forwarding the packet to the
> > transmitter will not be reported immediately. The solution in this case
> > is to call this new helper to free the necessary resources, restart the
> > the queue and return a generic TRAC error code: IEEE802154_SYSTEM_ERROR.
> >
> > Suggested-by: Alexander Aring <alex.aring@gmail.com>
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/net/mac802154.h |  9 +++++++++
> >  net/mac802154/util.c    | 10 ++++++++++
> >  2 files changed, 19 insertions(+)
> >
> > diff --git a/include/net/mac802154.h b/include/net/mac802154.h
> > index abbe88dc9df5..5240d94aad8e 100644
> > --- a/include/net/mac802154.h
> > +++ b/include/net/mac802154.h
> > @@ -498,6 +498,15 @@ void ieee802154_stop_queue(struct ieee802154_hw *h=
w);
> >  void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff=
 *skb,
> >                               bool ifs_handling);
> >
> > +/**
> > + * ieee802154_xmit_bus_error - frame could not be delivered to the tra=
smitter
> > + *                             because of a bus error
> > + *
> > + * @hw: pointer as obtained from ieee802154_alloc_hw().
> > + * @skb: buffer for transmission
> > + */
> > +void ieee802154_xmit_bus_error(struct ieee802154_hw *hw, struct sk_buf=
f *skb);
> > +
> >  /**
> >   * ieee802154_xmit_error - frame transmission failed
> >   *
> > diff --git a/net/mac802154/util.c b/net/mac802154/util.c
> > index ec523335336c..79ba803c40c9 100644
> > --- a/net/mac802154/util.c
> > +++ b/net/mac802154/util.c
> > @@ -102,6 +102,16 @@ void ieee802154_xmit_error(struct ieee802154_hw *h=
w, struct sk_buff *skb,
> >  }
> >  EXPORT_SYMBOL(ieee802154_xmit_error);
> >
> > +void ieee802154_xmit_bus_error(struct ieee802154_hw *hw, struct sk_buf=
f *skb)
> > +{
> > +       struct ieee802154_local *local =3D hw_to_local(hw);
> > +
> > +       local->tx_result =3D IEEE802154_SYSTEM_ERROR;
> > +       ieee802154_wake_queue(hw);
> > +       dev_kfree_skb_any(skb);
> > +}
> > +EXPORT_SYMBOL(ieee802154_xmit_bus_error);
> > + =20
>=20
> why not calling ieee802154_xmit_error(..., IEEE802154_SYSTEM_ERROR) ?
> Just don't give the user a chance to pick a error code if something
> bad happened.

Oh ok, I assumed, based on your last comment, that you wanted a
dedicated helper for that, but if just calling xmit_error() with the
a fixed value is enough I'll drop this commit.

Thanks,
Miqu=C3=A8l
