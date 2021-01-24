Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6760301C5D
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 14:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbhAXN4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 08:56:42 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31860 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbhAXN4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 08:56:40 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10ODoV8w013406;
        Sun, 24 Jan 2021 05:55:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=gDRWO1pyjI5pRZfv0nLE/+CUuaHjr0pyJx1yFCeuWHU=;
 b=jv5Ij82UAJ7wgN3u8vExNh3gUWUVGkGzJva/x9LeeWF5gq+oDk/PxBKHFPlb/IlTcl1b
 TBIuLi9Vnru8nfFWPbpvvRMNQdiLjf04y716CVCUAEd3PyKCcfapTCLAStWzmOzGsIh6
 MNjl4uZWFbSBYNOwvN6ctZ/lfrAeQDwKN4DNfC6O+VIcHoX+ev0+nFKIl7etuMu9vwap
 I5LttPX3H0p4tu2JeqrKF4fl8Ovqhj3Er4zH5h2mdx8y1nkRZ1qnzGMKsSdVM1pNoehv
 ZJTsvJcbVpKFEavRDmwwhiY+IA6rMhLwF+q49VuwVG4TmGQiVwa0YJLguRcHjjKEqTa1 5A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 368m6u9yaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jan 2021 05:55:48 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 05:55:46 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 05:55:45 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.55) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 24 Jan 2021 05:55:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJJ4cZG/8c8BygEFz/V/OQO9c8q+Y8fFRIvr0R/S4v+LpIyclEAeD8GuVXlOLhIJHUtQQv7MXV+kKTptc/aJMZcsSaTM8tRxfV7UO5rVVyDhf5UR4zz8g38GfeGL1mThw8t/xSc3Uj1sRE8f2520G+/RLqK2Uc7wgLkM43UrNz2YFFeAt1SvakYJ6JC8s+7HTqed3D3tauiLrdL6tB/athbQx5IO6OXaMEZ4ak9y2sbfR5u6YnJLsYLSv8BXZmN2DJNasj7CFTcsGNZh/kKMcbS4vBTZPYjOdy/i9/zFkOkU3M9Qh/N11J+dnxeOZN1ZxTSroIFYAR63ZQPssKmtzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDRWO1pyjI5pRZfv0nLE/+CUuaHjr0pyJx1yFCeuWHU=;
 b=bVhHfzcoHB5o7Po3nonZoJBgqx4MGFoZrcrInY9aQwtHLa08aRWxWrBnzQdkzFt//3pVA0aWYiHr4Bg9W36Jx1rtI5MLRj6bIQnkn2Nk/PaT6oWi1Xfd5DHC6km5o/3BwuJWqOZ4U1L0iqOjRXcVGHQyqTF1fJ6JcmV0cSWbycVqclrar64d/f6t1avnNmn9WYjzPoM+QbeyD37Lg4Y6kieXOcuRiLqzQcsOeAupnEmWdRLBYXclMwmBuY2OUBggpVgrqPIQwBUEpq1PjgwrDIVL+79IMqhQCDtXRLBFm3RYvMnOWPp6BEceBxqgfClUULbqRmTOjUqeBCRj+8waXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDRWO1pyjI5pRZfv0nLE/+CUuaHjr0pyJx1yFCeuWHU=;
 b=jvLeOTOSvjJMUhrbTYfJBOTgkkpPNH+Aw1yd8UmJ86iozpllwUKMVmy3e8WhbHj+pUZ3ogMwiQ30D3G3bHny7IXPTEmVZqtyavxiQ7x8mup7YCBtBuChkVB4OCFPk17lo971vqIBf979807dUcwbNSLeL4k3U2A69vdTY9S1hDw=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB4083.namprd18.prod.outlook.com (2603:10b6:5:348::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Sun, 24 Jan
 2021 13:55:42 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3784.017; Sun, 24 Jan 2021
 13:55:42 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 RFC net-next 04/18] net: mvpp2: add PPv23
 version definition
Thread-Topic: [EXT] Re: [PATCH v2 RFC net-next 04/18] net: mvpp2: add PPv23
 version definition
Thread-Index: AQHW8kZchLujdtMv9Ea2pwqlGkruZqo2wi2AgAAHuvA=
Date:   Sun, 24 Jan 2021 13:55:42 +0000
Message-ID: <CO6PR18MB387343A510B3C5A9C5E004B2B0BE9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-5-git-send-email-stefanc@marvell.com>
 <20210124131810.GZ1551@shell.armlinux.org.uk>
In-Reply-To: <20210124131810.GZ1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.11.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5270573-a0ee-47cb-fdf8-08d8c06fbd7a
x-ms-traffictypediagnostic: CO6PR18MB4083:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB4083129FC2DA00FA15F5EE80B0BE9@CO6PR18MB4083.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LBMfVdeJV1+Aq2j6Jmx+EGLz827ANpD8D5cfi9SKyLtDAEYEdWgyuRnOfsOQtbXvt825eKnR2iOhz0RbkgeFXFGDvlmqwpBbFSh5Qhyi8/s1pGzrulo214be8Cfpjl9nfQKlUHCvyq/ajIZkVBxoWiWI1eV75eV/OKUPIoWCnrfLTS8SOepAZ589+2gZAGnfqjhXQkgqPgoS029meOHDF5w1MAs2vs8Jg5EOF3GZjhC/EvlDnwZbZA4RGvabXiFtooTswd7ZmnH8RfP0pPg3ROIpsqivGq5ZEnzwagytpZGKjoPTLomqICBhv/+LFgsZZCVrdHoALUnVOQxsRtSOxO+q46Ry2D8ytoFr3tjjM7iWhFFi3ROzp36Di6OE+YvAK+hfw4XIfzRnRlbR5WwejQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(71200400001)(54906003)(33656002)(6916009)(86362001)(316002)(7696005)(4326008)(478600001)(83380400001)(8936002)(52536014)(5660300002)(66556008)(66946007)(186003)(76116006)(64756008)(66476007)(26005)(2906002)(6506007)(8676002)(55016002)(9686003)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ko1Uxy2iEdl4JepbDkGQQPIaZ/666src+KLAPJbhHj/A/bm3cZM3ZvSaNGWt?=
 =?us-ascii?Q?HBD6CKsqm/PqJLXzMKNMmspH0r9hfSWaZjL9XPAwqpoMOlPb4uGi+7cVH18B?=
 =?us-ascii?Q?P3lu16UKLZo2KvPYf4S7WS7zIHUnqsb6ltvrgGRDuBRWxq/4cxTzVpZMyooW?=
 =?us-ascii?Q?L6qOSU8EQuSjPcCFXm5BCwD6ZUKOeglQyMvNaxZM4Ig1l5H3kyAU44xR9V0o?=
 =?us-ascii?Q?JTf0a7XT2KG5rhRtxMhS7nORjCVCwxd0uVJGIEvuhicdT2NJshgrEZ+HXvLD?=
 =?us-ascii?Q?HnUTkIcCHPwDiwdd93QxCM/jVajyq+bIMeZxuJ8pGnix1si0aZYy6b40E4At?=
 =?us-ascii?Q?HdmZT3fTdVOe3/h0kU0l2NudZGtapi1Gb2KOQelCtDWjesCp7kgmqM6Q64Sa?=
 =?us-ascii?Q?x0M3xwKg2d+7RsvJvNLLo2V6JfytO2oAE+9RoUfeWTYomePf6q6K4gf9TnCJ?=
 =?us-ascii?Q?O/00CCbfLIJHTdOycRrs83NvP/8c/cLeaT+mQMIDxVikaxOMO4skZSSYxmn5?=
 =?us-ascii?Q?3ScRjqnQpcvi519aUZbnwqVZ0I1oghgo8PaIELLc1JCzRiSbH16GSczVDsZ4?=
 =?us-ascii?Q?U2eUpNkLkiTbjXk8cSbdDirU+0aTC/rUw2n7K1bu5ubK5SbOpmBkZX/aCknQ?=
 =?us-ascii?Q?J2t6os4HAaIA+03BzD64T2gIe93yRCYv0lyH1tH8D4i2FKaKq8kBeBNbPZpZ?=
 =?us-ascii?Q?WOeR7Y6WzGlQRdae3BiVjjWk/O9jUil6afnI00RiiCmi0q6cPgSrjj7UQY6v?=
 =?us-ascii?Q?BuXSmnSsgsXlc+33WWANGk5gW6w0Gv2Q0Z8VnGXfHcG4esniK/+ITR/AkSp9?=
 =?us-ascii?Q?T4Bjw/4JfNU2i1MvMUwIp6fKaBCRYvsmlPZmpm6KsVEDk19cZMxdDgr9QUzf?=
 =?us-ascii?Q?gWaBNWU78ABrCez27gHvTpL+Z1TH2cPOn3rSr2MhfOZw4L2WfcJK3Wgw2kDa?=
 =?us-ascii?Q?Qufvs+4g0c1z/UaafAeooHAz1HUQM+1Gily00T8aEjD9B8IvSaz9nhwSYIhb?=
 =?us-ascii?Q?H7bd7+k5+wqZE1K10VnlCMfGTLvOlrgR8gdrfRZT0BBal1/Lsw0GTXn/9G74?=
 =?us-ascii?Q?9E1kxGQ+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5270573-a0ee-47cb-fdf8-08d8c06fbd7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2021 13:55:42.4209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X1olaiQeZvXX4hUtLnKcdTNPnaKTlpqFMZZ/IA2R4/qsxry1+xnzpcz06J5IlJ4unzCANOWykJEXGL/3YqKkvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB4083
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-24_04:2021-01-22,2021-01-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> > ---
> >  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 24 ++++++++++++-----=
-
> --
> >  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 17 +++++++++-----
> >  2 files changed, 25 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> > b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> > index aec9179..89b3ede 100644
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> > @@ -60,6 +60,9 @@
> >  /* Top Registers */
> >  #define MVPP2_MH_REG(port)			(0x5040 + 4 * (port))
> >  #define MVPP2_DSA_EXTENDED			BIT(5)
> > +#define MVPP2_VER_ID_REG			0x50b0
> > +#define MVPP2_VER_PP22				0x10
> > +#define MVPP2_VER_PP23				0x11
>=20
> Looking at the Armada 8040 docs, it seems this register exists on
> PPv2.1 as well, and holds the value zero there.
>=20
> I wonder whether we should instead read it's value directly into hw_versi=
on,
> and test against these values, rather than inventing our own verison enum=
.
>=20
> I've also been wondering whether your !=3D MVPP21 comparisons should
> instead be >=3D MVPP22.
>=20
> Any thoughts?

We cannot access PPv2 register space before enabling clocks(done in mvpp2_p=
robe) , PP21 and PP22/23 have different sets of clocks.
So diff between PP21 and PP22/23 should be stored in device tree(in of_devi=
ce_id), with MVPP22 and MVPP21 stored as .data
Maybe we can do it differently, but I prefer to make this change not in the=
 Flow Control patch series.
I'm OK with both >=3D MVPP22 and !=3D MVPP21 options.

Regards,
Stefan.
