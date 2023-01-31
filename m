Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E5A682B17
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbjAaLD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbjAaLD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:03:57 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209C03C12;
        Tue, 31 Jan 2023 03:03:52 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 43C20E000D;
        Tue, 31 Jan 2023 11:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675163031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LheJCo+IpBubLdFfgTl8vL77nqbhOcG8gPSOW+UeSVw=;
        b=Mz+t9zWtbem3+HpUFUuAYwUXoW9auqWcbI7K/1pP52OtYAcTB2tOFH4/rxYN/AjToh3GmD
        SlWIfKc9oY69LDKZQ+bXMbMuMFl9xtJJkiFXXggbKndrMcO9UUFYDT7LPVE9F4famr/ciE
        27AHV6jMp708dztFjswefyuhsQtT1IAEw6XODrXQmAqwjTshKfHQ62bk6s+E6ZuDMQhzLG
        dTKBtUAcGVNTPj2pjDYqdxw7Zz50VGzg4kkuf5o9rzQfv4vhs93YUkj9HvpfjSzNfxeSpi
        sYG0w77UcqL8cRD9AQ3m1PwvfOte3l2LSSAOWnGSP+jO5ltl8KnaccVRxv1aLA==
Date:   Tue, 31 Jan 2023 12:03:46 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH wpan-next] mac802154: Avoid superfluous endianness
 handling
Message-ID: <20230131120346.65d42f25@xps-13>
In-Reply-To: <CAK-6q+iOXe2CQ=Bc4Ba8vK=M_hTW7cdJ5TormiHy5DJsiyr_BQ@mail.gmail.com>
References: <20230130154306.114265-1-miquel.raynal@bootlin.com>
        <f604d39b-d801-8373-9d8f-e93e429b7cdd@datenfreihafen.org>
        <CAK-6q+iOXe2CQ=Bc4Ba8vK=M_hTW7cdJ5TormiHy5DJsiyr_BQ@mail.gmail.com>
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

aahringo@redhat.com wrote on Mon, 30 Jan 2023 11:41:20 -0500:

> Hi,
>=20
> On Mon, Jan 30, 2023 at 11:34 AM Stefan Schmidt
> <stefan@datenfreihafen.org> wrote:
> >
> > Hello.
> >
> > On 30.01.23 16:43, Miquel Raynal wrote: =20
> > > When compiling scan.c with C=3D1, Sparse complains with:
> > >
> > >     sparse:     expected unsigned short [usertype] val
> > >     sparse:     got restricted __le16 [usertype] pan_id
> > >     sparse: sparse: cast from restricted __le16
> > >
> > >     sparse:     expected unsigned long long [usertype] val
> > >     sparse:     got restricted __le64 [usertype] extended_addr
> > >     sparse: sparse: cast from restricted __le64
> > >
> > > The tool is right, both pan_id and extended_addr already are rightful=
ly
> > > defined as being __le16 and __le64 on both sides of the operations and
> > > do not require extra endianness handling.
> > >
> > > Fixes: 3accf4762734 ("mac802154: Handle basic beaconing")
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >   net/mac802154/scan.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
> > > index cfbe20b1ec5e..8f98efec7753 100644
> > > --- a/net/mac802154/scan.c
> > > +++ b/net/mac802154/scan.c
> > > @@ -419,8 +419,8 @@ int mac802154_send_beacons_locked(struct ieee8021=
54_sub_if_data *sdata,
> > >       local->beacon.mhr.fc.source_addr_mode =3D IEEE802154_EXTENDED_A=
DDRESSING;
> > >       atomic_set(&request->wpan_dev->bsn, -1);
> > >       local->beacon.mhr.source.mode =3D IEEE802154_ADDR_LONG;
> > > -     local->beacon.mhr.source.pan_id =3D cpu_to_le16(request->wpan_d=
ev->pan_id);
> > > -     local->beacon.mhr.source.extended_addr =3D cpu_to_le64(request-=
>wpan_dev->extended_addr);
> > > +     local->beacon.mhr.source.pan_id =3D request->wpan_dev->pan_id;
> > > +     local->beacon.mhr.source.extended_addr =3D request->wpan_dev->e=
xtended_addr;
> > >       local->beacon.mac_pl.beacon_order =3D request->interval;
> > >       local->beacon.mac_pl.superframe_order =3D request->interval;
> > >       local->beacon.mac_pl.final_cap_slot =3D 0xf; =20
> >
> > This patch has been applied to the wpan-next tree and will be
> > part of the next pull request to net-next. Thanks! =20
>=20
> fyi: in my opinion, depending on system endianness this is actually a bug.

Actually there are many uses of __le16 and __le64 for PAN IDs, short
and extended addresses. I did follow the existing patterns, I think
they are legitimate. Can you clarify what you think is a bug in the
current state? I always feel a bit flaky when it comes to properly
handling endianness, so all feedback welcome, if you have any hints
of what should be fixed after this patch, I'll do it.=20

Thanks,
Miqu=C3=A8l
