Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F6C5FA1FC
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 18:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiJJQbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 12:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiJJQa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 12:30:59 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60081.outbound.protection.outlook.com [40.107.6.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A280D631C6
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 09:30:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TfTZBD2T0sdL2s4tzeT2j/z1YKxVeffuivgPs9OOUzpS3/ayzE34bcFFBN6kRzvKTYHbdfU+uqUUE++1fDN5hy0nM7Y8l4PwpIDcL++GUCibHfanQXHbmw51/ZfxKvf1TYrGnRLomCPv0C6J/RTRLOV37rAa0gDPs/hMtfan6gkcK6xC+Bs4kt9vceGMKY9eWcO25DfegyOzA4gxtPJcftipazrcQspgApnSinzm/EIu/kkEAZ3DcSzfofPg8ZBE7KgS6LHnpkYWEM7car0jboWnjB4WpfZZtx71R7dYcwhmrIHuQwy3C9UXiBfYxRfXhyghqWHQQB/y6WGl5f43QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9RiJZjuqWocM+bbTUTWbhxoUQEaFMAP1v7MPkB/cH0Y=;
 b=ix4ZdVFHaSRev2X+9M3HVzADskBpO1rkM6snRmq7Hy0pjakb+4lkNN1pa47+UjOvMpJ0+g7gjv4tnoqxptGwM/SAyvX+1xJ0iG88dElok6VVsyVljZUeL/Gj9PB84YGjszr37BcgYnDNt72f1wwjydszxaBaJ+hVm2NexBfPKJ8DEVgMK4L3uZ0hdxbGPfTHilrESveOt9pMurKtujbgB6AMNzIpr+W8nIpzkXvMwbDmim4C2CL5fUiPZT8XInPRqIv1mgINhM7SPRL9WaQ2W2ADyrXluPoB7sumnj33NYTIW+KzCFyw/ekn232q3yhVKuHGBEpM30/msf3dXF5zcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RiJZjuqWocM+bbTUTWbhxoUQEaFMAP1v7MPkB/cH0Y=;
 b=FAgFvrqEpUqS+ScIq/8aDWskDFvTcaug2egCinrtf35YC7VyS2QzQN30CwPKfnMbQo7rv8lAOcZco8cVMqJEaY3PEJoixtPNrkn12hcxP8Alq8bve7erpkbuZIBRFd7ujuB4mK/vpUX7suQnKgWTDdi/VcdzK/tP2EzebjEK1FI=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS8PR04MB7544.eurprd04.prod.outlook.com (2603:10a6:20b:23f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.38; Mon, 10 Oct
 2022 16:30:56 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563%5]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 16:30:56 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v3 1/1] net: phylink: add phylink_set_mac_pm()
 helper
Thread-Topic: [EXT] Re: [PATCH v3 1/1] net: phylink: add phylink_set_mac_pm()
 helper
Thread-Index: AQHY2mN8NiUdjFp6H0SMw6HHEkZ4lq4EGh0AgAOcBDCAAA1tAIAACz0AgAAFMQCAAAG4AA==
Date:   Mon, 10 Oct 2022 16:30:56 +0000
Message-ID: <PAXPR04MB9185FED6D39E6B008E4CFA4C89209@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221007154246.838404-1-shenwei.wang@nxp.com>
 <Y0EmbNyFhT/HsBMh@shell.armlinux.org.uk>
 <PAXPR04MB9185302A6164DC02812B471589209@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <Y0Q4zqhEjzIU2dIX@shell.armlinux.org.uk>
 <PAXPR04MB9185313B299F8788906E0EE789209@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <Y0RGlr6hdBIE4Gwg@shell.armlinux.org.uk>
In-Reply-To: <Y0RGlr6hdBIE4Gwg@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AS8PR04MB7544:EE_
x-ms-office365-filtering-correlation-id: 4b20eb64-d549-41f7-acf2-08daaadccecf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Zj1H0T/PmIMzy1j7Hvcm6CdRBxHnUfJaxMMCsy661YBXPgE7Ca0P3/m3cmYKPCgYXTJ1F8n6CmJ+90sPZY4VHdXijRILYaOyi/JbF7jKGXOp2fyGy9hj5/ukuC49W1ihM8aNkQkVx7yxRa/NwOwDyPyTFBIsNNxRSkLqhznwTfaKglRZJiiSaFdyquBz6f+ixxF1lQGs3sBXgQcMWUHDN4U25JbLNrAajnonP9CAsttDuRQCT07j30NcweZ2acQVaw1TLhzRcWJrD3VnvmaNM90ro2L5tx6LZXBdXOam0WziGEnKKWD4jx8Qs7epggg4muBBu5XD5HK8qPFGwR5X6gVL6rhnwgO3hzjf2uLi26QWLCiHxkdLTz9BzA7Dzf20P5eI2vPR/7C54zbsbX7wV5n2rqg77wLZZ1/iAvmP0JMUQtcYqroHhTyGZ8IV2aFS6wPCSUFAZN3VWHIrX6Vu1s4Y1B2YeQZSMCE4QQNLegtvX1SAbogVf6SwG8afgemmiO6UuJs6pNakspIQPxssL6AH+JnCXcIoD1Jx6j1RZbZbbJ2/F6a6oY+vuqbRANQjEiaFUQaPQSfYcAl2jed6AgVqWRnvw2yyBKMNQ7yr2943mp6ZqmzuUgAS0FPKoAXddAkl9CwAtXcdGDpf6LeQAHu3Ytnn/UYG2d5qMnqz+iW9uxZHjuI55rqOwKulz798iMWM95oJ9R1xCLn7FpXFYjmamLvuYMYLRgdxFoWy9rczfYhu9J5G+/v4VJe82vph/IL6mkSceokK576G6RjJB7+JxeyIxuKdotU13+yEpQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(451199015)(83380400001)(54906003)(6916009)(76116006)(8936002)(33656002)(52536014)(44832011)(38070700005)(38100700002)(66476007)(8676002)(53546011)(5660300002)(64756008)(66446008)(2906002)(122000001)(66556008)(4326008)(41300700001)(55236004)(86362001)(66946007)(55016003)(316002)(7696005)(966005)(26005)(45080400002)(9686003)(478600001)(186003)(6506007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jlLwLFwRbZRFDWWlKAdyZXs/ucZtRqVUY7Vt+3eZ7ChPlLr7Z717lDtMiHwl?=
 =?us-ascii?Q?5T9FxVvgJrUx9d100QJPCoJZD/tQHbMjGACM5leB6KAoThFWHS/AVJWtdY/a?=
 =?us-ascii?Q?yn9oVr4QTMt5fhWBEYuHXg0KsFSRwtm+vqdjccDz9cgzrTafz9z8j3ZC7MIU?=
 =?us-ascii?Q?ks+FzQhXD4rXHnvr4XlwTKhWs+xGXfTtHtQCOeNOHEJvNcrfvBtcZAkx9XGG?=
 =?us-ascii?Q?DfSbfENLiehaSdzOQWKRmzgvtC9hXuraHLwRQtxcT4uz1BxfWlziM80Hdlaa?=
 =?us-ascii?Q?f5YKhx8+yO2Zv8RlP6YGh1qfAJUJWXS+NWhmXAPXkjPQJf9diXOwd0BxS40t?=
 =?us-ascii?Q?Ha76IvENWtv4+tzaImHBAyoS6LIdCGtxOLVWPaxHlh3zxNFl8kE/S7Xj5Job?=
 =?us-ascii?Q?nC9uP/vHeqpLhKyAUtnlfAnmNziD0+flehnwCBDf3rSl8BR3RnITd83HHA5m?=
 =?us-ascii?Q?z9cM94BnI8SB6ORLENhzTHjf6lpYCRHUFa2bjDSmY8H3YsOVt4nZKK5YZQkZ?=
 =?us-ascii?Q?so0FNPOCOnym/pCDF2ua2qrxmBIpL41sBqJqbJPkPOzX+DKx0TG5c8s/1Sk9?=
 =?us-ascii?Q?GjtHBfQsfDdDOFIQlk11OAx16J5A5scVo0Wmobt+85UmBOk6FKm55SBEdM1v?=
 =?us-ascii?Q?4oO5jWPu8JFEmrn2GyS6xhA5BZQY+49Z9Th4W7ylogZ0PZ/uTf9JiHcWgAXA?=
 =?us-ascii?Q?y9uXE2Hx08mEBS3XD69m3QzPNXFO1W3fiUBMIhb2UryK5O3njttDahM9Lq9A?=
 =?us-ascii?Q?+9OBAJQvJP1iiaggaxLm9CiFd7SqpkIzRdwBTaJNxFg4jVJo2ldcXsCvHHSA?=
 =?us-ascii?Q?fGXnaabiLctNY3MJHEyuHmrXFji64Fx0zWogNO+36zqyiL3Wdc+t4KywUU9N?=
 =?us-ascii?Q?Vj1U01yfVTtlicpQS2NHTW9yKw/1qZz8kxSoaVzkmHGCJjzeXnJv02i7Dutc?=
 =?us-ascii?Q?uE7aQ4G4Jioedmj7Ci5rntx5kyNi/chCYcPpmNQY0M2MHujZEaDTW1RjqhII?=
 =?us-ascii?Q?6t4VSzHO2Bm18Bb1UEAet0bRLqzgl4b6FEpfoKdJj3u9Amblnjln7l4zc//C?=
 =?us-ascii?Q?buba1gVU8SnMJM+7KudmApF1x+jMT03Wn9yc7/0yMYYXZBx37YjfdOCH4t+I?=
 =?us-ascii?Q?BxUjNdSGZ3Vk4EYJA17iUctVQSLM/Q95kYeGnaB8Kba91G5SBGMJBv5GCa8H?=
 =?us-ascii?Q?UIB6q8HFFwYLwMr8xa0CncgmCNvy8LJXQ4GAdfoLZsV17DS9psKpmeArF+6Y?=
 =?us-ascii?Q?1ufq6p6NfrYWSs9BM8XM2HtBZCDFgXvn1UrzurVEQa5LdIo+Tnb1OKvDryAB?=
 =?us-ascii?Q?bBUcxsv17L7hYZtxJjRN4Cmuq4eaCfNL1BuLh2cDHJTpCSnbnGvE9U47S/Gq?=
 =?us-ascii?Q?R9IOdjZ7mVW4xrHijlgJzs/FjzCzLZJGOtCP/t8GFyqPPHw6XQG5GfDzXGAU?=
 =?us-ascii?Q?KZz8UmujzpbXdBvJfeWQyFp1/dsLvYrM+GlGv+NrgJUOK497Fk1S0t8pT9eY?=
 =?us-ascii?Q?RG6AWXRvWyDQRLnomcmtr9lG/F8KqG579yj8BuWZ9+QWve5kHNN9dghXOzTW?=
 =?us-ascii?Q?a7/BdQEeMIukYy3JiJSt+ZeqvhHOB81BHRD99Upo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b20eb64-d549-41f7-acf2-08daaadccecf
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 16:30:56.4965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AC0PjoQzJjUGLeJFEeKxD6ov4Dkz+AK9bnCUAoR63OIrpRXQSBfzaHy9ju7IXRWcmfJywEr/UIlMeuquxlPJXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7544
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Monday, October 10, 2022 11:22 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit <hkallweit1@gmail.com>;
> David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; netdev@vger.kernel.org; imx@lists.linux.dev
> Subject: Re: [EXT] Re: [PATCH v3 1/1] net: phylink: add phylink_set_mac_p=
m()
> helper
>=20
> Caution: EXT Email
>=20
> On Mon, Oct 10, 2022 at 04:11:36PM +0000, Shenwei Wang wrote:
> >
> >
> > > -----Original Message-----
> > > From: Russell King <linux@armlinux.org.uk>
> > > Sent: Monday, October 10, 2022 10:23 AM
> > > To: Shenwei Wang <shenwei.wang@nxp.com>
> > > Cc: Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit
> > > <hkallweit1@gmail.com>; David S. Miller <davem@davemloft.net>; Eric
> > > Dumazet
> > > > > with an accessible PHY, what should happen if the system goes
> > > > > into a low
> > > power state?
> > > > >
> > > >
> > > > In theory, the SFP should be covered by this patch too. Since the
> > > > resume flow is Controlled by the value of phydev->mac_managed_pm,
> > > > it should work in the same way after the phydev is linked to the SF=
P phy
> instance.
> > >
> > > It won't, because the MAC doesn't know when it needs to call your new
> function.
> > >
> > > Given this, I think a different approach is needed here:
> > >
> > > 1) require a MAC to call this function after phylink_create() and rec=
ord
> > >    the configuration in struct phylink, or put a configuration boolea=
n in
> > >    the phylink_config structure (probably better).
> > >
> >
> > I prefer to use the function call because it is simple to implement and=
 is easy to
> use.
>=20
>         blah->phylink_config.mac_managed_pm =3D true;
>=20
> in the appropriate drivers before they call phylink_create() would be dif=
ficult to
> use?
>=20
> Given that we use this method to configure the MAC speeds and phy interfa=
ce
> modes already, I'm not sure why we'd want some other approach for this.
>=20

Okay. Let's go in the config direction.

Regards,
Shenwei

> --
> RMK's Patch system:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.a=
r
> mlinux.org.uk%2Fdeveloper%2Fpatches%2F&amp;data=3D05%7C01%7Cshenwei.
> wang%40nxp.com%7C82e5e5068b23483f015008daaadb86de%7C686ea1d3bc2
> b4c6fa92cd99c5c301635%7C0%7C0%7C638010157080134477%7CUnknown%7
> CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJ
> XVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DrpoL9UwtjVEQp2lWkm%2FVj
> kp99Romx%2BARfj%2FFmdpsO%2BY%3D&amp;reserved=3D0
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
