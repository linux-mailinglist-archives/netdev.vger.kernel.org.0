Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD5B6A1F5B
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 17:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjBXQJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 11:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBXQJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 11:09:28 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2079.outbound.protection.outlook.com [40.107.6.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B71270D
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 08:09:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WV5YVrefLmD9u8W3qJnuWhxs2WqbKZglSlLrYPQQsFzE2WJjG6IYLz8to2JfsBRY52/o7jDDYNliCd/AIXgofHTCdYC8s8e9/XMiDIkdwpNcSLfmDbxnQw1Zd/zv+SEMG+l/p3RY3ba64nQG17Q5jXEfrcYtzNWLzqFKUVKyCezGTktsPYUdpnMBi+cyMVhGRFE0k9rnVhWNwVoj+dD9tShEA+p8Rc/5ISnfvirHFdMZ8C8qVTsGMxiY6Rogxhkgq6x3Ldj/HQ0xWCWoRjNr6G2o4TWfIhF7fWD1GIf2VEG3/q54uK0rHZimMK2GEFWdeUBqFRcGx8KaP6Z0f+OgjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YEnVYbyxLV8sGwqa+kLXL7v2ZdIz1cxwxe299sjpQ34=;
 b=FgK2oztrkkjIO1qt/NcuHJOVGtItgSfETB3cYdxROuLxuqz6FKXIq1G8KR68DBjlp+NtX8Qnydr/PBNftu8DK1HM1KW0KMClp/OHYt0x48q69I1Gjyer0zRQ2E5PYsLg35ddDgCapN8yFNm/mXISZC6T7ypb30/nY+HaaM5fX75Mcqdd/c5xd+uJ0/ZC/NSNwTrjdaOwMW8NLnoJLqDolP0zQRRebpni1ImJb1bsPPcfGmaJmRp0K1kAXQUA7l2/d2a+GTP+lESyre+QKjyS60ALhpLcx6bnNtJX9lbE02+lJWXj0J7Bu4MSxiXinpX7AGqR9iePcyVhUmDmtZ4Aqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEnVYbyxLV8sGwqa+kLXL7v2ZdIz1cxwxe299sjpQ34=;
 b=Bmk3SetOBC/aLW3fVuEvmPjAGRppnEBszRi1zSdU2p5qMhJAx0daYaXWil0ojd5XU+fVruIMWrXHdHtmFkzReMKRcAna+7aSRxLpmKNxrbrjFb9vWuW5pCgLQ7fDc1Sa5ZpuXJKPE9J2r9gqiolqvQLEYeSN/Ck5vtfHzwu8GHE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8685.eurprd04.prod.outlook.com (2603:10a6:102:21c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 16:09:24 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%4]) with mapi id 15.20.6134.019; Fri, 24 Feb 2023
 16:09:24 +0000
Date:   Fri, 24 Feb 2023 18:09:20 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>,
        Maksim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net 3/3] net: mscc: ocelot: fix duplicate driver name
 error
Message-ID: <20230224160920.cjia4n7zn3jm4nyd@skbuf>
References: <20230224155235.512695-1-vladimir.oltean@nxp.com>
 <20230224155235.512695-4-vladimir.oltean@nxp.com>
 <Y/jel+aPo4PkWc1g@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/jel+aPo4PkWc1g@shell.armlinux.org.uk>
X-ClientProxiedBy: VI1PR0602CA0013.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::23) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8685:EE_
X-MS-Office365-Filtering-Correlation-Id: 448f8ff7-f752-40c6-a1d9-08db16817f2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J2XM3stnM1qeaQPCnv/dr3gSsj63CtmkfGA6rYFktZnsif+655yZlDrH3xIAsJ5fX2wwj1oJgBJSHrb6piM5Mt0yR6VV/ppzCeU2gMjKwNH5B1CxNrfTBI7rljg/XMbeDI2y2JVNgGpJY9AIM7lDPkP0mpg1VfW6MTvtdWrO+Vgk/9S/XK+ukSpPqaubA5niUquyldtVufU1unoZHAinIlE0fTSYQA3Vl2aV/bs/P4pYR45PqAgW89261kjHcjXa1eEALr2M+6NQCwHLCeg4sot4ymc7GATBdflpdfb79EmiPGgTnCTIE4CoP5waOe4rldljMCvzgG/OcPoYzLXVVMb47zrNciAgpdfaazYTEn/rbupL1Md++cCSCVg4ulYsqVUmRRTUr4gP/HOOffbNLViYV12eDctnLLZTyGUaNmjT+FrsALVSvWtA+6Lv31ce1xYl4r9aoWVcaJKxJVAKxcSFXh719BiA188KwmdW2w9f41fZCcCojpAHjBfSbFStm7IQ4834kov+qITNudxAcEQ5nFX26s+0kEo71IuBWY/faePFbs+v6yHxxRBEfhPJZo8SCje4MZNiAwimDpgqNXYErFRzyXUHfU2yKe/dqn4s0k3x5sOsj4tUKQCEWuVRV7ULm1QYCuKXTn1FxCXCjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199018)(7416002)(4744005)(44832011)(86362001)(33716001)(2906002)(38100700002)(6486002)(9686003)(478600001)(26005)(186003)(8676002)(66556008)(66476007)(83380400001)(54906003)(316002)(66946007)(1076003)(6666004)(6512007)(41300700001)(4326008)(6506007)(8936002)(6916009)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1iJb99hxyxJ4LwCNXKaYaW5ZD0i2H8IwT5XC0ZnmvcnRmk3t8yxGO/DtkE0u?=
 =?us-ascii?Q?ORK5Jt2UO6ZgYQrAih0PbAVQL7J0M828p7w7jwWYXwymdaR/LGwHFHUUUan0?=
 =?us-ascii?Q?KrD/ir0ioiStl3JnXYfDAoC52hpUDgUdHTNjiBT2D1Xe47lG59j5tafUhWb2?=
 =?us-ascii?Q?73FxTdMmJftIDTPTzKzkEQ/CJ9vgerCqqYZheGrP3x8ZI8xeKJEHdEgo/83J?=
 =?us-ascii?Q?XOM8K9fOU9t4O6CplNdCFVfFaqGl3FvH4gEXT/QV4JjIylsxilV9cC+hr/pS?=
 =?us-ascii?Q?UKjaxSIskmvk4AR9AmWCzOUpAdsZ3zGJpRdxOL99M3pJkn8Z4fZsX+L020FT?=
 =?us-ascii?Q?56gli3Nhzi6QRWnJZcqHHkTlgsOrWXHxvcLNQJ0uddN2a0YLH0DlGCoCcZKe?=
 =?us-ascii?Q?BIJ7/VnKuu4cRDZZ+K1kRoTobOAKHC/CSPUp9g+Osw0Ec3WuwXEXMwvngofB?=
 =?us-ascii?Q?HaZOgjwSmTiP5UhpxFATMMJwndsXam3wxHsHlbfRCJCDdtGu4BcAOhGLdA9j?=
 =?us-ascii?Q?1pKWnRlc/sFurM0K24Lzbe3B7hw8Q8xTgqsICtnY1FJUfsXgOpj4PpUODrUv?=
 =?us-ascii?Q?y2hkJk6IekeDpe1vFX2o4AUpmt6g/ZxZdFTM76suY9960+1+RCXw0yUWM2jn?=
 =?us-ascii?Q?yK6Pqn0tTlILA594lCtQX49BJ/T6GIs9BaKH0QK9/Bpkqj59woQuKdZilpJ7?=
 =?us-ascii?Q?UDOaSCgp/GSh3sxIuUYIo/DuxdNZX4EsTk2Gpb3te5pFIvD5M0UoFoQ9rSq+?=
 =?us-ascii?Q?nLpuanhDrLrnHjxB5LdIUrLsi5mThTMJfji42iI0Rzxyy5UwRzlXLGDND2gb?=
 =?us-ascii?Q?WuLdO+Q1aJgw7saM3Iatfari8N/hiVhrC2vCBpTHBI6P2FJO4NG37EJuPqC7?=
 =?us-ascii?Q?BD1YjfEBF7TXxvt329pJweTVYF4iYMWuWbQg4nbP447HfE6rP+mzlzyN4BL4?=
 =?us-ascii?Q?4w0gyeypcoYuBVPgelNAWvHYjLIMthK8X83fIy6y6QItnt5/MnmxunnDtNzD?=
 =?us-ascii?Q?wGhT38RbHlzN3RemCFIPEJ0lOVkZAK33xWkfTXaqs4gObLlv9ma4uKPBQBmn?=
 =?us-ascii?Q?nCG3esEVxc5gVS/Ez5Jcljw8OtC6cNF9KAGCMIUkqXaSFfSHZMsN6aMhnmG6?=
 =?us-ascii?Q?psaRDY+N+M/cLv7HNpWP0bzkx4nN2abPJ08QEn0mdYyHWbmirfJoZIhbgFwh?=
 =?us-ascii?Q?abAfQEgcIvDj4ZMgbUj4cIWjrgYz5UkVKwagQHSm1UDeuCCUHpiNn3Uod5gj?=
 =?us-ascii?Q?cVURj9JFEplhE5QUpJzXqDKcGIyMyeFiWC/Ju087RB0jamblNubs/+H5vX/s?=
 =?us-ascii?Q?fqwEJMFMTDz/Nu89zLOqioWtjn8AkJkl0vZA7xRsMLZAevKDNJdANlHKdCcn?=
 =?us-ascii?Q?HlV2Qwi/YhVgyDsvJ9Xly84RBVuLt5ZlWhHAkLU/daz1RVirHbRJTb6Bf0FX?=
 =?us-ascii?Q?IbyFXkzJq7jMemvQgLHgSLrWz2FUuBZgtyMTpYtubVtwzEVL1d0fn396RVLy?=
 =?us-ascii?Q?jaf1jCC1z2HUBPAwTAeYTK8Il7GvJ4Za7s7od90/Z4DVWP1ORIVByJCBHKLY?=
 =?us-ascii?Q?9zL1NTOik4tH/NxXx7HJNr6h5l5wdP51dji+63htpohFuJ22BifCC3uBgPp5?=
 =?us-ascii?Q?Yg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 448f8ff7-f752-40c6-a1d9-08db16817f2e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 16:09:24.4974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BgkHDUQ+lgQESohWIym3+ulob48thNlk2zwnaR0UFSsGJN6lmM+w6E4lmXapM7VAcMJ54tps+B6NmvSu/CKzlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8685
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 03:58:15PM +0000, Russell King (Oracle) wrote:
> I'll also send another patch to delete linux/phylink.h from
> ocelot_ext.c - seems that wasn't removed when the phylink instance
> was removed during review.

Good point. I suppose that would be on net-next, after the 6th of March?
I just hope we'll remember by then.
