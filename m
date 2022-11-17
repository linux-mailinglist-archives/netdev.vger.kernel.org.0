Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7792662D5A2
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 09:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiKQI5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 03:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239402AbiKQI5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 03:57:30 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2132.outbound.protection.outlook.com [40.107.113.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F160A748D4;
        Thu, 17 Nov 2022 00:57:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QT/3pbiu4DrBV/G8ZjNlm0YiC8cvSGLVw9AJZJpxWw/yGbkUyjdFF97F/+sfLXcGEgvD+aZywBGZ8hfOY4Y8UH+42dKOMaPyRn3SRuOZrUbMo0lwJp2Cjxzut9ra5n9kc3KEwKLJBpk5uybXg2sXWSV3tl6s5bVyhm0AGjBgY+irAhM4Fv1EX1y/XUWHwCmcYL0OIMX4ygQTyGgHJ4Xwc25Y08c4yYx0HJ5HYGdDq7pvpxUa38GvBr6fmIBtIs3jjnOGhgwQ+TtR3deNIZfR0f+nsxs1JoEZ6Vu3XJlJHcFpEG1Acq9PcUd81lUIBSvBBTNwQ3BdAgdp7DpTUh5M+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hF/nOuL2vnJAAnv0dvsGlw8mKRMrVfWn8cqfUjDRhIg=;
 b=Z/irxMu2kE+z2fwo1LCQLwfeF/TAfUY2SdmEzxJyVmcmK+kcM+KWpnJ7GDbDeDkgpOUFww1FW6b4kMF1uViHilapniB0dBeM4FCbwYkKQBfZDbwvURqoBgX5JeHjj0CeSuqmPI4ux7rn6NHdmObiJMu6q7iTPlL4Q7rrY+YF4Tt9VZcb8qbv17gK8cjzBofuOmhriDiE65VTEnvFgXeVi9JRrZN0KLbrqJHZn67HG6YRgZkKDQ1+fgFcARVDLcZOMG8SZS7c0VdGOlHZPFc8+TJr8ep+p1c1nYG8EFYFoNU+Z7RvsunOlKczo2/vhaRtahd2q5Rc2j4AnNMerYuNAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hF/nOuL2vnJAAnv0dvsGlw8mKRMrVfWn8cqfUjDRhIg=;
 b=aqEKSwa46mPHdWBdHY/mV2ZxxoRF+johCDk1RqEvOZDJzQ4UK28m8SZkAC+xd0Cy5cDxQuZ4hT8tQfZsKngMPzr8aWkVlcPP1yWbap5x5KKY3xh9UyXMtferwgsjlnvXA/MdwFsIbcne0z3YBYt9WQfPww8mRMxZFgiap8QnpZ0=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS3PR01MB8384.jpnprd01.prod.outlook.com
 (2603:1096:604:193::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 08:57:26 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::cd89:4a4b:161e:b78d]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::cd89:4a4b:161e:b78d%8]) with mapi id 15.20.5813.019; Thu, 17 Nov 2022
 08:57:26 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Dan Carpenter <error27@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: RE: [PATCH] net: ethernet: renesas: rswitch: Fix MAC address info
Thread-Topic: [PATCH] net: ethernet: renesas: rswitch: Fix MAC address info
Thread-Index: AQHY+U28RnERYwPjUEeRyuo9iuoUG65CL9uAgAAF3oCAAJwLEA==
Date:   Thu, 17 Nov 2022 08:57:26 +0000
Message-ID: <TYBPR01MB5341200FCDC18D4CEFDD030BD8069@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221115235519.679115-1-yoshihiro.shimoda.uh@renesas.com>
 <Y3Vu7fOrqhHKT5hQ@x130.lan> <20221116233553.cr7ou25wbz445kt3@skbuf>
In-Reply-To: <20221116233553.cr7ou25wbz445kt3@skbuf>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS3PR01MB8384:EE_
x-ms-office365-filtering-correlation-id: 35b42926-1291-4885-1b87-08dac879c009
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /nYMsmekA2e2JfH9eS60BSrCJfKFxGDf0XMnXX8L+h9cRwq4VyFMRBrEhGpSklMdYtQnEwrNMq9+ChubL3oSxhYVRfOdTLG2BXquRHMDt696I5rzI77UKt23bQ8MK1lMLd8wte/nDqF7oJuKAC9qpF1gF688LSRR0q2eBZBws5PVuPmdq1YP6RklImnKPCV4MfC66yLZjiHWLqR7Huv5DHVArWxFADJ+RViefmbisda/NgGws+6iv8pi7d3fbEexBGfzHsU5+wlwoVUqHySixneN7uFjT5v3C/R1IRDbYPjm8NWZkqMII3MChD04mNu/YrGHVNzHH9YJU1uY50Fe4sQsHrXIPQFKb1IYCDraOMwbTndjl0dOsqMdDAC9v1/9HcxanmEDw5WkP6Qsxmmbg4C71VWvhPLlFLNFsxHsiywIIJeJPRvCvshTVFN9oVwTVXKtVSaH9VC/8ds7WnbYrOSc/WFjZVLFyC8BPNkaUuI7L5fYAkJPggxXweW2eetRQ6UfsxGemZLyxd6DR+Y6lu1JMNP247XRNyBlbofyzWtJye5OFqKB7Ce2F9J2If9l0zDjddMRzZ+kyiKDOBgAK4k5imcGnjppfSBHLpCZV5V3GdbDOsF/MuOOruAQwROSKmmAYv4aqFgPjVOZ5e7cR8WxN/WYO0EXxivUbMMmP6TtTonJrKXdbRooweW17vsQvF5oHBPt/+FHb9IMU38/uA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(4326008)(33656002)(54906003)(110136005)(7696005)(6506007)(7416002)(9686003)(41300700001)(66556008)(66476007)(66446008)(64756008)(76116006)(66946007)(5660300002)(52536014)(8936002)(186003)(316002)(8676002)(38070700005)(122000001)(38100700002)(2906002)(83380400001)(55016003)(86362001)(478600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LuvbOwM8R6aBVH8EGBND5E4j2QneccsO/p/P7XKIJekdDD6CG/aLqLCSPnhz?=
 =?us-ascii?Q?2xKwMrPLKKCORi0jDeaylx+KjOOJA/3uBWomAWT/Jx0ZlUorHZTMGp1nUWs3?=
 =?us-ascii?Q?lL+E0mAaJSi0t4qJjOSHT9r4Es+hEUiwdoNusLVhbQZwYphFqaa/unr6J6hf?=
 =?us-ascii?Q?oRAF7U+NzPr4fXlPb2Zjp53UqCjBvnv12yuHNdfQI6Ad4jY5RUXY6S7cxStJ?=
 =?us-ascii?Q?PMAIfXWBZvAM4mboa5cM6i56osUTNL+jzxICDdqWn7OUnvQK33ChTeUsCC0a?=
 =?us-ascii?Q?STmnTiE0nhcF+6JfIds3rz+XWoc1dNVM2NEy/N9SLm6iNyetEA8Pd4Qi+DG1?=
 =?us-ascii?Q?iMhDG3gQb0H/fn07s45KLCfjO0JNRuglUNLAoyJQmXLVwwiJ/VwPMX+19Gg4?=
 =?us-ascii?Q?a33mNtqqCtyyv0OoWNzO8bAtxHRtnfC5MG9qroQOuymjZRhDCFweiBP9Z20R?=
 =?us-ascii?Q?ldlwHTCmU2KFtRFsgDak+E6vwbp56k9KYLMN2+ronr1lwP22Is4fX6II6nqD?=
 =?us-ascii?Q?m1Pw9UiLComSnRV3AgEDVbY4bTmhLAMqbJ+2R4FjReKQXpsx5pph0LOuuoUY?=
 =?us-ascii?Q?Slr+wlGR9AjhMfud9Hckvj4eEn5U0fMlLWwkhnCSyqzfPgho7jiNN4FqkhpU?=
 =?us-ascii?Q?tvXDM7asb9jZQOJi49SxTp54OUQb8GZJjvLJB4NhatdYeGhD+NFfYWLWERsg?=
 =?us-ascii?Q?tzUueTArguNzmzA8YbPi+gB/EaAEKR3zqQgNzCLUVZa1VQUs9pSAvWjTT9SO?=
 =?us-ascii?Q?GI4mtJiHdZKuLjz/IjHn17L0R9rCr/pMSsGhm3IJIANin+aq+8axLFZsMKE+?=
 =?us-ascii?Q?2dyUpg8DiSL8OJTrpr85JLM2bAhr56+FmOyK+Raow1IJQtDt4soe0G72jpHZ?=
 =?us-ascii?Q?IzEgVZeBNeZ2Eb2/iqAJmDhnRNI8ydig/Q2XlDN0uQnSji74jbYwvpp9rRvR?=
 =?us-ascii?Q?nRQaXcxXr4OU9N66wbV9VlapCgc97XkyPXqirDY6YEnCiGXegrEC606ygslb?=
 =?us-ascii?Q?nUz2Aa7o4T1f/yUranDcEnHMSROe4mKmNmowsnzhsmW+LhXAVbYY9KOZSGjR?=
 =?us-ascii?Q?/15aQ9XFTNOFi6gwDe/n5LbDR1qC/sGJjYbZsE2GSXyqXRbFyy79p49r/LIq?=
 =?us-ascii?Q?f/vU4Cq8PU4NMtc56/xvO6Gket3Vb0ik0rylj/0T7/quxkvJkXNXL8CcfviL?=
 =?us-ascii?Q?r/9lExRIqANi82fVfq26v13b3rQKDRJS32lmG/fgdArDYyKjG95EoduLlS58?=
 =?us-ascii?Q?2o0j6ujqJ4kq+EN9+RHjtJJEuEZGsHP3BbeNwRYP6EXwn6clqvNzUCCgWcUr?=
 =?us-ascii?Q?tq8SZYUF0kgOxO703DibEMNuniyViXjjkCiN5rHcevhYHUPIBolM2a7OdXnm?=
 =?us-ascii?Q?VJDr0iwWhDFaElMRxP9HNr8RoxdVKjytzZxQBouT0CVBINDnJ5RpEYzCxoDg?=
 =?us-ascii?Q?V1+CpBc8+QwmHIiWOYpK8mvpii1FV0OkuMRNQKRbKuHJfoMioiSRT57Fx4Lh?=
 =?us-ascii?Q?ldCw6xwl1WLncRW7BLaDLRX2pup538aI8kWjkyaTJo0Hi8JELvPceddAn9B4?=
 =?us-ascii?Q?iaC4LESpozTmCMYxO5Ef1zPyQQ1i/xvgs/7x6dlYFc7gWNLAtlCebH3H3jbS?=
 =?us-ascii?Q?WTwnfxgvzfVtj9sh9Vo6n6Sb6YBNKnvBufo25eSbyTx1msWDK4aKmLYQEji4?=
 =?us-ascii?Q?kvtFcQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b42926-1291-4885-1b87-08dac879c009
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2022 08:57:26.4610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JpCDh5iNaSwv/Sj4NBHK8jew/KKuDo0kJOOw8BH9/qMFths9gRHYxCXf863UQycZEgFIzF2q/+Zba9I9wdTkrawi4yQUj5Y+0xbnMp00i7GuDShs8cl8dS0XxH7eBV1S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB8384
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> From: Vladimir Oltean, Sent: Thursday, November 17, 2022 8:36 AM
>=20
> On Wed, Nov 16, 2022 at 03:14:53PM -0800, Saeed Mahameed wrote:
> > On 16 Nov 08:55, Yoshihiro Shimoda wrote:
> > > Smatch detected the following warning.
> > >
> > >    drivers/net/ethernet/renesas/rswitch.c:1717 rswitch_init() warn:
> > >    '%pM' cannot be followed by 'n'
> > >
> > > The 'n' should be '\n'.
> > >
> > > Reported-by: Dan Carpenter <error27@gmail.com>
> > > Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethern=
et Switch"")
> >
> > I would drop the Fixes tag, this shoiuldn't go to net and -stable. and
> > please tag either [PATCH net] or [PATCH net-next], this one should be
> > net-next.
> >
> > Thanks,
> > you can add:
> > Reviewed-by: Saeed Mahameed <saeed@kernel.org>
>=20
> You can have a Fixes: tag on a patch sent to net-next no problem.
> No need to drop it.

I got it.

> But in the future, using git-format-patch
> --subject-prefix=3D"PATCH net" (or net-next) would be indeed advisable.

I'll send v2 patch by using --subject-prefix=3D"PATCH v2 net-next".

Best regards,
Yoshihiro Shimoda

