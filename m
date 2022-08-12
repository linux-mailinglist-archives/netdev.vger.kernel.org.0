Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7388B5912DB
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238778AbiHLPVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238884AbiHLPUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:20:39 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB21525C8;
        Fri, 12 Aug 2022 08:20:36 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id AB6CD30B2964;
        Fri, 12 Aug 2022 17:20:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=stN/v
        wM7kI+UEiBzIZ+KIv/wNPXPdvI3+HFyWkYU92g=; b=aN8BXTJxd8nshGGjXntzv
        5PkwpzkwY8R+zWn5mi7SYs+N5cxTBvqAIA0S4zY3wRL/TnnZ7ZJdYXugzoguFv6O
        kvq379zWRUnWb4xFMEVRDW8y7l4bdRLuPoJQtdQr2jUvE0UN948ey3ccUB1Xb27B
        ZgEEOoRNNVTDgr5ZqPx9iyQBfohPlXpHU+lfm2175/IHOP+BAjb/Zc2QnQmtRgA9
        yk2IwI4Q4WaJOOyfsO55yXpXSU/GUDGncK4x8HTLCn98fd4DYuaF1Xgl41uFXP/R
        qTBGFQhKEbisFuZXOG4J0hpunkN1cBD+8dnUMnkvsEoDXk1acv5EcyWs0PWQq/w+
        g==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 550F330B294A;
        Fri, 12 Aug 2022 17:20:03 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 27CFK3KT028000;
        Fri, 12 Aug 2022 17:20:03 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 27CFK2mK027999;
        Fri, 12 Aug 2022 17:20:02 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Vincent Mailhol <vincent.mailhol@gmail.com>,
        Matej Vasilevski <matej.vasilevski@seznam.cz>,
        Pavel Hronek <hronepa1@fel.cvut.cz>
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error CAN frames
Date:   Fri, 12 Aug 2022 17:19:58 +0200
User-Agent: KMail/1.9.10
Cc:     Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Jiri Novak <jnovak@fel.cvut.cz>,
        Oliver Hartkopp <socketcan@hartkopp.net>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz> <202208020937.54675.pisa@cmp.felk.cvut.cz> <CAMZ6Rq+EehdX8Kkg_430tzbE072Fm0PXbzgSqBzeDygTZqzBLA@mail.gmail.com>
In-Reply-To: <CAMZ6Rq+EehdX8Kkg_430tzbE072Fm0PXbzgSqBzeDygTZqzBLA@mail.gmail.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Message-Id: <202208121719.58328.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vincent,

On Friday 12 of August 2022 16:35:30 Vincent Mailhol wrote:
> Hi Pavel,
>
> On Tue. 2 Aug. 2022 at 16:38, Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
> > Hello Vincent,
> >
> > thanks much for review. I am adding some notices to Tx timestamps
> > after your comments
> >
> > On Tuesday 02 of August 2022 05:43:38 Vincent Mailhol wrote:
> > > I just send a series last week which a significant amount of changes
> > > for CAN timestamping tree-wide:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.gi=
t/
> > >comm it/?id=3D12a18d79dc14c80b358dbd26461614b97f2ea4a6
> > >
> > > I suggest you have a look at this series and harmonize it with the new
> > > features (e.g. Hardware TX=E2=80=AFtimestamp).
> > >
> > > On Tue. 2 Aug. 2022 at 03:52, Matej Vasilevski
> >
> > ...
> >
> > > > +static int ctucan_hwtstamp_set(struct net_device *dev, struct ifreq
> > > > *ifr) +{
> > > > +       struct ctucan_priv *priv =3D netdev_priv(dev);
> > > > +       struct hwtstamp_config cfg;
> > > > +
> > > > +       if (!priv->timestamp_possible)
> > > > +               return -EOPNOTSUPP;
> > > > +
> > > > +       if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> > > > +               return -EFAULT;
> > > > +
> > > > +       if (cfg.flags)
> > > > +               return -EINVAL;
> > > > +
> > > > +       if (cfg.tx_type !=3D HWTSTAMP_TX_OFF)
> > > > +               return -ERANGE;
> > >
> > > I have a great news: your driver now also support hardware TX
> > > timestamps:
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.gi=
t/
> > >comm it/?id=3D8bdd1112edcd3edce2843e03826204a84a61042d
> > >
> > > > +
> > > > +       switch (cfg.rx_filter) {
> > > > +       case HWTSTAMP_FILTER_NONE:
> > > > +               priv->timestamp_enabled =3D false;
> >
> > ...
> >
> > > > +
> > > > +       cfg.flags =3D 0;
> > > > +       cfg.tx_type =3D HWTSTAMP_TX_OFF;
> > >
> > > Hardware TX timestamps are now supported (c.f. supra).
> > >
> > > > +       cfg.rx_filter =3D priv->timestamp_enabled ? HWTSTAMP_FILTER=
_ALL
> > > > : HWTSTAMP_FILTER_NONE; +       return copy_to_user(ifr->ifr_data,
> > > > &cfg, sizeof(cfg)) ? -EFAULT : 0; +}
> > > > +
> > > > +static int ctucan_ioctl(struct net_device *dev, struct ifreq *ifr,
> > > > int cmd)
> > >
> > > Please consider using the generic function can_eth_ioctl_hwts()
> > > https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.gi=
t/
> > >comm it/?id=3D90f942c5a6d775bad1be33ba214755314105da4a
> > >
> > > > +{
> >
> > ...
> >
> > > > +       info->so_timestamping |=3D SOF_TIMESTAMPING_RX_HARDWARE |
> > > > +                                SOF_TIMESTAMPING_RAW_HARDWARE;
> > > > +       info->tx_types =3D BIT(HWTSTAMP_TX_OFF);
> > >
> > > Hardware TX timestamps are now supported (c.f. supra).
> > >
> > > > +       info->rx_filters =3D BIT(HWTSTAMP_FILTER_NONE) |
> > > > +                          BIT(HWTSTAMP_FILTER_ALL);
> >
> > I am not sure if it is good idea to report support for hardware
> > TX timestamps by all drivers. Precise hardware Tx timestamps
> > are important for some CAN applications but they require to be
> > exactly/properly aligned with Rx timestamps.
> >
> > Only some CAN (FD) controllers really support that feature.
> > For M-CAN and some others it is realized as another event
> > FIFO in addition to Tx and Rx FIFOs.
> >
> > For CTU CAN FD, we have decided that we do not complicate design
> > and driver by separate events channel. We have configurable
> > and possibly large Rx FIFO depth which is logical to use for
> > analyzer mode and we can use loopback to receive own messages
> > timestamped same way as external received ones.
> >
> > See 2.14.1 Loopback mode
> > SETTINGS[ILBP]=3D1.
> >
> > in the datasheet
> >
> >   http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/doc/Datasheet.pdf
> >
> > There is still missing information which frames are received
> > locally and from which buffer they are in the Rx message format,
> > but we plan to add that into VHDL design.
> >
> > In such case, we can switch driver mode and release Tx buffers
> > only after corresponding message is read from Rx FIFO and
> > fill exact finegrain (10 ns in our current design) timestamps
> > to the echo skb. The order of received messages will be seen
> > exactly mathing the wire order for both transmitted and received
> > messages then. Which I consider as proper solution for the
> > most applications including CAN bus analyzers.
> >
> > So I consider to report HW Tx timestamps for cases where exact,
> > precise timestamping is not available for loopback messages
> > as problematic because you cannot distinguish if you talk
> > with driver and HW with real/precise timestamps support
> > or only dummy implementation to make some tools happy.
>
> Thank you for the explanation. I did not know about the nuance about
> those different hardware timestamps.
>
> So if I understand correctly, your hardware can deliver two types of
> hardware timestamps:
>
>   - The "real" one: fine grained with 10 ns precision when the frame
> is actually sent
>
>   - The "dummy" one: less precise timestamp generated when there is an
> event on the device=E2=80=99s Rx or Tx FIFO.
>
> Is this correct?
>
> Are the "real" and the "dummy" timestamps synced on the same quartz?
>
> What is the precision of the "dummy" timestamp? If it in the order of
> magnitude of 10=C2=B5s? For many use cases, this is enough. 10=C2=B5s rep=
resents
> roughly a dozen of time quata (more or less depending on the bitrate
> and its prescaler).
> Actually, I never saw hardware with a timestamp precision below 1=C2=B5s
> (not saying those don't exist, just that I never encountered them).
>
> I am not against what you propose. But my suggestion would be rather
> to report both TX=E2=80=AFand RX timestamps and just document the precisi=
on
> (i.e. TX has precision with an order of magnitude of 10=C2=B5s and RX has
> precision of 10 ns).
>
> At the end, I=E2=80=AFlet you decide what works the best for you. Just ke=
ep in
> mind that the micro second precision is already a great achievement
> and not many people need the 10 nano second (especially for CAN).
>
> P.S.: I am on holiday, my answers might be delayed :)

I am leaving off the Internet for next week as well now...

My discussion has been reaction to your information about your
CTU CAN FD change, but may it be I have lost the track.

> > On Tuesday 02 of August 2022 05:43:38 Vincent Mailhol wrote:
> > > I have a great news: your driver now also support hardware TX
> > > timestamps:

Our actual/mainline driver actually does not support neither Rx nor Tx
timestamps. Matej Vasilevski has prepared and sent to review patches
adding Rx timestamping (10 ns resolution for our actual designs).
He has rebased his changes above yours... CTU CAN FD hardware
supports such timestamping for many years... probably preceding 2.0
IP core version.

But even when this patch is clean up and accepted into mainline,
CTU CAN FD driver will not support hardware Tx timestams, may it
be software ones are implemented in generic CAN echo code, not checked
now... So if your change add report of HW Tx stamps then it would be
problem to distinguish situation when we implement hardware Tx timestamps.

The rest of the previous text is how to implement precise Tx timestamps
on other and our controller design. We do not have separate queue
to report Tx timestamps for successfully sent frames. But we can
enable copy of sent Tx frames to Rx FIFO so there is a way how
to achieve that. But there is still minor design detail that
we need to mark such frames as echo of local Tx in Rx FIFO queue
and ideally add there even number of the Tx buffer or even some
user provided information from some Tx buffer filed to distinguish
that such frames should be reported through echo and ensure that
they are not reported to that client who has sent them etc...
But there are our implementation details...

But what worries me, is your statement that HW Tx timestamps
are already reported as available on CTU CAN FD by your patch,
if I understood your reply well.

Best wishes,

                Pavel
=2D-=20
                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    RISC-V education: https://comparch.edu.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

