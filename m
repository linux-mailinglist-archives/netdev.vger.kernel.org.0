Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C274A6D5A1C
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 09:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbjDDH5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 03:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbjDDH5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 03:57:17 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43DE198C
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 00:57:15 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8A723240002;
        Tue,  4 Apr 2023 07:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680595034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YD/5HT3HK5wzCFR8IzSTrUrxWmddaNyRdtU66LtUoiE=;
        b=OFA70iZLFp4EvBwBqa02S+5h7e0C0NsBDlgPGfdrwbTYjbqSzaNPRSGDPfN5LY4MWjk3+B
        7J223qKsJmMSf86TzGsrm/stkMJgcLXCertx47YHXRem5FsIorkLgsfzxKrkAkctX5ZUbT
        sOBFg9I/7k73r+l7Alru61yAau4fjUvjSr0BVrNhmkhcZXNvaQAnioyBFjQCf9G0swozVw
        6Nkfz8ay0eeRfmtAS2s+LXPOpOUkx8iQiUfPx3EmJsIp0wCFJJ/gFcgVZ3lgFu+vM2Cx9X
        zsamDSekUZpTa8V7/Azd8453RVK/mmv3jH4TEbNfIqTiRRb0lqtaQKB0ZJ0YtA==
Date:   Tue, 4 Apr 2023 09:57:10 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     Max Georgiev <glipus@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>, kuba@kernel.org,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next RFC v2] Add NDOs for hardware timestamp get/set
Message-ID: <20230404095710.73c47c20@kmaincent-XPS-13-7390>
In-Reply-To: <d6f905fd-9bd3-b673-710a-cbd080342d0e@linux.dev>
References: <20230402142435.47105-1-glipus@gmail.com>
        <20230403122622.ixpiy2o7irxb3xpp@skbuf>
        <CAP5jrPExLX5nF7BWSSc1LeE_HOSWsDNLiGB52U0dzxfXFKb+Lw@mail.gmail.com>
        <d6f905fd-9bd3-b673-710a-cbd080342d0e@linux.dev>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 18:18:18 +0100
Vadim Fedorenko <vadim.fedorenko@linux.dev> wrote:

> On 03/04/2023 16:42, Max Georgiev wrote:
> > On Mon, Apr 3, 2023 at 6:26=E2=80=AFAM Vladimir Oltean <vladimir.oltean=
@nxp.com>
> > wrote: =20
> >>
> >> On Sun, Apr 02, 2023 at 08:24:35AM -0600, Maxim Georgiev wrote: =20
> >>> Current NIC driver API demands drivers supporting hardware timestampi=
ng
> >>> to support SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs. Handling these IOCTLs
> >>> requires dirivers to implement request parameter structure translation
> >>> between user and kernel address spaces, handling possible
> >>> translation failures, etc. This translation code is pretty much
> >>> identical across most of the NIC drivers that support SIOCGHWTSTAMP/
> >>> SIOCSHWTSTAMP.
> >>> This patch extends NDO functiuon set with ndo_hwtstamp_get/set
> >>> functions, implements SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTL translation
> >>> to ndo_hwtstamp_get/set function calls including parameter structure
> >>> translation and translation error handling.
> >>>
> >>> This patch is sent out as RFC.
> >>> It still pending on basic testing. =20
> >>
> >> Who should do that testing? Do you have any NIC with the hardware
> >> timestamping capability? =20
> >=20
> > I'm planning to do the testing with netdevsim. I don't have access to
> > any NICs with
> > hardware timestamping support.
> >  =20
>=20
> Hi Max!
> I might do some manual tests with the hardware that support timestamping=
=20
> once you respin the series with the changes discussed in the code=20
> comments. I'll convert hardware drivers myself to support new NDO on top=
=20
> of your patches.

Same here.

K=C3=B6ry,
