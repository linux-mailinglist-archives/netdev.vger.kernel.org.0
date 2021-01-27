Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BB5305F8B
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 16:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbhA0P0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 10:26:52 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11900 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235869AbhA0PYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 10:24:53 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10RFK9CF029171;
        Wed, 27 Jan 2021 07:24:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=IrfmPQXhcGZMPRR5AhDhQYd0lAi4VlVIKC2Tmv5kS7k=;
 b=iEtgl0ETHgwoPxA74Ab2ARSSzBpa1ilZrFJ2NP3iHmtCj6Sy7M/XDIDq1hgVWlgSxdU4
 1/Rja8sVAeHNAPuaB4V6pPEJzOR348k3gwVBCKgObSVzRKq4w2VBr7+fZSGc0fH7bJrQ
 ZepbTNoU7Jn2kag7naolC6Fq5I5BTJMQEnnQX0jXD+CnDiA3tJIhB8bgrNg/eTGtJBjw
 RkrZNqQ+fu1vquehBvjsuN1C4VzaCyI0enhoizkyWFrXEj+yovkqFv5TIS+lZlCnpvmQ
 f5jBvjJxYZK7Bb1p2fKWTkNrnL3quDxmVu6XDNhUTz3EYvXnqXSVFoohMr0IfB90yEvD qA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36b1xphbmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 07:24:01 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 07:24:00 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 07:23:59 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 27 Jan 2021 07:23:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNuQSdZjX8jAL/YKED1cN7k7ClNkKI6LiJDtX/V5sB5XpBKmg7QsZ6LaFh50xN+w+Pqi2eqdbaqgzE6KLmfAwLj1DU/4c38g+MnNu3U4woezGWiibiX4tcTioex3gyL8Suq5j8PNbIQa18zKKljub127cQvdwUmBdxctqtgBiJ9ELvRFID9ZhruSU1XsX085K3RR66uwlQAhD2Y07nSzxwkKgs9LILv3eFSC0AJvq1uPBRPWvuBGEITY09Wmx2U4ZGe6RL+IAUJAwGXb5L0c3GLCZ3K2XhrUi0VMvd7TJXvSpsqMdCDAN0/MgMC22rU0/s8xKelGqZs9oHLLU8QASw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrfmPQXhcGZMPRR5AhDhQYd0lAi4VlVIKC2Tmv5kS7k=;
 b=Ga+c0Ndfyx7r7M812kndPe+gbEhhIxD9ItZgQ6NUfMbEwnSoOxMK2YinGmnb9/6QA8cU4o+Hi+YiQL3EyCH0d/cHC+muMbteexE0GaOpt4P9mXLtjcFX4CMStak9t99SlA3XWpDNbWonxW2pL90J2HKl9Y6PQ20iOVMgsQU+9q8+fC1o8tRLE5XG7gsnBO69xnlrh4ycEqyiaYlzXOF+U/eaCiJuNaSerXW1u0Y+cL70vfMB2AyFM+1PjfvC3GMwFfLAL9mgW7tcT6LVJIPvaJm6wiLeWGFeLAd6tDqtYPeugiC7Ookr1CgHDmy5cL0S3NMSdxMjJuewdX5WQ/pgJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrfmPQXhcGZMPRR5AhDhQYd0lAi4VlVIKC2Tmv5kS7k=;
 b=BR5U4FuIA5HxDLFfF+pG/mElcptxl9ab8ZJgJHDSzFcGPQnc7PzU7buzsrMflyOPh+zhYud6BAcxu1TDpuZJdEr6UzRdecarHdRntoVrXaOVSY4JjzxwPK6zpzFVXlzXfl1Bd7fnEeUguuvQrS2CjxHoHYjdk+cfhorY65jGmD4=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR1801MB1856.namprd18.prod.outlook.com (2603:10b6:301:6b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Wed, 27 Jan
 2021 15:23:56 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3805.017; Wed, 27 Jan 2021
 15:23:56 +0000
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
Subject: RE: [EXT] Re: [PATCH v4 net-next 19/19] net: mvpp2: add TX FC
 firmware check
Thread-Topic: [EXT] Re: [PATCH v4 net-next 19/19] net: mvpp2: add TX FC
 firmware check
Thread-Index: AQHW9KHjwS0UHLuva0e0y+cDZ3p/aKo7gciAgAAH8aCAAAcogIAAAiVwgAABmYCAAADuoA==
Date:   Wed, 27 Jan 2021 15:23:56 +0000
Message-ID: <CO6PR18MB3873DB2951C432DF87F6F0B3B0BB9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
 <1611747815-1934-20-git-send-email-stefanc@marvell.com>
 <20210127140552.GM1551@shell.armlinux.org.uk>
 <CO6PR18MB3873034EAC12E956E6879967B0BB9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210127145955.GN1551@shell.armlinux.org.uk>
 <CO6PR18MB3873983229F0F664A0578A3DB0BB9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210127151319.GO1551@shell.armlinux.org.uk>
In-Reply-To: <20210127151319.GO1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.11.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ffc5a54b-c748-4617-64e7-08d8c2d7904f
x-ms-traffictypediagnostic: MWHPR1801MB1856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB185614CED22EB3D3C5E975E6B0BB9@MWHPR1801MB1856.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vZivYS4mN6HAp5BacB5LSXeYcWKtpzifbJctYzpTnMfQPjSQoZVi9QanaNROtCyp3lkOyCZkyuZ1Xl9J9CX4I5BTEFPe8IHUD4d81tPx4bANQeQ/hEBqGM8O+RQzVmt21KmEXWZ854bzWSVo2NmMUt295BrrOMdjtI7H+PUZFIaDlj5+RBTW7K+HMhsnO40278cvyIhXWEphjTZRdPRKeU+J5gag1epEfS+AA2VPKy0/xTI/dH8+ZRpnjN9cunNIqWUMFs/rIYd518SpNVcFORxH6+GhoEpUglNCeDJs5Ycw5A+Blt+QcF5vmUBtQAPR20lCzrFGPPbYojx25H1wyXmtx2mu8xxsOwhAGs3cfBKFacNCxHf3rSx9Rq0XCXOKFpPhFJou2/a8INRyLHmQyk8cxf3IlqZYOkuRxPdTp+pJb8GvzwMB83UxYW998zgpQWUPDj5jBNUAnPi64HiU9YeUka3gVqKddo6MJLBPD7rXQwK9OTcPztSS+so2bjRQmqqxehzBXw7JEy44oo712g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(6506007)(6916009)(8676002)(8936002)(66556008)(2906002)(64756008)(186003)(9686003)(55016002)(86362001)(71200400001)(83380400001)(52536014)(7696005)(5660300002)(54906003)(4326008)(4744005)(66476007)(26005)(33656002)(316002)(76116006)(478600001)(66946007)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Vyk5XdsNy9ueIuhFcI+cbteujjalA3/tWPa2OiTxeeCNFyl+l/DosZPjQly9?=
 =?us-ascii?Q?WEoAiFHzuUXrd4CyHNhViq1PYIDdxOf487yJFIrUhLmrBqYc4rNzqFfWrETj?=
 =?us-ascii?Q?DKQkN33kF6PY9wdNk80ENS9EkU0BFs/8uQKY6b7UCE8sDBo7EzpgIUar5hdc?=
 =?us-ascii?Q?x8+eEZs9ka1BroN2mtmbJo2lBvVJEdE/z8V1j6WR3cpeVM1gl02u7RuSDtGy?=
 =?us-ascii?Q?XlGFKKwCF3c8ZZAUMVaU3APwhCLFhb0aBzx0jBZfQ8WpktC4IEXiBkOazKCC?=
 =?us-ascii?Q?DXzf25/IeQEbBLiab8dnHmozO0m0f3o+tE+n1ARx2vKP/CtM6LyRl1wDJHCd?=
 =?us-ascii?Q?1PzhOLZrtUIAS+gg53EITf/GIhOB7mACrRlON2F/aMVNJe5eNxXrUHyTI5C6?=
 =?us-ascii?Q?lZSYo6rJDRNjmxTWC6T8KK/xzHnCENsEGf433jfKjuTZmeqplAKCo8CBvqnm?=
 =?us-ascii?Q?U0PLWbX0ZXM3140nAAlAWo18JYprB0Gr5B+rPc6h8GOP4tI0q11LyBq8CXdr?=
 =?us-ascii?Q?73k7kcAonON+pKAyX1yPlCTDb3zRyVkzilajj2Pl51+HiWzNFlEplahEoPvY?=
 =?us-ascii?Q?w/UQLDOcqXqvxZIL/JeG3EeiJVNFboEOCq82nPNC0/3n1140PvCDqayEpmBo?=
 =?us-ascii?Q?RjYRWBIgi/vtlqmoWtndt2Okn6DjjqttTYfcngSeSdCZ/ZEilT0HqBwx0FpA?=
 =?us-ascii?Q?6wAf8mk4zwULvPOVO6yvJqLu83MJwkjv0j6guPZ3j+4VY9N5s0DPjOPo6TRD?=
 =?us-ascii?Q?gtJXowppjmsg1oYXhAsiLv/XovA+N1eCgLPJDZ+/T0vUOvLSe0oSof6qExoa?=
 =?us-ascii?Q?+4ezcaT/U3qNK4H9R3RXSsRflXwh10GxhWsy0Ug72KH++zW8el9kwWxRYIR5?=
 =?us-ascii?Q?7/2ZxjfEQ7DYiGS6sVfMiK+wsUS8bU99yAEWS3uZJOGAD18lj5t2DwYWLlzk?=
 =?us-ascii?Q?s9d8cQEAWRHvpOqAlhDqzcv0EfCjuYT44NoYE8L6i1i1lFKahabuebUHWPfr?=
 =?us-ascii?Q?9GKvv/aZ8GTYTR1CTG7CVw3QEDVEknrfyehrwwMO7zYTCBLJtx/Y1QKN8DaJ?=
 =?us-ascii?Q?tVKWHnGu?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc5a54b-c748-4617-64e7-08d8c2d7904f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 15:23:56.7018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cqWsTOxg4fc2cRghSqaH70rbt+yyRHIis0+Py9e8XXwdRTfLQ0LBEVY00i6Gq5i5Ov3DyhbPuWqQD93GJKmxkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB1856
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_05:2021-01-27,2021-01-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > You can devmem 0xF2400240(Device ID Status Register).
> > #define A8040_B0_DEVICE_ID      0x8045
> > #define A8040_AX_DEVICE_ID      0x8040
> > #define A7040_B0_DEVICE_ID      0x7045
> > #define A7040_AX_DEVICE_ID      0x7040
> > #define A3900_A1_DEVICE_ID      0x6025
> > #define CN9130_DEVICE_ID        0x7025
>=20
> Thanks. 0x00028040, so it's AX silicon. Is there nothing that can be done=
 for
> flow control on that?

No, we cannot support FC with AX on A8040.
=20
> It would probably also be a good idea to state this requirement in the
> message as well, rather than just suggesting the firmware revision.

Ok, I would update this.

Thanks,
Stefan.
