Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89EE65F6EF4
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 22:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiJFUYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 16:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiJFUYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 16:24:22 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60055.outbound.protection.outlook.com [40.107.6.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28F9BB04C
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 13:24:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=causQy0xOyR5xPYyl+EK2KWr0uasKEHeQ1foQWxgz4g1PY3ehhwj1B7wpbMDBg1n60fl2WuGTW8FaAKyxiObGNurPu2IMJE3kkTK4QCvnFOzp7SY7zWwa+9EwhCzp4wgGmchbXVaTqYUBQGtCLi8E3+Is74Z/zJdqBYdrojoXsCKZAmZSIL78xSQGOMdcHlSaOZXVPkzrVn/0vkGo7gB5/PgalM+0lfYz9YAuq/TrgBecPD0Mv+t4jPUVCu2xd1Qo+mAKCbiTRxpPw7O02M87neHTG5byTfVX+zIL3gTbsK3QhJYMA5CbC1bVwU9uL8PlUWXsEpfc25ZB0Yh+9y+kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8PAkexK+ZcA/oqOzcF1Ncz8NVc+C40bsF0cP+gTGnPk=;
 b=I9/Eo6VuZp0FAah5AV5six0dtSG3mfvABAcLf1WZ4m9iqEcovt4vOxKVdQyWHFqw8bS0JHkLtNTJonIUc3YJ783Q8gxLJo4uJRRZFulGX/XsO9nE7LSRxXeMIKu3jfu17bWqHjs+1vcpEuySydN3BnYT0NYVslabIhNHKXTq5YgXspZu3kQ9aJwPlJM6gzJ28o/BvEsqMB08Hpyp7K5nr62udzWkv7z97bu1ycH6taGeRFVKwNPqT2sq5YFqKqExE36sVVV6942G6RzGQ8ksUTFlKJOZZlzpROixaFH36YpexC/xn3itcyap0DAm5jQwZvOp/9zt6tb/pAjJ6aFiGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8PAkexK+ZcA/oqOzcF1Ncz8NVc+C40bsF0cP+gTGnPk=;
 b=QY4ERxOliqmDESH7Y3ZsdZKHR68wy0M3S4KR9E/edUo11B1pAWJqSjrBfh/UA/7aSBzdmpuAm6Xfv6phOcqLNNRGogRHWVGF7XHk6iv6VIBK6ZbYu13xMNVkpp1e/PXwVIaYZci/+zz3Ec4MecjfIiKtLQ0AQM98Er6yGrKtOuI=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PAXPR04MB8701.eurprd04.prod.outlook.com (2603:10a6:102:21c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.36; Thu, 6 Oct
 2022 20:24:09 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::fdea:3753:5715:9758]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::fdea:3753:5715:9758%7]) with mapi id 15.20.5676.033; Thu, 6 Oct 2022
 20:24:09 +0000
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
Subject: RE: [EXT] Re: [PATCH 1/1] net: phylink: add phylink_set_mac_pm()
 helper
Thread-Topic: [EXT] Re: [PATCH 1/1] net: phylink: add phylink_set_mac_pm()
 helper
Thread-Index: AQHY2aV7z03oTM08YkiJP0ja6Vcjkq4BvyAAgAAQecA=
Date:   Thu, 6 Oct 2022 20:24:09 +0000
Message-ID: <PAXPR04MB9185147B369F93218F2C1CAF895C9@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221006170237.784639-1-shenwei.wang@nxp.com>
 <Yz8rWoYlF8sjbkBz@shell.armlinux.org.uk>
In-Reply-To: <Yz8rWoYlF8sjbkBz@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|PAXPR04MB8701:EE_
x-ms-office365-filtering-correlation-id: 428e7c6c-d9a2-44fd-dcb6-08daa7d8b99a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VUlTf5s0P1xA2ZXSwnQbYscTmUUGSY3KRcZYntGZftGgiNDz5Jm5rWeh3L4MbmoqRIYNG0jfGbkRhpXsLMOnGhHNeHjxlWP1ne5eU9LVouzD8ZYaCRLv/hysbQ0Mz03u5mD8z/TTvzdA+/5JTP2znpKRiQCoJBwUj9w8YcjABMox1XTPWKK20rlBXwfeJ5B1D+v3YfeiouQI6seyU+xIgdRVxGSsvxQfohvEKccba19scMFiXA1ZqxZqKkkjcFiPlj1omMxJoZdiRVQxtZ9qLdFsqjYzqbfvpwOXbH+719AiNNim+vkDnvu0N70jj/0ibvbLXiqLBsVZ8Fp0HSyGyv1URd9Ctd9WVKG+XoHW1SlNNN87Lq0G7zrUZ4WqDyq1b6iLFwqTA5oQ/ufh1ej3YU2KtaJGB+pSpqRP4fTjodutsb7rA64UIKvoy2JZCoBjeUgUcVy5j4aL02f7VMLXEXMvNyRtLMc2+GtcNzacs+rSDgvInMPAtXNDNMLBs74jNGBaK4885vx+fw+4xpn6jVJ5sHyTJjo6zLNOmcw2tmjwapvnShkd2j9zTT04XkBgS61nWPWnYPvvezFW9yCg5X3rvLLYAIkzoZ7hbgxvlYTybuXmZdJpYxWCU2+DRQ4AsT5sU4iALwdiZQzPYiVZJ9KGUDLD2N/SDLlv8Wrfhsz8AbsuvULkRYaTWv8FI78zOKzjOhSd2Z6ISdCa/k/b05SWT4RxLNRUevi/mLY0j/80Y/vAquW0uo5ZKQzr3pURtL2h5MuSrAcYO5ePCcdyXZ2GfE3RR/dgAOKzCnSXIcw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(451199015)(54906003)(6916009)(316002)(45080400002)(478600001)(8936002)(71200400001)(5660300002)(52536014)(2906002)(44832011)(76116006)(66556008)(66446008)(64756008)(8676002)(66946007)(41300700001)(38100700002)(966005)(9686003)(122000001)(26005)(83380400001)(38070700005)(6506007)(186003)(7696005)(55236004)(53546011)(55016003)(86362001)(4326008)(66476007)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8KjDDHL4xMwY91Q088HlWgRWlu4ll/E5pt2SXXJqzzyHj47y8yOvexbSRDmH?=
 =?us-ascii?Q?z38k2uqeqwYnDkxk7Iesv82QSUXpXO76r9kVCO01cP3ziSXg12CRdvZR9XKG?=
 =?us-ascii?Q?fQcX+DXaqXZ2AIYuyZWUN5Gb1aW9Oo5GSAJkywaecCYVpUvYXKxsUdxrjgLq?=
 =?us-ascii?Q?xA8Tmsf6aivKEO/vt34VIvzAoy0ylnKoCPEp4x8i7RUvjJwfZT5+7A/nnxz5?=
 =?us-ascii?Q?3vMNBMlAlesnmrdPCwV/9wSus3ROHUDyF9wX4drMKpfWj7u2vWMYksnq8wGx?=
 =?us-ascii?Q?WKPQpq84RZ7fbJo9c4FyTApTqmlEhwstPt8HevWPln3T/9CcQT1wdkD0gRyn?=
 =?us-ascii?Q?T1gkMR5AW0gfulIgioZwxANypyHYKDNY5NT1XmKVsx2rWKyCGjbg98f9Xd8d?=
 =?us-ascii?Q?TNXFbMvUmeYIH27Igr855jOSxP3W6PABYcgYoVXxCjQOTKGaiAaNmnBwWjDT?=
 =?us-ascii?Q?z9R2B4JyYv7WOWd6iMn8+TSNTSVoIassFfOqlsjLP4fY3d/Je0N1en47J+dw?=
 =?us-ascii?Q?wFOb9VLi6iv69GpbY4XTb3U0CcLPLBgnzioZtXcMuJbJ6UoboqD1eV25JEXm?=
 =?us-ascii?Q?rI9NnQkm1zYeQuoMrDVGR/DeH8WGL/yPWGtX94POKECPzBqs5BcgapZ7Xs3K?=
 =?us-ascii?Q?LmqklWTKct4J6A+uubFS1bvUsZly6ElwyZnKjf9e4bOMAk+83oyXhdHdRVQu?=
 =?us-ascii?Q?WXmFJpd/ydZdMR2NPWOPRCWNMVUEHPeU7ZpzjqOCTwFgwcu/nqgmxZj4TJs4?=
 =?us-ascii?Q?Bs8Xo65y46hzlytBce5233TIKXIhNYQ/sb/oFZjFUKKgUhRYnd4xT+OC9NT8?=
 =?us-ascii?Q?5ZY+3su7SlhduTam4bhMIvoSWsLM5tz9RmI7hI0ya7zgC7sJHglGYzIz+Ly0?=
 =?us-ascii?Q?hCujdKDJNM5mhp+c86Sy/XW+JP37ZeD2JPZYzxrB170O9SJDjO2QKUBr82Dw?=
 =?us-ascii?Q?pGgDLQC7JzpqkbnlfUJa8sryRzIbac7VOm90edTH0Mz/Vq/4LTpiBnEbiKoc?=
 =?us-ascii?Q?lV9G9ISs34ZMy/Y/AZ10drgY8kKgLQVzbatQIG3pMGxmm0b8w7AewgrSLTZq?=
 =?us-ascii?Q?L1ncQCC7cm/TxDC4YSut2Ibc7cYQnS05gmnbpTcgh+1NX4w31iy7DmZw7BH3?=
 =?us-ascii?Q?s9ddruJNMpfR9EZMnhkNn25hs1gXz3+jJ5+xfDXDJ2cTpxcuUQF/wmDgKW7B?=
 =?us-ascii?Q?ik+FEs32RPX+xWlwncoXknFMOl/bCsWij70YX1Oo9mJDU5IYApxjEVuIwyN5?=
 =?us-ascii?Q?nRM4gnMwhgKv8vS0i8e9aENlPpBBCCtMaq7tDOkGSwa+M+YdhflcO6PleCXr?=
 =?us-ascii?Q?G0U9r/oqvFHrmgSSrFTsGKX9o7Ob91r888pXzLPyBI9kgsUfhCgO2nBYqMdq?=
 =?us-ascii?Q?npR0+pXn2uYz9k42efs6z/eH6nB08IxqUU26kBS/KROK6GLhHhEi0xQEo3bW?=
 =?us-ascii?Q?Kx6DkXYCW6cv0OM3iANYYdRTs3RNoqvE4h2Z/AvIpD1h9qkEDbEzgIQ6B1rT?=
 =?us-ascii?Q?QDGoOo3fep1FAEjXDE+2OoCYoZoh853qbydgtvkLGi2EXrxRxNU1mbNyLnOv?=
 =?us-ascii?Q?9jDAwgiytPa1zo7ig99m7y8jiHFYybghZm6P6LtY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 428e7c6c-d9a2-44fd-dcb6-08daa7d8b99a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2022 20:24:09.4898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GZ7CPJCiFWAqVzoVTSgZJbfiGFv1vkJwBFeqntpWiclWBvmPQsTMjYWhlC03rU9Ud6dwBI1y1CkvE7/rdHNg8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8701
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
> Sent: Thursday, October 6, 2022 2:24 PM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit <hkallweit1@gmail.com>;
> David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; netdev@vger.kernel.org; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH 1/1] net: phylink: add phylink_set_mac_pm() hel=
per
>=20
> Caution: EXT Email
>=20
> On Thu, Oct 06, 2022 at 12:02:37PM -0500, Shenwei Wang wrote:
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index e9d62f9598f9..a741c4bb5dd5 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -1722,6 +1722,15 @@ void phylink_stop(struct phylink *pl)  }
> > EXPORT_SYMBOL_GPL(phylink_stop);
> >
> > +void phylink_set_mac_pm(struct phylink *pl)
>=20
> This needs documenting. The documentation for the function needs to menti=
on
> when this should be called - so users are guided towards calling it at th=
e right
> place in their drivers, rather than leaving them trying to figure it out =
and possibly
> get it wrong.
>=20

Thanks very much for the review. Will add it in the patch V2.

Thanks,
Shenwei

> Thanks.
>=20
> --
> RMK's Patch system:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.a=
r
> mlinux.org.uk%2Fdeveloper%2Fpatches%2F&amp;data=3D05%7C01%7Cshenwei.
> wang%40nxp.com%7C817e10680d6345ce150908daa7d05d51%7C686ea1d3bc2
> b4c6fa92cd99c5c301635%7C0%7C0%7C638006810614113624%7CUnknown%7
> CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJ
> XVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DdRZOuDK5vKRHYZomgVbJLPu
> Adg13bxe3QGyPZyRWwwQ%3D&amp;reserved=3D0
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
