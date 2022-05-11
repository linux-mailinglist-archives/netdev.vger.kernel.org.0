Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA697523110
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbiEKK5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237991AbiEKK5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:57:46 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150047.outbound.protection.outlook.com [40.107.15.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529E946173
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 03:57:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ft0hVHL11Mf2nnADbvvXKj+MSs6NFD8NrcMHENcLeV6Up/lcbF3oNX8ck+tL6fhiRgQuMRsSWggQQk2S8+CmSI29gLuKC1KN8s54aagEbGMcc51WAnO2R+QrH/brVYe2FwTylGyf44AzIjClOYmIeYDzv0zdOLhzGge+LGJeOxy6icjjDCGaVSbGawsJH092uqtgkdcUoSo/QZ18NMR8gjR07hmW/rVmOLgX9crJTidSoTB5Wnj0K4svSCo8nFIszzLSx82Nu73Zb0T8MjDetVAUUO8t/ciieop5cW+7ZlsEbxTqXvOUXtKw2Bev+YFy7CUpyMqpxb2bVxLxwNbt2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vd2UZuJumwd1w2v4STuytqHbx+6wFGW03qz5JPOw/u4=;
 b=fpmgMTFEiOoTS/dKsDgSTvk3mDX6B3D2VP9TotwKnbMBKyXfm9Y+FuoAEgIYfP3fbI+Hs0K5XweDaI5/l8VoEkG8wrITNxH7b4njbbjy+72nAsMV7mEM0LluSFBTN+ZS0wid/w4Fe0BynMcL36XRM3Y11VMJL8s3COUkd4SMoV/SS+NVFD1aJFLI+X3BeXvTC5bnPumwu+wdjci/3n18Mo5lMf0wSFsTuZPX9etlfWPn9cNZy7rWXFUqIrajxwJr6N18w7kGtTJVhmBilBMZUPV1Tv0XbeY8ipWt1DgIgrdUpOsfp3VVdYoWekTN1x41Zt+FaXiwhUb3sihTov++0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vd2UZuJumwd1w2v4STuytqHbx+6wFGW03qz5JPOw/u4=;
 b=QC3/DU+nYD890L1VVvXTl5QEeU6gQyr7a5xlTvgXq/SQEkR8PYUBIsBQa7JofRDiyS1vbOWY2YIkQCMe/El7NRrpVAMirGjE5g3hiHSGoEdxTDC2kbVdb19dK5idLT2SaR0IjTcu5XaEAFXKj3/kA8Pn5/cWSwO9v9DYvTgbUkg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7986.eurprd04.prod.outlook.com (2603:10a6:20b:245::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 10:57:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 10:57:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?Windows-1252?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: Re: [PATCH v2 net-next 1/8] net: dsa: felix: program host FDB entries
 towards PGID_CPU for tag_8021q too
Thread-Topic: [PATCH v2 net-next 1/8] net: dsa: felix: program host FDB
 entries towards PGID_CPU for tag_8021q too
Thread-Index: AQHYZRyPJSfBMu7vvE6Qh6vnzfkhQq0ZgaWA
Date:   Wed, 11 May 2022 10:57:42 +0000
Message-ID: <20220511105741.obbf44iqkff4ggmj@skbuf>
References: <20220511095020.562461-1-vladimir.oltean@nxp.com>
 <20220511095020.562461-2-vladimir.oltean@nxp.com>
In-Reply-To: <20220511095020.562461-2-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8cb0b1b-d6e9-4adc-d63b-08da333d12e2
x-ms-traffictypediagnostic: AM8PR04MB7986:EE_
x-microsoft-antispam-prvs: <AM8PR04MB79867FC17CA493EE320D8212E0C89@AM8PR04MB7986.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YbmKCTmVClrxL9JfY2R3/0b4YvbmgiCRxAJePS+sfw6+mhi3Ip0vqI0hJrmLJBUhtzUCAZOyxZCbo+wMa6OsrL51ApJIYSy0jvT2RK0SsN+BqgE5MIWAE4eHrAZaITWzE3EKGwg4HiTIgG3yGw4RoZXtDjw5NOkVuQc6uHC7nW64AsdHQU0bEHHZB9GICNRmiAyJFxS2+WovZ/MzGTrfzRbdaVx1bSmSUiK7y9e9cW0ZBzFkyk6J76HMIwaHRiKjFEYti7p3pg4ZTj83xatmvkxbRbJLANlMzuz/mzP4EjG5+b6l9Qb1FG3pN7JZc3rqhphkPICz3l6xVfhZThT4gkjmIehDqa0LqAiDlYoTO8lwULNr+rfi6Csf55B3YFtJiItscpUbVOATSRWYwf9CMVUC7KW6W0n83FgEANTQ0SVDcZxdHNTMRT98Xo0WgiDXcq/Hw/R6x2UlQp+NiZE+o+AyEzFZGDIl0hkCkdt5a3mICZ+rWnoZ9ghwMs1PFD+rhiPotXQ9tUvEZ4Xreh+q6bRmHdihn0nKnPNRbGTGARasccAr4TFVyqRXJBVCLV+X3UwDEDmK2zExaPFZolVsCkPf5iJUGyFPr6Pl3V/blZSvXpsG7aGXknihEeTg41dJOg3FXPp/japBlXw1kY0E31oz5L0YIDH+sMt2JR8Th2kF3N31rtoA2MMkK5d2C0HSOMP4D4/E5zz2VH3DwC6FqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(26005)(8936002)(5660300002)(7416002)(122000001)(38070700005)(9686003)(44832011)(6512007)(54906003)(38100700002)(316002)(2906002)(6486002)(508600001)(6916009)(6506007)(83380400001)(86362001)(1076003)(186003)(64756008)(76116006)(66556008)(66946007)(66476007)(91956017)(66446008)(4326008)(8676002)(33716001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?KYFXNMcmoooLh3flzl+bbSgQfFeKKSdmhu5OID1qoA1i1npwAobPuOgt?=
 =?Windows-1252?Q?EldFL6zav2tlcJ7SvHIaTdjeYzJShXZU1MSQ+XhLCSZcWr/7eakrSOSZ?=
 =?Windows-1252?Q?UnUTQ1ONLPNHd5H/MsHLWuJ+Qnr0aFDc+6jc+oiNCQQyRvHSZ0GHe+T9?=
 =?Windows-1252?Q?BWC6zXFisTQmsLdiN1gXwD5kWc+LO3hYWAR7OF11A62h8Yqm1zbuOH/3?=
 =?Windows-1252?Q?aXUAg7+KDR0yfkzoyWW+Vd3NgGdqGO03vxK5Y8ldy/Y2/76wC9fHqVIG?=
 =?Windows-1252?Q?eChGg6JP6rtEFCmwyeJ4BLeaxHnLbfU8aWjtszWcv2bTcfnm00WZnZvZ?=
 =?Windows-1252?Q?N/Wj2lBQoZWkgwQbkctuoWabMvC5RT9yM3PgWDHjrZZj2bdGrKhhWlOO?=
 =?Windows-1252?Q?5aVWWDdGBq10R34sxfYBHigkhYjxyWoh/j3y/X7t2oxqtqMJwNXACJlj?=
 =?Windows-1252?Q?dKgOd0IMUnuYMYO8kok/r3gyvpeALATC/ZGa0CC9ftPQJ5JI2dkLZ8u+?=
 =?Windows-1252?Q?ucyAoJ5oQ/wOvtYacxGsUkIHoxOFM0bXZnpMT6qheMh5ifknbAMgk8gQ?=
 =?Windows-1252?Q?FOvNkOfnAWPrWR6uYeku3nWokWSmnIgXi6yZgtqIcbLLIXbn4YdtA+ea?=
 =?Windows-1252?Q?egCz8nuItqrrETTdA+2xwaY+aESu/wyD4PsKkbMPcIT5HZHeg3bXSpHc?=
 =?Windows-1252?Q?hK6uT5D4YhZcD/tCf/aoC/Tz0Hr9PNWqW09UwnJSvntPzWCOQ98UJPdJ?=
 =?Windows-1252?Q?o7OCC/ZN2zwn+VU8qeAHpo3UB/jcUkwum1hF6maamE0Yp6xpWc6xdvFl?=
 =?Windows-1252?Q?MrX5VZ1pQIlOVGZrrEsKol5RdhJQS/Ix/SpkUJlqI/VjRtXTrpvLJ/48?=
 =?Windows-1252?Q?AE9HVg4AogU6YRZLBEyiHZJ0a3LKiljlYzRFodZrmSJDUlobYCQv/B0O?=
 =?Windows-1252?Q?8gWJsq4eEVZPJSSzOz6eV+vZn1pCIMNHbJR/iHOfzf55WWhcTuczptOI?=
 =?Windows-1252?Q?mNtEwiIzORgM8Fwlz95UwCmlQY2+SQMPEBZ5dixTwUxrNi6M++v3A0tj?=
 =?Windows-1252?Q?6fM58IgH+9G3C5BfKI8+f/D0y+qWZrITLQ82q1knqscVUbDiwupPrJP8?=
 =?Windows-1252?Q?jLXUTglrECdd875qhdEHOHTzUzlQXWF6UAgkQRhC4gyfujZRuXK31Aoa?=
 =?Windows-1252?Q?zkrCyFRCy7te0StjY/7DUn/ncvVHyB/molq87nYgo0Hwn6SRSh7/KaIE?=
 =?Windows-1252?Q?ODxTTukvAXGbVUfNLbs6msAjnEfp2jTgx3bMNV6j8gNlcXlL4TbwS7KJ?=
 =?Windows-1252?Q?AORZLN3plgKnVUkUlDk4yKRy+MmOZvq/0zlDjRUTroBDEQS9jOjEro0E?=
 =?Windows-1252?Q?sXFae6Fz7DeO4ov2UdcAQn6TCDUf0ZTZ5uYT+TacSyokGz5cyTxHo06c?=
 =?Windows-1252?Q?dqNpL1EC6G6Q/HKLPOx+bmUPbgEvRivLlfvoIT2CcGPmVBtXA6S1alGv?=
 =?Windows-1252?Q?xSF4HnYqE1CVz1iOEM/0ab2uPUY4LQ9o7khQc734wd5H7CNlo2wyQfQE?=
 =?Windows-1252?Q?mVdUNALiuYELam9CCBvGKOfZOgkVNlQlR+Twz2US13vsUaWg7tMlEElm?=
 =?Windows-1252?Q?0iqJZUX+17UKW6dhCJp1Dn6lZs5Db75x704J4Jmxl8puIZX/Efw5C6Mz?=
 =?Windows-1252?Q?Swx3EF5NCDLnhuBFNsHbE/IBuAd8xmCZMYyWJf3WSKvIYN/SnJ0QXmSR?=
 =?Windows-1252?Q?f7fjxmx5K/tXrrqDmq/qr3hhJ/E3jnK737Q68FIpZ0sUleCUjH2m8UCI?=
 =?Windows-1252?Q?EnJ8dqJNoujFNlj2a+0BKo0EWXRwgXjbKaIz8Xs81/NvJFcn3qwGZNxz?=
 =?Windows-1252?Q?qj3oCFv/OXHDsfcf7fnE9npif62V+Mtag0Y=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <BE14ED6C5A73EB4C9F1E21B696BCB4ED@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8cb0b1b-d6e9-4adc-d63b-08da333d12e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 10:57:42.8911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uwCTYDdn68+sa6RSnzWw244RBtpQ0Xd6jbXIx3nKYXWX/kD5tfH6Hoao3ei7v/jr7sCfrqT6+LAhGHMbL49APA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7986
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 12:50:13PM +0300, Vladimir Oltean wrote:
> I remembered why we had the host FDB migration procedure in place.
>=20
> It is true that host FDB entry migration can be done by changing the
> value of PGID_CPU, but the problem is that only host FDB entries learned
> while operating in NPI mode go to PGID_CPU. When the CPU port operates
> in tag_8021q mode, the FDB entries are learned towards the unicast PGID
> equal to the physical port number of this CPU port, bypassing the
> PGID_CPU indirection.
>=20
> So host FDB entries learned in tag_8021q mode are not migrated any
> longer towards the NPI port.
>=20
> Fix this by extracting the NPI port -> PGID_CPU redirection from the
> ocelot switch lib, moving it to the Felix DSA driver, and applying it
> for any CPU port regardless of its kind (NPI or tag_8021q).
>=20
> Fixes: 51349ba7f2f0 ("net: dsa: felix: stop migrating FDBs back and forth=
 on tag proto change")

The correct tag should be:

Fixes: a51c1c3f3218 ("net: dsa: felix: stop migrating FDBs back and forth o=
n tag proto change")

I think I wrote the bug fix before the buggy patch was merged, or before
rebasing :D=
