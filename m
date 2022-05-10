Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4089521021
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbiEJJBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 05:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238298AbiEJJBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 05:01:05 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96ECB18996B;
        Tue, 10 May 2022 01:57:08 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7BC95100006;
        Tue, 10 May 2022 08:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652173027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZnFwzTlz2aq4QtptrpCp9sl+106xaZzHZs38DPjOssA=;
        b=IqeahinhO1hyLv9syQZaN4tVxfeak59NfkFm+QnDJQTTovhWp+PNVGKYn3tq+rM0fHcIAT
        FXtxGfAvNUe75ulpvoiZMOmJSLbK9UudkpZiz7Xs+mypVO9kOqZ4HtRH2hiWNXibhtNuoG
        lSrVKIeon6Gm95vDtiWn0F2MnjKpp0M4F9aaXXgI1KbeeFqSPKuybuL6nl56iX4dKMrwhk
        smbLgYFllPBXEJFx5WR4+r8ZtGtgyQDX3cqAqrICaXAhxoREH3lRjeklsOTt67ABmq8kcI
        XMxQS0W3dYoDj7wHG57MoG0GJQbJeJiC16AfFw3dsrBLpOoTeVAZJQTPnh6+/Q==
Date:   Tue, 10 May 2022 10:57:03 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 10/11] net: mac802154: Introduce a tx queue
 flushing mechanism
Message-ID: <20220510105703.6ef1bb10@xps13>
In-Reply-To: <CAK-6q+gkMbf7HGFWtaB2QX9z10dvbk2ac28to3TMUDS9MdWuvA@mail.gmail.com>
References: <20220427164659.106447-1-miquel.raynal@bootlin.com>
        <20220427164659.106447-11-miquel.raynal@bootlin.com>
        <CAK-6q+gkMbf7HGFWtaB2QX9z10dvbk2ac28to3TMUDS9MdWuvA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

> > --- a/net/mac802154/tx.c
> > +++ b/net/mac802154/tx.c
> > @@ -45,7 +45,8 @@ void ieee802154_xmit_sync_worker(struct work_struct *=
work)
> >         /* Restart the netif queue on each sub_if_data object. */
> >         ieee802154_wake_queue(local);
> >         kfree_skb(skb);
> > -       atomic_dec(&local->phy->ongoing_txs);
> > +       if (!atomic_dec_and_test(&local->phy->ongoing_txs))
> > +               wake_up(&local->phy->sync_txq);
> >         netdev_dbg(dev, "transmission failed\n");
> >  } =20
>=20
> There is a missing handling of dec() wake_up() in ieee802154_tx()
> "err_tx" label.

Good catch. Fixed.

Thanks,
Miqu=C3=A8l
