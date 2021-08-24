Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927FE3F69A8
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 21:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhHXTRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 15:17:31 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60888 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234048AbhHXTRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 15:17:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OIU6vO023382;
        Tue, 24 Aug 2021 12:16:43 -0700
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by mx0a-0016f401.pphosted.com with ESMTP id 3an63u05j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 12:16:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F83fVTOtOIoDph+uJO/kMa2p0nQ3cJdAaos2XKObB/b87Wg1ZBmECZ95JGuwL2haL2+JFZztiJr3GjE+wR5WJ1g+zCNnKVCNfqaMYb0MPqQIn/u/Ea7waOtngxJkO57tRR5MBPCjgRSlDnW8GUfJfXLdpLW0e/4r8sLzYrktIPnZwqrp84UxJvyntSyEYVaa6OuEW4DGriTKlYM0KA81gZ0IZ8LZdcOJugF6wvxRq7nuDBqP1ukHWJiawBnHFDUr49Hdq/KVF6RQwk9OSG6/QLDDbku+gWuabDbcPNem7eznsOOc6jdKj8/WcfQTkEXiSQJasXTJpOZZGKkpEqX8RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNCbPoJTskuYxWZCol0Yft49MHpg65kaZHbkdSrG/hI=;
 b=ERWnsN48Bh7Oo9XKw8+6qS4jfuPeZYkOo0OgTJrCcW1j/QWZb045WSII+++FfHiyY8fvLg7iM5w77jSYO2PnhCny8jwqkQ6JSj7MTl+fR/T9pO2Tr3wh+GNN+KLpr5wrodh31KOUlNX1BZQtNifiCnbnUJsdkhgGd/ak6iG20b4+hVIcBWG8M2QWS5sUgVwOIRTQUAeJbSd9OzKs8EzQxYg6cWvO6Ft9wPQXQwXeFFG4lSe0UPL7ODujnqhnhYgaMI47qZv/3Wb6vipLgNbIeVYqMv6wiJo+3HckqLzirE3tYFwqigEHIqNmVk8qkUReXDjTcClKgS6+QMJSISJJQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNCbPoJTskuYxWZCol0Yft49MHpg65kaZHbkdSrG/hI=;
 b=bQ/uxdbp4tg1LSFXpnYZfjbcXhVKhb2c1REiG92UmnkP4GORVxsMAviQUYwzTZUYWaZw3yf2e2kaSVm6ql0X/xQ3tvZJLXBYucNbPPrq3FQGKPA8gKR6lMzG08E/FI42uKvfMGU4PxEpW69bJtLoCpv706ZO8k+64UfoXWrtJ24=
Received: from BY3PR18MB4641.namprd18.prod.outlook.com (2603:10b6:a03:3c4::8)
 by BY3PR18MB4772.namprd18.prod.outlook.com (2603:10b6:a03:3cf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 19:16:41 +0000
Received: from BY3PR18MB4641.namprd18.prod.outlook.com
 ([fe80::bc38:940a:28c3:7e4f]) by BY3PR18MB4641.namprd18.prod.outlook.com
 ([fe80::bc38:940a:28c3:7e4f%8]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 19:16:41 +0000
From:   Ariel Elior <aelior@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC:     Shai Malin <smalin@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] qed: Enable RDMA relaxed ordering
Thread-Topic: [EXT] Re: [PATCH] qed: Enable RDMA relaxed ordering
Thread-Index: AQHXl4dCntCauhMEGUiY44ZhI+K7ZKuA+5qAgAAcTwCAABQ6gIAACNcAgAFiEgCAAHEuUA==
Date:   Tue, 24 Aug 2021 19:16:41 +0000
Message-ID: <BY3PR18MB4641E80F8ABF42A5621B7573C4C59@BY3PR18MB4641.namprd18.prod.outlook.com>
References: <20210822185448.12053-1-smalin@marvell.com>
 <YSOL9TNeLy3uHma6@unreal> <20210823133340.GC543798@ziepe.ca>
 <BY3PR18MB46419B2A887EFFCB5B74F30BC4C49@BY3PR18MB4641.namprd18.prod.outlook.com>
 <20210823151742.GD543798@ziepe.ca> <YSTlGlnDYjI/VhNB@unreal>
In-Reply-To: <YSTlGlnDYjI/VhNB@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65bbce42-b971-4b22-6544-08d96733b46b
x-ms-traffictypediagnostic: BY3PR18MB4772:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY3PR18MB477206A83917B88C82DDCD78C4C59@BY3PR18MB4772.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xGF8fmLY71VoYA/YMtOjXIhLycCqtNtx7q2bNEtYHglkPOzkEj9T5BGMD2P4gYfFMB/5+rO1J4vXpnZJCZweqjTTntFjo7aDLhQtHIgFcDFHzEr4VLkw9hXLpTB9L5+zxnR/tTanoySr3ITb6P0Z/iHQZaQMyV27B6B/e54peOIsrDSiQJ1EwONZqRF/shAzFLei2lKypu9ztv2Pp349Qxn+/AiBfLuZscNcWoBhYO0i7ph8j5lZSmtCoQHftZlC5f4SgCv89mYFN6IwbcNc84IX+3IpIe+3dCb6FlapTTMu8cdefdJQyScWJB7ZjCmxW8glme1B/g1PvPoAAZ3ZSVoXDA5rYJTFr0BIQxxs1K6NuSdCsxVNH+AQdlAaTueocSAw5xVIKsaaRKTgnkszlcKlBWE5stTns4GDJG24ZtAmaZeKjdYh9eIyhTDDyth5wNArUMAB/sO8blpAydVxx8xHRkCjipPqdoE+RkBV0MXd87cJnkMFvwCo6R03pRRS4DOWstlS4GGGMCHU632ym7HZWSeUask+bS3vHPsgq+S7NqWMA+nUdpb0bAr13YVEwNIF7DD3dloYzglIhbCnzyqTSqXIXaAfdM8XtdtDKeqyzWo7PITalncU2WMFRdL2wadE28YSuzvfdVqV2zHy9z0qOfRUvf72odU5fnE5h0F9moqiobA4rhs4RywJxDlly4v/qmIbbyTTBpsDO8hlnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4641.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(396003)(376002)(4326008)(66946007)(316002)(38070700005)(9686003)(86362001)(122000001)(38100700002)(76116006)(5660300002)(26005)(66556008)(53546011)(8676002)(110136005)(54906003)(55016002)(71200400001)(64756008)(52536014)(478600001)(8936002)(2906002)(6506007)(66446008)(7696005)(186003)(33656002)(83380400001)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T0p+IS5TcaMTvuuU+S3DPsD+6n/uVkwWauSHuG+BynTkYBRSQ84pJjm1UQCN?=
 =?us-ascii?Q?a8sfNEMST5ZF0OoZJ0bXfCLmCx0ndOgGjMFNzG8RQbXT1dyCxho/nLBwHkKq?=
 =?us-ascii?Q?efZlcODaFC95VWULRc0dkc84MoiVIxtusaaa4KfQAFIFC9P22EGoZRaXqVMh?=
 =?us-ascii?Q?EC8DIjh1lSe+JAJJZOGSq1SLnGnC60+DAywOzx8zFUmj5SuC3FAazRgOoSP5?=
 =?us-ascii?Q?YL2CB2HVu7xh45rlCJjmkV1TrIsmzfme+FM797TC55WXYn2l+oBB124W5mMM?=
 =?us-ascii?Q?XrVJQTlXa8aGSm5Gp0lJTtESkpNBWLfSiIDzeBhle4hthtJjGpZCWUzB9QoU?=
 =?us-ascii?Q?2/0S1/fu8I5G1x/nsQN94CDhSgLtcA/BB0BC4GBBLCdM9vi7DcrJQClTSDXj?=
 =?us-ascii?Q?K4bUt+/zX4f7CWL1SID05N17h14Ci1ow4/7TFN9CzhEwDR/QK/onpJ9nUBhE?=
 =?us-ascii?Q?BDRpGKKb8RCmDcA9Hehw0EIrUnmvyXcGh8C7br6y/IKtkALyzKPW1XnrOwRH?=
 =?us-ascii?Q?ZmnNVXba53hRgSIRZMWXmAdOVdo5GsYBeAVXIB91BXzw2mRcXT1dRrszpAfY?=
 =?us-ascii?Q?iHTTUcPgeeAhb4HFrv6cXp2kIqWSkZXlKcbK3ugABJo7MrM0D1m94pj2+Ek+?=
 =?us-ascii?Q?l7TAyueYrMA3FMeEoEk29+lreEESSj027en/HT7Bs/phgSQsmWBUZkFTDG4q?=
 =?us-ascii?Q?FKJURxzaV15jLqVqu9LQ8PmnqtmYpa8pLEB/f6PWtj1vgwm7i4p59stT3CmT?=
 =?us-ascii?Q?WTMu1bKrSqLcv7rl2Rx3olE/ifeyI/VrGug9YEobm7YqkMVGvU4nr/LVgx8c?=
 =?us-ascii?Q?1zN+Ba102myxyCI4kN1kvGA75qALQq+wfGnKhWKlYRqz0oWuNQ5knB9P1sVA?=
 =?us-ascii?Q?efz8SkBqzZf3zT1a6NbN1TuTxGu+52fdCWdIUoIBta5u/x4P0A1Cg2Z5vT7i?=
 =?us-ascii?Q?Ipmr5LzQMRG2Q7yYX0Gd2Oe+0G4RVrxPzqN5MlAaQmpTWLlwqyLH6rZKIOkX?=
 =?us-ascii?Q?tOV8Qgo88Lr7IKPy5d0lBLRFGvtx2fYvBw4HU8zXGNOXmsyG4yZPn1HKod1D?=
 =?us-ascii?Q?H5Arx1SsV/+97tEbbnDXnQC3+VPBeUVKCqTPBzJ/LbIMcvU8QExPfIB+T+pG?=
 =?us-ascii?Q?dza3rAo2TMlzATWvTsqTXtPYGNT+yqe0Ir9xEIGUFz0WsIEc+HSgh4UDNyT2?=
 =?us-ascii?Q?05GUhp0I/vV6Dr7gFm9oeOng+QR+TnzpqVQ6bbMUzdAjBp1/YX6jrCGFK+2c?=
 =?us-ascii?Q?CCooSdByEq5s7j+2gsqTIk4KxcqHePObsCrqkZ3oHn6nf/QiZMS2YmEPNEtA?=
 =?us-ascii?Q?CCrhN/+/AlwhtrLDSnsAX7M0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4641.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65bbce42-b971-4b22-6544-08d96733b46b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2021 19:16:41.6331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kUrztzjmLL/56y7vWB8PaU/s08PFcG41l4Ar6ZVup02LEyKq6t64+k/dPhyqC6cGYapjZytqaDC7PxKY7gag6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR18MB4772
X-Proofpoint-ORIG-GUID: s2EUF80GgL4kSisV9Y7M2kOlce4CJyta
X-Proofpoint-GUID: s2EUF80GgL4kSisV9Y7M2kOlce4CJyta
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-24_06,2021-08-24_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Tuesday, August 24, 2021 3:25 PM
> To: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Ariel Elior <aelior@marvell.com>; Shai Malin <smalin@marvell.com>;
> davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org;
> malin1024@gmail.com; RDMA mailing list <linux-rdma@vger.kernel.org>
> Subject: Re: [EXT] Re: [PATCH] qed: Enable RDMA relaxed ordering
>=20
> On Mon, Aug 23, 2021 at 12:17:42PM -0300, Jason Gunthorpe wrote:
> > On Mon, Aug 23, 2021 at 02:54:13PM +0000, Ariel Elior wrote:
> > > > From: Jason Gunthorpe <jgg@ziepe.ca>
> > > > Sent: Monday, August 23, 2021 4:34 PM
> > > > To: Leon Romanovsky <leon@kernel.org>
> > > > Cc: Shai Malin <smalin@marvell.com>; davem@davemloft.net;
> > > > kuba@kernel.org; netdev@vger.kernel.org; Ariel Elior
> > > > <aelior@marvell.com>; malin1024@gmail.com; RDMA mailing list
> > > > <linux- rdma@vger.kernel.org>
> > > > Subject: [EXT] Re: [PATCH] qed: Enable RDMA relaxed ordering
> > > >
> > > > External Email
> > > >
> > > > On Mon, Aug 23, 2021 at 02:52:21PM +0300, Leon Romanovsky wrote:
> > > > > +RDMA
> > > > >
> > > > > Jakub, David
> > > > >
> > > > > Can we please ask that everything directly or indirectly related
> > > > > to RDMA will be sent to linux-rdma@ too?
> > > > >
> > > > > On Sun, Aug 22, 2021 at 09:54:48PM +0300, Shai Malin wrote:
> > > > > > Enable the RoCE and iWARP FW relaxed ordering.
> > > > > >
> > > > > > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > > > > > Signed-off-by: Shai Malin <smalin@marvell.com>
> > > > > > drivers/net/ethernet/qlogic/qed/qed_rdma.c | 2 ++
> > > > > >  1 file changed, 2 insertions(+)
> > > > > >
> > > > > > diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > > > > b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > > > > index 4f4b79250a2b..496092655f26 100644
> > > > > > +++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > > > > @@ -643,6 +643,8 @@ static int qed_rdma_start_fw(struct
> > > > > > qed_hwfn
> > > > *p_hwfn,
> > > > > >  				    cnq_id);
> > > > > >  	}
> > > > > >
> > > > > > +	p_params_header->relaxed_ordering =3D 1;
> > > > >
> > > > > Maybe it is only description that needs to be updated, but I
> > > > > would expect to see call to pcie_relaxed_ordering_enabled()
> > > > > before setting relaxed_ordering to always true.
> > > > >
> > > > > If we are talking about RDMA, the IB_ACCESS_RELAXED_ORDERING
> > > > > flag should be taken into account too.
> > > >
> > > > Why does this file even exist in netdev? This whole struct
> > > > qed_rdma_ops mess looks like another mis-design to support out of
> tree modules??
> > > >
> > > > Jason
> > >
> > > Hi Jason,
> > > qed_rdma_ops is not related to in tree / out of tree drivers. The
> > > qed is the core module which is used by the protocol drivers which dr=
ive
> this type of nic:
> > > qede, qedr, qedi and qedf for ethernet, rdma, iscsi and fcoe respecti=
vely.
> > > qed mostly serves as a HW abstraction layer, hiding away the details
> > > of FW interaction and device register usage, and may also hold Linux
> > > specific things which are protocol agnostic, such as dcbx, sriov,
> > > debug data collection logic, etc. qed interacts with the protocol
> > > drivers through ops structs for many purposes (dcbx, ptp, sriov,
> > > etc). And also for rdma. It's just a way for us to separate the modul=
es in a
> clean way.
> >
> > Delete the ops struct.
> >
> > Move the RDMA functions to the RDMA module
> >
> > Directly export the core functions needed to make that work
> >
> > Two halfs of the same dirver do not and should not have an ops
> > structure ABI between them.
>=20
> Yea, I read drivers/net/ethernet/qlogic/qed/qed_rdma.c and have hard time
> to believe that hiding RDMA objects and code from the RDMA community
> can be counted as "a clean way".
Hi Jason, Leon

I certainly see your point, and understand the motivation to have rdma cont=
ent
in the rdma tree. We will start work on refactoring the (day 1) driver desi=
gn to
have more rdma logic in the rdma driver and invoke the core module when nee=
ded.
Changing ops to exported functions will also be part of that.

But realistically I don't think we can move it all. Please understand that =
the
core module has many responsibilities which must take RDMA components into
account, but are not just rdma specific (the same logic is applied for the =
other
protocol drivers).

A few examples for this might be laying out host memory for connection cont=
exts,
computing bar offsets, computing resource amounts and allocating resources =
for
VFs/PFs, etc.

I think we can definitely move some of the RDMA logic from core module to t=
he
rdma driver (as in the case of this patchset) and I understand it makes mor=
e
sense that way. But I can think of multiple code areas where this would be =
very
difficult.

The current design is for the core module to own data structures and logic =
for
device configuration and manipulation. These flows/data-structures are
triggered/populated from multiple entry points: some at the low level part =
of
protocol flows (e.g. create QP) which can easily transition to be an export=
ed
function as you directed, but other entry points may also be activated earl=
ier
e.g. when device is initialized, even before rdma driver is loaded (based o=
n
device configuration information, for example) in which case we would not b=
e
able to invoke functionality residing in the rdma driver, but still have to
populate data structures, invoke FW flows, configure registers, etc. which =
have
to do with RDMA.=20

Additionally, the qedr RDMA driver services both roce and iwarp, which mean=
s
there are TCP related flows/data structures which are shared between it and=
 our
iSCSI driver qedi. This is nicely handled in the common module avoiding any=
 code
duplication. Ripping it out and locating it in the protocol driver would be
difficult to perform and hard to maintain across the two trees.

Likewise functionality like light l2 queues, dcbx, sriov are shared amongst=
 all
the protocol drivers. Exposing the functionality through export instead of =
ops
is no problem, but moving the logic outside of the core module to a specifi=
c
protocol is both a considerable design change and may lead to code duplicat=
ion
or some very convoluted flows. =20

In our view the qed/qede/qedr/qedi/qedf are separate drivers, hence we used
function pointer structures for the communication between them. We use
hierarchies of structures of function pointers to group toghether those whi=
ch
have common purposes (dcbx, ll2, Ethernet, rdma). Changing that to flat exp=
orted
functions for the RDMA protocol is no problem if it is preferred by you.

In summary - we got the message and will work on it, but this is no small t=
ask
and may take some time, and will likely not result in total removal of any
mention whatsoever of rdma from the core module (but will reduce it
considerably).
>=20
> Thanks
>=20
> >
> > Jason
