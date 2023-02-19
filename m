Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A2769C24F
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 21:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjBSUe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 15:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbjBSUe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 15:34:57 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2127.outbound.protection.outlook.com [40.107.237.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9157F1630C;
        Sun, 19 Feb 2023 12:34:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCNj1fRnk86WJIrofUuJOeYXCN/eA911tZrz1JaW8MBq792N8swTk3aJYrbTPTCyNqd3e0BU9yBdOQYnYou0Y+OmK1ZICsMNjW6Pswrv4OXRZBFgRu4xeC8+n9FQPR9zZ1CN9d3cU9Xv7omv9jt+3k4BpU9543UAVOOuM0y2osjjzpKcHPgNchaPx+pWeUqiFw74j+/3qSqp8SJamtoiX4wj2O1h7PSQArjOSkTid3oSkE3FZ5yI6rHOuYChzMft78+BXsmIUncy2WzGYM2jOoFWcHrS7Ow8JHCNIows9uHnsL+bLtVpFYlrRA1imKdUMvtY5iH87bbncgVBdof36w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cK+ioT6H/Hr/JIL4RFRzMpDaWXlT0Ij8aoP0KhZXH8w=;
 b=cOXTPJwEkAEaekZf5Jq6jfLymVAQ5HZllNdFStYVerQYaiQG0ivKRWAVNCR1gUsEhM5ci8UNK4NWXJL4M+25ZTZl/z0Pr4YfNYxECF35DYqsdvUZm1M6DWoLfgppblTu3GCbEX7FxvdUyYy58iVnBiaRh65PQszYsEnoWpNRpr5AyCwjOI2zHdCkf3qqIquH9hVG2Qosmf6Pa/uSd9bcecr7yIHecdtd3TRQ2Jj2JrWEPqSOcnKvxFQeAhr+QIj6EEUWUNYvNCV2+l8gpkgFc7GmrmRnfcd+Tf3j7vlBuXeNXvcZL8NR0a901UpjRRzL+xFYaDkoHAjBYmxU3AZ1NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cK+ioT6H/Hr/JIL4RFRzMpDaWXlT0Ij8aoP0KhZXH8w=;
 b=RtGDPR6CcAIlcvSXFhvpYvsHYSCBHsSZVu8wuvy1gi22gNYhQtsSBPsbe/2C1cF+mskj1Vp+W9GF5KJ++obdNfBXgik2klTMbqdo8+0nnVk/Y5zmxVfqFIpdRK+snVXt+448+I6me5OyjziG3y1bEuckXg0wc0VqlLkljjIaScg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5802.namprd13.prod.outlook.com (2603:10b6:a03:3e9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Sun, 19 Feb
 2023 20:34:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.019; Sun, 19 Feb 2023
 20:34:52 +0000
Date:   Sun, 19 Feb 2023 21:34:44 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [PATCH net-next v3 3/5] net/mlx5e: Add helper for
 encap_info_equal for tunnels with options
Message-ID: <Y/KH5IOqcTbWZ80j@corigine.com>
References: <20230217033925.160195-1-gavinl@nvidia.com>
 <20230217033925.160195-4-gavinl@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217033925.160195-4-gavinl@nvidia.com>
X-ClientProxiedBy: AM0PR02CA0107.eurprd02.prod.outlook.com
 (2603:10a6:208:154::48) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5802:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e20b001-9fd3-4d37-182e-08db12b8c0a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zmhMswiWTBLF9KKxquJ7xn16PZbw07LInqfz0eYRHbqdmOu71IB+GqiMQHApd1XDxkcP5anqab/f6zn5PzKM+prJE0Qi+Kp8af93MmVjLB+BH4P3+yvCGSLMR9DYzSxt6yAs9ughAjgp3vXY0K78rjA5VSStwqDGO0hQRkQT4GIxC1FLhZ2PuBGLf8wSAGB8l7bmuFhXMI3cww66FlC9CQtalt2YECfGLQsCKKdsc3i8+G9ZG0ckhzRkeVv/D2P3SCdXRkHuLtEjjlg1Ix4HZWHylQQO8sO9vkSWFE39rLilWwLG+Jrndhgz8OSkGdBXxKzCQPoWnST7v+orSJ3E2cEmYQfTgo87Tijpyzbtf30OFcH7avhH/oZmqjlQ0AbY2M6p50ziQhDZDn1YVOzxpGqfCzIOtuBNizbEgWT2WqRXT9BzAQ2CUYs2mQToyOybH/G5zy2Kn7tnIplQCXnAGf2N5MR3Y911VsXiqwXdESpt8VrLKsSosZ1F2NNyPZVJc86oiDSnLutHu0ZfPKMGSDnlTVBErIfjeHXO1g7WAqff3L/FKAtcbhSclgnaclWDoEiI3vHE5wLvm0RcfqvHiQWwIgwY+wrKz+Yjz1o+lxV4uGgHBzkmVAmbXhBjQb6M+1Af9lJaQuDaEsHihRqZOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(346002)(136003)(396003)(366004)(376002)(451199018)(36756003)(41300700001)(6916009)(8676002)(4326008)(8936002)(66476007)(66946007)(2906002)(66556008)(44832011)(4744005)(5660300002)(7416002)(38100700002)(6666004)(6486002)(478600001)(316002)(86362001)(2616005)(6512007)(186003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NEqpitLr3anOVtUFxyJn21ym9A12JsCIaAqFQb6pi6f8hyTd85HaCNi45zuy?=
 =?us-ascii?Q?gBt/I1SDYuzf/2HmG6BVdy8WQoWjzfahoPR55b+m5O38XAM5YG7hN5dely7G?=
 =?us-ascii?Q?TX4t/ZPfXxdfpnoEEbKtfjYjyfnV+sDfD8mQp6tXN+NC21SuzGWHNrbRfn4F?=
 =?us-ascii?Q?Dha8yXC49gk5M8TY4XXPay+7Jyey695Y+a1j7R1LXjZ3rPFBTkgU/KcKfFxG?=
 =?us-ascii?Q?uwY1WRsKsKqzf6r4GJNmLkyK3thmLNjpw54jp+wjSN83Nva0LKhfYFQ1c+Nd?=
 =?us-ascii?Q?dI+e9KxgDuK+YwMN2H+Sd2b6IVGFASHwbT3wGqRxF6wA/chKsiJ/FHuFloOm?=
 =?us-ascii?Q?JEHU9TZkvRcCMcnbXbS1nxZDGwjHTUZhLvJhCXbxq9jrjmXTgHBuv72onc1g?=
 =?us-ascii?Q?JbdYYp6+gX7QLayTPvPgA1SbV6EZ817CzbNxwP2AxAdiSu/TJa7+IYo5TLOF?=
 =?us-ascii?Q?uFcu8j3ZjPO79Hgv0/YNFNiyp/+r/rIPzKAnrIPGBJPAwaf2mBzumJjxQ5E5?=
 =?us-ascii?Q?dVMNHI0MgS2gbxe4PUabzAnYXkXgSkrxaKTXvnJqFWBcMsgyrzsDRcVe1w+l?=
 =?us-ascii?Q?x7mZIClOtR0gbXPvLbg5lQxgtGhaAeY3/Z8o1rp+U7x6lHV0zos2sHPrjr9h?=
 =?us-ascii?Q?TlZ3LZa9shIwVXB/hMUTYwJwssq4DzPhrkGGIHQ4p6S4DHtG9BaBHcymlCZ5?=
 =?us-ascii?Q?tc1gEoEEwLTm82Wj24W1N+6lw5YWdMm7lZxdgQMmZFmGBEeYfuk1kojbWpGh?=
 =?us-ascii?Q?Z+rHYyx29nUTGoDrp/p58bXiHM8HO0XAD75ZwOJ3qWdhJa+YPH9gWDIPo5Uw?=
 =?us-ascii?Q?oZDwijsiqYcPtmkVu2C4kKOVyIMP7AeaIh1XUIfaiFIFbIDPfQYve4jmcJ//?=
 =?us-ascii?Q?d5sMwFWQUZtbm3GHsTQhMS9IUnCbDzC+nSWaeJ8AU+lD+zaIFQsmL5EIN3gL?=
 =?us-ascii?Q?JiN4fDXNOcISZN+GS/qpLbMBGH9tcI7ImrvhmVhZrYed7A305Fc92Trb0Und?=
 =?us-ascii?Q?F2A/KpZxwMnsg92DHlT6n+rNlv0Om7CUNQRLjtbk6gVtxyjU5BiP9q97A+2d?=
 =?us-ascii?Q?YhHKr9KerjY9K2iX6hRys2+xcrgMCOJQ0Ug7QpJIG6JTFlBOY29ckAAehvWR?=
 =?us-ascii?Q?bUmU/KNumFPT1qo94OKKh5T2Sx0s7CzdinDg7rTl81ftzrkt3zFY0+a8qv5M?=
 =?us-ascii?Q?+WJb3yHCa0ndOUBqSCmytS6YBLwnzqtNXk3PdKedIRoXvjTDBZtsDzcl/JpF?=
 =?us-ascii?Q?UZC9FN5BdgNiWALhCqM1LauPY7jzbRWrzbzZYhwaYv+Qzq2hAWSnqbMfqz4L?=
 =?us-ascii?Q?ThZq5YNQKx2UIVAR2MqqPhbzznEwGs39Y79JjgfJG3bqdKavswt+dUp07u37?=
 =?us-ascii?Q?/SG1vckpBORMLUhZb/P4Pvh4slqL3+DXzitktoB52TrKrpo9LCekjJPn1a4E?=
 =?us-ascii?Q?aUDIsRxOc3QLfPUYaJ2p4V34eEKd/VIkNMwGvuEQFGQdklmqHP1hNvKzzd7h?=
 =?us-ascii?Q?eQMwWV558VVswrwRD0D9dqO9c2+GLlO7f6XP9QoMK51ajvgayzSNI5hwefPN?=
 =?us-ascii?Q?IJVMIAxo7eGv12noFoN82ak7HWfVv2IO6stKYfosdFhwe3yH0qJSCckUZXXZ?=
 =?us-ascii?Q?4XSvaBd74JJz+KFNEicnMVYiAH7PrQdJGRHwPzQvkJ7WaUkglHkjDG8OBGrY?=
 =?us-ascii?Q?fxE4vA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e20b001-9fd3-4d37-182e-08db12b8c0a4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 20:34:52.0049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Xi/pnMCPfBHOmOrd6zEcd244AMout4flM7m6JDoGYtmx2YEWySd8fPj6e38hkST791WK4uH5SFHDvj9kkFN14GJ8Okj4impHLARyEhsFBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5802
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 05:39:23AM +0200, Gavin Li wrote:
> For tunnels with options, eg, geneve and vxlan with gbp, they share the
> same way to compare the headers and options. Extract the code as a common
> function for them.
> 
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Acked-by: Saeed Mahameed <saeedm@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

