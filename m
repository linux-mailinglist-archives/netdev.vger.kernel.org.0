Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6B45877FD
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 09:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbiHBHil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 03:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbiHBHij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 03:38:39 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1656CB86E;
        Tue,  2 Aug 2022 00:38:34 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id E4E7A30B294F;
        Tue,  2 Aug 2022 09:38:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=qMHRI
        qP5hY9O9b/xkCgt4bDck43g/6SvtkDTMLkcfYA=; b=XMnqdhxlHMHU2ffmRKnm0
        UH8m2Udz/jXZ0tdKq0SO6Yalq8AdzRX4kKKclhN8L6frxLltJpSGVeb/hT1ac1O3
        uEQ+5j32Vr1JNY1cqYWoNCTE9e5yXiWtYtvptepPEUlsTZ9ZIsom2ymTpaNmZ4CN
        EdKzsrTCw9TvM1Id5+ew/1sQIdOiU0Ja56m1KCqdM29zu9X/zdydS9hCX/rz/u7m
        LuwFNTtTkinFYYjVEoXB+fR6JXlaMWjnDxPjDybF2L+GKCtT1sKrPJOMaFZ5vqmb
        kQ8Wkba6qYFvJu/AJ8oKPegegQ4rYLalQWvVg6QXq2LUYiyCphWuYaW8lfFEELMh
        Q==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id D5FE330ADE4B;
        Tue,  2 Aug 2022 09:38:01 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 2727c1n4011125;
        Tue, 2 Aug 2022 09:38:01 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 2727c10Z011124;
        Tue, 2 Aug 2022 09:38:01 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Vincent Mailhol <vincent.mailhol@gmail.com>
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error CAN frames
Date:   Tue, 2 Aug 2022 09:37:54 +0200
User-Agent: KMail/1.9.10
Cc:     Matej Vasilevski <matej.vasilevski@seznam.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
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
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz> <20220801184656.702930-2-matej.vasilevski@seznam.cz> <CAMZ6RqJEBV=1iUN3dH-ZZVujOFEoJ-U1FaJ5OOJzw+aM_mkUvA@mail.gmail.com>
In-Reply-To: <CAMZ6RqJEBV=1iUN3dH-ZZVujOFEoJ-U1FaJ5OOJzw+aM_mkUvA@mail.gmail.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Message-Id: <202208020937.54675.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vincent,

thanks much for review. I am adding some notices to Tx timestamps
after your comments

On Tuesday 02 of August 2022 05:43:38 Vincent Mailhol wrote:
> I just send a series last week which a significant amount of changes
> for CAN timestamping tree-wide:
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/co=
mm
>it/?id=3D12a18d79dc14c80b358dbd26461614b97f2ea4a6
>
> I suggest you have a look at this series and harmonize it with the new
> features (e.g. Hardware TX=E2=80=AFtimestamp).
>
> On Tue. 2 Aug. 2022 at 03:52, Matej Vasilevski
=2E..
> > +static int ctucan_hwtstamp_set(struct net_device *dev, struct ifreq
> > *ifr) +{
> > +       struct ctucan_priv *priv =3D netdev_priv(dev);
> > +       struct hwtstamp_config cfg;
> > +
> > +       if (!priv->timestamp_possible)
> > +               return -EOPNOTSUPP;
> > +
> > +       if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> > +               return -EFAULT;
> > +
> > +       if (cfg.flags)
> > +               return -EINVAL;
> > +
> > +       if (cfg.tx_type !=3D HWTSTAMP_TX_OFF)
> > +               return -ERANGE;
>
> I have a great news: your driver now also support hardware TX timestamps:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/co=
mm
>it/?id=3D8bdd1112edcd3edce2843e03826204a84a61042d
>
> > +
> > +       switch (cfg.rx_filter) {
> > +       case HWTSTAMP_FILTER_NONE:
> > +               priv->timestamp_enabled =3D false;
=2E..
> > +
> > +       cfg.flags =3D 0;
> > +       cfg.tx_type =3D HWTSTAMP_TX_OFF;
>
> Hardware TX timestamps are now supported (c.f. supra).
>
> > +       cfg.rx_filter =3D priv->timestamp_enabled ? HWTSTAMP_FILTER_ALL=
 :
> > HWTSTAMP_FILTER_NONE; +       return copy_to_user(ifr->ifr_data, &cfg,
> > sizeof(cfg)) ? -EFAULT : 0; +}
> > +
> > +static int ctucan_ioctl(struct net_device *dev, struct ifreq *ifr, int
> > cmd)
>
> Please consider using the generic function can_eth_ioctl_hwts()
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/co=
mm
>it/?id=3D90f942c5a6d775bad1be33ba214755314105da4a
>
> > +{
=2E..
> > +       info->so_timestamping |=3D SOF_TIMESTAMPING_RX_HARDWARE |
> > +                                SOF_TIMESTAMPING_RAW_HARDWARE;
> > +       info->tx_types =3D BIT(HWTSTAMP_TX_OFF);
>
> Hardware TX timestamps are now supported (c.f. supra).
>
> > +       info->rx_filters =3D BIT(HWTSTAMP_FILTER_NONE) |
> > +                          BIT(HWTSTAMP_FILTER_ALL);


I am not sure if it is good idea to report support for hardware
TX timestamps by all drivers. Precise hardware Tx timestamps
are important for some CAN applications but they require to be
exactly/properly aligned with Rx timestamps.

Only some CAN (FD) controllers really support that feature.
=46or M-CAN and some others it is realized as another event
=46IFO in addition to Tx and Rx FIFOs.

=46or CTU CAN FD, we have decided that we do not complicate design
and driver by separate events channel. We have configurable
and possibly large Rx FIFO depth which is logical to use for
analyzer mode and we can use loopback to receive own messages
timestamped same way as external received ones.

See 2.14.1 Loopback mode
SETTINGS[ILBP]=3D1.

in the datasheet

  http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/doc/Datasheet.pdf

There is still missing information which frames are received
locally and from which buffer they are in the Rx message format,
but we plan to add that into VHDL design.

In such case, we can switch driver mode and release Tx buffers
only after corresponding message is read from Rx FIFO and
fill exact finegrain (10 ns in our current design) timestamps
to the echo skb. The order of received messages will be seen
exactly mathing the wire order for both transmitted and received
messages then. Which I consider as proper solution for the
most applications including CAN bus analyzers.

So I consider to report HW Tx timestamps for cases where exact,
precise timestamping is not available for loopback messages
as problematic because you cannot distinguish if you talk
with driver and HW with real/precise timestamps support
or only dummy implementation to make some tools happy.

=20
Best wishes and thanks for consideration about altrenatives,

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

