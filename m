Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F07F3F4CB8
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 16:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhHWOzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 10:55:05 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57888 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230186AbhHWOzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 10:55:04 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17N4YSIB012582;
        Mon, 23 Aug 2021 07:54:15 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0a-0016f401.pphosted.com with ESMTP id 3am4s0j0y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 07:54:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ic7vTK1B8GH3l8bhDEdRclCF7SBqwLQRrA55T28dL0qXO23Cu10jSsvPx3PB4AZltFKwo+2gIflA0Dxf/TeHwCp4W5ISsC/jwHqHqXQQuEG+17YQ0z2pNaDBfOIN6XKRCevsArqCKmA8tjq2VERObeKTfA9om2EaFsnTqzbefE+4BbLLhz9mGKwijlj46ZU62FygW/EA1BULciD8hvYzCZf7YDlMiPbwLBRA+cT1Ba8yl838+ME2pd+YVVDnXoliV3v4gqD+uSiybfSbfeyVIVHmasz+mqlUTDKvIzd3zsSlv3VfUSdM6w+inEZxEPOE66zVZWBvAxSyhLLbP3VMeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARy36vQ+ASCVMzMVYgeBn1O4ELTCLMojqradp6dfO6Q=;
 b=imXIYvoenhGx/GQ5iSoLGMdUB7jWWwkCeJhBI5II9Dcq13JWDQXBdhtPi2es22UE/1VaQKS6bBE3qlrPAFBg/NZvSmCbVMMaCf0Kr5S5TV6qeM4NHpa5YInSo1hssM3Jnz3Q0vcEuL5iIaCugMEzpmUAog91jmvkTRPyOr/vcqfKD2c7iNjUzjv/3TYPD43wmM50dybRYbsk08vGifcNAkiRIQu4itH7bb8kbW5T+dd6wK+MS/QFXnWvBxpGIojcgL+8vWMm38UDpbMtkKXnKj4F4JfODlPa6DlbFIpnLtNWKmBhEpPGBn/BQoSMsi6YYyRgS4qt29aHFXsWAp5lvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARy36vQ+ASCVMzMVYgeBn1O4ELTCLMojqradp6dfO6Q=;
 b=mw0rDu9oJmmIPbyGr/NAr5irny+bFSpGjpk5cOLxI1txbU6BOPO+GchAgthEdro3qqfvnhIm8DUM+emWkrBmcykd4bSIj0PkHPWWP70rdTBFBKSYGAaBEUejynxu/9KcNd5AnDGZUhTSd0XBgIoTfCuYLhUL/rqmsMfWhSH7IhU=
Received: from BY3PR18MB4641.namprd18.prod.outlook.com (2603:10b6:a03:3c4::8)
 by SJ0PR18MB4509.namprd18.prod.outlook.com (2603:10b6:a03:3ab::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 14:54:14 +0000
Received: from BY3PR18MB4641.namprd18.prod.outlook.com
 ([fe80::bc38:940a:28c3:7e4f]) by BY3PR18MB4641.namprd18.prod.outlook.com
 ([fe80::bc38:940a:28c3:7e4f%8]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 14:54:14 +0000
From:   Ariel Elior <aelior@marvell.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
CC:     Shai Malin <smalin@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] qed: Enable RDMA relaxed ordering
Thread-Topic: [EXT] Re: [PATCH] qed: Enable RDMA relaxed ordering
Thread-Index: AQHXl4dCntCauhMEGUiY44ZhI+K7ZKuA+5qAgAAcTwCAABQ6gA==
Date:   Mon, 23 Aug 2021 14:54:13 +0000
Message-ID: <BY3PR18MB46419B2A887EFFCB5B74F30BC4C49@BY3PR18MB4641.namprd18.prod.outlook.com>
References: <20210822185448.12053-1-smalin@marvell.com>
 <YSOL9TNeLy3uHma6@unreal> <20210823133340.GC543798@ziepe.ca>
In-Reply-To: <20210823133340.GC543798@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ziepe.ca; dkim=none (message not signed)
 header.d=none;ziepe.ca; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a990d8fa-5fed-43c9-3744-08d96645dfb9
x-ms-traffictypediagnostic: SJ0PR18MB4509:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB4509C6A569403F360BB8650AC4C49@SJ0PR18MB4509.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BkXh48rWAx3pz+LDubbhx3AsqleCgcgBD5F83mEh6sZVyFtIVoXBrduHncumFHzYHCI3rKrsVVQZQstG53V0xmIl1gwPdfbYz1mQHFfacCQa5zKZuPOdLHZedJ1vEdhaB1V0MajOn34On/AnkvM8IkKompZzvhagrb8KRlEwxbiArabu3VfNwRr9A9cv3FqWyGTVrBlX0l4y8I92Yiabupj7HyOJlnDdlvUAWxs9NvOQEcTbD5Tz28QXXzUC2VIe/MwyuxipFG733EXFBvYjItxAcFtEmgy61ID7S9WrPnk1toUnT/NwXE9TJJPhZ2qbPW2FauVLia1JLDdaj/Jw29rshNMCGf4r1j3MkhEPSn8jjh1CUMxOWSZJsaVtR1j8SJFrzZOm0fBrpwOdY6485F6IDV5ffVL49oEWo5SPK2//Vfy+ftaByVURWQF18dEKeen+q59phaKhVBHMoBsTHS7TqJ/hzVs5RuHVvsxVE0zsDgtSs+/l23gfk0iYlpVYyEFngmxbtH7OEYCBVxZve2Nf/ScfmTFKXfhgh+KzCc6D49I9yjV4NO5P6iGD/UqU36MzlOvzUXLE9YBW+o0jSh0I58dzX9ZVVwfWY6BjBKrfO5HOUC07aFsi5iXI3U+z118l5d+iX6RhNN0qJyTRiQUPF9N+4CVRkt6MHpmIAHXHZgfoJxH9M1zH9d/uCZEldYcg55K8H07NHFFr4zw0nQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4641.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(55016002)(9686003)(8676002)(8936002)(38100700002)(66556008)(66446008)(64756008)(66476007)(2906002)(66946007)(53546011)(5660300002)(122000001)(6506007)(26005)(316002)(186003)(83380400001)(86362001)(110136005)(76116006)(478600001)(4326008)(54906003)(52536014)(38070700005)(71200400001)(33656002)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hocchWH2dMTYzgxQuACkVJwBzIG8TEocdpUHF/368ejxUptdDLlPuIq3q2oh?=
 =?us-ascii?Q?G9OaMxlvHGRtDw2aW1t4XjQg/5z8RJQPCa9J9AAkBjWJtHtZTFDByWePXpQ+?=
 =?us-ascii?Q?iUN3Ja+ld+Rdw3nM3RaQqyG6TxUtR1shKQMBlTfhx7U8gZawbZv0iDTeFzHb?=
 =?us-ascii?Q?Qc3nCYMAB+iHkoC7bJGMOQDQ5HD1uBjlVHHGUgMUUSeuNbP45m8sOfpeIyHk?=
 =?us-ascii?Q?wxVed89L3/D1qNfzr9HRbHrBeV0NtLlDvr3PGQiM47IFF1MePXnMc3sxm8aM?=
 =?us-ascii?Q?FKn4R19gwIuS74aU/FG6sgbph8QV4hD9dFR6zHBRVNlcRlmIpsCKk3NtrcBS?=
 =?us-ascii?Q?ZujcOdVN5ooNKqcKbt6iTQYwKlGGha3O+j9bcgmGEDe0JzYFfrxpMM9Foo8U?=
 =?us-ascii?Q?4+aE9F/hLP2cZkuAi668rQ3hx+bDWDPAWMp4HZOq7q+XvSnrKu79vTbZJW1e?=
 =?us-ascii?Q?etnn9x6zgrgMQOwx3hOh/Adfe6fJGSGMgiv+icJgPTPl2DTyBh+Rfpgpj7PJ?=
 =?us-ascii?Q?IID8GV6Gz0MpTXmNaj3d4fSIvKW+SpBTn1ov6H01vszckxRACyUvExTjrVhx?=
 =?us-ascii?Q?NRRNl4yf5IenJqjtHoTyBd8pkSN2g7UZGqZmNrIiSCci1N3odKiQUTyBeTl1?=
 =?us-ascii?Q?Nix1YWGOBp5xtI0I0D6XD6o6LV252zQ0DigoTFpkvaxz4akUZ7B0amvz/+8l?=
 =?us-ascii?Q?eU+B/rhmnsxRxeIBXodFXArvkhjmj50ft/BiPggCVobWKJ4lZnooXZ+j3zQi?=
 =?us-ascii?Q?gaRmrGqeWLdBecZ1HRa7krVShLTAWHSQ+mX16SMvqGZwnupZRva1TehYscij?=
 =?us-ascii?Q?/XS2cdjAK2NjTQJGKiSmUR4AtnrbMei37bRblGWeOejDX7JXFVkjQC3iiZd6?=
 =?us-ascii?Q?Ws+LZvi8Ua6i3lEImBidPPFcQCVJSHoXuQEaMxM06ZtZ46BkMoqqFV3hZhvL?=
 =?us-ascii?Q?9G0nB110YwFTAfb1DTqXwijrZwsL02Oanc9Rct8Et0WV3MGrVS38O1CIo3YA?=
 =?us-ascii?Q?OtMb59AcxfOxQBgz8jXZ+oIJAiiH81YuOppjP8uQNgW0egaW4YDX5lEbbOYc?=
 =?us-ascii?Q?f7O22E0KMkAK50SDmnz9J7LZArukXl7/DhFVMzNumRADkuuUfIUaurojRDXO?=
 =?us-ascii?Q?1f8L+mp5AAkkwvGdjs2pPmCDM0z6y5oKOj2S0SMHSdTSItNumzCjaD600rHj?=
 =?us-ascii?Q?0Di9g0LLq6wypvqqyH51LoRrpIZqqjteSvWyCWb+phZnE5mtyjXkLYR/SUZA?=
 =?us-ascii?Q?0apmA/1PD7MNlhpHxdwhNtC4zU2mwll4lZ33K1ler3w4EmQPP/x47jAt+6IT?=
 =?us-ascii?Q?f78quMQnh3CX8YdQVbfOKI13?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4641.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a990d8fa-5fed-43c9-3744-08d96645dfb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2021 14:54:14.0157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vJLsITQo1bXKxvSjOakWULP676n+Nc/VksLFYEiegWyZ0l47FguKAG1KHIeHAz3xqV/TLNx1F8GtvZE4ZSfORw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB4509
X-Proofpoint-GUID: WrGoBo4AksaibxRlPkJbIp2SFlE9q9pi
X-Proofpoint-ORIG-GUID: WrGoBo4AksaibxRlPkJbIp2SFlE9q9pi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-23_03,2021-08-23_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Monday, August 23, 2021 4:34 PM
> To: Leon Romanovsky <leon@kernel.org>
> Cc: Shai Malin <smalin@marvell.com>; davem@davemloft.net;
> kuba@kernel.org; netdev@vger.kernel.org; Ariel Elior
> <aelior@marvell.com>; malin1024@gmail.com; RDMA mailing list <linux-
> rdma@vger.kernel.org>
> Subject: [EXT] Re: [PATCH] qed: Enable RDMA relaxed ordering
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Mon, Aug 23, 2021 at 02:52:21PM +0300, Leon Romanovsky wrote:
> > +RDMA
> >
> > Jakub, David
> >
> > Can we please ask that everything directly or indirectly related to
> > RDMA will be sent to linux-rdma@ too?
> >
> > On Sun, Aug 22, 2021 at 09:54:48PM +0300, Shai Malin wrote:
> > > Enable the RoCE and iWARP FW relaxed ordering.
> > >
> > > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > > Signed-off-by: Shai Malin <smalin@marvell.com>
> > > drivers/net/ethernet/qlogic/qed/qed_rdma.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > index 4f4b79250a2b..496092655f26 100644
> > > +++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > > @@ -643,6 +643,8 @@ static int qed_rdma_start_fw(struct qed_hwfn
> *p_hwfn,
> > >  				    cnq_id);
> > >  	}
> > >
> > > +	p_params_header->relaxed_ordering =3D 1;
> >
> > Maybe it is only description that needs to be updated, but I would
> > expect to see call to pcie_relaxed_ordering_enabled() before setting
> > relaxed_ordering to always true.
> >
> > If we are talking about RDMA, the IB_ACCESS_RELAXED_ORDERING flag
> > should be taken into account too.
>=20
> Why does this file even exist in netdev? This whole struct qed_rdma_ops
> mess looks like another mis-design to support out of tree modules??
>=20
> Jason

Hi Jason,
qed_rdma_ops is not related to in tree / out of tree drivers. The qed is th=
e
core module which is used by the protocol drivers which drive this type of =
nic:
qede, qedr, qedi and qedf for ethernet, rdma, iscsi and fcoe respectively.
qed mostly serves as a HW abstraction layer, hiding away the details of FW
interaction and device register usage, and may also hold Linux specific thi=
ngs
which are protocol agnostic, such as dcbx, sriov, debug data collection log=
ic,
etc. qed interacts with the protocol drivers through ops structs for many
purposes (dcbx, ptp, sriov, etc). And also for rdma. It's just a way for us=
 to
separate the modules in a clean way.
Thanks,
Ariel
