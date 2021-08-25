Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDAB3F71D4
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239654AbhHYJhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:37:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23280 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239517AbhHYJhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:37:52 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17P6e3Zc014197;
        Wed, 25 Aug 2021 02:35:02 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by mx0a-0016f401.pphosted.com with ESMTP id 3angt00mag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 02:35:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jbxsm6ZlBaQ2zUEyqGM80rXlFDk+eNi8Ib5ZF8Xo8jAkkd1i2Ky+yNvOsYR9U8yxXJsM0pB8KcPXUygx4YyVV3SlQqvDiiaYyv+ZbOG2wUMdABObTP8ezW5we8C900EdrLm9pGRF7Xd7Sk9U5n6eu9f8YMR0hBvr956AfCGyeHF4AjbTt5dP2Wz8iFIxXicx9jv2052MVdj+crtVhkPKj7GYdghQ9pkX1gbhPYQz9mFsFR5Hw0vMkC5kZ8QbcS/KxfouCWeHQa7BcyGL3sAZIoobAcW1/jBAyaSCRUiM3Tep/ttCIJMMeM6cebYrXo/Hm9BmmQDukTBXz2rcT2KVpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shIfwYf1W6ZUuDgUwTj1C18ClkhNDwyj3mVCutBNX3A=;
 b=IV/f3dxu00lt+19PggCevzT1ER3r8Ea8946Oj6fLjH1gU6kbKhuSGos7c5i+u7Qb2e0dtWQcn7sHg2CCt137JSe7t60udSElnGgG4f8Z/uP9+G3YWAUcIza//3Gpzfm8Pt1OuwYEV00sgWOANGUqPVmSpZXUkw3tZPVvk0VFUNQ5jtD9vXKIJSXEKRG8G7rREXDC2aEYBRyHGFBWeaH0xDv/Ot237adPeuGhsKiC5qcmDFW0pSEDBJGAfO0rsPhsZ0xMFDCd3la4KblXGQ/gnSNbVVib1DBLA4fAi61HZNabOL2EEqh63lAZqwBLp5AlPgi80hk4RV2OItx6V0LzYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shIfwYf1W6ZUuDgUwTj1C18ClkhNDwyj3mVCutBNX3A=;
 b=cnPiz0NLg8zD4MKsNVivognBRvmC2bsNHgTMHIW7xz8EuFW8HNfIyjLEyReUF1RNu2ky4S7I9Zg9ghLrkfAa5x7ZnPW8c5hhBAGEM1KP8mfbbagwRv7gzjXFUmubMQLrDQuA4UY2JniE1O5GEErnkqHvjDt/LGDjxIz3BUnE+M8=
Received: from BY3PR18MB4641.namprd18.prod.outlook.com (2603:10b6:a03:3c4::8)
 by BY3PR18MB4785.namprd18.prod.outlook.com (2603:10b6:a03:3cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Wed, 25 Aug
 2021 09:35:00 +0000
Received: from BY3PR18MB4641.namprd18.prod.outlook.com
 ([fe80::bc38:940a:28c3:7e4f]) by BY3PR18MB4641.namprd18.prod.outlook.com
 ([fe80::bc38:940a:28c3:7e4f%8]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 09:35:00 +0000
From:   Ariel Elior <aelior@marvell.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Leon Romanovsky <leon@kernel.org>, Shai Malin <smalin@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] qed: Enable RDMA relaxed ordering
Thread-Topic: [EXT] Re: [PATCH] qed: Enable RDMA relaxed ordering
Thread-Index: AQHXl4dCntCauhMEGUiY44ZhI+K7ZKuA+5qAgAAcTwCAABQ6gIAACNcAgAFiEgCAAHEuUIAACQiAgADmcpA=
Date:   Wed, 25 Aug 2021 09:35:00 +0000
Message-ID: <BY3PR18MB4641FFF30A6F424889A4B0E5C4C69@BY3PR18MB4641.namprd18.prod.outlook.com>
References: <20210822185448.12053-1-smalin@marvell.com>
 <YSOL9TNeLy3uHma6@unreal> <20210823133340.GC543798@ziepe.ca>
 <BY3PR18MB46419B2A887EFFCB5B74F30BC4C49@BY3PR18MB4641.namprd18.prod.outlook.com>
 <20210823151742.GD543798@ziepe.ca> <YSTlGlnDYjI/VhNB@unreal>
 <BY3PR18MB4641E80F8ABF42A5621B7573C4C59@BY3PR18MB4641.namprd18.prod.outlook.com>
 <20210824194223.GG543798@ziepe.ca>
In-Reply-To: <20210824194223.GG543798@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ziepe.ca; dkim=none (message not signed)
 header.d=none;ziepe.ca; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c80ca423-9476-428e-913d-08d967ab9c05
x-ms-traffictypediagnostic: BY3PR18MB4785:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY3PR18MB4785D7C54A2A11E5F9D55493C4C69@BY3PR18MB4785.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VO+ysMaDwF8zSynTqXUCJItm21qdsYM+PpUgEGqC/498itUuLjpt465n1yvGrthvYc9/cs7HBwXQcWh2TsgOzZdZ75eXhMjg+6u5EYhSJ6ZCJd3wCyuI1E1iHtZJ4dSTpVY+16ifSvVmb+126ieyvqydYHZI17VKV4NZr0sMK9LuIlpZyygTuwQuhtZFIQE1cnHqxOTm55r2vhbWJHTEcLY385kXRhImC3V7bgexp3iAEeYsmJYiONDvn11PHNRQDLNcsjm22KfGJNjdgEuQrXJCFsoCSIzZi302FvhTpoYkpp+eCQDd9CfvkoajByAZboOYgAt/wMM/lBOywBamt29WE3EZrbSfchQD1Dc7jjNbV4F4Vrtw6ayrxEwrxrZorSERkZjcW3hRqB1qzpgsRCikcWVFJxVpGbcVrG35kk5/6uDtiK1dfE3UeUhNE1I7N/LXHlt5tL1Sq3FV0ejul6IKgX8mjnPrvh6+vWQFxFq8FljdufL/gNh+NWZoJ6CrwD3cSJlxCeAQwaKKDTmXSytKJexZ8b+FtwHFBfb8S29GDLo6mp9wvOdfMSCpjJ+ydRajhIndpBgmH9m+JeLKdwbfCqaRV2Zoi7+m3YuTSFRcgC0NR/M4Tl/hxPneQIkhKCrVBlKeenRtlHXwEEHgVHXe4cfRggGxl5P55SkTeNl5ZiPBTSz81jJcCf5g3I4lRSdbCZ1gtDl49ISWit4ocQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4641.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(8676002)(316002)(86362001)(33656002)(54906003)(38100700002)(53546011)(478600001)(8936002)(7696005)(186003)(71200400001)(26005)(122000001)(76116006)(2906002)(6506007)(38070700005)(5660300002)(66446008)(52536014)(55016002)(83380400001)(9686003)(66946007)(6916009)(66476007)(66556008)(4326008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5jxEG93X3IjkJ1KaIk7ul+3efJKvGvW2OxzriXUVVZmTm0tJ7nVD5yedZ4gB?=
 =?us-ascii?Q?uDp3vahQHcwmRf6aHF14YmSsT2LHWUcnpqo8yH6XcsealoJ5IhTlmyRZbXIP?=
 =?us-ascii?Q?hwWu+MK20tmd8cFH9+p+SY0mOvDL2zYsQrJ0WDkxQoH1Ij0orAxVVy+RGJl4?=
 =?us-ascii?Q?F7cGQizBg8cSV1IJ0tFOklHet5SPgH1DF52qYlQTpfjUegShTrLtpK2zJlDI?=
 =?us-ascii?Q?9w85xILekdS89xd1zwNxrONnAniZCQq5yn9GgHKt1TyUdZQJMx6qxnD/LKBD?=
 =?us-ascii?Q?sR85lJrBryOOE7TTOuS16B9lG9suNLT8LXvkGz65nh7/WjdKNEGq3FpIMD54?=
 =?us-ascii?Q?y2y+ZIiVM7V2gmLd4R6XhmKoAvAaTYerNIhnzoRlzDJYty31JPSCSRn4qAL5?=
 =?us-ascii?Q?9kUIQqle3XLU2i6QUiATWqHtZMn5YEmhViFOHUJy0AjymuJSumRTDp3s/UsW?=
 =?us-ascii?Q?+gE4Q6UHJz+eIKbxU7RhDXL7aRXhT8xcyqyLGsqWRtia9qUZvgiIQA6Quzpj?=
 =?us-ascii?Q?5uec+mgncrUgRXXJ+cUC9cdzKYnbVWGxcz16XyRNvuVO0/wOriegtQ4ckYQV?=
 =?us-ascii?Q?s4MFeuzFe60EuKT5hWKo3rehle+/xc5DTNxuZrC3cw9EXKWZgUzLOciHSh77?=
 =?us-ascii?Q?7Ao+AmnTKbhsW6D3GEvo9lzpoayOc++BxLIjlwnhZA2UocSnsx9Tv/qrr25I?=
 =?us-ascii?Q?6dFtw6WicxPGKMb4YmDI4QL1vt2iZtW+PC8S3b/cGIxJq2VhR/iB1iVzcQug?=
 =?us-ascii?Q?CtDxdX0xakCjF13kp2VR7JRa94W47yd3cixcmssW5B8/fV4vqI8eo3HE87Xu?=
 =?us-ascii?Q?FutFmioXYniP6dIdWCIy8uTyfxgRwUyU18dr3dXCr1oL77xFmo85dSZRtLFJ?=
 =?us-ascii?Q?2enickkyBpQKS0xi1kNqeBzzKKPi9x0eMr8gF7drsniwS6+lfYSLFntG347H?=
 =?us-ascii?Q?C7npKpFbG4wwJHpLsyM7zVUcbm0/JZMszbEDQaKbqpbENS+KornMB7NtDMCd?=
 =?us-ascii?Q?qzIQhWld5qOCAzf60LYm7jF5BSpg0ZYwtGkuLRHI5hE13+EQJTXb2HKSJAsH?=
 =?us-ascii?Q?EvJmoJYXniqC8ltET6HN+kTUCLQEftwYisJrz9lteISst2zMvpgxTpHAoZqt?=
 =?us-ascii?Q?ptGDIsM4PYyDh7a/ZvfUP5Q3ItcFjPKkgEIRAew95a2QTNNydJB1nLd7R6NH?=
 =?us-ascii?Q?7durmWHzzyCgbXNPrw1tnVE87FpP9kmNbEvvy8eMvlOYGuVIVYyGcJFINkhZ?=
 =?us-ascii?Q?VCcW7p1ektTtCccxOwZd/O1noQX/T8fwLPfRtN+KD4SwxeUro5kMPLipWKrE?=
 =?us-ascii?Q?6xV+rNANJZzmsflGvEbCwyx3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4641.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c80ca423-9476-428e-913d-08d967ab9c05
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2021 09:35:00.3389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7p5HWrT1G5+N/Ds1NwiRlBPf9DEuPtya1YIRX/zrNLivsPw8h4r9MefXM78k5ZGwv2htpm++C4sSIGJtVn1wtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR18MB4785
X-Proofpoint-ORIG-GUID: q-u4gVAE9d7fFAusSFNeoVmFyJGXOwd4
X-Proofpoint-GUID: q-u4gVAE9d7fFAusSFNeoVmFyJGXOwd4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-25_02,2021-08-25_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Tuesday, August 24, 2021 10:42 PM
> To: Ariel Elior <aelior@marvell.com>
> Cc: Leon Romanovsky <leon@kernel.org>; Shai Malin
> <smalin@marvell.com>; davem@davemloft.net; kuba@kernel.org;
> netdev@vger.kernel.org; malin1024@gmail.com; RDMA mailing list <linux-
> rdma@vger.kernel.org>
> Subject: Re: [EXT] Re: [PATCH] qed: Enable RDMA relaxed ordering
>=20
> On Tue, Aug 24, 2021 at 07:16:41PM +0000, Ariel Elior wrote:
>=20
> > In our view the qed/qede/qedr/qedi/qedf are separate drivers, hence we
> > used function pointer structures for the communication between them.
> > We use hierarchies of structures of function pointers to group
> > toghether those which have common purposes (dcbx, ll2, Ethernet,
> > rdma). Changing that to flat exported functions for the RDMA protocol i=
s no
> problem if it is preferred by you.
>=20
> I wouldn't twist the driver into knots, but you definately should not be =
using
> function pointers when there is only one implementation, eliminating that
> would be a fine start and looks straightforward.
>=20
> Many of the functions in the rdma ops do not look complicated to move, ye=
s,
> it moves around the layering a bit, but that is OK and probably more
> maintainable in the end. eg modify_qp seems fairly disconnected at the fi=
rst
> couple layers of function calls.
>=20
> > In summary - we got the message and will work on it, but this is no
> > small task and may take some time, and will likely not result in total
> > removal of any mention whatsoever of rdma from the core module (but
> > will reduce it considerably).
>=20
> I wouldn't go for complete removal, you just need to have a core driver w=
ith
> an exported API that makes some sense for the device.
>=20
> eg looking at a random op
>=20
> qed_iwarp_set_engine_affin()
>=20
> Is an "rdma" function but all it does is call
> qed_llh_set_ppfid_affinity()
>=20
> So export qed_llh and move the qed_iwarp to the rdma driver
>=20
> etc

Got it, and makes sense to me. I get the point on single instance of
function pointers being redundant. We will start work on the
necessary redesign right away. Meanwhile you may see a few
more critical fixes/small features coming from us which are already
queued up internally on our end, which I hope can be accepted
before we perform the changes discussed here.
Thanks,
Ariel




>=20
> Jason
