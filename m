Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58AF56BCA55
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjCPJGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjCPJGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:06:34 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69845BDDD;
        Thu, 16 Mar 2023 02:06:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5FsTPc0ItI3BG6flJQoWwVtuJQn8D1BN/0Tt9bBhYEtOZuhuOvK2DGQ5g6kHvwk5X+I0r0bkvFmDxlLlmhVp9mlq6rTRpEI1kl+/Xcrwrff6lbCoyJJ+PkawmZJDnTBQuKioPX5G9GsGRbftYqC/0mO4adHOYrn38XeFEf1J/w3AX/inOdEv1vmcQbrct+MX1yUtkksZxLUt79WPBDi0bKEjsVwSGMm/0t/vmks8bEeok8cifumLkDzbdYx97HQQRN4v1PC23CJUMOGS9digcrCWjlROWzqppLoapWZMk6Sr9CNNT5FdH1BRCz5hC8lc6/jp0ALfLVIGOpZeuphOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8HGsSKda0SF274UhD6M1Osso/Ii9gEXEAMxLbuU4IoQ=;
 b=RpWbgaSfOY+j5yF+0Fm03rM3MXuxGOdLWFK6E9o58MWxwhR3/5tcuzCr7xwUZixn+j6wb26WfLEPVx7qpjTWKCG1JU3y8tn1ZnGPX8jPwe6Mt1m9qxeTJYmhAaLByTlY0WUgGIfX4nzCLm5b40x+NAL0rpufqkN72DFlsVhT3IWcgwdhF1qfANMR+0eZnZJiXC781CZgd5Y+HDh0PdLYZKcC/fpYLqYOhL33Z8eVZkN0E4pyXO4qtHeAy3e2YKY8X7yeAvOjXJnEcu+bDNstoeqchfzjL/ka6QN8iYhij2rBWeXtwnTZkK5pyYPU/IOlRNP7Gke3eHiwYba+RHJOTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HGsSKda0SF274UhD6M1Osso/Ii9gEXEAMxLbuU4IoQ=;
 b=pqBXuo5wT0M9WAawOKhN02GL5rOsQ+f4FwyckYAPTkos/21P3bDWARxP5/a/S+stpJ+6xRR+Csa3cDTccbG0i3kl/dvGsuDvNZscYrusqQGAibzqm67vJ2+NmPr2JF3t7fQ184mBjW+NWWp6GZ3oNiC+uHcoYfBaNnb0cXeXia0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3692.namprd13.prod.outlook.com (2603:10b6:5:229::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Thu, 16 Mar
 2023 09:06:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 09:06:30 +0000
Date:   Thu, 16 Mar 2023 10:06:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/16] can: m_can: Remove repeated check for
 is_peripheral
Message-ID: <ZBLcEGiVMxbXH7b7@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-2-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-2-msp@baylibre.com>
X-ClientProxiedBy: AM3PR04CA0143.eurprd04.prod.outlook.com (2603:10a6:207::27)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3692:EE_
X-MS-Office365-Filtering-Correlation-Id: abd88984-4efc-45cf-bdd0-08db25fdbb3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FxQvoGP3vJCBHdb395XsCG/31K++WQ20RK5KsOB5LT4Me4A2DZXznRPwYWXNgRI+r2w7rOV+5ed3i4DKa3+cywDX1g7XJsVRcVry3iuY2ox7f+4MO8LzMF/XVNfvViFJKsGQAf3NqW8TTfEbslHus1mK/t080KFlgDEfz2MJh9dBrcDlgC9WeURc2C++bj065F+Ja3Ljrqfpcdqk23BI5h9O0YCSAxd/np2LPKgtVfzAPO2VrJLo9/uClb7nvwaTeVpMU4nKJ/nu5EU2QKK5x2VQV8S1xD/xbe8gdFE6aein26jSU5AyObhLS/RfH3ND83+LPiG0d6+Cn6Q+LRH3HKmt6M5hLx/LcqK5mODBVQeeYkgfafRBminsnaOnvmL0k6BzYUwYoqNdrbeZELSy6/w0vxBAWwHEXLlDEZRWIGM2yhovzQeAfod6vIH1V3j1j+dzS4Oq7+1Ptg/qW9tAgaU/DtmWNMKpNJ+wzr166vgUeRKgr/Gop6jwxWmTxPZDFRRPdl6ZB3ayMnn69sZMzAx+8haOp8spDHGScHQmVo5YcDuVGG/eH3R/P0/mtMR+cCR94/eCArIyfUD0bhxrN2aJ4Cb+2KwY5H88V6XP8VEeN0mOHQ+rHf9IxGy17nKrDs7RgbKrLeNS32Ao/GIR/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(346002)(376002)(366004)(396003)(451199018)(66556008)(41300700001)(8936002)(5660300002)(2906002)(86362001)(38100700002)(36756003)(558084003)(44832011)(478600001)(6916009)(66476007)(8676002)(66946007)(6666004)(6486002)(2616005)(4326008)(316002)(54906003)(6512007)(83380400001)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8ku17zKx4djlP2fmcvmMe4lmdH4kCa5ruidSej4tnhO3NGuJ7XXWzx497wP3?=
 =?us-ascii?Q?wyJoRrfh/WPHTgPwe0OBquLnci7dT8ZSJkbHXjM2YUMIeqz8y07AuEfI3k8S?=
 =?us-ascii?Q?1D7Iq5NCNWKiK3FSiPQQ0bgC7bfwmSwg+81GZvDlF4BbahHAb4qKYrOsmUBc?=
 =?us-ascii?Q?YsEUBLH/uFGECwQSeKLYUGGlljAp/ZSBtJxX7aVQT/m+tdTTPvDhuMN8UDRV?=
 =?us-ascii?Q?/Z84I2R/iMS00jFZh7qisoAoZAEjL6wlExqNtmmN9SqehlumLN9djZUmiKdy?=
 =?us-ascii?Q?VhCuq0x8V7A+YUH6KYCI392p89EeBC9logVwwzoFa36AJn2Y+h27BXv8K2FU?=
 =?us-ascii?Q?oeIVRI64AeBTY7NST/rHZM7TBcCqY3HK/en2l1XiKJFXIWnHWZtTpoicZVyn?=
 =?us-ascii?Q?SIbVt8bU1d8I72bcDXxYifWmlaPKIJjharSM3tU5/mvugCWTs7Be3XT010s5?=
 =?us-ascii?Q?eHHS/WoLzcM8wmebGuUJ+Nz2n+zEUPedRt8A9BvDRwL9oHU6WXJZ/3kVxrUC?=
 =?us-ascii?Q?6pwmRQSRkZ5kQpB0aZ1VbLU/bq153qwZnvevzK8dBMfhm9Qsq/x3zv5dRQu6?=
 =?us-ascii?Q?E2yi3RcLwCG8dQ7yJy3H7EBWdHRavrZQ+vlDcQYCI0JQPJQD6V6HqvC1XMrF?=
 =?us-ascii?Q?M4uIkUtP9W/ORgBqaC16i60Go59LZ9DSItOe91XXohBdteiQUm6keJG8Dbhl?=
 =?us-ascii?Q?Vcp0yArVo1ZOqbwaqXu2J3+WcgeE9ndbDP+SmNdFtHzdEhwcsWMdTUPjXumV?=
 =?us-ascii?Q?g1LuD3qLsH8cn+uQ8NCdxdqlLktuNPjN9IYRvD3cgOE3GDXDDaDe2OZvLQuf?=
 =?us-ascii?Q?tJS+5+PRjostfe16hyOc+8xt2B6+DbKbUSQe+VJ0anGmZQHgl8v/KmBygXzq?=
 =?us-ascii?Q?F5NIvqGzi5buC0A8sjVIsPfIzSBJ1QAWh7PajZyi6DJMn7dVcJzBhh+p+t02?=
 =?us-ascii?Q?jEnl4WYYAslzcemBCZmFWXbR9GVJh+Em+GCfIWrWQETOnqxuFmB8IkynBClb?=
 =?us-ascii?Q?eECF/Pw7nnnHj0CWGQh+lshl+aKjjFdH6c12PwOG48gFR2WoWaotH//WNg9D?=
 =?us-ascii?Q?+kJvWzR5knH+oZLTdo4rnzSyol7CKc5mbIFlgYMmHohcEPUH6NTGjlBAD8iI?=
 =?us-ascii?Q?z4nOTPLKIHaqRL2ANNEjBRNvxspNV58Ast8pxCBXBfZMz0vKdm52iZAd7Pc9?=
 =?us-ascii?Q?yX2ZC9LGql6s0g6tYf0mNd0GzXovFgONrnlEHypKdpkaEUKYu/9oK/+7yIt4?=
 =?us-ascii?Q?YUJ/chxq91uAoy3tWF/xuc4OxLEzxaDTPjB15QlSKaRbK80zfriWbrSUC1sv?=
 =?us-ascii?Q?OYmLIAowvR+9A5LVAHjen2x2TJGOLQ/FAqkvS7zZmJDehU5IzjEba7WC034T?=
 =?us-ascii?Q?tMvqWsycdA0qYo9wIeTSuV2BDdmp7uAr2sA9fQhnC0BQ+q91xCfgj+mBGE1k?=
 =?us-ascii?Q?7g+Futcsjbj3xiJTWsiVZ6qHPAAzDcnODujO/Jz6+XsWGG4/BF+YUVzDo3D+?=
 =?us-ascii?Q?m2XV4F8xsoV6cbL0HxuVypUAFJKP98XakJmYlH+A1b6ahImyeNMUmbgTlfms?=
 =?us-ascii?Q?/0OGtMmNcKR6FoQRop5MQDKFZhAUVMAmXcpqTJ73LqWFC8BlKOLGM/kjtDIr?=
 =?us-ascii?Q?wL5CM1eOl7fYC5DSNZ4gJ/bCepNGEefv/kyTOfDVYfZDphuFGIEuoCq0TFu8?=
 =?us-ascii?Q?yxA7Tw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abd88984-4efc-45cf-bdd0-08db25fdbb3f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 09:06:30.2933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nkSBNgJwfyzUXKR3+COduWxpzVlaDimDwm8+dUAAaqP9h5S4Kt0cVfaGahL367AqowBWHU0mQOTXD/K7n4G5gsb0XD/TRVNHvKbzuShb/PQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3692
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:05:31PM +0100, Markus Schneider-Pargmann wrote:
> Merge both if-blocks to fix this.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
