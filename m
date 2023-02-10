Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D611D691CC9
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbjBJKd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbjBJKd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:33:56 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2110.outbound.protection.outlook.com [40.107.243.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE586D609
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:33:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EUU2nCAg3fJjDqeFb/oY/cO/kwyg5NRvIwq2GtByd6cVOSuMWWf7opvWTtBs17Uv3IVPUhsSlz0jCRyWPenVxScVG9VfTYFwtd/8eNtpjqkbZnADZtRhuz9GIArKPwDn9B/srILLZkUkpGPYqQSWN8GpFJhjgEhA1pVduOGPZiBizV0tEiupvLvSfDkO6JmH/1gZjwqNMeIdg7p/26Y3aJiljFl/UJ7QzTonbKbyYwpbea6Et8nG05ZXJJFjdPhyFw73QvwpT7Fg0XBNLOsdxj699mBFkcpgZv2Z0hO0cKMK8NO3XhIJtgUarDs7c+q8QSPRHW/bvS8NvOnGWFTxSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFP1ycai6qjJ2JBmph4dakRRu7hNRmo+EztuHzaZ89Y=;
 b=UJdisyghPW4B1e+1tKqjQzx9RiVE8hwbKA/vQgzOuJKiuz0Lc+AwxXp20hgnmTwUB0GCY7I0PxBWPePdc29lmr05UjvDgT8L1qmJHWb5bmY/AT9jyvuvb8pw7dEWTbFnfYnQcG4KbhNVJBQnNG9YN+CRghgYWYf1Ka36wMao6h3ryxAIz7xdPpKYomNTB6u0Vj9vWnvH+1yXqa8IlsZT5BUqHqcad6s1T4faAt15fcsE4g8Lnbt5fl3X95Nnqz6NX144yWrezljZvo5mQtWR0bQWmvvFtMwaw8WHdpje/DzITjQ9ww9Gn9hgoe9DSVEyF1l/AwZcVWWMwwU/3HfMDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFP1ycai6qjJ2JBmph4dakRRu7hNRmo+EztuHzaZ89Y=;
 b=mViVayo8UIAlohpr+xXx/tqhKChy5NN6/kqQ+Q4ptf6roKori6sPijUFtqRk2lpPZAl6UO0CAs7uNB6EovfqFph3qVtTgPUCIZaC69GBmt2NvdrsseBAfpdayZxE9AvkZg9labsUOK99vQo6frxz/GRFCzi+9f3Dtv/OPQ8tYqA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4789.namprd13.prod.outlook.com (2603:10b6:303:f4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 10:33:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%9]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 10:33:50 +0000
Date:   Fri, 10 Feb 2023 11:33:27 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com,
        saeedm@nvidia.com, jacob.e.keller@intel.com, gal@nvidia.com,
        kim.phillips@amd.com, moshe@nvidia.com, idosch@nvidia.com
Subject: Re: [patch net-next v2 2/7] devlink: make sure driver does not read
 updated driverinit param before reload
Message-ID: <Y+YddzEwYA9f9RIZ@corigine.com>
References: <20230210100131.3088240-1-jiri@resnulli.us>
 <20230210100131.3088240-3-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210100131.3088240-3-jiri@resnulli.us>
X-ClientProxiedBy: AM3PR05CA0146.eurprd05.prod.outlook.com
 (2603:10a6:207:3::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4789:EE_
X-MS-Office365-Filtering-Correlation-Id: d4b86718-47f8-4958-8761-08db0b524c77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9UYlJj3aKBiNfnw7kPiDuTTCW5Y6tu4ncZ+vZ+vAWsQ3DaoZ4lRpAM+/UbEK2aF8DvSlaiR8His+KyRT+IZPczhp/JF4IqI9fbxTdWIgRL2hEDQMzs0UrWf7cJn24+7xlpst9flx2YeLjwcPs2JOTU2xWT74O4NT4o0pQCxNKtLG8+K5YEiOzV0pm4Hlto+qLRHWrF34Uwp76neU5V/1RcE8ye3nwMxM9PsMgxNpXpa/GoWwDTNYR7f+hFNVps+nIIjgqX6FXz0Z3nKb93sWisB2rqAFDAPJs24eWJYhmIO2A2BYvXw3wJaxlgdxp4ZEK4jp7cyfnQjvNtwUzy3a9Dw9/iMgcegGAtai8SQBNm6zwFGezyRTeClQM3bET0pZ9kkkmYY7f1tPtd0o5lYs3cQg6hT19s6HzWnTrHWOmgpEtJq61v3N87uuyPTK1wdvTqL46PKyImlGQfxgd2mlK4lP+k8u9CEA9iSL/8fHxpowf0CbfukfWq6ASvt/E3pMeReP1i7BxCna4iL4FwL1TjkCDogKWzo0cKXeM1RY0xJtz8/sZ9FYMpPxiwg5e00drF96enQilwOEKmDX7Hylg8G5IkAnK+xOkHOPOo25dFTKVWDT0XGZKE+a3Ql47m4WXlrE58ZRngHGTrlRx7OYVeDWiDivgGwPHmbjAJBMzh/+JYhMv+LKyezSj3/o9ukj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(366004)(136003)(396003)(376002)(346002)(451199018)(36756003)(83380400001)(186003)(38100700002)(6512007)(2906002)(6666004)(478600001)(6486002)(316002)(6506007)(41300700001)(7416002)(5660300002)(8936002)(86362001)(2616005)(4744005)(44832011)(66556008)(15650500001)(66476007)(66946007)(8676002)(4326008)(6916009)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eZzgSyfbz0KmpEulvRstXaD+kSeQwGa7Bablb07ImX5Kr+D1dJmRSsbZ6AOR?=
 =?us-ascii?Q?EKWqglbLOfvsj9bg5VxapdpD+IfAH4EhW7gMWbLeDyz2VVN7WXKPoLdONm9D?=
 =?us-ascii?Q?KGsrBmGjfFY1EnStEsVayLYuOfs4xbZIHjIpvwEVx2rToOGjkrhZrbcQto3f?=
 =?us-ascii?Q?kOjaXnwhLE0KEdpE4YM9cvyJ6IGBwnWFhvpDBtZWfRhh3y6u8BkqaTDpvjch?=
 =?us-ascii?Q?vgYqnuiQ861D/0LbfAK0vxdx6qEjJ3OgU9JOxzd9OLeZKkE4Mv9y6OMGqJUq?=
 =?us-ascii?Q?acQ6SP/2I2HhWPsAMQyuTsMj8p3C9nTtByHWW1kNL7F2srtVhCFdp3YJlLL7?=
 =?us-ascii?Q?6nDlcx+nNls3ek/OTQXN4DeWnwfVJV4cbwH8JhlhuUsGJ0725YpVZ95559iT?=
 =?us-ascii?Q?BN9cZJFp8zcs2/b/LbC7Gz5H+mDFFKGt9kf6mSlvMZWPtDP9LO+OfZ8lPS3m?=
 =?us-ascii?Q?YWPqSHDREHmAB+HGjmkDR46HabQkdwaypxLVO0FFZMyCcu3ppqRXOnHO3U3q?=
 =?us-ascii?Q?xnvOk2MsBlcnknrsogtADxX7qKZHkqzc1PIVcAgzsqrQp8ozQ09penkkViSe?=
 =?us-ascii?Q?uT8DXOSMxBLuZ3eoowGhfM7OAs0b6rxGN51DyuoD86390Ud8pHXnq+FoAMdu?=
 =?us-ascii?Q?HnGSilr69A9LBAdifzYgXJoJJwQwkE1uEkPCKrpOMHd5BLXy/KYiV9u+UXwF?=
 =?us-ascii?Q?s6WJojxp3EaBB/0Av4Wgg7AvO66VeY4MQYVOwgxgccYzj9IKbFGZIzfNQJ7L?=
 =?us-ascii?Q?mtiT/fhzJrObeKSsntuJljHkuN7L9ruIXMEpT0ZreY2BbkxG8ymnlLDBz5pd?=
 =?us-ascii?Q?WFHg/jXobILEPImoFo8bTPNPTBdurHZFG9LFITy5HexGRMxSfyU872lWgTGi?=
 =?us-ascii?Q?CKqb6FQiev7uPmnUCF891pGKKbLq6E9H9Wlxegs8nOV3jD383XyNd09U/f+2?=
 =?us-ascii?Q?0dlH4ALKLxF98zpCXB5PoeUwn7dpjxGfv9+LxBLoUIsIqYd92pMr49uXBt6V?=
 =?us-ascii?Q?/3LQI1URfJcJYFEpXtRq0JM+hMtPF7RZIxyNc8iOZMJ2ucNbRWKCcZC+cN0G?=
 =?us-ascii?Q?MiG3Ad8CS9KlYy28KC5pADdZcu59XhmfmMLDJ0f2wH23GOg0Ms7bcESzjXGM?=
 =?us-ascii?Q?+GQeK5FKda5ZJccTqmbO7hhApjC8dOmA0Kb4cqMVpWVe/sokJ6PaoaNjGFko?=
 =?us-ascii?Q?XfP7UAcX7zJXig7BdpDriKxQ6AsImq1999d6uLbGTjwTi6Or+KzLFK84aaLO?=
 =?us-ascii?Q?TyFnUiG/63dIxSvCT59ps0ZA/Mk8hetSHfvXYC+Tk9ZkTa4PWvvdfYZUY7eE?=
 =?us-ascii?Q?xA3TdL9kFhBdzCgJSR8WUK1UHB13gQuwkThuX0TCMcLDSUYcouVk9eEqbgUl?=
 =?us-ascii?Q?VmkTs5DaiHHzWe4M1vfMYqvQX64koM8GFCg4sM5W8uvDE4VF0+Lw4u7YNWWS?=
 =?us-ascii?Q?0zTLRVQa2OvDsz8/6PWQwJA0LfA530tAX1sQCpMAOeErbDH4O3DVoqB8Yced?=
 =?us-ascii?Q?2Rciz1sk0P+NSLigH1Jt5WrN/FLeJsavhJ916Sbkjog6AxvWE4yMBfd2luo3?=
 =?us-ascii?Q?LnTlAsT1lYVBRKbHYdkZTDlGwNVBlmO9cNa5KHlA1cmK+kIi7B9YxhfW6OEl?=
 =?us-ascii?Q?bCAGKXvOH7XFoIrXqbOsPu/YsaV70pRp6dGxs5WFrInX33U0DBD0avzwxp4B?=
 =?us-ascii?Q?7uFdwA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4b86718-47f8-4958-8761-08db0b524c77
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 10:33:50.3683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0UqYM4UWxdXFDO1hCGXUlVnExS4Ykg2MPYyCdoqDc6xYvzIqXwxGxBqk/SiQQfSwmM/nloiBPS4EgIINBQn2ZceQmAwz0FPdN3EO8JN98rQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4789
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 11:01:26AM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The driverinit param purpose is to serve the driver during init/reload
> time to provide a value, either default or set by user.
> 
> Make sure that driver does not read value updated by user before the
> reload is performed. Hold the new value in a separate struct and switch
> it during reload.
> 
> Note that this is required to be eventually possible to call
> devl_param_driverinit_value_get() without holding instance lock.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
> v1->v2:
> - extended patch description with a note

Thanks!

> - call driverinit_load_new only if action is REINIT

Reviewed-by: Simon Horman <simon.horman@corigine.com>

