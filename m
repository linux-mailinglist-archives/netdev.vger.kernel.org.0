Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAAF7127CD
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 08:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfECGed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 02:34:33 -0400
Received: from mail-eopbgr150050.outbound.protection.outlook.com ([40.107.15.50]:59447
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725775AbfECGec (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 02:34:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJG6PU4w5Wi4wqn0CpQaswxXYNnYkMAF51zIRpYpFeo=;
 b=L3TE60OnUtxQnJnHZoBUplQvOXB2XL1+Fp0zIW4qNeewVE38RmOnWRONAJP7U+E6ohTUsD+pt1WBAQVhtrQblq8hBOgw/rBM+cHNLFw7z6xYoAUQPr/PbIaycfsCDQsv3QapULEElv2SzJCyL3IAc+KHDZ3d9A3AVRaUSVx3C0I=
Received: from VE1PR04MB6670.eurprd04.prod.outlook.com (20.179.235.142) by
 VE1PR04MB6560.eurprd04.prod.outlook.com (20.179.234.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.12; Fri, 3 May 2019 06:34:29 +0000
Received: from VE1PR04MB6670.eurprd04.prod.outlook.com
 ([fe80::812f:13f4:8c9d:86d1]) by VE1PR04MB6670.eurprd04.prod.outlook.com
 ([fe80::812f:13f4:8c9d:86d1%2]) with mapi id 15.20.1856.008; Fri, 3 May 2019
 06:34:29 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC HACK] xfrm: make state refcounting percpu
Thread-Topic: [RFC HACK] xfrm: make state refcounting percpu
Thread-Index: AQHU+osNJr96QpyKR0OmqmjggxV6FaZY9/oAgAAAcBCAAAOPAIAAADyw
Date:   Fri, 3 May 2019 06:34:29 +0000
Message-ID: <VE1PR04MB66701E2D8CE661F280D6A6C48B350@VE1PR04MB6670.eurprd04.prod.outlook.com>
References: <20190423162521.sn4lfd5iia566f44@breakpoint.cc>
 <20190424104023.10366-1-fw@strlen.de>
 <20190503060748.GK17989@gauss3.secunet.de>
 <VE1PR04MB6670F77D42F9DA342F8E58238B350@VE1PR04MB6670.eurprd04.prod.outlook.com>
 <20190503062206.GL17989@gauss3.secunet.de>
In-Reply-To: <20190503062206.GL17989@gauss3.secunet.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc60d3ba-f2a6-4bc3-5512-08d6cf916549
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VE1PR04MB6560;
x-ms-traffictypediagnostic: VE1PR04MB6560:
x-microsoft-antispam-prvs: <VE1PR04MB6560771DC02416347AA76AE48B350@VE1PR04MB6560.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0026334A56
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(366004)(346002)(396003)(136003)(189003)(199004)(13464003)(81166006)(6116002)(3846002)(68736007)(6436002)(71200400001)(71190400001)(81156014)(186003)(6916009)(229853002)(53936002)(44832011)(8676002)(8936002)(476003)(11346002)(446003)(486006)(6246003)(7696005)(256004)(14444005)(25786009)(5660300002)(99286004)(14454004)(86362001)(64756008)(66476007)(66556008)(66446008)(66946007)(73956011)(76116006)(478600001)(33656002)(2906002)(305945005)(55016002)(316002)(26005)(53546011)(74316002)(6506007)(54906003)(9686003)(102836004)(52536014)(7736002)(66066001)(4326008)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6560;H:VE1PR04MB6670.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qz+4JhDubGJM1qIQ5rYDgz+aNrEXB7gyYcazLWVu2QrXzBxu+UjCU73ab2tq2lrYe9/JDa38AMujnHWTLphCMWv0Ek+6ZtpVasY2Wn2k4PIjGFg7riieyzLQodIRzlACdJzhgyaBPh8Le1u7shgy9r6XV7v8iua2o1JVKBaB3ENlSwG8P58A/ggWEoidb3Xhac0zpOAV+dINKbXD14+D2wSY9fcaoEAlFyrtRKYX/BAVYbpVaOCa9FLfuq2Dxe+QdarK/rlh+hjfndNZyMvWAjgK4o6wzSpm/f4Crie2qgURzLHUPFtu2W8nYPF4NxJwlAj/33Qw8NKWQ+xeljV9TQrlkYaz4rTLJ4Vk6pJPVg7WiDYEij8Rw5DZQ9n1Lxk8w2g3aR2qFL+mCcflyDCL9hZY3z2SyGUiowbXtjId/Ss=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc60d3ba-f2a6-4bc3-5512-08d6cf916549
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2019 06:34:29.4945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6560
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Steffen Klassert <steffen.klassert@secunet.com>
> Sent: Friday, May 3, 2019 11:52 AM
> To: Vakul Garg <vakul.garg@nxp.com>
> Cc: Florian Westphal <fw@strlen.de>; netdev@vger.kernel.org
> Subject: Re: [RFC HACK] xfrm: make state refcounting percpu
>=20
> On Fri, May 03, 2019 at 06:13:22AM +0000, Vakul Garg wrote:
> >
> >
> > > -----Original Message-----
> > > From: Steffen Klassert <steffen.klassert@secunet.com>
> > > Sent: Friday, May 3, 2019 11:38 AM
> > > To: Florian Westphal <fw@strlen.de>
> > > Cc: Vakul Garg <vakul.garg@nxp.com>; netdev@vger.kernel.org
> > > Subject: Re: [RFC HACK] xfrm: make state refcounting percpu
> > >
> > > On Wed, Apr 24, 2019 at 12:40:23PM +0200, Florian Westphal wrote:
> > > > I'm not sure this is a good idea to begin with, refcount is right
> > > > next to state spinlock which is taken for both tx and rx ops, plus
> > > > this complicates debugging quite a bit.
> > >
> > >
> > > Hm, what would be the usecase where this could help?
> > >
> > > The only thing that comes to my mind is a TX state with wide
> > > selectors. In that case you might see traffic for this state on a
> > > lot of cpus. But in that case we have a lot of other problems too,
> > > state lock, replay window etc. It might make more sense to install a
> > > full state per cpu as this would solve all the other problems too (I'=
ve
> talked about that idea at the IPsec workshop).
> > >
> > > In fact RFC 7296 allows to insert multiple SAs with the same traffic
> > > selector, so it is possible to install one state per cpu. We did a
> > > PoC for this at the IETF meeting the week after the IPsec workshop.
> > >
> >
> > On 16-core arm64 processor, I am getting very high cpu usage (~ 40 %) i=
n
> refcount atomics.
> > E.g. in function dst_release() itself, I get 19% cpu usage  in refcount=
 api.
> > Will the PoC help here?
>=20
> If your usecase is that what I described above, then yes.
>=20
> I guess the high cpu usage comes from cachline bounces because one SA is
> used from many cpus simultaneously.
> Is that the case?

I don't find kernel code to be taking care of reservation granule size alig=
nment (or cacheline size)
for refcount vars. So it is possible that wasteful reservation loss is happ=
ening in atomics.

>=20
> Also, is this a new problem or was it always like that?

It is always like this. On 4-core, 8-core platforms as well, these atomics =
consume significant cpu=20
(8 core cpu usage is more than 4 core).

On 16-core system, we are seeing no throughput scalability beyond 8 cores.=
=20
