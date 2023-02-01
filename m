Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7DB6867F6
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 15:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjBAOHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjBAOHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:07:15 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20706.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::706])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D0F133
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:07:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEHpBX7sNkormUrgjdEmZXvU33olo9A0GIWd2bE263if7kBUtufkxBTonxlvabIg909uJe1I8fL96OXtt0Ela4x4/Bp4gQ3zaZRCbel4Vf5soM8ocaCv489xuOfrLi9GuenccZCnkO2LwhF4ZSavaVlsuzroU3+PrQbG/ywCUgXr9R7uDfhYbniFFshfK3fY95OrX4l9rpW3LU5JSwvj3qAmqQ8yh3mn35KC8UHBk3YLKUFDMkwdgIJhsEHLlVpJrcJx75o7Oc1udVhjXbQ0AmAQNpiUW1eDPnGJDnMElAeCqJf9DHonFZEswhEyNdlDFO0YI7lKqUQgJFmQP/5SWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sR5vNZIIoD2KTtojl3r00IQ7xm3duhqq2Q0Qq8+WCEA=;
 b=j0wIihtFQZPxGXY14Fd5M2GVJgOd9f8jm8yb9galcl1JTRriavWU/nWLZkQSLbjO59cSd4jJ5piuClwCF0P1J4zkhVJAH1LteS31gx8kZ8POSIsd9GPBcAhpJwQA8gIasGU1MZB/N5XsDlA3IzDJ4oVWgyN4y8U6jGh69qkEVumsDiI2ekmsEKPbXoTmysqftvBL7pp9GXofBcfzj40OhyThBt6gedSyxkWcm7QXTweqLdXt7X2xTNNXjoOozpK7Fk1vrllThl0yzNodhziaffOL+vV5SeDCspTXPC4MrQCTToP3NNd2jBeEA3HC63IQairYW0JVhoyV9Fo4FeZX7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sR5vNZIIoD2KTtojl3r00IQ7xm3duhqq2Q0Qq8+WCEA=;
 b=cAPIg3eLUAC4OVTYT/N1CjkIgf3aMEwnbF7ppV1U7MDT+2W9y5ienv2wY49KaX1FQq1uPrTmosBxHXbgbKZN1Mo2OpHp3fL+Coryu0i0lRJUcJ0DdsEWi6rVNrg81eQLY6fzHADLDHzfxeN62/tVD+jv5QLaT6L0Kh4wLUqu1CQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5694.namprd13.prod.outlook.com (2603:10b6:806:1ed::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 14:07:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 14:07:09 +0000
Date:   Wed, 1 Feb 2023 15:07:02 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v4 net-next 06/15] net/sched: mqprio: refactor offloading
 and unoffloading to dedicated functions
Message-ID: <Y9pyBhIwtkbRhk5A@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173145.475943-7-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR01CA0098.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5694:EE_
X-MS-Office365-Filtering-Correlation-Id: 08b115b9-af08-4b59-6aa5-08db045d9b7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QuODH+zUv/WupnD1aQUc4CxEdBUyozvt5sqAAnZoK3JK0rQ1JCSLYiSZhUbrJkD+P9R0v2cVkyt4mR+NmT/pLmkjZwQkuQxUE7hUtv3vZVGQbMnbwZoa5eGQOwEZLbBol0cLEK729KylYiXqjtmjojG9GnFh8Z4MRcnEcP1Vt8qxm7J4mxm/Up05XKDq5+eQn9d+H0Z8naU/AUdjsTQ4/gaMtIR1z/ujtx+h0epeanwGBvTZ6Mt6ECzzAvxGi5fTS7c8iIBLqi94Kk3LcZuzhemfV4Helk5kDJ31TWydgjNzK1SplsYmLuFkf0pXm7R5fd9qW8obj2QK5KP0KIB3ObIvhaolbN1OFL3evN0Xy/DCswvkAnY5MQZ7D3Xdkzn0xJn42/Lbb3PCxgCoQQ2tmq2iFT9wLEF/eeP3Q9jlmvRgd7oRZK3sZVMJHOxUy9KwJDjaMPRZVhu4Lt4NpB5Ax8zx/B1c+PNVZPCvRZmgndhATHdfxdG6FBU6+tHRH09gM7kCbg3Ii6BybsNLa9rVeIUPBwq6uBmdjWmd0rK4EerBxKqNVE2ex7iq4FiCZX7qqWJyE4TeBQaVMH2wcOYqtwQI4f+idqIPv9a7L6PtmBtG25R9DyfyATRTC0mS/GW8UbBWCSt4jRA9/TXNR6Nbew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(396003)(136003)(346002)(376002)(451199018)(6916009)(66476007)(8676002)(66556008)(66946007)(2616005)(316002)(54906003)(6506007)(6666004)(186003)(6512007)(6486002)(478600001)(36756003)(38100700002)(86362001)(4744005)(7416002)(2906002)(44832011)(4326008)(5660300002)(8936002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6EXfdZE1oCJQJEy0Btq8UjgUKcn1iYQtZOzDAAW1r6xlhUgot7UiDTaZ8wfi?=
 =?us-ascii?Q?RKgKMSecJLX2aYWx/5c85fSrrCsHxGQJm74VZlLK9Rdmw3oiTAp5RcjozPVA?=
 =?us-ascii?Q?zVJXirFyltOYNdhU0wjz10dbMryqJjA1qkkrd/hkuGbCPKpaouS+K5QUYHux?=
 =?us-ascii?Q?8cKfAxQF0FCTzTsVZSHEarHDRGCTv5CqnO2A5y8FV61aexX2djoA2eS9rhv9?=
 =?us-ascii?Q?O55rLoxJMiOVdp+TQaekdgEu+up3wIkzmKm/8+aZcYiMXtMAZgKn88YMma3u?=
 =?us-ascii?Q?F7qxSWPJGdH5oJoixj3UGRWCHeakoPlZG9Q+/CDhtJc8H/vBy2qGaksqwNvk?=
 =?us-ascii?Q?KviGnHQfjTU3IW3pXpD1NzWgil2/b9XUBlJupVgzG2QebsXjbV+jn9nY2zv4?=
 =?us-ascii?Q?vnHx4qlg03oZdlMIO4B0KlxNupWLo89FLfCQ7YGl3GSFuc4RFMxmc93we2Bg?=
 =?us-ascii?Q?wXOLaL6zJJh+h2SBzcajmk4ExvcAmGqj6zRE/OElGQuIOnQ0QHr+Ylr6SFAL?=
 =?us-ascii?Q?A9v41mXxiUS7+v1oEA6JmZCqwNgGhBwEhxriBZmPtRlPYYWLady3WHUksm3q?=
 =?us-ascii?Q?y44xTkRxAbS0HDCr0WPteJIm+m+5WcibtBT7G3ul7G98E9nJd0gT8R0ZWFqL?=
 =?us-ascii?Q?fvzyxcL+Lpq4M4z27Sbe3sAff/vmF1jrZuqIZEk9JtpbBLQJavpyK5c2IWHI?=
 =?us-ascii?Q?17vLPHP3V/wk0w2z9tcg0UxwVovIxleb3Os5xHxckvMIzprq0Xh2f6DSEIPK?=
 =?us-ascii?Q?ymTu0hhLsn+hG2qggTPx1nqxEiwQo2zHUE3u/gAybzWY3J7H9VupN9sXih5s?=
 =?us-ascii?Q?Jc2Js4cqR/905YxZsES0pgke7KaNwbrbkjimKitaDCnVukKoQvnlG6cgRN6B?=
 =?us-ascii?Q?G+7e61Zrgf6PmWh7BcmwhIDj0hmqIQRyXEaFeg5x+IVE4OcJ/mv+9Pgx37Wj?=
 =?us-ascii?Q?rehdUfCRgEEnE1BwloLrT2AtNTd4j2Js8fQ35qiCNPUzJkOvDUnCg83Xeg2G?=
 =?us-ascii?Q?AYPMwNT/6bQ/ywuS0F79lT+/HabyYpNIBTY6pCI3mG2MyvymwJX/1BK846i2?=
 =?us-ascii?Q?/HPrxdM1EB8myiITGLF21mqCIJeW0x+ciJQPJchIxkJfhI0/AZL7TUwOaoXR?=
 =?us-ascii?Q?RpXL+eua1awtb7J1/D3B3ZevAA72/g6lumNqapYGymiBjaQHaFcKrfWpp/cS?=
 =?us-ascii?Q?5Q4kyMzL68PhYRHmV9Hws8Cdwet3U1UOqR21bGui66mG/DV5gWVCYYoyb0iG?=
 =?us-ascii?Q?5aY5VeCewmeeUS+A2ZAVXb/1e35Lh0IXyR412hA4LgFNCs+ixlxxUNLVZTrT?=
 =?us-ascii?Q?l38iW6J7Sw8WjBkd2qgVOseiJhKUTA7Ys9IkuTsGN3ficvKnln2gRk7+c5RP?=
 =?us-ascii?Q?LE0xQENaDQaiZMd+52RbbiudbfMaPn7gC525YeYp0lyzHBaWulE89dj7h4mF?=
 =?us-ascii?Q?arVntD7L7lo3diNBGCZGbgKJmOGx4XL8Af9+VmGa3SdURQrNexFyRLE+fCmZ?=
 =?us-ascii?Q?QTCUqvTfXWaWU1xuLpiQQyK/fiKeHph6PZmIlAKhMkkmTlnRYgLv0i6mQznH?=
 =?us-ascii?Q?YjuV3jEQFgUqDwrvd5KC8WNyhTs7aXYI5ruXvrboJ4uDqhBMhLqsRgk1Zitl?=
 =?us-ascii?Q?ugVJWC4rxi9Q50n8lturf2z/ymajUVAMRNosYAHLxfE1rb7GqDoTCPiFbgAX?=
 =?us-ascii?Q?EoDrJg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08b115b9-af08-4b59-6aa5-08db045d9b7f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 14:07:09.2845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ps37KR+j5zwhPVGCi+pVt6ps3dG4b7vFucjT8BbpaSC9xNka2GStRrNsRjeQgREn/Rdw43wyPg8z/9o8nsPXzx/C3kn09VVRjPkvDEsH0ts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5694
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 07:31:36PM +0200, Vladimir Oltean wrote:
> Some more logic will be added to mqprio offloading, so split that code
> up from mqprio_init(), which is already large, and create a new
> function, mqprio_enable_offload(), similar to taprio_enable_offload().
> Also create the opposite function mqprio_disable_offload().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Signed-off-by: Simon Horman <simon.horman@corigine.com>

