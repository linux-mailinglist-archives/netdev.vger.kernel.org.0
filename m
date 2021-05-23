Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAF538DAED
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 12:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhEWKzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 06:55:41 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10308 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231679AbhEWKzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 06:55:40 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14NApMdI007871;
        Sun, 23 May 2021 03:54:09 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0b-0016f401.pphosted.com with ESMTP id 38q1fntdv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 May 2021 03:54:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJDW4/pJTE/HDyE3nXjSgXZ21HmRsP7+gz96iNS1iQai3w5k1/GYNRrp+kGQ1ToC6SaYnmlmAd2pU7jU5G5ByHnjPgmozCzdUuE/6VjP/cCUekqbPLrBqus5xsTwRfUmeuGyC9nPylg1qJkzXBJu1hgeCwx+SUdeLdzLax0PqXFVlnYl8l2dsNm5vC4l9w9I1frdPXh3/JYf0Z+ONgkG+NA077+GvfRy/qQLqcwy3aKOW8LsHpr0ah8j4nhuBer0tJ7ijVneoKbniI4GgPKO2fuS7DSAY17RqmHbi7FQwsc7SMjH0fmXNyjXn9p64Mwj4TnvR9E69FJ7FTFy0vjRkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6O3/N/Sx3kTIDE4xoXVzF7M0L9mTj+SVaZ6vZq5A0c=;
 b=M9Aa1SN+f503UQFMnp49jLYsXjj0V6B9an//fmt388qZ2gdtXknZqfE6E4kxExspmfpVz6bOL/Z9G/pazB/1fy5RaT/SIxdKAKeI0BlQHUpslFULJw7L877zy9BIP68bGRKhfjkdP/KghaIT07thcFaC0WuFXfPal6v+vFOAUKhrIDRjfzdGBulZGKQAMHnnb7ivLPLEa9pYda+GX2SeeNHN5BKeqc6Pqh8Fn61P1ErI6I1Gjj9DK5BeATclHMrZ9yqXf9ltqVG0KIbxYXUoGD5p9P37GY0UVtzMEQKOwUKQoePRU9BXcR4lRVntlBrkfbS2QSn9aECX+jHYrmKCSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6O3/N/Sx3kTIDE4xoXVzF7M0L9mTj+SVaZ6vZq5A0c=;
 b=gh3+LchzrTBSvqfHWW4el7GMX35jaMMc1ZMW0DoACI2Fr6hyBxCne3y+83TwAsiiJTDNoTbO7+6JiLKi4zrjTTZ+PBYtTnhGaceSjsLOrZpicoNFzun8dA5phB7SGjNySvERrUAAURCwSFxBy+C0TZYg+n1OIzw/9gxehxyhNgQ=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR1801MB1854.namprd18.prod.outlook.com (2603:10b6:301:6c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Sun, 23 May
 2021 10:54:06 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::5c49:f037:f7da:96bc]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::5c49:f037:f7da:96bc%8]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 10:54:06 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Marcin Wojtas <mw@semihalf.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] mvpp2: incorrect max mtu?
Thread-Topic: [EXT] mvpp2: incorrect max mtu?
Thread-Index: AQHXSMEeOB8utqlMw0S+5lVqOciSAKrow/5QgAA+egCAAAh9sIAH0W3Q
Date:   Sun, 23 May 2021 10:54:06 +0000
Message-ID: <CO6PR18MB3873C192E9E00100060444B5B0279@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <20210514130018.GC12395@shell.armlinux.org.uk>
 <CO6PR18MB3873503C45634C7EBAE49AA4B02C9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210518094134.GQ12395@shell.armlinux.org.uk>
 <CO6PR18MB3873FB0E037EEE6104FAFD80B02C9@CO6PR18MB3873.namprd18.prod.outlook.com>
In-Reply-To: <CO6PR18MB3873FB0E037EEE6104FAFD80B02C9@CO6PR18MB3873.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 932cb391-987f-41aa-3f0b-08d91dd91635
x-ms-traffictypediagnostic: MWHPR1801MB1854:
x-microsoft-antispam-prvs: <MWHPR1801MB185449AC379E9391978187EAB0279@MWHPR1801MB1854.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WUCTF2v9j6V7fpl1vf5HFpuLuAWBd8Sb+TbZqpYuDeLWlVeHDoKuUD9jYTVlswjBkTu7+wle/VKm70X6QQBBi04yWOdUAL+Xw/rOB2ORpFKUAGEc/X1G7JNdLnJidQa+mnKq/bCEdrWRlTR4PATUESgPUNrSm/E6Ibre0l6Ny5fLYU7w5gF/5TgLing83M+W/J+MZOx4JvVwFAmTOUsNcz/EDc4KAieP701+eG84gB8focA20rBoSUg4jxJMAbSjINieosRk3DkvspuGM6XrFRxu5hlbkpxzxpVnYBBf9WL/m+TCOpsDLh+WEbx8eS0/LVD3rNWtjGG++1W+2N14vB5YSYvxYwKjAdpPPYUCNs41VZ6l0q6h4QW0mbaz00lTIJ0Ayqpn/xxwC/67YIk1olYqF1iRjrCmtBsOWkMJeyyYGOMjF/3cSamjPOSXiqF83mwTagXTqG1AFR+GYZh4VUA5RyHLobbLdgce7HDUbFXXKd4JtKkuV6PGegofoeHCAT4I27toXFsA5G9FbuSjtvvbFQSsJVCgJkCWJbFTv+gYIoel9d2oxf2dkZQvmJBje/7z8Vvc0fO/Q9Y7+I6tnnxmrhiTavnJpy8Q4gHfY6U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(39850400004)(136003)(396003)(2906002)(26005)(8936002)(8676002)(66946007)(66556008)(64756008)(66446008)(9686003)(52536014)(76116006)(53546011)(5660300002)(6506007)(66476007)(186003)(6916009)(83380400001)(7696005)(86362001)(38100700002)(71200400001)(478600001)(33656002)(54906003)(316002)(4326008)(55016002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TWVH8e7Mo2l4+g6xeGmpeKWS+H9HbPTVNBeYip+dMR+0gBfM8wm0SjKiz5o7?=
 =?us-ascii?Q?yygRlL2YnvHkeoizosEi1KbrDkYOiDpUWfJxPrldW0xj3PzYLn9AkzIniqJF?=
 =?us-ascii?Q?+dzgFheJTcHlVgW3Jy6Y6eN36uiLBalerKGhF0vCG/Ut3LOnzyLerVTsM1KA?=
 =?us-ascii?Q?twpoIdAO2lJK0EMHURAnxW7OlFjRDxnuMZwDL+RvoYCsv8xisDoAQLHS/r0P?=
 =?us-ascii?Q?+GN6OI+1UxCbrnr3W/vctLRjEMxptXO6kH9Jki564KB/j6m8Lh6P0NrK/bc1?=
 =?us-ascii?Q?lInM8t2neN2bxGUnzkSp6WlAaI3xTUWbdXTMOTrpH6TJ8BOLhAW7cfLBl5IE?=
 =?us-ascii?Q?YdLO6kJy8qAPi56svpcZ8VP2nRCSrE4ldKxmGkAiWjtIcM+QS0M0MV9Hq3SS?=
 =?us-ascii?Q?ti5+GTdIoMuwsHTjF413ehaDRVVqShjCGtzxgdNyt0WAw5oyxqQ0TgYA9EK1?=
 =?us-ascii?Q?dH80PVhWz9ZbCaEPJrOH41fusqABhHWZAFyxTT5QFYSdKC5c3+6U5tzfxCet?=
 =?us-ascii?Q?FUO9NXMCdLGYc6WlVQbVDnC+K2S/dypP6YyuQub3GcOM6Beg97wZwTY3biwD?=
 =?us-ascii?Q?YEwcWnq5K8Y/GPd4OzzHvnH47lo9K8YXoWjDg083Deq4rrL1knOm6MEZqZs0?=
 =?us-ascii?Q?DzUlp94FzNbAqFDOIQh2g2GeKxNI0BoJ2AXAhCMsphWZ7QqBhw3WBDMkWM5g?=
 =?us-ascii?Q?Sq7BfCzh1ImaqnsC1qxcXhFoQT6Z7f6macb+zKpA4Wla7/+ftrmcm8Atq54f?=
 =?us-ascii?Q?9SvLG9BdAOYNpymtEyQvUw0u4p8CdFubBjYf2KPO93672THJL6RQHXh4POWg?=
 =?us-ascii?Q?zBnflx2l+KKotVlZLdalFUb3ikvRCOEJSVm1r4qnmxazzXvG+uBd0azXJRuh?=
 =?us-ascii?Q?ME6ErMhveWsbFjKsyd49ndg4VJLfMtARVfZareKDTZ8Tvh0BwvzI0YhOK1Y3?=
 =?us-ascii?Q?bMhaWOztK/Sz0ET0GbS8A5Jw2pBsvYvwYwPcXL8IPfwC37qvtH3JxFvYT1ab?=
 =?us-ascii?Q?XTU2d3unmS2mtsuRpRZUUdJJerPXne55q7IneH1vDEGt9Y38s/T8rD4ogR1p?=
 =?us-ascii?Q?tsAP62zOSduagVBKZGnT+3uTmmOYq8gILAvihnSJpKd2IoHQFtt0hErAQuHQ?=
 =?us-ascii?Q?Ug7GX28AU4PdAGq1Ne3ds9tQSW16fc1vkO4IdffiRgb/u+V0wE6Ssir2wtlr?=
 =?us-ascii?Q?RZEXgvc/+tSaWZrjCtMz/PhP+iUeKUPqG4bJPlFTwZMYVYikj8CkWaWKir/g?=
 =?us-ascii?Q?fnoGKghGnLtjEFqkYx374UbiwYL4wyk7UXmHxSjin0xV/iJFPRSS2wwxgbhJ?=
 =?us-ascii?Q?vEs=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 932cb391-987f-41aa-3f0b-08d91dd91635
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2021 10:54:06.5590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m4h3WA3YPmmwUsg4AhPKxbQ9Tn9fV5WydFQVRW+nRIbTg5m5C3A9dxhUa5k4pmdDcPZLxR0glj109d9EoFEzlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB1854
X-Proofpoint-GUID: NYqUKm7Qo8dP4cHgq1ml0lHIubVkoGGK
X-Proofpoint-ORIG-GUID: NYqUKm7Qo8dP4cHgq1ml0lHIubVkoGGK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-22_08:2021-05-20,2021-05-22 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > -----Original Message-----
> > From: Russell King <linux@armlinux.org.uk>
> > Sent: Tuesday, May 18, 2021 12:42 PM
> > To: Stefan Chulski <stefanc@marvell.com>
> > Cc: Marcin Wojtas <mw@semihalf.com>; netdev@vger.kernel.org
> > Subject: Re: [EXT] mvpp2: incorrect max mtu?
> >
> > On Tue, May 18, 2021 at 06:09:12AM +0000, Stefan Chulski wrote:
> > > Look like PPv2 tried scatter frame since it was larger than Jumbo
> > > buffer size
> > and it drained buffer pool(Buffers never released).
> > > Received packet should be less than value set in
> > MVPP2_POOL_BUF_SIZE_REG for long pool.
> >
> > So this must mean that setting dev->max_mtu is incorrect.
> >
> > From what I can see, the value programmed into that register would be
> > MVPP2_BM_JUMBO_PKT_SIZE which I believe is 9888. This is currently the
> > same value that dev->max_mtu is set to, but max_mtu is the data
> > payload size in the ethernet frame, which doesn't include the hardware
> > ethernet header.
> >
> > So, should max_mtu be set to 14 bytes less? Or should it be set to
> > 9856? Less
> > 14 bytes? Or what?
>=20
> Yes, look like dev->max_mtuis incorrect. It should be 9856,
> MVPP2_POOL_BUF_SIZE_REG,  Pool Buffer Size is in 32 units.
> But before changing it I prefer to test different sizes. Currently, I don=
't have a
> connected board.
> I will connect board and perform some tests. JUMBO_FRAME_SIZE is the size
> of the buffer, but packet offset should be taken into account.
>=20
> > It is really confusing that we have these definitions that state e.g.
> > that JUMBO_FRAME_SIZE is 10432 but the frame size comment says 9856.
> > It's not clear why it's different like that - why the additional 576 oc=
tets.
> >
> > All of this could do with some explanation in the driver - would it be
> > possible to add some kind of documentation, or at least make the
> > definitions around packet and frame size more understandable please?
> >
> > Thanks.
>=20
> Yes, definition or comments should be improved.
>=20
> Regards,
> Stefan.

We probably should split this to 3 issues.
1. BM drain issue. I can post patch witch should fix it. So after lowering =
the MTU you won't have issue.
2. Regarding MTU max, here we actually talking about max MRU not MTU.
MRU set by mvpp2_xlg_max_rx_size_set/mvpp2_gmac_max_rx_size_set port->pkt_s=
ize - MVPP2_MH_SIZE(2 Bytes).
port->pkt_size =3D MTU +  MVPP2_MH_SIZE(2 Bytes) + VLAN tag (4 Bytes) + ETH=
_HLEN(14 Bytes) + ETH_FCS_LEN(4 Bytes) and from some reason aligned to cach=
e_line_size().
So if we set MTU =3D 9888, we actually get MRU 9918.
3. Fix all max MTU comments in code.

Regards,
Stefan.


=20

