Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B523668A9DA
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 13:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbjBDM5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 07:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbjBDM5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 07:57:22 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2104.outbound.protection.outlook.com [40.107.92.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE2E25E27;
        Sat,  4 Feb 2023 04:57:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnEWiWh0PwgcWskUdfdXEMPpalKbtK41vf0ehfT0ib6L3KKvIafHPkDgQsCp6z9aLYkurbmzWKYt6RQmfoZJ8yWp4FeErJSszuFhBEq5oDWHV2aGLRk5YwWk3tZovHhR0mJCoAttb2vccewHKOYtlgnscxIZXJlUmt5Phe72LAKjqSjVtPoGofMRrgEk6LDmL61BqsT8AOk7y2u6xGvteFhUdvEERysx0OuKoNxlBwphpdMa2f2V6c5bLLrYPONnw2eZ/Ld9mUErlNNXYp48FU3Ft/X39mb753fWGFv9EUYF1E04YV4nBgSQa/GNkqtIXNxSK6U4gap/dsjMi8FMBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eDTh6nsKCs2X366coMcv8Yg7K2ofoUj24EkpOuvPNqM=;
 b=oWbbchPyqKUsWNiqQdt6gp5hFTka5s1jq5+rTlOiFkHXriSBqqKPcg4aVIBy1OJUhhmn+mvzhynajDeqCHNe/+aqRDlzIVEt1rQ3czL5KzMYkakphKEIw7piUT37l3O6zyfcEclJ+dOwMhkWB3yhV0aXwnXMqTeRq4Kszben6/paXIsvWN8kg6X23UwaVIMhn9bww8elJi1wmnZaOTm43dj7a7WlAeuW2xtnlhdZysSUKecAhCOo0IbdCxfyRMqb+aEEnYXlWsxW3rZ+YWFI68Us3w58LD0gYlkuoz5YHqIYANjhF+7YA+DgGGXdI9ijAgHumRrHh3mcvQwpA+6e7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDTh6nsKCs2X366coMcv8Yg7K2ofoUj24EkpOuvPNqM=;
 b=up/o+Yvf0Rf1rWjz7E0J50UmIWHHBbS4X4HIYFZrPZAsUHj+xwqt+xHi8UIspUFQUxlBNWS8uYD4LZKHkuhPzjIRlDPHx3aZMETGtAGhtjzVIFXAUscEQl0lqo43XoAUJ4XqMSmBey1nILLqhg1njKbXpixpHALVMaYnVC773BM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4675.namprd13.prod.outlook.com (2603:10b6:208:321::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 12:57:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 12:57:07 +0000
Date:   Sat, 4 Feb 2023 13:56:58 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, richardcochran@gmail.com, casper.casan@gmail.com,
        horatiu.vultur@microchip.com, shangxiaojing@huawei.com,
        rmk+kernel@armlinux.org.uk, nhuck@google.com, error27@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 08/10] net: microchip: sparx5: add support for
 PSFP stream filters
Message-ID: <Y95WGmbHVa8VNA+T@corigine.com>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
 <20230202104355.1612823-9-daniel.machon@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202104355.1612823-9-daniel.machon@microchip.com>
X-ClientProxiedBy: AS4PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4675:EE_
X-MS-Office365-Filtering-Correlation-Id: e1c1c007-f430-4d2b-5b25-08db06af522e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tY78K2KDw3QYbt2vj3oQ4I6eQMjrwX/pcWR/yFvTfv8wiV/EUWxnf6vArMx8pnYHm+S1QEdtWEtxZN8ZDT86IdBam5cdxWTaEPrxbYvSAd+dzweHgbiCmNsL/CUBETXJUnGe8GjTlvLBRLppZnviHTJL3zrmMuyUyjqBfAgXBBjZZL0a46jxozOMPXmpJ1vZ3qFMt1IYUWbPRui29hainRkSEB/ATRfu3spK9t6CQb8CCBYofvKB2YqiPg6q82QKv/OQJ7MEXIwoqgrzo3S7A42gubaIvmZ0sDk5OMGq3IwbB1EX45Blch6UqW1Ybe3k+RYCokbB6jwt3zrKtHKMr9Z6+RtLe8y8Ew5QvwAuqHZn3v1fpucy/bVpdtlb1KsBtEZ8lx0rfM8cQ+qDI1HHXcU9IbYTFR9XvlqhD8Alkb3szjP3YZFNT0T4DeYJkNB9SrlQqLZNV0YFdCiJHVw04GeW1UBu3TaPIiGq+mb+YGW2E0ycTPvXU+dSAuj/405bvlne7rsn/oyX/rYHv/Rrtmz1f9t219rfINF54Tv3R020vm/MUfen0NG3CFjnkw0LkyvYIrogj07UNfnMU64SEO5t2PTwWW2qPjaWMyIcuRkD0zRTbAkWTsNnWPqVUOUt3TXK9AANtBGZJVtsUTElUlSRnj80YP0XlmCAqia/MrXlp/AnFfVu4yGg2zIkgCbO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(39840400004)(136003)(346002)(451199018)(316002)(8676002)(66556008)(66946007)(6916009)(4326008)(5660300002)(41300700001)(8936002)(66476007)(36756003)(86362001)(38100700002)(6512007)(6506007)(6666004)(186003)(44832011)(2906002)(4744005)(7416002)(2616005)(478600001)(6486002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ssaZtsFmQtvBFiXQC57zolXuHnS7jgzKT4W689vA/e/ZjJ9s8xRSDYMtnciV?=
 =?us-ascii?Q?Qi1SLjPZ4oBPh1BQ5bljuuksg9M5kBNxvlfIqfAGXsCmramU9vEusEa8eaYM?=
 =?us-ascii?Q?RyuQhpHTAImcQadqoJ7yfFraH8prSxY2KNvbifLypRrAM/smB57g51i6j2mA?=
 =?us-ascii?Q?dSAJ6/obw5LLtN9V6C+j48xybeh71La44WZjQ80xxIK8HQKNUKmSE+J4GbdA?=
 =?us-ascii?Q?b9pd+1apX2eXSb4f+CqrqtzYxMhj2tKAUZ5ahvm8RAENJzp6Z6tBDLL7nhDN?=
 =?us-ascii?Q?C89OcoKTPfGOS172+nmiIesllqtLUSEHXK9z7b6gjauGHJiROhEoCnAlzXSG?=
 =?us-ascii?Q?cdwdYqpSwe74lkGvyERBetI4Vevxd0RtTeqagHpQbRJeJImsNwWHJBeUQ3Py?=
 =?us-ascii?Q?2QmYDhHnkbgnEU2UwsPWOAGtSpKZtVhkBfdbnYSTS7gqXQpw2zHNKjL3axqF?=
 =?us-ascii?Q?Uh2TRwgGoiPv4AzYg6Q0csoV+M9sPWRz0vlz3XS7Ty/tf8l7QWFOUXUOq6xh?=
 =?us-ascii?Q?xIX2XdWIePLSegdrSZPpM2qAwJ7GyR5gSx1QmhszHPAg3pAD2SOSA3/H5ymh?=
 =?us-ascii?Q?nmQ0xSQvraHd327bXdVXmObgzfc0p1cvwE5G1+1gk4TMHrWgiVkSVqbIuAQx?=
 =?us-ascii?Q?ogg0VR9qKtxUAwHc1N1zwZBAeA4LZyMS1TEH1qadmTiDZbFpJIJpecivxdof?=
 =?us-ascii?Q?qplRsZpMdXG49FBSzBeztkyulgIMR1iw/F45mpD77TWyq/drq6CX4l74Ych9?=
 =?us-ascii?Q?W+RJrArU8uzu1AIFu2d5/GqBp+NSyR4pLY/+RfJyj9l9MVE/HxcpnS3hdQ2B?=
 =?us-ascii?Q?iFnRJoZN3MDbU5I61kO7G1mR5HWWZI1hXutQL/DkNEJTegpQlv4maAwnuSKm?=
 =?us-ascii?Q?MZFjb/0y6lTPVnGDb8zUBGB0+L9CvY4jczqm/ISIWKSp4txX71zfQUUBNOpR?=
 =?us-ascii?Q?cNo2A7QxSJGVaebJfG0MIBonO+BPl5GQIL/LkOu0QX1ExyAs67K4hjkZuZen?=
 =?us-ascii?Q?C3FwXwlAo94XAdda9Vi2qpa5fzyIsQbsPuxlJXiFBHhTzaQHz6oLxP53mbp2?=
 =?us-ascii?Q?udIN7ho4EAu3Kb4+Fqdc9W/7NQ0kVSpFPW8ciinznVvvXNNdUAsmnqpacEle?=
 =?us-ascii?Q?iBhATGMMXMPRZyeI8QaDxhMM2qeQqQOnUn2qhD4XfJvMuJsyONiRewM9fBcl?=
 =?us-ascii?Q?NtLFPlQ9XOQmxrEl0Vma+2OIACgB3KOEJJP83L4BDqjt8mq8vl5G9vlW8GjD?=
 =?us-ascii?Q?oFJKZlZJ8NC1GhJoNLD4miQBavcESl7z8wESNcsMcUPhI5KvtvqkVvZXTeCz?=
 =?us-ascii?Q?kaQi0Bl3u62ts+D89caOUMNprdoO+Qf/OkqudFBR6vTSe7qRH3wSnNMNamhn?=
 =?us-ascii?Q?PHGP2+GxjAfQm9wd0hU+lvMsrtSsL6VrPcNdOA5Eaedso4RrR+v2g19SbgeO?=
 =?us-ascii?Q?ihlCxBrLP7VB/qstuYBv0RB6Yssx3qHASFawFu8XKpg4fxjjKva4bj49kHtk?=
 =?us-ascii?Q?/i721mVv0yUTJMAOwzNFxtCR0TCAm+v+7I8g+djsZ+BEROcD55jNWpL5DJ8E?=
 =?us-ascii?Q?De/vnIonw9qJbGEkij6EbN7+goGf3eBFbrZOQj0MPt2RhuHofDeg8cwhoz+6?=
 =?us-ascii?Q?Q2uVFigJ0iWDTeGZVVCELwMXFsfacgQwvUP0eBJ20XPYiMObHynw8iO1uSEA?=
 =?us-ascii?Q?YUm4Fg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1c1c007-f430-4d2b-5b25-08db06af522e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 12:57:07.2744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NkIUq894dIRrwVDScIy7V9TJLm4+HsgBEnr+jX4e1SuR0HqV4d9oCMPx3ApB/kw0kxMqx5vIi4c4uS4UDCceLEl2z18F3o6Gup7wgsYxrWw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4675
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 11:43:53AM +0100, Daniel Machon wrote:
> Add support for configuring PSFP stream filters (IEEE 802.1Q-2018,
> 8.6.5.1.1).
> 
> The VCAP CLM (VCAP IS0 ingress classifier) classifies streams,
> identified by ISDX (Ingress Service Index, frame metadata), and maps
> ISDX to streams.
> 
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

