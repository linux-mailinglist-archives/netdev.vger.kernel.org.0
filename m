Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84F965D71E
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 16:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239572AbjADPRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 10:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239469AbjADPQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 10:16:31 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2118.outbound.protection.outlook.com [40.107.212.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2792411C3F;
        Wed,  4 Jan 2023 07:16:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePv/c5gFQCRX5EuqnJ/IlnC7/h6j9o+ZAtgAHMnvhJzPaw70Z6R9RbXq8f0Q42lnWI2pcS5SjZdHIfM9LK+ZYz5M5ADUbB5NoF2/I0OJS8/s943MTCBlPl2H6bBaQWqzSFGWkk2wf38Z7MgWUOSe5evfVdzDibm35QLRjP6CM+S9ByeSVSLLjK/vUmK2JVbTWk0soufNUdcLXRIuuRN3pnbYA01iSWHRbUnG/LqKiakP23dRaG6dHBAvxeDPALrgTrTbAEOe8JEtV4vfGfsCnSrB+f3dC3GKjDTGqRTToPvffNWyeMs2xPpb5YMhjE5qbfgXVJKt+MF49T6GyaNb3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n+IaTL20KqXT9CdgvhuiuizJz+6iVQB37z47atNM354=;
 b=T9T8T5j8r2qxuXQR7Rz41G938AaGWObgrjXH6zUDbyCKcd30ZpJTzm8Ecd1Audw/rjf6TxDqTrvMR0saD2OHBYJ078qlA/HJOoZB0YECuXRpDHoMnkLSJGCwSpglInS7VZb0yBpXI0doFvPP8tIW5BWhXKk2zEYn00CyLH1prz4Jy4Sz4LFVlEVLN/LubjLAKPetd7RxUHDeBLEwbT1NO26FCdDTZjlm4fxrEz48CrZTVlvjUCXo+nmihVOgmB2XKh4LrYNHJ0eFThLL3swzqQyT0cB1LlOQcfH4A7811BtHsJyFqlZ4jdd/WOKkT5ctKRAburgHV3mmjZXLhSfjjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+IaTL20KqXT9CdgvhuiuizJz+6iVQB37z47atNM354=;
 b=VBKj5DVlw81C2ktMtW/EwhDzDEJ09G/1IpwhR+HfHK3S2LzXlSJoyZNIsKuUk+8rDWYRP3GxQdlpFivgyglgXb2CMJBEWWBl198AShg4L0zDpvwOMvwj7vyWTGInWFH3D6Ger4kUI3Td1NGjrEL57IxDRR6rY+mbg7qKZ6eSmtw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW5PR10MB5807.namprd10.prod.outlook.com
 (2603:10b6:303:19a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 15:16:25 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 15:16:25 +0000
Date:   Wed, 4 Jan 2023 07:16:17 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v6 net-next 09/10] dt-bindings: net: add generic
 ethernet-switch-port binding
Message-ID: <Y7WYQfFnUjy8ygyR@colin-ia-desktop>
References: <20230103051401.2265961-1-colin.foster@in-advantage.com>
 <20230103051401.2265961-10-colin.foster@in-advantage.com>
 <20230103175641.nqvo2gk43s3nanwg@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103175641.nqvo2gk43s3nanwg@skbuf>
X-ClientProxiedBy: BYAPR04CA0035.namprd04.prod.outlook.com
 (2603:10b6:a03:40::48) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|MW5PR10MB5807:EE_
X-MS-Office365-Filtering-Correlation-Id: 637fb156-52a4-4f95-2c18-08daee66a4d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QJPhjUtovYuE9eENfTBUYbf16BCuzCB5qOgr41i6uZst9OVRJ2d3QAFo8z+83Rx1Fh1u3fKVqnTbJxxvssPFwe0YSC5gVNvkj5+lT3EQU+kFvxNkyPU8zzXCE6+H2WhGG2xazpK152Hpw2ZN+qy7M9FnW1KWIwqn8eDEV9kFJmO312SiuK0v3E4qNcRz5tCWQuT35r7JQ0ZdCWhxRQ3yvy5X7+5ub/1439p373NX9zU1qCfQWl+3O+TVwpY8f3FmEsTloqyaEOH3w2dAq0oyg4FtZUU5l6YmTY+tvp8FOkoD02og71r2h3rG8jbyshyBt1ncuxdkCUtLQDzR2B2xymlTFPMUh7dy8v7PJ/IDNCc0vkRqK7ndDzMy51IMdvpQaiAFNrhM1Smc/TcXDluIXGQSiqMDSE+i6u6uoVn3Kfe48blWn0FMDhsxTKxSeE5/RbUg5svn3ZCIB7owiAMXey/uOxm9/lBV3X4mgLISB/4FFFB4IlStcEKd1ux7F1OHiRtevDlK4yQLB5KJbxIsDHoLmW5um6FilEqpiXP8+NzYzd9WbR4RMY9VPbbrHVj9ndFDYYQNRk4auXu8davrgHO3kWg3ND6uTy5ZbouluuF/VyyGrutvjRX+59532fCQwMFXSbZti827zSTCIXuK35aIWEpyYR+YLk4Mbgrvo7VZGEcqifmPUeWuucmFyGo8EvGQia6+EUsMHo+0jP7Biw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39830400003)(376002)(396003)(346002)(366004)(136003)(451199015)(83380400001)(6512007)(9686003)(26005)(33716001)(6506007)(6666004)(86362001)(38100700002)(186003)(316002)(4326008)(478600001)(41300700001)(8676002)(2906002)(7406005)(7416002)(5660300002)(8936002)(44832011)(66556008)(966005)(6486002)(66476007)(66946007)(54906003)(6916009)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mIYEmQTpFrn4tZeYiDrNVtG/F1n7BroSSzj4XWH35FXfhfMzzi78mKbXyY+r?=
 =?us-ascii?Q?ro4RnpIM3eP3mrX8bE7S56oK1ujPMeAR50q7lm6rsh8FN3owRGUe6/2TDdPs?=
 =?us-ascii?Q?Q3iw/8JBWxo5knTuL1VL2sGB6sJ3djbWj1V2a85b5mezshT3rwLtIQhBaU5C?=
 =?us-ascii?Q?sWt4GEyzHveoMQMQ2TlX39QB0Ka97JOR98edWFZou19rn+Ur1yyv2qJRBw04?=
 =?us-ascii?Q?k1h4M/7atkjU4BmgfxyGafN1Q0PPT2/jExpVrdhIRwewp8cmLw3IGVmZFDtO?=
 =?us-ascii?Q?qOGJyHhGbyiALBFY6kex4Z9h9eltepBKZ1BrnyHf8dwXXrlW7bwk32e92dy3?=
 =?us-ascii?Q?kdoxId385oBQ5Cjudwu9MA6ycI0D5XjGkH6zQ8WKmHkvNfBhgtfxy9uGqBHU?=
 =?us-ascii?Q?eYmg4RZmaKpJklQ6VACZVBljWJpUUqTSomFanTxKaRT1YCVS+0hASuoMj7uA?=
 =?us-ascii?Q?j8Dwsm9cokNXpHe505EWuJ3F6+ymYHitgd/gKY9XbYih8TyiYuBAbXlz0Xdk?=
 =?us-ascii?Q?zN1FoYYZaP7eGQTzfIgj6W/FbFgLK2j4leAm14miNwivcioL3alvHHxoVLTo?=
 =?us-ascii?Q?r35eEkXLmBu8Il0As1yBOi75/IhZJPffcucaGD+Xot3qgsZgBlApzNjBMRXa?=
 =?us-ascii?Q?aLSqYp++FouSUeVOXgE3xnyaSVoQZUdJNBanLGQl80uee86RaZ22cCjAY/Bd?=
 =?us-ascii?Q?21tH7gODzcINgpqZ1R35cL1y3RLv3NIUVgHk2sVjWng1noN440DlQgC1Crph?=
 =?us-ascii?Q?EgYdrjz5ea1RT034kbmjJ2l2Nj5IUQ0CmLGR5asfPULq+g8Dc0Ebh1bKalan?=
 =?us-ascii?Q?2WhnfMd/UKz4/jVJEHhcRusOCfnb2GmxYDMlPRpVmFtrM1Bs8qRDdRgNOqlf?=
 =?us-ascii?Q?MGalPynGNjsYnMI/Dvtx0zgRHnbUiC0HmgqiOE+arPDlR31q7e1ORUHfijQl?=
 =?us-ascii?Q?BDiwpcHvqQZeN4nTGqBs03GdU10pESKOehLIQOP1HhbC9uwjFBXd47DLxK24?=
 =?us-ascii?Q?HKvT41kQd36bmQbQCN60DDKCRDT3+T34NmY243Mo4YDFEWvF9d5FwwbAXYLO?=
 =?us-ascii?Q?mKsMaAxfiF79v26zyE8PddGkPZaTNn8rcy9xPJVjfjiQ4qEKyTP6AG9vi43b?=
 =?us-ascii?Q?gEprW099IXOwppPxiCptILMxcQ9wYhRk1D6UACr3Aq48oOA5V4ZGHLvTrU9v?=
 =?us-ascii?Q?D9fcep3/ZVTFTOn4fsFJtnAAmlJG6a2gUKII8kSrBIxIyPJUGqQrWTNUTh5K?=
 =?us-ascii?Q?r6DcLkpcX0n2YYI68/lN8x/5B0PhpJJowCd+OrxunJBtnnS3L2fNjnCeDGgV?=
 =?us-ascii?Q?C6lQZu50chlITIctkxQeTXVKQOJKKjYRISMYBN4lTbMZy4CuCHWAlnqI+7fY?=
 =?us-ascii?Q?d+Hd+OIoJrq3iLk0OaQ0qv06jQQ7yPQPkwzbDmse6GdqO1oe2ie6qtGbTWOT?=
 =?us-ascii?Q?D1FBpSFX4520H9LxulfOdDh/XFY8cFfGLyqStW9py2L2/VM3j921sqD5kQXQ?=
 =?us-ascii?Q?5S6yxXa4meqTsSimJ2IBfGkojTB23E3OmgDjoec4FXJw0GTIHkeC2qyhhRn3?=
 =?us-ascii?Q?oGS3DNtZrVdpi/Euxgl5MtFe9CmROTXYaHRAjOxoGYSzk6rGF+DfI9eXRs6+?=
 =?us-ascii?Q?3A=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 637fb156-52a4-4f95-2c18-08daee66a4d6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 15:16:25.0764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q+0S9hr+UL2LwAAhLg94tclt4bJG2GL6XdJJ4ekiyGVIfdSVkX1xLs+1o1yt6YugGECB6Q4lLYIpD922No+zPw6zqW2nlWoc1oew7edEoY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5807
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 07:56:41PM +0200, Vladimir Oltean wrote:
> On Mon, Jan 02, 2023 at 09:14:00PM -0800, Colin Foster wrote:
> > diff --git a/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
> > new file mode 100644
> > index 000000000000..126bc0c12cb8
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
> > @@ -0,0 +1,25 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/ethernet-switch-port.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Generic Ethernet Switch Port
> > +
> > +maintainers:
> > +  - Andrew Lunn <andrew@lunn.ch>
> > +  - Florian Fainelli <f.fainelli@gmail.com>
> > +  - Vladimir Oltean <olteanv@gmail.com>
> > +
> > +description:
> > +  Ethernet switch port Description
> 
> Still doesn't look too great that the ethernet-switch-port description
> is this thing devoid of meaning. What is said about the dsa-port is what
> the description should be here, and the description of the dsa-port is
> that it's a generic Ethernet switch port plus DSA specific properties.

Apologies - you mentioned this earlier as well. I'm not sure how I
missed it in v5 (and therefore v6)

> 
> > +
> > +$ref: ethernet-controller.yaml#
> > +
> > +properties:
> > +  reg:
> > +    description: Port number
> > +
> > +additionalProperties: true
> 
> Also, I see your patches are deferred in patchwork, and while this isn't
> really for me to say, presumably it's because there was no announcement
> so far that net-next reopened.

Based on above, it might be for the better.
