Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B34344A13
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhCVQAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:00:36 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25088 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231322AbhCVQAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:00:05 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12MFpPv8014020;
        Mon, 22 Mar 2021 08:59:46 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjnwj39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 08:59:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUXwzCc5H4QOupVhtq2/CqgJim8XSo+90veKJHm2KVKvvejyYZhWUVwVrTtdW7gLz9LIQmYs4fB2aRjDFFGOCA71gNglu2oHLnuC1YklZmKdCdXRSI/IWNKU0Oqp+tHJdG1R61U4Vib/TiZoT7RlTZojDq4TcVmPTeG2tlm8adUpFM/uijKQhb88eTuBwsFMBsGv06xn3z5h5/IprWPUJvuvSpYAWqZGeIf54k/r/Mabr32Rf50H05pk5TKFudgPsy6t6wPi50VSpvKcrnyzbll11iyn041jykTw9NnycusfAgq530YZR1rFM65Je0dThHSAUH4J0eURrLDs+Pqjqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpPO8a3JxCX97p5STk1X07uFeUj35ztUFO4MZXErjvA=;
 b=NhqP/e4wc+2GxTBFn91JN9JarwUrxuJn1Von98Vp1sOloCywSMY5NtoVICmYzAtAKIKsrNTrVGjCX0KdM/JqRh1gtgw0cpXtckJfLkEmD969ijETW1n1J4jTNzgIWIDxItIlBx4OlpXZSK6Okr+XDn5lAC4u1VZ5Tu6qiml4oPsxXcAQkSC6hVytMrAWs5lCw3CxE6kOI9ZL+akf3D/UszSnYAnquhWKZp8YYm0TglbjkLoHYy1wTKX+DHA0U5Yj5o70a0ysyGUvU4lxcofvVsRjKz9Sc1IUHunout/obvepYdrx1KsdXJJN+FBRNnf3c350USJg5wwX5qguS+/+ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpPO8a3JxCX97p5STk1X07uFeUj35ztUFO4MZXErjvA=;
 b=VGJLu02/kD8SlXpo5egEK/0vlTh7QaaWYJZ1f69wUE/6G6jBm422580DQNMCq9NdGxJQr5SBw9amqrAv3YMlQsYFk1hngAChqL1Q1Dp2Ap2m3JdHqsnX9HhZQ25r9jxEaRIjVmNk/QagO1eSF9f+V5EDJYmHUL5rtT9ZJhyC50Q=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1166.namprd18.prod.outlook.com (2603:10b6:300:a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 15:59:44 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ddee:3de3:f688:ee3e]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ddee:3de3:f688:ee3e%7]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 15:59:44 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "rabeeh@solid-run.com" <rabeeh@solid-run.com>
Subject: RE: [EXT] Re: [V2 net-next] net: mvpp2: Add reserved port private
 flag configuration
Thread-Topic: [EXT] Re: [V2 net-next] net: mvpp2: Add reserved port private
 flag configuration
Thread-Index: AQHXFpW4dTR4hPIdakagD6uzfQ/d0ap/ArIAgAfBQuCAA4BOAIAF9pLg
Date:   Mon, 22 Mar 2021 15:59:43 +0000
Message-ID: <CO6PR18MB3873543426EC122F1C53DC40B0659@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1615481007-16735-1-git-send-email-stefanc@marvell.com>
 <YEpMgK1MF6jFn2ZW@lunn.ch>
 <CO6PR18MB38733E25F6B3194D4858147BB06B9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <YFO9ug0gZp8viEHn@lunn.ch>
In-Reply-To: <YFO9ug0gZp8viEHn@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23e3d235-6f79-4c16-3336-08d8ed4b827f
x-ms-traffictypediagnostic: MWHPR18MB1166:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB11661355E1B5FE8DFAAEDDD2B0659@MWHPR18MB1166.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n+JeZyBQNDwKFNa7aEPBYE85Jo/ZhB+q07OGL/iD1FX67Sh5u/o2Lsy8ZYi+dOUWxMiYYcwcDebH5o4+olZfuxNbfpyTIQFpGGQmD03Zt8T9hf7twLc/pQpzQdJA+wxk+oxKqFrIIOvMWusaZScCeYacRzDC0g2vXBg/gV6GOZb69B14hrb9pC+GCP4KcuuOGqcZr6nrjJxeDCOqpOtgMy8E0jMznhy1PklD2lqav1g309WdvCNxT759eELobulJ9CEcrI70vhl0lNV0YtHG4YLd/NJISeaHhcZhxHJrhOVr4n9lHyiNI1HOIHJGO0Phob7K7D4i4sk1m45o/5jQmFvjFnGAnQCwxh85fbY9OBpqka7B9sPuEeZcgY+y+BBhjz5VQPu+EiucwgR1aeeRoBxQ15Y6jwI+PhkFX0Cjr+N4YjzVCigSfsYr87oEIkjayWXrdZEpXQ8iwbqdJ7c6gf6xRaLcyF2VdRwmpLijJ0sliZ71lj/3EEvLPBolFDW6lX1sSdaDd2VGl1ffLihz2HvzHmipBPRwW6uAfhdBP9lzoWxpEUmPRPkAZET4xDy3sv5X8Zx/X67xz1Yl1dTMduGl+o1Zly/0RV/l+a+0q4eeoSclewrSBsCa43hIVzkDnzHeK82WlZaxUUahaLGhrmxUP+7X+eoJmzREMfpKYaQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(38100700001)(64756008)(71200400001)(6916009)(66946007)(5660300002)(55016002)(26005)(54906003)(83380400001)(66446008)(2906002)(7696005)(86362001)(66556008)(66476007)(478600001)(186003)(4326008)(316002)(9686003)(8936002)(6506007)(7416002)(76116006)(8676002)(52536014)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pCJXj6nEK0Etrq7dJQfqLnK6g8lBrygb1WQLVt5oaw0Z5ErU1M88QjOZYGPC?=
 =?us-ascii?Q?f+zmsGabhJGA+M1kJyRUiK7aBtTe9YpPWeA+cGudxG7E7fB0dojnQ1THjQ3X?=
 =?us-ascii?Q?X+elaJciHHjZXZ78QGG5CpSoReh602RgHn45XPOxHoTpCrT26Oc6V9mDNcOt?=
 =?us-ascii?Q?qjFYEl1p4xpCTFXO4bEB10epc62c/wG93LylZqPNLs+fo8BoBPywqvz0JFnP?=
 =?us-ascii?Q?2IXqVJVprIPn9NqHbV3u6CeivEiXN354wlEeaOg9lVeHZbOMxDDuDeeyrsH1?=
 =?us-ascii?Q?7SnaZ7SSqrAZobps9pqJSKyKdyNl2DZHpLereqb5a5PkxxWfcHG1aqru8gx9?=
 =?us-ascii?Q?8rFdYgXxLLsk0hhG1NxMRv5iYbNWSzf0gNQbGN9gifHQwXMOzVRb78d+XD0X?=
 =?us-ascii?Q?QK4LwCTsFFBGxeswTRRiAIn/LgBNWW9rjST/bk9HE9zdACOJmDBUYGWJymYw?=
 =?us-ascii?Q?aVYeRQ8lQy5+ahQLifH/5he28vh1zgrhvLV3aOOWrdbbrfEp87EiicjNv3fu?=
 =?us-ascii?Q?uoUs0oH1PqNiazOuwW37olAQlM7urkCl/oroHFlxcUOwE7cDssDxaTcq7Y51?=
 =?us-ascii?Q?lSoibDwquCyCGxVhDehIZmVTmjuRt9qLiNxRS4r7PWmJ4h5OwFah9tN1IqNE?=
 =?us-ascii?Q?Ir3+9c+Joryt2uqnk2UVpUbYMnRou05uzGuTdl+pHZcE2uJiBM+sb0Rc6zUG?=
 =?us-ascii?Q?oUOyPeE+C5JUwOupXbsMsnWlxXIOMDxUJYj6QKZ7/P0//d8ON038u5TKzNyD?=
 =?us-ascii?Q?iCBAUZblQVnP+lzlcXdUlRqTonUxHXr7n1iEHY7VP1+1HRlO6khzOPxH9AVt?=
 =?us-ascii?Q?wmihxGd6Cb+yFwwU1jbq1QuICcIHZxz1sjli+Gp7E7L//zxZqO+9UvxHExZw?=
 =?us-ascii?Q?UxgnsCKVWe+ZuB0p1EwBq5kAbI3S2G2nKdcHP1mL37j7i+bem2WAMIQAFUZp?=
 =?us-ascii?Q?4bvx2SvHttO0i8Nz+uunOGZgKGUUYIQiTY9higGr+ZbSCDH7odNyZrAS7j2B?=
 =?us-ascii?Q?HhDnzMaTXlwtYuFEgv3l6GYuMb+sWVhykNcRSsFiufk4uR9XpP2gKeS+DfJH?=
 =?us-ascii?Q?LXyvovYxCaMkWWJ3baR1/NAoqW6kTDcDYgF8QbrgDLjIKcgjKKOyHeg240VH?=
 =?us-ascii?Q?XGWjUlvQSoHA8J6/Kzu0hng+kVOopYnLYjJR9H1G98KzCMEx4SFAcaNzQ5nB?=
 =?us-ascii?Q?J6cvVut/6k02CldX95sHh3naTQkN8It9yyvfCmDHFia2jtj0yD5eMrRu7lHx?=
 =?us-ascii?Q?qwACZ4MdAp4PZx0fYjsz2IPdFr1t5EPHCnkl2oDZmVMiMwSKkRMrD0ms2UdF?=
 =?us-ascii?Q?YI4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e3d235-6f79-4c16-3336-08d8ed4b827f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2021 15:59:43.8279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /IF44HrDh19D+82Nk1vspr2NhrS1JLibi8RHDYlFLSvvp14t+2ny2RJD75437MnP5q1vWZFRZxz05D5NZqeLVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1166
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-22_08:2021-03-22,2021-03-22 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> > 2. CM3 code has very small footprint requirement, we cannot=20
> > implement the complete Serdes and PHY infrastructure that kernel=20
> > provides as part of CM3 application. Therefore I would like to=20
> > continue relying on kernel configuration for that.
>=20
> How can that work? How does Linux know when CM3 has up'ed the=20
> interface?

CM3 won't use this interface till ethtool priv flag was set, it can be done=
 by communication over CM3 SRAM memory.

> How does CM3 know the status of the link?

CM3 has access to MAC registers and can read port status bit.

> How does CM3 set its
> flow control depending on what auto-neg determines, etc?

Same as PPv2 Packet Processor RX and TX flow don't really care about auto-n=
eg, flow control, etc.
CM3 can ignore it, all this stuff handled in MAC layer. CM3 just polling RX=
 descriptor ring and using TX ring for transmit.=20

>=20
> > 3. In some cases we need to dynamically switch the port "user"
> > between CM3 and kernel. So I would like to preserve this=20
> > functionality.
>=20
> And how do you synchronize between Linux and CM3 so you know how is=20
> using it and who cannot use it?
>=20
>       Andrew

I can add CM3 SRAM update into ethtool priv flag callback, so CM3 won't use=
 port till it was reserved to CM3.

Stefan.
