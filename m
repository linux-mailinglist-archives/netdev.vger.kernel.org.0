Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788E75B906A
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 00:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiINWKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 18:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiINWKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 18:10:48 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on20627.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1a::627])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9786574E17;
        Wed, 14 Sep 2022 15:10:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3unTNSru8R2lx17VePXobZ1DEV8M5CCwBWOXd7S4BlZbFOth6EZYM/lB8jvqkt8u+WLBrYqdc2fGeR9YG99c2fumpmKWTTzhPZiygZn0/UsVS/Dt3fj+wGYWmaUmnUMhxIYlE3LC3R4q/ZaxuF0g9fSAuxcm99kb10BfLViBTKMP3jqt33Xv1Us77R58Ae+UmG9qg7OXjdWLg0ThbrOeRyw5b42g1nkXbrjgYLuZ9B1eQpUOSCovRrCMLoK/ZHcCAgfJwm8L1QHSDX8FX8SRSXaQNmEmd2Thy7BUlpQJHhCbNXBKm5gC4RL9XkPgUfgO7btxHiF5R4JKM02I9Kszw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R6M1f8EXbk8ablLiFTOicZJL0urdtlYlG8deSJcfQr0=;
 b=cX8478NXQ9/JYXNatMVH53S5snqjvZ2wcL9BVIt+z9SbYdzZWACNaznfvfMSrEKcpSX44mJfkWqqrlE9sZGPUrSj40lEbzuODQ6xMZOPnWMoPQ7NeT4m3EOaRJUjU498rAUJRqebz/zsChuukAihpxZu1jKi0g65LEkzHw0RVlW/M9sqzLk2zZS9Zmcccr+is8uinCcxgnrSxG+UIhbF5a3hWQFuaRhe9xuiLSwiI/l4sW5exfNU4U9RFOy8tRkDVR+oACBRiLsEfLOz4U441JTX6NLQfdzez/Loky3BeOOxutlVKpQ0w+FRSn9nsxQL8a+C6gw9rOy3QjyzgvcCmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6M1f8EXbk8ablLiFTOicZJL0urdtlYlG8deSJcfQr0=;
 b=oFI5V90t6XkTTewXngp2F+Ior01jaZAbcfFoNJ/Cq151M2YquIayhWjiXp0QoJb8jvH4je96Z1mHFb3qbFcJPaAkRGexkymgjMjLVKTxhwmBDq/QtumcXZeFkg3bWbnGGI51dOAgDpv0bcaDjLpw5J2yxX8CaaLWjZ/FLI779Uo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8836.eurprd04.prod.outlook.com (2603:10a6:20b:42f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.14; Wed, 14 Sep
 2022 22:10:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 22:10:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 04/13] net/sched: taprio: allow user input of
 per-tc max SDU
Thread-Topic: [PATCH net-next 04/13] net/sched: taprio: allow user input of
 per-tc max SDU
Thread-Index: AQHYyE9ZfT5bo6uCkEmd6s08JFlY763fdU4AgAAHuwA=
Date:   Wed, 14 Sep 2022 22:10:43 +0000
Message-ID: <20220914221042.oenxhxacgt2xsb2k@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-5-vladimir.oltean@nxp.com> <87k065iqe1.fsf@intel.com>
In-Reply-To: <87k065iqe1.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB8836:EE_
x-ms-office365-filtering-correlation-id: 769e1f9e-c247-4aa1-4411-08da969df77a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R3DIbzy8IAAMAdf1uYazRf5F6ltCDAFEoDPmvT7q8xUoE3YDArlYmdf3dQCYRlErVfVBxbg6c0/Y1POTzREuf72aHWOYUTnpd4g0jKA30RbCrY6p4V02yQ5uI/DryswQ8/tLbrmHd5tSd9w1L2v7TkGsKVj7CFpzSUFRsasACSc/qC6d6tks2qVerbfW/iIxClb5T8ewUOSs3AyF0Yd7gRMtvRAlNREOArW6+rpvi1ZdfQcaDGRcfR27YikEKxnGjZlESC18EGihwN2KrL+QWir1l9x1gfuynfXgYpKZlTteshN/EcNRVPIhReQMgXd6iWy7mRazoS97sl33uDc79rLrpdYWGDyFMqvW+an5UZvMShgmMr4YEuXqWP3ty9pd6yY+Dfil0Ud65S27GQmV5vU2EqphtnO3IL7phuny2gOnM3hJkwpV76n6d2I3bdGTIramxPIq9SbAZ0JhcqBCRHobattdnGWyUk/uZHTBcyqVVw2vbOmjjRfEjqAkhUOkXVn6eZdr3m0Va18BMMhArtz9YNKkulim/UP25RKhg/gvL0P3GdHTl2tgMzwOLawugK2GU0yrTDqxg9sEU3ZO6xoP9j/C7ELwukD5hjwQN0eGrMO8it2aKlM+bTNq4mppj6aCh6XtOvAGKPNpW1prtZJgT0AmwcTE7Y2V0JZq7DD64DAuY/5ZbFBjIq6cARRjbB3GDAHBJCBvDlwOcBC683gYd6WTxHeIV5LJGYLEzSkR4+ZuL5XxW9oAC9z/GaDMpWlNTLJdfSSx8D/wvMYIYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199015)(6486002)(2906002)(478600001)(41300700001)(8936002)(54906003)(6916009)(316002)(66946007)(76116006)(91956017)(4326008)(66446008)(66476007)(66556008)(64756008)(86362001)(8676002)(38100700002)(71200400001)(122000001)(38070700005)(7416002)(33716001)(186003)(1076003)(5660300002)(6506007)(9686003)(26005)(6512007)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w0Kw4YLgHi9DFx3MahcW7IiHVDWFlFZ65wlTGOqgRiAHSVHYO5UO1mExZRZ5?=
 =?us-ascii?Q?9qirMI3SIXbHeMlnj6iOGSkm/tyNwv+JbJj8SW7oS6xtanITbiqD4BRIKe5Z?=
 =?us-ascii?Q?T5DufAcQ8Da4hlauorXm7UtikvEBy4twbD+iw67+yiv9fyu0q5IeC83Vy/I7?=
 =?us-ascii?Q?ZCVRWpw+BSZtgx83GIILz/fVLaMOVJessZ5xcQfpPSgP2W0+wVaFHuQg13+G?=
 =?us-ascii?Q?NDCGDWSQsQnVzGHk4Tlwxj3nGwkDbzs0BUlY8Vr2+3nlAYNvMn3uYthc2fwM?=
 =?us-ascii?Q?sZdUzvPiSjFwnNSj4zbAOchkdufxjeVT1QfAuSP6tgG4F9DEJSMWx3RPKZ5J?=
 =?us-ascii?Q?I3IHT+Xov2jN5bqNiQiJd8rEYFsb5ojiE7K580Hp61uCNLzvUZbb45TME3ze?=
 =?us-ascii?Q?mEzHxeOlH82XTEzcXCxJJ9JyqRYej8vcg2YDSCOFLK1T7efp5jK3YbH40VOM?=
 =?us-ascii?Q?EXkwCdg0T5q1m6kjMGoKVaNhHJUK5VPhw4sR3SK4HVSCZ+HNVInXqV3icGdB?=
 =?us-ascii?Q?k2hbtSpNFhHWSvyQQfRyLWmt5rEJYU8oY+FtX9wvMTG2HzJTfUq81O8g4UYS?=
 =?us-ascii?Q?k/7wl9SAeIn3pmxCelFhSeobXRW5kZl6Ku/jsaSpKR3NJWdwBKXon/cNs8vE?=
 =?us-ascii?Q?UMlMG6wNESysPr/og5JUu9OfLTsPWeKiREDVKkfvEa+lV9HAcjYBFBWr2quX?=
 =?us-ascii?Q?tvix4sAKC1Y/JK+9nMyTd3vzCEtuTTZ1JYSZ/A8WI6koCSsqQ10Hik1me5iw?=
 =?us-ascii?Q?+dE0qsQi61YAmQuxKOt2qoiDNvhjc+CV/wcycs6bOxZkJoSPV3WQwjDKTcGQ?=
 =?us-ascii?Q?HpZsLTeLTmXLuC6+DNmhawpOZDAyA/DHSjvT6k7Bau48dCamEKSmWdc+NTYI?=
 =?us-ascii?Q?gFYg5HdsG7OuYMV4ZJWjeZolgRFCCVzbwEgiyw01Fo50RLajnRUSyTzwe3mM?=
 =?us-ascii?Q?H/8Xx6AdS51Vz5AXOlxJsMOMeh9tYAUta+k+jNu1famSDey9AnmfHbZJAIJ2?=
 =?us-ascii?Q?Pq4DhmtSt6Z7tIg1m7cj28kbv+UTlKf2UOZcSKXovOnZawkUeBvUysjA9LkM?=
 =?us-ascii?Q?C+nreAhiYY8g4WzHmI51SWSAq1uoL2bCFmgdrE3oU+MnyY280mEhaNmRKed9?=
 =?us-ascii?Q?cbLcmxWyeQa1Mb/ifwB+Kxnv+UWu7+OOLOCM61e8U6OHpfpE7fGe8HWvSCiM?=
 =?us-ascii?Q?9ejjgsU9Eu87hkNLncrDxEXBhrtP49dV+3whXGdDGwwIJTu8t12Z1Xja859A?=
 =?us-ascii?Q?fMViExJOPQVcAYrKjuzfpHYhc/y3mRGdOOT8gI5n1jlXfqtB+N6ceoTFN5Ej?=
 =?us-ascii?Q?I7cWs+UZ43b9BJ/qJ0guCWxEZdYzl3T6NkAsn+x448QLZcSZv2G8XXr+wnQz?=
 =?us-ascii?Q?pkSsP4IfRfISMyeGFNHwraJiLzcB7gyNt8JmNQaflKLcMfsdsigiwQd/NC5c?=
 =?us-ascii?Q?XHsNrSU8aeZyAm2Y3HwTmOq2GQ+COMVkqEy1z4K+TZKDf4AJ0zCjK8AjhbO/?=
 =?us-ascii?Q?ACCxvrP8b+75NxDWVK0YGS9zEp9B3UzyXyu0sSg4VCrNjhSyHNEvvq/sOhhk?=
 =?us-ascii?Q?bwP4Z45d1Z9Wu35fY8IFiHfdAoOWxVaizzkZ1IdTSDzTrwwEh4vE06sftSG8?=
 =?us-ascii?Q?eQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <258B0D48A865A04F99C494AF343C9F6C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 769e1f9e-c247-4aa1-4411-08da969df77a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 22:10:43.2051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h+m/atCdWOEpz+I6qVurK4AV1UGCQ5U8nFj4W/k/9cLy5kA4eoI9TvYuBGpfLdfsf0HQqySZ4aHSMM+nEr8qZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8836
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 02:43:02PM -0700, Vinicius Costa Gomes wrote:
> > @@ -416,6 +417,9 @@ static int taprio_enqueue_one(struct sk_buff *skb, =
struct Qdisc *sch,
> >  			      struct Qdisc *child, struct sk_buff **to_free)
> >  {
> >  	struct taprio_sched *q =3D qdisc_priv(sch);
> > +	struct net_device *dev =3D qdisc_dev(sch);
> > +	int prio =3D skb->priority;
> > +	u8 tc;
> > =20
> >  	/* sk_flags are only safe to use on full sockets. */
> >  	if (skb->sk && sk_fullsock(skb->sk) && sock_flag(skb->sk, SOCK_TXTIME=
)) {
> > @@ -427,6 +431,12 @@ static int taprio_enqueue_one(struct sk_buff *skb,=
 struct Qdisc *sch,
> >  			return qdisc_drop(skb, sch, to_free);
> >  	}
> > =20
> > +	/* Devices with full offload are expected to honor this in hardware *=
/
> > +	tc =3D netdev_get_prio_tc_map(dev, prio);
> > +	if (q->max_sdu[tc] &&
> > +	    q->max_sdu[tc] < max_t(int, 0, skb->len - skb_mac_header_len(skb)=
))
> > +		return qdisc_drop(skb, sch, to_free);
> > +
>=20
> One minor idea, perhaps if you initialize q->max_sdu[] with a value that
> you could use to compare here (2^32 - 1), this comparison could be
> simplified. The issue is that that value would become invalid for a
> maximum SDU, not a problem for ethernet.

Could do (and the fact that U32_MAX becomes a reserved value shouldn't
be a problem for any linklayer), but if I optimize the code for this one
place, I need, in turn, to increase the complexity in the netlink dump
and in the offload procedures, to hide what I've done.

If I look at the difference in generated code, maybe it's worth it
(I get rid of a "cbz" instruction). Maybe it's worth simply creating a
shadow array of q->max_sdu[], but which is also adjusted for something
like dev->hard_header_len (also a fast path invariant)? This way, we
could only check for q->max_frm_len[tc] > skb->len and save even more
checks in the fast path.=
