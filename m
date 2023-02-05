Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4ABA68AFD2
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjBENBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBENBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:01:37 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2D6E055
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 05:01:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWP9esXfhqOuKMcbEU8vNDe7tPLTjVMMvkvoa6cqrwjx170ykNYRAdxi6X8PWMx+ZZlvDrPFrQ7cD34NrbDIwmZHn47ZKHDwIOnhBdhvIF7rquI72v5uDpF0ZFcNBBmqeK5bKM9bjTxaYC8kFhkQCzGxXA/Ymvw08UJ6whFEHMHdntUWpCOpYneaewZxEdaHslEJIVgHBSgZpm51LAzxDr49ttvHLG2mrqlpIKwRWkKGifBrGOjlS6UJHyQ9wb0p4ExcWBiob+xQOBdBJ3iY8kEXO4w7EzI79yTn0bjGIQZ3wRntIavPy7ZXn6W9gNEBnBLHcNrmu/08nL8GnVNf6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYYDM6hcLsWUDsJ1e5ekkX1iQH/tLmnyXiwZiNhEOM0=;
 b=aBFDefi6FUHhp1WsXkk8LkWYviHe/X11qNkPjJrkrVpRcMjwThvq9ACL6Yh54yaq+QP6nMbWtKVtFT5P2xNEa7j+/xVPVL8NfD9I5wsojE4WoRtirXJeZOF1g5v5HfGV4q830gy/Bnn2OuM9OmAVmhiS7YaMnDU6SDsWyaP/TrroPIuFGjhudBIQ/Gi7nUCec+2IWrD1v9KbMh1a4jxZbibSe9zonrYhrMQJVuH0se6U9SznRhYX+vV5RNGP0IrMiIGHSJLADKERNpbtiVUEtJt0URH5Oqd2hJIT/YlNCFcu54VVoz3NOIwq2vBt+bI5BH5Ztk6KjPfiy0B49abkuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYYDM6hcLsWUDsJ1e5ekkX1iQH/tLmnyXiwZiNhEOM0=;
 b=V7bo6Jbb8qtrgdS1LmwwMQ7yaMPawldU8/e2VTYYjNh4gm3PAYpxAnu09qQUZ1MLdzyxBB5U3zfUVnejsUc5hmDOHnGonKX9Oq4ukd7jYeuIxbk48YAtOcs7XcZkv5Xu36CEeZ4RCVUfYsUtHMP7UT469MYJS2Xe7NiqDixRyYymC09KootYmr+o0M5RCI2Z7dpM/wCa/Xa8LJRKr8SGUb18cwWMx69SiXMZlXKmONMOMFIIUgCMrjegR0nAUDflFPzdlcJn247bQJS4SOheHlVXFzgh4EELbKbymlf9tDzKOyff7e40adTANdNT3RDGK/gvFgXPSf255UIXuBTW0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 SA1PR12MB6872.namprd12.prod.outlook.com (2603:10b6:806:24c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sun, 5 Feb
 2023 13:01:34 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::b18c:b9c5:b46a:3518]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::b18c:b9c5:b46a:3518%10]) with mapi id 15.20.6064.024; Sun, 5 Feb 2023
 13:01:34 +0000
Message-ID: <ff11679c-2fe3-eeaf-44c9-6a96f43313dd@nvidia.com>
Date:   Sun, 5 Feb 2023 15:01:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 5/9] net/sched: support per action hw stats
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
 <20230201161039.20714-6-ozsh@nvidia.com> <Y90bRHerUsBhFIcl@corigine.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <Y90bRHerUsBhFIcl@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0327.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::8) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1307:EE_|SA1PR12MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: 07b2f084-a547-4eb1-1397-08db07791b7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YeyhUCLHef0zP7Mph6m6+sPipGw+gtTRrINFBjqd1gZH1NqMNKwIFf48hyi5DDKtYsKmZ5POF58Td2LOiD3TN9UpwDmhPmVW5dva1dFcIccRbUuGs6zKmqjNePHx47o0vPoSSbqiLEmoa1ciX4Olcnx94JkRxKNhcI2ykPyoEbAZManFGa7f04XtIRKDDW8AcKCtyJikOQoqQK0EMtl1eUkQkk++t1P+qciY711n7nAp1EZ1BmRLe+wIRqJBRYWYTbWA1stXSd8hg65V+cUAQqnnTS5dZro1gUGGv5FKnKxbz1JnaYe5mnpnET58SUpS+udJRROlrujZgbO0SEH8PN4y2YphNchnc5rE8HMKO5xx5Yd1M0H+fTaZqPzdkQxYHVzgt+AarLfOAX0tPW7OvMCQDtc6ENY947SVCQjADCmKvasq5hJxyeBntiskBNl0HuCCEkeGPYEKRFTMtEZUpYKZi9ueGJlToDyG1GnwOMFcsgyV6C7hddNIxgNKoxwNYHgv7Q1l4/gdyyoD3ltrVRpeU2uxCrJ4ZMBfYtOUy1zsHAaXodZQ3FL9LNLGUhrB+9cfBrpzirNVo7NtBzLhhy367AtrsVzAvdvKSA1x7nIcxo7MvRsFk/xAdyb+gW31EyacnHZnNihbvFAW/hmjPfaBiw/BwehEH+Fv3bRUOOVlfxfok9QudOo50gkvkcvgwPj0/Eb0FPy1F9u5eCXMSJpy8txLfGLCABTcTgum7mFvNm+R7A+LF17Jeo6RZyUigXhp6e6WJITsOu9Vi+sdgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(451199018)(31686004)(36756003)(66946007)(66556008)(66476007)(54906003)(4326008)(6916009)(8936002)(8676002)(41300700001)(316002)(5660300002)(31696002)(86362001)(38100700002)(26005)(186003)(6512007)(6506007)(53546011)(6666004)(2906002)(6486002)(478600001)(2616005)(83380400001)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2lOSEx1S1lXQmh5THlJemNFRlJIR1pjWTRIVCszZDlPT0wzSnEwTVVuenZW?=
 =?utf-8?B?dlRsT1NpZm50UGk5QUpJeFVMdjRTQXBzenRRVmx0eFNQdXVsNW5LbmJ5RDVv?=
 =?utf-8?B?MlZCM2Rpck9JNEJ6ODRKMGd6cmdIdWRheVBMOHJFcnN1di90R09JUDl1RFox?=
 =?utf-8?B?N3VMSnhJcndZWDNRVHBkUHE1eFdHdFQzMnlvUUR1VmFVMmlORnFZR1ZqQ1Aw?=
 =?utf-8?B?b1BUNGVVWnNVUjlOQ3dIUG92WDBmRnZxaThGK0NqbkJ5OWNyTmNtK2dnanVX?=
 =?utf-8?B?THlXcE02TXJYZGc2SlJ0MHltMW5PVkhnVTlrQkJ6NlZNSGc4OUQ2bTZJQm1C?=
 =?utf-8?B?bzd1d1QwVmVOTk1NN210dVRraXpxaTBjSXAvaWExOWZQZ2JrK3NuMWhmTFI5?=
 =?utf-8?B?Y015UFNmb24rYmE5U0xGMzhZbEQ5T1hOaGtIOVZNOExUWUtVbEliZjlHSmJm?=
 =?utf-8?B?TlVoT25HeXZQOXg0RlZnQTZiTnBISHZJcVcyZnRLNUxyNlVqS2t2WFExTG9B?=
 =?utf-8?B?UExLUlU4eUU5OFV0RTBSQmE4YXNaVS9McXBVV0lHQ3F2Q0FGQkhYc0V6aysv?=
 =?utf-8?B?ME1lVjFzcGllcVRNR0ZUVjI0TlZ4YWpzQUphempBZEl5Y0EvSEIxVnBpQ1Ex?=
 =?utf-8?B?VEgwOGYvK2Z3Q1QvbC9QRnNsZ2cyLzk2Njl0ZUd3amVSUFhxenc1aVdta3Vz?=
 =?utf-8?B?K0xWL2d2RHNiYWtSRElMeXFJcEhwT21hRER1STZkcFZqU0k1L1ZrZVJ4WHlH?=
 =?utf-8?B?Z2tjTnZoM3lray96WGZ3WEtFK0RvanRCZEFNZ0lPWkU2OXBJR3JzZE1mRUVO?=
 =?utf-8?B?Skt0R1UyaTZ4ZG5DdS9UdkZoVjlWcW5kMi9XTTVtWEdIaWFrUVFneDZqZUUw?=
 =?utf-8?B?aFp5L0k3RTJZLzBEMjgyL1gvUFN0azFvc09zNDNSaUdrYzY0STNvMU95ckdQ?=
 =?utf-8?B?RnFhejNVQ1RPaktoT0pEU04wSDY3Q2pJdS8zTEJuVEVRdHpCNW52N1NzRE02?=
 =?utf-8?B?NlhLc0RZNEtmYkNlZkIwTVVZZ01Rc2lRZnhqMTB1NXZ3MGg5OG5rMGpSN01x?=
 =?utf-8?B?blo4ZTJOOEpkUmVWRTBVRU5QNDk5QjYzQUtNWDJ2djg3UmE4Mm9FUjlZa0Ir?=
 =?utf-8?B?NytsK1FGNEhDMy8wTjBXOG9IbzAyRkx3b3l1UFBEMXptZExlR2U0dVljUmJK?=
 =?utf-8?B?R1BiUkFlUlE4aXY2eHlabjl5cHBBRTQ5VDB1bHYyOHRoT05EYWZ2M0JwRllw?=
 =?utf-8?B?allVWFE4c1NvS0NRQUpGVFdvVW55dmh0VkpydzJNMC9DMW51S01YUExmSm9x?=
 =?utf-8?B?Q0xSbDNGTG54amVHL1UxTWFLb1lXTTlzNndKWnBSNmlXQkRzTkNYeTlDNWF1?=
 =?utf-8?B?S1VTc1FGSkM0dStiUUtWN1A1emV2Yzd3aVZDdG85MlhFRXlab3hxQVhFaEFt?=
 =?utf-8?B?UWJQMkdaWEJLZ1dVMUVvTElwU1pmc2pQVjY3R2NKYlZmSTZjYWc4UEptTG9V?=
 =?utf-8?B?b2tvK004NW9ScW0vQzhZRUgxS3RVOUUwaG1iRk15S2o4bHBHTytZQjA2QnpZ?=
 =?utf-8?B?TnNiS2R0TkFsTUhrMDhQMXA3c2RheWJRcVQvRy9XSzdZVkgzRHBmNEU0RjNu?=
 =?utf-8?B?cVA4cEtLbkVEbVdJY2sxUmQ5U29YZjhKVGRyd3IwZFJVS01CSDRsblNvNHRB?=
 =?utf-8?B?bEVWOXV3K2xISHRLdHJFWm5wYi9FQkVsWkZrSVgrTGtOdEFwMWp0Y3RrQUxY?=
 =?utf-8?B?ZmVWb1Vvcmg0OVRneHZCVGczdzhPQlRXTkJ6aFNLUllqRzFGWExob3RlNDY4?=
 =?utf-8?B?U1M5bWpHSjNDNGZCa0ZjNVd3bnJKcnBXd3JqMjg5SzdFSHBHei9BTVpXdXFs?=
 =?utf-8?B?Q0lGaCtzd0hMMk8wVjBsRlZVQkU4WUxlQUJRVklhUmhxeXdPdDBzWDN1amdp?=
 =?utf-8?B?Y254dFVzSHRaUVVxeWExNU5aU2hPUEZ1d0ZoanBrdk1zQ2lpRFhXVXZVamFK?=
 =?utf-8?B?QVdhS25DYTFxd3R2bmR4cEUyN25uT0JYbFh0R2tnVTFmUnJUeUNZd0g0Y1gy?=
 =?utf-8?B?ckJ2WmRiTVVERWErS0RYckZjYnZIeXM5ajFZMFpVTmw2RUdEUkpWeFlhQWdB?=
 =?utf-8?Q?rQ0wUryx2a0P7In0pJkZNl4ee?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07b2f084-a547-4eb1-1397-08db07791b7f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:01:33.9619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W0ey7STiFHlIeG45gAwRHfmN7hvOrZzJqn+U5LpciF73vFrx9C/wrKtXt1nWPfUD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6872
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 03/02/2023 16:33, Simon Horman wrote:
> On Wed, Feb 01, 2023 at 06:10:34PM +0200, Oz Shlomo wrote:
>> There are currently two mechanisms for populating hardware stats:
>> 1. Using flow_offload api to query the flow's statistics.
>>     The api assumes that the same stats values apply to all
>>     the flow's actions.
>>     This assumption breaks when action drops or jumps over following
>>     actions.
>> 2. Using hw_action api to query specific action stats via a driver
>>     callback method. This api assures the correct action stats for
>>     the offloaded action, however, it does not apply to the rest of the
>>     actions in the flow's actions array.
>>
>> Extend the flow_offload stats callback to indicate that a per action
>> stats update is required.
>> Use the existing flow_offload_action api to query the action's hw stats.
>> In addition, currently the tc action stats utility only updates hw actions.
>> Reuse the existing action stats cb infrastructure to query any action
>> stats.
>>
>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> ...
>
>> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
>> index be21764a3b34..d4315757d1a2 100644
>> --- a/include/net/pkt_cls.h
>> +++ b/include/net/pkt_cls.h
>> @@ -292,9 +292,15 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>>   #define tcf_act_for_each_action(i, a, actions) \
>>   	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
>>   
>> +static bool tc_act_in_hw(struct tc_action *act)
>> +{
>> +	return !!act->in_hw_count;
>> +}
>> +
>>   static inline void
>>   tcf_exts_hw_stats_update(const struct tcf_exts *exts,
>> -			 struct flow_stats *stats)
>> +			 struct flow_stats *stats,
>> +			 bool use_act_stats)
>>   {
>>   #ifdef CONFIG_NET_CLS_ACT
>>   	int i;
>> @@ -302,16 +308,18 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>>   	for (i = 0; i < exts->nr_actions; i++) {
>>   		struct tc_action *a = exts->actions[i];
>>   
>> -		/* if stats from hw, just skip */
>> -		if (tcf_action_update_hw_stats(a)) {
>> -			preempt_disable();
>> -			tcf_action_stats_update(a, stats->bytes, stats->pkts, stats->drops,
>> -						stats->lastused, true);
>> -			preempt_enable();
>> -
>> -			a->used_hw_stats = stats->used_hw_stats;
>> -			a->used_hw_stats_valid = stats->used_hw_stats_valid;
>> +		if (use_act_stats || tc_act_in_hw(a)) {
>> +			tcf_action_update_hw_stats(a);
> Hi Oz,
>
> I am a unclear why it is ok to continue here even if
> tcf_action_update_hw_stats() fails.  There seem to be cases other than
> !tc_act_in_hw() at play here, which prior to this patch, would execute the
> code below that is now outside this if clause.
You're right, my bad
>> +			continue;
>>   		}
>> +
>> +		preempt_disable();
>> +		tcf_action_stats_update(a, stats->bytes, stats->pkts, stats->drops,
>> +					stats->lastused, true);
>> +		preempt_enable();
>> +
>> +		a->used_hw_stats = stats->used_hw_stats;
>> +		a->used_hw_stats_valid = stats->used_hw_stats_valid;
>>   	}
>>   #endif
>>   }
>> @@ -769,6 +777,7 @@ struct tc_cls_matchall_offload {
>>   	enum tc_matchall_command command;
>>   	struct flow_rule *rule;
>>   	struct flow_stats stats;
>> +	bool use_act_stats;
>>   	unsigned long cookie;
>>   };
>>   
>> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
>> index 917827199102..eda58b78da13 100644
>> --- a/net/sched/act_api.c
>> +++ b/net/sched/act_api.c
>> @@ -169,11 +169,6 @@ static bool tc_act_skip_sw(u32 flags)
>>   	return (flags & TCA_ACT_FLAGS_SKIP_SW) ? true : false;
>>   }
>>   
>> -static bool tc_act_in_hw(struct tc_action *act)
>> -{
>> -	return !!act->in_hw_count;
>> -}
>> -
>>   /* SKIP_HW and SKIP_SW are mutually exclusive flags. */
>>   static bool tc_act_flags_valid(u32 flags)
>>   {
>> @@ -308,9 +303,6 @@ int tcf_action_update_hw_stats(struct tc_action *action)
>>   	struct flow_offload_action fl_act = {};
>>   	int err;
>>   
>> -	if (!tc_act_in_hw(action))
>> -		return -EOPNOTSUPP;
>> -
>>   	err = offload_action_init(&fl_act, action, FLOW_ACT_STATS, NULL);
>>   	if (err)
>>   		return err;
> ...
