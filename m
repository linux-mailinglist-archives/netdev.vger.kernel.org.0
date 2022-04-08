Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B314F960D
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 14:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235878AbiDHMso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 08:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbiDHMsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 08:48:43 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60068.outbound.protection.outlook.com [40.107.6.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38353EEA40;
        Fri,  8 Apr 2022 05:46:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/o4rzAQ2vSA7zwXqjmFfHJ+OjITUIp1HMxU4s/ZGUcMeUgBAoavxkq8L5WbiFlU0EeGO1kED+6VoqYSE5aWvlNn0tvpoY4zOvg3ypzYsfT3JFP6Ct4AYLU8BrsjnYeyssVnUpgdjcVSRbn1d4U/SHFLwa/3m0A9fb/FhZi3x6v823B2/IcDp5PEV/Mc+9Wf3GrFrkt5SrlBydumemHiLJr5roXwAdWzAGEYDyTyKjsXLu//voSQIcm66YlGigJ+xDSdnkhlDNIGWdeKafQtdxP6RRR3Znq0BqPPInYx9LQm7eCM2dLdYMYlHajeDSkZrUF7Hyd7UShsSfwN0Csw0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kn92hTPan3Cx918Zq7FMrekiwdQd5gqi3I+UGJ3R4/Q=;
 b=hK8OdWdZbwtaiS7omy4EYe+yxLHmJHZSTJujZunHH7aIDHzt81Nk9i22JHqJYA9mbLU97E7zzCQghcnmBYMyfRzXnqTKJ23HjQ4CWZv6B/cuQ6cATpTbIB3DkqZJMMLGg0WclxTiq4wj6GL4OkwHQYJJ5tL5UxpqQ4ff3TSxypWPGkCTgsgK5Kxe/o/XW07fcC9aF05OFtWe6oqQod8y5129ZZ89NPNV9GoRwfa6Rcbk73LyW8iozC/1erano6qMwS3g3QBNDJh6UaVFmTvcRxCCA1sIIe+3xZyvAlZAAOKunlGw2rjmUfUOCgU7uFbJ5n/Du1qd8POPraZWlwyMtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kn92hTPan3Cx918Zq7FMrekiwdQd5gqi3I+UGJ3R4/Q=;
 b=rTHv2wMqSpdPzMrLgR3G82JXcQZwLgTaWyvuVWAfC2oJ6Y5zlwFNPU61ZSevZAxY1NyjYXWKH1qrK3FXb87EF2W9IQFUKIg7ddd6EmzCP+7SUcTAYBwytPHk/dLpUjXULq/T8AUV8wkYNvSA7sAO9evFLTl6wDXGhIX+JLvBc/w=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5506.eurprd04.prod.outlook.com (2603:10a6:208:11e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 12:46:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Fri, 8 Apr 2022
 12:46:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: dsa: felix: suppress -EPROBE_DEFER errors
Thread-Topic: [PATCH net v2] net: dsa: felix: suppress -EPROBE_DEFER errors
Thread-Index: AQHYSzGWvEeQxHa3uke1Xw4hjZdwZ6zl9voA
Date:   Fri, 8 Apr 2022 12:46:37 +0000
Message-ID: <20220408124636.t7a3fowe3vz6gd65@skbuf>
References: <20220408101521.281886-1-michael@walle.cc>
In-Reply-To: <20220408101521.281886-1-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3fc3620e-7e34-47d9-1239-08da195dd23b
x-ms-traffictypediagnostic: AM0PR04MB5506:EE_
x-microsoft-antispam-prvs: <AM0PR04MB5506A060C8C1AAEC744C5BD7E0E99@AM0PR04MB5506.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CdCsMOdD2hra26f1WdsVpBWqm5W/YmRaEPNa0q0JI/GGIZIfG66LiL9e7dRhnSOEpOjrQ7i4sL7mfYLdLOSl0c4f5ovuZGuDCX6QcZmNgZudJTcDVWZ5ugJtUcfZc21edN9YKXcMn8zgb0P7ZhdzXCaxrFDvyrLhNI5dCDh5inFbKqWn1Rc+C7av4JUL2KfMnyyNCGZMmLcLgg7hzt2oQh/rWrmSviTgtEJOgNmetpkE+q+NeQK3HB8K5fFBFSt0Uj08PPlA5arseAjxmTleYtG1a8vovmRUagSqqO+HrH9AuKHZTkyaTsXvL+A4XS/esTEDrsDCsenz+/ATrxchkUr3ZM8/bGp7gSjG2oIn6c2HbwEkPG9xMVtD7cW+ainoFpfTiXjDEKtx+LouzSi8ps2hv6j99BXDwmxIu4z2Z24kxes3b/aoxhQCjhghX9LpVb+SV2yO67sGkY+L5OWLyoe9F9Ej3WVNb7O9r2eo0bzc2E/0DT409a9JNHc0pbrRMRsyU/nl/vEY5VbjJvul2ZIsJfj+O4H12RnvG8jXTC3kJicNumURbPvHmeJpJtm7+P6vrpnxR13kcJwFIArsI0VtjwS4hJwZhOEkRXroGbx571A/psrGdySEHgPKMauzKANi41p46wkAB5JWCbhNVEJA6b591jd4tngPF/t+mQ+IMhppWc0W0nLCFUurefsjjnCN0uDDd095HHYSMw7ihw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6506007)(54906003)(6916009)(6486002)(9686003)(6512007)(83380400001)(86362001)(316002)(186003)(26005)(1076003)(71200400001)(33716001)(508600001)(8936002)(2906002)(44832011)(122000001)(5660300002)(7416002)(4744005)(66476007)(76116006)(66946007)(66556008)(64756008)(66446008)(8676002)(38100700002)(38070700005)(91956017)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?y6q16Ibc/n813IOii9j7H/3SoIOfKu286oanI8X1PTfyLgeIiGG4YRGdJpEz?=
 =?us-ascii?Q?6the1sRKtStcuemrwhdIQFOKJvP9L5e7TTu4XHvnul7SKOSp0n82N9Oo4NeI?=
 =?us-ascii?Q?cXl0qnpAKuJraxPWTGPlkE6/4A91ZyME8WTGvp2Zerf0fhGjiwzkBhVkzqMT?=
 =?us-ascii?Q?XY53Y9oY8x+obh/37559KRIq9kfeina/yW6H2wgHTBq4sR1QQm7+uiKgmQkj?=
 =?us-ascii?Q?9naAofD+NAUAkagwEL+WWTPtu+chAlqxB/wVFcvbdv9CQ14UvQqZkTeDIeuq?=
 =?us-ascii?Q?eUFSOjapXm7VEr0SXHTzQyRMGm7x9wVBF6QPrbQMjjm/QVGVt/y+1/UDQ69A?=
 =?us-ascii?Q?uHqKG8ydXiPfBU+dNn91mrQPfg3I88GIRPml6DxHZvmin6wNA96WXVOwRu6j?=
 =?us-ascii?Q?ng7LLB61MqinZsoqA6LmQFhao551EHhzShHHB9l49O+JC1Ym+LyUWC41NMm6?=
 =?us-ascii?Q?idCJGJiRlNWLtTbzuuxosoMCpUFQJYjTzdXzTPDs1uDBpb0rau2fhl/gugKK?=
 =?us-ascii?Q?XAMSPc5LDr47F7U4I3RbR8s3EnmJHXu+73IB7AowTfKRraqXnoRTUdwGZNxN?=
 =?us-ascii?Q?js1fE2fDJtph5U/DdBF/WEuKxWC0lOsu6iAK4HvV0+gnfBgz87TxACTFzy5q?=
 =?us-ascii?Q?YYcoNttRa8j2Vv/b9Intz8uWlouRLTSh9uhyXYTsj+tGBBHh4YvaUj2gSNqu?=
 =?us-ascii?Q?ly4QRr0uQ2uimBbI5loc2/WWEN7pSkZ7RXE+fOTdds2Je+fGvNZN4nLqCjAy?=
 =?us-ascii?Q?mf8NRT8VX1uaB41N4wa+h9Cyc6zgvXXY+fHB738E1cTXl62oaGFyaDNYz3FG?=
 =?us-ascii?Q?HyfsM5see/Fqh5xqpWNZhbLKkZ6vtYWJk5Nrc206d+AJqEnA3iz6lUMugAe0?=
 =?us-ascii?Q?ZqddPOogqzhUGSKCDI0dj2Bq4cbOWL1iXECOJjaaYLIuCnlazfSPHk1jHLFO?=
 =?us-ascii?Q?eKhBZPQzqNfGXleOBmAaolx/A6OpFRTZAE7e2Lxm5sv+CFQ3me6pQh6af68s?=
 =?us-ascii?Q?NtXUckI7tFaNpepgSjaM8u4NUSFbrn4I0rmmFE0WwPVGb3TF0X4CCt7qprND?=
 =?us-ascii?Q?uPH10/WXCfOwNlinz/ngcuUGqMA775or5UxOen2TZmU4xMTG2nE0zLw+dk3+?=
 =?us-ascii?Q?7zvhc3+wLanZPA3hJvaRxYwaUAFRYkTerBspu1wxtldxm+VjXZmic6GU7OaJ?=
 =?us-ascii?Q?9OfQThS4coF35vr3+s1xzs5eBYok8HNv81FN0lqMFKiZZFYUMJ2CsRzMHwT9?=
 =?us-ascii?Q?C3oIoC8mauvWUIAwf77PWUTYcU3lpB3zDpN/w5gr/F2lDEwB/htWb2xzuINU?=
 =?us-ascii?Q?8d6oBWgG9ig0rHdZwVY9HfnA5yho77i72YNVWRcbztHh78D0NVJwWOPp13+m?=
 =?us-ascii?Q?8jcpm0DVF0/Qh4XoIua2B6uOoXlo/Z8MBLSq3YMdNx5a9k3xAOK46cN3FjPj?=
 =?us-ascii?Q?5sueOZcdBuLFKT6ZY9nfNURaHz+5eui+Q0bl2TeGjfebu+kjHIcVKcEf3MYO?=
 =?us-ascii?Q?8QA6v7REbs52LhJx5clt7ZXaOdXZJLoBEnoqNVLZpGMPsFgZaq2Nwnos8n+b?=
 =?us-ascii?Q?xCzxTSr3qaCP92AZeaXNQv9H6g9nZZRQVokDCmM4VPrJcRJd5NmecPnpFctp?=
 =?us-ascii?Q?xUb3pKK7AGLWa2F5P3fbuAso8iMkC/4E+j24EycIQZRWlkWXhWfEVDVhnilP?=
 =?us-ascii?Q?PPNW8MwQJEHWdCmtcg/mfi7iDErfmZ3PwWorK07kiestUXC8VVe4kLgHGczr?=
 =?us-ascii?Q?Q5zAbSXE1+3LEcybkEO+BLP7S4CvxPo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11C3FE5EF472874D8462799001ADDE27@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fc3620e-7e34-47d9-1239-08da195dd23b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 12:46:37.5461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v+LcicEAJF+pLryaGzZGPf7ltECWFjG23G46/F9Azx4ObDafOWGQ3OEiAVlrAtH6eDNAstv95AzPIyEnRDKOmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5506
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 12:15:21PM +0200, Michael Walle wrote:
> The DSA master might not have been probed yet in which case the probe of
> the felix switch fails with -EPROBE_DEFER:
> [    4.435305] mscc_felix 0000:00:00.5: Failed to register DSA switch: -5=
17
>=20
> It is not an error. Use dev_err_probe() to demote this particular error
> to a debug message.
>=20
> Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch famil=
y")
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
