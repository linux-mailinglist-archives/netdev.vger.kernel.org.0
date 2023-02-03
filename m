Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42038689C3A
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbjBCOv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbjBCOvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:51:25 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2118.outbound.protection.outlook.com [40.107.100.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F249A000B
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 06:51:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqTax62vYsu9PiRobRPIXtedBttPn/jPKefPA4pDhP6m6taU3AEGjWVPQuzXte1me39GceJIMUdrvoNJkzmquOOSlhlFiwxdeh46YlfrHUCvR8i5CqHtBiH/WOun0X9rAje+boUfUVu/VtsBI0OXqDiYdtdNYk0RR1k73qhRU7DkYCLd5be0q0r2PcAfAs4TuKp65y8Ta2ot3JZd+/agnyfPOVXbYPICej8ahKDi8/4ZNlcC82urR8a1FhV7qF4OnFazGtJINPmJxmWeW29J1BRe8S7S2+IdvhuD7gx1WDkfoMGfUpNIveE+flqsyAUA3q82diG88ZL6jNbzQ67HWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X5qIr+FC0zk0rdNH8Zl44dVGm4w1HaTocC6H+fg7Ca4=;
 b=Abt/HShRWqOWAa0Zgtc55LWwIr2sU11pd1AL+h932k3TT7HHvBo9wPhXDZX6XkEklB+RWs/tgex4dXYatU6QfWQD2NSaUaRN5r8NAQoc5pv3qgqkNwOyo5kLh0jitNpnFrsEC7EXlP5lcHmLAceKurJfmm2YtNnY937WuJKK2w1WLTTjTUVx9yMn6lHdeu/UMeVj8L3uaKu4L5ZpJKbVmrHZ4v5Zv7+VMbJjsUU7r9TdJvB7rvbJaExfblWAOAA0R1d4HoqFdgwCjHHxYparyv012QgJdXxOWKtxwnvZw92j9v3S6sx/lsraU7FQ7z2jphy9r6M5/06WRvBIZYn7bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X5qIr+FC0zk0rdNH8Zl44dVGm4w1HaTocC6H+fg7Ca4=;
 b=Qb+Nfv7rLM6RdwGPTWkmf+M+VIeJuANxSX6d5Azcv3sA7U4WCXJ+PjddFxl+KpeqHTxS04GLUplKZvwlT/cF4GdE3r9FFoKOdZG9Iqet6byIgyASQkjhky93prQvECYRWEKtyTovsRm6PxKu+GL0401ZCzXttkY3cCnpfuI/Zz4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5526.namprd13.prod.outlook.com (2603:10b6:510:130::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Fri, 3 Feb
 2023 14:51:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 14:51:13 +0000
Date:   Fri, 3 Feb 2023 15:51:06 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next 5/9] net/sched: support per action hw stats
Message-ID: <Y90fWp0ltyK85WFL@corigine.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
 <20230201161039.20714-6-ozsh@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201161039.20714-6-ozsh@nvidia.com>
X-ClientProxiedBy: AM0PR03CA0041.eurprd03.prod.outlook.com (2603:10a6:208::18)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5526:EE_
X-MS-Office365-Filtering-Correlation-Id: 23f0e80c-9124-4ee3-a4c6-08db05f6186d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O0Ot0JUQwMpvjqXzKmekw48Intivm+qxCP1IoOnPnGVLf8vLZeEeQQXTOxL0FzLInP6QVFCgNR5sYnkODIAViauujY630mNBJupUZhsTVgXcuimZrTvsn6tbVBTM/0dHZC46EA+2rmSvg1GJlYOXGpMyh8wvVi9Nvd40ThAh0P/rS/+wHGEyyy+u8AiLeHpHBHyyDw4V1JfWPlzGi5gTutDO76UW/VB0zyrOjZbtRYak3AvITZ+ohc018uiwBT/z9r/Rjj+xwoFFXlkwRT5T/V9G/IqkNOdnyGz3+LJv/QGBbyVm75udvutCkqbfGyNVrKlPz0ZDR0Y24W9COuUz+tSeSew8WUEpg3kDPpjRzs3gEsnpbFpOJDf8fnOIxKkFAozYkrrR3NThsTxEO1KNod1WDuNL5DvnHhu2nWnXQTTsdGmy4cNMgR7SsoB0ZJo4afN4R20MsCiWpe8XfhCLcv/YtNAVun6DsCOSYQ3/e+xeVG/Aehh66+3bt1kgSB10WJzLud/zHK4SM7Yod/Lz/AAJmF89cKjaqqfkPKwszCD1YyqXklWyPxCXKsu/M1GVNXYaOyCV6e9ZUHYjrd/10ZaaUSgJPDarsYzG3Jgyx+4GNu/jKrEwD8VkEho/2Q4otIhryW/mBu1HRF6B3eNj2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(136003)(39840400004)(366004)(451199018)(54906003)(316002)(6486002)(478600001)(66476007)(8676002)(66556008)(4326008)(66946007)(6916009)(8936002)(41300700001)(6506007)(6666004)(186003)(83380400001)(44832011)(6512007)(86362001)(5660300002)(2906002)(2616005)(36756003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6QQBxUcupCF6FFeAaI2LY4QGt7B0hGargF6AWlHvJbBLoxN1isNQ6cXjTgTf?=
 =?us-ascii?Q?ciJzdZqRpUGyvLojiUvGn/Pwz/ao60RTqT/XSGKygba+cpwnhs5gYZqbl3/S?=
 =?us-ascii?Q?tI+EO2WuTOusvjKZdv6cHBXkmt7D720AW8TaVqegGPizLxkVTjNSPBYlDBwX?=
 =?us-ascii?Q?PWuQTFIpSr2abanzfDCePaXq5vit7nJ46vWch//krFjJnY1U3o89MtkMPlSe?=
 =?us-ascii?Q?AoDPwcAKDXWbu3HCLTCPR0U67x+mLG7w2ydK8XRAx5+7lXkMvLe6iQQaiU8m?=
 =?us-ascii?Q?iyD/CT5YT6UVuXI5c+/BjzH9nDexKBM4l2l92LAauRsreGPY+lLLilE3Vghr?=
 =?us-ascii?Q?+4MpTC2w6XVcN/JHiu3G4sDtfOtC9B4Rd4DX2za7kJy10oqE+H92Xb8/BbPj?=
 =?us-ascii?Q?HIc9GqohbVI6XNVjZLLKAvqmzXZP9oRzblVfqlo7j+d7HhlzAvxuwOF0WqPl?=
 =?us-ascii?Q?LvesoXc7S6smjtNlbbR+xs/BIct33q6HI82DiH7mDS5dpUOv8R/A/O8KmqR1?=
 =?us-ascii?Q?e6NXXN/3W91csgQiUw2NsNwFFxAl03939kbujy1PfdmPcLE9v3CefXzEUjrk?=
 =?us-ascii?Q?xzyBqhnzKwOWS6jEuYbLgNqdrbvyd8ei6TZvG71uOcKvzniPUBE0NgzzuJyE?=
 =?us-ascii?Q?Dg3VrEWEis31BGY+JDqD0vZe2zDCClvfot6zbpq2a8S56iXh+mstoU0bCIs9?=
 =?us-ascii?Q?+ZlEX+1UnW8dy9mNOEi7eGrrM1SM+t4kGGy0XXpvtMXlNYIkrv7FJDbcnIq7?=
 =?us-ascii?Q?NZQI3yz/bSKdpsQEEc1pNGgTeuyIcheFDQXrtCg+dTuoSqsF6PO+NP0jw+c+?=
 =?us-ascii?Q?fCc0a41Try4yY24VotsY7iSh2GzH0poA+K1fILWLiAgTWVlOge5m/EyyKkma?=
 =?us-ascii?Q?GRckFicQRcDePpWysQYEKnW5HICinPGzJpohjlQlOiS1FaGrqgPtu5vS9pW1?=
 =?us-ascii?Q?0IIwk7sG01GCVFIMoPbIH709QtWVevpcyWS6myaOUsPs21aP/KKwwgNsU2vB?=
 =?us-ascii?Q?SyVeqDdighKc2QIHAfI25u2WE0K3KO6LXDTNWgsnhbkxnk818IrCiMUnMbkJ?=
 =?us-ascii?Q?ebQ0BG9+LUxeFs/QuQaPB2rnT/saUy4skRrvkeMsroih5gTvPQzN7G4L38nH?=
 =?us-ascii?Q?BYZ6PoPsC2vwHodyzUwDkQmA5UQj3o01/9vFIru1MAVAGIcs8yGRp987BMSd?=
 =?us-ascii?Q?+D5z3+kqM91Ue3pdxK8S+hTNP62ECoYsH6wdLJoADcPd1elCwyKxoeVfb+op?=
 =?us-ascii?Q?rHVAZJdfz3fF2V0XC1KmTHcHc/LqD8t8wP57WoOQSIpX/3nDfyTvJKkK25px?=
 =?us-ascii?Q?5zaCwhG/tROLZewJNd9BvT/axsJT+BOUkDqr3cWV9Ai6gnuB8AkNLtYa7kjH?=
 =?us-ascii?Q?DtuTSf58EVgPQIOv4+QIpVUi3eLf/gQlf1sziuCinwAdXND6nJfNP+FOTayj?=
 =?us-ascii?Q?yEvSFVHcQQnNH3PnD0lPEj8sU1CVFSmcAR+7RDwZxiFkoJ3Vipql40t2QQvY?=
 =?us-ascii?Q?4YZGCz+faJhzfZk9tWT6Vz5RB3BaC08qKO/l5sphn0ROd6z0hEHHkecypx9U?=
 =?us-ascii?Q?Si/4wn96PhNKDBVAWRm+NYljl2Dpt8zPsKPdIjoBz+tPwHHu2IVK606IDQDt?=
 =?us-ascii?Q?YbN29C/digR6AUxuBn1ghzowfPHSCqRCZ6QtbkcndBufOcRbb6PeJa7MogwN?=
 =?us-ascii?Q?VrZnaw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f0e80c-9124-4ee3-a4c6-08db05f6186d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 14:51:13.4864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hl5CXlXU6pK67MFdm5owW84ZFhh+gjaB5OVc/YonOrNaXeSAXiyUH0+NH/THNnIbMVGefNmZ5Asm/EK5TfYwBa2R2KA8sklUkDUqoefhHTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5526
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 06:10:34PM +0200, Oz Shlomo wrote:
> There are currently two mechanisms for populating hardware stats:
> 1. Using flow_offload api to query the flow's statistics.
>    The api assumes that the same stats values apply to all
>    the flow's actions.
>    This assumption breaks when action drops or jumps over following
>    actions.
> 2. Using hw_action api to query specific action stats via a driver
>    callback method. This api assures the correct action stats for
>    the offloaded action, however, it does not apply to the rest of the
>    actions in the flow's actions array.
> 
> Extend the flow_offload stats callback to indicate that a per action
> stats update is required.
> Use the existing flow_offload_action api to query the action's hw stats.
> In addition, currently the tc action stats utility only updates hw actions.
> Reuse the existing action stats cb infrastructure to query any action
> stats.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> ---
>  include/net/flow_offload.h |  1 +
>  include/net/pkt_cls.h      | 29 +++++++++++++++++++----------
>  net/sched/act_api.c        |  8 --------
>  net/sched/cls_flower.c     |  2 +-
>  net/sched/cls_matchall.c   |  2 +-
>  5 files changed, 22 insertions(+), 20 deletions(-)
> 
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index d177bf5f0e1a..27decadd4f5f 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -597,6 +597,7 @@ struct flow_cls_offload {
>  	unsigned long cookie;
>  	struct flow_rule *rule;
>  	struct flow_stats stats;
> +	bool use_act_stats;
>  	u32 classid;
>  };

Hi Oz,

It's probably not important, but I thought it is worth bringing
to your attention.

The placement of use_act_stats above  puts it on a different
cacheline (on x86_64) to stats. Which does not seem to be idea
as those fields are accessed together.

There is a 4 byte hole immediately above above cookie,
on the same cacheline as stats, which can accommodate use_act_stats.

>  
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index be21764a3b34..d4315757d1a2 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h

...

> @@ -769,6 +777,7 @@ struct tc_cls_matchall_offload {
>  	enum tc_matchall_command command;
>  	struct flow_rule *rule;
>  	struct flow_stats stats;
> +	bool use_act_stats;
>  	unsigned long cookie;
>  };

I believe the same logic applies to this change too.

...

> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index cb04739a13ce..885c95191ccf 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -502,7 +502,7 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
>  	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false,
>  			 rtnl_held);
>  
> -	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats);
> +	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats, cls_flower.use_act_stats);
>  }
>  
>  static void __fl_put(struct cls_fl_filter *f)
> diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
> index b3883d3d4dbd..fa3bbd187eb9 100644
> --- a/net/sched/cls_matchall.c
> +++ b/net/sched/cls_matchall.c
> @@ -331,7 +331,7 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
>  
>  	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false, true);
>  
> -	tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats);
> +	tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats, cls_mall.use_act_stats);
>  }
>  
>  static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
