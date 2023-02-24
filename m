Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A9A6A1D2B
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 14:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjBXN6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 08:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjBXN6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 08:58:03 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E82D193D3;
        Fri, 24 Feb 2023 05:58:01 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C57D040003;
        Fri, 24 Feb 2023 13:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677247079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VoPzW7n5a+mXABqnPHMAAB9/qWEnlbkkwf/8DgTN3FU=;
        b=XdCbTgT372HdJ3JHLYf2HkanE6+aO7f0ytg/Q+lUid4cg1mTGtxvC3in+G9nEfONx3f1Ii
        ojqkHxeaWRMAhmUfGkiPHa+nayznc5NSGFW0Axn6MC5lcLz22ZJIMfaG3CaevnkGoITzsb
        jteh+SyF7T148q8xbhw/14y/Pp6PS7n2Paj3xCeqjhCjqd0kz6QpYP+BbeEoX/NmFhbhj2
        Kb3FxjheW474N18VPwcJ7AO3MMFUXVVzKq2KOB46EXHM1ZV+/veC9PL6i9bi8UtPl66/VJ
        WJ+tLkuxrFnfnszzkCyPE4TZ6B6OWR2L6o5qMgLnKzL/pdR5a6znrKfhyXJnCQ==
Date:   Fri, 24 Feb 2023 14:57:56 +0100
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
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning
 requests
Message-ID: <20230224145756.39349d29@xps-13>
In-Reply-To: <CAK-6q+ikVP2eWpT5xRkiJn_JoenmD6D5+xcc2RwwXTfC-zsobw@mail.gmail.com>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
        <20221129160046.538864-2-miquel.raynal@bootlin.com>
        <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
        <20230206101235.0371da87@xps-13>
        <CAK-6q+jav4yJD3MsOssyBobg1zGqKC5sm-xCRYX1SCkH9GhmHw@mail.gmail.com>
        <20230210182129.77c1084d@xps-13>
        <CAK-6q+jLKo1bLBie_xYZyZdyjNB_M8JvxDfr77RQAY9WYcQY8w@mail.gmail.com>
        <20230213111553.0dcce5c2@xps-13>
        <CAK-6q+jP55MaB-_ZbRHKESgEb-AW+kN3bU2SMWMtkozvoyfAwA@mail.gmail.com>
        <20230214152849.5c3d196b@xps-13>
        <CAK-6q+i-QiDpFptFPwDv05mwURGVHzmABcEn2z2L9xakQwgw+w@mail.gmail.com>
        <20230217095251.59c324d0@xps-13>
        <CAK-6q+ikVP2eWpT5xRkiJn_JoenmD6D5+xcc2RwwXTfC-zsobw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Mon, 20 Feb 2023 21:54:41 -0500:

> Hi,
>=20
> On Fri, Feb 17, 2023 at 3:53 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> ...
> > >
> > > ok, I am curious. Probably it is very driver/device specific but yea,
> > > HardMAC needs to at least support what 802.15.4 says, the rest is
> > > optional and result in -ENOTSUPP? =20
> >
> > TBH this is still a gray area in my mental model. I'm not sure what
> > these devices will really offer in terms of interfaces. =20
>=20
> ca8210 is one. They use those SAP-commands (MCPS-SAP and MLME-SAP)
> which are described by 802.15.4 spec... there is this cfg802154_ops
> structure which will redirect netlink to either SoftMAC or HardMAC it
> should somehow conform to this...

Absolutely.

> However I think it should be the minimum functionality inside of this,
> there might be a lot of optional things which only SoftMAC supports.
> Also nl802154 should be oriented to this.
>=20
> Are you agreeing here?

Yes. That support can also be improved if we ever have to support
advanced functionalities with "new" and compatible HardMAC devices.

Thanks,
Miqu=C3=A8l
