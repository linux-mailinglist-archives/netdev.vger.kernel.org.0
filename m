Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6059212789
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 08:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfECGN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 02:13:26 -0400
Received: from mail-eopbgr60065.outbound.protection.outlook.com ([40.107.6.65]:11575
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725775AbfECGN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 02:13:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5UL9rR1Kqjh3GlPXtRKK/2Wy9gvRjlaGW5hRQ9zAEc=;
 b=A1GeiQvtWO8v7XXGUawwdo1GdFTUS6JwwhKmNINbNjcBG/P3oYdK0ayj4qRc9ocOtNXuzaUkizPkDAy7aniZpLBrovj4c8kclmj56dUKhrhXUzAS442XudUcJYzR1YNArqoh+MKaKHSLkYZsQxXz8oTmR7yc7AXyE4i7iEmdP/w=
Received: from VE1PR04MB6670.eurprd04.prod.outlook.com (20.179.235.142) by
 VE1PR04MB6416.eurprd04.prod.outlook.com (20.179.232.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.14; Fri, 3 May 2019 06:13:22 +0000
Received: from VE1PR04MB6670.eurprd04.prod.outlook.com
 ([fe80::812f:13f4:8c9d:86d1]) by VE1PR04MB6670.eurprd04.prod.outlook.com
 ([fe80::812f:13f4:8c9d:86d1%2]) with mapi id 15.20.1856.008; Fri, 3 May 2019
 06:13:22 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Florian Westphal <fw@strlen.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC HACK] xfrm: make state refcounting percpu
Thread-Topic: [RFC HACK] xfrm: make state refcounting percpu
Thread-Index: AQHU+osNJr96QpyKR0OmqmjggxV6FaZY9/oAgAAAcBA=
Date:   Fri, 3 May 2019 06:13:22 +0000
Message-ID: <VE1PR04MB6670F77D42F9DA342F8E58238B350@VE1PR04MB6670.eurprd04.prod.outlook.com>
References: <20190423162521.sn4lfd5iia566f44@breakpoint.cc>
 <20190424104023.10366-1-fw@strlen.de>
 <20190503060748.GK17989@gauss3.secunet.de>
In-Reply-To: <20190503060748.GK17989@gauss3.secunet.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8687920-f282-480a-f2fd-08d6cf8e7211
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VE1PR04MB6416;
x-ms-traffictypediagnostic: VE1PR04MB6416:
x-microsoft-antispam-prvs: <VE1PR04MB6416D49D76D9C6990AB08AF18B350@VE1PR04MB6416.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0026334A56
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(376002)(346002)(366004)(13464003)(189003)(199004)(68736007)(2906002)(52536014)(74316002)(305945005)(5660300002)(64756008)(33656002)(66446008)(66476007)(66946007)(73956011)(76116006)(14444005)(66556008)(7696005)(256004)(99286004)(71190400001)(71200400001)(7736002)(3846002)(6116002)(446003)(6506007)(53546011)(25786009)(4326008)(110136005)(8936002)(486006)(44832011)(6246003)(14454004)(66066001)(86362001)(316002)(102836004)(11346002)(55016002)(476003)(8676002)(76176011)(53936002)(186003)(81166006)(229853002)(6436002)(81156014)(9686003)(478600001)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6416;H:VE1PR04MB6670.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kr7G5Ozo6+/oRTMjJY2XCJ2xWwRX4wJ/enjicAJIHI8xfjNLQ4/s85GFJ1qsJH7W0ievav6Z/Aumfz01LK37UH6UZL7aUpyXFYBJkduWyQALD25kWxDrsB5jerU6DCLEiJdmEnEl+3OGtrBarFMaoFjsO6pv3Shmt1Woz1r7j4piw6+HVG24CUN7WR92Y3du0hr9kqy+NWulM8IdB3p3U7dmeTRhpa8iQGHwhCZJZTwqJ+Yjt84TQLL+AxWeCd5rmgKYU8JnGC1leu1J1XzTGbFwxwFI2Nm/yKrtRR0Fh8a427FE7Rgq/zUhicG5sTcEndSR/vL+SFaSZ2E15DqB0r+QQAGHaV9+3H2RdGkNDMjrQN1gIcyMT7ZgbL6uSKJWjwE8nDYSvjyiiCyABMKpsmxRc8aEWvq1jmDHCAh2+Dc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8687920-f282-480a-f2fd-08d6cf8e7211
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2019 06:13:22.5098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6416
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Steffen Klassert <steffen.klassert@secunet.com>
> Sent: Friday, May 3, 2019 11:38 AM
> To: Florian Westphal <fw@strlen.de>
> Cc: Vakul Garg <vakul.garg@nxp.com>; netdev@vger.kernel.org
> Subject: Re: [RFC HACK] xfrm: make state refcounting percpu
>=20
> On Wed, Apr 24, 2019 at 12:40:23PM +0200, Florian Westphal wrote:
> > I'm not sure this is a good idea to begin with, refcount is right next
> > to state spinlock which is taken for both tx and rx ops, plus this
> > complicates debugging quite a bit.
>=20
>=20
> Hm, what would be the usecase where this could help?
>=20
> The only thing that comes to my mind is a TX state with wide selectors. I=
n
> that case you might see traffic for this state on a lot of cpus. But in t=
hat case
> we have a lot of other problems too, state lock, replay window etc. It mi=
ght
> make more sense to install a full state per cpu as this would solve all t=
he
> other problems too (I've talked about that idea at the IPsec workshop).
>=20
> In fact RFC 7296 allows to insert multiple SAs with the same traffic sele=
ctor,
> so it is possible to install one state per cpu. We did a PoC for this at =
the IETF
> meeting the week after the IPsec workshop.
>=20

On 16-core arm64 processor, I am getting very high cpu usage (~ 40 %) in re=
fcount atomics.
E.g. in function dst_release() itself, I get 19% cpu usage  in refcount api=
.
Will the PoC help here?

> One problem that is not solved completely is that, from userland point of
> view, a SA consists of two states (RX/TX) and this has to be symetic i.e.
> both ends must have the same number of states.
> So if both ends have a different number of cpus, it is not clear how many
> states we should install.
>=20
> We are currently discuss to extend the IKEv2 standard so that we can
> negotiate the 'optimal' number of (per cpu) SAs for a connection.
