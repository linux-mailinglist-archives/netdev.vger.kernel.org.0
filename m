Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223743F8930
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242049AbhHZNlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:41:22 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63550 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242681AbhHZNlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:41:21 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17QAH0Ic004110;
        Thu, 26 Aug 2021 06:40:27 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ap92mrpyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Aug 2021 06:40:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBmtRORULcmFpIRuJ78QraVTJXaObfLf00WQkiPeqoy7PSlWOq1QODS/3IopdRYKKRLuks/VpNqG756G4m2yZNlM8tl2UQxJFUeXX4PhZcgMGgJ/oU+dId+IB8jvL1HXycBeBbYeFMDe4cf8/vMzT4qqMz25O2YsNoHPhu/lA7YO/PGdCD8oWzb17ReEA3MFqeyysr3Wor8RNbo9MYTigiatKHiOikjmuK1k00JOGTqbQ3qjXVhEvWjwDTOZx0wRQwQETJvYP8KULUXd43wz/okCQnpDK1HH9UjvEVALG0cQXIESr+h1QbBq7Lri51wv8cq42v/SDm8FYREo98mfwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkYpu9XJjr/iypPICy/x+my4FF1jaS+0aJHyte3Lgtk=;
 b=f2jJsUQfQTFFJldw9Us08WNlPDCiS45hzSZlWUAnwWbprzmgaeZGkh1a61gVcCgP0ToCTXzQkAof7bf4/kcHd6T+yU5QnOi99CglNFyuerhezJQJCNOk0LHXuhHiBItsKncW9jnoYjvRzKgjA/CsY74xcGNftSt4d/ZzakIy9fMOfBUs3GrfQzsPTxD8JoD+G7j9T1NbM0juuH0VrPDWuCWGxwIzwnzGY7dH/RzSQg0WyhkpqFOqTOKsm40rzvLoTv84dHnO3bdDbY7s9wjRCKmbtXpnqXA9TGMkQ531p+p8Nj/7P4TshEcM/Cyjxz8g+LExDtId7vXxDlj0QnmYCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkYpu9XJjr/iypPICy/x+my4FF1jaS+0aJHyte3Lgtk=;
 b=VpLPRWZWVjF6LETM53sW4WR5Pa42xc4EciMYy656XhhzdPptYSz+qlTSw37eW1phGwQ9VHuVf3+1qWpkOygy7FeajqenzWfMhTZgoj5/tgFgCKvv6eRQuksC4/0NoBAuojKcz55/AzUT3sujalnxl1XkWBt/I82GZRKbNabyfms=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by BY5PR18MB3364.namprd18.prod.outlook.com (2603:10b6:a03:1a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 26 Aug
 2021 13:40:25 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::80cb:c908:f6d2:6184]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::80cb:c908:f6d2:6184%4]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 13:40:25 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Leon Romanovsky <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH] qed: Enable RDMA relaxed ordering
Thread-Topic: [PATCH] qed: Enable RDMA relaxed ordering
Thread-Index: Adeaf+u36Dk4mDjjQo+UVZEX1YF78Q==
Date:   Thu, 26 Aug 2021 13:40:25 +0000
Message-ID: <SJ0PR18MB3882FB84E1643D82978A3B37CCC79@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ziepe.ca; dkim=none (message not signed)
 header.d=none;ziepe.ca; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f360ce4-fe7d-4f04-dab9-08d968970f5a
x-ms-traffictypediagnostic: BY5PR18MB3364:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3364280E26FEEB168A722402CCC79@BY5PR18MB3364.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /3ISTbjur+V8H3/Jk3oBiB9cstfsckOxHrBIQBAExqm+11YeGkp6fP2T0AQAIUE8LeCmLyoMDIcpwB6826qRYOrNl0QM4rGg8aaQ3+LEhijFtTj1qqxiRwMDNnxMN1Lc5Qm0GJFxnutJpFO+UjUtbI89E6xQ2cQ+H1n/8x7+yQtHuFt9Pm4/ko//I6WKGVMf441kdj6K6plTYZK1w/VzKnhNbbTeyoMye7I5atERqD6k0QRS29U0XA9j/cr5Exeyl4/VVcdYJO9kTu1H1/X7O3VO83pAsmzNr6Ny2KgSFjdWn9/pQdcYfXmfqCBXmwibPRh/td39oHOY5tCRKY97MWTbgCOx5FAd6s2TVOv6z94IChBdbC+xCtIZ04bNYGEd2ofNr/OHCKA/nxqjUgeuMl1DI+16q8hy242/miYIsap8uoITij1EsbSh3ggXhHI7fBxsq8FVawmp8yJand2RffPg7WSLI/bd4sWLweVlopD+HNEQwQK0nUt6zozjNhKq7ki0dNEHNCMgCBQZ1BMwNw6J7N0FVKs40P9IWSpEWpqXzygQdzCx+c2KP9EUHkRko4RJXWoqoMyYrk9xgV+MVYzD6zCLIEmCEGpeAe7xT2uiiYWMPEP6YvWpg30Bndy89Cxthu90lfEdUuyRiuQ+Lgk0spm4/uNPZwZL8Q/fQLtMXbjm6spgDfZkj6vmhH3/0eoHq4A3p485D4T+UdMBJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(86362001)(66556008)(64756008)(7696005)(66946007)(66476007)(186003)(52536014)(6506007)(2906002)(478600001)(66446008)(76116006)(5660300002)(38100700002)(83380400001)(9686003)(122000001)(33656002)(38070700005)(55016002)(8676002)(6916009)(316002)(8936002)(4326008)(54906003)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l16UJKPA0sz2csXT2UJUxTuBPmzBKy1yPrGdaXePlcMdbok/DDv0kInIae/i?=
 =?us-ascii?Q?XIF5xWDPBFr0e/f3S8yrMJaE1muvmecnRsh0bEfTNiKYZrRHDzN7edHUx4nO?=
 =?us-ascii?Q?27ll0TbHWo1B831Eq63I5DA3z40vfV6WPBRNQUvcUcphHGRc7TnPildCrSQ4?=
 =?us-ascii?Q?ehYeZMUrGcuYH/zRQamNxUGoY8uT1E33cI15ZW7u4ZK/E9WpUaEaPSh5dLUH?=
 =?us-ascii?Q?82KkxkC3lOGljISKKFEe6dxZkE/cBBdIPU3jOwlxGWIPBzV4Bz7ezBRzr54L?=
 =?us-ascii?Q?uGvVECnJmGNfOI7zuJ4nd5mqbMB23feQPH79UenezqyK+Eaejt0nG/gvAQj9?=
 =?us-ascii?Q?fifZgnH8Idbk2qdRTFEHeprHlEhNnwqApUyUuaMsuwJBHDR2TJ42l0UaC+TV?=
 =?us-ascii?Q?cSxThAiz7aQ6yyLv9W6QU4jeTlQDtH0VS2g+LbpGWy4Biy8MfQkrTK33Gc4f?=
 =?us-ascii?Q?RcnFKzSxeJSUgQsx3Js+xwQNEunFDw64jlOTpasiGNbPFRghTSiI7LArpAiV?=
 =?us-ascii?Q?n77oSamS1M98zWqu7nrEeLwX4aKOm5+Qqr6s4DOX80Si+2m9QUlK8/oTW7A+?=
 =?us-ascii?Q?nf/LULz60dKlnytudhpZuPgUw+kt1ALvavVaD3fUy4KLqmaEEDQMDtLIZ8hL?=
 =?us-ascii?Q?C3Ry3A+tELb3Em/CIvo6U1d195ozbwE0fw325bFsUSMnM2OOPVSkq5mOU4vm?=
 =?us-ascii?Q?vJXh/Uw4jdvMuAy7tfRwXd2ge58Flvj1re02GfRooZrZqOhU/JghWEp8jUv8?=
 =?us-ascii?Q?U8CgTuVsbwhydjPc+6GVE6WenVa4z7zFFF+MoTLPrf/zfSfxkp7ezeiOB6Ra?=
 =?us-ascii?Q?xSreujJWvN4iUeiMhLszi9sBkc0UVgSWi+KeOGqmFcSNC12WApkKQGu0X0s9?=
 =?us-ascii?Q?UXT+5CazOKpfocvmAv7sjlN/zbZnUOx5NY+tZ0zpm0sw7uqGH6EAxpDan6Za?=
 =?us-ascii?Q?6mPZYL4+8T94XJW10G/COsMhY/NWrv3jDEEXb5ND13joBz94mEGmlADqkxzV?=
 =?us-ascii?Q?uwSOWB2PK+EKm+W63dZ9GEsSh6tYsr3i/VwLACblQtPrJr1SestGt1il9CMf?=
 =?us-ascii?Q?4SycJmFXsO17WczWGjTP6a/NWfLAr0YVAyR52x+5orrteC4vZTFIMvu3fZIA?=
 =?us-ascii?Q?TrwNoi7zVAK9GVru5t0Z7aXZg4PqbSOxiJjviHE6PV6iHcwXIipT0MxROMhu?=
 =?us-ascii?Q?RhDWP4Q0tOWbfTaiFzS9hVBWCdUirc4Ld1B6ui4JQkG2htxxOO7/PXw/0Um5?=
 =?us-ascii?Q?6l9B9wS8+A0jjg078pk0wXZN2Gyf2dilAAu7ffBk8aar6Qii9+CPpLmbJOFA?=
 =?us-ascii?Q?yaf2IF/PRE2m5mPQ1ggQxnVkAJPvrpchvkeVdDVOoO8V8vzDWK9ZirkFViCN?=
 =?us-ascii?Q?jac6QAA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f360ce4-fe7d-4f04-dab9-08d968970f5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 13:40:25.4916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TzMAyDsQCPVlLNRql7lNcfC7tGXmaaMJXT1mC5qMIZixsBNZSNTrCReSBikHdLTGLNOMtntiI4lmpGVsYyt3+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3364
X-Proofpoint-ORIG-GUID: EQ4-CMUUxD172mwqaLyRLcDz9FiXPb0x
X-Proofpoint-GUID: EQ4-CMUUxD172mwqaLyRLcDz9FiXPb0x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-26_03,2021-08-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 04:07:00PM +0030, Jason Gunthorpe wrote:
> On Thu, Aug 26, 2021 at 12:05:18PM +0000, Shai Malin wrote:
> > On Mon, Aug 23, 2021 at 02:52:21PM +0300, Leon Romanovsky wrote:
> > > +RDMA
> > >
> > > Jakub, David
> > >
> > > Can we please ask that everything directly or indirectly related to R=
DMA
> > > will be sent to linux-rdma@ too?
> >
> > In addition to all that was discussed regarding qed_rdma.c
> > and qed_rdma_ops - certainly, everything directly or indirectly
> > related to RDMA will be sent to linux-rdma.
> >
> > >
> > > On Sun, Aug 22, 2021 at 09:54:48PM +0300, Shai Malin wrote:
> > > > Enable the RoCE and iWARP FW relaxed ordering.
> > > >
> > > > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > > > Signed-off-by: Shai Malin <smalin@marvell.com>
> > > >  drivers/net/ethernet/qlogic/qed/qed_rdma.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > > index 4f4b79250a2b..496092655f26 100644
> > > > +++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > > @@ -643,6 +643,8 @@ static int qed_rdma_start_fw(struct qed_hwfn
> > > *p_hwfn,
> > > >  				    cnq_id);
> > > >  	}
> > > >
> > > > +	p_params_header->relaxed_ordering =3D 1;
> > >
> > > Maybe it is only description that needs to be updated, but I would
> > > expect to see call to pcie_relaxed_ordering_enabled() before setting
> > > relaxed_ordering to always true.
> >
> > This change will only allow the FW to support relaxed ordering but it
> > will be enabled only if the device/root-complex/server supports
> > relaxed ordering.
> > The pcie_relaxed_ordering_enabled() is not needed in this case.
>=20
> I'm confused, our RDMA model is not to blanket enable relaxed
> ordering, we set out rules that the driver has to follow when a
> relaxed ordering TLP can be issued:
>  - QP/CQ/etc internal queues - device decision based on correctness
>  - Kernel created MRs - always
>  - User created MRs - only if IB_ACCESS_RELAXED_ORDERING is set
>=20
> So what does this flag do, and does it follow this model?

The flag was not following the model. It was supposed to enable the=20
RDMA FW to use relaxed ordering for all the above cases as long as the=20
device will allow it.=20
Following Leon's comment, I understand that it is not allowed with=20
user created MRs.

Our gap is that in order to control the per MR relaxed ordering we will=20
need to update the FW (in addition to the driver changes).

>=20
> Jason
