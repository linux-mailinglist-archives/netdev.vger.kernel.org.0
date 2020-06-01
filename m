Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9795A1E9BF8
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 05:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgFADME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 23:12:04 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:8063 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbgFADME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 23:12:04 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 7955C5C1F17;
        Mon,  1 Jun 2020 11:11:59 +0800 (CST)
Subject: Re: [PATCH net-next 2/2] net/mlx5e: add ct_metadata.nat support in ct
 offload
To:     Oz Shlomo <ozsh@mellanox.com>, paulb@mellanox.com,
        saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
References: <1590650155-4403-1-git-send-email-wenxu@ucloud.cn>
 <1590650155-4403-3-git-send-email-wenxu@ucloud.cn>
 <91589d29-42cb-7384-3ccc-58af4350a984@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <a6b01a18-f3f1-1af8-7d2e-6f9b282d42be@ucloud.cn>
Date:   Mon, 1 Jun 2020 11:11:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <91589d29-42cb-7384-3ccc-58af4350a984@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEpJS0tLSk5OT09DQkpZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkdIjULOBw*M04DHSQYHykeDBkqTTocVlZVSktJSyhJWVdZCQ
        4XHghZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nio6Azo5Fzg#Mz5KIgEzKx1W
        FBYKCiNVSlVKTkJLQkNKSkpCTE9MVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFNSExLNwY+
X-HM-Tid: 0a726ddd4e902087kuqy7955c5c1f17
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/31/2020 4:01 PM, Oz Shlomo wrote:
> Hi Wenxu,
>
> On 5/28/2020 10:15 AM, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> In the ct offload all the conntrack entry offload  rules
>> will be add to both ct ft and ct_nat ft twice.
>> It is not makesense. The ct_metadat.nat will tell driver
>
> Adding the connection to both tables is required because the user may
> perform a CT action without NAT even though a NAT entry was allocated
> when the connection was committed.

Thanks, understood.  But I just wonder what use case for this behavior?
>
>> the rule should add to ct or ct_nat flow table
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 34 ++++++++--------------
>>   1 file changed, 12 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
>> index 995b2ef..02ecd24 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
>> @@ -88,7 +88,7 @@ struct mlx5_ct_entry {
>>       struct mlx5_fc *counter;
>>       unsigned long cookie;
>>       unsigned long restore_cookie;
>> -    struct mlx5_ct_zone_rule zone_rules[2];
>> +    struct mlx5_ct_zone_rule zone_rule;
>>   };
>>     static const struct rhashtable_params cts_ht_params = {
>> @@ -238,10 +238,9 @@ struct mlx5_ct_entry {
>>     static void
>>   mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
>> -              struct mlx5_ct_entry *entry,
>> -              bool nat)
>> +              struct mlx5_ct_entry *entry)
>>   {
>> -    struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
>> +    struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rule;
>>       struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
>>       struct mlx5_eswitch *esw = ct_priv->esw;
>>   @@ -256,8 +255,7 @@ struct mlx5_ct_entry {
>>   mlx5_tc_ct_entry_del_rules(struct mlx5_tc_ct_priv *ct_priv,
>>                  struct mlx5_ct_entry *entry)
>>   {
>> -    mlx5_tc_ct_entry_del_rule(ct_priv, entry, true);
>> -    mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
>> +    mlx5_tc_ct_entry_del_rule(ct_priv, entry);
>>         mlx5_fc_destroy(ct_priv->esw->dev, entry->counter);
>>   }
>> @@ -493,7 +491,7 @@ struct mlx5_ct_entry {
>>                 struct mlx5_ct_entry *entry,
>>                 bool nat)
>>   {
>> -    struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
>> +    struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rule;
>>       struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
>>       struct mlx5_eswitch *esw = ct_priv->esw;
>>       struct mlx5_flow_spec *spec = NULL;
>> @@ -562,7 +560,8 @@ struct mlx5_ct_entry {
>>   static int
>>   mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
>>                  struct flow_rule *flow_rule,
>> -               struct mlx5_ct_entry *entry)
>> +               struct mlx5_ct_entry *entry,
>> +               bool nat)
>>   {
>>       struct mlx5_eswitch *esw = ct_priv->esw;
>>       int err;
>> @@ -574,20 +573,10 @@ struct mlx5_ct_entry {
>>           return err;
>>       }
>>   -    err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, false);
>> +    err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, nat);
>>       if (err)
>> -        goto err_orig;
>> -
>> -    err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, true);
>> -    if (err)
>> -        goto err_nat;
>> -
>> -    return 0;
>> +        mlx5_fc_destroy(esw->dev, entry->counter);
>>   -err_nat:
>> -    mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
>> -err_orig:
>> -    mlx5_fc_destroy(esw->dev, entry->counter);
>>       return err;
>>   }
>>   @@ -619,7 +608,8 @@ struct mlx5_ct_entry {
>>       entry->cookie = flow->cookie;
>>       entry->restore_cookie = meta_action->ct_metadata.cookie;
>>   -    err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry);
>> +    err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry,
>> +                     meta_action->ct_metadata.nat);
>>       if (err)
>>           goto err_rules;
>>   @@ -1620,7 +1610,7 @@ struct mlx5_flow_handle *
>>           return false;
>>         entry = container_of(zone_rule, struct mlx5_ct_entry,
>> -                 zone_rules[zone_rule->nat]);
>> +                 zone_rule);
>>       tcf_ct_flow_table_restore_skb(skb, entry->restore_cookie);
>>         return true;
>>
>
