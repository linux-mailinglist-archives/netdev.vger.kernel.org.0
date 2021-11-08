Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B02447E67
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 12:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238916AbhKHLFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 06:05:38 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42292 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238910AbhKHLFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 06:05:37 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A8ATIfn011833;
        Mon, 8 Nov 2021 03:02:24 -0800
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3c726bg4g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 03:02:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PR4e118mNcCY3mF1XVFi1OGYksgAheBlOutNqmjxuikCQKnBpZN9rs5YFjiJ3qsE64C0h67too1bK6tIbtJui6KgiOIgbw6lvNAn+3U+YwAnBtMloD6VNPUhg215Ducl+Rjxj99ByHPNYQzBrIv/zDEHAhEn0lFKxhOTyjQnbTMx+9vPr782cIiBdtnDb81gD5dhCvEmb8DFXa3N9c1+Kd46PFv2Yxloi0LzL0CPoKyapR3N8xFssEBskcZQGbkYc3eNkQFXlioz0ewbsuVHc2t+7eCnggT/OANZTGzlcm53J+Xe43wk76X6GfYIcYf6X43PE/sYzxgqEXBP50AGUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XOw8sgAFW0x/NTS52igENbaFc2d9uPktjMRBfy10+74=;
 b=CaXgru/FMhbBqxhJtboizyoncMuUs76w1fJZMgzlf6vrn6fM3siJmcXeJ9r7v1+ae+jXYkTCZPLtCzZepdJKKCX/+X5BlguXPt5EHNBT17AddnmVxDDqTKWsJBAPhL0hZaZSMQbxu71TKanAQgACoHEWn6jMNEeQUv+ZdI+uMPpls93l3YTseTBz8udo4cE3FIq8enchN7D+2ib1qRDarUoIXQnyA78m/ike6eZPvjR3ypTzEn1PkyPAjBPyxsgNTZ1cgyI/ax6W1bu0Ae5AtHcWLIACt55tshQVsFa7BfR/1j9yARBQ8zz2pjv+CPnbHvCCQq5dz+Qvip8rEc9ErQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOw8sgAFW0x/NTS52igENbaFc2d9uPktjMRBfy10+74=;
 b=U0qWtX9xveein0dSn1agGQWrT5I5bsnxtDa2wpmMEcI+g1UhAuYV9bA5KXaAX6ZsTsGbWI58VPgWxzgu+L/M5P3yn32CGEZ0kL65tILDboolT0/ShhvRfFrNfzSeOKdnDIZFSTa9okakiq8dzwfqVQYpIBCEtO0rtP/IGNVI5hY=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by SJ0PR18MB4930.namprd18.prod.outlook.com (2603:10b6:a03:40d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Mon, 8 Nov
 2021 11:02:22 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::547b:90a7:d7be:94c7]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::547b:90a7:d7be:94c7%7]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 11:02:21 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Ariel Elior <aelior@marvell.com>, Jakub Kicinski <kuba@kernel.org>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: RE: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Thread-Topic: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Thread-Index: AQHXyqDh2TAr+aaEAka5b0KFvfxjIavlxdqAgACI1ICAAJL0gIABNaOAgBFm/aA=
Date:   Mon, 8 Nov 2021 11:02:21 +0000
Message-ID: <BY3PR18MB4612A7CB285470543A6A3C3CAB919@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20211026193717.2657-1-manishc@marvell.com>
        <20211026140759.77dd8818@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR18MB465598CDD29377C300C3184CC4859@PH0PR18MB4655.namprd18.prod.outlook.com>
 <20211027070341.159b15fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB4655F97255C0E8AEF5E3FDCDC4869@PH0PR18MB4655.namprd18.prod.outlook.com>
In-Reply-To: <PH0PR18MB4655F97255C0E8AEF5E3FDCDC4869@PH0PR18MB4655.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7b38e9d-51f7-436a-02e3-08d9a2a73d38
x-ms-traffictypediagnostic: SJ0PR18MB4930:
x-microsoft-antispam-prvs: <SJ0PR18MB493001E9603C3384DBEDB704AB919@SJ0PR18MB4930.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VXKPRyUp1nucYNRckhOiq9g07ZDmK9BZ/3qXaBoDdHudYT0lqbWZQqnPCn/cqDXUPYHnBfulDdEBO7tR81sFsIc0vTh89oHDs1wIwv1caeNljTaCoGPI81L7BKgfwTR0GhXY0bX4GiGY88ptsgIoMKcoyrRkgRvftVrI9mk3GO1d0GH0kkdqJK02chwZJbDl+YqyeIE28NRBwKY1gLvSGLn+KTBVChb1sW/qzbQcRMF7CIRy3RA7qCTnwvoTZBshaRpdYgL8uprOw8KpM0j1i+/wA1QtbH5HzrCT65ITiKkAyVmmQ8CZREmVBFNSpCoNIjT7a6TGZF6H5Cu8qdC/93M+ckD5wFdCv9vWDTsA6PCMRNboPTRqt42eUlhG7j4rXOevIu7YNVhcSm5ZRFdy1NATfLAaC2nACMgQt5bIr2RK9b5c1lviBBcSbVnn2bQ8nwQps37dGG0boTnr8atU8F2+ILkMmKGxA6uuL3rJtp+eyB5kdPkqM8XeQt7IANT+rOZIBGzKAGPe+J4ROIdprGeKM0rtlUvVSdXJYaKXTCxPsXubuF34Rr7USyfyGUgBkhmh/FdieYl8HNZK6sPTkk5FpsJ8dj8x1NLM3oaAObBMzMOo3oJw+NZB7LEthPo68RRI+QpNB3h7Csfp4YYUlpp64au6CrFfUqS8Gsm7xOBHLU6Flw+pO6p+tmoSQEa+QS1HBPrSDe4XVPytPASbt5suZgvUQJXCCVnLTYrwbvdmLIt6497FSJVVUScD6Q075RiWnRc4j5vqRpSOObOGOAHClxaJ9jkA6Bzkl6o/+cA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(83380400001)(38100700002)(8676002)(33656002)(7696005)(9686003)(38070700005)(508600001)(71200400001)(2906002)(316002)(4326008)(5660300002)(66556008)(186003)(52536014)(54906003)(53546011)(6506007)(110136005)(55016002)(122000001)(66946007)(966005)(8936002)(76116006)(66476007)(64756008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?S0+arSiOXn4ANYvHD//V6abdsF6qJO96bwTg3SoFmlcRlJN4IY/VhbjnTcHd?=
 =?us-ascii?Q?m2qr4xEsXKRGwbXAy34zplk5KzS8Jy4GM2rcZQoInInuAmEljBMBiM6BJnM9?=
 =?us-ascii?Q?DSqbj4oPUNKP4nBnn9vULEZuAaCksfsmGbPLoY7sr2a+3PudbbcSpyUKbWc2?=
 =?us-ascii?Q?BRvazuLHauOU2E8OXA2PjRnwT0Bl5+mXi8Eo763t1iyp4jicCGRUx8G0VFHE?=
 =?us-ascii?Q?VkiAcvfwOxZj/VAuDPDIq0t1dte1HYaZQPcGdTg8MuJCkNL35XIE8niN/mi3?=
 =?us-ascii?Q?zaSza1CUxQamnxfTQTR2nZNNz9vp/q2JHGkz2722Ardf/PHe7MxShPG4/Eh+?=
 =?us-ascii?Q?7aszRSqfPrMXCOhGbq9ZHITXR1+5HYx4Bds4ptQqKHRPC3G3rOvqwBzHiioZ?=
 =?us-ascii?Q?5Q76WFVI/FsSZErTlRBnmVf+Ovraz9pIsPXprDYaHmVjzVuy43ItHrzDehbo?=
 =?us-ascii?Q?yCqjologS1TqAub0H5D2fiGiC9TpX7iy69X7DeTkw4TwydtHkyGiFD8Hgffs?=
 =?us-ascii?Q?5PvoPbmbqy1Yudv8hGLCi9HZiFcs9WVQBBRn9UFJ2djmfa0n2LxxknGVsTGR?=
 =?us-ascii?Q?5rqk0bxr3ZrL8iIa+Cn5rEFhD96rgJpH1AHgIB8N3jzOpYmiKd5am8FFpLBo?=
 =?us-ascii?Q?omKg2NYlkzEfarHZzzT7X6hP2DtiVIZahpU7jhOPFyhiXZrukGSSiD+dKGlG?=
 =?us-ascii?Q?6Wk/lAwiJSQxUt/OpzkPX8MSaYtx0DkpUefBZdBTNr0Tht4mj6N12kFuO5nz?=
 =?us-ascii?Q?cVWZCxaV1oH9jtFALvnXlX74+gMaTIFYldWqZ9khot4p0axPzxzC/21+AICT?=
 =?us-ascii?Q?7eKOho9ZAnfvj3+IyLyS8tVDWoQ9H8xqbN3x2XZlCKXVA9Aob6s0mdXSQgdT?=
 =?us-ascii?Q?X9SRA6m1SfHIeX+r7DfBOTKLcAsbPrfeyaPCkj4aCodkDlO/NnrQLw09nZDx?=
 =?us-ascii?Q?31lMK8hMXUqdrRJ1ITcFyUYCwTCYAnHQG1DGBjh3tu0Zu2gAIMeZQT2DtXFv?=
 =?us-ascii?Q?VYRtruXgdLbLV5VCjYZ80rkilY18VAeZgLeKwFwv9yQoaPO70L3c8RcFKrS4?=
 =?us-ascii?Q?pbOtpzCsyIxYTZNDKIRVT80fKfX67vzoF2PMBU/nU0vKXNEAbQ55wKPVW1yu?=
 =?us-ascii?Q?D91jp9Ktppgl2a6WTgxGfxGovRv4dqE62XgPgTF4qDp9WmOc/HjRwa798frf?=
 =?us-ascii?Q?WMrfxDs6otKv0rvwAqbzVTKa1HqsDaAbVZanabrPaJbOOnY8QJgwIYMXIJTc?=
 =?us-ascii?Q?tTN//vTC7so4kMOXoijAFvtQaVwKUHIYTlforfHQXdESCHeXhvQE8NHVdadj?=
 =?us-ascii?Q?NtUC8d8ywufhnxxR2BjuePJ8YM445k+A34RH0OD68dQz+bH4AsGmrRDSDO57?=
 =?us-ascii?Q?Vu4ALWX7xQzN1uRv+lmM54YX6DKcFb6KOotbObBrwTitrBaAYLbpeHXgxpX7?=
 =?us-ascii?Q?Q6wr3qGn8UdYjT8TrhKKrUEV4oQF+mFj6ZYHhDVFDNHA2AUlDQZFL6ti9sWw?=
 =?us-ascii?Q?UH3d5L8sibiH09JRILEr+A1oDIVLXTrVg5Zgpa4KWKBHrhuelgySh/pg9Wb/?=
 =?us-ascii?Q?9s9+U5eO+UwTmUmhqX/07u5rCWOFhKl/Zjw0Cg9qRRLKYr3n2nSQCCWZS9bc?=
 =?us-ascii?Q?Es7KhIAQdPCwSAM4I9zF7Ec8wSpejYAHy1OWt6OrKUlehwIv/Wd8qKa/7Xii?=
 =?us-ascii?Q?puJZK1qPe7X3oiYFv5wNlpfZ2FE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b38e9d-51f7-436a-02e3-08d9a2a73d38
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 11:02:21.7057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NRRB/g9dCXH5vcIK78fqiaijbWwacnlnBwc3RLuiIPIHNrSJioU7TRjQTpwF6kJTMds3UwiTqiR9bIABbp2oHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB4930
X-Proofpoint-ORIG-GUID: UXIV5GaetCh4KRQxXAQSjcGeQBs6LADl
X-Proofpoint-GUID: UXIV5GaetCh4KRQxXAQSjcGeQBs6LADl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_03,2021-11-08_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ariel Elior <aelior@marvell.com>
> Sent: Thursday, October 28, 2021 2:02 PM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Manish Chopra <manishc@marvell.com>; Greg KH
> <gregkh@linuxfoundation.org>; netdev@vger.kernel.org;
> stable@vger.kernel.org; Sudarsana Reddy Kalluru <skalluru@marvell.com>;
> malin1024@gmail.com; Shai Malin <smalin@marvell.com>; Omkar Kulkarni
> <okulkarni@marvell.com>; Nilesh Javali <njavali@marvell.com>; GR-everest-
> linux-l2@marvell.com; Andrew Lunn <andrew@lunn.ch>
> Subject: RE: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.=
20.0
>=20
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Wednesday, October 27, 2021 5:04 PM
> > To: Ariel Elior <aelior@marvell.com>
> > Cc: Manish Chopra <manishc@marvell.com>; Greg KH
> > <gregkh@linuxfoundation.org>; netdev@vger.kernel.org;
> > stable@vger.kernel.org; Sudarsana Reddy Kalluru
> > <skalluru@marvell.com>; malin1024@gmail.com; Shai Malin
> > <smalin@marvell.com>; Omkar Kulkarni <okulkarni@marvell.com>; Nilesh
> > Javali <njavali@marvell.com>; GR-everest- linux-l2@marvell.com; Andrew
> > Lunn <andrew@lunn.ch>
> > Subject: Re: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware
> > 7.13.20.0
> >
> > On Wed, 27 Oct 2021 05:17:43 +0000 Ariel Elior wrote:
> > > You may recall we had a discussion on this during our last FW upgrade=
 too.
> >
> > "During our last FW upgrade" is pretty misleading here. The discussion
> > seems to have been after user reported that you broke their systems:
> >
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> > 3A__lore.kernel.org_netdev_ffbcf99c-2D8274-2Deca1-2D5166-
> > 2Defc0828ca05b-
> > 40molgen.mpg.de_&d=3DDwICAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DcWBgNIF
> > UifZRx2xhypdcaYrfIsMGt93NxP1r8GQtC0s&m=3D7SlExiNTnqs5yykfN6rmIWZvB
> > wQtSHCEW1ZmdHhe3S4&s=3D5OfVYQjTBOqb9GeN7GmGw70U_7MZLYz9YDyl
> > o1iqdtQ&e=3D
> >
> > Now you want to make your users' lives even more miserable by pushing
> > your changes into stable.
> >
> > > Please note this is not FW which resides in flash, which may or may
> > > not be updated during the life cycle of a specific board deployment,
> > > but rather an initialization sequence recipe which happens to
> > > contain FW content (as well
> > as
> > > many other register and memory initializations) which is activated
> > > when
> > driver
> > > loads. We do have Flash based FW as well, with which we are fully
> > backwards and
> > > forwards compatible. There is no method to build the init sequence
> > > in a backwards compatible mode for these devices - it would
> > > basically mean duplicating most of the device interaction logic
> > > (control plane and data
> > plane).
> > > To support these products we need to be able to update this from
> > > time to
> > time.
> >
> > And the driver can't support two versions of init sequence because...?
> Well. Generally speaking on the architecture of these devices, the init s=
equence
> includes programing the PRAM of the processors on the fastpath, so two
> different init sequences would mean two different FW versions, and suppor=
ting
> two different data planes. It would also mean drastic changes in control =
plane as
> well, for the same reason: the fastpath FW expects completely different
> structures and messaging from one version to the next. For these two vers=
ions,
> however, changes are admittedly not that big.
>=20
> >
> > > Please note these devices are EOLing, and therefore this may well be
> > > the
> > last
> > > update to this FW.
> >
> > Solid argument.
> At this time we don't have any plans on further replacing the FW, so hope=
fully
> we won't find ourselves here again. Another important point: the major fi=
x we
> are pushing here is a breakage in the SR-IOV virtual function compatibili=
ty
> implementation in the FW (introduced in the previous FW version). If we w=
ould
> maintain the ability to support that older FW in the PF driver, we would =
also be
> maintaining the presence of the breakage. In other words you may be bette=
r off
> with the driver failing to load with a clear message of "need new FW file=
" rather
> than having it load, but then having all your virtual functions which are=
 passed
> through to virtual machines with distro kernel fail in weird and unpredic=
table
> ways. For this reason we also ask to expedite the acceptance of this chan=
ge, as
> it is desirable to limit the exposure of this problem. Back to the EOLing=
 point: the
> set of people still familiar with this
>  >13 years old architecture is severely reduced, so would rather not to t=
ry and
> invent new ways of doing things.
>=20
> >
> > > The only theoretical way we can think of getting around this if we
> > > had to is adding the entire thing as a huge header file and have the
> > > driver compile with it. This would detach the dependency on the FW
> > > file being present on disk, but has big disadvantages of making the
> > > compiled driver huge, and bloating the kernel with redundant headers
> > > filled with what is essentially a binary blob. We do make sure to
> > > add the FW files to the FW sub tree in advance of modifying the
> > > drivers to use them.
> >
> > All the patch is doing is changing some offsets. Why can't you just
> > make the offset the driver uses dependent on the FW version?
> >
> > Would be great if the engineer who wrote the code could answer that.
> My original answer was more for the general design/architecture of these
> products, and a general design of supporting multiple FW versions on them=
.
> Specifically for this FW change, as relatively little has changed, we
> *could* maintain two sets of offsets based on the FW version. This might =
impact
> driver performance, however, as some of the offsets are used in data plan=
e (e.g.
> updating the L2 ring producers), although I suppose we could also work ar=
ound
> that by preparing a new "generic" array of offsets, populate it at FW loa=
d time
> and use that. However, as I stated above, I don't think it is desirable i=
n this case,
> as the previous version contains some nasty behavior, and it may take us =
some
> considerable time to build that design, allowing the problematic FW to sp=
read to
> further Linux distributions.
>=20
> Thanks,
> Ariel

Hello Jakub et al,

Just following up based on the comments put by Ariel a week back. The earli=
er firmware has caused some important regression w.r.t SR-IOV compatibility=
, so it's critical to have these new
FW patches to be accepted sooner (thinking of the impact on various Linux d=
istributions/kernels where that bug/regression will be carried over with ea=
rlier firmware), as Ariel pointed out
the complexities, in general making the FW backwards compatible on these de=
vices architecture meaning supporting different data/control path (which is=
 not good from performance perspective),
However these two particular versions are not changing that much (from data=
/control path perspective) so we could have made them backward compatible f=
or these two particular versions but
given the time criticality, regression/bug introduced by the earlier FW, bn=
x2x devices being almost EOL, this would be our last FW submission hopefull=
y so we don't want to re-invent something
which has been continued for many years now for these bnx2* devices.

PS: this series was not meant for stable (I have Cced stable mistakenly), p=
lease let me know if I can send v2 with stable removed from recipients.

Thanks,
Manish
