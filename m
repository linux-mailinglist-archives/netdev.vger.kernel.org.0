Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96155ABF50
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 16:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiICOUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 10:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiICOUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 10:20:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516245D0D3
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 07:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662214839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MHHb9r0sbrRKH/m8uZjeeKsiFWFQ+NOalW8jzj7qfIc=;
        b=M0Usdd8eCPdiOJw7/9yjVKcQyDA2DK/374Idg+Tkqnm4Bohv/jgyfreMq/C1iD/pn4ybxO
        kzdBLs8HIvPDnn4dtsVamE0R522Um1SGjL5V0+J0OwYQvrR9t3+Ic7MSS1SAwZ1XxkYvD3
        9pKqnfycODJRUp7BS3ZCexcf+bYdYKk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-587-5w4DrJqLM3uFcTRmEyTriA-1; Sat, 03 Sep 2022 10:20:36 -0400
X-MC-Unique: 5w4DrJqLM3uFcTRmEyTriA-1
Received: by mail-qk1-f200.google.com with SMTP id n15-20020a05620a294f00b006b5768a0ed0so4070355qkp.7
        for <netdev@vger.kernel.org>; Sat, 03 Sep 2022 07:20:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=MHHb9r0sbrRKH/m8uZjeeKsiFWFQ+NOalW8jzj7qfIc=;
        b=zbUnTA6n+pH+Ns0qTxUZNDhx05HLViqEa0tnUfGpumW/WlattRsmsuI3IYRSsiCNhm
         soUszncwg4pIVRFEgTJzTVTIFHgXXMRC/gv9w81lfHSG2hiXBF4qxzLyq5q0rm/N97+V
         755OnMHfSy2Oqz6aBK0MOUjBdJ8gU6fwW3C13XNI1oQdEjJRLKu6Rv0Y2GtLos24MGqJ
         Z2bDT2ymFDy0AHlxRhYzpZF7ikx6OMeeCPuYZi3wpuKY4I6Ca8u3uxd0LwE+xrNK5KPT
         RPMyvcvWrxCFN54/YHHx0484iHEK3I7KfETbezAOm1XJY/O6JpNLsiUq0EIynQnLFIYA
         PTZw==
X-Gm-Message-State: ACgBeo2YUdBFeJobGMSyd1zq+cUeMk5qnF0cjpOAVRv30ztQWEkMipAR
        oOH6IkJwhdx4lPAindH4N7tbIkVxp2KVJlhhIE4S67taAPpkWb31uhQgDXGbS+bvJbLzZCL/jpf
        0F+Z2Wpt31J0hyDgcJjA3rMkjDnyXkMal
X-Received: by 2002:a05:6214:2581:b0:499:91e:2fb with SMTP id fq1-20020a056214258100b00499091e02fbmr24202831qvb.59.1662214836120;
        Sat, 03 Sep 2022 07:20:36 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7YguVSerMmsxLYr5u7bpg1KNMUj3aYUbLmVd5GkvhjjaS0yRDDeK+dAn6pHZ9gt4F+O4PUBvVlBWQD3a1ipRA=
X-Received: by 2002:a05:6214:2581:b0:499:91e:2fb with SMTP id
 fq1-20020a056214258100b00499091e02fbmr24202800qvb.59.1662214835855; Sat, 03
 Sep 2022 07:20:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220819191109.0e639918@xps-13> <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
 <20220823182950.1c722e13@xps-13> <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
 <20220824122058.1c46e09a@xps-13> <CAK-6q+gjgQ1BF-QrT01JWh+2b3oL3RU+SoxUf5t7h3Hc6R8pcg@mail.gmail.com>
 <20220824152648.4bfb9a89@xps-13> <CAK-6q+itA0C4zPAq5XGKXgCHW5znSFeB-YDMp3uB9W-kLV6WaA@mail.gmail.com>
 <20220825145831.1105cb54@xps-13> <CAK-6q+j3LMoSe_7u0WqhowdPV9KM-6g0z-+OmSumJXCZfo0CAw@mail.gmail.com>
 <20220826095408.706438c2@xps-13> <CAK-6q+gxD0TkXzUVTOiR4-DXwJrFUHKgvccOqF5QMGRjfZQwvw@mail.gmail.com>
 <20220829100214.3c6dad63@xps-13> <CAK-6q+gJwm0bhHgMVBF_pmjD9zSrxxHvNGdTrTm0fG-hAmSaUQ@mail.gmail.com>
 <20220831173903.1a980653@xps-13> <20220901020918.2a15a8f9@xps-13>
 <20220901150917.5246c2d0@xps-13> <CAK-6q+g1Gnew=zWsnW=HAcLTqFYHF+P94Q+Ywh7Rir8J8cgCgw@mail.gmail.com>
 <20220903020829.67db0af8@xps-13>
In-Reply-To: <20220903020829.67db0af8@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sat, 3 Sep 2022 10:20:24 -0400
Message-ID: <CAK-6q+hO1i=xvXx3wHo658ph93FwuVs_ssjG0=jnphEe8a+gxw@mail.gmail.com>
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
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Sep 2, 2022 at 8:08 PM Miquel Raynal <miquel.raynal@bootlin.com> wr=
ote:
...
> >
> > I am sorry, I never looked into Zephyr for reasons... Do they not have
> > something like /proc/interrupts look if you see a counter for your
> > 802.15.4 transceiver?
> >
> > > Also, can you please clarify when are we talking about software and
> > > when about hardware filters.
> > >
> >
> > Hardware filter is currently e.g. promiscuous mode on or off setting.
> > Software filtering is depending which receive path the frame is going
> > and which hardware filter is present which then acts like actually
> > with hardware filtering.
> > I am not sure if this answers this question?
>
> I think my understand gets clearer now that I've digged into Zephyr's
> ieee802154 layer and in the at86rf230 datasheet.
>

okay, I think for zephyr questions you are here on the wrong mailinglist.

> I will answer the previous e-mail but just for not I wanted to add that
> I managed to get Zephyr working, I had to mess around in the code a
> little bit and actually I discovered a net command which is necessary
> to use in order to turn the iface up, whatever.
>

aha.

> So I was playing with the atusb devices and I _think_ I've found a
> firmware bug or a hardware bug which is going to be problematic. In

the firmware is open source, I think it's fine to send patches here (I
did it as well once for do a quick hack to port it to rzusb) the atusb
is "mostly" at the point that they can do open hardware from the
qi-hardware organization.

> iface.c, when creating the interface, if you set the hardware filters
> (set_panid/short/ext_addr()) there is no way you will be able to get a
> fully transparent promiscuous mode. I am not saying that the whole

What is a transparent promiscuous mode?

> promiscuous mode does not work anymore, I don't really know. What I was
> interested in were the acks, and getting them is a real pain. At least,
> enabling the promiscuous mode after setting the hw filters will lead to
> the acks being dropped immediately while if the promiscuous mode is
> enabled first (like on monitor interfaces) the acks are correctly
> forwarded by the PHY.

If we would not disable AACK handling (means we receive a frame with
ack requested bit set we send a ack back) we would ack every frame it
receives (speaking on at86rf233).

>
> While looking at the history of the drivers, I realized that the
> TX_ARET mode was not supported by the firmware in 2015 (that's what you

There exists ARET and AACK, both are mac mechanisms which must be
offloaded on the hardware. Note that those only do "something" if the
ack request bit in the frame is set.

ARET will retransmit if no ack is received after some while, etc.
mostly coupled with CSMA/CA handling. We cannot guarantee such timings
on the Linux layer. btw: mac80211 can also not handle acks on the
software layer, it must be offloaded.

AACK will send a back if a frame with ack request bit was received.

> say in a commit) I have seen no further updates about it so I guess
> it's still not available. I don't see any other way to know if a
> frame's ack has been received or not reliably.

You implemented it for the at86rf230 driver (the spi one which is what
also atusb uses). You implemented the

ctx->trac =3D IEEE802154_NO_ACK;

which signals the upper layer that if the ack request bit is set, that
there was no ack.

But yea, there is a missing feature for atusb yet which requires
firmware changes as well. Btw: I can imagine that hwsim "fakes" such
offload behaviours.

>
> Do you think I can just ignore the acks during an association in
> mac802154?

No, even we should WARN_ON ack frames in states we don't expect them
because they must be offloaded on hardware.

I am not sure if I am following what is wrong with the trac register
and NO_ACK, this is the information if we got an ack or not. Do you
need to turn off address filters while "an association"?

Another idea how to get them? The Atmel datasheet states the
> following, which is not encouraging:
>
>         If (Destination Addressing Mode =3D 0 OR 1) AND (Source
>         Addressing Mode =3D 0) no IRQ_5 (AMI) is generated, refer to
>         Section 8.1.2.2 =E2=80=9CFrame Control Field (FCF)=E2=80=9D on pa=
ge 80. This
>         effectively causes all acknowledgement frames not to be
>         announced, which otherwise always pass the fil- ter, regardless
>         of whether they are intended for this device or not.

I hope the answers above are helpful because I don't know how this can
be useful here.

- Alex

