Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB37631317
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfEaQxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:53:24 -0400
Received: from mail-eopbgr20055.outbound.protection.outlook.com ([40.107.2.55]:59717
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726531AbfEaQxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 12:53:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jk+CL3jdhs9SpcJK5Lwm3NSvKgj9hpI6fynSFgJuYW4=;
 b=N8Nt/z6r0imTy6YKEDHrR5tpDwZ0tqA8aCJZn9/n1ouF8YOeChlbVo55Kt5MJGIUJ0Eh+BTjgmCfmd2Od0TCDRS59RsO6VjytwgQsleEZZEbmG4TBS6Tj1uwM8Goh7e8mGByPGXtaIAQrQtzpaz0fOV4APkTUdXJkWIhh/DCmmk=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.50.159) by
 VI1PR04MB5424.eurprd04.prod.outlook.com (20.178.121.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Fri, 31 May 2019 16:53:16 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::8d0e:de86:9b49:b40]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::8d0e:de86:9b49:b40%7]) with mapi id 15.20.1922.024; Fri, 31 May 2019
 16:53:16 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Roy Pledge <roy.pledge@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jocke@infinera.com" <joakim.tjernlund@infinera.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v3 5/6] dpaa_eth: fix iova handling for contiguous frames
Thread-Topic: [PATCH v3 5/6] dpaa_eth: fix iova handling for contiguous frames
Thread-Index: AQHVFvLDgVVLsICrz0e/ErKUP7YXHqaFbvqAgAAETAA=
Date:   Fri, 31 May 2019 16:53:16 +0000
Message-ID: <VI1PR04MB5134F5E31B993B2DC5275BB3EC190@VI1PR04MB5134.eurprd04.prod.outlook.com>
References: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
 <20190530141951.6704-6-laurentiu.tudor@nxp.com>
 <20190531163229.GA8708@infradead.org>
In-Reply-To: <20190531163229.GA8708@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2344736f-baa7-4d5a-28ab-08d6e5e87a3c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR04MB5424;
x-ms-traffictypediagnostic: VI1PR04MB5424:
x-ms-exchange-purlcount: 1
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VI1PR04MB5424420CD622D8111EBC24A7EC190@VI1PR04MB5424.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(39860400002)(366004)(136003)(396003)(189003)(199004)(13464003)(6116002)(7736002)(7696005)(66066001)(86362001)(74316002)(71200400001)(3846002)(6246003)(4326008)(76116006)(55016002)(52536014)(8936002)(76176011)(54906003)(25786009)(26005)(102836004)(33656002)(476003)(71190400001)(305945005)(6916009)(99286004)(486006)(44832011)(6506007)(6306002)(316002)(68736007)(11346002)(2906002)(81156014)(81166006)(53936002)(186003)(966005)(478600001)(446003)(14454004)(5660300002)(256004)(6436002)(4744005)(8676002)(66556008)(9686003)(66446008)(64756008)(66946007)(73956011)(66476007)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5424;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e+NCxI4BguB88QjxXUwOvRmeWulMM6zwS6B1T+zcO66WfdoiZt+BndN9L3qGnItxJM2JPIsl2zoW5qwmIswVBjUyoZMA22IcBpMM69LWkuAya5rTfOEY+DFV4q85WslmGukWMXhHcG+aQiLd/BN4Pd0XHZR77Sx6u5gOHPMwsGaw4ZRSwcepwJ0Q8ZXr0PElPw5Us6ngO93sF25FSm0OPwXEkg3curWJjrpqPJm/WL8vRv3TlPDT54V1SxDORNZSVLq02ayP83KGn/VCREHjdK69msFslBvMVsEOCZ5DOpcZ0UVIJw2FhhZ6WnAVXWkSVVVabMxqNF5U6ktof5HvJWwXQz4Msv+Wvl4D5IGK95/Jm71+VUDU3pJ8BE+HfFpMpS0z4CvAb6veSNtxb+CiZwp4uy7YtlCnMVqt2Okhi/o=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2344736f-baa7-4d5a-28ab-08d6e5e87a3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 16:53:16.3621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: laurentiu.tudor@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

> -----Original Message-----
> From: Christoph Hellwig <hch@infradead.org>
> Sent: Friday, May 31, 2019 7:32 PM
>=20
> On Thu, May 30, 2019 at 05:19:50PM +0300, laurentiu.tudor@nxp.com wrote:
> > +static phys_addr_t dpaa_iova_to_phys(const struct dpaa_priv *priv,
> > +				     dma_addr_t addr)
> > +{
> > +	return priv->domain ? iommu_iova_to_phys(priv->domain, addr) : addr;
> > +}
>=20
> Again, a driver using the iommu API must not call iommu_* APIs.
>=20
> This chane is not acceptable.

Unfortunately due to our hardware particularities we do not have alternativ=
es. This is also the case for our next generation of ethernet drivers [1]. =
I'll let my colleagues that work on the ethernet drivers to comment more on=
 this.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c#n37

---
Best Regards, Laurentiu
