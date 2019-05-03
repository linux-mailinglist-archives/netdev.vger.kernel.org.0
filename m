Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE3D127F4
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 08:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfECGsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 02:48:38 -0400
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:20288
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbfECGsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 02:48:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoJUzgyqqnOz7MejnMgD7FyNhpYQ8w7qYUSDXhn82gU=;
 b=jzQk+rSfViCz5OW+lYeDXJU7EBYmjMjVjR3AdHO6jt+2MWovX9mmbolD2qbZl4OomWQ/1YGkZu03RLZawhALWUGBUQhf8Uy+U/WVp+Xu/0QIg8+1TxZsyHCRvp9hp7LXTzSao13WpmCoPfHQN6C2UnY4IpxCpj5UrkgZaUhlFrk=
Received: from VE1PR04MB6670.eurprd04.prod.outlook.com (20.179.235.142) by
 VE1PR04MB6509.eurprd04.prod.outlook.com (20.179.233.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.12; Fri, 3 May 2019 06:48:34 +0000
Received: from VE1PR04MB6670.eurprd04.prod.outlook.com
 ([fe80::812f:13f4:8c9d:86d1]) by VE1PR04MB6670.eurprd04.prod.outlook.com
 ([fe80::812f:13f4:8c9d:86d1%2]) with mapi id 15.20.1856.008; Fri, 3 May 2019
 06:48:34 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC HACK] xfrm: make state refcounting percpu
Thread-Topic: [RFC HACK] xfrm: make state refcounting percpu
Thread-Index: AQHU+osNJr96QpyKR0OmqmjggxV6FaZY9/oAgAAAcBCAAAOPAIAAADywgAAGhwCAAAAusA==
Date:   Fri, 3 May 2019 06:48:33 +0000
Message-ID: <VE1PR04MB667020CB281B9132C45B0B448B350@VE1PR04MB6670.eurprd04.prod.outlook.com>
References: <20190423162521.sn4lfd5iia566f44@breakpoint.cc>
 <20190424104023.10366-1-fw@strlen.de>
 <20190503060748.GK17989@gauss3.secunet.de>
 <VE1PR04MB6670F77D42F9DA342F8E58238B350@VE1PR04MB6670.eurprd04.prod.outlook.com>
 <20190503062206.GL17989@gauss3.secunet.de>
 <VE1PR04MB66701E2D8CE661F280D6A6C48B350@VE1PR04MB6670.eurprd04.prod.outlook.com>
 <20190503064618.GM17989@gauss3.secunet.de>
In-Reply-To: <20190503064618.GM17989@gauss3.secunet.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a75c6e4-c664-4c07-cbd9-08d6cf935ca5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VE1PR04MB6509;
x-ms-traffictypediagnostic: VE1PR04MB6509:
x-microsoft-antispam-prvs: <VE1PR04MB65091FE04C08C51625A150EF8B350@VE1PR04MB6509.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0026334A56
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(396003)(366004)(39860400002)(13464003)(189003)(199004)(11346002)(316002)(7736002)(486006)(446003)(44832011)(305945005)(26005)(71190400001)(71200400001)(66946007)(73956011)(64756008)(66476007)(53546011)(66556008)(76116006)(66446008)(2906002)(14454004)(52536014)(6436002)(68736007)(4744005)(86362001)(102836004)(256004)(99286004)(25786009)(66066001)(9686003)(8676002)(81166006)(33656002)(81156014)(74316002)(476003)(3846002)(76176011)(478600001)(4326008)(6246003)(7696005)(6506007)(186003)(54906003)(8936002)(5660300002)(6916009)(53936002)(229853002)(6116002)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6509;H:VE1PR04MB6670.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fDKhs8mH92zcUoefHVm9Tpe0ADgMidlZLG86uCnpfAD/+AfY47/XmYAdblVJvfZB27mwhX+o+g7A2zuy+uLzG+zMiVfXISRCDzMDscHWHVfP1xhp9NGOWD2cowFBbaKlFrVCzkyWm0NoiV+hhI3G9OEq5BaJxTQzXDdYD1IUmeOix4W3i4RakiH53OAtQKPPvPm9QJczDk0AnbLgW5Pszk4UlPneIUBqpmG3vvEtHj0rrDbiZkV+ouzHHRiH9JBofwSq7jItE6MKu2wiZC0H8xxCkgYWWohHMJwfhZkapM8FuQYTpe5riJMDy3HK/3xytXAU1H3Rny/K91kikv9huv7thsdl17v6LcyIrBqaUqt11l/QFecCUrz6BIPZZXbKSmU8T2rbt4ND1XZsNj3j5bzjr9300K6Yu9KA2fzrsPY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a75c6e4-c664-4c07-cbd9-08d6cf935ca5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2019 06:48:33.9174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6509
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Steffen Klassert <steffen.klassert@secunet.com>
> Sent: Friday, May 3, 2019 12:16 PM
> To: Vakul Garg <vakul.garg@nxp.com>
> Cc: Florian Westphal <fw@strlen.de>; netdev@vger.kernel.org
> Subject: Re: [RFC HACK] xfrm: make state refcounting percpu
>=20
> On Fri, May 03, 2019 at 06:34:29AM +0000, Vakul Garg wrote:
> > > -----Original Message-----
> > > From: Steffen Klassert <steffen.klassert@secunet.com>
> > >
> > > Also, is this a new problem or was it always like that?
> >
> > It is always like this. On 4-core, 8-core platforms as well, these atom=
ics
> consume significant cpu
> > (8 core cpu usage is more than 4 core).
>=20
> Ok, so it is not a regression. That's what I wanted to know.
>=20
> Did the patch from Florian improve the situation?

Actually I could not get time to try it yet.
Also I do not find Florian's patch making refcount in 'struct dst' to be pc=
pu.
So I think it may not help....
