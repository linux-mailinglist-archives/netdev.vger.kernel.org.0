Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089CA31D78B
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 11:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhBQK1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 05:27:36 -0500
Received: from mail-eopbgr00059.outbound.protection.outlook.com ([40.107.0.59]:64070
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229707AbhBQK1S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 05:27:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d5z35YAxP6vLhUcsBEukI0IEa6vZgK2nnN9OylmEJsRjWggV4vpGr+oW6pB5rFMckWzT1shLX7HL1LarBWTJiNx+j1V/mx6wr8vRdWneneekdNjdmuxr1BuynVhJHAZLP0jlyuZ+vRBxHXpEqtOcGkIk7nXxFJStRXL0w2oVszAShVEM/apwIPCZfkPRKdjIlOhPx3mGeRY/ONN+2xcjfX5N9rZMGYDh1KNprQ/rlWdXMvzCZT9m3z18ksSGvF4WJ1kNYidCRAUG+e7ihHttpOUIx/SC6N3x4DS/p6KoVrA5agkJddtyw7+Pb7JWf5+KWXRDNS27/qMiPB6GQh61ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxu8JXonfxe/rLmFGQ6sCdtG8n40EDKdDN0nEjSfKOo=;
 b=eMhPR0ahsowmf/jL4T9TX7AmP5nu7M7gZ/ivmYGDho2ju5d342fhfn4JpfhxPU+MoH9NBEtoV9jLYKEs24unF0JAyl1gu2lIg67mG9XRwEfAbP5UN0s0PnqcVBA6MiZlE+wZ54X9eDXCvALK6nhxRQbtXy7DiE8IH5zDzzJRGrESjTxllDQAXueSeL2FLZSJe4c8MZlYjad96Ww5OrDmL/gi7T2foJ0lXBXo3PGqQemaBvm3PJ4og4o3CvMPqn+zE/yEGC2+GEdjKiCbYXl/4JfkqWSNwyyG9Y6ly01ZVaLlhuRrmJYpUXpcpBeY0AMlfDLqAXBQBBm6NVA/wd8qQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxu8JXonfxe/rLmFGQ6sCdtG8n40EDKdDN0nEjSfKOo=;
 b=hVwJ0smV5Ve8VE5OuI+AMMWPG6QInWbI5y0Kdm61ZWL/n6T+MKteaKEw32M9ePeuPapgdTK5p6i2rEx/coiPvCRAf/G7NxFjOU0JccsjwUcarFfEGQ6MCJpcx96jDy8q8F/j5+hi8tqtjum//5y98QDP3o3hsnHSxFPdZunm3Qg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7119.eurprd04.prod.outlook.com (2603:10a6:800:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 17 Feb
 2021 10:26:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 10:26:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v4 1/8] switchdev: mrp: Remove CONFIG_BRIDGE_MRP
Thread-Topic: [PATCH net-next v4 1/8] switchdev: mrp: Remove CONFIG_BRIDGE_MRP
Thread-Index: AQHXBKy9P6LibhcjJUWUQjUelVRtP6pcJVuA
Date:   Wed, 17 Feb 2021 10:26:30 +0000
Message-ID: <20210217102629.w2ytzvxyokoxt5yj@skbuf>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
 <20210216214205.32385-2-horatiu.vultur@microchip.com>
In-Reply-To: <20210216214205.32385-2-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2a28c594-1b88-48ae-c5e0-08d8d32e7da1
x-ms-traffictypediagnostic: VI1PR04MB7119:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB7119E10796CCED829C884990E0869@VI1PR04MB7119.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:546;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rdka9+VnAr9IU2SFSTEx/C8fI89umjIxFRclI0W7QhAplRM06fBLHyfgxw689lC6hcfBfKmIqq14b2NRyaO2FENACrfV8fNXeQazH3fvT+LhIY35oX59w6zvfCm9yYdlWksjv5AAA4eZ0HafTe2Y88OgiHNrK9WA74jegRgBZv0tFPHlWi0aw2vJ0HKviC5feM9zMmglmmaBVA56Xc6OvaSWg2Wybxmzr99pri3bVSFGXOPNDK016L0GaLhYDb4xLVsn8+dyIps1spxOvxLypadud5EpH7eEcwrNQr3WFwTL5Il78liDIQdJLtXzUiMIlOUKQaXeTD8lWFBHIcp8eRfZy5IffyYNGByHG8HtlH9UdaW4TmhfPWJ448vPWXRhn1bQBwbr0mPcZaTa4xZE7tiU5ucsOPWT3TOz8rr4Chcr7DoQEmYxqFtpXCClRo5LiGozoKd9O8L/X6eHiFhdDPIwk0/JEJyyZ29KGPz4YX6axyXh5ctZcfCuQDxgf42XfkdtaEs5nptpiTmu41ZhQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(376002)(39860400002)(136003)(396003)(366004)(66446008)(2906002)(4326008)(54906003)(6506007)(316002)(66476007)(8676002)(86362001)(6916009)(71200400001)(76116006)(7416002)(6486002)(558084003)(186003)(8936002)(478600001)(26005)(33716001)(5660300002)(66556008)(9686003)(64756008)(1076003)(91956017)(66946007)(6512007)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HzCozs7somdPFfzQxckEa05emnDZ8pwA00ynSDgPUE9pxRpe3awuHwgtgo/L?=
 =?us-ascii?Q?lLLBbRP+dzsxBIufCqg5Rz1OZENayQqZz4NMm7sZeXcbYaj98/d6bWIHrp8u?=
 =?us-ascii?Q?/PVugUjPWSDBCc9nR7jK3BHuS1BrfjVoZB0Gk9wUHxi11w10LDCgN2Fo192K?=
 =?us-ascii?Q?BfIrhTebzhZ1DKxgK2hCcUXRqqyFIUeE1SO1rlKR4psY5S/YNUg64Cyz45x1?=
 =?us-ascii?Q?uczp66OZbgRRjYrTcYUZpiqVwcIkF8MHJhV2WqerPeE39BhEdRc9stKjx5Kp?=
 =?us-ascii?Q?CUTspgrPpR32OMHyB99k3s/ys2oVUHwKWZRemVF+T9s1sMYwJi0BWlUD72Te?=
 =?us-ascii?Q?OTgL4308O0LhT+eR54fSi3CawtDhU5/pHDrfhl6+/pc8BsjUzBTzomnM4cBi?=
 =?us-ascii?Q?ZsuodMXNON/sm4jwVo39wnvP0qAh9U8raQVF1Zti7v/WAVa4mNDvpAmikBLC?=
 =?us-ascii?Q?e7yv/8uqckTxBA2QTiz4IwjL+wvkW55JL32WFJ5GxEzT4pzswBiSeY/j7wF9?=
 =?us-ascii?Q?8NZdkMrOH/hOGexz4RdmzDVUEWzHym3jfAJ/R0v8lzKpwlu1FAsmJWPWuzdR?=
 =?us-ascii?Q?ZG5edpdxH5g+gAaJH7XdcJxUoQnijqdDqua1dHK+VnyUgrNdZO0Y1NLYpeB+?=
 =?us-ascii?Q?tu9E+un5che65Ltdrvu/Y3+OJHibVSX9VPgCT5Kan7UG1d0dk/31UWX2C/w/?=
 =?us-ascii?Q?gMitVUiTntlyaXXjs8cOKF3N4CJeU3hDv5Yd7QusK2j01Hl2Uejm9AEDctou?=
 =?us-ascii?Q?ZI942dhI+hFMdjCfLKwSstqfGzy/jijvYQ5Wy6FCuFffyXiOqQF+xbZnr+lE?=
 =?us-ascii?Q?i4Ph3ApenGQMcwFL0Zpw6Xcs7++5gkpt+LP9tCgT7ms1dRAZYUqFnngsPZX1?=
 =?us-ascii?Q?iJWelB8bQL9g6zjhu3ikw3r7fsW4E/RQkvkNrRLnHwRIfEt5PRfHRYiLeYuU?=
 =?us-ascii?Q?cK2UcJisohBzVnR9zjUQCOW24MCd1RsKX5AqHDtvpxha84ifu5Q7MSFODsHX?=
 =?us-ascii?Q?Y9sNZw3CvSn/rqsN7DfaavoYG38vINevbROtoZZyrXQZO1dBcMcFOWkO+BrN?=
 =?us-ascii?Q?82d4nGhsF2aRjHOlD4fJ7VvE/CB1A4re3OEQW0L17+LyK/xEhAdc6AtbJavz?=
 =?us-ascii?Q?wYPo2Yp87DElPvxtMS7OMobPYwui2mq1qpxh765/h0DQ07lLzX6i8IRD348C?=
 =?us-ascii?Q?Xa8SfZQSDXFMLBLFT+Ad+4jNrRDjknb23rURoS2CQzUY1ATMgC1dUGtaS31B?=
 =?us-ascii?Q?cxJIcqdJKsuqmRidHLlLyjyiIuhyUPqx2luoabb6xp1m+RWZ8xu7OC0lALIi?=
 =?us-ascii?Q?F1yiPRmfLXcaYqfHCDdpx5SM?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9ED876A605665042B5FFD45425DB8DFC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a28c594-1b88-48ae-c5e0-08d8d32e7da1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 10:26:30.1196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AgxaAXaYZvoY+Dulw4IUtLaHH5cPGWMmChp68ISP8Wg0344E9L/DuGiqeyapKlgPZ2IXmmh/5xs+vI+V/UMZ8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 10:41:58PM +0100, Horatiu Vultur wrote:
> Remove #IS_ENABLED(CONFIG_BRIDGE_MRP) from switchdev.h. This will
> simplify the code implements MRP callbacks and will be similar with the
> vlan filtering.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>=
