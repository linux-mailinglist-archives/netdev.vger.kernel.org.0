Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B42E52A55D
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 16:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349288AbiEQOxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 10:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349512AbiEQOxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 10:53:23 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8CA1EC6D;
        Tue, 17 May 2022 07:53:05 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 89A71E000B;
        Tue, 17 May 2022 14:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652799183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r8NUncwq3s1CVu2P00UGMPhablf+3nQ86dd2EzZyPuU=;
        b=mAyGveIGQVn1eSiEL28K7wsFioIN3X/1ytQcrccYRxEBln+stTofq1nFApbhUXjmY9mHlY
        nsb3BIuiyUX+Ko96kIIsF3FGhS0VWPyFtoQ6EoBz75pGduT54v1RfAg/W1a65iFdP7+s/4
        uKadIFw/R48vBIWTkqa63a2HLXq3iXrC2VBX+sRMkDN/nALUmSXX2jClT/cnSDkvQ/FY7A
        4C8JNKTQ7EQQ7NYbWnrGJ+pNI+apM1dGQCpn6VPwhmB9qHMlUBNaER3QtVwjb5YLmDUWG3
        ZkFhF97em/4BU7qrYeRvVHSfdksnh+RofinDXNxmZvm84XjMTvYYQfPoAw/iqQ==
Date:   Tue, 17 May 2022 16:52:59 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v2 10/11] net: mac802154: Add a warning in the
 hot path
Message-ID: <20220517165259.52ddf6fc@xps-13>
In-Reply-To: <20220517153655.155ba311@xps-13>
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
        <20220512143314.235604-11-miquel.raynal@bootlin.com>
        <CAK-6q+jYb7A2RzG3u7PJYKZU9D5A=vben-Wnu-3EsUU-rqGT2Q@mail.gmail.com>
        <20220517153655.155ba311@xps-13>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
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


miquel.raynal@bootlin.com wrote on Tue, 17 May 2022 15:36:55 +0200:

> aahringo@redhat.com wrote on Sun, 15 May 2022 18:30:15 -0400:
>=20
> > Hi,
> >=20
> > On Thu, May 12, 2022 at 10:34 AM Miquel Raynal
> > <miquel.raynal@bootlin.com> wrote: =20
> > >
> > > We should never start a transmission after the queue has been stopped.
> > >
> > > But because it might work we don't kill the function here but rather
> > > warn loudly the user that something is wrong.
> > >
> > > Set an atomic when the queue will remain stopped. Reset this atomic w=
hen
> > > the queue actually gets restarded. Just check this atomic to know if =
the
> > > transmission is legitimate, warn if it is not.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  include/net/cfg802154.h |  1 +
> > >  net/mac802154/tx.c      | 16 +++++++++++++++-
> > >  net/mac802154/util.c    |  1 +
> > >  3 files changed, 17 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > > index 8b6326aa2d42..a1370e87233e 100644
> > > --- a/include/net/cfg802154.h
> > > +++ b/include/net/cfg802154.h
> > > @@ -218,6 +218,7 @@ struct wpan_phy {
> > >         struct mutex queue_lock;
> > >         atomic_t ongoing_txs;
> > >         atomic_t hold_txs;
> > > +       atomic_t queue_stopped;   =20
> >=20
> > Maybe some test_bit()/set_bit() is better there? =20
>=20
> What do you mean? Shall I change the atomic_t type of queue_stopped?
> Isn't the atomic_t preferred in this situation?

Actually I re-read the doc and that's right, a regular unsigned long
used with test/set_bit might be preferred, I'll make the change.

Thanks,
Miqu=C3=A8l
