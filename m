Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3DB452B627
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 11:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbiERJNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 05:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233922AbiERJNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:13:35 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850901207D7;
        Wed, 18 May 2022 02:13:32 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 10CC7E001D;
        Wed, 18 May 2022 09:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652865211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=04jfuH5BFGccW5q5/b1RjsWpg65MB3wYyeNJmV7uelc=;
        b=FK29SCUS/LN4YW5+LtO8rrzkY5OQ3fhFKcK+BP/Pvr7uQi6T9Tjn+4PMZ1ADt1wumrS9xX
        zSh7h36MzGd+TtNpsyGjpasyJU51Bz7kpcMUI+gpxYJ1IpCJg49M5y/FhLrJsWFUehh5bE
        aB66y3Odb1UelG6RLWbJmMD9EKf9gfAo9jSYFWEKv8AS2akVQDQUpWCrWYzk5YEu3/CO1o
        PnYnFNRNHlUrBQ8EOUW/n3F41Pqk6T53FHobMaf4R4Upr3ZEjHh8MKkycgu9Gxz7Y/Ghwg
        N7rQPWaCEAtg6SsWz6eIeWz9Loc/eWzkpIUVwpgtrQWVtodp7X6zEyIZLD82Ug==
Date:   Wed, 18 May 2022 11:13:26 +0200
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
Message-ID: <20220518111326.243d7b45@xps-13>
In-Reply-To: <CAK-6q+h=gNqoUHYi_2xamdGyMOYpO0GDO6--oKXSevJC9Wywag@mail.gmail.com>
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
        <20220512143314.235604-11-miquel.raynal@bootlin.com>
        <CAK-6q+jYb7A2RzG3u7PJYKZU9D5A=vben-Wnu-3EsUU-rqGT2Q@mail.gmail.com>
        <20220517153655.155ba311@xps-13>
        <20220517165259.52ddf6fc@xps-13>
        <CAK-6q+h=gNqoUHYi_2xamdGyMOYpO0GDO6--oKXSevJC9Wywag@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

aahringo@redhat.com wrote on Tue, 17 May 2022 20:59:39 -0400:

> Hi,
>=20
> On Tue, May 17, 2022 at 10:53 AM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> >
> > miquel.raynal@bootlin.com wrote on Tue, 17 May 2022 15:36:55 +0200:
> > =20
> > > aahringo@redhat.com wrote on Sun, 15 May 2022 18:30:15 -0400:
> > > =20
> > > > Hi,
> > > >
> > > > On Thu, May 12, 2022 at 10:34 AM Miquel Raynal
> > > > <miquel.raynal@bootlin.com> wrote: =20
> > > > >
> > > > > We should never start a transmission after the queue has been sto=
pped.
> > > > >
> > > > > But because it might work we don't kill the function here but rat=
her
> > > > > warn loudly the user that something is wrong.
> > > > >
> > > > > Set an atomic when the queue will remain stopped. Reset this atom=
ic when
> > > > > the queue actually gets restarded. Just check this atomic to know=
 if the
> > > > > transmission is legitimate, warn if it is not.
> > > > >
> > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > ---
> > > > >  include/net/cfg802154.h |  1 +
> > > > >  net/mac802154/tx.c      | 16 +++++++++++++++-
> > > > >  net/mac802154/util.c    |  1 +
> > > > >  3 files changed, 17 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > > > > index 8b6326aa2d42..a1370e87233e 100644
> > > > > --- a/include/net/cfg802154.h
> > > > > +++ b/include/net/cfg802154.h
> > > > > @@ -218,6 +218,7 @@ struct wpan_phy {
> > > > >         struct mutex queue_lock;
> > > > >         atomic_t ongoing_txs;
> > > > >         atomic_t hold_txs;
> > > > > +       atomic_t queue_stopped; =20
> > > >
> > > > Maybe some test_bit()/set_bit() is better there? =20
> > >
> > > What do you mean? Shall I change the atomic_t type of queue_stopped?
> > > Isn't the atomic_t preferred in this situation? =20
> >
> > Actually I re-read the doc and that's right, a regular unsigned long =20
>=20
> Which doc is that?

Documentation/atomic_t.txt states [SEMANTICS chapter]:

	"if you find yourself only using the Non-RMW operations of
	atomic_t, you do not in fact need atomic_t at all and are doing it wrong."

In this case, I was only using atomic_set() and atomic_read(), which are
both non-RMW operations.

Thanks,
Miqu=C3=A8l
