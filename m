Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3391E5E6EE0
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 23:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiIVVxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 17:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbiIVVw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 17:52:56 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2058.outbound.protection.outlook.com [40.107.22.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E918A10E5DC
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:52:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htZZlV6IPU+hxZIsaQRMhXWQtYyaRRfKOipV0H7ZW+jc3c+ZNp/2vU6e8gvWSZa0R/WslCrT9GCLBik9a7HZoQBLhDfh+fW1oGTzOLH7sGuIGlfzX+PhIdWMxK5zeS/VjcUti6iMK6suuAepdZu3+iStH0+57p2Glal/CW19I0J9WFPOHp0rag2+w788woETiRtDXhoPmTjYr3R6N2Cg+8NaXZqFqmEfapd4XcJdkgDzjxS1Q/A6V5j9e3aW6dHcGuxYjltP5Sq9TjAr9eImzYmJ/FW0DxF2rFNn+xiJm0ZMqP4X4nJ7s2H8T19QSYs3GtNWYkmwJShfyg0e7O99oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jSM16tKDOcQAprZDXeg7lnNp8rpsxwRp5y3WnxnbBuY=;
 b=jOnWyWBjm2YHaiQDrspVVWXYWcrWRdImX9KygzS3QCv0Mx6oW18QmJpUMHOk9O3h0NHujlmh+SclymYjpVDBuUd3JujXbjHjcPbU/fWuXp3+vdmQ7jZyX5E0QeAxJC8lhZG+YstwEmNPJ3l0iuQJ82hgsWN7289aTPIwptLClKrJl6gXdl6sg+t9pDETt556ceoOccS6c5eNgPF3dTJFkbQJHQ7I/MJygwZK7hegGnokEmqX129CwzwWDlXBCWArs+OOFK+OAGW6XIJwWiBrQ0Z7j5+W443bmlQnkw5DjVhMgMHXKAdgRT0Tq54/GFogautaJiRYq9nokXc3Sa+YlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSM16tKDOcQAprZDXeg7lnNp8rpsxwRp5y3WnxnbBuY=;
 b=WY6dSaxq/ie/iRMo+QBS71pm28cwobIVMifwj0NTXVDPIa7HzOOWzUfNNt+CZGAsn4O/xRKHU2VjeaRrEq98Lk0uFxGmAEJeyrV9FAg6ARFdSJr3VXcMkZkWsmxvnK50vmbHYGz0Jp9o5X8mhOU3wSh9qqkpY73X07R/9rE0uG8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7991.eurprd04.prod.outlook.com (2603:10a6:20b:289::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 21:52:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Thu, 22 Sep 2022
 21:52:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Topic: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Index: AQHYzdpfTBwouHrLuE6KwxLywZqExq3qNnWAgAAAg4CAAEHDgIABDlWAgAARNICAADKKAIAABd2AgAAI7wCAABAEgIAADnaAgAAAo4CAAACwgIAAAxQAgAADIoA=
Date:   Thu, 22 Sep 2022 21:52:52 +0000
Message-ID: <20220922215251.edmytm4u6uahrd3m@skbuf>
References: <20220922144123.5z3wib5apai462q7@skbuf> <YyyCgQMTaXf9PXf9@lunn.ch>
 <20220922184350.4whk4hpbtm4vikb4@skbuf>
 <20220922120449.4c9bb268@hermes.local>
 <20220922193648.5pt4w7vt4ucw3ubb@skbuf> <YyzGvyWHq+aV+RBP@lunn.ch>
 <862fa246-287f-519e-f537-fff85642fb15@gmail.com>
 <20220922212809.jameu6d4jtputjft@skbuf>
 <fa76bef5-50c5-d9d7-c2ed-e743dcbdcf2c@gmail.com> <YyzWkuFL+gPubz2M@lunn.ch>
In-Reply-To: <YyzWkuFL+gPubz2M@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB7991:EE_
x-ms-office365-filtering-correlation-id: cdbc5af6-a7ea-4d58-931e-08da9ce4cc52
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: he6zqqjfbdHzwlrrzwRqyiKNyIya6wuQcQ5ZTv5dDKT6+lVC7l+MmbrYi8Q6/ncyjaFDbpMVhbGMj5qMud7nxrEJE9ZLplu8dHdQLD3NxBPMxo/q9i63+ebFYR0Y9xTD1ghXyQjo0Xx6hlKKYVO9H7pk21Te2cPKpFXhYHWbX6WWun0PKIVJNpfvDMb5pwo0Gg/jtxvl8wBU2beK6s+5ofV2uvI02LQrDxBN/PzlKoJsWJdGXz7NXhj1FNBpl2QY4snpykMRBdjpeGbMuODfvvUFiWTuDgB6+6hyVv96VxwX8VvU/8aeoZ4FhaU/8EDALiqG7CWkcgualVjXV3EVyy8O9UVWYUBu4gABafj9uAbMa/BeFFvovA+RKb1s2KkUjOLWJ0CcylSZ7lbcvUe1yQF6utZOd0Rdf43AxAcf5yRjvGdoT3lBYnqPpMVbOmbtFctPrhRb2AQM64n8rllXqKHAyCp5t07bC4b1ub4mNzJt6BFPnVoS0dQhD4zIQopnF3XZwZER8Kfz5FNgvEPoyxNhi25iR919D2bqWlk4rYcpbQjFtqzdtSbcqrrJRk65+/vZdXVQZhPOOodwk3XoEJs3EjMneuBykHmssjyeT/E6LjZtFPWG1J4mGa8Ob18N2slVAL/WieeT0hFksUkTV4EOllZ5mJAgp2iQ2pPsJJ5pL4LkSBWx+3Tgw0SlATpZ+fDUGwmgHiux9jcQwFfquYiSgjewn1pt8H3OgW4IwhUXIOxenEmkMyzQU6eQIX/izTJJxaAkG3JJ5kiol/zQJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199015)(66946007)(91956017)(76116006)(86362001)(38100700002)(6506007)(122000001)(33716001)(2906002)(6916009)(38070700005)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(186003)(478600001)(6486002)(1076003)(9686003)(5660300002)(4744005)(8936002)(44832011)(6512007)(41300700001)(26005)(316002)(71200400001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1BywKUZt9/QukecF0vBcEFiwk+Tn/ml9HLhAIEicm/CA3+Nh2yHazpN8UIa3?=
 =?us-ascii?Q?FKuuTpJMR4fIYKJpUShsRUHwJ5rTxTAGecq1dG5NZ00HZpk+M8qd4+Z/OtTh?=
 =?us-ascii?Q?/owQIUO/xyy6vKIjI70NjmwtMoQqryL6Lvgji3XrJrzTLDf7ibQ++1YmZeiH?=
 =?us-ascii?Q?6mmREsLM7Gkn4e/nUbYIRNlIgJn+clMJTNnZAG95wJShYGLiW4X28+EYTSUW?=
 =?us-ascii?Q?pfRfvRhz7gdb1qdyVn/gSSI6Z/cjOIBi9cSjrszHVsJMcH4fwmplFpTS80sc?=
 =?us-ascii?Q?qg6F8egGkS6zlj1qQpfOUSzQKVeFqAYn+aR3QvBBxA9+BWBBKs+NiO8PtMu3?=
 =?us-ascii?Q?Fctr+aTeEAZzzYRcA5+5dnxkz1gKfsxAMonIMVbPZ3zYdZH89/hoaFh2rsWW?=
 =?us-ascii?Q?b/ycX/JJAyRdW6+fGOlQu/KDkGoyGiVlPII5Ym1Wn1FE06obzetY0Z2uu63m?=
 =?us-ascii?Q?byOXhqvOPV35Ae18mBIo0pRvCZOjO6lzSeFyu/f8oKZxbEA+6KptK598tcfL?=
 =?us-ascii?Q?yKadp6r4IAQZgRIlpDdCscTwsG6itP+XbU4WWYf5w1rP9MbrViyvdyGsgVeF?=
 =?us-ascii?Q?FUVTbhN5ImOiGpClgxX/gXjgAibzqds1M7+sSyW2jf5Xz0ekOyQ1XN6ED1Vb?=
 =?us-ascii?Q?qK9iT4YtgG4GbE+P150cPeLbfLsyk/qwiXevLhPjt4tTt+6FQbUlsHHnKZi4?=
 =?us-ascii?Q?0A/5zv0NeKqpafzjwJkvZKpc7ob7i++L0iglnVSMWs1RdR3C8mZSL/ohQ9NW?=
 =?us-ascii?Q?uZ5sbS+1+UNLTHvDcgbXK1PNAgpxQ4RIVyfBIDrCW1a6szklHC1FNU3MqHPA?=
 =?us-ascii?Q?fG+dHQ4paM7Y6YooltWf/B9P6s3GTCxWs9i0h5LrkqosjxcRQUjtn7LJrZMH?=
 =?us-ascii?Q?4ltq4NbTs2j8Qy66SUKAfs7SB5Y7aKeU+fHwqoWe5vwnI2kefxb1UgAQnf2E?=
 =?us-ascii?Q?gNyfWXSoKAV7SK4U9yt996Cn9Ccazcr3AzDN/ihMyuxv+0vGVmeRSW3GWown?=
 =?us-ascii?Q?4ez/em0y3AlWAjb0afY5vPZMmi6UDftsDfiko2vclRJ5UZQJR9bzydSspdoj?=
 =?us-ascii?Q?stElnvMrRLoREGblDXFbJJPkqtE3bCRfryFFczjbzw2VCZp1KsCFtZEiRq8z?=
 =?us-ascii?Q?S7ChEVIltxAuECgnS17claST1DGx2bnM/57l+GVAzZfi/ctRKtPY6A+gQa1h?=
 =?us-ascii?Q?8F7qFZBAxS7+vDQlWZF4FJsWP+YQcmU5uReQaFrV/VypmEPeHJvJJcrVBeya?=
 =?us-ascii?Q?VLA2pAa7ZRBsMX3VQ6DYim0jMH7ZHHt6w5l7xBiUwL7NWeJJOJuJOECU7NG3?=
 =?us-ascii?Q?nLTWnbB6Ci4n97GlreWKUXcCx6beex0G2zSuviNBceSsZ3sOHq41G1kZMU/o?=
 =?us-ascii?Q?XV0cvtrPNd6WCRTEpXjkCLY02PxTzfM8J1Bq5n3+j5yssDjAz9JnMxwxb33F?=
 =?us-ascii?Q?PGZ8zbV1nr+UZEd4+cS+DaS11DvcA2LTPYEoI7lU1mdbUuNyrpNdgke/NUWW?=
 =?us-ascii?Q?hO16IGLCIwXIRtTpjWCNk0l4OmLRL1bjZwYZ1HV3FbrMK+nSd3JqTFpnO4WS?=
 =?us-ascii?Q?EVRtPQ/+lrxs8xqnosX9jLGc0rCdpK8jXh2lc5PQ1O7LIudHSTB+qdaV8fFD?=
 =?us-ascii?Q?6Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C001A3954DACAA429937B6981E6E5FE2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdbc5af6-a7ea-4d58-931e-08da9ce4cc52
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 21:52:52.0630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hXuTz1nOIsLp6OHGeQraAUI+R29EWpjcIEoSGISZcTbdoNedHX3Otbv+kkKppSW7PqR7dR1wTjQZPtmCF52tSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7991
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 11:41:38PM +0200, Andrew Lunn wrote:
> 'via' would be totally new, and i don't see any need to introduce a
> new term.

Well, the entire command is new, so...

Jakub clarified that 'via' would indeed be used as a preposition rather
than as a noun. So it does not describe eth0, but just the relationship
between swp0 and eth0 (specifically their traffic), and therefore it
isn't really a new, or alternative, naming convention for a DSA master
(which 'conduit' is, on the other hand).

What I find a bit awkward is the 'set ...  type dsa via ..." syntax,
since a noun would typically be expected in place of 'via'.=
