Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DE25A1DD0
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbiHZAwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiHZAwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:52:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825E8C8766
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 17:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661475123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WSFX6y8b5iTiRkZ50bFiPpqWxjJ+SyK+rCI33sJWvZw=;
        b=EcIwXNsVe9rOq6Azp+SlS2A3qyO1a+63z6fnQWoXIRoInEmh/v6oAVsOTe7/9IRjUmbpBJ
        Wl5aWkkSLhKJ9aw8d+uBhqDwGvwndevZoixbv1ICsff+7VetyObU9Gumwsv6sOYTDXDdSz
        h3r+j2y0pxtt/ru04ClJTFkVRmHWqnM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-500-_aastOFWM16InHXSLYJp6g-1; Thu, 25 Aug 2022 20:52:01 -0400
X-MC-Unique: _aastOFWM16InHXSLYJp6g-1
Received: by mail-qk1-f198.google.com with SMTP id bj2-20020a05620a190200b006bba055ab6eso104264qkb.12
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 17:52:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=WSFX6y8b5iTiRkZ50bFiPpqWxjJ+SyK+rCI33sJWvZw=;
        b=1X2HLq6zCVxDGisESXQqbRI8uYu0tNhnlHhxSNdj52vdi2BZDp2Q2OVI40rEjZpIxE
         HCkg25zjLGCUEcC6hJV9pYMD0N1BxIR6BSfhjKUBEsMUUF2Ypncc4Z+kHynh/t22q6m7
         WuRFq8n22FsrTbTG0WSYwnLmODnJV9SPepq/Xe6rt0cJAq8+uSBKZ4Chm/u3WtnSibSo
         fjJn3LrsGaIiFcFtYDhY7321YG09XcnNE+e8cpmZ7H4u4wcbmenbG5oTzwudqay0Sg3O
         CRD/n38ro+6HMkb7/KZ9cFsy4dRzRm+Uz9ptnaliaRkjerEuphMXppDt6DDy6s06zV8g
         l+wQ==
X-Gm-Message-State: ACgBeo1rSghhpWrCnZ1CHN3pQwl+QTTywHkPsg8/Quc9b/nJ7/UwQ3G8
        3S2pocoJq/mRKYsMiqFCPjhw0Z0uvpZugik7MNXjfBfDzKXcipjIQ5+oSn3GjRzU5LjeRN6w2xv
        6CEkDTqR4Iou6d83N3vpeV7AhhmPXGTnR
X-Received: by 2002:a05:622a:4cd:b0:343:65a4:e212 with SMTP id q13-20020a05622a04cd00b0034365a4e212mr5882713qtx.526.1661475121214;
        Thu, 25 Aug 2022 17:52:01 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4YJqrZSshF1vlykHNrdknf7xVRzPrl6kocULXRRD4BQKI0CifD9B+puEYkCNRATyY1ZqEJQ/bsP6qBxlDClUw=
X-Received: by 2002:a05:622a:4cd:b0:343:65a4:e212 with SMTP id
 q13-20020a05622a04cd00b0034365a4e212mr5882695qtx.526.1661475120936; Thu, 25
 Aug 2022 17:52:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220701143052.1267509-2-miquel.raynal@bootlin.com> <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
 <20220819191109.0e639918@xps-13> <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
 <20220823182950.1c722e13@xps-13> <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
 <20220824093547.16f05d15@xps-13> <CAK-6q+gqX8w+WEgSk2J9FOdrFJPvqJOsgmaY4wOu=siRszBujA@mail.gmail.com>
 <20220825104035.11806a67@xps-13>
In-Reply-To: <20220825104035.11806a67@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 25 Aug 2022 20:51:49 -0400
Message-ID: <CAK-6q+hxSpw1yJR5H5D6gy5gGdm6Qa3VzyjZXA45KFQfVVqwFw@mail.gmail.com>
Subject: Re: [PATCH wpan-next 01/20] net: mac802154: Allow the creation of
 coordinator interfaces
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Aug 25, 2022 at 4:41 AM Miquel Raynal <miquel.raynal@bootlin.com> w=
rote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Wed, 24 Aug 2022 17:43:11 -0400:
>
> > On Wed, Aug 24, 2022 at 3:35 AM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote:
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Tue, 23 Aug 2022 17:44:52 -0400:
> > >
> > > > Hi,
> > > >
> > > > On Tue, Aug 23, 2022 at 12:29 PM Miquel Raynal
> > > > <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > Hi Alexander,
> > > > >
> > > > > aahringo@redhat.com wrote on Tue, 23 Aug 2022 08:33:30 -0400:
> > > > >
> > > > > > Hi,
> > > > > >
> > > > > > On Fri, Aug 19, 2022 at 1:11 PM Miquel Raynal <miquel.raynal@bo=
otlin.com> wrote:
> > > > > > >
> > > > > > > Hi Alexander,
> > > > > > >
> > > > > > > aahringo@redhat.com wrote on Tue, 5 Jul 2022 21:51:02 -0400:
> > > > > > >
> > > > > > > > Hi,
> > > > > > > >
> > > > > > > > On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.rayna=
l@bootlin.com> wrote:
> > > > > > > > >
> > > > > > > > > As a first strep in introducing proper PAN management and=
 association,
> > > > > > > > > we need to be able to create coordinator interfaces which=
 might act as
> > > > > > > > > coordinator or PAN coordinator.
> > > > > > > > >
> > > > > > > > > Hence, let's add the minimum support to allow the creatio=
n of these
> > > > > > > > > interfaces. This might be restrained and improved later.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > > > > > ---
> > > > > > > > >  net/mac802154/iface.c | 14 ++++++++------
> > > > > > > > >  net/mac802154/rx.c    |  2 +-
> > > > > > > > >  2 files changed, 9 insertions(+), 7 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/net/mac802154/iface.c b/net/mac802154/iface.=
c
> > > > > > > > > index 500ed1b81250..7ac0c5685d3f 100644
> > > > > > > > > --- a/net/mac802154/iface.c
> > > > > > > > > +++ b/net/mac802154/iface.c
> > > > > > > > > @@ -273,13 +273,13 @@ ieee802154_check_concurrent_iface(s=
truct ieee802154_sub_if_data *sdata,
> > > > > > > > >                 if (nsdata !=3D sdata && ieee802154_sdata=
_running(nsdata)) {
> > > > > > > > >                         int ret;
> > > > > > > > >
> > > > > > > > > -                       /* TODO currently we don't suppor=
t multiple node types
> > > > > > > > > -                        * we need to run skb_clone at rx=
 path. Check if there
> > > > > > > > > -                        * exist really an use case if we=
 need to support
> > > > > > > > > -                        * multiple node types at the sam=
e time.
> > > > > > > > > +                       /* TODO currently we don't suppor=
t multiple node/coord
> > > > > > > > > +                        * types we need to run skb_clone=
 at rx path. Check if
> > > > > > > > > +                        * there exist really an use case=
 if we need to support
> > > > > > > > > +                        * multiple node/coord types at t=
he same time.
> > > > > > > > >                          */
> > > > > > > > > -                       if (wpan_dev->iftype =3D=3D NL802=
154_IFTYPE_NODE &&
> > > > > > > > > -                           nsdata->wpan_dev.iftype =3D=
=3D NL802154_IFTYPE_NODE)
> > > > > > > > > +                       if (wpan_dev->iftype !=3D NL80215=
4_IFTYPE_MONITOR &&
> > > > > > > > > +                           nsdata->wpan_dev.iftype !=3D =
NL802154_IFTYPE_MONITOR)
> > > > > > > > >                                 return -EBUSY;
> > > > > > > > >
> > > > > > > > >                         /* check all phy mac sublayer set=
tings are the same.
> > > > > > > > > @@ -577,6 +577,7 @@ ieee802154_setup_sdata(struct ieee802=
154_sub_if_data *sdata,
> > > > > > > > >         wpan_dev->short_addr =3D cpu_to_le16(IEEE802154_A=
DDR_BROADCAST);
> > > > > > > > >
> > > > > > > > >         switch (type) {
> > > > > > > > > +       case NL802154_IFTYPE_COORD:
> > > > > > > > >         case NL802154_IFTYPE_NODE:
> > > > > > > > >                 ieee802154_be64_to_le64(&wpan_dev->extend=
ed_addr,
> > > > > > > > >                                         sdata->dev->dev_a=
ddr);
> > > > > > > > > @@ -636,6 +637,7 @@ ieee802154_if_add(struct ieee802154_l=
ocal *local, const char *name,
> > > > > > > > >         ieee802154_le64_to_be64(ndev->perm_addr,
> > > > > > > > >                                 &local->hw.phy->perm_exte=
nded_addr);
> > > > > > > > >         switch (type) {
> > > > > > > > > +       case NL802154_IFTYPE_COORD:
> > > > > > > > >         case NL802154_IFTYPE_NODE:
> > > > > > > > >                 ndev->type =3D ARPHRD_IEEE802154;
> > > > > > > > >                 if (ieee802154_is_valid_extended_unicast_=
addr(extended_addr)) {
> > > > > > > > > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > > > > > > > > index b8ce84618a55..39459d8d787a 100644
> > > > > > > > > --- a/net/mac802154/rx.c
> > > > > > > > > +++ b/net/mac802154/rx.c
> > > > > > > > > @@ -203,7 +203,7 @@ __ieee802154_rx_handle_packet(struct =
ieee802154_local *local,
> > > > > > > > >         }
> > > > > > > > >
> > > > > > > > >         list_for_each_entry_rcu(sdata, &local->interfaces=
, list) {
> > > > > > > > > -               if (sdata->wpan_dev.iftype !=3D NL802154_=
IFTYPE_NODE)
> > > > > > > > > +               if (sdata->wpan_dev.iftype =3D=3D NL80215=
4_IFTYPE_MONITOR)
> > > > > > > > >                         continue;
> > > > > > > >
> > > > > > > > I probably get why you are doing that, but first the overal=
l design is
> > > > > > > > working differently - means you should add an additional re=
ceive path
> > > > > > > > for the special interface type.
> > > > > > > >
> > > > > > > > Also we "discovered" before that the receive path of node v=
s
> > > > > > > > coordinator is different... Where is the different handling=
 here? I
> > > > > > > > don't see it, I see that NODE and COORD are the same now (b=
ecause that
> > > > > > > > is _currently_ everything else than monitor). This change i=
s not
> > > > > > > > enough and does "something" to handle in some way coordinat=
or receive
> > > > > > > > path but there are things missing.
> > > > > > > >
> > > > > > > > 1. Changing the address filters that it signals the transce=
iver it's
> > > > > > > > acting as coordinator
> > > > > > > > 2. We _should_ also have additional handling for whatever t=
he
> > > > > > > > additional handling what address filters are doing in mac80=
2154
> > > > > > > > _because_ there is hardware which doesn't have address filt=
ering e.g.
> > > > > > > > hwsim which depend that this is working in software like ot=
her
> > > > > > > > transceiver hardware address filters.
> > > > > > > >
> > > > > > > > For the 2. one, I don't know if we do that even for NODE ri=
ght or we
> > > > > > > > just have the bare minimal support there... I don't assume =
that
> > > > > > > > everything is working correctly here but what I want to see=
 is a
> > > > > > > > separate receive path for coordinators that people can send=
 patches to
> > > > > > > > fix it.
> > > > > > >
> > > > > > > Yes, we do very little differently between the two modes, tha=
t's why I
> > > > > > > took the easy way: just changing the condition. I really don'=
t see what
> > > > > > > I can currently add here, but I am fine changing the style to=
 easily
> > > > > > > show people where to add filters for such or such interface, =
but right
> > > > > > > now both path will look very "identical", do we agree on that=
?
> > > > > >
> > > > > > mostly yes, but there exists a difference and we should at leas=
t check
> > > > > > if the node receive path violates the coordinator receive path =
and
> > > > > > vice versa.
> > > > > > Put it in a receive_path() function and then coord_receive_path=
(),
> > > > > > node_receive_path() that calls the receive_path() and do the
> > > > > > additional filtering for coordinators, etc.
> > > > > >
> > > > > > There should be a part in the standard about "third level filte=
r rule
> > > > > > if it's a coordinator".
> > > > > > btw: this is because the address filter on the transceiver need=
s to
> > > > > > have the "i am a coordinator" boolean set which is missing in t=
his
> > > > > > series. However it depends on the transceiver filtering level a=
nd the
> > > > > > mac802154 receive path if we actually need to run such filterin=
g or
> > > > > > not.
> > > > >
> > > > > I must be missing some information because I can't find any place=
s
> > > > > where what you suggest is described in the spec.
> > > > >
> > > > > I agree there are multiple filtering level so let's go through th=
em one
> > > > > by one (6.7.2 Reception and rejection):
> > > > > - first level: is the checksum (FCS) valid?
> > > > >         yes -> goto second level
> > > > >         no -> drop
> > > > > - second level: are we in promiscuous mode?
> > > > >         yes -> forward to upper layers
> > > > >         no -> goto second level (bis)
> > > > > - second level (bis): are we scanning?
> > > > >         yes -> goto scan filtering
> > > > >         no -> goto third level
> > > > > - scan filtering: is it a beacon?
> > > > >         yes -> process the beacon
> > > > >         no -> drop
> > > > > - third level: is the frame valid? (type, source, destination, pa=
n id,
> > > > >   etc)
> > > > >         yes -> forward to upper layers
> > > > >         no -> drop
> > > > >
> > > > > But none of them, as you said, is dependent on the interface type=
.
> > > > > There is no mention of a specific filtering operation to do in al=
l
> > > > > those cases when running in COORD mode. So I still don't get what
> > > > > should be included in either node_receive_path() which should be
> > > > > different than in coord_receive_path() for now.
> > > > >
> > > > > There are, however, two situations where the interface type has i=
ts
> > > > > importance:
> > > > > - Enhanced beacon requests with Enhanced beacon filter IE, which =
asks
> > > > >   the receiving device to process/drop the request upon certain
> > > > >   conditions (minimum LQI and/or randomness), as detailed in
> > > > >   7.4.4.6 Enhanced Beacon Filter IE. But, as mentioned in
> > > > >   7.5.9 Enhanced Beacon Request command: "The Enhanced Beacon Req=
uest
> > > > >   command is optional for an FFD and an RFD", so this series was =
only
> > > > >   targeting basic beaconing for now.
> > > > > - In relaying mode, the destination address must not be validated
> > > > >   because the message needs to be re-emitted. Indeed, a receiver =
in
> > > > >   relaying mode may not be the recipient. This is also optional a=
nd out
> > > > >   of the scope of this series.
> > > > >
> > > > > Right now I have the below diff, which clarifies the two path, wi=
thout
> > > > > too much changes in the current code because I don't really see w=
hy it
> > > > > would be necessary. Unless you convince me otherwise or read the =
spec
> > > > > differently than I do :) What do you think?
> > > > >
> > > >
> > > > "Reception and rejection"
> > > >
> > > > third-level filtering regarding "destination address" and if the
> > > > device is "PAN coordinator".
> > > > This is, in my opinion, what the coordinator boolean tells the
> > > > transceiver to do on hardware when doing address filter there. You =
can
> > > > also read that up in datasheets of transceivers as atf86rf233, sear=
ch
> > > > for I_AM_COORD.
> > >
> > > Oh right, I now see what you mean!
> > >
> > > > Whereas they use the word "PAN coordinator" not "coordinator", if t=
hey
> > > > really make a difference there at this point..., if so then the ker=
nel
> > > > must know if the coordinator is a pan coordinator or coordinator
> > > > because we need to set the address filter in kernel.
> > >
> > > Yes we need to make a difference, you can have several coordinators b=
ut
> > > a single PAN coordinator in a PAN. I think we can assume that the PAN
> > > coordinator is the coordinator with no parent (association-wise). Wit=
h
> > > the addition of the association series, I can handle that, so I will
> > > create the two path as you advise, add a comment about this additiona=
l
> > > filter rule that we don't yet support, and finally after the
> > > association series add another commit to make this filtering rule rea=
l.
> > >
> > > >
> > > > > Thanks,
> > > > > Miqu=C3=A8l
> > > > >
> > > > > ---
> > > > >
> > > > > --- a/net/mac802154/rx.c
> > > > > +++ b/net/mac802154/rx.c
> > > > > @@ -194,6 +194,7 @@ __ieee802154_rx_handle_packet(struct ieee8021=
54_local *local,
> > > > >         int ret;
> > > > >         struct ieee802154_sub_if_data *sdata;
> > > > >         struct ieee802154_hdr hdr;
> > > > > +       bool iface_found =3D false;
> > > > >
> > > > >         ret =3D ieee802154_parse_frame_start(skb, &hdr);
> > > > >         if (ret) {
> > > > > @@ -203,18 +204,31 @@ __ieee802154_rx_handle_packet(struct ieee80=
2154_local *local,
> > > > >         }
> > > > >
> > > > >         list_for_each_entry_rcu(sdata, &local->interfaces, list) =
{
> > > > > -               if (sdata->wpan_dev.iftype !=3D NL802154_IFTYPE_N=
ODE)
> > > > > +               if (sdata->wpan_dev.iftype =3D=3D NL802154_IFTYPE=
_MONITOR)
> > > > >                         continue;
> > > > >
> > > > >                 if (!ieee802154_sdata_running(sdata))
> > > > >                         continue;
> > > > >
> > > > > +               iface_found =3D true;
> > > > > +               break;
> > > > > +       }
> > > > > +
> > > > > +       if (!iface_found) {
> > > > > +               kfree_skb(skb);
> > > > > +               return;
> > > > > +       }
> > > > > +
> > > > > +       /* TBD: Additional filtering is possible on NODEs and/or =
COORDINATORs */
> > > > > +       switch (sdata->wpan_dev.iftype) {
> > > > > +       case NL802154_IFTYPE_COORD:
> > > > > +       case NL802154_IFTYPE_NODE:
> > > > >                 ieee802154_subif_frame(sdata, skb, &hdr);
> > > > > -               skb =3D NULL;
> > > > > +               break;
> > > > > +       default:
> > > > > +               kfree_skb(skb);
> > > > >                 break;
> > > > >         }
> > > >
> > > > Why do you remove the whole interface looping above and make it onl=
y
> > > > run for one ?first found? ?
> > >
> > > To reduce the indentation level.
> > >
> > > > That code changes this behaviour and I do
> > > > not know why.
> > >
> > > The precedent code did:
> > > for_each_iface() {
> > >         if (not a node)
> > >                 continue;
> > >         if (not running)
> > >                 continue;
> > >
> > >         subif_frame();
> > >         break;
> > > }
> > >
> > > That final break also elected only the first running node iface.
> > > Otherwise it would mean that we allow the same skb to be consumed
> > > twice, which is wrong IMHO?
> >
> > no? Why is that wrong? There is a real use-case to have multiple
> > interfaces on one phy (or to do it in near future, I said that
> > multiple times). This patch does a step backwards to this.
>
> So we need to duplicate the skb because it automatically gets freed in
> the "forward to upper layer" path. Am I right? I'm fine doing so if

What is the definition of "duplicate the skb" here.

> this is the way to go, but I am interested if you can give me a real
> use case where having NODE+COORDINATOR on the same PHY is useful?
>

Testing.

- Alex

