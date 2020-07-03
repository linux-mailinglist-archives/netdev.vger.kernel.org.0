Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDDB21389E
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 12:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgGCK00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 06:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgGCK0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 06:26:25 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D020C08C5C1
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 03:26:25 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id n23so36383269ljh.7
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 03:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:cc:subject:from:to:date:message-id
         :in-reply-to;
        bh=OuKtOMJmwEvf1zoQfKNKHsaVoKBbF/WASS38YrJXJ3E=;
        b=cV9YuavzgFDqbaqBLUaNSzNVvtnAnkRnDohecPuo4IufPuxSqrBxS9WKj3j17EldwR
         AhJWwJ3SBrWKTgL1VdU88pfFfK5KEVV2XCxNWvIKHHs3SF6QR//zIhmw4A31ccdjKl3A
         yHUUEL7XJRTgTc0pQ8zYo4B846p4BgmIbUMixQbXnm+YbX1HANSSug/omGOp2fu0AfY3
         kQLgnbrunM924hVClzi1tWfk3YP/sqDCIN1dbO1H7qoUs28IO1CDVbGWkUHLLOYFedmm
         oEkVUx68gJlvAyY96l5kyspmNkhMWktRM5fS/za2Jr39oCIzDsSYOCGNzMnJ3i7fb94S
         HIkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:cc:subject:from:to
         :date:message-id:in-reply-to;
        bh=OuKtOMJmwEvf1zoQfKNKHsaVoKBbF/WASS38YrJXJ3E=;
        b=gME2EIafTsCkgckesrlq4YVKHxTjBaXx3oMCPWfSY0ljG10SaREHjHbdRByXkfTIYn
         fKZSCScQVF5MeEu0kRxP7uJAJOaoej0jntSue/l37pL5dLpZG6e10vFIZqXfFPIpD4Fi
         y2VDmbxidb6ww3QRB61UCRvHgU67LGR7N84NxuAC5TDRJ0tR1f41OSNQ1CObmZ4xHP74
         y5fLqAexL/iUDd2gh3ZkKfUZ+Rkl8PPr6jAetCh+GSMhKT6AlG8nL+MQWLnK+XiVq6E6
         fn8SEaWxxMYsT9ucfsY6FV/GtldFp38UvWcL27O8GHgMLQDjygW3XcEsfEv9Oagbifzp
         bPwA==
X-Gm-Message-State: AOAM533hyjx2kbpmVgbA8OjAppuoaCY8HgO6VxQyDPZFhuHI6B5sCZhI
        9wA/Kc6JEp+T7w7CDn9p4DjGgg==
X-Google-Smtp-Source: ABdhPJwTmpnQX3Lofn5d+Vod8XsKPdWpjmOcGGX8ucwe3j1z/U/HpIqc4dyJrG4beGHsbl1zMK9cXA==
X-Received: by 2002:a2e:9eca:: with SMTP id h10mr19678436ljk.273.1593771983077;
        Fri, 03 Jul 2020 03:26:23 -0700 (PDT)
Received: from localhost (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id t15sm5134545lft.0.2020.07.03.03.26.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 03:26:22 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH v2 net] net: ethernet: fec: prevent tx starvation
 under high rx load
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Andy Duan" <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Date:   Fri, 03 Jul 2020 12:02:04 +0200
Message-Id: <C3WWHZGE1V5L.54SWH1P5EARO@wkz-x280>
In-Reply-To: <AM6PR0402MB36075D91D8365FC9DD677F09FF6A0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri Jul 3, 2020 at 11:58 AM CEST, Andy Duan wrote:
> From: Tobias Waldekranz <tobias@waldekranz.com> Sent: Friday, July 3,
> 2020 3:55 PM
> > On Fri Jul 3, 2020 at 4:45 AM CEST, Andy Duan wrote:
> > > In fact, you already change the queue priority comparing before.
> > > Before: queue1 (Audio) > queue2 (video) > queue0 (best effort)
> > > Now: queue2 (video) > queue1 (Audio) > queue0 (best effort)
> >=20
> > Yes, thank you, I meant to ask about that. I was looking at these defin=
itions in
> > fec.h:
> >=20
> > #define RCMR_CMP_1              (RCMR_CMP_CFG(0, 0) |
> > RCMR_CMP_CFG(1, 1) | \
> >                                 RCMR_CMP_CFG(2, 2) |
> > RCMR_CMP_CFG(3, 3))
> > #define RCMR_CMP_2              (RCMR_CMP_CFG(4, 0) |
> > RCMR_CMP_CFG(5, 1) | \
> >                                 RCMR_CMP_CFG(6, 2) |
> > RCMR_CMP_CFG(7, 3))
> >=20
> > I read that as PCP 0-3 being mapped to queue 1 and 4-7 to queue 2. That=
 led
> > me to believe that the order should be 2, 1, 0. Is the driver supposed =
to
> > prioritize PCP 0-3 over 4-7, or have I misunderstood completely?
>
> The configuration is for RX queues.

The order in which we clean the Tx queues should not matter as there
is no budget limit in that case. I.e. even in the worst case where all
three queues are filled with transmitted buffers we will always
collect all of them in a single NAPI poll, no?. I just put them in the
same order to be consistent.


> If consider PCP 0 is high priority, that does make sense: 2 > 1 > 0.

Sorry, now I'm confused. The PCP->Queue mapping is:

0->1, 1->1, 2->1, 3->1
4->2, 5->2, 6->2, 7->2

A higher PCP value means higher priority, at least in 802.1Q/p. So the
order should be 2 > 1 > 0 _not_ because PCP 0 is the highest prio, but
because PCP 7 is, right?

> >=20
> > > Other logic seems fine, but you should run stress test to avoid any
> > > block issue since the driver cover more than 20 imx platforms.
> >=20
> > I have run stress tests and I observe that we're dequeuing about as man=
y
> > packets from each queue when the incoming line is filled with 1/3 each =
of
> > untagged/tagged-pcp0/tagged-pcp7 traffic:
> >=20
> > root@envoy:~# ply -c "sleep 2" '
> > t:net/napi_gro_receive_entry {
> >     @[data->napi_id, data->queue_mapping] =3D count(); }'
> > ply: active
> > ply: deactivating
> >=20
> > @:
> > { 66, 3 }: 165811
> > { 66, 2 }: 167733
> > { 66, 1 }: 169470
> >=20
> > It seems like this is due to "Receive flushing" not being enabled in th=
e FEC. If I
> > manually enable it for queue 0, processing is restricted to only queue =
1 and 2:
> >=20
> > root@envoy:~# devmem 0x30be01f0 32 $((1 << 3)) root@envoy:~# ply -c
> > "sleep 2" '
> > t:net/napi_gro_receive_entry {
> >     @[data->napi_id, data->queue_mapping] =3D count(); }'
> > ply: active
> > ply: deactivating
> >=20
> > @:
> > { 66, 2 }: 275055
> > { 66, 3 }: 275870
> >=20
> > Enabling flushing on queue 1, focuses all processing on queue 2:
>
> Please don't enable flush, there have one IC issue.
> NXP latest errata doc should includes the issue, but the flush issue was
> fixed at imx8dxl platform.
> >=20
> > root@envoy:~# devmem 0x30be01f0 32 $((3 << 3)) root@envoy:~# ply -c
> > "sleep 2" '
> > t:net/napi_gro_receive_entry {
> >     @[data->napi_id, data->queue_mapping] =3D count(); }'
> > ply: active
> > ply: deactivating
> >=20
> > @:
> > { 66, 3 }: 545442
> >=20
> > Changing the default QoS settings feels like a separate change, but I c=
an
> > submit a v3 as a series if you want?
>
> I think the version is fine. No need to submit separate change.
> >=20
> > I do not have access to a single-queue iMX device, would it be possible=
 for you
> > to test this change on such a device?
>
> Yes, I will do stress test on imx8 and legacy platform like imx6 with
> single-queue,
> try to avoid any block issue.
> Thank you !

Excellent, thank you!
