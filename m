Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387EC5B5D98
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 17:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiILPrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 11:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiILPrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 11:47:18 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2081.outbound.protection.outlook.com [40.107.104.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241302F392;
        Mon, 12 Sep 2022 08:47:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B81tyg6+9cBSzeyVM2prphAnOYxEl1+tzm0dgtTuWMZ+h1O14jx7Mlz27zIuSJnAXXjQGK5bCzoov+t+ttuFdMuvA0Eoh3JEJ8Yk9T87WnBV1QP+K1V1AmZoWhGm+3uHH7orq2VBQWkOPjFAETyMi1Us2uOHK3VaE7cgNAKh927ORBBSutqDFk/XY3YKbq9ChqtD40R/yrqN3r267FCSSfnLAwHnU1v2xWL/sNp99mY8PTs0x1nGxDLXsDUK15PROsCmrqm/0pstLrLqDkOsPXDUzKC7ZWeakOeE1jqvMS/k4+pFu68iInd7A56Y6WkkJfwcIV+Fmx3d6tAOQPTHsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7kssGgwfhtfkvSDIBCC8t6Bm07+NLF1WRsmaZr3k6eY=;
 b=PGx/o5O/DlK6DLEBM8H30YkBWH8o7NPm4hfOq+w5ByKD5ymlW/VzghfJMArdpKx4HvHkgIBNuW9DRTXDTzZUh1EMd+9dtmosh0aoxAi+CN7RNixUEo5qgleeyzIx7Z1e/6cjczEBcbWIRwfu7vDEaUEfo/3Vv6Na9ikX/CT77FWdxob/WTpO4KA+TW3VmjwDOdR3iYv7WcyiVl2TZK0POg9J2+Kvou0sTl42+4XukZ6ZAnu2SqzdWPyFtJuyClENaGMIZJa9tEOslYO9eWTZ325YE5gbm8eNp7DL7kQPZdrG7+y53ocRtM3OQCLIKEKmXYtK90p4QNKuSr2ohEEutA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kssGgwfhtfkvSDIBCC8t6Bm07+NLF1WRsmaZr3k6eY=;
 b=CfvuI0H8qgoalKWexi6hs/hFpf/yxJCwxULWtsJs+h5yfWKXDmlbkDYaRheaZrKb0Zp09sKEMTxPeLojPh4uHflofjLItgIaR4H5MiKr7B3bNukwqa1yDDkAYPB9gIOpqnL7ZF2WyYMeQ26Y37Kmd+7f944PASlhnv9pFenpp9Q=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8327.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 15:47:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 15:47:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 2/8] net: mscc: ocelot: expose regfield
 definition to be used by other drivers
Thread-Topic: [RFC v1 net-next 2/8] net: mscc: ocelot: expose regfield
 definition to be used by other drivers
Thread-Index: AQHYxhmAN1ERRaXlwk6n3S0yVpb9zQ==
Date:   Mon, 12 Sep 2022 15:47:15 +0000
Message-ID: <20220912154715.lrt4ynyhsfvdbyno@skbuf>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-3-colin.foster@in-advantage.com>
 <20220911200244.549029-3-colin.foster@in-advantage.com>
In-Reply-To: <20220911200244.549029-3-colin.foster@in-advantage.com>
 <20220911200244.549029-3-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB8327:EE_
x-ms-office365-filtering-correlation-id: aa2d2680-7558-4407-e2a4-08da94d6113d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AX2wgmuw784nsrio2ejZhhpON+xh7L1TjXSaYGTHwBt3xa7NQ7mGwLYLtVdm7fg710d1eCDL1fBo+RYnf97eWluXcMwypELD3FGBceKLGspKGt34XNq/Le/hamubpGty4uIO4BxK6ThLlmIcUulNpmAOz6j/YbGJ2U5R0JWy3CnuBGfO86QzYwad/A+PBZl2ZA97IAiEvUvMq61R5o2EF39xN0DJyw3XjjjrfBJuhpKt8i8mERmpZHS/y37tAnO69p+NsqFmEtFYCihWBpBuDx61xA/UbSffW0YKxza628PKQdJG6DNmhSMcLkjyDkEEBPeC5Zy8xGe8GpQQAwXu4agxjYjHg4ZRqOQ4GRR+XcqCbY22ay28XNfp9lf0TiYA42MAmETqBWaqmAZRSkoooM44ChX+Ztr4m3+zMcHvNc0xsg79Z7aEIH3PVns8gKWb8xIkSg3ktlviBrYa98RhE4bMxDw4SgJ9t4VIw58/J6lTtYItngKVuG9SnUQBBn4D165jlD368UUWJzsl+E2EM6LtZ2Z9awMj3VgIVYXFb6tb6NKCfkvMFlVckFxLAiW8X/znIr1PJfuD5xUimA8U98/4loYRw5hn58jib8wpbxEXd50p3HzIjf+UUeXIJyYblV8UUdOKNGB/v0OxqLxGY0sKTJOkwQkXJQ6udQ8pa8y/y8YhErfKu+JS7lNrodDt6w9yt2RLiTrHFD/3caQ/s62kXplOp+oTMkt04OR3QmC9z4MDUvoNZvHxBmCcmZ1B89SUaf4bENJInd96lWuSrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(38070700005)(38100700002)(122000001)(8676002)(64756008)(66476007)(66946007)(76116006)(66446008)(91956017)(4326008)(66556008)(86362001)(1076003)(9686003)(26005)(6506007)(41300700001)(186003)(71200400001)(6486002)(478600001)(316002)(6916009)(54906003)(2906002)(44832011)(6512007)(4744005)(33716001)(5660300002)(7416002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lenOMGJXnNiqNw/pEVBDv5fZOlj6JybE/j6On/ywsZraxZcZzwwSTaFNk5WE?=
 =?us-ascii?Q?9nIfNgqdndy+C2YHgEa9evhJq25fd6jfyPiQa6uvxNdZRIdxaxoJ35EQf12Z?=
 =?us-ascii?Q?JM7HRcqqrbaHQ8/OcYj/RSMn5zGoPRcJFc7MLPZsRz9UZF3+6QBexOjW1dAu?=
 =?us-ascii?Q?3fmHj36IM0abqSeV+V/rwnuJ66L04HOVCFY7utlpFMC/q7GGF5cMGGWtqqfb?=
 =?us-ascii?Q?Mc8NljzL/U5Nvn+jCw1t/d2xREzlMHKDUrr4vACNdMhXgKc3bDkm4BMCwNJk?=
 =?us-ascii?Q?xtshtsh9OBxmVZ77ht7WBV37bP2vb+cD3lXnNygvELio8irN0ns5MdgWi8Nd?=
 =?us-ascii?Q?AJgkdwKvAee+QH2zjpc0ZlIZirqoKnKrB8yc/G7d/awR4PoLwXA8ZV41RLaS?=
 =?us-ascii?Q?o7ElIWM+6AII+li21IC2K6PTmXSCYJ9BMtw4UH0rMdG0Q8jWxM/RLxlCN1Nv?=
 =?us-ascii?Q?UC/drO31VyGLZtQNkxZalXs6oRv3765+loSWzjEzKK4rlrAU4vlToiXVw+LO?=
 =?us-ascii?Q?O3d6BAqAupY8Jl55qDuNgrIWHyOD+9bpWaNzd9Psnm/TcAGhSA1vrFjraNRX?=
 =?us-ascii?Q?toa3/gmCYo0iIZyevIgVRZNmb1RmQ8GXw7coH++7AvM03JtDbPQmJksPVnQz?=
 =?us-ascii?Q?Aya4zuJVl0UTAuoGaUQZnCXWD4xWqe6fCnpfsVDh35mhN3FPzhxRMzMYSARP?=
 =?us-ascii?Q?rFbBmOgrUBl/YFzJV7USQCV7w3rdCR5sYpDLipxF8TZc8fFitassSLUrtAgm?=
 =?us-ascii?Q?4q0YgU5wIl2+lQQYsGOA/MS8vMCCzJD2DAbCXhgtYiTUnOyjKrg5EU2ZpnLG?=
 =?us-ascii?Q?5ta1622nKObkHpXVg5JXZ70Fbkz+daDC+RwzIqmJyAfgavaBHuEUqPh8N1Pw?=
 =?us-ascii?Q?QF6/B4GZHGWG2wVbZnvS21lOTkMNYKxsDPrNsCs8JV4IIHaMPr77zsvyzKuG?=
 =?us-ascii?Q?AA3FFFIDF4BEbRM5yPPM9FQJSoLMafuFTZTXPqCR5zsoCziTUv0K3/udsAFN?=
 =?us-ascii?Q?11A8uQqA+RCMfG+6GHP/Yi1CpkRu9DhHKK08q2LloqBseLrSle5MR577ccZz?=
 =?us-ascii?Q?aFJQONtVivMkq3QlTf0nOuhkoPrrzY6Vg443TRCOSsRIkNHO1ZxWEd5DRoo0?=
 =?us-ascii?Q?ywIVxhB/wQW7XDcI2wNpN3D2K+xTDILvJDkWZn8QYkUrmCj8rYyHpw4Qvyge?=
 =?us-ascii?Q?9xJ+VSxTKOKq7dcuY+jR9woPakbUI1DC3DSj1npdXrlAB+cpcdMApcDNgwkx?=
 =?us-ascii?Q?I8DI7kpRDbAJeqQ+517sj+FgV4lbKY8lRox5/fFoZUZ8HKRAoRi2GBqXcDm6?=
 =?us-ascii?Q?sCFozhsfVj7xp4vJT9dSk5IcIHBhj/yfdod6po8gpInNcK2ZIuG9Dt+pOa1p?=
 =?us-ascii?Q?UVX8Trjp4Kf3lV9DOlGR1ojGo9Ul6GIoFodLgX3bJ270qnZelal+AgVXK8bV?=
 =?us-ascii?Q?0BKKHtu06UUrVgi0hpOJWVglxFNIZ2yWElb3lNE5Z9aJxsCZHQysZmGFRY4V?=
 =?us-ascii?Q?+MAfMH7TDZCdcOh1bxzxvexpZ8kgehK8Zkg2em9yM651e1r9fv/hJO150/9z?=
 =?us-ascii?Q?2ZKCq2eTJWkOTjo+sZEmCmUrM92DfBylU4L5ICjGtTEerPZ3MkLDXmGz0GqM?=
 =?us-ascii?Q?1g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3C97EE9D99D1754590DD438056644F22@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa2d2680-7558-4407-e2a4-08da94d6113d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 15:47:15.8902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CIUnOpTZ7Qb6wv+ra8Yez7BYmubnJa7ND0Xec9zXny/TyRc9k2cVJT92AkqZkkqt2LfZIbOzTN1ayIbFJUyA3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8327
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 11, 2022 at 01:02:38PM -0700, Colin Foster wrote:
> The ocelot_regfields struct is common between several different chips, so=
me
> of which can only be controlled externally. Export this structure so it
> doesn't have to be duplicated in these other drivers.
>=20
> Rename the structure as well, to follow the conventions of other shared
> resources.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
