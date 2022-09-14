Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF495B8066
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 06:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiINEs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 00:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiINEsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 00:48:55 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2113.outbound.protection.outlook.com [40.107.113.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9245F10A;
        Tue, 13 Sep 2022 21:48:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6FKhXtIq/PfNkW+Q6xGpieB1nKGDPKFHpMSAZqv2xp2xXYyGgzlT09NFhS1ZInvvo1EoXZmEsVccebZTO7dNuNl60vkHnS0eP25bgSJELekuLE3veij0aRmFtbLhZ86IUt2RYcvwWejn6JaGrw2R7KwCiGVGqkirFiJ41++yO9BBU8dAzW+nPOHBPwACK8fvKziOPysNhmm3uS0szw39xhSLB+h7QPQL1yDPsB0pls2PE9ZssWhpBV4nkNlS7VSF8UjR9AGEEq9eZs7FKBFEnlD8h5815rwujQM4AgKxNFZj192Mk5sUK9hYELS9lVg0ZGKofpHCfNQUxEzyT/6ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uj+oLP1Zlzeii9cfjUx76a6WlhbUGvAq8ftHjtbj/Pk=;
 b=OEp1q2uUba8Kx24IWavijv3YVEFh28e22DFX36dbNC9HnhzIeJlbSPGUQzg+Ui7Vqkkiot7YVcq+HtAtntKK9cT0y9sw8DAz0LDcCAYLYHvHrWAlGqgEMu/aiDdUku4BWqaXe8HgMM47m204WVOxeC9m++vTF6ldPv+ZX6R7PpBm61LXlsdsqPXWum3wT9Kszw0h8IXfXILoMP8/xJQOHJ2zY6DjnuKJD5CMRczqJD0aLefiYTVFe5WtoZa/M2pRZssH/jRbGN8SmArTQdShnx4YbHhqLf0gaBHawHo3+heOEtybCO/IEf3jP8GPRGA4cFSOu5UFKqItY7kCXLFZfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uj+oLP1Zlzeii9cfjUx76a6WlhbUGvAq8ftHjtbj/Pk=;
 b=IHHkO8bJtBI5x8P8nDGzLHr8un4WM3N+UtrQnhZqzgrI2nlGzQFOhUifSSOapiE1ZKPxRdUxBgEkbUWrzJ1QUMa6NvjrJH5Vgt+j3xqkyoFHiI5nMRNCc7fDr9DgZAwYnRhBcMveJTGhbQVewQ8cHwX3zS3/EvrCCUGV3whPV3Q=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS0PR01MB6082.jpnprd01.prod.outlook.com
 (2603:1096:604:cb::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Wed, 14 Sep
 2022 04:48:51 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::194:78eb:38cf:d6db]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::194:78eb:38cf:d6db%4]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 04:48:51 +0000
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
Subject: RE: [PATCH 3/5] net: ethernet: renesas: Add Ethernet Switch driver
Thread-Topic: [PATCH 3/5] net: ethernet: renesas: Add Ethernet Switch driver
Thread-Index: AQHYxE/FihGBdu/LPk6xtXUSKRtI763cZt8AgAH60PA=
Date:   Wed, 14 Sep 2022 04:48:51 +0000
Message-ID: <TYBPR01MB53417DF77C62F96844AEF59FD8469@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
 <20220909132614.1967276-4-yoshihiro.shimoda.uh@renesas.com>
 <Yx+z1gbdNuNM8scD@lunn.ch>
In-Reply-To: <Yx+z1gbdNuNM8scD@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS0PR01MB6082:EE_
x-ms-office365-filtering-correlation-id: 2a4b6117-2e18-4a08-7e2f-08da960c6b68
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rKBqO6NP2vSERLvOXJn4BlFChyLE3+dGFNoceKpmQWCx3JAGk6FeJ5ua0a6RMUxnQwyMGFrtmUQOpsmhimXFbSUfETGGoyNq1oFff/zdwSnFtKWXsbpY3zgzqD+wXOwDe8qVPP4BTP1frDBUQ3+ua5zSOwFNhI+IDZl6DVyzuJJQ2f3deBqG3mSSeKPfutI906x+r3E83rHgZ+QAFtKfEbUTGnhUAoEDfLcxai6PJZpSyWLKfFZBINoHKX/hUbxg09Tu2DXw5DQbUcsBPLia1XBnZ7lL3Q3ctjzj870ba9f+u1uZbaLFLGst/n7jJiLRK68jSRu4Yy/VUrNVWb51642kcuHTkWiuCfaugH10Ri8U5l1+Yw4yLFGEfqiLvoUcO2ZClVtD9a+NbCnnNSl7X/nylLEWSMCmIDYw0aCfnHo6T/go1l+PZ4LhmQpZmQNj81okSuaJx6tauKTg67vpjOF+6e78QDNMdDNDGlkMqbQymq1mI9cwvLx9G+rPLiClZ++ygCOHRRVGqjvpFNZYFDib0p0EYqfGtTSfb11bMHW3rZwrZS3rMyCKnBX9p4hxqK/vL3PnsMrBsLsD+GBuywPJgp0l99n0JRWROFKhOwZ81pgDSSbZAqPeG+nKsPYNv4/LxdejM8Xb0LY+WO4rqUGVJBBKxHQQtSqM2cmW13dsOiSNzLkhNXIRtTVE0okpMVe5rOTpanuiQ9bV3xruCM5a7FxhYwmD7JsrU3Zly4FpTudPUMaic+AplU+W+iIlSm1KOF2cOirZ2sKDoVPoRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(376002)(136003)(366004)(451199015)(71200400001)(316002)(7416002)(66446008)(478600001)(33656002)(86362001)(38100700002)(52536014)(6916009)(6506007)(122000001)(186003)(41300700001)(2906002)(4744005)(55016003)(8936002)(66946007)(8676002)(38070700005)(5660300002)(64756008)(4326008)(66556008)(7696005)(66476007)(76116006)(9686003)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cp/4rtn6ZDZBRbkh4hVk5WvaPAdOIx0JTkQfNl7l0DcRbBsIjGTXJ7BBoUdM?=
 =?us-ascii?Q?V2Sp4nvthIeTD5c72BbRG+aQcOJwGwAU0gvCafTFSmT1fyt4dVXVo/flw/0n?=
 =?us-ascii?Q?+YAZMRsBjNr0wkJj1/6MVLltNqT/WRH5WBPbgZRCdkCBNy1rNKhSSF5OrFcI?=
 =?us-ascii?Q?2gn/dTXnniGtuoFOKykLGs4UoToTkCfK4yiWeUULXczFoEENTc6Ei+eExSjY?=
 =?us-ascii?Q?jJEzk4LxqKHwn2YinkezzRgNp02l2xgajV5cN70LurG/L3lUWYnCTzUB0rI8?=
 =?us-ascii?Q?M68+wwI0j4PmIF65o3CcIxP8xDz1KLK//QrYfdnzsjDAT2ZFi//i9TfaAi5R?=
 =?us-ascii?Q?g9SWsUsQokfwh0quL1QlDDwPkWJ+1G6hpMntqCWNxkVnGLHA47nnre2V5OGJ?=
 =?us-ascii?Q?HQRboGAxWtLZWCy9k7bYQmSf/J5NnijPKHr8FsEPrmkoX5RFTHEPzAhNz/Xu?=
 =?us-ascii?Q?S8koRFDIMYA5H1/C61RuaEX0/C7bhuKO56k59dUgFPtxAw1GfEQdFdnpYQdI?=
 =?us-ascii?Q?jVKAvjul0WN/1yOhxfIAKj7mnIIU+nA0gZtoPSCp98QzuRbyGYcYwrLucpq1?=
 =?us-ascii?Q?oJfOLUbda7vMeOKNnFmSIKgALlTXquKKQbspcxVzSMxEtk/mkBj5ldy/tsz7?=
 =?us-ascii?Q?BpT+BBr9MRNFDBmN3tjRCyU/paxsDKPGBKlryx+2TxsBLuN90oT4j14Deag2?=
 =?us-ascii?Q?xQ5+6QXFYYgeg1O8kmx0oR84DWoW5o70zRFJ4J1VZfAqG2O/sF/B+6qalslN?=
 =?us-ascii?Q?R2dDxNgO3LellWhs5VH/1KHB5+zQwgIAJEqfhqPoKNlZECP+U4VgWvZFWR0t?=
 =?us-ascii?Q?Peb1ADOytmaa1eyANzKsiXSYwBlCVXU/WS7xz5ZW4r3uxtItfLcb+/ZC1iqI?=
 =?us-ascii?Q?aHyso0sHABuNlXS7oPqYegN7EIGn795nZd2kCekF6w94vQ/tPMw2KxOlGRaZ?=
 =?us-ascii?Q?N8GoSYpLhtOL/8ww20a/eZVwWjEf34i/RgJVa4+WoJ+Zy2OpewbXVU0Ak2hn?=
 =?us-ascii?Q?kCrXQjMFE121KkE/f1NTnW5dRqoSyVknNVnrysODr/NJqfLQ3i30IuO4ZU28?=
 =?us-ascii?Q?smpNA5AvDW9FNFENzQA04+BorMEyeqWdZctPZ3VvTCSpNN7NP3wxPsSiUC3I?=
 =?us-ascii?Q?wLdvXoJkFziX6WHskiE1ntStZXxess3dPcYsUYflwe0LBrmRw3lQRZRyFgk6?=
 =?us-ascii?Q?RVLODiLiPlwMAAIpBek4sy+U6utagu/HsrkmiqPo/deu6YaI1BkmwqVSUCgu?=
 =?us-ascii?Q?XSvJL5wqi49G6D63NJkCS6Htq9+NU5h7ihMRrYdJSmpME+9YK5d6Lzvd0Fuh?=
 =?us-ascii?Q?G4i4rJSLXtdVNGb1vwUzI1aLfakMKHXSNeV6B+fpY8e22edN+teuGmRgHOZx?=
 =?us-ascii?Q?kAMBtjz1jW7HzT8iMA3PTToK5gob03Q96WrcffRf4tlKM0IZ5cdUDjAGifLQ?=
 =?us-ascii?Q?RZJSxsRroj7MbRG+oyfxrwypR66A+NyYV55TzlnKH6wMZMaH0u0ePVcl9NPa?=
 =?us-ascii?Q?AaTmTLf7z9SBUfk/KET2GiJbX+/fWqlhBCHSlMIrUoAYk1yPvjXMDqGwCgQY?=
 =?us-ascii?Q?g2JVIpZt78yF4m1XddFHtmeE0DjLT1KHSzbCZ2kihF/gE0WpiT/4PfAymbSW?=
 =?us-ascii?Q?W3ryMnuENE8CtksqMnGA+bhq4JV4bk4CYLlqU/Alf5hUhRM8zqIL/BfpzzlV?=
 =?us-ascii?Q?P315pw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a4b6117-2e18-4a08-7e2f-08da960c6b68
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 04:48:51.1505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ku4BSK1Pl7T6RW4W2xj7dhNGla6BTW6AHnsoZp4Wo/EZc3V41vqtfFkSxe6pP30aDHDRkEuvbC197kLshHKpHJfg/86Vspg+P8ZgVRl+Xlb6tSuKxgSBPErMXz8rCta1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB6082
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

> From: Andrew Lunn, Sent: Tuesday, September 13, 2022 7:34 AM
>=20
> On Fri, Sep 09, 2022 at 10:26:12PM +0900, Yoshihiro Shimoda wrote:
> > Add Renesas Ethernet Switch driver for R-Car S4-8 to be used as an
> > ethernet controller.
> >
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  drivers/net/ethernet/renesas/Kconfig          |   11 +
> >  drivers/net/ethernet/renesas/Makefile         |    4 +
> >  drivers/net/ethernet/renesas/rcar_gen4_ptp.c  |  154 ++
> >  drivers/net/ethernet/renesas/rcar_gen4_ptp.h  |   71 +
>=20
> Please split PTP into a patch of its own, and Cc: the PTP maintainer.

I got it. I'll modify the patches.

Best regards,
Yoshihiro Shimoda

