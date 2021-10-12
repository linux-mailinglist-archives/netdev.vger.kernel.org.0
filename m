Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7243942A5E4
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbhJLNlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:41:36 -0400
Received: from mail-eopbgr1410113.outbound.protection.outlook.com ([40.107.141.113]:16704
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236811AbhJLNlf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 09:41:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RuijpnwRwaemVGByM+oNdTpPckXqxHydZ8jzTKUhY8M/UkJXH0N6FGsGeGxUTchHd0JypFSqD3eKPA+bEt9e7pIIzFx+g85Hldfm8hPSO/TuZoMFyYxcIhDEYUMM7UckqYHNq+srRBeDSW262hsaB4jJLI0ZxNdF9NVpgtqVPWmIbrPaK96Dd/BjuXez/CBIkFD11Pz92MbEbUnioaI6C2agYGGOz2jRKRrLmMKj7Suey9dXOje9pVjYH+mNlMODAdDAoFY+2K29JgjQpho1QgQXDAD5ihfdDhmTXOvShf/WngRjrq4qVPntzzmwFZku2/wwjw2tNTMnAuzx7S0dlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gen4tIdWtr+o26vj2QFD8pTd+yMLX6rvl18axGsR+8w=;
 b=DuzTlLDZzAAsNp7wTBJMr87RrtmWvzNXqnu5bkBkLhd4BDLMJbIKuGi0zBUQzbk9SrGKSodg7aY4Qmt1SG8wwX2sJ447JBxbdGFxVngCjJD5OrQ7+lPt0IVIM1hbSClspVO50jr57Y2r2zaAz6F+UE9tBOc31/kZ9AQ0ERCbQlaApo7lm8Jqdq8wYiX1Kc3ibgq25AZ9wGS1O6lQ+ipkdOOwy9x3WqWDv+kW8MOrMRJ6AmbS4YN7Zf1+uKydAA03QmuVKmI/V6ZskJCrAwD81nS/J5eKq80xZoSrb/das5vU1R5geTfjF21l2bQelF1NeJiakh4I6KcWnabOsLahew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gen4tIdWtr+o26vj2QFD8pTd+yMLX6rvl18axGsR+8w=;
 b=Bw/Rk6/sSd8HdJH2OX+eru3dzrmBmRbfHiIIuvEJCFeo+Z5s1ZlvFkPhQ91d26ZndiVKdobGKS+L7SD9cyvYf3/lBUJhaHHyIo5qRqOVDCVIQ1u6oBXclyajLvcvEo6mp4auuxByCMj4iINthhFkTKNx588LCEXJQFQIsOJ5v08=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB3302.jpnprd01.prod.outlook.com (2603:1096:604:42::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Tue, 12 Oct
 2021 13:39:30 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 13:39:30 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org>, Chris Paterson
        <Chris.Paterson2@renesas.com>, Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next v2 13/14] ravb: Update EMAC configuration mode
 comment
Thread-Topic: [PATCH net-next v2 13/14] ravb: Update EMAC configuration mode
 comment
Thread-Index: AQHXvaixd8lMzh4St0+QfQ9kX6MhhKvL9taAgAABWOCAAAStAIAABr7QgAHXYQCAAYYiMA==
Date:   Tue, 12 Oct 2021 13:39:30 +0000
Message-ID: <OS0PR01MB5922FD0183178493CAAA9D6886B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211010072920.20706-1-biju.das.jz@bp.renesas.com>
        <20211010072920.20706-14-biju.das.jz@bp.renesas.com>
        <8c6496db-8b91-8fb8-eb01-d35807694149@gmail.com>
        <OS0PR01MB5922109B263B7FDBB02E33B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
        <57dbab90-6f2c-40f5-2b73-43c1ee2c6e06@gmail.com>
        <OS0PR01MB592229224714550A4BFC10B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <20211011072032.6948dbe0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211011072032.6948dbe0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90516aa4-3e9b-4084-26e1-08d98d85b824
x-ms-traffictypediagnostic: OSBPR01MB3302:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB3302F7D42C2C45DD4AE4E01B86B69@OSBPR01MB3302.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZF8mdyh/vniIyS1qRwHuNLuwpaX6H36+fvdyEHxJW51QT3QQdlzB5CE2a3stnalUnrg2YvwaFjKDjipPg98EXtZiTSTYpfr4/HrM4PuVtZ+2kgfhDrbUB0Y77533ly1ri7/lSnPMt8T8YDDrO7kf3W12gPLdmULyEltMZ66UBRcYwMEP/6g/0wIIXzXxhqOvBM9P4uD15BPIURgzLXA6xUYTussXwuI++4MkOhyQlW+l4ikpmFMsQaB8SKTpUTteYkJS8dyCG2LOOGNApiQllrNb99v+HtMAne2ffmS+/+BwUNO2Eh5CpqPo3ef9Ep7Dg9pwisGKx4qQwcYrSDvGqSFAyv2qdlPJW6Z1WtLyuWEU9+QlOV34Wlrdjz/Bv6W4PMb5nK9xCoizcOg5Jz1cctTiUVC+VnQGIfbpeacN85bXmH1cTcLhR6aImTMPDbR/kCsCh8RM5wvRAyHSJOjb8fLSxF8MdJ7sOIE4mhjU4bwaXFnnPL2kJ5B1a7r16lSow5qDBGGZQStXGkNBjKYQfVRxI+0lW9Hk0nebaRk8rFMIk0rs2zX1JT0Xm7KEb15IlxNWb7NfCoGpmG4SNnwfU4a15JLdkvHEECjp0JLGK/nHZ07bH9T+0CpFAUGlOLlpmvYRGxuqozISZqPxnhy/NnsPkLRX+tiLXR4BUlo7uIXqK2cK2A6e4qDlHvk2KnVWHdfuqZGdIUOXCoRekEKDrw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(38100700002)(71200400001)(186003)(508600001)(64756008)(2906002)(66446008)(6916009)(52536014)(122000001)(5660300002)(83380400001)(6506007)(66556008)(7696005)(4326008)(26005)(33656002)(38070700005)(86362001)(316002)(7416002)(4744005)(15650500001)(55016002)(76116006)(8676002)(8936002)(9686003)(66946007)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1itkJuJJChq+9GZvGaiKdwrQRCRaaPbNOw/6c4rp7gjCqI+d2GnVda1DtH2i?=
 =?us-ascii?Q?16dNa374wgjuwmrChOBL6NSuj+iccDllZ8SU8czqHFi+kSEPYb72UgowhsED?=
 =?us-ascii?Q?v8g1+/9UNArHIv01sedNkgNpcQuRjKqrVkjBfKIGjomV98x7fbO83hwd9bZG?=
 =?us-ascii?Q?8mmKAE0QN64apw30mrz6LMvdxlJKiRBmRy3y8616Prmd/gEoAAQY+F9puBis?=
 =?us-ascii?Q?j0pARVT7LTwcImah6pjuqfIrBb0ySb3SCs3FkyUUv9NUzaLpvCdF7r8Gbr5n?=
 =?us-ascii?Q?GHba53g0p+7V2NdhfhNhmrHNiNseUL3vWuEFGKWT3AvHjllsYEpKhW2wCrJD?=
 =?us-ascii?Q?hqW5B8mjQx9y/4SAQ4NJiXRCf7sPrX+nkM7zYSc7vf65sJIRSki7q/XdvZ25?=
 =?us-ascii?Q?w347EPKkbhHX5ymTZop30JRk8ttIEVUQW8iNDEnUygcuQpVT/VzAFnxYLjiy?=
 =?us-ascii?Q?ImggAtpzPOMWTe2MARMg4K3N6/CUrBc+dU0oNGVSEy3YX0fakANCoDpEdG/r?=
 =?us-ascii?Q?m7FbtAq2sKvnhbM09p1REvPOiVxtisH332XPh8+AL6UG6X7q44cXzeo5sDvt?=
 =?us-ascii?Q?2N9EQj5jFlUOFk7k7SPG0p96wIe1kPyVinmn0Q3E21g8bGOjs5/IGOtdQCdu?=
 =?us-ascii?Q?U6OEioRtROTu8e4hWmVm4a9K6dZc/cp4etpVNwcVam3GCj+gtACwM5uYgi7X?=
 =?us-ascii?Q?VLSPL+XI2wumGsUlbppm06XAcfjZ/YMGRKehLiE54zmbe+/fVIFfhIhW0dTw?=
 =?us-ascii?Q?xqHr6xEz1P3oFiv7A8Dmq+bXQFSEFsG22wH4rzl7chef6NVEyRm+fA1x0Rr5?=
 =?us-ascii?Q?93Tuk1moC4h6CKFqtAREuwKF7A+FHtV9aL6rnMJgnVmdvFO9oZ7FGoyvI77I?=
 =?us-ascii?Q?kTCyFuLDTM0u9jekqbVXhPnwiEHtDT6yyYevjAT3xFfxWhDKUfPnqDOGASEF?=
 =?us-ascii?Q?aFVSkjWqyCp4zm4DcJ3276QdIrSOrnBxpZbjmZEvbZXhrwpcRf/sfRB9onU7?=
 =?us-ascii?Q?2pvEuJyF5O9kxBGh2yKgcUaosI5emcWnDQhaV6H9gW08nsK0sVp59nIcxk8k?=
 =?us-ascii?Q?L2Tg9ya/Muy5s0CZ9zJodyGyEWpzK1RXsm14yNpFwv0m8i4l0ubyDH2j4S53?=
 =?us-ascii?Q?is15PgVeJXv0wi/8EenV0CXFQMd3gMb7dWwFO863C3KX8QSaWpauUK6mRgNG?=
 =?us-ascii?Q?S1Y/C4ReWBkppM7Bx742ygtamnuhOL6LkZMkrQ+MNjNiFr2P7ga7AlC4TifF?=
 =?us-ascii?Q?lKy7pvNo/w6k4kh6H6uLAm0IVhYoUAVHn8hGsb6y80aVI/c2ZzjiyznSnK/P?=
 =?us-ascii?Q?aaw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90516aa4-3e9b-4084-26e1-08d98d85b824
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 13:39:30.7467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9OPUBZ+wOBlm8+vRZgd4w6ieDr6rfOfO/zjdL7G34uZKGiy/J8oyX3DdX7TNWIbeEHuJXGtnQMpzNjRcBwSI4zX0y6QecQqFC1qOXVN6ZG4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3302
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub Kicinski,

> Subject: Re: [PATCH net-next v2 13/14] ravb: Update EMAC configuration
> mode comment
>=20
> On Sun, 10 Oct 2021 10:56:32 +0000 Biju Das wrote:
> > > > This is TOE related,
> >
> > I meant the context here is TOE register related. That is what I meant.
>=20
> Did you test TCP packets with bad checksums? The description you posted
> earlier could indicate this is about dropping such packets, not about
> address filtering?

I have made changes similar to R-Car for HW Checksum on RX and passed wrong=
 checksum(0x0000 or 0xffff) and it crashed the system.

Regards,
Biju
