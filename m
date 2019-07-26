Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05DC376610
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 14:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfGZMkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 08:40:01 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:55144 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbfGZMkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 08:40:01 -0400
Received: from [192.168.1.5] (unknown [180.157.110.197])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 620D041172;
        Fri, 26 Jul 2019 20:39:56 +0800 (CST)
Subject: Re: [PATCH] net/mlx5e: Fix zero table prio set by user.
To:     Or Gerlitz <gerlitz.or@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1564053847-28756-1-git-send-email-wenxu@ucloud.cn>
 <7b03d1fdda172ce99c3693d8403cbdaf5a31bb6c.camel@mellanox.com>
 <CAJ3xEMi65JcF97nHeE482xgkps0GLLso+b6hp=34uX+wF=BjiQ@mail.gmail.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <692b090f-c19e-aa8b-796e-17999ac79df1@ucloud.cn>
Date:   Fri, 26 Jul 2019 20:39:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAJ3xEMi65JcF97nHeE482xgkps0GLLso+b6hp=34uX+wF=BjiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0tKS0tLS09NTEhLS09ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PyI6Gjo4Ajg9MkseThQtDUMZ
        NjcKFDVVSlVKTk1PSk9PTEJNTU1JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpDS1VK
        TkxVSkpLVUpCTFlXWQgBWUFPSE1CNwY+
X-HM-Tid: 0a6c2e4b83ba2086kuqy620d041172
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/7/26 20:19, Or Gerlitz 写道:
> On Fri, Jul 26, 2019 at 12:24 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
>> On Thu, 2019-07-25 at 19:24 +0800, wenxu@ucloud.cn wrote:
>>> From: wenxu <wenxu@ucloud.cn>
>>>
>>> The flow_cls_common_offload prio is zero
>>>
>>> It leads the invalid table prio in hw.
>>>
>>> Error: Could not process rule: Invalid argument
>>>
>>> kernel log:
>>> mlx5_core 0000:81:00.0: E-Switch: Failed to create FDB Table err -22
>>> (table prio: 65535, level: 0, size: 4194304)
>>>
>>> table_prio = (chain * FDB_MAX_PRIO) + prio - 1;
>>> should check (chain * FDB_MAX_PRIO) + prio is not 0
>>>
>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>>> ---
>>>  drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git
>>> a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>>> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>>> index 089ae4d..64ca90f 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>>> @@ -970,7 +970,9 @@ static int esw_add_fdb_miss_rule(struct
>> this piece of code isn't in this function, weird how it got to the
>> diff, patch applies correctly though !
>>
>>> mlx5_eswitch *esw)
>>>               flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
>>>                         MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
>>>
>>> -     table_prio = (chain * FDB_MAX_PRIO) + prio - 1;
>>> +     table_prio = (chain * FDB_MAX_PRIO) + prio;
>>> +     if (table_prio)
>>> +             table_prio = table_prio - 1;
>>>
>> This is black magic, even before this fix.
>> this -1 seems to be needed in order to call
>> create_next_size_table(table_prio) with the previous "table prio" ?
>> (table_prio - 1)  ?
>>
>> The whole thing looks wrong to me since when prio is 0 and chain is 0,
>> there is not such thing table_prio - 1.
>>
>> mlnx eswitch guys in the cc, please advise.
> basically, prio 0 is not something we ever get in the driver, since if
> user space
> specifies 0, the kernel generates some random non-zero prio, and we support
> only prios 1-16 -- Wenxu -- what do you run to get this error?
>
>
I run offload with nfatbles(but not tc), there is no prio for each rule.

prio of flow_cls_common_offload init as 0.

static void nft_flow_offload_common_init(struct flow_cls_common_offload *common,

                     __be16 proto,
                    struct netlink_ext_ack *extack)
{
    common->protocol = proto;
    common->extack = extack;
}


flow_cls_common_offload

