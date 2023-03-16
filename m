Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFF86BCA64
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjCPJKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCPJKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:10:11 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2139.outbound.protection.outlook.com [40.107.243.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF8126CE2;
        Thu, 16 Mar 2023 02:09:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTFuL14BKT/gy4J499NFaP81mQfOu7boxdGsck+WjjXcT+B0gpDswEYlcD5UBC/gIAFM39QCreKttxN+G3pD83AEfpWT09JrfffytrBH4pxNPSbMXwrJObtwFw/gLjrHIzNtqtfDhnxYCF7R3ZvUAQqQ63oHYh5KFwXeryei17mhxfvCftngpI1hG3R3mlK4q8nc3qE22iy/RJpytMOxYHRQ3GJtPseL3D238ZUpGx85uYYAuBIWPuYW8ut8RZkmLc2Oy4tAlwjl5T6LwVCYPKNmCQe+w8oLl+SA7HN+PPhiGBG3a2LjHDosdS8i5oVh+LVwwkVU30BJUF7ofvgKqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O6ILTD9Aqd8RPg4h+Zt6/4CesLlxh8v5sf+b4BL0Bsk=;
 b=UuNAdBZSXv8Ya/qOWLPKraPZI/jabpmtQaBmSCnsi+9GJbM5jKrWzdR6+QeWhMO7oxkaF4yceiOEcXm7eFcHBf8bjSnfusAPNAwEM7X9mrN5gE/uUYjazdqldy1Nu7whi1noKbIEp6vZja2YGFEpYKQUR1xTdNatjzmUco7z9rqUQWr4MdPxHxLcOhnYJuTpBJ2y5WXtGWTKJoR0Zt+WI9xPpwHsv+OREvErvXgUigdfFsKiTLWVKnggIr4WJM9LQTBOU1bbOwSOqgP8zP7a5lOsI3Vwk9hp0MxqS5mhMgyzIyukLBkCy/XRvzy16gcb1laz+5INCWrplw93DbsM8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6ILTD9Aqd8RPg4h+Zt6/4CesLlxh8v5sf+b4BL0Bsk=;
 b=WJQSoBvAquf2dhZJ6JP0ZUSIuJV6n3JGdUlx/aGYXYXUJ7+/oVHGcXyfjibbZXA/fkYfDvCUCNIoMpW9p5Ep6cS53g+jE+qBTvnrK/yd6Er+ZxYcBKPZcI4en+IZpDPwMa9P5pIAy51oaY3FB6WDXaamhBHxNwG7oV6STCpOJLg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5112.namprd13.prod.outlook.com (2603:10b6:8:11::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 09:09:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 09:09:45 +0000
Date:   Thu, 16 Mar 2023 10:09:39 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 03/16] can: m_can: Remove double interrupt enable
Message-ID: <ZBLc03OYJLLhHLNj@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-4-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-4-msp@baylibre.com>
X-ClientProxiedBy: AM0PR02CA0157.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5112:EE_
X-MS-Office365-Filtering-Correlation-Id: f81361cb-8a9b-4a10-52d0-08db25fe2f88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ihC9UAlWf80yRvfh+6UIBV12fmctlc/GzUbuAi9o58Ri9nAl2atNpt0op6cvIDwZsre5BBpWt1H/5riXkLPm1lhw3C4I45Lr8jLVNq6UeVczuaF7ziQE06eGXw6PyAr+4oPyvu3G44QLvt0kJbRVry+lgkL1kjIzCUTcT20m6mUSL86Vk8JqTD6S92DVpdIFNbJEh8NPko/i+n4PljZO2sd2RUg/52uy6B0meT8OvxoHAlo1Gc4ZWUtAzkE0B5fbtlQfkkZtFNC3FVBubaTA7iEYCaqThQCiaQs+EpgOC/7Q81UbrIVyNPIhvSgyAbAd8sLyQ3FRMXyOQT1Hy20WR+K3gzt70iqlW2Z7JAk65L/CNpWmvtwxTVb0xSTaptsLPbbEbqMpoIBMiuzPuvpXIhksdmMg6/hRs8pLa79s7AgjGh1OW+SaLSxnqKaj2i0Jd6tCN+0mA/9knCkH9vGXV83BAh9GWHc54DKchj6P2n8CHAO6/qg6zhIaz843XqWtf+27ob8FMG/s82EH66VbhK128Im10AoHdPE6QE5KCifB1Lig/CLmkNMrvh8vQ3UxX5VvhGAP2Jb0BmHWiaZShs73u7kjY0D3ltovumu8JqE0T3TT4JNVWrTJHGwO7PmB7E0n1lKBMI0T9j/h3K0DGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(366004)(396003)(376002)(136003)(451199018)(41300700001)(5660300002)(4744005)(2906002)(44832011)(36756003)(38100700002)(86362001)(8936002)(478600001)(66476007)(66946007)(8676002)(6916009)(66556008)(6486002)(6666004)(54906003)(4326008)(2616005)(83380400001)(316002)(186003)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HCN9e9jRpRPIe1tx8AN6k9BlBIRiB+wxfBD+kPDvlx1zzrRcnh07fUArS67H?=
 =?us-ascii?Q?r/9BqUdExPHvTHncyw5lwcd/MwaQz7Apx4dv7ax/btAUaVPnlblanbNgA7bg?=
 =?us-ascii?Q?mDvaDawoYO2EyONlACLH1MK+4ObiQ38c/wmFepYDwTpLEXYIrdRNKQ1BT4m9?=
 =?us-ascii?Q?R0UNRPOM2O1IRlRgZfpnos6GxpyxtECUpvhA6kNEh7n2+35qBX8PR7hZfJwg?=
 =?us-ascii?Q?42WPO8BOL7iqBfU1DAhoiXrwstfP7Ob1ihGho32jd32N/s2LnxmyEUKVE+de?=
 =?us-ascii?Q?YHasTYDd9g0rqKBty8Y99moULnli6i1tRqR6XFnFl0jKKQSd4ZuV9NI1If99?=
 =?us-ascii?Q?/TuvgZxC6kFGhqWENToKkpJ30Sbtbz8SvnwrT6u1WXGX1S29dRwmhulDcpkM?=
 =?us-ascii?Q?lys5jUEQvXMG37Ioa/i0cuL1gCIibSzgHZzsewjGYnW68ekV+P45B/QN0rfe?=
 =?us-ascii?Q?2xYJLHaqwvFlKqz8F0fzEyNd56no5szjvyOEZyqZ4s0L559v2axmOvvc8KDK?=
 =?us-ascii?Q?HzYMzgGiLSimeuVxqLkCkwf1/oSHQEH64bAEgH6TgLxN/IQWcWCjvPC/IdzX?=
 =?us-ascii?Q?34BWvmYAAxz6WsDATbWhi8qyYr+9sAXsErOB95yz0lHDEy/+SliYwmIScLUD?=
 =?us-ascii?Q?NKojgwXGJcUVBtBGSkFR2eBYyPHCRgWhmBOG/MOP3tbaFBEevW/5NygVtwE2?=
 =?us-ascii?Q?J8uJLXrPcY8efchhrvNpE8GG9VnwU9Ho13JvaQidGna0vWGBfyTPbRl3x6TV?=
 =?us-ascii?Q?xvGS7aeGNRHJ7SBVtzPxBko3pafi7S9GxC+3Cpl46mC937PuG2W1bogvyQPc?=
 =?us-ascii?Q?Bfx82oN9AzfDvBdfiAUQMopzwUTCyJEiFXe7aeCXhsnkwXUre2Vxav/xQmnT?=
 =?us-ascii?Q?LmBqgmSNTvQKAbqD+d8C1T5iZ7pNrD576yqrMNOV4yPnPWSgkn4EZ5vaqM5C?=
 =?us-ascii?Q?JpRL+u11mfe1kcKpR5CBuUjK/4tDVoGIgENllcHoS90ZsU8YlbfJFQWNcHZf?=
 =?us-ascii?Q?PzO9zFAt7QTmWQYwQn3fMjK3CQDJrydJXG68nlmKIpXnV39YZJMaUV5hmYyc?=
 =?us-ascii?Q?jmbM+C3cZDxv4vF2a8LVrTtLs2RJXbGUsS4wX6MqI/EHiSxmGpJxGhH4EA9n?=
 =?us-ascii?Q?LwOR7Q2O88ykE9NZREeyHRV7iSNiJ4scU9tXIdMIBW2NDOxBKOdugIdYecKi?=
 =?us-ascii?Q?oZAeT+cBrZlV2Gd+fl7wIjMzqKKlSIkB7a9SiGZL6fuvbBNySMarBfADIkHD?=
 =?us-ascii?Q?rnbyv2ROEKYQVoYgKR9YHPO+YGgEXa7DjWNlMQkUysCEXSwzdIXdThuKInM2?=
 =?us-ascii?Q?2ahNBgnJzjQDfeLUIWPo39kiDRevl3ozE6yTJgs/HyCOI5XitbWquJStqsdM?=
 =?us-ascii?Q?CW0Y3AzUiHSWOgEUC3Z9QE1ryVLxyOvJbRcoJfg4mlAnCaRRmWMCgs/H2qeB?=
 =?us-ascii?Q?JMni9PvczvNsKfE9qp0Cx2FBSTD7FY93a3jjzVP13cWXNls602R81/hJDfmI?=
 =?us-ascii?Q?3P6sOTA1yErgEnzDgPEsW8oh3Ipr00XABEgmw0JHH3FYFlrE1Nbt6lPZeu42?=
 =?us-ascii?Q?HUvcp7BTDtbuLY8J/CRlpGvvrYb1YEDOzFkL4O/WU1mdhVkj25tU7rov7hnD?=
 =?us-ascii?Q?h8aB6w9RpRy4mTvl3RDCxKHMLGlxN+Z931lmrZgK4gj4g+2UwbdEdetwfMTF?=
 =?us-ascii?Q?TxzijQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f81361cb-8a9b-4a10-52d0-08db25fe2f88
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 09:09:45.3704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XVF1OZNPlqMmpE3Jxu38fZp7FhW8/CLruywcjK3Im10aWTFKk/5nUYa15KdRMHLMnu8/gO9L0jBHHbXgG6qeByzUTf3P9Z4JgqAFnuLf5xU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5112
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:05:33PM +0100, Markus Schneider-Pargmann wrote:
> Interrupts are enabled a few lines further down as well. Remove this
> second call to enable all interrupts.

nit: maybe 'duplicate' reads better than 'second', as this call comes first.

> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> ---
>  drivers/net/can/m_can/m_can.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 8eb327ae3bdf..5274d9642566 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1364,7 +1364,6 @@ static int m_can_chip_config(struct net_device *dev)
>  	m_can_write(cdev, M_CAN_TEST, test);
>  
>  	/* Enable interrupts */
> -	m_can_write(cdev, M_CAN_IR, IR_ALL_INT);
>  	if (!(cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING))
>  		if (cdev->version == 30)
>  			m_can_write(cdev, M_CAN_IE, IR_ALL_INT &
> -- 
> 2.39.2
> 
