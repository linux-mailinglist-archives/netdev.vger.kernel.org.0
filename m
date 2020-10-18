Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0C0291736
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 13:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgJRLmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 07:42:14 -0400
Received: from mail-eopbgr30079.outbound.protection.outlook.com ([40.107.3.79]:59776
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbgJRLmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 07:42:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7+xoy7Z1tvdtOptIfaluXMSqTF2Xo0FZesHcDlDOpl4r9Tdcsj5yP/JJcEqS/zomXfW3e70uijFjNbHELamwWIBsdbGVThcLg33StDTZLWpeHdX62NcHARs/g2AmR8/Z/bEMW6qUvl3qHFFhpWfGyIwRGA5r215DkakTl7gQ3rwSFnYZcCk4o6GwmjRzUWQDG9pzOEgM4c6hJaPYazXelrdtksGojTV2VMRd1BqKDDoy9IkQrewKKDt+KnrlJ+9WspK8eK8upiB6fTP+JGyMNQ/vi/YgQdnAMgN9X4/ZJRWKUwuDPsn7J+aQqwG7VovppudEWT40Ah1Xih85lWFYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sJK5aMUnUA1QuzvLwcmvK3Htuz+XegGeFcVA20gEEk=;
 b=b7WSZ70x3ZRUflzCtnZhuVGyL9xeTn8AkyR4DDeqjc87LlC2lagZXoTrTCD8C01o+UU+S43tM/9TXdxsfj++3wVMutOn30i2nNMpWEIdRJA0D4o/wlF/GxnvhvkbqKI6ZkPAnhwepm1+tKHHLxMdbMKLydE8oZDvjGmBaNv4vS9A1UPoEIDgpXjWMxAv0dmmOMbDRJq0r7jKRL4xkCwduxO9Sc/lBkM1s5rOkm+sGRDINkxE2YevRjXGUCFzHkZsL+AuGyagD0hgexQTjelBWVPd2VEfsro8CRvaH5GpH1AEF9sWax4dJRd7gyL92Lgd+78os42X5/7tnn9oxlQLtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sJK5aMUnUA1QuzvLwcmvK3Htuz+XegGeFcVA20gEEk=;
 b=Y6KHlA/TmqHvhK0QbTsu1DHjcZ1xvMGPljE4szEOfpuarMTGr4Zu+IDI7gGBwjbejviChm1BLkixlnJAgMGVhyMgaeKuiMjiiSk20XIa6l9wRf5dWO+IzRv06zPBM6Qs0YPtTXko61Wn1x3T88qDyef3gBxKWgYzHMyjar26fTI=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3712.eurprd04.prod.outlook.com (2603:10a6:803:1c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.26; Sun, 18 Oct
 2020 11:42:06 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sun, 18 Oct 2020
 11:42:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Christian Eggers <ceggers@arri.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Topic: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Index: AQHWpM2WRVElJamqkEeHVtfDsj9ayamcWGgAgAAIdQCAAByHAIAArfWAgAASc4A=
Date:   Sun, 18 Oct 2020 11:42:06 +0000
Message-ID: <20201018114205.dk5mcr7mcnqgo65w@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017223120.em6bp245oyfuzepk@skbuf>
 <20201018001326.auu4u7mgfnxk37nx@skbuf> <2267996.Y80grUFxSa@n95hx1g2>
In-Reply-To: <2267996.Y80grUFxSa@n95hx1g2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: arri.de; dkim=none (message not signed)
 header.d=none;arri.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4116f1cc-d913-4609-7b00-08d8735ad6f7
x-ms-traffictypediagnostic: VI1PR0402MB3712:
x-microsoft-antispam-prvs: <VI1PR0402MB371252F7F3DF928B443FEBD0E0010@VI1PR0402MB3712.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rxbSSOxqG2nQc/XV1Zz7v3enNWbHJK97FL59p4FxBRpBj9oNTGUD2psLymQNQYBvm5Yc5IUbXY0Caht5zadj6OVFmR43fFrYKcVwpYyM+MW+XCEEYFAiIqzPNJg4cxegRqZonZsBe0nhn1jRQTDc6MqohLsy9i/pawxTDf/M/mP43fL5Q43EpdexVcZ9sUzsns20WdVExgDSqVcCvDNFChVSy/KmWDRCO8K6CMGT0N8ZGcZjGmw0mcYLZZHGG9Pxf+2ju+nvNP4eLeV4DMcC8gCnMaKUAx2ARwHGEy4UX8OkGDJ1DY5UZ8ZWSilrsxogcb06NhvH7QguI4Fy9yEsWmedJT2kWczSLAwOmPDvNgG3N4xDNIq+yPGflcPi16DH/kGxRKz8wVD/980ULFqEcYsdvD4V4tLhEGmepzmiels6tqMyPQjvjULPd91JAXlmsFw5snQW/Xo+nWbkXQg7fQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39850400004)(366004)(136003)(346002)(376002)(396003)(6506007)(71200400001)(478600001)(33716001)(83380400001)(4326008)(8936002)(86362001)(44832011)(6916009)(2906002)(316002)(5660300002)(1076003)(66476007)(91956017)(966005)(66946007)(76116006)(26005)(54906003)(186003)(6486002)(66556008)(6512007)(8676002)(9686003)(64756008)(66446008)(505234006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 393w1R14sFqAr+pv+w4ExXSfbHkIZmIhhch1++O0aPwHmhjixbzzlE173jvCl0SH7ZdDY2a5I4iBxAWgFgEKgiKmeCDDODUdgiKLcrQiGyhKfDSLaWVDUGlWqQvkwp/7OtG7ZlUELz8I4jjpNTKk/ILS2Mtgtx1riJ4JXiRGQSlRydEAHCcsSJHmTeGp0xCRq4AhfgNlFVyouK3WFb2Wyyokrk/nmx3J81igMZcSiIcn0BzF4PboV33CwY6rTAnXCUvS8Kh4DJLAGCChcP/4VlMIH8FjceRk6dYcsGdx1cCD7tkUFrL2wt1FepJyB5jUB9PnEzFiu49f3ys/6sq5jvmfqzVm6NenZcKoYmultdbID6PZUsicE984LdXWFOYPgbmKqILSqL1KPpvL2C7fRtTsOafOg/yMYutNUha7GxFLRq6U5AvTXejfXYsTlpgXiJZPym7698NCYPXMOMsj1P0r/yfI8BwNjh1xV5JmumfvpjzWZwm5XCw66gonNp9zLoNEHyZrI+reZGZwmR5ulkJBf4IKhUW1+FEJDMY+JsLHazzZqwHOHWLM1YxVizummNGx7y2l0LNQ0Bhon1B0umhpcWH1Ns9g/8UtFYalvEUybLcTtUnH5yz61puLDG3DtiNBcf0bHj1yAISnjTe+Lw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3A767B1893060042A7CA930F4784C2B1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4116f1cc-d913-4609-7b00-08d8735ad6f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2020 11:42:06.2070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FtQdsRJ2Msi01KWeXydIbtgCMSYGjkmJHOgvFwkSYaZCLmnKZ8Ob3AjPb4Sb0WkuKEVHIsADAUtv9eQNPfmOKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3712
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 12:36:03PM +0200, Christian Eggers wrote:
> >       /* For tail taggers, we need to pad short frames ourselves, to en=
sure
> >        * that the tail tag does not fail at its role of being at the en=
d of
> >        * the packet, once the master interface pads the frame.
> >        */
> >       if (unlikely(needed_tailroom && skb->len < ETH_ZLEN))
> Can "needed_tailroom" be used equivalently for dsa_device_ops::tail_tag?

For what I care, it's "equivalent enough".
Since needed_tailroom comes from slave->needed_tailroom + master->needed_ta=
ilroom,
there might be a situation when slave->needed_tailroom is 0, but padding
is performed nonetheless. I am not sure that this is something that will
occur in practice. If you grep drivers/net/ethernet, only Sun Virtual Netwo=
rk
devices set dev->needed_tailroom. I would prefer avoiding to touch any
other cache line, and not duplicating the tail_tag or overhead members
if I can avoid it. If it becomes a problem, I'll make that change.

> >               padlen =3D ETH_ZLEN - skb->len;
> >       needed_tailroom +=3D padlen;
> >       needed_headroom -=3D skb_headroom(skb);
> >       needed_tailroom -=3D skb_tailroom(skb);
> >
> >       if (likely(needed_headroom <=3D 0 && needed_tailroom <=3D 0 &&
> >                  !skb_cloned(skb)))
> >               /* No reallocation needed, yay! */
> >               return 0;
> >
> >       e =3D this_cpu_ptr(p->extra_stats);
> >       u64_stats_update_begin(&e->syncp);
> >       e->tx_reallocs++;
> >       u64_stats_update_end(&e->syncp);
> >
> >       err =3D pskb_expand_head(skb, max(needed_headroom, 0),
> >                              max(needed_tailroom, 0), GFP_ATOMIC);
> You may remove the second max() statement (around needed_tailroom). This =
would
> size the reallocated skb more exactly to the size actually required an ma=
y save
> some RAM (already tested too).

Please explain more. needed_tailroom can be negative, why should I
shrink the tailroom?

> Alternatively I suggest moving the max() statements up in order to comple=
tely
> avoid negative values for needed_headroom / needed_tailroom:
>=20
>         needed_headroom =3D max(needed_headroom - skb_headroom(skb), 0);
>         needed_tailroom =3D max(needed_tailroom - skb_tailroom(skb), 0);
>=20
>         if (likely(needed_headroom =3D=3D 0 && needed_tailroom =3D=3D 0 &=
&
>                    !skb_cloned(skb)))
>                 /* No reallocation needed, yay! */
>                 return 0;
>         ...
>         err =3D pskb_expand_head(skb, needed_headroom, needed_tailroom, G=
FP_ATOMIC);
>=20

Ok, this looks better, thanks.

> >       if (err < 0 || !padlen)
> >               return err;
> This is correct but looks misleading for me. What about...
>         if (err < 0)
>                 return err;
>=20
>         return padlen ? __skb_put_padto(skb, ETH_ZLEN, false) : 0;
>=20

Ok, I suppose it can be misleading. Will do this even if it's one more
branch. It's in the unlikely path anyway.

> FYI two dumps of a padded skb (before/after) dsa_realloc_skb():
> [ 1983.621180] old:skb len=3D58 headroom=3D2 headlen=3D58 tailroom=3D68
> [ 1983.621180] mac=3D(2,14) net=3D(16,-1) trans=3D-1
> [ 1983.621180] shinfo(txflags=3D1 nr_frags=3D0 gso(size=3D0 type=3D0 segs=
=3D0))
> [ 1983.621180] csum(0x0 ip_summed=3D0 complete_sw=3D0 valid=3D0 level=3D0=
)
> [ 1983.621180] hash(0x0 sw=3D0 l4=3D0) proto=3D0x88f7 pkttype=3D0 iif=3D0
> [ 1983.635575] old:dev name=3Dlan0 feat=3D0x0x0002000000005220
> [ 1983.638205] old:sk family=3D17 type=3D3 proto=3D0
> [ 1983.640323] old:skb linear:   00000000: 01 1b 19 00 00 00 ee 97 1f aa =
93 21 88 f7 01 02
> [ 1983.644416] old:skb linear:   00000010: 00 2c 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00
> [ 1983.648656] old:skb linear:   00000020: 00 00 ee 97 1f ff fe aa 93 21 =
00 01 06 79 01 7f
> [ 1983.652726] old:skb linear:   00000030: 00 00 00 00 00 00 00 00 00 00
>=20
> [ 1983.656040] new:skb len=3D60 headroom=3D2 headlen=3D60 tailroom=3D66
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ok
> [ 1983.656040] mac=3D(2,14) net=3D(16,-1) trans=3D-1
> [ 1983.656040] shinfo(txflags=3D1 nr_frags=3D0 gso(size=3D0 type=3D0 segs=
=3D0))
> [ 1983.656040] csum(0x0 ip_summed=3D0 complete_sw=3D0 valid=3D0 level=3D0=
)
> [ 1983.656040] hash(0x0 sw=3D0 l4=3D0) proto=3D0x88f7 pkttype=3D0 iif=3D0
> [ 1983.670427] new:dev name=3Dlan0 feat=3D0x0x0002000000005220
> [ 1983.673082] new:sk family=3D17 type=3D3 proto=3D0
> [ 1983.675233] new:skb linear:   00000000: 01 1b 19 00 00 00 ee 97 1f aa =
93 21 88 f7 01 02
> [ 1983.679329] new:skb linear:   00000010: 00 2c 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00
> [ 1983.683411] new:skb linear:   00000020: 00 00 ee 97 1f ff fe aa 93 21 =
00 01 06 79 01 7f
> [ 1983.687506] new:skb linear:   00000030: 00 00 00 00 00 00 00 00 00 00 =
00 00

The dumps look ok, and in line with what I saw.
For what it's worth, anybody can test with any tagger, you don' need
dedicated hardware. You just need to replace the value returned by your
dsa_switch_ops::get_tag_protocol method. This is enough to get skb dumps.
For more complicated things like ensuring 1588 timestamping
works, it won't be enough, of course, so your testing is still very
valuable to ensure that keeps working for you (it does for me).

>=20
> Tested-by: Christian Eggers <ceggers@arri.de>  # For tail taggers only

Thanks, I'll resend this in about 2 weeks. In the meantime I'll update
this branch:
https://github.com/vladimiroltean/linux/commits/dsa-tx-realloc=
