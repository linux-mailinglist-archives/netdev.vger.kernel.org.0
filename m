Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C4742B7FC
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 08:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238177AbhJMGxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 02:53:05 -0400
Received: from mail-eopbgr1410111.outbound.protection.outlook.com ([40.107.141.111]:15360
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238126AbhJMGxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 02:53:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBoXSpY/IWQBZ0ENgtNtsEo52PCjPUsirw+FZbLVFmUoMNo84jienPR3Q7cZGr4UHKxG2GouJv0O+KX//J6BaN1mBh4ufLEY617f3doCMXl4QMbqtMlT5PaGzAw47Hxfxoxalk0Au6pWigNiz41Ua9vzdpghhOeX3EQQEHmat3rsa4f5bzx8Qug3LLV30ojXX6/sP34JGIBJe7yVSDh1KlZ/9uRuuZEVChRwPjCIKU/gDrOjzUK7HOFWKhVOOiJXf7oHQbHVVmTRiPE8tXQmeNTZdxb+J0qLRwpOR38uqxlQLREwJLMS3oEGFe7ypKciC+I6LpTztFeDoyvjVRWhSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vim0OxrvCsAnVu/gYNTezN1mZ+IYo1+DZjF8nk0/g30=;
 b=VHMCjVbNdhPCPiXISCyA2JHHXwgHkAfJBEeiZZtHVwR5VsetI6pXSjXa5Y63/4q3t+QTSE7e653zUsPtUdlHQMwQsb8AYqP1h6oeurUZq4BVDyceirf/qkNxs7xy6XZUx5Bordwf21yN78b2ScWWUNju6104vv21SKJxrzmgF38moGjCy9x3mZ8tUMuvsgoYE11WvfKBc6Q/NApDEKuk/pv2BTtEuc8vJoyeEbNyxHp9Fd05K6m0j7ot29fcimqzOj+kvT4Q2j9gQq1MlQPVOFM7HKlLyUx8vka+xS/cP7v19FX7o754iVTThiCU081Sh9IyAg7h5fY+44Ez1tMG+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vim0OxrvCsAnVu/gYNTezN1mZ+IYo1+DZjF8nk0/g30=;
 b=OL2taWKaPm9pMQjHwzuYJMX//NHKN8zPZR7n+c5bjzW7vDwKV0UaIrk3NJr3NQcYY/cocoL1MtbqKhkTc3MypvToqpqeddnaak8+7AF8oW6KrXEbNG7T30PDrq3plVyTBgRbOaauHylX8d+DsrPwI2vDIJwNV/ZBy1eOzJvgwG8=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB3303.jpnprd01.prod.outlook.com (2603:1096:604:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 13 Oct
 2021 06:50:54 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 06:50:53 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Jakub Kicinski <kuba@kernel.org>
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
Thread-Index: AQHXv4dKgBnK88kVVkGc1kUz1FHm7qvPrEoAgAABg9CAAASpgIAAANWQgAAZ6oCAAK2bQIAAAajQ
Date:   Wed, 13 Oct 2021 06:50:53 +0000
Message-ID: <OS0PR01MB5922D9AFC79B82B0AC3376A886B79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
        <20211012111920.1f3886b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <OS0PR01MB59228B47A02008629DF1782A86B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
        <20211012114125.0a9d71ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <OS0PR01MB5922B6FD6195B9DC0F2C8EA986B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <20211012131709.0bc11e3e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <OS0PR01MB592261426615D281CD598DF086B79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB592261426615D281CD598DF086B79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 744b1e0b-5dd5-4d35-5b01-08d98e15cd43
x-ms-traffictypediagnostic: OSBPR01MB3303:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB33036523EF3FDCF16B48979A86B79@OSBPR01MB3303.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4XAZLp8ZNJvILGFzy8eANp7vRTeazJVfQ6gBUL2DeQcrX/y+6c7w1yoUDY/Kt9EYhxFAefzL+8qwJ2E1r7EqddHaMdQrqGQI/5W4rqS8s3DyI2dufjOZLOHoLp/vCVZKwU3feGQlE5xY3tqXyyEKlCLgKTr0o3hWPQd2C9UNcxVskxVgpt50u9cYm2hBCyWlzdHH1cgZZgFM3B4vswW8TGRpOyB0sGtg1YRtAPs9jbZWRmpS6ohG1kM32x5ejJvQBejgcTGV0l7lC8nKnx9l37Q4859N9CUimD7DwZk+bTVOIu2CQdO6tOhFJC6eu9cmRcLQaUfn0qOp4aQpK22lyB2yZ5WUjWc5mOqiNbQODrwSfn9/sqfWImmYtDwyStxSVhUjp7nfuJFHIlBprcKNVfQFoeXfs/JZ1SAZFTraJZxUIxEw4ka/Iivt6fCIQxV5pcYZe86w824s6MHf2J1wiR/+JGlARsDENQ30+LL0M4zmoLwCe3JHNxDBa60/ZrhRVXdyapFjAw/7bGaV1/ZbL+ojAh8pdMXGOWa5udUlyOOqjujIEshXxnT5nAYTadzmJVz0ca6EIYAtzdbIodz2yYwmLYuTnI5vA0CbBMuE4xrjA+8isDbrGCI4gRpMQY9dPCMHoTsAUGorzKT5+5/7S7vnQrIFAw/bArD/X5lpqoGL4t+SvcMdazUxKjCwrzPf3TzdAtho9sgmc2iHfg/LOTtFwhwtTUiQzK1pVixQve4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(38070700005)(7696005)(9686003)(86362001)(186003)(71200400001)(2906002)(55016002)(26005)(508600001)(33656002)(6506007)(8936002)(66556008)(66946007)(64756008)(66446008)(66476007)(5660300002)(52536014)(4326008)(54906003)(2940100002)(76116006)(122000001)(38100700002)(8676002)(316002)(110136005)(505234007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2MWm5lLJu2hqCp7Hscb5d+OyqMJfHPC/3Bj6NNVndsc9EU7WZO4Pxc1Krhez?=
 =?us-ascii?Q?BAFU9qq8uOr4iu9cath1/kRMnPTxJa+mtkPZ5/ik02YxZGM//Tgz7mK0AP6G?=
 =?us-ascii?Q?wyoaAHzCYZRj3fMp5wG9/lKcjMd/tjZIZR3HJq1WGEraO61OlsR/55Rwrff2?=
 =?us-ascii?Q?tiBGemHcxyDvSuIUshBuWaAtplh5VdCFRzmLUH7aUxxnSFq5d9/TDYwGfKBT?=
 =?us-ascii?Q?95oA+/Hyn5sKX/PB2Xmxsg1HnfW/k1Dl51tDhu1AG3eXphBkwNVmKZhZl0zC?=
 =?us-ascii?Q?DYliC5KJ7sqMSqunsgUxrAyYHhDMssIFrBF7uJezd5IjEZb1Hl3wOfOkfXp2?=
 =?us-ascii?Q?d85rYxhX9R/1qIG5NcCZmPGhSdNekpfaGzCkaQDJp5wJac3Xz73QC17HDjtw?=
 =?us-ascii?Q?gcbs/c5sEtjA3JbM/5Z+yJ+leDwwsIo91qckI6FgWR1pXm0N8O0oY+C94HAt?=
 =?us-ascii?Q?Ravi9NA8uplrR4ZxUccuEAJrgstl9Ltibu7YhUbbphG1ZKkKVx/ZXFdaIvRg?=
 =?us-ascii?Q?l3Ql9AYS5IuOs3tFLx+lk9BCer90fBAI7oomTHMtIsM7V/yLfXozLtI2v4uG?=
 =?us-ascii?Q?ouiRyG7o/L4iJveidLg2Aozy3b94Gca+J94pHdGh/bWXplylRyrj2JGwpZqJ?=
 =?us-ascii?Q?+Pnsnu8/rQI0VHDR/39ArgHh8WzxyNfqYGo4clnmqsC8XfP1hMGG9H1YfTqN?=
 =?us-ascii?Q?KGdEEU/cJgJ95tZ796KVt5b+BuW4/6cHyMWFBU7dK++w7vLglSl02M9Um1TZ?=
 =?us-ascii?Q?aaOh5pEbwnYth6y2rlwn6zLffxcY0SRBQoC90L8hv0PWLw2BLpKjYXhAL5lp?=
 =?us-ascii?Q?czgfa7RIIF/woNG1yelAYUuFRm8q2+/kBeo31XuB/Rs0AhKl2IzQXmX4Javy?=
 =?us-ascii?Q?UNI3B5/1QFIZT6WEqFlera7qS/Gm8hjV+PGoJTVIVFZDMO7MLPGTFr7+kPuy?=
 =?us-ascii?Q?tcKIqEq/S1iteiKNmWUz3QD79FMSmLELF2zysa/XGLZm7vUax4FWg0SXEX7K?=
 =?us-ascii?Q?r5skd5aLhjaKCsnobG7JCpLLndCjuNGWztl2RWhEYCQKpkixbbGOTQ+u3xHO?=
 =?us-ascii?Q?VA+teIay4klNNSOjASmNDl/z42lYfYDJcalljrgcrI/m1SLXZlANvh/tw26j?=
 =?us-ascii?Q?91MECDZyYsC6PAV34ILksiBCHKuquAI7eu3L0h5IGUzYv3mou0VmEIhh5F1o?=
 =?us-ascii?Q?o0N5yT4Nh9af5RPn1NNJHaaY9FUn7emJNLj5CgxU1EzrQ5XEYFtQaFeQi+Os?=
 =?us-ascii?Q?JIRFYx4eXNiC3+tbl7JEo3ZLuluATMZUgk++RC3tfH0WNg1+zkbfZ7SkOH45?=
 =?us-ascii?Q?G0I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 744b1e0b-5dd5-4d35-5b01-08d98e15cd43
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 06:50:53.7144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lancy4OcsEtxGd4gPx1H+udHidjzkOyCeWJDTPi4Tn/eMJ5bwBF7e1LD3rhjR/pwg9P4jPDWmUGLHdFnIicvotzTxbUApVLcW66gRUYGY/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3303
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Sorry for the spam, it is not crash, it is just printing out the stack trac=
e.
I have tested with rx hw checksum turned on by default as well. It boots wi=
th NFS, but with that noisy messages, if we pass bad checksum to skb->csum.

Regards,
Biju

> Subject: RE: [PATCH net-next v3 00/14] Add functional support for Gigabit
> Ethernet driver
>=20
> Hi Jakub Kicinski,
>=20
> Thanks for the feedback.
>=20
> > Subject: Re: [PATCH net-next v3 00/14] Add functional support for
> > Gigabit Ethernet driver
> >
> > On Tue, 12 Oct 2021 18:53:50 +0000 Biju Das wrote:
> > > > > Yes, you are correct. Sergey, suggested use R-Car RX-HW checksum
> > > > > with RCSC/RCPT and But the TOE gives either 0x0 or 0xffff as
> > > > > csum output and feeding this value to skb->csum lead to kernel
> crash.
> > > >
> > > > That's quite concerning. Do you have any of the
> > > >
> > > > /proc/sys/kernel/panic_on_io_nmi
> > > > /proc/sys/kernel/panic_on_oops
> > > > /proc/sys/kernel/panic_on_rcu_stall
> > > > /proc/sys/kernel/panic_on_unrecovered_nmi
> > > > /proc/sys/kernel/panic_on_warn
> > > >
> > > > knobs set? I'm guessing we hit do_netdev_rx_csum_fault() when the
> > > > checksum is incorrect, but I'm surprised that causes a panic.
> > >
> > > I tested this last week, if I remember correctly It was not panic,
> > > rather do_netdev_rx_csum_fault. I will recheck and will send you the
> > > stack trace next time.
> >
> > Ah, when you say crash you mean a stack trace appears. The machine
> > does not crash? That's fine, we don't need to see the trace.
>=20
> I have rechecked today. It does crash, if you pass bad checksum to skb-
> >csum. Please find the logs.
>=20
> root@smarc-rzg2l:~# ethtool -K eth0 rx on Actual changes:
> rx-checksum: on
> [   34.391956] eth0: hw csum failure
> [   34.396044] skb len=3D168 headroom=3D142 headlen=3D168 tailroom=3D1575=
4
> [   34.396044] mac=3D(128,14) net=3D(142,20) trans=3D162
> [   34.396044] shinfo(txflags=3D0 nr_frags=3D0 gso(size=3D0 type=3D0 segs=
=3D0))
> [   34.396044] csum(0x0 ip_summed=3D2 complete_sw=3D0 valid=3D0 level=3D0=
)
> [   34.396044] hash(0x0 sw=3D0 l4=3D0) proto=3D0x0800 pkttype=3D0 iif=3D0
> [   34.425196] dev name=3Deth0 feat=3D0x0x0000010000004000
> [   34.430231] skb headroom: 00000000: ff ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff
> [   34.438064] skb headroom: 00000010: ff ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff
> [   34.445863] skb headroom: 00000020: ff ff ff ff ff ff ff ff ff ff ff f=
e
> ff ff ff ff
> [   34.453660] skb headroom: 00000030: ff ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff
> [   34.461453] skb headroom: 00000040: ff ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff ff
> [   34.469246] skb headroom: 00000050: ff ff ff ff ff fe ff ff ff ff ef f=
f
> ff ff ff ff
> [   34.477038] skb headroom: 00000060: ff ff ff ff ff ff ff ff fd fe ff f=
f
> ff ff ff ff
> [   34.484831] skb headroom: 00000070: ff ff ff ff ff ff ff ff ff ff ff f=
f
> ff ff ff f7
> [   34.492629] skb headroom: 00000080: 00 11 22 33 44 55 08 00 27 a0 90 e=
b
> 08 00
> [   34.499895] skb linear:   00000000: 45 00 00 a8 54 06 40 00 40 06 50 f=
6
> c0 a8 0a 01
> [   34.507692] skb linear:   00000010: c0 a8 0a 02 08 01 03 0c 1d aa 76 e=
1
> a3 4b 1c d8
> [   34.515488] skb linear:   00000020: 80 18 21 55 72 75 00 00 01 01 08 0=
a
> da da 94 96
> [   34.523283] skb linear:   00000030: b5 fb f1 40 80 00 00 70 d9 4a 86 c=
0
> 00 00 00 01
> [   34.531078] skb linear:   00000040: 00 00 00 00 00 00 00 00 00 00 00 0=
0
> 00 00 00 00
> [   34.538873] skb linear:   00000050: 00 00 00 00 00 00 00 05 00 00 01 f=
f
> 00 00 00 01
> [   34.546668] skb linear:   00000060: 00 00 00 00 00 00 00 00 00 00 00 0=
0
> 00 00 00 11
> [   34.554462] skb linear:   00000070: 00 00 00 00 00 00 00 00 00 00 00 0=
0
> 00 00 00 00
> [   34.562260] skb linear:   00000080: 58 9d 6c 79 80 e3 86 f2 00 00 00 0=
0
> 00 9a 8d 38
> [   34.570055] skb linear:   00000090: 61 65 87 ee 22 8c 2f b9 61 4a 17 f=
b
> 35 09 00 98
> [   34.577850] skb linear:   000000a0: 61 4a 17 fb 35 09 00 98
> [   34.583534] skb tailroom: 00000000: 00 00 00 00 21 07 00 b0 63 70 47 f=
9
> 42 5f 47 f9
> [   34.591329] skb tailroom: 00000010: 21 f8 47 f9 80 74 47 f9 de 60 fc 9=
7
> a0 06 00 f9
>=20
> [   42.262329] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.15.0-rc4-arm64=
-
> renesas-01223-g75a50e114cb6-dirty #416
> [   42.272370] Hardware name: Renesas SMARC EVK based on r9a07g044l2 (DT)
> [   42.278979] Call trace:
> [   42.281460]  dump_backtrace+0x0/0x188
> [   42.285186]  show_stack+0x14/0x20
> [   42.288550]  dump_stack_lvl+0x88/0xb0
> [   42.292267]  dump_stack+0x14/0x2c
> [   42.295629]  do_netdev_rx_csum_fault+0x44/0x50
> [   42.300134]  __skb_gro_checksum_complete+0xb0/0xb8
> [   42.304994]  tcp4_gro_receive+0xbc/0x198
> [   42.308974]  inet_gro_receive+0x300/0x410
> [   42.313039]  dev_gro_receive+0x308/0x898
> [   42.317018]  napi_gro_receive+0x88/0x370
> [   42.320996]  ravb_rx_gbeth+0x36c/0x568
> [   42.324801]  ravb_poll+0xd0/0x278
> [   42.328163]  __napi_poll+0x38/0x2e0
> [   42.331702]  net_rx_action+0xf4/0x248
> [   42.335416]  _stext+0x150/0x5d8
> [   42.338604]  irq_exit+0x198/0x1b8
> [   42.341970]  handle_domain_irq+0x60/0x88
> [   42.345950]  gic_handle_irq+0x50/0x110
> [   42.349755]  call_on_irq_stack+0x28/0x3c
> [   42.353733]  do_interrupt_handler+0x4c/0x58
> [   42.357974]  el1_interrupt+0x2c/0x108
> [   42.361688]  el1h_64_irq_handler+0x14/0x20
> [   42.365841]  el1h_64_irq+0x74/0x78
> [   42.369291]  arch_cpu_idle+0x14/0x20
> [   42.372918]  default_idle_call+0x78/0x330
> [   42.376984]  do_idle+0x22c/0x278
> [   42.380261]  cpu_startup_entry+0x20/0x68
> [   42.384239]  rest_init+0x180/0x280
> [   42.387689]  arch_call_rest_init+0xc/0x14
> [   42.391759]  start_kernel+0x62c/0x664
> [   42.395472]  __primary_switched+0xa0/0xa8
>=20
>=20
> Regards,
> Biju
