Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E000168A9D2
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 13:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbjBDMyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 07:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjBDMyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 07:54:10 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2131.outbound.protection.outlook.com [40.107.100.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1BF25958;
        Sat,  4 Feb 2023 04:54:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qcl1ai27ZWMlZj/adz5qqQzgj0Njl2R0LwGEggwos/KnPQ0Rq/52RybjTI7UBtOjFXwXHyHD8dJ4A2AOHRQyRcc6rzA8rE0nASsKPvSZKFgrrxyzoRs5BDY5+QFZ5Sg6rmFlAYvulJMTaL4Oe4bR+OQB/qyegmznJCZJEE+y+nXlxG+C2KDII1vyias0mk8+3vPD37AJQiLgqnCXyIdW2ZJJ0qEPqagZEY7P8u50a7AI6dSjPDhqWNyBcjoA92gIhX+m7v8RHI4rI/dtEZ/iORhTl5dZYdIkCMN09+fqP/+yVfdr25qZQAEb3KYileGuabuexuYM4wi6VeFgB6rHVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LpkEJuk/9wFFystoMC/8tNWkNfUDYfCjTINYm1ijKss=;
 b=ZUlw+XU8LcHru5FrJoQF+/N28GMTvQbvHA8CxzSewgRgG2dSMD+XsPWi0VaQWDqPDBkmJo6lyx55atT3xTTJotZVJvBbCaY88XXEZlAJs4zFb5eeEsauPN7H6w5vR7F/zSLJEl0wJji+s3loZeBrtViFvEs8rDC4gzeSWIucdbF4CYw2YTzGI7qyvTZGpGG0UvDnShWkY8NSUS2cX9Wt3KjmBV83p9oZjCLkkUW5IiADlAdXsYy0GB8A6ASSanX/B+NJASUfpiEhsScCrKDRW6BGCxwTbC2fwh/Q2igwyEV13JVHHECZ0wiXwboWDS/Lpitqv0U45oOJ8iVA4dp47A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpkEJuk/9wFFystoMC/8tNWkNfUDYfCjTINYm1ijKss=;
 b=PMzT02wUFOMx1HuKLg+JjlrpmbfLpQw/GWR4SkxwQQMf9mY/nsU6yhPoHiQv/MlucwkglpjVloctQGL30hox1eXWcCJMrZyFZBCGkxIxON1JgDzAXQ4wWS1cKTsjnGF9EEk5vV+bCqhvPADhG+5pjNfs7dvb5r1MGfXFg75/z1A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5140.namprd13.prod.outlook.com (2603:10b6:610:f3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 12:54:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 12:54:02 +0000
Date:   Sat, 4 Feb 2023 13:53:54 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, richardcochran@gmail.com, casper.casan@gmail.com,
        horatiu.vultur@microchip.com, shangxiaojing@huawei.com,
        rmk+kernel@armlinux.org.uk, nhuck@google.com, error27@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 04/10] net: microchip: sparx5: add support for
 service policers
Message-ID: <Y95VYmrSNiZuU+hM@corigine.com>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
 <20230202104355.1612823-5-daniel.machon@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202104355.1612823-5-daniel.machon@microchip.com>
X-ClientProxiedBy: AS4P192CA0013.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5140:EE_
X-MS-Office365-Filtering-Correlation-Id: 251d2dac-1c4f-48fe-2b84-08db06aee439
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T7BOim9m8n0RdjWbqkQqiqyIo13NhSE5VmPQoPCQ4GJz3J4hi75FpHrwXyxd7TfO+aCW8YPaR3BRPsUbwXOp5Z4UF8pudF/CZv5IC8p+e8Xa9kJunEU1JQAyqE2BmafzAG3dt3dwxzJhMBnpkwdggJwBKHFNNDRTSCZWQHP7t11oVzUY0iI+Du9DXBvQFDxN7IVnDDJK2WDuvvLlgGkSXpkmOtETovL1GfFC9Iytd/FnhC7/8YATW3iR24cbTk5gACy6NjdqvFGh7p8EGRgKYbq0KlXen3f7nmuDQ9OLPKnNxooMnk+EECURb0ou+TRuJR0vYT8MRzymHnGGJmBuSGoiexxDgjQvLk/t7fLOfSadhuxo3MJpigFLqEYJbNPEYPNmTKc123Bwz9LeFe2DnhzDfv0bVxTPW8fSPcyQ2dqtxpc8MeJtjTPg2hvgj5krVEkOsN7VXOMGDv6VvoM407oDOy//SEu05cUWjUBbD+P79mrAtEnim1Kl8tOf3b+AljAW+VFLNhv/8p7A1uZupRUhiubnzRnVn6JjVwnr3Dmj2O6n2tqt4r5qHe0ANdZqeGnG+gPFZxNst2XWIMhooOO9LqVoQ26BiUbnhFfAF4P2VsmdD9vQERLafRFEg7rgl//lJMYTMzYrIbQWENBemBhw2cxiRGxh12oBznyv42QLDlERUiuPRXvKpy8/z0n8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39840400004)(396003)(376002)(366004)(451199018)(36756003)(86362001)(558084003)(66476007)(38100700002)(316002)(4326008)(5660300002)(8936002)(41300700001)(66556008)(66946007)(6916009)(8676002)(2906002)(44832011)(7416002)(2616005)(6486002)(478600001)(186003)(6512007)(6666004)(6506007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?REYsyDenRe0y/HFKTuo39n55aGYkGId8L0NPh/7WFpxJnx0M9emKrTwHKOA0?=
 =?us-ascii?Q?EAVTa64wpIRvaebMA0cqk0mI6w6w4s2KMlN59OTGGBoZVo2nMfCPoJOZ9CDk?=
 =?us-ascii?Q?/+0h7UvjF1nynQR7FxROM15Bx+cAFbqa2u2MzYKCZSE9dDD/yUsFSLgfZhUS?=
 =?us-ascii?Q?GqZiUoD3a64C3kUbgct+zxwEZjRjYiOvjlDTAHO4RzFRWVIrfOzeHE1qav4N?=
 =?us-ascii?Q?P/KPoo0t5aq7rYLu88S24u7jhkfQWBcBU5/+UIMZrgBoEOMeHqromiUSh+Jo?=
 =?us-ascii?Q?5Yx7m+ZUfieJ1pYFsyAeWIUF/RbxyMOrfylMS1x2kIwMNSiQn/LkZtOepcMi?=
 =?us-ascii?Q?VHMnzRSVLuDlRRc/UPNCi6VAv3zHHd6MeOmFr5Q4fZqoYg8F6zimr+NZRd35?=
 =?us-ascii?Q?4ppDjTe7RhcZ8hWL9HQjyDmEceuyEkEJZSCh+pXXUK9gwT0OwqFk/QY5NXdv?=
 =?us-ascii?Q?qqrrhlgV20vpR756ohQT+7HvlJl61uT+XlqMui0ksC73wX7i1NJ5ennGGgwI?=
 =?us-ascii?Q?BjHrjHPTG6HxNycM/WJrJoT7PBMdsldwFEXFtHr3PJRZYGw+gEuGOzHqVFsR?=
 =?us-ascii?Q?ahYx12QoSRPY/DDwsRorCjgz+iPkFDpqx0W7MlPXFYnvBrPGDWZN5BDs+4zE?=
 =?us-ascii?Q?j9jCkJ+u5dA01YUExvLOb5lYMiyCo613zeuAz5NxaUBa4lQUxA5lLrXbNyf9?=
 =?us-ascii?Q?/QrhqBwkQVmkO/LXG38xEBUUGkA5S54tioSLflqk5/GnNaAZiE9tyzUJzAwK?=
 =?us-ascii?Q?4edg7J8ZTc1aQmdeux/o8W7/Vxoh+jBLfQfQLVsMBI7fijeEJ2tjmJMGzFKR?=
 =?us-ascii?Q?tlR0pbhhqCCyH6O6vrq7HrZI00kCDhQPuwJKgusm8xfpM9rGPaC36aNJjY4p?=
 =?us-ascii?Q?xwlfr4/6NNnMnISMpl3enT/yK+g7WOES6UM1BGjCGfDf0Dan0oXq6gHn1be/?=
 =?us-ascii?Q?52QZPgHsOL9Vq9GsSjhURjIz4dGPBABqrOEYAvPV7bMDNq4MlW5fQOr2wyTa?=
 =?us-ascii?Q?7/6cR+uJvf3elRkysK5y3Ywka5xZzvD/45J8hE/BrWicFw7/lwzSnY5L2x4a?=
 =?us-ascii?Q?IM+8YWK9xLcsL7ooFxGTQU7XYEL1cpeJt8K2junjIfbrPWRXd+D/sugNJG7l?=
 =?us-ascii?Q?8kXA3sLXu04nOsNuCejjwtQ1rh58EKFt67SiSqtZlsXXJaoishOHNgHElW6c?=
 =?us-ascii?Q?jETuroGV8N7gAMfY2xAPK3OVoqqik2ylki/zQMlAAfi6NLzhRNc5D19EVUVW?=
 =?us-ascii?Q?x1clZ1pLIyY0Se28GxyFkU4VBF/GgF5hLWbjkx+rZq/PRStACVgKrOoG26A+?=
 =?us-ascii?Q?OcspTnXJYa4rs2/V3gwbP9bzX3NWX7eB+TI+x4hQnxdQLPvLny+BvRRaoXIP?=
 =?us-ascii?Q?EgXZ7be4acmUYzh+PPixplBRAN+T4AAXowMbotHG1uDpQYB4rUEmBMszDQ+q?=
 =?us-ascii?Q?ZdwgDJMeL8kbIl94PuofM6IrjAyOrg9xcgP//1XvzwZ7+79Xh+IsUAqMPHKZ?=
 =?us-ascii?Q?zvO/xTK15KdDyI9tv4AsgTy5C4dKEmKlLAd2Xn7Jd6i+ogAFqtoDwiOf6qkQ?=
 =?us-ascii?Q?rAuQq6IuuQWPLFwDPCE54XYJv11pj2MmyE/9z18z2zOluRxqFo1Hj6p2rfwL?=
 =?us-ascii?Q?dLLMcLGJzggupfZwK0iXoCVVfFWBaZSVwQZ8yQUi367JG7siShr/WxdcxMrS?=
 =?us-ascii?Q?yPTe9A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 251d2dac-1c4f-48fe-2b84-08db06aee439
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 12:54:02.7972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XlBihLmnSDt7NQCif+cw9OWHpa9j0oKlsrm4JmqDSga6vKXguGtHtiAccA+HGpwXuJ7Z16F3gp7lAWPh5asjgDcoNQRJtaDwwqOJJg94f68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5140
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 11:43:49AM +0100, Daniel Machon wrote:
> Add initial API for configuring policers. This patch add support for
> service policers.
> 
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

