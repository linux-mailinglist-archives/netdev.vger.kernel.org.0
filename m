Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064CB6054AA
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 03:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiJTBEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 21:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiJTBEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 21:04:12 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2116.outbound.protection.outlook.com [40.107.114.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC43170DFB;
        Wed, 19 Oct 2022 18:04:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvZyulnRczlb8L75OqXTlcKfaTfWRmG3POterErJpmYkV7ssRR7bpmaSZtlbQzQsH+VzkX97gn/jqSH2w76R52UwNHlLMXxEIXGlPqyhIHbsJDs0+R9rSlNc2c6mYoc4F1xfGle6POMojUfHY59U9ygtVahblTUxNjq5PEOQl0YAsraxt21uqN/yk6qPhL/L0emtFL4bdh7giZyjboezqQTJGOjEtA5kOUkzf21elbfKlyzoXtUn+sVJNbl369dhjdufhpxiPHrkMs6W2W4kiFhjrCbc680aGyvwtKGOxI+WKOMAnXcDug0gxVOMwsYnjdkGej96tcItdg2088mMBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ThHcdy7bV3KiaHiv9kgrtAv/a0Gsv88+oVii9aAS/Ik=;
 b=SB5C4xG0KtSyJUIcSO4ojdkVXserzoM6T9oWkNy44fY3pUX+Bzsh5xZqwCIfONnycUQ81xupslIrNtX6wB0NOJMq/AopIcj6610fU434DPv2qUjiSM3/Y+6+lGFpt0Unzg20gx96jCBnVHB7xxvJcmkSb8WLv76eQjoSsH4UM2e1DOH1LeLvBhOwXEBJ7sdK75r6TG9z4Ae5Z1a246eqCXArjDVM9Tik46/E1eZ4ueOMZlb5oQ/TsuBKf+Bf976QCn8ZV9dqZ80jAipsl8YbpvS1hR1sFP/MMUwajjS61MplUoj2n54gWpfmTvIK5Ry6EDcFZ3XrfIdn5O9gEMoWdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThHcdy7bV3KiaHiv9kgrtAv/a0Gsv88+oVii9aAS/Ik=;
 b=K7d1a/as7LO+Q3WycBgKBwRuNX8P0DdH8Kg1MaQYRJQ6MCG3JYXr7+NfXnYGvDAUK1GyU9vTi+jBrwdeaFtUFiPlIEdyrDoG3srCA035BzYQW55IvTw9hHtT9jXU/A+Uomeel+pX93M9uYGaDtJLHKRAwQ9ptapo61m3xTLaeyc=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYWPR01MB9660.jpnprd01.prod.outlook.com
 (2603:1096:400:232::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 20 Oct
 2022 01:04:08 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::51b0:c391:5c63:4af4]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::51b0:c391:5c63:4af4%3]) with mapi id 15.20.5723.034; Thu, 20 Oct 2022
 01:04:08 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH RFC 0/3] net: phy: marvell10g: Add host speed setting by
 an ethernet driver
Thread-Topic: [PATCH RFC 0/3] net: phy: marvell10g: Add host speed setting by
 an ethernet driver
Thread-Index: AQHY45fxzGX2A/ma5EGv/JYGm3jrC64ViGcAgADpe5A=
Date:   Thu, 20 Oct 2022 01:04:08 +0000
Message-ID: <TYBPR01MB534194A95766D08669134746D82A9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
 <20221019124442.4ab488b2@dellmb>
In-Reply-To: <20221019124442.4ab488b2@dellmb>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYWPR01MB9660:EE_
x-ms-office365-filtering-correlation-id: eab5576f-8f20-4749-857b-08dab236fe14
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2UmB0lhctC8iSAQgQ5IW6mrtqI79AjcuFw1+WkcnaGsGHlxJLEr4QiDfo8hVae+9/9eFyKdYug+/A44tBQtPKWoQ0BbY8Dlb1Ixgzy0G0M+YO3zU3K5L54j5dGyXSvZcHV6eAzO+E000mJ2Or9ma0TXN7VVQQRLq0D4pCq5mLYsIMzXc9neW8nsjf0HSW2BdhbJSIbDzcAL7+IOjYhsVvCx+xhj5NLvekJxgIrSKR9uQ3r6EwkUHrd0YuxuohqTtgD+tP27D4KPzOEwJOgQraGCFvGtfo8RK9SY37G54k4DuOlZ7wGLySge/ny9WuRP1xDxGldj6QCLy9x4hPBPGcdiVoT5T7SU3pWaqdrE8IMWoeHvCJWH0yKmFrmDcDeZHrwa53Rg+evPm5Hwoxt8rBH71ou7xuMascIjDM2L0K3aGQP0PfwaFKumANxjzcVsP5sO4jtlcLR7e7gDGQdrXgsW85H4IKHckSrMyUmm93IAmTRThcG78w7iZ8DZMD0BZB+VQ38eA7ediqbbNybchx2uGjYxvWvQz5EMfc9gGoRg1MvbImBq7Mn+3s03AxmlhHLDPYHnS2XapzJ7+r2+ecXetsNz3DSTS2pv85V6wWifFQWcPjgRRllFGLuZUykxMhDJRSdILIv5V5I7k+11UXBhu9d0VBMIJKfBCdBKNC51f169T3q++/FdxfnvyOBC70nQQCnrSMmcutwU5sQ1EKwAmdZmfT0l9IILaX7hqimTWtbWqT7YaeVxdzgqI3kHBervjSBUutbEX9SiF7NSE9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199015)(33656002)(86362001)(122000001)(38070700005)(38100700002)(2906002)(55016003)(5660300002)(4744005)(7696005)(6506007)(9686003)(186003)(7416002)(71200400001)(66446008)(478600001)(316002)(52536014)(54906003)(66946007)(6916009)(4326008)(64756008)(66476007)(76116006)(8676002)(66556008)(41300700001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?p/MawtxvWZGyqo2fnWXWJkxqj3spELmLZOaoIM9FoR/fG63/0xAmm/oT9G?=
 =?iso-8859-1?Q?WZy874lC+UbKjve81Hlmnunp1/NeIm8cZc0Kf2NPhpOww0AkisPTWyewau?=
 =?iso-8859-1?Q?uVLYt1pt0w8dGjo+By6hFtfXvXbL8+UF+P1mvlmDjeSnCfEtYg1Han7pUE?=
 =?iso-8859-1?Q?rlolaCyjv5OzZlx7NciwB2bES//e/emSGdnW50gIry9G/IvwtJA5th8SNd?=
 =?iso-8859-1?Q?qoW2EmaYNiNSIMvTwRB8oWakH30kyI7XAVu0S2C6xbLt2JseSn8lKClBnt?=
 =?iso-8859-1?Q?L6Fdos4WG5hU35hWxT0KAS9TAGzDATmcjkla5CjgKiv9PSoerjhXQEWLBC?=
 =?iso-8859-1?Q?oI2VyANzcQHKDd9DU+T8ALegKNGK1LJGWR6tboRJpM8u7ilKIxGE9l5k3Q?=
 =?iso-8859-1?Q?gwx3KjGeo7i9xmjTEH7mmBWOIEVfFfd/YAKLRC1BQLoIqnGR7PS8h0PF6F?=
 =?iso-8859-1?Q?6f0/B9w8sHNwrK4mnI+YprhKJhEKZjYM0JQM/wNwB6ldF67MrYUbHUqpYb?=
 =?iso-8859-1?Q?fWnV/aA9F2fSx4rJRLg8+jk5Yx9AZLBbdw6ULtIzvVsXZVVHoglZEJgvMD?=
 =?iso-8859-1?Q?THriP79XfO/xJxUDSNDNzUUnvJCRd+P1HwiIViaj3qQp6a4Hg3Wh8/B1dt?=
 =?iso-8859-1?Q?6YzLv/6AiFdafAi1kxelCq52Y1wb0vAsvvmnsTHnLFGGuPYWjp/L+Ma+V7?=
 =?iso-8859-1?Q?U6xG4CR+iHZ2rP38XgmkBeDhgCjevYLcUXOA3bCMm85SH04kCDQ9LlZK6s?=
 =?iso-8859-1?Q?AUuSv4roipNrp+CGjeq/noA8txbt+X6SwmnySYcG4OhnVxdGhvJQhRxLHS?=
 =?iso-8859-1?Q?5sbj/HCsDxtR8BZY8rBdxTMFYfGIo5vHXisnHkxeBU7KN4lvfLhjdsK52A?=
 =?iso-8859-1?Q?x3OaE5T414M24/k0ge2P8DS0DLH+2AQQOhnlrr0jgln7tJDLOMyBxDq2rp?=
 =?iso-8859-1?Q?G3m/p7lTEVYY866MB+WqzUGY7Wg6e/lpikC+kguIrnlFWrQsXrbDRS/KyT?=
 =?iso-8859-1?Q?NVFWdJOFw1N/zk0z+RTX2JayMGiKgST67XYw+vV1Br96dqSeCDU6tBWc86?=
 =?iso-8859-1?Q?IfSvAQKBQjU+6bWfId1aFfmcfIAdbl3NE8WLO6uIJlpR2x9W4vReOoSOPc?=
 =?iso-8859-1?Q?7SbVqEOdqp+XAhoxRG6lV4HCLyCEQiHHswnx5YB+cCGfSpOlHjyXws0PkP?=
 =?iso-8859-1?Q?Ac8fQzWbG47YpGTEA3e7VjHkrQTtyd5JC4eb/s4cA+NkHa4YX/EHBCPlY5?=
 =?iso-8859-1?Q?HAzxDxHTzRRxSrbj8PuVFfDQuepPAz9Gq3pza2mU99shTu95EOaRmztH34?=
 =?iso-8859-1?Q?tbZn3bdQMXuZcJ3x+Y6N14hVS3FBC5wsDbMZkYYTdksme/Lxv2LHTlGhTY?=
 =?iso-8859-1?Q?TtOvQJ8ZcPA4Asqj/Qn/fUZOpt5HAy5kjPSEc9jvquk7uLIyyArSlVcI4m?=
 =?iso-8859-1?Q?xXc8c7JURjJaB1QPkQ3WDY2ji5lvYnk6wvuNg4hqmNstLOHJOc1ydakTo+?=
 =?iso-8859-1?Q?VSGX/BCG0MBVGmR8EOSFVgNAYynp2nUZ30kIm589EGK823qB1AgIRHinEW?=
 =?iso-8859-1?Q?GdKvm83Y8X/wEuHGbC11SEnwivgPDCnFTtTWwl1j9rf9DW9dVHlcw5LGLi?=
 =?iso-8859-1?Q?WS6yJjrqJ6uLmji5LA4LfxwE3NoX/CBlYoL2PVQHr8bOse6nlPcmJdHT9A?=
 =?iso-8859-1?Q?pG3+BksmFKD3X08lOOxHt1VdAj+LFUdiQ07+c3XlLSE1gVXHs1ohDBGMWk?=
 =?iso-8859-1?Q?LdMQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab5576f-8f20-4749-857b-08dab236fe14
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 01:04:08.6769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iUG9BF3DKXyeqMWq31YG3Nub7LYU9K/9IDPDo7clkuHr9MiTURTiTJ4YCv7zKk14WK7k+nYbjKkzDJYwG/BkFGJC3qHQGHGu10P0ggibLevnxl9Y4Wp4GrIi4wVms40m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9660
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

> From: Marek Beh=FAn, Sent: Wednesday, October 19, 2022 7:45 PM
>=20
> On Wed, 19 Oct 2022 17:50:49 +0900
> Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> wrote:
>=20
> > R-Car S4-8 environment board requires to change the host interface
> > as SGMII and the host speed as 1000 Mbps because the strap pin was
> > other mode, but the SoC/board cannot work on that mode. Also, after
> > the SoC initialized the SERDES once, we cannot re-initialized it
> > because the initialized procedure seems all black magic...
>=20
> Can you tell us which exact mode is configured by the strapping pins?

Sure. The port 0 is:

CONFIG[0] =3D 0 0 0
CONFIG[1] =3D 0 1 0
CONFIG[2] =3D 0 1 0

So, MACTYPE is SXGMII.

> Isn't it sufficient to just set the MACTYPE to SGMII, without
> configuring speed?

If the host speed was not changed, my environment didn't work.
The SERDES of R-Car cannot linkup with the PHY.

Best regards,
Yoshihiro Shimoda

> Marek
