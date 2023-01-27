Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8111D67DB43
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 02:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbjA0Bac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 20:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjA0Baa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 20:30:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9728A59988
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 17:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674782979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XtFX0cAZl2U0Cf9R2KfMcgQizSlN8XjxsP0x4+jzJs4=;
        b=P/rG0Oo4lJE+PfYE6BSSLLFW0epdov/6lb9GLt4W8RX2AJYHU04Ims3sUoVlw27i1GOZPW
        72eaZKqHFllnkidz/mSftRJSsgUZ1kQQ2hg2AJaxKg//eCb25LiraK+YY1nQOyDzXr6a6c
        Cb+reS6ZrVSkwEvGDALkXWy7MZX9ZJA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-345-FKrpmSAXPAWO9_kWuZjjJQ-1; Thu, 26 Jan 2023 20:29:38 -0500
X-MC-Unique: FKrpmSAXPAWO9_kWuZjjJQ-1
Received: by mail-ed1-f69.google.com with SMTP id f11-20020a056402354b00b0049e18f0076dso2535037edd.15
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 17:29:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XtFX0cAZl2U0Cf9R2KfMcgQizSlN8XjxsP0x4+jzJs4=;
        b=8PkDTgN87rYpNS+OqqTh9qPGf2g0MdUQZitq/l/j6b+HcOMc17S6xYqaTE22sMHBFP
         JrCMvxEu0q1NJ7SHr93ZgTpUZZpTZ+tqXhqVDiRJa2C5OUCzCOoMtqbyKHbAdpk6NAq2
         8U+QXDXD/vve75GrRt2rtjnoWexLNTWvoH+nYHoHxOXbU+SGZ8G9Puwtgkz4JPUjoZNX
         XjM4IR2gtCPyhYjdum31C54aDWfh8zC+p9Y9SY1zRRZNds2akDMCCsVCOcOxSRjdgiyL
         h563nby0DS0/iHBIGjECTcL43PJa+IzqOerPXim6MGAKILWHAXrM+BMEsPAIOkA5wVPr
         uXqg==
X-Gm-Message-State: AFqh2koXk4aFp3wrEhGDbNLcUGWaKumbjHlzDpcxQ6ctQShDYCCV3zDB
        t0sBa4DXv/xcSYOoTXGmSfPwVkxKyjrfI80wCVoPWbj/fgKD+twWTI6i+6xFR5SgKMfdj06SbbE
        wPzOmqCO+RoN+w8QNgyyHEq/ueP2ucy75
X-Received: by 2002:a05:6402:221a:b0:49d:836e:21f9 with SMTP id cq26-20020a056402221a00b0049d836e21f9mr6230188edb.36.1674782977078;
        Thu, 26 Jan 2023 17:29:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsQ6AiyzFo2NkYnvxuHz//Uy/6NG+60HeMrHvs6kxEJUyYVvCcoM3BpoYotduQq+03M9m1VvKYRAfY5mSEKxFU=
X-Received: by 2002:a05:6402:221a:b0:49d:836e:21f9 with SMTP id
 cq26-20020a056402221a00b0049d836e21f9mr6230178edb.36.1674782976877; Thu, 26
 Jan 2023 17:29:36 -0800 (PST)
MIME-Version: 1.0
References: <20230106113129.694750-1-miquel.raynal@bootlin.com>
 <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com>
 <20230118102058.3b1f275b@xps-13> <CAK-6q+gwP8P--5e9HKt2iPhjeefMXrXUVy-G+szGdFXZvgYKvg@mail.gmail.com>
 <CAK-6q+gn7W9x2+ihSC41RzkhmBn1E44pKtJFHgqRdd8aBpLrVQ@mail.gmail.com>
 <20230124110814.6096ecbe@xps-13> <CAB_54W69KcM0UJjf8py-VyRXx2iEUvcAKspXiAkykkQoF6ccDA@mail.gmail.com>
 <20230125105653.44e9498f@xps-13>
In-Reply-To: <20230125105653.44e9498f@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 26 Jan 2023 20:29:25 -0500
Message-ID: <CAK-6q+irhYroxV_P5ORtO9Ui9-Bs=SNS+vO5bZ7_X-geab+XrA@mail.gmail.com>
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Beaconing support
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Jan 25, 2023 at 5:00 AM Miquel Raynal <miquel.raynal@bootlin.com> w=
rote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Tue, 24 Jan 2023 21:31:33 -0500:
>
> > Hi,
> >
> > On Tue, Jan 24, 2023 at 5:08 AM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote:
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Mon, 23 Jan 2023 09:02:48 -0500:
> > >
> > > > Hi,
> > > >
> > > > On Mon, Jan 23, 2023 at 9:01 AM Alexander Aring <aahringo@redhat.co=
m> wrote:
> > > > >
> > > > > Hi,
> > > > >
> > > > > On Wed, Jan 18, 2023 at 4:21 AM Miquel Raynal <miquel.raynal@boot=
lin.com> wrote:
> > > > > >
> > > > > > Hi Alexander,
> > > > > >
> > > > > > aahringo@redhat.com wrote on Sun, 15 Jan 2023 20:54:02 -0500:
> > > > > >
> > > > > > > Hi,
> > > > > > >
> > > > > > > On Fri, Jan 6, 2023 at 6:33 AM Miquel Raynal <miquel.raynal@b=
ootlin.com> wrote:
> > > > > > > >
> > > > > > > > Scanning being now supported, we can eg. play with hwsim to=
 verify
> > > > > > > > everything works as soon as this series including beaconing=
 support gets
> > > > > > > > merged.
> > > > > > > >
> > > > > > >
> > > > > > > I am not sure if a beacon send should be handled by an mlme h=
elper
> > > > > > > handling as this is a different use-case and the user does no=
t trigger
> > > > > > > an mac command and is waiting for some reply and a more compl=
ex
> > > > > > > handling could be involved. There is also no need for hotpath=
 xmit
> > > > > > > handling is disabled during this time. It is just an async me=
ssaging
> > > > > > > in some interval and just "try" to send it and don't care if =
it fails,
> > > > > > > or? For mac802154 therefore I think we should use the dev_que=
ue_xmit()
> > > > > > > function to queue it up to send it through the hotpath?
> > > > > > >
> > > > > > > I can ack those patches, it will work as well. But I think we=
 should
> > > > > > > switch at some point to dev_queue_xmit(). It should be simple=
 to
> > > > > > > switch it. Just want to mention there is a difference which w=
ill be
> > > > > > > there in mac-cmds like association.
> > > > > >
> > > > > > I see what you mean. That's indeed true, we might just switch t=
o
> > > > > > a less constrained transmit path.
> > > > > >
> > > > >
> > > > > I would define the difference in bypass qdisc or not. Whereas the
> > > > > qdisc can drop or delay transmitting... For me, the qdisc is curr=
ently
> > > > > in a "works for now" state.
> > > >
> > > > probably also bypass other hooks like tc, etc. :-/ Not sure if we w=
ant that.
> > >
> > > Actually, IIUC, we no longer want to go through the entire net stack.
> > > We still want to bypass it but without stopping/flushing the full
> > > queue like with an mlme transmission, so what about using
> > > ieee802154_subif_start_xmit() instead of dev_queue_xmit()? I think it
> > > is more appropriate.
> >
> > I do not understand, what do we currently do with mlme ops via the
> > ieee802154_subif_start_xmit() function, or? So we bypass everything
> > from dev_queue_xmit() until do_xmit() netdev callback.
>
> Yes, that's the plan. We don't want any of the net stack features when
> sending beacons.
>
> > I think it is fine, also I think "mostly" only dataframes should go
> > through dev_queue_xmit(). With a HardMAC transceiver we would have
> > control about "mostly" other frames than data either. So we should do
> > everything with mlme-ops do what the spec says (to match up with
> > HardMAC behaviour?) and don't allow common net hooks/etc. to change
> > this behaviour?
>
> To summarize:
> - Data frames -> should go through dev_queue_xmit()

there are exceptions... e.g. AF_PACKET raw sockets can build whatever
it wants (but it will probably not being supported by HardMAC
transceivers) and send it out. There is no real control about it. So
mostly I would agree here.

> - MLME ops with feedback constraints -> should go through the slow MLME
>   path, so ieee802154_mlme_tx*()

yea.

> - MLME ops without feedback constraints like beacons -> should go
>   through the hot path, but not through the whole net stack, so
>   ieee802154_subif_start_xmit()
>

it will bypass the qdisc handling (+ some other things which are
around there). The current difference is what I see llsec handling and
other things which might be around there? It depends if other
"MLME-ops" need to be e.g. encrypted or not.

> Right now only data frames have security support, I propose we merge
> the initial support like that. Right now I am focused on UWB support
> (coming next, after the whole active scan/association additions), and
> in a second time we would be interested in llsec support for MLME ops.
>

that's fine.

> Does that sounds like a plan? If yes, I'll send a v2 with the right
> transmit helper used.
>

yes.

> Thanks,
> Miqu=C3=A8l
>
> NB: Perhaps a prerequisites of bringing security to the MLME ops would
> be to have wpan-tools updated (it looks like the support was never
> merged?) as well as a simple example how to use it on linux-wpan.org.
>

this is correct. It is still in a branch, I am fine to merge it in
this state although it's not really practical to use right now.

- Alex

