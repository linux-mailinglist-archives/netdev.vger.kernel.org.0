Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B383542B7B7
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 08:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238037AbhJMGnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 02:43:55 -0400
Received: from mail-eopbgr1400101.outbound.protection.outlook.com ([40.107.140.101]:10007
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238039AbhJMGnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 02:43:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQIazevK2Cq++MWDbNAAG/SmJnHXPuWjVQG4gp4UOMf6nByZnlCO3rGuHJU33J53XmA7uyySMuq3NcgW9vu31aS39TgwOmP8oYhgUbfI37MakfweY/L5kuFpU1jfhQkBS1ajcX1GBeU6L1qxWF13yKiKCGq2/1Px6RiZRq0AbS7iQiB9g1k0rTolAkJFRakMXLqjb287XAtHztGdZVd84OPYJEtX57Yd8SS/VctrhItfkY9TFHYZkJWp/04Dkt03S8j8Ft39wHs9abj3Jjbs36YBgkSOT0/VKnHN3VqwlnIltaZVi3pHSnGrXGFeGcYo0CxsWClLldqgNNXfiWD15w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FBi/zgzD+QNNyIQWYH9t45lq9zBNEqlSgC1GnmkspyM=;
 b=cT1kVyPPiV10MU/YjFq0xW6WmOfzSXoFhbSEZlrffcOyP7S3N5G67GjG9lHaV1XzQM66RAT6++51B7lMccaxITOAMygADIboHFUTtRLWDp0Rp+KrpgOr0t8p71dhu4mlRLWgOVK3gK3z9w37Wwqu4ftCb82AIri1PkHqZuj4vyXWSvVu2wi9yom/r+4VZ+4+O3rjt7MTRiNeVT2YurfTHrVjAozQJ6gN/XyLe3OXXZVI7Ov2gf7XkldkmhL1yuJ/PKk9+7wFuEdPGZgTV5XOWGKEzw/D2L7eXRahbmxcBvd0rt7qxw6ILuPkC78knyCaSZm133Ha51UnJ41w2B9wNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBi/zgzD+QNNyIQWYH9t45lq9zBNEqlSgC1GnmkspyM=;
 b=iMYvtcbyjbEROyC+Nu2e771LWOY27emTpegYEr/DTtFgNn1Yzmjc7Yw69pLaCuQd6FQDgRgfx2BMS9LFaSyBBTP2KrIBwDL8b8EgEZ+mL9A5fF1NN6Y9JMu0g4TmTLHdeXA6OPNhejVPu0/nOaorU7nWk7cKU9yZ8PSAG9pE3BM=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB4695.jpnprd01.prod.outlook.com (2603:1096:604:74::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Wed, 13 Oct
 2021 06:41:46 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 06:41:46 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org>, Chris Paterson
        <Chris.Paterson2@renesas.com>, Biju Das <biju.das@bp.renesas.com" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next v3 00/14] Add functional support for Gigabit
 Ethernet driver
Thread-Topic: [PATCH net-next v3 00/14] Add functional support for Gigabit
 Ethernet driver
Thread-Index: AQHXv4dKgBnK88kVVkGc1kUz1FHm7qvPrEoAgAABg9CAAASpgIAAANWQgAAZ6oCAAK2bQA==
Date:   Wed, 13 Oct 2021 06:41:45 +0000
Message-ID: <OS0PR01MB592261426615D281CD598DF086B79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
        <20211012111920.1f3886b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <OS0PR01MB59228B47A02008629DF1782A86B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
        <20211012114125.0a9d71ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <OS0PR01MB5922B6FD6195B9DC0F2C8EA986B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <20211012131709.0bc11e3e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012131709.0bc11e3e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c7a8fd4-25f6-4364-2089-08d98e1486b8
x-ms-traffictypediagnostic: OSBPR01MB4695:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB4695BED5D0E0DDDA7AC86B4686B79@OSBPR01MB4695.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DcIB4QfXHmDH5Q0ZP1MLv/U4BQEDtC2hevMx+JEpNJhMoIMwSW65sJPN5m1ho8DVaJOdESSeEG/cSEm4l9RUSB3EBK5nKjnldqVPXiU30KCD+9xAZKeYbvdCK0fNIva0DzxsTqx915n3CbHe4ZR/4eOhkavk00durQdfqGCfem5pX3NVySxXv9ejxUUdAHeDl7NEF+HNc0mDV+GiUYTkgcMqdM0m2JcII4QlyqZVE6orpd5DqxoQWgOgbXJ7nCHaYFYBWn/Fv+omFkXr7VGG5oXYtoEeccG+/zN2Bs4qQHtupwzmjI4FGm+iTLo3KcI5uNkjtQlGXczSXNMpcGRxjK2DjYrvNxBRuDPgDOaXIAcC6V4Daw3q1ydy131uZq16yRNM8cTOt/VisbnWxKBmaTxKa0bDoDUlNGs49cKbgZ4Nzp/IVTHvBxG1NNpwpsz0A3a+vyjDYHxwn2cPsB0aGatHDOWVvT6yqRjg/n1q0zPGBYI5ueNYK/0wQHsBTzsDheSUKVJzOLfeNn7/90y50L/maWn8ScScdBFO0HlYF1pp0WHRzuwAw3SpwwzZeX/05J6mJb88QvfyoDwtanzWx2jyVb9LgfHrC6VaZGkiujYecw6pshu09LiIVfHPmouY19AAm9dBIEfo7v+5K6WmhQt14N4mO9B72x6EYAFAXzEB89KYa3HtaOrHojD3BTIlh7FJwm5QhBfHuAlzfaeBn8t21QRileiBxEsfZ4bXz0E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(55016002)(38100700002)(508600001)(2906002)(122000001)(83380400001)(186003)(9686003)(66556008)(33656002)(64756008)(26005)(8676002)(316002)(8936002)(66446008)(4326008)(5660300002)(7696005)(54906003)(38070700005)(6916009)(76116006)(71200400001)(86362001)(52536014)(66946007)(6506007)(505234007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vWbcXidZ2jvcGHwIB4gOFaKHr06USX5ZpiXQeGDuYyYinRL7wakNncBohFNu?=
 =?us-ascii?Q?Rk7bbVqpfnngWs5v9VuOVLOP4mGVjcdJjdiTfNLSVBtAwtnRzkIg4d7gmqYk?=
 =?us-ascii?Q?KgzoagnxZwyJ+CL9eVm3JfgDsoZko0XNO+QkkmHbnGr1BRVSKURqbL+HN8K/?=
 =?us-ascii?Q?Nyqy6/QoTlztC5iYoi8aKWnmZySn7XYrgYpmuGNIcws3gt8m/0Z/bLjFdeGE?=
 =?us-ascii?Q?hiyYEOJBmcjtDFPfCUJ6uKtoBjOCtFAvf4SzPHPWaVdQgAXW8M2dVZSYI70B?=
 =?us-ascii?Q?EDTgQigN5c9kMPrVxIh9BN/F23tJz/tuEXFLqd9oB9ASMMeFj1qoI1In0yWD?=
 =?us-ascii?Q?DKyoDJ6911MFOFnRs7upcbOQX/MG6l+cH0hupXP1d3nwb5eaO6LGrLTFVPCm?=
 =?us-ascii?Q?7O1LSiDYfPQ7C/gCHndlQXGyfN7N2eRRAD6/halpHpV4vkqwGXAHDpicn3XG?=
 =?us-ascii?Q?xXdIKCpqk8ejHFUUaqKGVoEWIFmGO+voRa2CybO6N93lI5iF2ZM02Ef6mMDz?=
 =?us-ascii?Q?ZJm+eOqAv435XX054KAaOx3n0mObFpq05xdgH4u5SakZQF5mGdk2cCeydB2g?=
 =?us-ascii?Q?uukD6mJNZu8qnWD8xPVTmriS/GOvdWQOhf231SxIMTcJd6jgV1O794B9u8+p?=
 =?us-ascii?Q?617PO6/jL4FvX5/AnWaykQWmINEP2BEvgeKxOvECNjUSvbyP8L2g9d5FD+xQ?=
 =?us-ascii?Q?LqpHYhGmJ45S4blW5K4vXyqrAu9wFtbW5Y4LA2Qxgs6vab+O7nYwXNriRYPj?=
 =?us-ascii?Q?5eZfNBCgC8t1ZItT53RjWub0/UiLUGECcQIyTrT9AsmgC86qq3dYfaY85hIL?=
 =?us-ascii?Q?WZMFfELwsrGAY5CpdCmz6EPC5P9E7aNvfPnMHoD/UH8y8lj4LJKYrW3VsuXE?=
 =?us-ascii?Q?jFNpsnPh+54jyIGypvLb7i5iybDlBEb9tjj0sFMIhq8P+S0TwNE1Cu1ndPnb?=
 =?us-ascii?Q?leQMkLCjTk3dNQW9HN6ItnqMHblyoc7ggxc3NRXvZ2dnL2TyebqnY38bnKoN?=
 =?us-ascii?Q?hMHJo5MqVaK60dDpNIe6UORXlcms6FoNaitKRYoZp7CzKUro8+8fuyRRx3TK?=
 =?us-ascii?Q?y54jDRgUXg6IACZ/vEA/xLweDc1tajxQd+/Oc748aW6BbCLNROm5fJcuTbQ1?=
 =?us-ascii?Q?9pa6gW2e3iu37UuKZPCyHTx7YNawiijLafGEZZNrixKweF89z67Zt+Xf66Yo?=
 =?us-ascii?Q?1tMyf9K7RDtfSHRv/tAz7piuDEJXtiHxKSDbd/RsVN9IcvwbjZkWJggUT25F?=
 =?us-ascii?Q?NnKq3gmBCBZHPJ1cwFRm0Vc0a8nG5YRr4HTuAS3gZquV/O3KTxLdXh5Dvzvk?=
 =?us-ascii?Q?ASg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c7a8fd4-25f6-4364-2089-08d98e1486b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 06:41:45.8816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cZYX4+UqO/b3G0DFDh2lDWJ9j1Az97+2GsOAPqs7gJHK8AsjBdhqH//SFzkwPgXIRS97XeugzwZF6Yv47RCAYfnyFhWdJWRgogxCeUA69t8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4695
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub Kicinski,

Thanks for the feedback.

> Subject: Re: [PATCH net-next v3 00/14] Add functional support for Gigabit
> Ethernet driver
>=20
> On Tue, 12 Oct 2021 18:53:50 +0000 Biju Das wrote:
> > > > Yes, you are correct. Sergey, suggested use R-Car RX-HW checksum
> > > > with RCSC/RCPT and But the TOE gives either 0x0 or 0xffff as csum
> > > > output and feeding this value to skb->csum lead to kernel crash.
> > >
> > > That's quite concerning. Do you have any of the
> > >
> > > /proc/sys/kernel/panic_on_io_nmi
> > > /proc/sys/kernel/panic_on_oops
> > > /proc/sys/kernel/panic_on_rcu_stall
> > > /proc/sys/kernel/panic_on_unrecovered_nmi
> > > /proc/sys/kernel/panic_on_warn
> > >
> > > knobs set? I'm guessing we hit do_netdev_rx_csum_fault() when the
> > > checksum is incorrect, but I'm surprised that causes a panic.
> >
> > I tested this last week, if I remember correctly It was not panic,
> > rather do_netdev_rx_csum_fault. I will recheck and will send you the
> > stack trace next time.
>=20
> Ah, when you say crash you mean a stack trace appears. The machine does
> not crash? That's fine, we don't need to see the trace.

I have rechecked today. It does crash, if you pass bad checksum to skb->csu=
m. Please find the logs.

root@smarc-rzg2l:~# ethtool -K eth0 rx on
Actual changes:
rx-checksum: on
[   34.391956] eth0: hw csum failure
[   34.396044] skb len=3D168 headroom=3D142 headlen=3D168 tailroom=3D15754
[   34.396044] mac=3D(128,14) net=3D(142,20) trans=3D162
[   34.396044] shinfo(txflags=3D0 nr_frags=3D0 gso(size=3D0 type=3D0 segs=
=3D0))
[   34.396044] csum(0x0 ip_summed=3D2 complete_sw=3D0 valid=3D0 level=3D0)
[   34.396044] hash(0x0 sw=3D0 l4=3D0) proto=3D0x0800 pkttype=3D0 iif=3D0
[   34.425196] dev name=3Deth0 feat=3D0x0x0000010000004000
[   34.430231] skb headroom: 00000000: ff ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff
[   34.438064] skb headroom: 00000010: ff ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff
[   34.445863] skb headroom: 00000020: ff ff ff ff ff ff ff ff ff ff ff fe =
ff ff ff ff
[   34.453660] skb headroom: 00000030: ff ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff
[   34.461453] skb headroom: 00000040: ff ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff
[   34.469246] skb headroom: 00000050: ff ff ff ff ff fe ff ff ff ff ef ff =
ff ff ff ff
[   34.477038] skb headroom: 00000060: ff ff ff ff ff ff ff ff fd fe ff ff =
ff ff ff ff
[   34.484831] skb headroom: 00000070: ff ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff f7
[   34.492629] skb headroom: 00000080: 00 11 22 33 44 55 08 00 27 a0 90 eb =
08 00
[   34.499895] skb linear:   00000000: 45 00 00 a8 54 06 40 00 40 06 50 f6 =
c0 a8 0a 01
[   34.507692] skb linear:   00000010: c0 a8 0a 02 08 01 03 0c 1d aa 76 e1 =
a3 4b 1c d8
[   34.515488] skb linear:   00000020: 80 18 21 55 72 75 00 00 01 01 08 0a =
da da 94 96
[   34.523283] skb linear:   00000030: b5 fb f1 40 80 00 00 70 d9 4a 86 c0 =
00 00 00 01
[   34.531078] skb linear:   00000040: 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00
[   34.538873] skb linear:   00000050: 00 00 00 00 00 00 00 05 00 00 01 ff =
00 00 00 01
[   34.546668] skb linear:   00000060: 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 11
[   34.554462] skb linear:   00000070: 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00
[   34.562260] skb linear:   00000080: 58 9d 6c 79 80 e3 86 f2 00 00 00 00 =
00 9a 8d 38
[   34.570055] skb linear:   00000090: 61 65 87 ee 22 8c 2f b9 61 4a 17 fb =
35 09 00 98
[   34.577850] skb linear:   000000a0: 61 4a 17 fb 35 09 00 98
[   34.583534] skb tailroom: 00000000: 00 00 00 00 21 07 00 b0 63 70 47 f9 =
42 5f 47 f9
[   34.591329] skb tailroom: 00000010: 21 f8 47 f9 80 74 47 f9 de 60 fc 97 =
a0 06 00 f9

[   42.262329] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.15.0-rc4-arm64-r=
enesas-01223-g75a50e114cb6-dirty #416
[   42.272370] Hardware name: Renesas SMARC EVK based on r9a07g044l2 (DT)
[   42.278979] Call trace:
[   42.281460]  dump_backtrace+0x0/0x188
[   42.285186]  show_stack+0x14/0x20
[   42.288550]  dump_stack_lvl+0x88/0xb0
[   42.292267]  dump_stack+0x14/0x2c
[   42.295629]  do_netdev_rx_csum_fault+0x44/0x50
[   42.300134]  __skb_gro_checksum_complete+0xb0/0xb8
[   42.304994]  tcp4_gro_receive+0xbc/0x198
[   42.308974]  inet_gro_receive+0x300/0x410
[   42.313039]  dev_gro_receive+0x308/0x898
[   42.317018]  napi_gro_receive+0x88/0x370
[   42.320996]  ravb_rx_gbeth+0x36c/0x568
[   42.324801]  ravb_poll+0xd0/0x278
[   42.328163]  __napi_poll+0x38/0x2e0
[   42.331702]  net_rx_action+0xf4/0x248
[   42.335416]  _stext+0x150/0x5d8
[   42.338604]  irq_exit+0x198/0x1b8
[   42.341970]  handle_domain_irq+0x60/0x88
[   42.345950]  gic_handle_irq+0x50/0x110
[   42.349755]  call_on_irq_stack+0x28/0x3c
[   42.353733]  do_interrupt_handler+0x4c/0x58
[   42.357974]  el1_interrupt+0x2c/0x108
[   42.361688]  el1h_64_irq_handler+0x14/0x20
[   42.365841]  el1h_64_irq+0x74/0x78
[   42.369291]  arch_cpu_idle+0x14/0x20
[   42.372918]  default_idle_call+0x78/0x330
[   42.376984]  do_idle+0x22c/0x278
[   42.380261]  cpu_startup_entry+0x20/0x68
[   42.384239]  rest_init+0x180/0x280
[   42.387689]  arch_call_rest_init+0xc/0x14
[   42.391759]  start_kernel+0x62c/0x664
[   42.395472]  __primary_switched+0xa0/0xa8


Regards,
Biju
