Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B375B8063
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 06:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiINEra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 00:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiINEr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 00:47:29 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2101.outbound.protection.outlook.com [40.107.114.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EA05EDCE;
        Tue, 13 Sep 2022 21:47:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRCWlUGlH+QthXVL96smmgqTjl3+VVWrWXCO0Fg3UpAgKvcKonqYB6rDp/0yZ7kdaUs2ELL+ErLE9k0mfmwdsvzhAksyiyJdon66hPytfrTi9lBkkT+OuKYa2r2/I7c0rWwTmIw332jLN3eoU+5xH+C25eTU2V5TuOH3/pL8zWMAr1kOhEFPDWKYcdbIeOvqYScDerHG1v0EupFp6dJAM1P2H3dZkCm7UD+RMhLbFqEE2JX33eszLc0HQKXWN1kgtBZ5yHTDkKmB/5KwG4Qb56MleyLkChhmoNV/ctqHuO438TcLVLEQbJg3m3Q/lR5xal/VuvIMbnbhn0NXRZu1cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jk6htmnFtw/+tLFL9ZoQ9duF0N96RGebDPpj5zxYIzY=;
 b=RGSVkY9bxzup66oq3j7eduROXrTGKEmxPfGlEpXzW/NiEv4Hn91hfvJ84nerk6gNSop8WzlRrRExbo76wyJmJqpESmOIlBogKYPgWUzKolv2MOV1TsM/Xc7EbXQefOcOmo+wDpheULF0+NADpDfd1MzS8wWbl1ubfiattaqt7IBrZF9+WDyTVEbK0t6Kno9+kD5m+xz9mC6W3lc0oW9g+DHIryuDEywb+NViJywGNN7Ql6K+JB914MA8ZZqXRsMtmS0n0Y86PBKK49bwI88i4WBWOupEeA51ZBR/e32cci8yLBLLKRONBgkjOhdi0cyUPQ2tDVUwCj8OdD/ULRhngA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jk6htmnFtw/+tLFL9ZoQ9duF0N96RGebDPpj5zxYIzY=;
 b=U35Z2fQCNyrrsEmhNxiBZxxHMm6uZ1YDCCLKnxarnXZRP0RdeofS4qCWPgBYSmB/wDw5tBfWR15nH0ooXXtRKHANiNa4tivCs2Eb5XOO5tV9Nzj0Lo0tF0Y3EiLfRF8K8YMUkiZYnIhtiRmE+E/dLObMZWClttBBm69Vyc+LosY=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYCPR01MB7848.jpnprd01.prod.outlook.com
 (2603:1096:400:185::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Wed, 14 Sep
 2022 04:47:25 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::194:78eb:38cf:d6db]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::194:78eb:38cf:d6db%4]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 04:47:25 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 5/5] arm64: dts: renesas: r8a779f0: spider: Enable
 Ethernet Switch
Thread-Topic: [PATCH 5/5] arm64: dts: renesas: r8a779f0: spider: Enable
 Ethernet Switch
Thread-Index: AQHYxE/KYBwY6XjQF0ijnvFAnT+7Rq3cg3qAgAHcCKA=
Date:   Wed, 14 Sep 2022 04:47:25 +0000
Message-ID: <TYBPR01MB53414B8CA1157760148FACB9D8469@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
 <20220909132614.1967276-6-yoshihiro.shimoda.uh@renesas.com>
 <Yx/L1VeVmR/QAErf@lunn.ch>
In-Reply-To: <Yx/L1VeVmR/QAErf@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYCPR01MB7848:EE_
x-ms-office365-filtering-correlation-id: 74dc66cc-57e5-42c8-06a2-08da960c3852
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eQ+f7AbHWjDEjr+Cl8NiLAKMvzeWprbrbmUT+HHux9iwy454tcrgZlWQwC/JzRQip09V0J4xaaLKDMuSgRYj7vnkGyS7FC87sDoilJ6MfftNsKSxgiqs6SPcxOpLQuzAfpv9U18TiMnrCrigIG+5RtM3axjZ4H1E3X4D8KsLcHfVPe2Kd8CIceddiA+BoxxI3NNeXnZ1wbkTZ5JooQoiRkliQPPLW+DWAYK7W2B0Qw+JChPNAxX9P6Z7NAPT/+AEho0Sv62oJmoMAqdKnU/o8DeE4SgpqebJbA7R41QZy9RGdcrOqRAxJVxPvsRFgrPVNtdDxR0rubMEzq5y2CQAoEauFVHH8jHputpL9HCwaqWQSg8X0lPRSSn/Ok/hB21zTbHrUng63mi/eqJa7ZVi/B6hIku3tUF8NZQI1DCeurlh9PMp3i8g1qs6TbW4IVv2667Z0JBb+9UL182bLPJiiEDYPsiQEZ5OoIaavoDCZwr2xs8GYikjhAucUkhPSyrYbxnGyPOJkrzaNpG66JRWaNYRJxBRByRmhnXR0sMrOorrthfOay+0d1K5sHoJVmuWUbg3rTW1Clw5GOyGtWpY0UpGGnNtRiOWN21F9qCzwFVGfnOjK5ZOw4n85SrRw7xMADX3Lb8AibGv4KutS2+ZbJO8lC60XyA5jIEEfr3S2nxR4CCByqPBqoHw9AOdEkqJo72xMuBmFiNJyeHTovpBwHBcwuO7hzEGjyp2N6U6W3BbC6/Hny6twxGrM2zpQMmcGG3e/fLOkVNZt5VYUK9TV+G0lRfjCaGMUFgS9/Glmq0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(451199015)(7416002)(6506007)(9686003)(6916009)(122000001)(5660300002)(38100700002)(38070700005)(41300700001)(186003)(478600001)(86362001)(8936002)(55016003)(54906003)(64756008)(316002)(7696005)(66476007)(83380400001)(2906002)(71200400001)(66946007)(66556008)(4326008)(33656002)(76116006)(8676002)(66446008)(52536014)(43134003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FGtzDUrUpu/uJMwV8H6NkB3kcufeiWWusj5JWjtNuX5L0ngyqPZq7BL6jhaV?=
 =?us-ascii?Q?blpm4mR8QWDShMlJ425d8plqICtxtoEs0F/oBdUJXtSgTbLyNonop1E7zdt6?=
 =?us-ascii?Q?l7M+BSeU9cPsc1oEcZRE/jpjdCX0Ko6WRJkdkMPTZiJDe3wSs3e9bAigsvli?=
 =?us-ascii?Q?rF80BEFwC/2/aP2A3j6LOwu50nGDpxHLvN+vHpNsSRuN/QfPLX8qOp1b64cN?=
 =?us-ascii?Q?LaFipiV1WQMr2/oTlnlUv6IcbjwVIvlBJHzsLF/xgJlzYUX/HXCvMkWJMh44?=
 =?us-ascii?Q?EZFJRQ5UYBYa2uFSeC1th+2Xq2pmxbjELIGUBfw5pHRYCyAYEVMY4JDoe7Cg?=
 =?us-ascii?Q?HQRN22CkoWBPSsh7/9M3U+7RnBIXTi4trnxa7GtQ2qGgKDl45HyDYg67YLRq?=
 =?us-ascii?Q?M/UrhqqZUltTJ5/8mcvRbtj7zaj53j0RNNLBXDpKagG+zMJvHkI7wmZC3a6p?=
 =?us-ascii?Q?jx7DrID9fJf6THdHiY4hXEi1eSynI/XzXYQT5mg1xE0wznpkJJgKzzcdOIWL?=
 =?us-ascii?Q?1CA1ist+6zmIOW/XLgdmfPoav7G9/bGfuSF8waDmuVl6/nUBJMU8at6wc1UE?=
 =?us-ascii?Q?DAVaWW/qMfhGBKVIsrql7O8nfM0I+D2Lrz/wWkn9RPrIk4qk85XwRoKoPNAd?=
 =?us-ascii?Q?J7fU2oe4W07ajTZ2pgxR95o+W14RbGBBC7nnL3lTzHmGOYgDBT8PRTraY2gD?=
 =?us-ascii?Q?xm5urK3z92WldyHDKdZPnDB1s0992IlQrmBAvBOYr+Q8yyEpvIMzYmSQ6d2f?=
 =?us-ascii?Q?00bFhh4KE3nivP7Bm3+1tTOaG5tDPjwGmEDNvD8WBu8dssEIJmymRxiW6did?=
 =?us-ascii?Q?o/LVTn1fVQtQZBebR0HhQmLE4+inId3SX7/YGozuDELxiy2pYnyFV7ForNNw?=
 =?us-ascii?Q?Xn9p+rNNK/OQPgSabWQoWgu9rr9vgCXMHqrI2+ifpBoOwNqR+z3d0uEEmfmW?=
 =?us-ascii?Q?rgjs3L9T4GfrDCN6uOTG/xbnxe4lMO19RfMqbeh8pGe/HpEDK/+vZDmSfiK8?=
 =?us-ascii?Q?F7YOfUAcnv3KC16nrTc5eo1ju91hwh1UGQhII4Jj4nZq1J3eoF+W1778BDmx?=
 =?us-ascii?Q?hgHXxvbahMjXZlIWfSmhgiT9R7b38wcdcC2bsWaIpGGgvcLHIZvDezs+FD3G?=
 =?us-ascii?Q?hBB3ii/9T35QFRJhVhtaXWlhhTBeqEchEGYufQqkz9OV+1k/yB1mxBBWI35C?=
 =?us-ascii?Q?aFoUuo/6tnUI3pYdXyfY3OBzubRZa0f7K5Jb6baXlzd+oVaO6eTZBLU/7Kxi?=
 =?us-ascii?Q?04jabpSr9Clc7wXhVD766hh2Zvbn7MloYd8EYSYZbmxpkc6CgIwvW1Wrg+WT?=
 =?us-ascii?Q?ATC3sqqmkIFmnB8g41d+mk0FYA8ZU0orOr07D21cUOFWzVcjHQDFfvb842C7?=
 =?us-ascii?Q?S80XNsxclemD1Mef95RVRDETVSMIMNaUDErtvYUakGMHOCH1piFMoOxysy7+?=
 =?us-ascii?Q?ExCuuOSX5zKOvQpIoFcyQV4S7g+I6GoXOPGYrQ4GqeGjXixWL0h/wSqfAheh?=
 =?us-ascii?Q?H1lgyeZK2VIyHabNvZfy1LwHptH1j23TPrtYOSj+/Quh+/xbqgrPUlWBECNx?=
 =?us-ascii?Q?jMig0ii+9ontOZo6bqIyOzogg/HY/aVAUQjauX29r6X/infvAMH6O8E5m5W4?=
 =?us-ascii?Q?7Pn9jjYmrnrwzAOAQoElEx/ygIzBXM8FWk/IPhy2hoxBSoYkBtjrIPSHDjHy?=
 =?us-ascii?Q?YbjUkg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74dc66cc-57e5-42c8-06a2-08da960c3852
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 04:47:25.4863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D8ckbsUYspUt0XMdM9CxRwyJ5bB+BvNFPpu+lBsY9/njtFZ2N2QoPt7KFDu7Xyx40wkcV91dLUsWDyS55JmfG9SYvKQMftO6W7CFHcbiUUC+wnWKF3ddZqT2MxhHr+s3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB7848
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for your review!

> From: Andrew Lunn, Sent: Tuesday, September 13, 2022 9:16 AM
>=20
> > +	ports {
> > +		#address-cells =3D <1>;
> > +		#size-cells =3D <0>;
> > +		port@0 {
> > +			reg =3D <0>;
> > +			phy-handle =3D <&etha0>;
> > +			phy-mode =3D "sgmii";
> > +			#address-cells =3D <1>;
> > +			#size-cells =3D <0>;
> > +			etha0: ethernet-phy@0 {
> > +				reg =3D <1>;
>=20
> reg =3D 1 means you should have @1.

I'll fix it.

> > +				compatible =3D "ethernet-phy-ieee802.3-c45";
> > +			};
> > +		};
>=20
> You are mixing Ethernet and MDIO properties in one node. Past
> experience says this is a bad idea, particularly when you have
> switches involved. I would suggest you add an mdio container:
>=20
>=20
> > +		port@1 {
> > +			reg =3D <1>;
> > +			phy-handle =3D <&etha1>;
> > +			phy-mode =3D "sgmii";
> > +			#address-cells =3D <1>;
> > +			#size-cells =3D <0>;
>=20
>                         mdio {
> > +			    etha1: ethernet-phy@1 {
> > +				reg =3D <2>;
> > +				compatible =3D "ethernet-phy-ieee802.3-c45";
> > +			    };
>                         };
> > +		};

Thank you for the suggestion. I'll fix it.

> > +		port@2 {
> > +			reg =3D <2>;
> > +			phy-handle =3D <&etha2>;
> > +			phy-mode =3D "sgmii";
> > +			#address-cells =3D <1>;
> > +			#size-cells =3D <0>;
> > +			etha2: ethernet-phy@2 {
> > +				reg =3D <3>;
> > +				compatible =3D "ethernet-phy-ieee802.3-c45";
> > +			};
> > +		};
>=20
> I find it interesting you have PHYs are address 1, 2, 3, even though
> they are on individual busses. Why pay for the extra pullup/down
> resistors when they could all have the same address?

I don't know why. But, the board really configured such PHY addresses...

Best regards,
Yoshihiro Shimoda

> 	  Andrew
