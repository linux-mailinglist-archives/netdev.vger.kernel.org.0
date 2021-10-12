Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626DF42A5C7
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbhJLNgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:36:23 -0400
Received: from mail-eopbgr1400109.outbound.protection.outlook.com ([40.107.140.109]:7479
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236856AbhJLNgW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 09:36:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dA120DawEEqKlSDYGW5IJHdeilDBqmESxcvf5leWNZHlO3SMQQznimeVBmr91ROmjN+eZE0C4sSSvpxvyi44i89LhstypMN2ocgK1G3/VET7CvYqtfngp63MFRfUEmF8+aU5l+/p4uplFRYiMoYRMxS37Mw2tklqLKOrvg4881nAa8BXLm9YpXMQTzfFOYlY5ryXEgNHniPU8RhwiwHoz73vGecmtyHGiYyDgDufaSHaE/nBFxwkz/7Gnzq6FLxr4IcldaeozhYhx9GX8/CH3ytT7orlJ0GXzpjnE6iCS+VDHYZIVv3O4crIT6D4FY0v6I/Z5z9raxcbHFDZYRpG2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RdFaUkMEUYiV5Pn8v1rsqUoxYiWuYnZB96kwdgdvC7o=;
 b=acNm6zJHtj+PLzQQgJ6Snxhhj92ngJ8vGIwQ4AB/nOhtpIyY4lrAKf7LBlMHK94jw/Hz4R8qKh/U7fJpZ5u60vNkeHAEYEL0NctYFWF/xvBNjLy6RmqoN3qJLZE+DY5zCXdLYz2VVVEZdxXQ0tpeZyhgnDhSo06tE+7yK/80Pf2MvZ72/uoLzW7Vy0F4RVi6sLfQVLmh2KfpOGlsp64l2C+VZUokCKTP9WZWMR8USb4WOJVngXjVp8KFx5xEXSkXpWtuG7pnWbHa6k/bJrb1yiYquzBbZBWF9jeDNvULoZAxA8RRgMguOQoN7xQDhss58GCDQF4SCWkdTRvgVr3+TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdFaUkMEUYiV5Pn8v1rsqUoxYiWuYnZB96kwdgdvC7o=;
 b=n2QaQdgg3OfHOke9Kn28vQIOJYXW+066Zz+HK3ykJcALUdZ62HRig5j1wX9RSShO8a8vnSXVibF1kSJdN2mC88ehTYBPAOFcEcAW1n+4XLLYEsj1URNGlNRrFONl+fQAVreM5/QAVga6qbwBS8uTQY+K5bP9vhMj92ehLNLV4zI=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5731.jpnprd01.prod.outlook.com (2603:1096:604:be::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Tue, 12 Oct
 2021 13:34:18 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 13:34:18 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next v2 13/14] ravb: Update EMAC configuration mode
 comment
Thread-Topic: [PATCH net-next v2 13/14] ravb: Update EMAC configuration mode
 comment
Thread-Index: AQHXvaixd8lMzh4St0+QfQ9kX6MhhKvL9taAgAABWOCAAAStAIAABr7QgABR+YCAAtShoA==
Date:   Tue, 12 Oct 2021 13:34:18 +0000
Message-ID: <OS0PR01MB5922253965DE7FAAE0A679E586B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211010072920.20706-1-biju.das.jz@bp.renesas.com>
 <20211010072920.20706-14-biju.das.jz@bp.renesas.com>
 <8c6496db-8b91-8fb8-eb01-d35807694149@gmail.com>
 <OS0PR01MB5922109B263B7FDBB02E33B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <57dbab90-6f2c-40f5-2b73-43c1ee2c6e06@gmail.com>
 <OS0PR01MB592229224714550A4BFC10B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <YWMBh33gBnAlHI1N@lunn.ch>
In-Reply-To: <YWMBh33gBnAlHI1N@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 577aa08c-da5e-4489-f35a-08d98d84fdc9
x-ms-traffictypediagnostic: OS0PR01MB5731:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS0PR01MB573115F1AF77E98E14A7988286B69@OS0PR01MB5731.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wn+k05oj1DxtCPJEulipouumOKTh/+sVFkASvZ8lzHQ7L7FzJ6f4EHH4OYJTlzI19BbTRYqOuHsAqvvVhsyjtxWVDppO7mGD3++CoAb6Pqa/0u7re0HKXCcxmbeBOtrHMCmu0vE79c4v4QKtMb/ufFoeRQKmZcT52iDFmP6diDHxFxfAHC4LdxnRvaGF6l4ELrzpXHoIM5Mgl1P3np21AOV4XjjSZDtuhh4IPCUdjvYiwNYPze6hAcrtHhBCa3Zw3uEPPD50+gGWxP/x4lss/lOVBusVyg6zHwCBjclHFwW/c0evyP80qxBm57/TA/exOKo3jv7Qb8a/n7SHVOwwZyvzOybtaip2u7uC7OWFnZqWp2xGBtpWH8ValUYZdYQYp/bcDu3msfyQjOYe3Yy+I0iL5lLdGzM9SDssbJ0lbFkNt9Yg1jCz3d4Opevsh8/y6f48hhVCILDeBNYa/C2zVxIZH4aAHX+KAYQTXsIvRU+RR0z2mAzkwEUpr5HtfNYDNMzr9GrmBxegVAb0MaXno0dWuJD+1rEcXQpLmQuhnMP4Y+orHE+A5M5y/omg5EZoPRRPaLJ/zpyP+aK1PeuFwe+DYfNiLET+VqpqCcHlBYXjUQ1y8K0toy6IYttH5FXdXoMj2MqGPv05XDz99eeHtFCeOyOVZoqE+zXr3N4wJtzzgztxAXUTOV+8h+yexFKH9oghnJJ8gXvc1KKtQFbefw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(316002)(66476007)(71200400001)(83380400001)(76116006)(2906002)(8936002)(66446008)(66556008)(64756008)(9686003)(508600001)(15650500001)(33656002)(54906003)(52536014)(6916009)(66946007)(7416002)(186003)(26005)(4326008)(5660300002)(107886003)(8676002)(38100700002)(6506007)(122000001)(86362001)(7696005)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Vfm7r2QHSgPu7ABGmhtnI3XqMeesCIPvcieSqEm5cxZlQlFCvAi6kx8KeszD?=
 =?us-ascii?Q?1Ooj5ptUWZZSQD+sYKIi/ErSQlmKTR2J245Zp4BXKybnDr6+/mZx32ObLtWB?=
 =?us-ascii?Q?dX0gFOkbW8cZeJ/+4ejL5ywD+rZAMs89C9ahszT2uA8S+nqVPaIqrhAQbICP?=
 =?us-ascii?Q?38zdoI+nBCvFvJvB/Rd6DSBdOuxqQkLphT3xqbHS/fG6QxX/mho6eHG0bKrU?=
 =?us-ascii?Q?Y62jX3KWJdMXAKr5Uo1HHD/NTOgS2ciGtWh+PLqpRbasYnk8s3TLtS0Ek2cZ?=
 =?us-ascii?Q?X7kE9tewYni3/UbaTus0jQHf9ifBoUugyoTqbixxXoBD8gdpfEZyvFmdRicv?=
 =?us-ascii?Q?BFECBktfgPmXjFltOCnspgeIkWzS+wTPB/pYbR65PA56n7GRvwkNs7dpQ+rT?=
 =?us-ascii?Q?YeDZJIhepkhiIu3f0E7SB+eQPtdO2yJpxyzDAJ7u6tvuy8x/t5yUqTfnegpr?=
 =?us-ascii?Q?U+O2zn5DA2KIJJiG93+B3pHk2H/JhP0CdAGt6zKPd6Sket07gUJRaOwenWwm?=
 =?us-ascii?Q?4nzKx14tQt3KsAioewJn9mrhYmfv4NEhHp4IQyPqc+MGiRfOinGVbCNgHLFM?=
 =?us-ascii?Q?tXYUR9jZxHC+5R5AnYQQ4ygAaXXJ30pnHNI+w9uLtnnlOryqHNSh3l2zAjgH?=
 =?us-ascii?Q?dKu5yMoJ8+In9NFqrQBt+wGhD9McshiL0gIinqMDJ+H3k8hINAkp5IUtgZPD?=
 =?us-ascii?Q?Gd3tqxOJ9onh7yq178e9zu/5umK8u92nKnx5liBQcm+S6PXgEryPqokVRn7M?=
 =?us-ascii?Q?38o//+rjeyn7jinHdOx8JW7/mIMWAZ5scY90zOMaxr3fEU0VT3KupnLujf2H?=
 =?us-ascii?Q?Da61dDJOyHphVHnMO9DF6CKBh3iHYhdSHcz8EgYq3sV2ZqK7Oo1p9SHRbwlg?=
 =?us-ascii?Q?2bUTWkRWJq4Wxt1FvtWwdlPaKM9s5dqVPc5t+07MQQQTGX5ETR3MlZnhozKU?=
 =?us-ascii?Q?b9J0UnwlFMJH+ZR8TDHWOBsrIDKXK8OxYKiu6qIoxOJIi2ogM3BM7mnVRdSX?=
 =?us-ascii?Q?hMucdRnQBWS6MTLbsWU8vVEI5XtdgQmKDaP7H+GxA7LbzCQ23YI/MTQr0+G3?=
 =?us-ascii?Q?9Fvm/Jlpa7Tg7br8EtVYcyuBPFDNYkAn1EXcEos3rTgkFA85Jcl5WRe4QbSn?=
 =?us-ascii?Q?HOIGIUaoCmmJcRvpXE7MU77Xz5uMrB+ecZL8eFI9UQRz5Ds9py5jdrsAJDED?=
 =?us-ascii?Q?dLv553Vo/tTIGDepTTQs5ZnPw1L+XDqc8zlTD1rRxqdQMF2GWvEE3U3B1vWE?=
 =?us-ascii?Q?SjHKMAFBNb9c45ATAsLiwtMA4pCD6eEhpJNhtUY4wfxyUlhhVHIzhCrBmleS?=
 =?us-ascii?Q?7tE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 577aa08c-da5e-4489-f35a-08d98d84fdc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 13:34:18.1461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vrIr2qH/rYrdo3HDVSENdqntRCCwscwxg/LnE3PkowWGN2wNtDgJiDQqdbjRg2DpgbBLtRRZ6exmkHjeG+8qmRyzWe/1VzqZQvS7BTQ1+2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5731
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thanks for the feedback.

> Subject: Re: [PATCH net-next v2 13/14] ravb: Update EMAC configuration
> mode comment
>=20
> > by looking at the RJ LED's there is not much activity and packet
> > statistics also show not much activity by default.
>=20
> > How can we check, it is overloading the controller? So that I can
> > compare with and without this setting
>=20
> What is you link peer? A switch? That will be doing some filtering, so yo=
u
> probably don't see unicast traffic from other devices. So you need to
> flood your link with traffic the switch does not filter. Try multicast
> traffic for a group you are not a member off. You might need to disable
> IGMP snooping on the switch.
>=20

I have tested in below environments
Setup 1:=20
  Machine1: RZ/G2L platform connected to Ubuntu Guest VM(bridged),Host oS w=
indows via SWITCH and
  Machine2: RZ/G2M platform connected to Ubuntu Guest VM(bridged),Host oS w=
indows via SWITCH

Then ran multicast_sender app from machine 2 and ran tcpdump on machine 1.
using devmem, I have controlled on/off PRM bit.

In both cases, on tcpdump from machine 1, I see multicast packets which I a=
m not a member off.

Setup2:-

  RZ/G2L platform directly connected to RZ/G2M platform.=20

Ran UDP unicast sockets to send data from RZ/G2M platform

ran tcpdump from from RZ/G2L platform

using devmem, I am controlling on/off PRM bit.

But for different addressed packet, I see RZ/G2L platfrom is trying to do A=
RP request for
different address. So packets are handled, with and without PRM bit set.

Regards,
Biju

> Or use a traffic generator as a link peer and have it generate streams
> with mixed sources and destinations.


