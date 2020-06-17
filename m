Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F8C1FC437
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 04:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgFQCmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 22:42:31 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:4127 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgFQCmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 22:42:31 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E709041D16;
        Wed, 17 Jun 2020 10:42:27 +0800 (CST)
Subject: Re: [PATCH net v3 2/4] flow_offload: fix incorrect cb_priv check for
 flow_block_cb
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, vladbu@mellanox.com
References: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
 <1592277580-5524-3-git-send-email-wenxu@ucloud.cn>
 <20200616201348.GB26932@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <7d21a0b5-9f90-7f66-ae7a-80b0d9bbf2a1@ucloud.cn>
Date:   Wed, 17 Jun 2020 10:42:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200616201348.GB26932@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSU5JQkJCTENJTk1JSU1ZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXIjULOBw6FREdIi8cUBceEzcDTDocVlZVSktLKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nz46Sgw6Vjg#MzYpNA5ICiwa
        HEkaCihVSlVKTkJJSE1KTE9DSkNLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFISE5INwY+
X-HM-Tid: 0a72c02806772086kuqye709041d16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/17/2020 4:13 AM, Pablo Neira Ayuso wrote:
> On Tue, Jun 16, 2020 at 11:19:38AM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> In the function __flow_block_indr_cleanup, The match stataments
>> this->cb_priv == cb_priv is always false, the flow_block_cb->cb_priv
>> is totally different data with the flow_indr_dev->cb_priv.
>>
>> Store the representor cb_priv to the flow_block_cb->indr.cb_priv in
>> the driver.
>>
>> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>  drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c        | 1 +
>>  drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 2 +-
>>  drivers/net/ethernet/netronome/nfp/flower/offload.c | 1 +
>>  include/net/flow_offload.h                          | 1 +
>>  net/core/flow_offload.c                             | 2 +-
>>  5 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
>> index ef7f6bc..042c285 100644
>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
>> @@ -1918,6 +1918,7 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
>>  
>>  		flow_block_cb_add(block_cb, f);
>>  		list_add_tail(&block_cb->driver_list, &bnxt_block_cb_list);
>> +		block_cb->indr.cb_priv = bp;
> cb_indent ?
>
> Why are you splitting the fix in multiple patches? This makes it
> harder to review.
>
> I think patch 1/4, 2/4 and 4/4 belong to the same logical change?
> Collapse them.

I think patch 1/4, 2/4, 4/4 are different bugs， Although they are all in the new indirect

flow_block infrastructure.

patch1 fix the miss cleanup for flow_block_cb of flowtable

patch2 fix the incorrect check the cb_priv of flow_block_cb

patch4 fix the miss driver_list del in the cleanup callback

So maybe make them alone is better?

