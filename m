Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB816EA677
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjDUJDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbjDUJD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:03:26 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2098.outbound.protection.outlook.com [40.107.93.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9264974F;
        Fri, 21 Apr 2023 02:03:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DG0YzkQMe3gErWhRHO7qMhxN3M14k8lXTSyBpIrCV/y/KPLaXEQp/pV0YctxtStudNo/h7XO6ZI1cuhhuQn7rtPQfw2644rg2xW6mBolA+r1hHLuLsffQ+tRpBjmX2OfltwgynV5CwuvFi/OL8Nmjc7zdmWuenlnnuZP0a/BUI4hJ2flRiAQqxOBhQLwjB08Y0lzcoliP+hyseGcjCIo1uroTaojS2FXglbbcQeikqQC4dtgAb4k7E+ksXHerV+HmoEgvgytWmngqW325663Tgg0003VEZPqpgZL+NAa9HMerA2oe8LBmxaE8myD8XMovP+sEMDPziqpozqrJb+xWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cwv/q79xHeBKbBh360JanppjCaZzwHN56+DEvEhwbig=;
 b=i/h5DngUeN0tvqRJPVDkdFKYDfVCP91sBGZINob65sSVoRc1GiH6rqdU9J7kwIezM9YPi7k5gOq2ghG5Nhx2wFZOr81I7tX2zcaY3WYAo7XqQrZ8VADh0z1+o7FnvQS38XlHmgu8RmI202mXHs+aWi3e+VrQONLxlpRS748aPQtzpAWVpC3PsJoOd1J8CYE2NcZd0q4rqXlh5HyuWIAic6btC6HbqDKIo5n1062Bzyi6EbN57dS9kz4ckzQ3IIqrKrzk1+ZjCU7l7C+eO3FHKEqZNP6IakCRPO7IrKDMAQ74QoB8JELw1n2Uw6TRSVPUx8UT6aXRKR6hK6pSMH9s/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cwv/q79xHeBKbBh360JanppjCaZzwHN56+DEvEhwbig=;
 b=eF5tCDXFsKmjaKx8kKB5S9oa2laxDanWPlLT0vPyj077XY7K7YQmIVb6UDWDfaSlaeYb6D/Zpx1usYo+tHPlO/NTtZ5XRUp0VgY15riJ3hDtC7nxXxfz3RoEvSLAWRb8dQDnrQblHLB6kbd5QECr0BiNeEVKszbmPpLHxCGvu90=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5158.namprd13.prod.outlook.com (2603:10b6:8:4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.22; Fri, 21 Apr 2023 09:03:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 09:03:21 +0000
Date:   Fri, 21 Apr 2023 11:03:13 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/9] net: enetc: include MAC Merge / FP
 registers in register dump
Message-ID: <ZEJRUcR5nGFPagaj@corigine.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
 <20230418111459.811553-5-vladimir.oltean@nxp.com>
 <ZEFOSGwKhIyzwWmB@corigine.com>
 <20230420165852.op2bn3c7kdkhekvx@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420165852.op2bn3c7kdkhekvx@skbuf>
X-ClientProxiedBy: AS4P195CA0025.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5158:EE_
X-MS-Office365-Filtering-Correlation-Id: 314b6241-f608-413c-9471-08db4247416a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qqZ71Vv4iAPtSVfaer/CTpBlrbr8MhjTqezDh32z8MHGdMQ65C6UQbnXUu7+/PwLXD0rIjsc8XM8VeZ+JgalsAINYy+eySQfGh7T64OUpztX0rXRzCkkaZ0j9y9lXCTeaXhYQnlzgphrPr7CZrllF34OVHz5fCsP/CtJml8UvBXiJlnuAzanpgCdY872bZsaw0X//WuXF26IbSt09hMQ74KIhuqd2n5YFqPzXlFMJx2KkSFXWnD4x4tRYT6heKeS+H4rIbwHT1czH+FKZHMMUU7mNSx/baa6/ThJCb6mEVbPMtII2QxBnRHei8LIJEgx9KlP/furzlqx1V8mELiWi9YJ7JKuw4jIbs9z9+ioWFpNoq6/yyWdCzu87c8i0EEe0bCe2k0pW/E96EBVhSufAP/XZYb4YGA3TpZMicb0lqtkRCyTMn159E7PQZXocEMFUwx4m/YifH5wYpHtxQrxVKiwL7QqRq1VnTi+B36QTi9Bi+S60zC+0l0BIg1ZcP0DY41g676Q2737aGK+LG1ad1mYq38JpGab/YRpHhdocmQN3I2+7e/8I3iOVnNXUrpp9fPeddFI23psvg1zZPgRhlJYpIgT708WjHWfdvAkhNM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(136003)(396003)(346002)(376002)(451199021)(41300700001)(66476007)(66946007)(66556008)(54906003)(316002)(6916009)(4326008)(478600001)(8936002)(8676002)(83380400001)(7416002)(2616005)(5660300002)(6506007)(6512007)(6666004)(6486002)(36756003)(186003)(44832011)(2906002)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+J90OM6K/23v4Lb0+bZwRblujUAPNVsBHvXQFW78UsF9YZbdb2P+hGeWHTaK?=
 =?us-ascii?Q?CTKeheoO49fHrhVuRYeiCv9/4PPR5hHB6eV913g5yJ98z9cv5muHxSht1zAI?=
 =?us-ascii?Q?A0q8I4CE8/HuCXJkfTfEfyTZ8mT5YZ1f6UvBlDUTCp5r6HaABsilMOocylhc?=
 =?us-ascii?Q?r26J6tNvUtDnCI0mbtWY00/YC492awS3XzsB0oJeZJV1Po9TYmL2IDnVadFU?=
 =?us-ascii?Q?iZgD5jgyhR2z0ES+dLx4xABN6eTZ8dQtkaztFrmHa2tZsi5RYY8Suj8BWS36?=
 =?us-ascii?Q?VwnTjBK2z9UpBsvCGSaQLulKBgf4nz02UY3SDz3SE+G2zW7j6trqGz3PjfPp?=
 =?us-ascii?Q?pbphzW9GfWJnUYCAo06Uq/98A9ID2+WaU7iNI4HBVUISQT+DzthchqQu0prG?=
 =?us-ascii?Q?Z6BGFyY4MgdXyIyJiOYyGvpOq0mA4XfuAq12IGRz2BKNMS3JRpEoAgit8vYI?=
 =?us-ascii?Q?RVA4JUgVwzOfoTiBovRDTovlUbs5Kn24G2c+g5AW5fUoBUR0flvJ8zXFKNKy?=
 =?us-ascii?Q?M19hOdbe8vfG6Z1Bdquhe9uSZQXSXSLuuWsBuhiCD6uloOQDdOCQgUH35lg3?=
 =?us-ascii?Q?ayJUNrJPVhYRib9cBh6/+so0KFoVfz1SOLMqorqrCUNks/zBnNL7RdT8Kjq7?=
 =?us-ascii?Q?EWi6SYrKfRUbhI7lwqCQ4TZSbcrMNaTszJS7+oEcx3e+gX0EqILQOdbmoc1x?=
 =?us-ascii?Q?TkynUO+4/unnc/XVE8wIWtUhY0TPbmh14iFXqxd+fdNpNOTobuTPUsguM0pa?=
 =?us-ascii?Q?uXeKHmRz9kyUwD3mAh374tk51v9I0VBQ4gJz95D/R6SAv5rivazXkt8X3Ul8?=
 =?us-ascii?Q?i76VMoai91HImUJ09TgtTvI9I8q9gBOzNdJv+lMhXnygtGB9go0mVfvLHtH4?=
 =?us-ascii?Q?Txr/29C4OXdD0yZXqzlxE7JY4B3xOmf3RRRSYyPuiOm2QWS2E5zMxPl/RoMB?=
 =?us-ascii?Q?sodbnta7xWQbYYO8wFmalbkiq3VwZWtUFRs9s/9EXY05+z1xzOc+sACKA3dE?=
 =?us-ascii?Q?9AcOzpX9kjvaWBlKJ4f0Ay4SAfczN9JFAQEJl28Gatt9E+xOOjkcoxjRsIlG?=
 =?us-ascii?Q?LKfB6jAY2f71UHCZ4C5uNrI8vyTH1/q8Cqqh8zD+/eeSlPcXAnAnqYqqGxgR?=
 =?us-ascii?Q?MsDTriIbbwqp/F8RWX5rk2aOkuy+WGqRA3g8YSxM+QqUC2y0K9k+cqyJawIq?=
 =?us-ascii?Q?dbAJzLqKB278vCPwRdSwwYny9JmI6IulqBb4q0lEvEOMyTN/oBUpGJO81UF4?=
 =?us-ascii?Q?9A96LDPvGN69LC5a1HLHacoQPMMy9RHlNhwJb1K+W1kN3KmImRXCC4HpLLv8?=
 =?us-ascii?Q?6t52loRY1ZGkdVY9NM6+HzfczA5ICNf+EAiAvPgd1qpuZG/jnP0P8T20KXrd?=
 =?us-ascii?Q?B+w7z2bWWhQK6MNkRsdihbBo9PxId1euC0JzvTzhe8K6qI6srxaMIkd5hjHF?=
 =?us-ascii?Q?YmwzmMUiGesRIiT0X7y865UZwL4+W2bDBpmpIvBPcuC70ZFTwMDOoSnAv8v+?=
 =?us-ascii?Q?w2PQsKxXz0mTmvWAl8nWJ8dKTlHq7OCM/b+DmgijdVNB8N7oEk0xgEWRflDi?=
 =?us-ascii?Q?gn1HyZsTE053qyP0fK5LKtMO7H4pJ3GAPS0bGWMIWI9gDnAEIhJ1US8l6trv?=
 =?us-ascii?Q?nPJrKK2sJNshNPQNQR+6DVFxqKOLyvigDFp4fgCARTHSp9U+wun1uAneJr+u?=
 =?us-ascii?Q?7nh1ow=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 314b6241-f608-413c-9471-08db4247416a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 09:03:21.2595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iM7x0Kl3UH0TPV3T810Aj0r/AcJOg6T85Ace68GoYPEJQ21LouxdOEd2nIGdO+jVTHMgMUiqIKHdImMiZ/vPR/49JuyXiZVLMlb0zEIQRvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5158
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 07:58:52PM +0300, Vladimir Oltean wrote:
> On Thu, Apr 20, 2023 at 04:38:00PM +0200, Simon Horman wrote:
> > > +	if (hw->port && !!(priv->si->hw_features & ENETC_SI_F_QBU))
> > 
> > nit: I think you could make the condition.
> > 
> > 	if (hw->port && priv->si->hw_features & ENETC_SI_F_QBU)
> > 
> > which would be consistent with the condition in the next hunk.
> > 
> > > +	if (priv->si->hw_features & ENETC_SI_F_QBU) {
> 
> Maybe, but it generates the exact same object code (tested with
> "make drivers/net/ethernet/freescale/enetc/enetc_ethtool.lst").
> 
> When I'm debugging, I'm a bit of a conspiracy theorist when it comes
> to operator precedence (& vs &&), and so, "A && B & C" doesn't read
> particularly well to me, and would be one of my first suspects at
> hiding a bug. I do know it would have worked in this case though,
> and that modern gcc/clang usually complains about suspicious/
> unintuitive precedence.

Thanks, I guess it's subjective.
And I do understand your point regarding & vs &&.

No need to resend because of this
(or update the code at all if that is your choice).
