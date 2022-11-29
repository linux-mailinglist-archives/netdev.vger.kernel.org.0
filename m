Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1D163BB2E
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiK2IDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiK2IDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:03:54 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50EA2EF39;
        Tue, 29 Nov 2022 00:03:52 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 891C3E0010;
        Tue, 29 Nov 2022 08:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669709031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NFtcuDAhsKGvsH1pnOKbymkG4o1LKn/JeftB9u3zNbQ=;
        b=AI0Yxo2CstQAy1CAkj9vHfOw1fOrjcDegaRLXRnYDM7Eby2q+o/S7LGZttGl8NxbZJxO3C
        ITIQdy5Me71lRwx6DunfEV0axYHWBR7o3DF0JhatbpMEBTWh0ZT4kRtl5FcbCQFnnMxbZ1
        wT2rc9RoQMahTgcBH27wZHVJ2mYnzMZxJjsPNHiWoJoteCseoiDkeuQWbx/v0+Jxij31J5
        gadGyf8Se8osQFLccfIrrAjRgR9FZTwEp6XVbcfajXaP2oeDWUGWEDa4ZtNZsNvmL6USti
        VC8yeZWnYHwrMe5O1HqIdaWFZiahReOyhfHjfgukWviAoCeeXIHqID9nUnXxNg==
Date:   Tue, 29 Nov 2022 09:03:21 +0100
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
Subject: Re: [PATCH wpan-next v2 0/2] IEEE 802.15.4 PAN discovery handling
Message-ID: <20221129090321.132a4439@xps-13>
In-Reply-To: <CAK-6q+iLkYuz5csmbLt=tKcfGmdNGP+Sm42+DQRu5180jafEGw@mail.gmail.com>
References: <20221118221041.1402445-1-miquel.raynal@bootlin.com>
        <CAK-6q+iLkYuz5csmbLt=tKcfGmdNGP+Sm42+DQRu5180jafEGw@mail.gmail.com>
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

aahringo@redhat.com wrote on Mon, 28 Nov 2022 17:11:38 -0500:

> Hi,
>=20
> On Fri, Nov 18, 2022 at 5:13 PM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hello,
> >
> > Last preparation step before the introduction of the scanning feature
> > (really): generic helpers to handle PAN discovery upon beacon
> > reception. We need to tell user space about the discoveries.
> >
> > In all the past, current and future submissions, David and Romuald from
> > Qorvo are credited in various ways (main author, co-author,
> > suggested-by) depending of the amount of rework that was involved on
> > each patch, reflecting as much as possible the open-source guidelines we
> > follow in the kernel. All this effort is made possible thanks to Qorvo
> > Inc which is pushing towards a featureful upstream WPAN support.
> > =20
>=20
> Acked-by: Alexander Aring <aahringo@redhat.com>
>=20
> I am sorry, I saw this series today. Somehow I mess up my mails if we
> are still writing something on v1 but v2 is already submitted. I will
> try to keep up next time.

Haha I was asking myself wether or not you saw it, no problem :) I did
send it after your main review but we continued discussing on v1 (about
the preambles) so I did not ping for the time the discussion would
settle.

I'll continued with the scan interface which I think is the next step!

Thanks,
Miqu=C3=A8l
