Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87BD361070
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 18:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbhDOQwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 12:52:16 -0400
Received: from mail-bn8nam12on2115.outbound.protection.outlook.com ([40.107.237.115]:38528
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231137AbhDOQwO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 12:52:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJ3O70wthF+111Ub0u4euR8XPJFQjeercWeUrB71dqJiCGaA3yjR7s+TWSt09RrbTHsjkXGql78wKDd8OAOkJHvLnbgH/Hn3z6BktaAE11kMguXAP8LrQRenXU27omrwUAAqpV5y4PSU62Qr/RsUzC23+n2JH+AdCChmz9rnlidNXcn7/nxa1tZ9HAx3yd14PoqLnM24voTrnPM4BqqavO1ThZBZx7FARKYLRIyMzjP4RDkvWQojtQqlsT1uSa2g+P/oKA5UgapH5MEewruqs0Wpr6/Ia7vAwPTnblurP12A+IW7c+mPhBWlPY1TPv0HOfH3WJ+pf9e+zE0Awv4tFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKwOAb8kP41AHqUBZoyp6lG89FPi1zUZCa3F8oXwUh4=;
 b=FQKWw2Q1pt+M7wcnnXaa9dL9iKSmd62QyQnXvQfURw8O6T34suwYno5RqC7MnPv5R1exsDhgDyokAeAQm+7V7oewn5WxWaf4XS/4M/va1wE2EJ7FHUCpUSMXDT13zOgiivZ29v9wiO9diIxZlMneOuSyZhxzThYCrSNwZ+2nI3/w2mCGRNm7kElxC1rm4gl0QTQFOt01NgU1EKEUGUbQouCT9buLPs4IBwGiR5dBoJz43ZH2B7BaEQVs8ZHeGOf24VQj0DSmnJ023BRvVPHvpp4SYWRvRvOAUTxclyTyIsXKe7L2XzHuQrd31qXGMo8yOCYKRpRrO7jMOSv8x07f8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=metaswitch.com; dmarc=pass action=none
 header.from=metaswitch.com; dkim=pass header.d=metaswitch.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=metaswitch.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKwOAb8kP41AHqUBZoyp6lG89FPi1zUZCa3F8oXwUh4=;
 b=YofyMB0cvW0ECxLK1IWzIwGbv2ym/okqAeZ79El5Tiahhdj76Fb++49Az0FWSgCIqpd7LlQsuATBsjFfsUf6cyoMxcLcats1T52FYg0Q4mO6B/0+g72xil9yAPCKePugIERWb2TrOdC3hWBLhClgzro2aZIUT83EY6915fwFWug=
Received: from DM5PR0201MB3527.namprd02.prod.outlook.com (2603:10b6:4:81::14)
 by DM6PR02MB4459.namprd02.prod.outlook.com (2603:10b6:5:29::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Thu, 15 Apr
 2021 16:51:49 +0000
Received: from DM5PR0201MB3527.namprd02.prod.outlook.com
 ([fe80::7ddc:6726:dc28:5c87]) by DM5PR0201MB3527.namprd02.prod.outlook.com
 ([fe80::7ddc:6726:dc28:5c87%7]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 16:51:49 +0000
From:   Rob Dover <Rob.Dover@metaswitch.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: XFRM programming with VRF enslaved interfaces
Thread-Topic: XFRM programming with VRF enslaved interfaces
Thread-Index: AdcyBfQ6GkbT12PzSWuwRc7KPVjx1w==
Date:   Thu, 15 Apr 2021 16:51:49 +0000
Message-ID: <DM5PR0201MB3527C144EC33D8E6519A7484814D9@DM5PR0201MB3527.namprd02.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=metaswitch.com;
x-originating-ip: [209.93.55.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88c230e3-4c6a-4ee4-1185-08d9002ec341
x-ms-traffictypediagnostic: DM6PR02MB4459:
x-microsoft-antispam-prvs: <DM6PR02MB445907C68FDBE0E5F0CED649814D9@DM6PR02MB4459.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1dZeloycG4q+Q/pp689aufQpyTCzwjQknUjjKTjU61Z6sgJ82yrseQLVWuEwf2XSrJbWVbkE0nJ/yq9PW8eAAy4ojjLEwIPSUvjbh40nWDX7vJOsIPcxUOmmZRRL7Ag1xXgKuSG5INuCzhF1ga3/aLYu7tYk4TvR+GfiHSjxZrhwGlkl9RpSkbTpzdh1LB65dpiKEs8fdXskbsD1M15nInd6cD761TavYg6vNb46PAFwNv8T/qaybvst8B/A79hWU8hcW/JYXxh0HV9ISbXGrzwY2qjsjCUZTvgVVPF3nAyrgyR9YZs6PxuMRNnCQJtH3woIySXMjKmfWPOKgKAfLf4xzkHziZrPmGFYL0rM35dDpnatvaGgT/dOuA05HwU/emB//GIPHRPlIcDtjdiLNeow6EgH3DMgATp6XfheGzosdETOo3u7WaJ1N4jLnvldVOO2nJxEIVP2pM4srPZawtsiiM/ydkeu6CEFfRfGA5rP8n+oENgWT3oLMZmBODlxcMZlp9KMPD9ydyTZkR0W8V2E06GHp1fPIdJWJy+IOqnJcxt43ZhAAIDA3kEogQPmwURuN/y8XK1+clpvGTW5QQu11OM0dQUeBYZfxZrLElo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR0201MB3527.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(396003)(376002)(346002)(136003)(66476007)(66446008)(64756008)(66556008)(66946007)(76116006)(2906002)(33656002)(8936002)(83380400001)(5660300002)(7696005)(478600001)(6916009)(316002)(6506007)(26005)(186003)(55016002)(71200400001)(8676002)(86362001)(38100700002)(9686003)(122000001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?dLUQSsfY2jrq0NXAgLS8YORv4T0fznnMcYEGli44WfFlSiKxLLtROaQSauwq?=
 =?us-ascii?Q?bo9Ou/Acdzo8irUduM2X/xU9K3dvFUbEAfOh1rmnho6gsgkLLIrYsNHRQxGC?=
 =?us-ascii?Q?ewxt4r0sRozg1F2j3Duw/3LzztZV0Tra+aIBArwzWoRC+WvPaSQ3s91C8H4n?=
 =?us-ascii?Q?JUpDEia1DRwk+kc5glDy6Nnbcve8ZkKoTh0AoCeg4vzaaHOWG0cijZBtm0Kj?=
 =?us-ascii?Q?5lev1PWGGBVCWD3y0FtWM5zlKf5Pl+Uropc+Tb1WBrt9sZstSZtZ+6Pm1Z6j?=
 =?us-ascii?Q?mHoM6/JQRM3X8sLvT9QuCW0VyeAS2NRzHJIq/KoNmRSl63qTgfusmdmit+Li?=
 =?us-ascii?Q?UzaycKGEtSIwxwnpcghzkbhdMHubLFSdj5A6PvPGj+6HTYJtZ61LHcyhNUXs?=
 =?us-ascii?Q?zQoN3Dj9nb1afv5bFQ9jQflgk4qzffA1tB5V9QBchFv3N1OSPWs4iLjpVBM2?=
 =?us-ascii?Q?07HwjMjIUyk5vQFd/fRkluLeHuDqTSp71WRrSLIxAXcraymOFE5NWO0A4wHj?=
 =?us-ascii?Q?IaO7x4Ce+SjOGwaW1iw9XULI2Zu8R474a5BexoL00cVH2CWoyg/6G7ZGpned?=
 =?us-ascii?Q?Mo8/F4Hw6vg8QCj8wCwxftmUpcw/zgxgAEXhN5Amds/bYKNnRzWdHxo5fCG8?=
 =?us-ascii?Q?henBozuI4VJN868r/P5E8p6ZadjbAER3bos37Il8kFBbWTTKFsv+8pVkTmbA?=
 =?us-ascii?Q?dHS4YIp6nvONIw7EtoGXRkn2Auu/xsoLAOZLDAaHPYbIgMflmJcT1HDqBi3q?=
 =?us-ascii?Q?xXvWAQd4cTo7hkRT5EeGH08VILzgPbfVff0tYDtEhEwNrCihJ4ogAR0QgCS/?=
 =?us-ascii?Q?3OCeAeDkJC9jP0wMWuecvdfWAzgUC5Ai07o0y4aeOz+Npvd6fapr3tDbkj+6?=
 =?us-ascii?Q?oba9U399w2BVy3nvT4HQ+ynnZRJih+Lnf+F8yPf4/dbop+jC9bWBIJkFwck5?=
 =?us-ascii?Q?l75+mq+G3d982hmHQUvky2F/Oxkj5YbaB2QGzHeYh8cdUsx7tKpZuKJqA5ft?=
 =?us-ascii?Q?6A/HFoeaip9FaxCjbq8g8UZ/Ns37I4mPSsH5bvAA7IdwVtRy/JqiWLCG8Wvo?=
 =?us-ascii?Q?zsuz66o/F1iF0ieCDGuqD9paNtU6MMSnweHnlqieli4EwYZnU6dxH6EmAia3?=
 =?us-ascii?Q?bO83JUumb48Uik+yonuIpl+E1b1LijuyFnjQXgVDxcwbd+3EC8JT0/HbtYKi?=
 =?us-ascii?Q?4jCURi9l3jAt+93KKRCJUZg5cRAjHMVQm1t1fNLqbHLIqfkaufAs9saLV62J?=
 =?us-ascii?Q?XZObPMkM6Wuwg5PXSrqrD9hviYLOd3CXi9HTsmocygLYOB0Yq+fZSfBFGd7O?=
 =?us-ascii?Q?r9E=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: metaswitch.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR0201MB3527.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c230e3-4c6a-4ee4-1185-08d9002ec341
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 16:51:49.1654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9d9e56eb-f613-4ddb-b27b-bfcdf14b2cdb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yXbnpbVbjqzokqhP+wbXTjSa00BmOIoiLYqmz27ccDPCudwFWqOYk5Cz7AIJnNaeEy5f4ouW7Oaxu7DdFnZIYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4459
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi there,

I'm working on an application that's programming IPSec connections via XFRM=
 on VRFs. I'm seeing some strange behaviour in cases where there is an ensl=
aved interface on the VRF - was wondering if anyone has seen something like=
 this before or perhaps knows how this is supposed to work?=20

In our setup, we have a VRF and an enslaved (sidebar: should I be using a d=
ifferent term for this? I would prefer to use something with fewer negative=
 historic connotations if possible!) interface like so:

```
# ip link show vrf-1
33: vrf-1: <NOARP,MASTER,UP,LOWER_UP> mtu 65536 qdisc noqueue state UP mode=
 DEFAULT group default qlen 1000
    link/ether 2a:71:ba:bd:33:4d brd ff:ff:ff:ff:ff:ff=20

# ip link show master vrf-1
32: serv1: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master vrf-1 sta=
te UP mode DEFAULT group default qlen 1000
    link/ether 00:13:3e:00:16:68 brd ff:ff:ff:ff:ff:ff
```

The serv1 interface has some associated IPs but the vrf-1 interface does no=
t:

```
# ip addr show dev vrf-1
33: vrf-1: <NOARP,MASTER,UP,LOWER_UP> mtu 65536 qdisc noqueue state UP grou=
p default qlen 1000
    link/ether 2a:71:ba:bd:33:4d brd ff:ff:ff:ff:ff:ff=20

# ip addr show dev serv1
32: serv1: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master vrf-1 sta=
te UP group default qlen 1000
    link/ether 00:13:3e:00:16:68 brd ff:ff:ff:ff:ff:ff
    inet 10.248.0.191/16 brd 10.248.255.255 scope global serv1
       valid_lft forever preferred_lft forever
    inet 10.248.0.250/16 brd 10.248.255.255 scope global secondary serv1
       valid_lft forever preferred_lft forever
    inet6 fd5f:5d21:845:1401:213:3eff:fe00:1668/64 scope global
       valid_lft forever preferred_lft forever
    inet6 fe80::213:3eff:fe00:1668/64 scope link
       valid_lft forever preferred_lft forever
```

We're trying to program XFRM using these addresses to send and receive IPSe=
c traffic in transport mode. The interesting question is which interface th=
e XFRM state should be programmed on. I started off by programming the foll=
owing policies and SAs on the VRF:

```
# ip xfrm policy show
src 10.254.13.16/32 dst 10.248.0.191/32 sport 37409 dport 5080 dev vrf-1
        dir in priority 2147483648 ptype main
        tmpl src 0.0.0.0 dst 0.0.0.0
                proto esp reqid 0 mode transport=20
src 10.248.0.191/32 dst 10.254.13.16/32 sport 16381 dport 37409 dev vrf-1
        dir out priority 2147483648 ptype main
        tmpl src 0.0.0.0 dst 0.0.0.0
                proto esp reqid 0 mode transport=20
# ip xfrm state show=20
src 10.254.13.16 dst 10.248.0.191
        proto esp spi 0x03a0392c reqid 3892838400 mode transport
        replay-window 0
        auth-trunc hmac(md5) 0x00112233445566778899aabbccddeeff 96
        enc cbc(des3_ede) 0xfeefdccdbaab98897667544532231001feefdccdbaab988=
9
        anti-replay context: seq 0x0, oseq 0x0, bitmap 0x00000000
        sel src 0.0.0.0/0 dst 0.0.0.0/0 sport 37409 dport 5080 dev vrf-1=20
src 10.248.0.191 dst 10.254.13.16
        proto esp spi 0x00124f80 reqid 0 mode transport
        replay-window 0
        auth-trunc hmac(md5) 0x00112233445566778899aabbccddeeff 96
        enc cbc(des3_ede) 0xfeefdccdbaab98897667544532231001feefdccdbaab988=
9
        anti-replay context: seq 0x0, oseq 0x0, bitmap 0x00000000
        sel src 0.0.0.0/0 dst 0.0.0.0/0 sport 16381 dport 37409 dev vrf-1
```

Having programmed these, I can then send ESP packets from 10.254.13.16:3740=
9 -> 10.248.0.191:5080 and they are successfully decoded and passed up to m=
y application. However, when I try to send UDP packets out again from 10.24=
8.0.191:16381 -> 10.254.13.16:37409, the packets are not encrypted but sent=
 out in the clear!

Now, I've done some experimentation and found that if I program the outboun=
d XFRM policy (eg. 10.248.0.191->10.254.13.16) to be on serv1 rather than v=
rf-1, the packets are correctly encrypted. But if I program the inbound XFR=
M policy (eg. 10.254.13.16->10.248.0.191) to be on serv1 rather than vrf-1,=
 the inbound packets are not passed up to my application! That leaves me in=
 a situation where I need to program the inbound and outbound XFRM policies=
 asymmetrically in order to get my traffic to be sent properly, like so:

```
# ip xfrm policy show
src 10.254.13.16/32 dst 10.248.0.191/32 sport 37409 dport 5080 dev vrf-1
        dir in priority 2147483648 ptype main
        tmpl src 0.0.0.0 dst 0.0.0.0
                proto esp reqid 0 mode transport=20
src 10.248.0.191/32 dst 10.254.13.16/32 sport 16381 dport 37409 dev serv1
        dir out priority 2147483648 ptype main
        tmpl src 0.0.0.0 dst 0.0.0.0
                proto esp reqid 0 mode transport=20
# ip xfrm state show=20
src 10.254.13.16 dst 10.248.0.191
        proto esp spi 0x03a0392c reqid 3892838400 mode transport
        replay-window 0
        auth-trunc hmac(md5) 0x00112233445566778899aabbccddeeff 96
        enc cbc(des3_ede) 0xfeefdccdbaab98897667544532231001feefdccdbaab988=
9
        anti-replay context: seq 0x0, oseq 0x0, bitmap 0x00000000
        sel src 0.0.0.0/0 dst 0.0.0.0/0 sport 37409 dport 5080 dev vrf-1=20
src 10.248.0.191 dst 10.254.13.16
        proto esp spi 0x00124f80 reqid 0 mode transport
        replay-window 0
        auth-trunc hmac(md5) 0x00112233445566778899aabbccddeeff 96
        enc cbc(des3_ede) 0xfeefdccdbaab98897667544532231001feefdccdbaab988=
9
        anti-replay context: seq 0x0, oseq 0x0, bitmap 0x00000000
        sel src 0.0.0.0/0 dst 0.0.0.0/0 sport 16381 dport 37409 dev serv1
```

It feels like I'm doing something wrong here - the asymmetrical programming=
 of the interfaces doesn't seem like the 'correct' approach. Seems like the=
re are three possibilities:=20
(a) this is standard behaviour, I just have to live with it (although maybe=
 there are some tweaks I can make to settings to change things?),
(b) somewhere along the line the way the application is passing packets dow=
n to the kernel is incorrect and that's what's causing the mismatch,
(c) this is a bug in how the kernel works and it's not attributing the pack=
ets to the appropriate interface.

Any idea which of these is the right answer?

I'm running with the kernel that ships with Centos8 (4.18.0-240.1.1), so I =
know I'm a bit out of date! But I've done a trawl through recent changes to=
 the kernel code in this area and I can't see anything that would have obvi=
ously changed the behaviour I'm seeing (feel free to correct me if I've mis=
sed something!).

Thanks for your help,
Rob Dover

