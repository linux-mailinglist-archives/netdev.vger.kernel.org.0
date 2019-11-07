Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F95F25AD
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 04:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732928AbfKGDAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 22:00:49 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:49436 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfKGDAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 22:00:49 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 8E0D7886BF
        for <netdev@vger.kernel.org>; Thu,  7 Nov 2019 16:00:46 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1573095646;
        bh=DCD7wvpav4EmA7ZHz05KmNhs++VD7s5ifYJIUtVXM9Y=;
        h=From:To:Subject:Date:References:In-Reply-To;
        b=zNtwbw8kTypM/gIDTG6hI7kEXPdhArx5CxL0ZoptjJ06vVdCQjLr37qCuVAjpiEGp
         Nc5PvCF9/64Ems1/NlvzAcJJJ20YqYO0xNip+65326rfNkUmpxJlcFdY16Nwtdwbuj
         ntoBAcduGoALLk1YEWTz18F5Bu4jbYBRBt9xeYVxvd/K0KZ5AfZpX48podAcQaGYcg
         Y5oxPffMiqC+KPvkxMq4MeGYnPRvc5XhUkXvLOQdrBjiRkoUttNRhAkrVbsYKJvQk2
         LRKvODsrSwUWKFJdY/R1b1O6+fgfHgzWL3pntE/bGN4+hYuN0pT9Fs6eC6dbyl1eOV
         rW73imEcR4VCQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5dc388df0001>; Thu, 07 Nov 2019 16:00:47 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1156.6; Thu, 7 Nov 2019 16:00:46 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1156.000; Thu, 7 Nov 2019 16:00:46 +1300
From:   Mark Tomlinson <Mark.Tomlinson@alliedtelesis.co.nz>
To:     "hd@os-cillation.de" <hd@os-cillation.de>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [Possible regression?] ip route deletion behavior change
Thread-Topic: [Possible regression?] ip route deletion behavior change
Thread-Index: AQHVlLrRmgrekLMNEECfn2OiOKYoS6d+K7WA
Date:   Thu, 7 Nov 2019 03:00:45 +0000
Message-ID: <2db4c4569c61cafb1abb609609740e83d242b5f1.camel@alliedtelesis.co.nz>
References: <603d815f-f6db-3967-c0df-cbf084a1cbcd@os-cillation.de>
         <9384f54f-67a0-f2dc-68f8-3216717ee63e@gmail.com>
         <b7d44dcf-6382-a668-1a6a-4385f77fb0f5@os-cillation.de>
In-Reply-To: <b7d44dcf-6382-a668-1a6a-4385f77fb0f5@os-cillation.de>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:23:fdf0:a6de:5c39:13cb]
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <43288CD186860640A666C51652F09609@atlnz.lc>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-11-06 at 16:56 +0100, Hendrik Donner wrote:
> On 10/31/19 9:41 PM, David Ahern wrote:
> >=20
> > devices not associated with a VRF table are implicitly tied to the
> > default =3D=3D main table.
> >=20
> > Can you test this change:
> >=20
> > diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> > index 0913a090b2bf..f1888c683426 100644
> > --- a/net/ipv4/fib_semantics.c
> > +++ b/net/ipv4/fib_semantics.c
> > @@ -1814,8 +1814,8 @@ int fib_sync_down_addr(struct net_device *dev,
> > __be32 local)
> >         int ret =3D 0;
> >         unsigned int hash =3D fib_laddr_hashfn(local);
> >         struct hlist_head *head =3D &fib_info_laddrhash[hash];
> > +       int tb_id =3D l3mdev_fib_table(dev) ? : RT_TABLE_MAIN;
> >         struct net *net =3D dev_net(dev);
> > -       int tb_id =3D l3mdev_fib_table(dev);
> >         struct fib_info *fi;
> >=20
> >         if (!fib_info_laddrhash || local =3D=3D 0)
> >=20
> > [ As DaveM noted, you should cc maintainers and author(s) of suspected
> > regression patches ]
> >=20
>=20
> I've tested your patch and it restores the expected behavior.
>=20
> + Mark Tomlinson so he can have a look at it too.

I admit that I did not cater for the case where l3mdev_fib_table(dev)
returned NULL. I am OK with this change.

