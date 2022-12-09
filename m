Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A17648922
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 20:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiLITlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 14:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiLITku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 14:40:50 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14ECA84A2
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 11:40:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WoA3q5Yld0HUYC8Samji9j0dn8tSbsalsIqPIdsrKpYHRqxp57dVDT82Lzaar7bpGW5wvdSfau6Fcu/iWSWksRsaHuCvxozTowUQ/ltHHeYYt0+d9UcGL6Gn9uBXzWbhzAFLWElSuTPfSoi/bbyxAUkhcP1+7h024tbTOC2Y1vMdRrbY0c/gI55hfz4IiiMyef/OgL7OeoNcn6r6TDGffAwwzx2VPXiFMwP+d3JLII+B4IoDtu9dGy+laIPvML87j5qBGU5ZMd65HpEx8Bnjus/Isa25Mr4lVYqAqzeg8wcDPnL1dnamXoFctaH+NFBjvofSp46MhxpADQSZ0i0KJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iS2z1Ov3+9EQjuuulWxaGlgXcj897/G1LAwmtEL1t50=;
 b=TEW3J9Gbijf5eEe5KPr8tQQoWGUz0+7+dvqq0EwHzUSgGNsx6lpdHhmeVvKouzHbSrc0zk2AjxLCy9YkWTGka/wC0PFaBy+p3zwSuBAQRwIOT1EmggzyQKPbMMsbgjPY56m6EdUeW+41z4s7Ml0pc4A08Wdmr/gNI9wb3XWw8Zh2EEdKp4DLHrsft1FbxFh26rK3BpHLfEd+SoidF1RiqilhztzZvyfXQmiD2b3c7//89Zy8szBTQCdl0TlneB9hvqu7zJhYM4MJnFVNfOc4lteRMquksYuGQooNgCxZQzH7MgQwV5TuXUBDZ08tIl+Q7cgBpx1kkozGsAwjTtyMig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iS2z1Ov3+9EQjuuulWxaGlgXcj897/G1LAwmtEL1t50=;
 b=XPqvaD1Zfv24vFZsiTiVTUa3GAb0mj2nTvamHQppC+kj90xP2Ua4Mb6mrHBq+3OKCXKEnHdlA+8F1zRg5XDUUfpjBUFZ00Y4f4DjP9ARmU3wYZD99wrFf4t06mR99lJ0EQBIrKa+KgNMXVmNEoCNMnEZoH6N+gv4D6Y2azBCQoI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8224.eurprd04.prod.outlook.com (2603:10a6:102:1cb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 9 Dec
 2022 19:40:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 19:40:45 +0000
Date:   Fri, 9 Dec 2022 21:40:42 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>
Subject: Re: [PATCH v2 net-next 3/4] net: dsa: mv88e6xxx: replace ATU
 violation prints with trace points
Message-ID: <20221209194042.hxsduaeutoe5wb3e@skbuf>
References: <20221209172817.371434-1-vladimir.oltean@nxp.com>
 <20221209172817.371434-4-vladimir.oltean@nxp.com>
 <Y5OOwWIT/TL800aw@x130>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5OOwWIT/TL800aw@x130>
X-ClientProxiedBy: FR3P281CA0130.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8224:EE_
X-MS-Office365-Filtering-Correlation-Id: 2588bd8c-f296-4de6-6c9e-08dada1d4402
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oiQRi4yFigEiz5KJ81C4c6JlW90ONXaVu1UrcTywBEhCS9RNiV1FGWxO5TgX569DqIx1zbZqYgoBdvKax/yKAeOGcOuDLj2iQwUhBRkFoj/qhXJx+ZOWDWq0UIWlHaAWPMuMRtjAIq9kJQdsR2PGG8LM8u3g2RVmzmgSnBpyOJfpEOWIYcvkVQm/c8BTz2FtW5S5N7h9Lxm62WxX/lnR8wi6/vySDsYZmanwbif2lONkShnUGEuc08LGcDzgzu7TyDnMICfK0H2e3FvbsS0tv9cM+/Bd2/SN5Vt69Y/THMc+WW55Ed03fUchvCNzz8aajywd9vRbUV0eJyM1xJJIrN2oV/BlIp1Ngu71C5/WbmPg2+lqtP6ltik2rlJCY5lg72jONsEJr2SXXiG5lrxQGGNjqrE0QMUKh9yTpdgbmo0Iphy4spDJpxrTruiwU3HW7EbcTGNIp31C2HiLd5SrRFhNYFe4+kApHL2uyqhhnlkETjWLHDWpQ/8/BlPuEw3AvMFbfn8jDM615AMQdqrR7cPsEAnGCMWcMdjAxv4EJ2Ggxihyt6FVWyPRtD3D8YQ0fm3lQuBCHWAZhVkdPNF2O+xdA7f4ROqRppMUzzja/JxqPzYOUD3b25N/uS++m+HefRAG9ZOSKRgban0PzSQeMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199015)(6916009)(8936002)(54906003)(316002)(4326008)(66476007)(66556008)(8676002)(66946007)(83380400001)(41300700001)(1076003)(38100700002)(6486002)(86362001)(186003)(6512007)(9686003)(26005)(478600001)(6506007)(6666004)(33716001)(2906002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FvNcO4jlMi3iUzMD/uTC5KwQFaIAdlHwbhJJsWrp90VI1Jk310o6yV7mAB6m?=
 =?us-ascii?Q?fpWYw/kiJ5XLLTbAUmK4/sogiVXK1kfB7Vj/Pv0nJNM2d+uszH4jeaoMeXUv?=
 =?us-ascii?Q?thfDTpqo8KZpMtzyy45Dc0AI1uREiH1YEZSEp2olpO7YBuRrLouzlunq5EN0?=
 =?us-ascii?Q?gOjlx9XNK1DsKQFO2VrJjXz6WQbdwXQs0OZscSmekWQsnLJD3s1J47KAVpv7?=
 =?us-ascii?Q?+RM/1DUN69ShdqK5bhkWhhHObIqcfd3mxkP+laY6SD9OdI/htdOsbHkuIu0t?=
 =?us-ascii?Q?DfZ3A+Dn6g7OC4KF3IsGzGa/rNu8bM9kWd3s3dtlDxbMnfzMNE/BOctwnnJB?=
 =?us-ascii?Q?Pko45sYPwfDDj+PJUVscuR2mVvQgBzoEUA+G49q8C91AVricfZ/6N5nvPJ+y?=
 =?us-ascii?Q?xt5mXf/swZZ1QrZNj8O9LXWYfOdVwXRK2etjNohwsoxB55Dop0pzkJVjNJC2?=
 =?us-ascii?Q?xo/sHj42upah33sN7Urws6NzXVeLCX0+UdEY/mGM5UKCH2Hc2wVUUKUOfpxK?=
 =?us-ascii?Q?g13wOuMNtcP/K5y33WLvmjZT1TNAF+PAuXr9efsGgqhRmifjpDM49l2/nImn?=
 =?us-ascii?Q?4U7h4YOgzgPRen3v2NlNCGhkoWh5m9N37e0hRPkzNpBOvWHO+s4WlWN5tmdp?=
 =?us-ascii?Q?zNeFWN+7ieSmljJJScRCWIMs7P/t1/pDp5vabtKPtM2W+XVi107H4ShW1niQ?=
 =?us-ascii?Q?xZwk3NQCPI6WeM5Lbuq9sKDW6cpKXMkQP7XTKN17UtOdVHyNe5jY6ywFxKUb?=
 =?us-ascii?Q?0YEPPEO6CiNTiKqcXgdp07nTRuh6f1xTYR6T9/bPxsRu41a+A3ai0m+GucU3?=
 =?us-ascii?Q?ZPSurWK/+azXNcCVuGDiwiFUKygIEz8MyMdTzYRt52aWWTtr6HFMuTT5z+Yy?=
 =?us-ascii?Q?dBg/aDM4W++GSI7mI6QEuwwAutGw8g2xZ+88STnDl3g4kw20CQeYYcIE7u8v?=
 =?us-ascii?Q?srR7HSf5tpVCz7gkgoeBz6iub1oCMC39AfYjH1TKtvczygtfwaic1Xy4oZNT?=
 =?us-ascii?Q?KmlMaOZtwcfg4uFSrcWrIcy7dSNDP9NZPv8OhTygSoRDISUbJ3qZ2SXcV+4u?=
 =?us-ascii?Q?4uK0VkJ7EudrAPq4wPG9h2zfIapdF3bceaZsv3QcIpmNB1qHp5XpFWKXFYDS?=
 =?us-ascii?Q?HiRgN+OF9SxI/8JRwd6wPS+6BY+m0OXyKSQ2DnpTopT7vRx338v4vRqoPi64?=
 =?us-ascii?Q?HRdyMW/INzF0f1456B7LU0I51eKu/RD60rVj0S5CSE//fIetQ++571tRrUZ2?=
 =?us-ascii?Q?yrTJgrtNcGSIiEOyrUsZ+6Lf+aWkxFYF/q77enJc5pQkJVkgaOSvMgcMwl3H?=
 =?us-ascii?Q?2rvkc/vDp9qEoApMQPYHiJyjxN7RTBS6BVL5adNEue64cwFfQfzbgI6KBWR7?=
 =?us-ascii?Q?nmjy1QbiljNfRYE07ANgOiJO5L+LialZkA34GMPYpVRdbRndY2wLymgiulKY?=
 =?us-ascii?Q?iV8hTIZ+jKnHpEehTDbbPRd8UEqx454D8uxqd5hIjUpRKiFeZtRDsQQmWTHf?=
 =?us-ascii?Q?d6wrnBojSoISOejItaW5ayonsSFkDedqUEkd/1IC58vCkcBxBYI3U2XXtTnC?=
 =?us-ascii?Q?MO1+RVJSvErx9vxHal3nvkXiXyNGXcCmGAu3fdCfIxKs8yAp6Yh0HK9h1+WP?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2588bd8c-f296-4de6-6c9e-08dada1d4402
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 19:40:45.7668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pj5LVTNWOQya+ZzMvrcD+BmPF23iwvzj0AffFF6ahPaG3eWy3LqoR/otGxodeFxFZuSFdN54D8zTtkR2VMrhwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8224
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 11:38:41AM -0800, Saeed Mahameed wrote:
> On 09 Dec 19:28, Vladimir Oltean wrote:
> > In applications where the switch ports must perform 802.1X based
> > authentication and are therefore locked, ATU violation interrupts are
> > quite to be expected as part of normal operation. The problem is that
> > they currently spam the kernel log, even if rate limited.
> > 
> > Create a series of trace points, all derived from the same event class,
> > which log these violations to the kernel's trace buffer, which is both
> > much faster and much easier to ignore than printing to a serial console.
> > 
> > New usage model:
> > 
> > $ trace-cmd list | grep mv88e6xxx
> > mv88e6xxx
> > mv88e6xxx:mv88e6xxx_atu_full_violation
> > mv88e6xxx:mv88e6xxx_atu_miss_violation
> > mv88e6xxx:mv88e6xxx_atu_member_violation
> > $ trace-cmd record -e mv88e6xxx sleep 10
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> My knowledge on dsa is very limited but for the tracepoints logic:

There's nothing to know about DSA here, really.

> Reviewed-by: Saeed Mahameed <saeed@kernel.org>

Thanks for the review.
