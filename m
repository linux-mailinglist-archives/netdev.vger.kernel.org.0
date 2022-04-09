Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE41E4FA764
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 13:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239431AbiDIL5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 07:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiDIL5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 07:57:42 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80073.outbound.protection.outlook.com [40.107.8.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C0DFDE18
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 04:55:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZepxyKCtzYhtW60hbOxOz9qS2iXXKdnSu4/UMcF14Box/RhzuIvIDeqSJ6EPSZ1ZPm0krxMZ2cLLtezv/2WL6e+7tlijLXSBKfSfAi8o7DMhcfSGxHm7g/2QLLsqZsIIGnOaw4LlLN2RHyUVsNncU7MroyaB8EJUbKC9rN41fso5uw2AEf+VvUu3YloCon4Y2Fci6Dqf1NlLsRJFYyeaFy7eIXlzP7kI0afChX95AG0M2AkXEvw5Hhgndcp4oBLMuYlbLxBaR0ms9e9ioOpQKjIAaQVJ4U0ouch8l4mIlgBCmu9ITOvVylfetQZmfZZPlZiEmoeEvunqU5/dYCXwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5irmhbEx/IK3PvmVX1jNMc/s44jZzmpAP4QOBuRKJg=;
 b=Oyrn8W9M8/7Y9CwyugFl9uIVmUTrWtfHcXtG5XRUj820BvYtqnlicW+YOICCbAK4E+PZjkEjGXsvUygz+ND4SoaPfXM5QaW1tEqYblBksdmAwV1wDySVp1flVdH620qmX4xba/PIYbhETxf8/lhV/lABL89eZRujsfwJu6n7R1gFKTZUzL66JSeeX4OmcZS7B3H/jqbnfItwZySvD6zpYfRpHpN9FzNKkkevzUfiFNtNQcFjpL1I09e9aV/xFEoo07P0F5fpk4s36uYfOD7PjuifRtVBpuVIZ4dTWTqTZiTMW+g4Bgr02HiXqUhX4l3x+9tape3AMq7Zm+D/KHesDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5irmhbEx/IK3PvmVX1jNMc/s44jZzmpAP4QOBuRKJg=;
 b=iWuM2FZtzBTwJ3YnxTQ2CrL/mg+YwtN9CNVPLePfpg/C4qta8EHFrISuUTsxVRhkxUM+hHri5ES5UFzAykUW1lvruZD6RbfAa9h5WDTSNYaF+ARdtd0kAlfAn6YOnBxiXNOH61P1oq+FB7Uwy7kOKcVWBjIlb6fKx9gQukusXZo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5552.eurprd04.prod.outlook.com (2603:10a6:803:cc::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.27; Sat, 9 Apr
 2022 11:55:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Sat, 9 Apr 2022
 11:55:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH v0 RFC RFT net-next 4/5] net: dsa: sja1105: Convert to
 mdiobus_c45_read
Thread-Topic: [PATCH v0 RFC RFT net-next 4/5] net: dsa: sja1105: Convert to
 mdiobus_c45_read
Thread-Index: AQHYStHvK77DzdjuA0uVb4ZqYU5+d6zne8iA
Date:   Sat, 9 Apr 2022 11:55:32 +0000
Message-ID: <20220409115531.ff2trf4jikrb37qn@skbuf>
References: <20220407225023.3510609-1-andrew@lunn.ch>
 <20220407225023.3510609-5-andrew@lunn.ch>
In-Reply-To: <20220407225023.3510609-5-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7d8b92c-ba10-45be-411a-08da1a1fd99a
x-ms-traffictypediagnostic: VI1PR04MB5552:EE_
x-microsoft-antispam-prvs: <VI1PR04MB555234B785CD3A82498A08EEE0E89@VI1PR04MB5552.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xWVHC88uxGQkIEdNbOn0GEV2PHqc8ru3B1+GUkKacmYLsXvbX0ka3QAuM9PW2pBGkdld8mEmudrEd8Pi8Q4k/D71hTrbbzTCJJjqngtEcQDWHaBlYH7OLLiRttS+RNj1JRpzKmUO0ZFpr9SSoeIdjzntiaBluzPBiCkWlIIDy6lppfOm3NgVyyRuHi1UI82GzHof36o10VbbXlKuXQj4Hz9uqPcanD93WJNtm5GVSm5m4DHPWzT7JcAO7dl79Ycra6IWxJUwYlmS5aIO7ZyEPzDMjhrCFRNzzvj9eifnppG1Z1UCLXHuC22LFmUb7KktKYJlrsAMu5d6EQsBXOMmyVAUYZ0kVfdq4UDD3theuIxx0E4GsxQ0UzpQBeGA0c1cRNm3lAlJLwjdombtRqBJH2qP9uaw1ff9dqFUVUyJ8o2L3RcEycAeHIvBJWvH2L9zamR3MJQJgSqdof+UY5avNytjC026aO4OTTx0ZsYOIltw4LSk7F4PvKKw3ba9S1P7DnUedf6TgQ+Mo1aEJjVBPc+tzC+YR1KXnp7leNzUsHHw0A/fE4iAzmKALG1Vg5CzYX18WmEljfw+CJMeVRH1VI2gbkMtJPawfmLl0YpTScwruA2Ca88BH1w69ovtBHWZj/AxyvdJuR5MefJsMw65yptAxxn5nVCM9XqQzxwkRojUnRb/gCRuRse1J3MT458jGCm+NLL4P9hUKqaXloc6nQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(26005)(122000001)(38100700002)(186003)(8676002)(4326008)(316002)(54906003)(8936002)(6916009)(71200400001)(33716001)(66476007)(5660300002)(86362001)(66946007)(66556008)(66446008)(6486002)(76116006)(44832011)(64756008)(4744005)(2906002)(38070700005)(6506007)(1076003)(9686003)(6512007)(508600001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?W/eGsR7m7XPdL+F7e3+0/4hF6k81lMw6x7Wd0Nb2OK3VHE3uAhAIOj+LF2YB?=
 =?us-ascii?Q?G1HXvKDbu8w5TWO3fabkZ8xaKn8RdRVV6LyTK6rF/dNPj4nUjbltTHXd3qir?=
 =?us-ascii?Q?IeglJKIK1g4T06egc8PXygBW/WA1pdBfq+46HGopaZOaDCwX7jnXx3mucJec?=
 =?us-ascii?Q?drnRX1ajXyHcl/Hu3xWOazFA2CajuWUM7TpztbNDjvG0DM32WqpiF9JIvR3o?=
 =?us-ascii?Q?2DHIfhCORjgbW/itcv68WGkszq3Nh+AXTSaAeQ0mbpfosrI0d18BV7+Lt95N?=
 =?us-ascii?Q?1czt7tIl64r3QN7Jg2Su93V2dS/Fh3gUUOCHLZ8d2fJXvRpm/kFJhahUSesZ?=
 =?us-ascii?Q?Y8ipDsF9vaZTiETrFH+ENu+JcCs6/y6efL7ZpRU/ZQHlUW9Z6VZDheFzJ/Uy?=
 =?us-ascii?Q?gtKTePLAXwmQJ2UFFthVteFFijD6oduFyPo2FyYNEwH8wtqjrYxeMfbXqLiW?=
 =?us-ascii?Q?4dArg6XVOXWkVNl14iVdqhapyii5L5LCGh94RG83PJpxPXbMeXdJlMPe1rB7?=
 =?us-ascii?Q?NpgCWcG4Um7kXYtJhIltkQJAOJRQFVqlH/rQxK6alhOEDPYsyrY3+SnW06L7?=
 =?us-ascii?Q?wYaXcvqTsh5+knI+HRhiHLpMzjIByO3V8kr1bkjmjqwn/PrzbDJkoPJBWTkV?=
 =?us-ascii?Q?/qRxc+3u+IfcBqan4aRPUDvKr8aPXi77rUrD/ZqzuT2IPW+6TH54Okib0ntQ?=
 =?us-ascii?Q?EA4P7RlV/Bo0XFzrZaYILSkZcZ3v9BwR1wU1BH2n2SIsoQ+3zFjCD1ZYenlR?=
 =?us-ascii?Q?JAtZuCyEooU4rWL28CZIOM10oE7TpuQnzEdrvKIFnWpt92hDl6o35dMqPgCv?=
 =?us-ascii?Q?seIWbAMWKlNE++6KwkTXVq7pCSf6S+TxbEpf0lDR44z/YbZjyeig+wk6i+FG?=
 =?us-ascii?Q?5VIPIvg8X1awOM4K9UMxaADQTZ5AyXgvKkbUHX+/hZRvEVH5gSL93YDPopSY?=
 =?us-ascii?Q?pioCkwEOM9P6HuCAj6AeBJXKJnGcEMviotY7FOC2o/9XjWNVUGm6MOGXqOi6?=
 =?us-ascii?Q?d+DQEXiBj0kPxCH+nKeEzutRcsflPoY5L3jyoGFIz74sHwH9qo0BTQG657yF?=
 =?us-ascii?Q?sdbZNTDQxW3/yryUBPyOZMPNkIaMenA0Z5CZNR29hLpG0Q50YXn3geEmcZ0o?=
 =?us-ascii?Q?tAvZNoTI/hA6kwJWlGZnz5eqq3NSrz24PA/K3sQ+w2ib+IjqDDVF/0UodMSa?=
 =?us-ascii?Q?3t2nzraJRAdr4UF3gUBu+oqQTQQxw3HyFInHOjC92aH3mo5Jw2LdLshuikEm?=
 =?us-ascii?Q?zri814f8Do4Ywy4othGAeEgVuv0m290Ox0RB687oKrU9vXjg7NdlzRvXbSaz?=
 =?us-ascii?Q?9y0RFlEhYKGyTobgzMXrbK6JfcTRp69qwpDYINKe+S/AG+YfCo96+1YGn3kI?=
 =?us-ascii?Q?fs+ig4bcMgsFo4rfiL11wSeDNzb9h4kDNg2yNqInOFbfVh+yfRDpERkUX899?=
 =?us-ascii?Q?/hIArIHk0FnxWURa2xHEGV9P7wFMPlY0oiteuTHrhPTLsTigd+klh2k7Zxf1?=
 =?us-ascii?Q?31lRtNYxCZftO1D2/jnJx/+CcBTAJjI4mzzndL1pAs/OfrIKOdXBmOnhJN6t?=
 =?us-ascii?Q?B/rz1vYk9q8l+5ytTyawjl0NpAFqLooP53CQRya6On8IH41CZLhimMIUXUQC?=
 =?us-ascii?Q?NP2p9JXhKJMCZx4WzbtQrtH1y/qHTrmn0M61UvZtTUMQ3Kv1rpupZQc9htCM?=
 =?us-ascii?Q?+ORuP9phPC+b1PE1nTcJZzzY1u3XFdo42qb5E+999dHSdZiQVSjUajwfsuhf?=
 =?us-ascii?Q?p96h3ZqfirdBICgHTT/DEAbvCpmll3U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <145BAC11F5B8D04CB2C04CE4E653EF35@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d8b92c-ba10-45be-411a-08da1a1fd99a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2022 11:55:32.3107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ph9bqu8XhoNl6QLUrbdXAk7TDIT7fQNdkcIp79uURMzmKnITzuN4hKok1tnTJFjJ0D6MABGCGIxUAQDArlW9Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5552
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 12:50:22AM +0200, Andrew Lunn wrote:
> Stop using the helpers to construct a special phy address which
> indicates C45. Instead use the C45 accessors, which will call the
> busses C45 specific read/write API.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
