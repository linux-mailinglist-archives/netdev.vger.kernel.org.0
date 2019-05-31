Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB82731341
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfEaRBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:01:38 -0400
Received: from mail-eopbgr50078.outbound.protection.outlook.com ([40.107.5.78]:39015
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726678AbfEaRBh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 13:01:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6h9eII9uonwD1v72h0OGLMf+bL05id0CifKWqh07YSU=;
 b=XlOffcS1Rxm9aAcxgRXgPR74q/vHahpDum7jLU7rtQUT2fMU+y3e8Z+IFCK1w8UgGkp/YpP88A1CVoRPjaJr4AutIl2xBFtOGurLovcGkO9Bsu//C7NVBFxfWB22anNV7KLBzdDjr2W4tC6SdZonCd7q43DsXmfTXgbPNESLT7o=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.50.159) by
 VI1PR04MB5422.eurprd04.prod.outlook.com (20.178.121.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Fri, 31 May 2019 17:01:32 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::8d0e:de86:9b49:b40]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::8d0e:de86:9b49:b40%7]) with mapi id 15.20.1922.024; Fri, 31 May 2019
 17:01:32 +0000
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
Thread-Index: AQHVFvLDgVVLsICrz0e/ErKUP7YXHqaFbvqAgAAETACAAAIjAIAAALuA
Date:   Fri, 31 May 2019 17:01:32 +0000
Message-ID: <VI1PR04MB5134156396FB7597FD2A0DE5EC190@VI1PR04MB5134.eurprd04.prod.outlook.com>
References: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
 <20190530141951.6704-6-laurentiu.tudor@nxp.com>
 <20190531163229.GA8708@infradead.org>
 <VI1PR04MB5134F5E31B993B2DC5275BB3EC190@VI1PR04MB5134.eurprd04.prod.outlook.com>
 <20190531165530.GA16487@infradead.org>
In-Reply-To: <20190531165530.GA16487@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26ea16aa-3f7c-4c7c-ca03-08d6e5e9a210
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5422;
x-ms-traffictypediagnostic: VI1PR04MB5422:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VI1PR04MB54226722E6C1BE9C206912DBEC190@VI1PR04MB5422.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(396003)(39860400002)(376002)(189003)(199004)(13464003)(81156014)(6116002)(6916009)(55016002)(53936002)(6436002)(7736002)(14454004)(8936002)(81166006)(4326008)(256004)(2906002)(478600001)(71200400001)(71190400001)(86362001)(66066001)(44832011)(9686003)(54906003)(6246003)(305945005)(3846002)(25786009)(11346002)(8676002)(26005)(316002)(186003)(99286004)(33656002)(476003)(7696005)(64756008)(66476007)(4744005)(66446008)(5660300002)(76116006)(66946007)(486006)(229853002)(446003)(6506007)(68736007)(66556008)(73956011)(102836004)(52536014)(76176011)(74316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5422;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fc5TLLCM3CxRpEM34pIodDt/YCSK56njIGz7aTliY/fS53/5Kq8LNgLOtRdtJRgS/+lkyLw8Ij1mEGE/Q7XRMy/L+TkDOmc1RE8HoP7pXENm3Q04ABU/LPCjHOid3ZWPTn9hvDXUBtgEVgjrhWnmFJneRsXqmDxOLXXv2v1ZBu2nPouLLIz5YN0cME2Nzatbj0OhDBxvCgB2Zq68TojEo9IDnk8QF/NeKpozD7jugiwhG73Fq7Jf5cgGs7LUf5d4yD1XTyNj4D1CRFqpM0S6bpxJ/CTRRGmP6hAiyckTADclnNqRsjsuW6Csu2rXI7PHs1DT2OfX8bwOam/zWHKsIUZM3Whm669onDkfEggUfaN5UBNZQnz+w2Tq6Fx8ji3hf6UScMlOu/YVCbrmN/I1HCKAhU48dmnb5EioaM8O9Dc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26ea16aa-3f7c-4c7c-ca03-08d6e5e9a210
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 17:01:32.6824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: laurentiu.tudor@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5422
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Christoph Hellwig <hch@infradead.org>
> Sent: Friday, May 31, 2019 7:56 PM
>=20
> On Fri, May 31, 2019 at 04:53:16PM +0000, Laurentiu Tudor wrote:
> > Unfortunately due to our hardware particularities we do not have
> alternatives. This is also the case for our next generation of ethernet
> drivers [1]. I'll let my colleagues that work on the ethernet drivers to
> comment more on this.
>=20
> Then you need to enhance the DMA API to support your use case instead
> of using an API only supported for two specific IOMMU implementations.
>=20
> Remember in Linux you can should improve core code and not hack around
> it in crappy ways making lots of assumptions in your drivers.

Alright, I'm ok with that. I'll try to come up with something, will keep yo=
u in the loop.

---
Best Regards, Laurentiu
