Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE67A19CEDF
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 05:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390175AbgDCDb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 23:31:56 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:56464 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388951AbgDCDb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 23:31:56 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id DBD5940F36;
        Fri,  3 Apr 2020 11:31:46 +0800 (CST)
Subject: Re: [PATCH net-next] net/mlx5e: avoid check the hw_stats of
 flow_action for FT flow
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        Oz Shlomo <ozsh@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1585464960-6204-1-git-send-email-wenxu@ucloud.cn>
 <fd36f18360b2800b37fe6b7466b7361afd43718b.camel@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <d3e0a559-3a7b-0fd4-5d1f-ccb0aea1dffd@ucloud.cn>
Date:   Fri, 3 Apr 2020 11:31:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <fd36f18360b2800b37fe6b7466b7361afd43718b.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSkpNS0tLT0pIQ0JPTU5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MT46Txw*Fzg*HhUdHE48HSIQ
        HxoKCUJVSlVKTkNOQ0NPTEtMSkJCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT09CTDcG
X-HM-Tid: 0a713e1839082086kuqydbd5940f36
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/3/2020 10:59 AM, Saeed Mahameed wrote:
> On Sun, 2020-03-29 at 14:56 +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> The hw_stats in flow_action can't be supported in nftable
>> flowtables. This check will lead the nft flowtable offload
>> failed. So don't check the hw_stats of flow_action for FT
>> flow.
>>
> This looks like a work around not a solution .. if the user requested a
> hw_stats action that the hw can't support, no matter what the request
> is, we should fail it even if it was for ft offloads.
>
> if it is not support by nftable, then the caller shouldn't ask for
> hw_stats action in first place.

The action entries in nft didn't set the hw_stats and the vlaue is 0.


The following function check the hw_stats should contain FLOW_ACTION_HW_STATS_DELAYED_BIT.

flow_action_hw_stats_check(flow_action, extack, FLOW_ACTION_HW_STATS_DELAYED_BIT)



Maybe the following patch is better?


__flow_action_hw_stats_check(const struct flow_action *action,
                             struct netlink_ext_ack *extack,
                             bool check_allow_bit,
                             enum flow_action_hw_stats_bit allow_bit)
{
        const struct flow_action_entry *action_entry;

        if (!flow_action_has_entries(action))
                return true;
        if (!flow_action_mixed_hw_stats_check(action, extack))
                return false;
        action_entry = flow_action_first_entry_get(action);
        if (!check_allow_bit &&
            action_entry->hw_stats != FLOW_ACTION_HW_STATS_ANY) {
                NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
                return false;
-        } else if (check_allow_bit &&
+        } else if (check_allow_bit && action_entry->hw_stats &&
                   !(action_entry->hw_stats & BIT(allow_bit))) {
                NL_SET_ERR_MSG_MOD(extack, "Driver does not support selected HW stats type");
                return false;
        }   
        return true;
}




>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> index 901b5fa..4666015 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> @@ -3703,7 +3703,8 @@ static int parse_tc_fdb_actions(struct
>> mlx5e_priv *priv,
>>  	if (!flow_action_has_entries(flow_action))
>>  		return -EINVAL;
>>  
>> -	if (!flow_action_hw_stats_check(flow_action, extack,
>> +	if (!ft_flow &&
>> +	    !flow_action_hw_stats_check(flow_action, extack,
>>  					FLOW_ACTION_HW_STATS_DELAYED_BI
>> T))
>>  		return -EOPNOTSUPP;
>>  
