Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39ED358579B
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 02:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiG3Atf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 20:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiG3Ate (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 20:49:34 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2059.outbound.protection.outlook.com [40.107.20.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5597567CB3
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 17:49:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktxmZGPkPL3PyoaHZUUSAUvkSUIw2fbmp4gjkJXaMwGq2pAvdLIVA/i3ocPp1ARTxiA90PC/6vvDWkgxE1ZGrNm8KHbDQcuDDaC5y5d/q3gRWjI8lpeBSlnZZbsV3Vaj/bZmIhpbsXUzofQ8n6RbyWeLPJobgX2M2WuIXUq/p2AGcD0yvIumYiSWmYsX1ihlUzciX//cCZIb0QDfisQl58Lha2oO+rS9Y1nr9jrI7J20BY+4qrBnfnYMbm2D2GmZpV0UT2toEvLspyWnq+/1MJRj4MGpHeckIaPln9W1bFggG+LOPzS27NK0EO73EX3u47ZRQkTH/Dv4+UzM/KMZKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOeaaa/aJdeVuuWrdRpw83tix8UcBgM3HypixTVpoOg=;
 b=FtwUWfWWecCikhPKF7Nq65Z/roQT1DW+fCfzK4bsS0CtSt8M+gn84Ma3xSwueO3hl5QbJ3Snkd5MUgv3O4lMBkTt9qw2jxk8HKFTGvFF/r2xNjTwzl9wpPhxMgyHaURPLjEavEuJ4L1+f9pmK5+Gcl/ys9Fdjcp+ZCdBzNAAI0e6PMH0A2sD0AgrixhGxgrGD6e9y0EpfQeUUP1jB0+qxdPwIvHcUcFRQSkF76Vmr00ZAJcj6LWA9OcALBZmEmT57P6KIAVOGgtEboC4ghI+Hq939LnLVJtMzh9nJ4MerCvjYtB9T/j1SjuELnxZP+wY/aBXtsDIvfFEAdWX5NmEcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOeaaa/aJdeVuuWrdRpw83tix8UcBgM3HypixTVpoOg=;
 b=mBSHTvjOtQw8mKrfKddAlL8zebvi51MgdI/eYVOPk1lldhR+AiBuoS00fgH4vupuvL6QCy7SBLIcB5bmlWd29QHkxGNwWQzgYHCjCxXgXKkTTdYlN3uOQn2YTUFPcgvs/22++pUbGGejWxXFcrQVt+5+KXCo+hD5xjKz0oWXg+s=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2333.eurprd04.prod.outlook.com (2603:10a6:800:28::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Sat, 30 Jul
 2022 00:49:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.011; Sat, 30 Jul 2022
 00:49:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Marcin Wojtas <mw@semihalf.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?Windows-1252?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?Windows-1252?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
Thread-Topic: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
Thread-Index: AQHYo04nl4JHZbxuek2HktTJEcy9Ma2VotIAgAAKUACAACH2gIAAC6KAgAABzoCAAAKMAIAANsCA
Date:   Sat, 30 Jul 2022 00:49:27 +0000
Message-ID: <20220730004927.arayez47wj6yo4xc@skbuf>
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
 <20220729132119.1191227-5-vladimir.oltean@nxp.com>
 <CAPv3WKe7BVS3cjPws69Zi=XqBE3UkgQM1yLKJgmphiQO_n8Jgw@mail.gmail.com>
 <20220729183444.jzr3eoj6xdumezwu@skbuf>
 <CAPv3WKfLc_3D+BQg0Mhp9t8kHzpfYo1SKZkSDHYBLEoRbTqpmw@mail.gmail.com>
 <YuROg1t+dXMwddi6@lunn.ch> <7a8b57c3-5b5a-dfc8-67cb-52061fb9085e@gmail.com>
 <CAPv3WKcoi8M6WmEtUXAObhRjJmR3jm7MguWUyw=RJQfNnt7c6w@mail.gmail.com>
In-Reply-To: <CAPv3WKcoi8M6WmEtUXAObhRjJmR3jm7MguWUyw=RJQfNnt7c6w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84e089ba-b387-4490-e5db-08da71c55b4e
x-ms-traffictypediagnostic: VI1PR0401MB2333:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ReW/RoiRuRz/LGMQnHsGRAwB4d+u58pxqeutopsx7P2DoBv5S9EUWnVn1sehX3nlCxOLH57UJsj6BMbA98EelhGW2t0IABQ3amIQuRgiZ6E94iHfXT1EE/tIvoOfrfPRsiLqym60bPjHnuF7G+9BVWixQXxThWKTFQLX/2Xl1VlCDq6UE8S0BzRrvurmRfMhMJjxvsXS5mUR2FL0NqT8azSvIAFa/iQ/6x4xdZb9GVVbjQ0+lAvYTxKLhk/ZbpdQc7rjvZrxFGetSZ3wpF/wewlWcprFd8bA7+VPTp9H1EQ2YKfwgtvIIOQfFYHzR/iNMdBIi4z2tPGlACNvNLIxalSzskcVKbbHEnYmhMOoROgYooPwx4hpz+QsVGnYqQLfuVR+Z03KzRZtM2pYIqj3KFCyyUaoavllFexhV0Ub8y7kP1s7sMqHx1c8MhU3otJ1vvY2O0Uo3/N4MRDKEhAItXj4vh625D6eeKhC6VVPViAdqaE+VzaeWsQPU+MmUP0HCGMRVWVy1K/BDcvsr8RnZvJ1AK6KnItRm+EIFl0Jn+ftYgxIyzChKF5uro6b9YJ+zOdppLUNHnY3sRxKNaPCAcyl0rWnBvPRkGeKYpVs/VgLC18KaK/+rgBtDRLF68hHp+eXPe4sSnouZqYFRJU+sZKHa5BelqbfoWDbzc2Gj3weBx+affjanyQ4Wy5sEDYopiIRFGzIPuq4NGBJPbeI90+G6i2JZL0aaIWWm9hv4LFT/jYM7H6Mic/iiB6FZpgFX6wqpxG+Q1oQjGt4/nkMhFbXRe8I9oJXJOL7/MHk6vOXXyVx7H8tUNRxAVFoHjBecUpH+B6grRnQNp5jVfxuiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(5660300002)(86362001)(38100700002)(83380400001)(38070700005)(66446008)(76116006)(66556008)(64756008)(66946007)(8676002)(91956017)(15650500001)(6916009)(316002)(122000001)(4326008)(54906003)(2906002)(66476007)(6506007)(26005)(8936002)(7406005)(44832011)(7416002)(6512007)(9686003)(66574015)(1076003)(186003)(478600001)(33716001)(6486002)(71200400001)(41300700001)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?ECFTXNvCvw0nAz8s9kuXcvDFJfJCJnTuXY5b4kzHp2HzQiKP0gC2xyNo?=
 =?Windows-1252?Q?MwZfiE3na6pDiiBz1qyOXrqR32cazOMmdiCt3mL6OStyRqnupScCpwOk?=
 =?Windows-1252?Q?vDVR/l+18zTpXXZ3TM5TfGxfGDT0V/ra5MOmR/cnMTTSOFidgnXYY4AG?=
 =?Windows-1252?Q?8mGFcsYUAKD+8QcQXqHa3EDac3JRbSuKGfJHzn5VMJhhoqsKLRM1/2rt?=
 =?Windows-1252?Q?4xgAjYi9QwiLXQhpxssQAWTgAM2QowtvAOtIvRaJw2dJZPQZdjq0tcag?=
 =?Windows-1252?Q?CIoXNtUeriATar++xnKiB5ylF+FUPduQ3wtQ/blWzwOTInd18JSx4O7s?=
 =?Windows-1252?Q?MAR3JLO69mcoL1lrP5TbrYDWgVqY6JaspS8ChSDsvMeI3RdLkTK4pOq6?=
 =?Windows-1252?Q?/ZbQl4sl4Dk+yTyjPbj6jBh8asWOPJ6RUx461Lvb62+HGPHUiTjZBS5I?=
 =?Windows-1252?Q?wGtbSRKm/qqUQYcWrfzIeFW46xc1qJpGjcRdYS5yQ952inT5D7iLE2cX?=
 =?Windows-1252?Q?b/isyUpaDdRy/M0ntMO+R51VPpkIwp8kEkyzUl5wkBEX7H1+ODPQ2Lgf?=
 =?Windows-1252?Q?mnoCimWTIF3I7w3EmwzeUZjhk/zPDsLNfRfxqL/HbIIPJ3vDjsalnmbI?=
 =?Windows-1252?Q?Xk1nl2FrXqkBh2ZvGL+sUPTCA0v9K3vxP3m1xfpkMThBSubQ3b8Ldt4M?=
 =?Windows-1252?Q?lPFWNNqplY6fI9ZtcJkcWyGfWDnXsBdYeiXQ8Ez/JC4ScaVlUQdeZuLm?=
 =?Windows-1252?Q?S9fFDtfwJ2NrXXfPNjFt0SG608My8NRTEnqEwxgoTo2X4ygEuQnyNfxg?=
 =?Windows-1252?Q?lQRlV16Yqx26nk0uzW6cPxvDOScShLn2t6fzoG/98oye270OKSp2C9cR?=
 =?Windows-1252?Q?bQuUh3XNKkadSB76iikeAZAXtiiptNF3lMBM2XBUEyC1vMOQXnCyngzC?=
 =?Windows-1252?Q?PPXBiS/ovee1D2mJN9QOKJ4QvwEZAU6dYEojVL6Bh1frvS7rtbveMG0X?=
 =?Windows-1252?Q?raejw8hNQDp6lg5LmEDz442mCf982WEcGItvid/gg6yVDDJ2gh7yUW9K?=
 =?Windows-1252?Q?7ovAYgaNEjzIygoFH1enZQ4zBaUPB0IBRmuICn8bTKwXZgEZb03nXP30?=
 =?Windows-1252?Q?k9NJbQOU7L+zHMOxVs5eMd6lu1R2oZmo70Xzuw1xdZ0cAdt6Wh+CtRfC?=
 =?Windows-1252?Q?dVdxtKEaoQD7x7JKMCZsfcuWJ0mtGdUkxHo1ain8Qo2yCD6oIrwZX1qB?=
 =?Windows-1252?Q?unQItjUH2NKr8PCfo5GywFX0y1pa/KBualfjWEnMNBaAnvKJa/o/wdhx?=
 =?Windows-1252?Q?xXzNRGxUUOmqtszitlADRw9mimBkifxTEaWTw8/ZJP2upRqi+4sf9nWR?=
 =?Windows-1252?Q?Wpv0InD/sf1GkIStct/9BV8aEKNBU1byTHmQubOSYhIgChwPZ/4Qq4D1?=
 =?Windows-1252?Q?kxqef8UUmbk25vOh9/yHmoAkUBxzZR5boNUIez54+KTx98K/eDNbxKoo?=
 =?Windows-1252?Q?fjoTtn/FN3tqKlvmT2RWxWLMkXaiPLV7+TAJrjwwPcO3yl4sCNBxbv2x?=
 =?Windows-1252?Q?ZvjtezY/bkNPnUvrB6I2qe00QR5WFuXXVWmANNDDjiaphqKOS9jTwCFN?=
 =?Windows-1252?Q?9eJB0qQrVPr/CDvtevu5mumzauw+fAj3berTqMV9Fd27Rs8BIOLI2C5w?=
 =?Windows-1252?Q?cxAfvgdEKntTOlNUrwpqFXuLdRcN2fwt7Oq2qrCNKe1ri5OINAIGzw?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <4B613F24F9CBB2458AC9D8AC20A1CD50@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e089ba-b387-4490-e5db-08da71c55b4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2022 00:49:28.0114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0nUDvAFeVM0gGPEHJC9xf4kV/3vso73MFKcGVq2L8O3tUQUiRpBziWra0r4GHJob2LfvZVZZwu04RLVIrn9ksA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2333
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 11:33:30PM +0200, Marcin Wojtas wrote:
> Initially, I thought that the idea is a probe failure (hence the camps
> to prevent that) - but it was clarified later, it's not the case.

The idea _is_ a probe failure, but not for whom you seem to believe
(not for the 'expected bad' drivers but for the 'expected good' ones).
The probe failure is for drivers using OF whose compatibles are outside
of dsa_switches_dont_enforce_validation, and all ACPI drivers (that's
going to be your part), effective immediately.

For example the sja1105 doesn't have any parasitic users, I'm absolutely
sure about that because it already has validation, although only coincident=
ally.
For the ocelot driver I'm also relatively certain practically speaking,
because we're talking about an embedded switch where the description is
in an SoC dtsi. But I can't totally exclude the possibility that somebody
won't be crazy enough to /delete-property/ the fixed-link from a board
device tree, or to redefine everything from scratch without including
the SoC dtsi, and then claim that hey, this was actually working before
this or that refactoring, due to some marginal condition which I never
designed for.

And that's the point of this patch. The DSA core is flawed because it
doesn't let phylink fail when it should. It tries to save the day by
making some odd decisions which make sense considering the old drivers,
but simply don't, when you consider what the code would have looked like,
were it not for the pre-phylink baggage.

So this change essentially lets happen for new drivers what should have
happened in a normal world where DSA would not interfere at all -
nondescriptive bindings: fail to probe, bye.

Rob is right, the DSA core shouldn't validate the OF node, it should
just let phylink fail if that's what it will, and go about its day.
Individual DSA drivers shouldn't have to validate their OF node either,
but they'd have to, if they wanted to circumvent DSA's logic. And why
put the burden on them?

> I totally agree and I am all against breaking the backward
> compatibility (this is why I work on ACPI support that much :) ). The
> question is whether for existing deployments with 'broken' DT
> description we would be ok to introduce a dev_warn/WARN_ON message
> after a kernel update.

Andrew suggested it. In v1, the array was for skipping DT validation
(this implies skipping printing warnings) for drivers where we knew it's
going to be violated anyway. But we thought, why not also tell users
that what's going on isn't quite ideal.

https://patchwork.kernel.org/project/netdevbpf/patch/20220723164635.1621911=
-1-vladimir.oltean@nxp.com/#24949229

This is a detail to me and not the purpose of the change. It would be
nothing short of a miracle if people would suddenly see the light and
update all DT blobs tomorrow. But no one here is planning based on that.
Quite far from it - Russell King and Marek Beh=FAn were (are?) working on
a patch set that actually pushes those incomplete DT blobs to the next
level, and fakes what the proper OF node should have looked like, based
on driver level knowledge.

> That would be a case if the check is performed unconditionally - this
> way we can keep compat strings out of net/dsa.  What do you think?

So you're saying keep the validation and the warnings, but don't fail
the probing of anyone? Why? Being strict about validation allows me as a
driver maintainer to be formally correct when I say that there are no
users that expect to not register with phylink, rather than just guess
or hope, or even waste time checking. And if I was someone new coming to
the DSA framework, I'd want to have that guarantee. I didn't design for
that possibility and I don't want to have it, just because I use the
same framework as someone who put workarounds in place so that it works
for him. We could argue about who of existing but otherwise newish
drivers should be part of dsa_switches_dont_enforce_validation, and
that's where the camps come in.

Being warm and fuzzy about this, and just print, doesn't really describe
anything except for a preference. After all, we're not abandoning the
broken DT blobs.

What's your concrete problem with compatible strings inside net/dsa anyway,
and do you have a competent alternative? Is it the problem that you'll
have to convert them to fwnode? You do realize that this array is not
planned to expand at all after the patch is merged, including not to
ACPI IDs, right?

I've explained in the commit message why:

| Because there is a pattern where newly added switches reuse existing
| drivers more often than introducing new ones, I've opted for deciding
| who gets to skip validation based on an OF compatible match table in the
| DSA core. The alternative would have been to add another boolean
| property to struct dsa_switch, like configure_vlan_while_not_filtering.
| But this avoids situations where sometimes driver maintainers obfuscate
| what goes on by sharing a common probing function, and therefore
| making new switches inherit old quirks.

The latter has actually happened no farther than a few weeks ago,
refactoring was done to the microchip ksz driver, and a newly added
switch gained support for an old one's quirks, by refactoring the code
to share common logic (which I was otherwise very happy about).
Now good luck with adding a compatible string to
dsa_switches_dont_enforce_validation without anyone noticing.=
