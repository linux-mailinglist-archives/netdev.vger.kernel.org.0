Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A0855EC9C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbiF1SbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiF1SbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:31:22 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2106.outbound.protection.outlook.com [40.107.220.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181DA21E0F;
        Tue, 28 Jun 2022 11:31:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYm5vHU4i8U8pjKizrY6aCnQLXdbe7o49adYV/6vcHKt+q0aqPn2xytL8p3JEQb538EYEXIHEUmGAZQcG+h5HUaEwCv2E8hJ+UGVnqVmvsK+DB/zgKQ7Omv6wyu87P3VAbarHwQF03TUBRp2TM1a6dZZjIsZAwfz1740VWZQ1nR0d7+8npBHaPuxQK9c5CEznWwEsKlABglzriOuICuW0rPCrRAnn6k3tmk4aCg4ds86zPJUJXG1ItXMr0tRP6EBv6ePBqNPS3yyUyrPpA6k4puiVRC4H27Bi136xwH4s6j7sQD3ClIBQjDmZDzU1bPQl7U5HnAdrCvamw3G9B2yeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8a5bKnIySPOJ/yHZgI8Fiq/jUqfp1Jl2TSEJAfCM4o=;
 b=NJ5AJX2XjCa8NZ08nL+gaAYa3zhlwObGT8HwW0jI6ALhmT+BtQi3BHbUglqVqfkr4xzWLe/BE2cdb4IWpamDp62cEwbj7TMLY4O0FvTlq8WsIYVf8N/oX3EZr7TIFnOwQ6LQZjNXfH43wjsdEhIqV36BZ4VaK5cek9F7ZUl0zq5N7JIdArEsklGE+f4ghw4d4uiXNoTp8mLNiBpzrFSTzgNMhJtXYAO1jcX5mBISKKyiJKB2CNx6LXOEdpAIstZow3J6A0niNaGy6NVz9llx/ryVy9zPiM0Hzl0cYv79fIk42GJ4XMJYh89pPmB1O+tPd6qveLrdEf1GBPe9Nl1w7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8a5bKnIySPOJ/yHZgI8Fiq/jUqfp1Jl2TSEJAfCM4o=;
 b=GgPjBZnIDPWItESzs6vd0H3En3+zC+7/WtuB9t0D10GM+9sU5eVcXF6AxEX4RNtADfPUCOzj0OVy/coHMvahoMgsR0bYmC5ZkbukXddBWMP6lNZtsnSqmB3eeUiTVwgUlLiJuuQOxh5485ccHohEPVi7HD8cQ8o6Tnt+jHLOnb0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR10MB1685.namprd10.prod.outlook.com
 (2603:10b6:910:9::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 18:31:19 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 18:31:19 +0000
Date:   Tue, 28 Jun 2022 11:31:16 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v11 net-next 2/9] net: mdio: mscc-miim: add ability to be
 used in a non-mmio configuration
Message-ID: <20220628183116.GD855398@euler>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-3-colin.foster@in-advantage.com>
 <20220628162604.fxhbcaimv2ioovrk@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628162604.fxhbcaimv2ioovrk@skbuf>
X-ClientProxiedBy: CO1PR15CA0061.namprd15.prod.outlook.com
 (2603:10b6:101:1f::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1a71c19-58c9-4561-dd38-08da593464fb
X-MS-TrafficTypeDiagnostic: CY4PR10MB1685:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TwQ7Xp3jt7zDSqwIFPFQQQCFGtAjSj1zh75zyYUIoe9sX+T5bsTgLef7ACnW5WIbE4opdPZE9ZLuFgABd1j/UyNd9LFk3yRXhFXQUnroGEQeIgCYB/Xmlus0JmAHOH0ffhFKogZ13fbLYN2f4moUeY1sOEBCNFW2AYWGMurGgaygHULlSdfhWohS8bTbBWsIC5hHlqlWXowuhfYSfWVIJMVyu/QkMQilVw3vxUhLwxD5Q8WJV3Auxy6kzhcbgHazFW5Os1xihTxXsJmtx117p9vIXSlNJ8S9TNnNHrTrjVuk3MQNI4EdMRP8/OhRARhJ+8vw6DrYuhUXaU5Dskx7e8MWWyj4jNBUqDZssdGqsUiivwp0216+HOjcY54xP1Ua0weX8rRDW17KZKpSfRkrGFhs+aCZDBRI+vCs+nT+CUu6Cv3VzrD+qjQgLH4oLYSop3O21V4z7UvZ6W7U94wV17otQ7cKC1ZCNlqzE1MU9S5JOFx+M1OVg8KhNsHQNjpMDTz/PxiLiJa+GcdRZX+xGJMw7d+aCmi6NzlVVaU67zmr/+PNKL0H54+jCjE2QL1fynSxoDvtKNhG96f8MTS43CAwkdoJiQDucUsAsR2azXEyN8HqWhrzP+0E/vYvWBDw2KioOpsK0gcfJM0S4k3Eaep6vNBklr+DqRyoC3ayy2V4dFp4I+VZcGPk3tGsbgwnZefqAuYTpZRtv2H/OLNwudHKTeCUKU5xyyvEqEynatwulFPvULPgTcZRyMQroukUseVG44O028C1eh1f1aMEMh4fQMwGqOWvxd0ZdA/qrqY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(39830400003)(396003)(346002)(136003)(376002)(186003)(33716001)(44832011)(2906002)(38100700002)(4326008)(66476007)(7416002)(8936002)(83380400001)(6486002)(4744005)(33656002)(5660300002)(6666004)(478600001)(1076003)(52116002)(316002)(6916009)(54906003)(9686003)(38350700002)(26005)(8676002)(41300700001)(6506007)(86362001)(66556008)(66946007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SkKrOuOxorsSRFvrce8ZeGkeu67mjg0WGHrVVUq7NuKyiH9plq0T9+GyY/DM?=
 =?us-ascii?Q?TNSCN0a+agoH1TkivVkj3fkZuYaI13SaLREV0XCnGt8Jgdb2g+UgKNrqBJqk?=
 =?us-ascii?Q?mZohtZ/93sLQQNsYnLxM5ICykLYhx/wXbZ14Hm3sTbjhJW6hE58NENFFhwEQ?=
 =?us-ascii?Q?WcrQEhdTKXbWrcBmRanYQJrwjAKulQkrwpYxU7WTaxmI3a9ggEuXqYMvsK97?=
 =?us-ascii?Q?x+UO1lBj8YwrncqocJ0+ulF4WFe1fHkWovKs0gQYBexGX3A9QipwQaqWj0iZ?=
 =?us-ascii?Q?rTvxj+sfMX7YzWwXl1K0yBbjEILlSCpVXxksyLvhcvagIG1YHckJGcSlRNPy?=
 =?us-ascii?Q?8TSYeUjyRazatQNYRV8a1++TnlximkJuU+xm1pruykWJSgj1MUiMr88zLXUL?=
 =?us-ascii?Q?5FAGSCSH8kV5zAPW2na3qiyXw0kVWuUJIlN39XVxNhg9BVupU1d9ogkNgdl+?=
 =?us-ascii?Q?zqwuRDfLdjk2c07OEww7n019w+VA7uwhlb815jVbts5sB3pCaH9RwoAxIHa4?=
 =?us-ascii?Q?acGkU29GxWysqjgVel5Ebilttdk4NrBSU2wv1VxfA8jlrROgF3CsZvNy1z5x?=
 =?us-ascii?Q?LXBnReCV2j/bEsHOkH9yFl40cFL2EH3YKOeXAQQjspxNT56Os3nbx8yiAxnh?=
 =?us-ascii?Q?hXPOGhM4Mh7DbUYu9Lanv4R1KMDyzx+DjHQzXQe3ZMto08sYqxXU9BnbZvN2?=
 =?us-ascii?Q?06qKegjlADNBBet2PafiSltB1jvQdRyWTV19K2+NL62TBLyrcRAtEF0HasPs?=
 =?us-ascii?Q?n+/Sk/D8fX+XXxa5OqmP8a9Yq1Y6HOVmN1dQ6omf3WQWBtijHCpwHtKi5weN?=
 =?us-ascii?Q?uNz5xZo3srEOYX96V9eshAfe67HgQvqIiG2rD4OA5eXKgN4wK4RqwP4Husb4?=
 =?us-ascii?Q?c3PaXL90NuSxPGUta8yunQ1W24S94mT/HhDosuk5rJnRcH7/4u/0vwYEm5CY?=
 =?us-ascii?Q?izhgI6QWeLd6dwPvs6ocE0rIxDQ8yrRynE0jAEb1H2HrUiEX5GVyworjucs1?=
 =?us-ascii?Q?QRQLA/YJ8HyMwpIv0SHMQKYEFBUJtHpohYnhv19iH/pwOdUM/0HPzi78pRaa?=
 =?us-ascii?Q?379KcohqW55pdt6y63Iuj3NIcHQ96rguqSCe4dDw745l0bJ5Egl6nhNAd8UN?=
 =?us-ascii?Q?O4QilAsHYbN4n8JiLhmJ3g96dt4mT+WSlI3brPGfxda2xHmoQBsC67lGMah4?=
 =?us-ascii?Q?tAHQINcRgfs2A5/nu9JgzldGAFIVpbtJPf8HxXcXr8RxOpqc0wyV920wo9U2?=
 =?us-ascii?Q?AfkVVjVFec0uwFaZAbWL87otaoICCUsRm8VU/7kxHjgXoB5+R4PIwOU6ktPN?=
 =?us-ascii?Q?pFb5N4NZeZ98+Ry79IgZEQ/2vBJrp0tNpycevTBzo0MvKrCXllPLOX5PW+UC?=
 =?us-ascii?Q?hON7IMXh4eWegnH2l3ZYVnudXTbVj643UfjwiStWBF7HlPIMCY9oskEedWyN?=
 =?us-ascii?Q?OYbjbLbIIG/aeiirCsp97kTQ2NoQF/hASeDEqKCdRARVUgH3PmDh25prV2F9?=
 =?us-ascii?Q?DLiGxa04aycKNMxW06/fCSoDEvzKKhsLTdbFP4q8ogfEArvIOEmMIOoz0x4r?=
 =?us-ascii?Q?gxdhUirkCwkZTAL35ipsV0yT677sST+/1OfZW9gdUiWMiRloqpKhP4HijQ/y?=
 =?us-ascii?Q?hRlpAF3e8cLOHvK9xji5BFg=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a71c19-58c9-4561-dd38-08da593464fb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 18:31:19.5620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KB9OnIr+cFS7ya8ovB+hlYVRD8mT+bAlSjwF9gwz4JRRW3+rgWUSEcAL7T0t4+MorKAvOo6aP9NxKvzqYO0IiNtW/GY8UJTbWyynxmYz6CI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1685
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Tue, Jun 28, 2022 at 04:26:05PM +0000, Vladimir Oltean wrote:
> On Tue, Jun 28, 2022 at 01:17:02AM -0700, Colin Foster wrote:
> > There are a few Ocelot chips that contain the logic for this bus, but are
> > controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
> > the externally controlled configurations these registers are not
> > memory-mapped.
> > 
> > Add support for these non-memory-mapped configurations.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> 
> These "add ability to be used in a non-MMIO configuration" commit
> messages are very confusing when you are only adding support for
> non-MMIO in ocelot_platform_init_regmap_from_resource() in patch 9/9.
> May I suggest a reorder?

Initially my plan was to get the MFD base functionality (SPI protocol,
chip reset, etc.) in and roll in each peripheral one at a time. That was
changed in v6 I believe...

Maybe a commit reword to suggest "utilize a helper function"?
