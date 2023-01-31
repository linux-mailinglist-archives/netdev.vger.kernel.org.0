Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDAF6820A0
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 01:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjAaAWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 19:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjAaAWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 19:22:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6501BDB
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 16:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675124515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JtIojjqPJfWA8r7fIaLtZliC5rFkK+e5G2vXAK457RY=;
        b=HU1jMZv7vc8wsRMvMWy5p9HMPAo6gho1jHzEQNTwHUEHss2myAUPAStWqfXlccX6qdCyA/
        KoC1nmNB6eaEhI29CfLkOCCfURrkfsKDUgV03tx3X/fFAEjILUvK+VGNciymWFSCXw1J7v
        rx2PafBRcQOfC1l7JpPyaegIW5NXaH8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-76-TA-EGeM3OsyLZdG0npOdWQ-1; Mon, 30 Jan 2023 19:21:53 -0500
X-MC-Unique: TA-EGeM3OsyLZdG0npOdWQ-1
Received: by mail-ed1-f69.google.com with SMTP id h18-20020a05640250d200b0049e0e9382c2so9343009edb.13
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 16:21:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JtIojjqPJfWA8r7fIaLtZliC5rFkK+e5G2vXAK457RY=;
        b=iiiz4hTLsQ51aS7cFS7AgoRrhfk4qjDKu1cYeaCNY4p7mydAEoJvVyYqzvguxXDNy6
         4ia6RUsklrhCDODmClHerXTjjN+k6cWcD2ke0vjpC84U5ZubDyhjHtPDw2CDQStPOhBe
         BBn2swZ2mBPDwLu7TrtQ1DCL6sTgHWaDk3fqlpzD0yC0jW7QzPxsJvcHS22vQBt1to0g
         c+Apg0UFtnHIW69gFZoF/lBbZ2fqOiqyFIcXXGwumuu7dm9w2x8w+UxB5yWOC5a0zaWT
         1fLHpIo4FhkJ+GOwlUyVziB3mW3t1D81KNUaWyuVRT2GpJn50kpc72eeEDJGOT9dv5lC
         1pUQ==
X-Gm-Message-State: AO0yUKXS/WRlbPMx6browqMMSuScYTXPs5nu6YLVjErQwIqJgoDLnmuM
        3rQTBYl6wUnY8kyXLHxSYeIDCwKe447FNROBi/SHpFxoev9CtqReE7XS01FOtxZmUgvR+Een6A0
        TWv637kWukWdwGB6Oqg59l4wX3WRNcO7w
X-Received: by 2002:a17:906:7244:b0:882:c2dd:f29e with SMTP id n4-20020a170906724400b00882c2ddf29emr2851366ejk.268.1675124512918;
        Mon, 30 Jan 2023 16:21:52 -0800 (PST)
X-Google-Smtp-Source: AK7set8sI1WOq/7rZuTLGLFYup/sgDq4GGKe++h1jLu8Hur5lmbBidWwSjTrBx8GwuxZkzmjjc+VOm+4J8sCR678RsU=
X-Received: by 2002:a17:906:7244:b0:882:c2dd:f29e with SMTP id
 n4-20020a170906724400b00882c2ddf29emr2851357ejk.268.1675124512770; Mon, 30
 Jan 2023 16:21:52 -0800 (PST)
MIME-Version: 1.0
References: <20230125102923.135465-1-miquel.raynal@bootlin.com>
 <CAK-6q+jN1bnP1FdneGrfDJuw3r3b=depEdEP49g_t3PKQ-F=Lw@mail.gmail.com>
 <CAK-6q+hoquVswZTm+juLasQzUJpGdO+aQ7Q3PCRRwYagge5dTw@mail.gmail.com> <20230130105508.38a25780@xps-13>
In-Reply-To: <20230130105508.38a25780@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 30 Jan 2023 19:21:41 -0500
Message-ID: <CAK-6q+gqQgFxqBUAhHDMaWv9VfuKa=bCVee_oSLQeVtk_G8=ow@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 0/2] ieee802154: Beaconing support
To:     Miquel Raynal <miquel.raynal@bootlin.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jan 30, 2023 at 4:55 AM Miquel Raynal <miquel.raynal@bootlin.com> w=
rote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Thu, 26 Jan 2023 20:48:02 -0500:
>
> > Hi,
> >
> > On Thu, Jan 26, 2023 at 8:45 PM Alexander Aring <aahringo@redhat.com> w=
rote:
> > >
> > > Hi,
> > >
> > > On Wed, Jan 25, 2023 at 5:31 AM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote:
> > > >
> > > > Scanning being now supported, we can eg. play with hwsim to verify
> > > > everything works as soon as this series including beaconing support=
 gets
> > > > merged.
> > > >
> > > > Thanks,
> > > > Miqu=C3=A8l
> > > >
> > > > Changes in v2:
> > > > * Clearly state in the commit log llsec is not supported yet.
> > > > * Do not use mlme transmission helpers because we don't really need=
 to
> > > >   stop the queue when sending a beacon, as we don't expect any feed=
back
> > > >   from the PHY nor from the peers. However, we don't want to go thr=
ough
> > > >   the whole net stack either, so we bypass it calling the subif hel=
per
> > > >   directly.
> > > >
> >
> > moment, we use the mlme helpers to stop tx
>
> No, we no longer use the mlme helpers to stop tx when sending beacons
> (but true MLME transmissions, we ack handling and return codes will be
> used for other purposes).
>

then we run into an issue overwriting the framebuffer while the normal
transmit path is active?

> > but we use the
> > ieee802154_subif_start_xmit() because of the possibility to invoke
> > current 802.15.4 hooks like llsec? That's how I understand it.
>
> We go through llsec (see ieee802154_subif_start_xmit() implementation)
> when we send data or beacons. When we send beacons, for now, we just
> discard the llsec logic. This needs of course to be improved. We will
> probably need some llsec handling in the mlme case as well in the near
> future.
>

i agree, thanks.

- Alex

