Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E4241682E
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 00:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243526AbhIWWuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 18:50:40 -0400
Received: from mail-eopbgr70077.outbound.protection.outlook.com ([40.107.7.77]:36835
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243431AbhIWWuj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 18:50:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBL+oVzndeXs+lZ4nRL8qIKvCwNJZXZCfIpUYfqB00T6bi6TPCW1AXXfishwn+xt37JK780McyygZfL+FKgUv1smKyka3Ouvcf8y4+2UzXdMK0H5PVd9DKX0AjWZ8j+NkDMVpIBo0zf2zUXHCIaYC2SA9tZ9LiPG11RaMInBhn1oCec9puu/VdH2ZN/CLjEjaABu9j7GWhTU+7miOAnNxKmrImireGplBd+5bo24QTn/6SVjj+veG+f5JtduEygKTtkXHujTnwzaHNM5I4qjKsZK84ezA6yrTY9s2dau+2QK4Pg/sHIlOUX5C6GYWZNVdo3sP0QOTdAoZ89xknPztw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pqQqh2j4rdPU+UQvikVazK0rvMqq6JfQeAriiYeMwXM=;
 b=GlDvCZRLS+E4l2n4TGno4GNBTEsT1OqEhXkYGSuuYpNuHO1vPHTTEvcN+jPfLjqWBIE4/EMyib2QyJr2erap9NRzlFLX//OjIIiRlE+msJ9KN1N0qRtygSQeJH0ag/EJ/CQDUxl0xCeCUip7JSjWgXEpwdf8elMvERBvbpdZU9lpIYOfMP5bRZwZEf45tmljqa2znaVQJeUs2MTKznr7HOLt90eZN6k2UJilW0uN59T6hmdmOH/wjkkUN0jkOO26+SuWgrsoWSqV6km/OSB3zr8DVHh7wM/khvx5yBHq7Ea3qIVejdjAe8PCePqj3XUjDmpCuXn8hF1++pOGzCgtPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqQqh2j4rdPU+UQvikVazK0rvMqq6JfQeAriiYeMwXM=;
 b=BIRObD1ESNXz4lMgP5Ev+TaU2Unf/dXiz+7mQkBMUJ9RfhsItXt9BnOAdgWXiNndrmbfWWigHdu+3U9jyZ4xxfsJSBIkQlOYjv+GSyoxkF1TPkcnKGCX5PPBthRJuV3iNEzMlp9n56ZNzSR7I4AyHG1q6K8FVDiWOkQ2rSPW2X8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7325.eurprd04.prod.outlook.com (2603:10a6:800:1af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 22:49:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.021; Thu, 23 Sep 2021
 22:49:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH 0/4] Faster ndo_fdb_dump for drivers with shared FDB
Thread-Topic: [RFC PATCH 0/4] Faster ndo_fdb_dump for drivers with shared FDB
Thread-Index: AQHXls+U+tbP+byAdEOJ1ujBjTSpAqux8MUAgAB2c4CAAAWSgA==
Date:   Thu, 23 Sep 2021 22:49:04 +0000
Message-ID: <20210923224903.mrln22qqfdthzrvm@skbuf>
References: <20210821210018.1314952-1-vladimir.oltean@nxp.com>
 <20210923152510.uuelo5buk3yxqpjv@skbuf>
 <187e4376-e7bb-3e12-f746-8cb3d11f0dc4@gmail.com>
In-Reply-To: <187e4376-e7bb-3e12-f746-8cb3d11f0dc4@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9aec04c0-a8c8-4c08-3a45-08d97ee45801
x-ms-traffictypediagnostic: VE1PR04MB7325:
x-microsoft-antispam-prvs: <VE1PR04MB732588BA017FEC6107FE4F5BE0A39@VE1PR04MB7325.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bUFXoZAq2bZPS65ClZQLxUTiwPa4Hq3fkHvH4v1WZM6HTsJUBewufEo/hTp6dvfD8X2hkij2wbqQgopBsrqknO+4dae5aOKwSCzLh5XG6g9YnQi2R1S7/fMpXi/yBtLNZ+KcFEtgPkAGPf22WOg4naR4jE2xRq5HwniCXn/41Eja67TnrmduLo0gJZhIxvXsx43b8SaMm9acWmYYh7xN6P24bnSupNlEgALCaUaqOnuwskuRPwxy9ru+w+Zd2hd/F3w9OxtRoDcsuM9Vm9MwVBAf+Y8rulmuSxfXsYoPUDNfWvg2tnyS368ms435Qg+yArbkN5UQCEjAfQ5snC2uqlnueP53cHpkUmnuLRrdFKWvA8whX1/BR3hSDjKqKqNwZXZSelEVIB8wK9h98EvakSmiPvlirmIehtbVwON2DFHRLrS7w9kyZWLaorl6Nnxn1H9v9buZeCYd8PlmoG2Qp83Y3PJoAwOBbFZMNoCOBNTWx8kpMP0tPXcKhF5QsoTFpveoIr/Q8lH7tZxHl4vRn6IUQn7dVKkpXmHZl0VGrJlkFlbsY3VoosUXxW1Y8/KBD5mhoJd+jCrFaUN0+FqW5z6KcDibq4uOrW2VLqjTjDpOS4tHN4hrQRYNFjRmEN5RtJbWoRZgE9VPxj+PweKX/A0f/e1kSd/BD2jujLLVFo1n1JjbtlMBbspZtyhGKSdvx6lfyf5BQIBz0PsuBS0EP6vqyohsaqVGVs0Ch/CDkauLY4RHGnxhYO5q0TgTOwlEh+w2GVTd06Z3vvnyUc8fIbTGmtoG/fpoxJPeqhB1k4I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(508600001)(6506007)(6486002)(86362001)(44832011)(38070700005)(966005)(8676002)(5660300002)(33716001)(66476007)(6916009)(66446008)(8936002)(71200400001)(66556008)(91956017)(76116006)(66946007)(122000001)(186003)(4326008)(38100700002)(64756008)(9686003)(6512007)(54906003)(316002)(1076003)(26005)(83380400001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I+c109v5ThHB9pF6rQ6i31M5trQ8+bSiNMixldEFTv8XRWOKbEVaHUQYT+IF?=
 =?us-ascii?Q?4okb6gnGDVlnlMcv7yR/4InpPV9lfg76+bQmJA3zK5OvuRxo6yqKQyvtrntj?=
 =?us-ascii?Q?cj9mr4nceHrnk3t5LIFSgDqGXXKwzQpCCldfKa8kZCocHvBmEP3Pxwz/z5di?=
 =?us-ascii?Q?5+ueI0DQKbKuXfOItNYESkqillweopthRI7f1ZWeYzVLqYrvZ3D/6k1uKRk/?=
 =?us-ascii?Q?ae6k4TfsO27Z460bTiYnI6c+jQHCJh9dsJ7EKy7vB9Revp7otN7efP6IWxTI?=
 =?us-ascii?Q?M9Bb6XmN2KgP+Zo3Xs7CsgIQEYxZk6F92c+dQM9SIlVCZwE4nrvHa1SM2agR?=
 =?us-ascii?Q?3ETVvD6aveIwDdLMO/V2hRbNPHfgRdQNMOOqyZvGSNbYLooQ92B+7+tZsbvz?=
 =?us-ascii?Q?bYm77zLxz3mTjiqh7vMY81l008VP17fV6GDiptUDUe9HgbrMMESZ8CKAJp7q?=
 =?us-ascii?Q?6d4euvd+y9H0EHZBpHI2dDnN8tsxSScGHW9nC/Edo9DwSQULsq/lnwvM8ptR?=
 =?us-ascii?Q?lYK3+kEx8HA+1iJdoXyFCAP0EYkf6KU5Ltgvu7KHwWPSt53xOvbQyPAF6JGy?=
 =?us-ascii?Q?GhONuiFy45aEFp4Ulhl/Pe41v2dzjuMwuH3HdcLFmb/GmmMtKOooZIcTcPeZ?=
 =?us-ascii?Q?HSNTD9kvV1VBeqPgTgzpJx/Iozd8MFQn0/0qcp6b9VF8MEqToqP+hx2qr0Oy?=
 =?us-ascii?Q?csIqMKxBn21VWbQS2R9RU8+v3sTkERm9wu4t93ECDCeo8inrYFsqrUUlkxrI?=
 =?us-ascii?Q?OQFdDG3GKqmCbwRh/AAjrTmlqEqblFp2Dzwf4MqMefNUlcQ7Dkj5BhU/wJnA?=
 =?us-ascii?Q?j+CWZ/KRoIuxImuyYHJNrVPB08ohbS9lYaouTlRUaCRQGytKQyWm0BKneLhu?=
 =?us-ascii?Q?GdVZaFApsPPzbfqdC1ijB62/MM/BoOVrk70QGUOY8dEq4sN3ge+Fny3vlrXq?=
 =?us-ascii?Q?IA+zVRjzyDgcyD6XNM6TcRy61+2owL5KpaULJLn/D+qodk11Fc5RVt5ua34Z?=
 =?us-ascii?Q?Jmy8eBz5mmYdKoF3DMJUhqaPY1AX9ClvlmNW1I8CSQvSxqJq+FnrGWqsmyl3?=
 =?us-ascii?Q?6W8ncJu6T25o7Z16ZeXaXoZNwKI6DwBKZiZmCqXggOMHZylQ2sxvl6UAu8qp?=
 =?us-ascii?Q?3fzi1wrqI6bhLV1k+yqolFHGDO+RO3sDy4nHJ1PCXDvFHu8icOP8vjA09UW5?=
 =?us-ascii?Q?dL97a76imfJGG3kgXaMubNO0LdfNLrFFp5oHuW/5b2MlvUTfT4xgDFJ9tezO?=
 =?us-ascii?Q?HjrRqQdt3bqJBdAlqo7/WN9IYfxvcV4+pPRcqC1rSAzqyYdGHoAlAEUMKz29?=
 =?us-ascii?Q?L/JuRhW4vCbw97Pn8Fw/1cJh?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16AFCA41414605439256FDA2C285D4B7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aec04c0-a8c8-4c08-3a45-08d97ee45801
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 22:49:04.2535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xqv0PM8B//E+aCfonIB54RLXKZY3y5wAEnTfUjpJci1TXn8zgkN0TUbjlu545tFUx7vpMYOsW/EkEKazxw8LMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7325
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 03:29:07PM -0700, Florian Fainelli wrote:
> > Does something like this have any chance of being accepted?
> > https://patchwork.kernel.org/project/netdevbpf/cover/20210821210018.131=
4952-1-vladimir.oltean@nxp.com/
>=20
> Had not seen the link you just posted, in premise speeding up the FDB
> dump sounds good to me, especially given that we typically have these
> slow buses to work with.

I didn't copy you because you were on vacation.

> These questions are probably super stupid and trivial and I really
> missed reviewing properly your latest work, how do we manage to keep the
> bridge's FDB and hardware FDB in sync given that switches don't
> typically tell us when they learn new addresses?

We don't, that's the premise, you didn't miss anything there. I mean in
the switchdev world, I see that an interrupt is the primary mechanism,
and we do have DSA switches which are theoretically capable of notifying
of new addresses, but not through interrupts but over Ethernet, of
course. Ocelot for example supports sending "learn frames" to the CPU -
these are just like flooded frames, except that a "flooded" frame is one
with unknown MAC DA, and a "learn" frame is one with unknown MAC SA.
I've been thinking whether it's worth adding support for learn frames
coming from Ocelot/Felix in DSA, and it doesn't really look like it.
Anyway, when the DSA tagging protocol receives a "learn" frame, it needs
to consume_skb() it, then trigger some sort of switchdev atomic notifier
for that MAC SA (SWITCHDEV_FDB_ADD_TO_BRIDGE), but sadly that is only
the beginning of a long series of complications, because we also need to
know when the hardware has fogotten it, and it doesn't look like
"forget" frames are a thing. So because the risk of having an address
expire in hardware while it is still present in software is kind of
high, the only option left is to make the hardware entry static, and
(a) delete it manually when the software entry expires
(b) set up a second alert which triggers a MAC SA has been received on a
    port other than the destination port which is pointed towards by an
    existing FDB entry. In short, "station migration alert". Because the
    FDB entry is static, we need to migrate it by hand, in software.
So it all looks kind of clunky. Whereas what we do now is basically
assume that the amount of frames with unknown MAC DA reaching the CPU
via flooding is more or less equal and equally distributed with the
frames with unknown MAC SA reaching the CPU. I have not yet encountered
a use case where the two are tragically different, in a way that could
be solved only with SWITCHDEV_FDB_ADD_TO_BRIDGE events and in no other way.


Anyway, huge digression, the idea was that DSA doesn't synchronize FDBs
and that is the reason in the first place why we have an .ndo_fdb_dump
implementation. Theoretically if all hardware drivers were perfect,
you'd only have the .ndo_fdb_dump implementation done for the bridge,
vxlan, things like that. So that is why I asked Roopa whether hacking up
rtnl_fdb_dump in this way, transforming it into a state machine even
more complicated than it already was, is acceptable. We aren't the
primary use case of it, I think.=
