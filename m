Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629AD689F50
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 17:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbjBCQc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 11:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbjBCQcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 11:32:23 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2115.outbound.protection.outlook.com [40.107.220.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8608A8403
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 08:32:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkjq0d9kQ2rDAcCV4+IPYJmWX/KXQo8Q1K2sMwkfVE4sNWt/XYP1Ywb2qWbzJLXijvUIU5rcRl3qqLzOI9Z9yj4cgHOcMYAewF24HeJuN8bd8QQT+pxsQWI0i7VstS6IdEoCEzwo+8n7Ru4MoQ3oJeZw4L5z3ywxhFL965ydeEmgYpD7K7qCBkNYiVVyDLkBsIg6ceEqL26n7s0tbiTGeWtoMihxF/ww571CA9s8iEyA/NMe2Jc5wDO8PZ2qw0TdStYt4IUYImWQ4K6IoDE74fTJbvWqlxUjxnnd8TkDS2lc+mjeddg8oVn5e3y0cyornXj5wSFAVnjdmTMi4ZYZzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ap9jRd54R2tItTvdL+TCiiuJcu9OwyaMUWzeZosxPMo=;
 b=OcPJjYoi53eTDOmI6e9Y5gK0TGUunKfB+zWtmTztrxYOoxPbIXJzGmusRY3hV8of/BA/wb1pedt+Vo3HCcJ3T8NLLKMvqM1LQSkOrSep5Z6FfIC0B6YVvxq4VdFTl0zo2QU5XQV8mLgZamHXbPwM3DWBZtb6Z11u561QbIw4EYdh5WZO5ifbDzkoxOXdu+nvxgUWHn4VA4ElMSFR3zfpRhSilKmHE4PfrUoFwxUpzCpcz4XpH+bZWvA9dCoZfVHGp2gsQw9vdyLBsT7cCpZtojg8VGsva18dOE69SpbKIij0fyPvZzofvgE7Nq9eWUUxuKk8MNu9CJGwJ8x/7tAaNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ap9jRd54R2tItTvdL+TCiiuJcu9OwyaMUWzeZosxPMo=;
 b=Svt6DojhYBSrqXG+j95uFW6OM0AAlGphU4GNxz9DQ0/9eP6yIOaAEQhjs8/ccv18BMx0Kavj3TaHfpY41x9dbXS6LlWPXcjltpdlgzyfo93FZF6+PCgXa0kqVi7xDND065cLtd/tXQsACgpzmVwj38WXpWn604g7CAXycc5eA6M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB6156.namprd13.prod.outlook.com (2603:10b6:510:292::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Fri, 3 Feb
 2023 16:32:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 16:32:18 +0000
Date:   Fri, 3 Feb 2023 17:32:10 +0100
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
Subject: Re: [PATCH v5 net-next 11/17] net/sched: taprio: centralize mqprio
 qopt validation
Message-ID: <Y903CuEDJInw/lN3@corigine.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
 <20230202003621.2679603-12-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202003621.2679603-12-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM8P251CA0025.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB6156:EE_
X-MS-Office365-Filtering-Correlation-Id: 8671af26-3438-49ed-e588-08db06043758
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w4jf6wVOurs8BqYYpnwoU9l+vn5vRlyTWAS8YHlQ/Zi7nC1eYLLRXiBOjEBUQB6X25hgj66VNs94v0CxwGxCPyzLAQM8g7kssnNKQDam4cysAaYspZ/VmEWb/9xZ7mJM4D5PcTXd8KXqr6VREirCkCRmxMNu4+L0wZRPUF8g2DXOMrc2mA6rLsQNRrcJJapi1yfFkGMmwMupvb2z3hJcz0gvkHsEtHxfGUEfZNQN3zB5VQ3/NUqYzXT2LzR42+u3LFY0gwcV8GMVwDvsdS6sr//i+ZKvTK0pAbLgCP9SUuBz7pEH3NgpilCwZVq2vVOE12U6HTD1kXTjqeVp0IPFkFLmd+UXJ4PyUud8WBsYyq63F9IrnX1R8JdYtvaeHztnDgN9Xzj3rSXRmwk8XkwFnyADyB/hFddNjkYJazqMsOGpxcY+BZp0FJMxy6sip2g3dzaVJoQ7h7md87ABxriE7GRjBgbKOo0jGj3xu2FjLg0qAzr2qN2z6SvGM5mFaiSibSGl2+NITja7esol++jsFU1siTVrJFlq7CN2UmWurXOpRiVyMObg/Hlo21BLMjrc7KDXueSkDP34U46E1V4Tz347gPe9c/uTMFI5ddkVNdyhRcmJI9apHWkk+YtkKxbHRa7EPtV7eoTres5sDMhimQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(396003)(346002)(39840400004)(451199018)(38100700002)(36756003)(86362001)(6512007)(186003)(83380400001)(2616005)(6506007)(6666004)(8676002)(44832011)(2906002)(6486002)(66946007)(478600001)(8936002)(7416002)(66556008)(66476007)(5660300002)(41300700001)(6916009)(4326008)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WIW5ynGtF/0mmg6OMbUuh946lSK7o6IODobyRWLdsVQLR1Y2bniYvhIl5oWl?=
 =?us-ascii?Q?n61nHGQaDgGAUHiA4mATAEu6AMfj31CGHcqAET+VVdkMCWejxXXljqhxUIae?=
 =?us-ascii?Q?CHawkPEsSGGEtEqt0Vpj/6OpAC7hv5PfXjpDZYY8n8izP1LXKPYrhbnVVykX?=
 =?us-ascii?Q?aBTX+/CkXgA5cjIM1FHqvjz7FBBMALVDBI4ZvaG2rYenWiE8ZWyGLU7eAxRp?=
 =?us-ascii?Q?ouu7+uQY5kotNYaG4O8UkTRwkcI4ji5WfvmqCwvgeuwx/2D5AA60Bp0laAu6?=
 =?us-ascii?Q?2lbmIlG7P+WDC94wenIOwgBJ7cNbcgwFNADmpaZIl+FP7Rx+xY8QCIXpS0S3?=
 =?us-ascii?Q?dshH5AlHwv1VhFmWSrPDR48qoRfWqo6AEJ0sp4cwU0kzZXIdwfx90U4fZrxl?=
 =?us-ascii?Q?9sw6/mAaXh/OUsLllOzqaYPYsTQ8rJoMRQYQNvZQ9d/hjJpKreFJutAz66J9?=
 =?us-ascii?Q?Kk2HCihWljYhb9HSyWOyHoWNeCjZLAyTY2oUzwgwhqPa0QxJwlZVgFydsEJL?=
 =?us-ascii?Q?1ui1LXFKKUiDbh6J12kPnfDsJ0fkuOeTucJu+xrUXQY2Kvfa1tO6iJvWNiwL?=
 =?us-ascii?Q?q9QqVcohqyuOxyaVmo0stRXZbhJioEQu0hEdLKfcGERJ527O/7yenF9U0HiR?=
 =?us-ascii?Q?3qqCnU60W5ogBrGQRgOptD4Pm5Wmo1/GNHNXunQfKAKRtAQYiuuPFE0RigjF?=
 =?us-ascii?Q?4yHhVoXJEbKz/yEt+pjhJKz+gx8/cVY1LC/Ko5rMr7xBByRDECtgief75EIc?=
 =?us-ascii?Q?fHF8CxYdTYoswSbKfwxVNLBOYsCH2ta0tpiuT1E36zdkjBp3S6qZV8Y65Mq3?=
 =?us-ascii?Q?stX5tmUxoiqkkQzLBHO8LrpyaYoudKWCrhrPKxaoB7SaTEm91dyJoVfgIt+F?=
 =?us-ascii?Q?P4/x5GUIQoLPS9oMPJ4ADin6oEvJ9tDM7ZOv5s4MVmtg1Kl77OM03jjt1LcZ?=
 =?us-ascii?Q?EyumqQnwi03Kf+hK/6Jp9zprghGDKuzPmuCGTYQutj/2vRTkZLXScM4TmlUB?=
 =?us-ascii?Q?I0ceCcFee6+Yhvng35/C6k5klmeNz1Zzd3h3Fc3oyHUohiuY82eSpJ2uW3LZ?=
 =?us-ascii?Q?kMB2MY3spITqVs/yqn5T3ivfJ/zzhlnREr2k4tpKBuBxqaqN/xVp6WTwrQfd?=
 =?us-ascii?Q?Fpimtbe8WrBHqIML8HsytR1B4VsvR8ClBKbBnp4LIpFybVHib92ewUgrUkep?=
 =?us-ascii?Q?tQ/4/ypgUSaja1fuUHuhaFyGXgFjWj75yml+RtMbBb7KuG7CDvBzf5emg2+p?=
 =?us-ascii?Q?y4MHM0ocJkD7CJatNt02QLMjQl7m9Ss4FfWwlwDqTuMKKns02ZG7L24aR30C?=
 =?us-ascii?Q?S6xEosLSIz3C2hQGfpnQ/c+rpJYy2r4vLGib9F3N/t+t/pfypB1WinU9Xh8Z?=
 =?us-ascii?Q?v/8pi6KxXemZmb1ptjYS4T3BapnduNf1bDwyhJsURhk8CNg+PSnKpfUebZpk?=
 =?us-ascii?Q?S63EPazBU8aD7nKnuSU+a62AnDIK+mqfHZLAKKWvGNVmYhHlRU0+39EK8uRN?=
 =?us-ascii?Q?KuLsbo8YyD9K425HOQ6R6ALui00Xaxd38H9OafOYrakYso45sl69Ar9ot7fw?=
 =?us-ascii?Q?mYFVlNSo/est6BL1SV8a87ssranvKm7hmX9NNjbPtc6uObdN4QoIeZycdfhL?=
 =?us-ascii?Q?YhwGLmxSEVlcu9Wo42+zzgdGFe1HxuNzPCxGsM7d7I/1c0wRO8OHTSIGSKRd?=
 =?us-ascii?Q?IbdrUQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8671af26-3438-49ed-e588-08db06043758
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 16:32:18.2841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F9hjV+aseB1aMKyZgGDb9ysxnsiJLJ2aEe5x4L7J+RQpuOOQXAaHTbKWA4xaUnuHWnr6/PphBiAzT4AXj6qWfWzXMKSgy+MfPIA1sYvTdlg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB6156
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 02:36:15AM +0200, Vladimir Oltean wrote:
> There is a lot of code in taprio which is "borrowed" from mqprio.
> It makes sense to put a stop to the "borrowing" and start actually
> reusing code.
> 
> Because taprio and mqprio are built as part of different kernel modules,
> code reuse can only take place either by writing it as static inline
> (limiting), putting it in sch_generic.o (not generic enough), or
> creating a third auto-selectable kernel module which only holds library
> code. I opted for the third variant.
> 
> In a previous change, mqprio gained support for reverse TC:TXQ mappings,
> something which taprio still denies. Make taprio use the same validation
> logic so that it supports this configuration as well.
> 
> The taprio code didn't enforce TXQ overlaps in txtime-assist mode and
> that looks intentional, even if I've no idea why that might be. Preserve
> that, but add a comment.
> 
> There isn't any dedicated MAINTAINERS entry for mqprio, so nothing to
> update there.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Signed-off-by: Simon Horman <simon.horman@corigine.com>

