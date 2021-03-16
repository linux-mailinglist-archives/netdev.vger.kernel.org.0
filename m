Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0808833D9D9
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236427AbhCPQw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:52:29 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57040 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236437AbhCPQvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:51:52 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12GGf1nm003426;
        Tue, 16 Mar 2021 09:51:32 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by mx0b-0016f401.pphosted.com with ESMTP id 378wsqs3nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 09:51:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ceBhCO722qksCXvtXKm3vY34NjXCvGU/a789SpuwHO4SevJ0hC5D7e6rsKvtGYzTEBw4n38rtb6/0y2Jt01ReM9zB5uKv9ialM4DDKTj1RgD877fM6xeTdSZOVdHnIw7YvCvdYvbeoeBfRC7V4C1eZPkDnqFLFgnPSw17J0bghj6ZkOjPtqX/ycnl6ncm4oZu+xOpgJausaCWkbsN9HQoZlihbkMJZ3CkwXgfTAM4LCodiRYtZOJLxRo7tBPszLJvYgCp7Iy+B9wTAhCm/cdd4Kz9wijfGYaEAxpHanDnfNuER5afOoEhxrwJieW/4oKqG19QVIkbQS+b28Hh8h4gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/ZboafmXdZpYd2LmyMWqDWLQe4MFVJO8Eow7VSExps=;
 b=PF8VYxGfZUKqAJ3UAp0sDXAk6x8b0o+c4FZJk9tbdSVwYNd2TRApMR6utVktmR6xrwKGaOSNEPHm/zyy8v7H2cPbLvwVsyUGNfzJSJCfh6vH+XbPTN/UsYepvHPk4zx8YPb8OxrilcNFOjRXcya83gAzG5tu4H5WRJY6yU61bR5i8/sLZpR9XhlVz6cDe1klmTdzfjqk0Z+vv6hNoGT1i9UR1KhEvVwitapO0tnkzQ/8bgYnL3g21/xw05qkrjHq9JEXi35y0FkA8ZQIRr4rGQn6C4oIFTZoajHIZkumzy0w4uCLKMEJCyXWajVj2jIz0suzOPYx8T/CIMGRj/kb3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/ZboafmXdZpYd2LmyMWqDWLQe4MFVJO8Eow7VSExps=;
 b=UJXH4s+FxFcJxQT5FvW+G2oEn2uyoc8/7soQ8vcuPG8rXRGSDpKCPcPRcbSJdNzjaTucNEGZ+Zga4/zDFnPFxTzpuc+tzkdfxeU1+5rxybbzuDFN1dMFiPvSq4au9Pk07uCaoXnL1gEvfRqqkF14K+KwxlXP7AuxH/VlB5BZ+e4=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3921.namprd18.prod.outlook.com (2603:10b6:5:342::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 16 Mar
 2021 16:51:29 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3933.033; Tue, 16 Mar 2021
 16:51:28 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>, "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "rabeeh@solid-run.com" <rabeeh@solid-run.com>
Subject: RE: [EXT] Re: [V2 net-next] net: mvpp2: Add reserved port private
 flag configuration
Thread-Topic: [EXT] Re: [V2 net-next] net: mvpp2: Add reserved port private
 flag configuration
Thread-Index: AQHXFpW4dTR4hPIdakagD6uzfQ/d0ap/ArIAgAfBQuCAAASKgIAAE1Kw
Date:   Tue, 16 Mar 2021 16:51:28 +0000
Message-ID: <CO6PR18MB387393B1CEA068893904535EB06B9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1615481007-16735-1-git-send-email-stefanc@marvell.com>
 <YEpMgK1MF6jFn2ZW@lunn.ch>
 <CO6PR18MB38733E25F6B3194D4858147BB06B9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210316154129.GO1463@shell.armlinux.org.uk>
In-Reply-To: <20210316154129.GO1463@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4927951-3557-4cfe-25fc-08d8e89bbeb4
x-ms-traffictypediagnostic: CO6PR18MB3921:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB39210B456C1C0A237B0ECC40B06B9@CO6PR18MB3921.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: neVT6kuN1nGW0Q5nC65GCPdck/rGLEKUgie+1gAhi9a5SrstZ5DnbzkhBsXszDAuOvExZ8go3VUtpXnPLdid/sshFQqxeo4PliaPNKSTV9llfSfCdQI7P6U5Jls34WvxCmuZHqj+K9pUfS8CEpEcq6DgBpddrBs/Zp+hewnrzxqxEtf6AYHScXPpbPNrEbRgqJmolJfF6Y1BuZKZLZuiLxlC44PXm/X/AMHTgQIGkOdtvmmGbe5FfdlHzVRa7V6R5/U1HSFghFnXNqUycXNL2pla4rs63gh+ifDdtHQ5wJsHoNFpXftsqxpxw0ZAwn9I3YgDPuJvLxPWj6ee9ShTkhzqV4R8UlUNa3ARtMY48k4e76G1QIVXsxqGA6exUCF7v1uJ/iAHvCox6eC6Nfr9TJjANCA4NXVyd1vIoskyll/qxtiOIlrNFj5mxHXzRPpfog7rWr7lL0NufmrQo9Tbe2mmscPQfNlc6Gd3rbs0RwfICr8bycDDpD6Yd6Md9OFMOJhfTTszP7oq2UDiPLfnjyxMJgY6o/J8oxmGgG0PwqOYLbhl8RPU1XEtQRrb6tMo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(6506007)(498600001)(66446008)(66556008)(66946007)(66476007)(186003)(5660300002)(55016002)(2906002)(9686003)(7696005)(76116006)(26005)(4326008)(8676002)(71200400001)(86362001)(52536014)(54906003)(8936002)(7416002)(83380400001)(33656002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?p/hvi3xBQDplKlcVLnkn/0nvP/zRCGe4jptbFVJaoLP7s4YODkkuW2S4aE?=
 =?iso-8859-1?Q?0X+/EWJpZbT1LSi2EPQHXkEVHBsPgWDCC43euCOxn98SMubw7JMSy8T1rz?=
 =?iso-8859-1?Q?BdByAq4LGnhK3xmJBe3okx6ONheHetu/sIiB8J1YN+0hbfY0avmnMckSWf?=
 =?iso-8859-1?Q?R6zyUyD24YlMRZAbRL/uvaxv/b6TlYRZqX/C5xLt7UTuPBMue/wJu8UyDo?=
 =?iso-8859-1?Q?/lDjyGCPQ52icJUDSygYOV3Pqjlr2Tig1dp+O0HqNiTamnCWzFE4UjKtJW?=
 =?iso-8859-1?Q?dajuYrQzV4n8tLIoQH+XCVAvlU8t2a6ocjrR8YUGg9RDtPvo9JId51KInd?=
 =?iso-8859-1?Q?1BcmO9ACbURRbic1EeIoZV2kDc0g130p+2XJ5ghCWv+3joItqDz3h32dyl?=
 =?iso-8859-1?Q?F+TShgq1/OlqnC8Alom5migwOGXmosUCf3XNplYYYau4ejn8HovmSPC5ki?=
 =?iso-8859-1?Q?idTsqfH8oMVQJaQAawzq3CreAj2noiCJsWS3nfaCvOrXL4wV9qJJKus649?=
 =?iso-8859-1?Q?mAkPERrDkQxj7azS+1Buj+meInx8w/EdosH8mIBms+H0n9XchvMxhzR0d7?=
 =?iso-8859-1?Q?7Tiyknv83m6gkCExo8F+CBpYaTMBnhWveNMk3YwgiESOgzAJolFnGiCHJO?=
 =?iso-8859-1?Q?oO/32qBzY1T+cekNNFGykSWFccJXJjV4PopJXzpfoeMjCThjawijB4I96E?=
 =?iso-8859-1?Q?zeHECV4W7XWcJIv6aqmLBksRveNjxO10uxxKbPwQyX4IEKSmATN+7veD4D?=
 =?iso-8859-1?Q?7naLmfNYV0lwVbU6rk8BIVA9wJ6C2U/HLTDfF2cPgdHR4kUEwP4fv2fhGX?=
 =?iso-8859-1?Q?/R57oGZIYuWCDTj3HqgwpXv9leDS6Z7Mc9jdmo4b2vsMG9eTVIZgKkTjb0?=
 =?iso-8859-1?Q?1qTYBvT0McAQFJELtDCU659Ln85bbeyN5h0SiSWIIbjg1eg/DwBK0dD41l?=
 =?iso-8859-1?Q?EiSKs+3KBehnRAW/83it3xEtb/5DRGVX+6rxLRIXuHeiCc40lRzF/o/Y/y?=
 =?iso-8859-1?Q?+/j2VB2Wd5jf0EaLl60Qkbghs65xyc8qdOGzFQTt0kCb/8i9b5a1u40yVO?=
 =?iso-8859-1?Q?7dPbKv2Dz82yblfS82zCErU8ErgkT9+ODR9z+iDrSlbbozw8Ps+eSwMIZU?=
 =?iso-8859-1?Q?RpDOnNfgT+0B3UR1kUtJuEyjpueLLH3VmKK7pPKaN6cvMfUcKq8ES0e5PY?=
 =?iso-8859-1?Q?6Ki6iqF1jLDRYp2DGiMJZfGkiJhEepynGVAr3GGxpffgy+QFKXILCrQL05?=
 =?iso-8859-1?Q?C6J81b/2sMwdT5BueihNhuen8gNkwktmv//wLBbnWYr4VgQsku0NGHtZR1?=
 =?iso-8859-1?Q?sqG7wIiXMayzFZRedN8D0XzWz++D2xu3Zq9lI6l7uVqyui0=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4927951-3557-4cfe-25fc-08d8e89bbeb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 16:51:28.7548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pR9Eb16wH7ZXkWDPyGKiMmCwqC5TXynEfEfKFC/MemuW9lNoMqhHHYObNzoOU8gn4cG3jJtjzpPrO/lKs9P+tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3921
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_06:2021-03-16,2021-03-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I really, really hope that someone has thought this through:
>=20
>   Packet Processor I/O Interface=A0(PPIO)
>=20
>    The MUSDK PPIO driver provides low-level network interface API for
>    User-Space network drivers/applications. The PPIO infrastrcuture maps
>    Marvell's Packet Processor (PPv2) configuration space and I/O descript=
ors
>    space directly to user-space memory. This allows user-space
>    driver/application to directly process the packet processor I/O rings =
from
>    user space, without any overhead of a copy operation.
>=20
> I realy, really hope that you are not exposing the I/O descriptors to
> userspace, allowing userspace to manipulate the physical addresses in tho=
se
> descriptors, and that userspace is not dealing with physical addresses.
>=20
> If userspace has access to the I/O descriptors with physical addresses, o=
r
> userspace is dealing with physical addresses, then you can say good bye t=
o
> any kind of security on the platform. Essentially, in such a scenario, th=
e entire
> system memory becomes accessible to userspace, which includes the kernel.

Hi Russel,

This patch doesn't relate to MUSDK Packet Processor I/O Interface functiona=
lity.
MUSDK is just another possible use case I could think of for the port reser=
vation feature.
I am not responsible for the MUSDK code, but as far as I know it is based o=
n the generic UIO Kernel interface (uio_pdrv_genirq) so the user can decide=
 whether he wants to enable it or not for his platform.
For the main CM3 management port use case, security is not an issue since t=
he CM3 processor is secured by hardware in the device and its code is authe=
nticated.

Stefan.
