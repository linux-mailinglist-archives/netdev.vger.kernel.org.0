Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBB56751E5
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjATJ7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjATJ7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:59:00 -0500
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998FB3AB8;
        Fri, 20 Jan 2023 01:58:59 -0800 (PST)
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx0.riseup.net (Postfix) with ESMTPS id 4Nyw1t5hCxz9t2t;
        Fri, 20 Jan 2023 09:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1674208738; bh=92PsRtMC7mbIUrHwmLwuzUa+IS0s0MFe6lAX/U7D48I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hmyxtqcnwx0iTuilLodvc2nPCVw02JgApVNRtDt/eSDY/KjyPw6hWS0+2/j+hdlOc
         nnQxXmor8Qj+/XXEK93ayduH/N9mW+9DCI08r5N5n1PFn3zXWquVNR8O3DH6/JiOU+
         n78kwfSdASuZ8SkAdYkoju2vrw+p7zEuz+NgkDLg=
X-Riseup-User-ID: C4B09AC9A934D4CCD209CA97DB19AAD44390F416733645866B079B4AAD4C2DB1
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4Nyw1q5V6Jz5vZw;
        Fri, 20 Jan 2023 09:58:55 +0000 (UTC)
Message-ID: <b4286a08-8264-c8de-622d-0db2c76901c8@riseup.net>
Date:   Fri, 20 Jan 2023 10:58:53 +0100
MIME-Version: 1.0
Subject: Re: [PATCH net-next 9/9] netfilter: nf_tables: add support to destroy
 operation
Content-Language: en-US
To:     Vlad Buslov <vladbu@nvidia.com>, Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Maor Dickman <maord@nvidia.com>
References: <20230118123208.17167-1-fw@strlen.de>
 <20230118123208.17167-10-fw@strlen.de> <87o7qvasfv.fsf@nvidia.com>
From:   "Fernando F. Mancera" <ffmancera@riseup.net>
In-Reply-To: <87o7qvasfv.fsf@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vlad,

On 19/01/2023 08:29, Vlad Buslov wrote:
> On Wed 18 Jan 2023 at 13:32, Florian Westphal <fw@strlen.de> wrote:
>> From: Fernando Fernandez Mancera <ffmancera@riseup.net>
>>
>> Introduce NFT_MSG_DESTROY* message type. The destroy operation performs a
>> delete operation but ignoring the ENOENT errors.
>>
>> This is useful for the transaction semantics, where failing to delete an
>> object which does not exist results in aborting the transaction.
>>
>> This new command allows the transaction to proceed in case the object
>> does not exist.
>>
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> Signed-off-by: Florian Westphal <fw@strlen.de>
>> ---
>>   include/uapi/linux/netfilter/nf_tables.h |  14 +++
>>   net/netfilter/nf_tables_api.c            | 111 +++++++++++++++++++++--
>>   2 files changed, 117 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
>> index cfa844da1ce6..ff677f3a6cad 100644
>> --- a/include/uapi/linux/netfilter/nf_tables.h
>> +++ b/include/uapi/linux/netfilter/nf_tables.h
>> @@ -98,6 +98,13 @@ enum nft_verdicts {
>>    * @NFT_MSG_GETFLOWTABLE: get flow table (enum nft_flowtable_attributes)
>>    * @NFT_MSG_DELFLOWTABLE: delete flow table (enum nft_flowtable_attributes)
>>    * @NFT_MSG_GETRULE_RESET: get rules and reset stateful expressions (enum nft_obj_attributes)
>> + * @NFT_MSG_DESTROYTABLE: destroy a table (enum nft_table_attributes)
>> + * @NFT_MSG_DESTROYCHAIN: destroy a chain (enum nft_chain_attributes)
>> + * @NFT_MSG_DESTROYRULE: destroy a rule (enum nft_rule_attributes)
>> + * @NFT_MSG_DESTROYSET: destroy a set (enum nft_set_attributes)
>> + * @NFT_MSG_DESTROYSETELEM: destroy a set element (enum nft_set_elem_attributes)
>> + * @NFT_MSG_DESTROYOBJ: destroy a stateful object (enum nft_object_attributes)
>> + * @NFT_MSG_DESTROYFLOWTABLE: destroy flow table (enum nft_flowtable_attributes)
>>    */
>>   enum nf_tables_msg_types {
>>   	NFT_MSG_NEWTABLE,
>> @@ -126,6 +133,13 @@ enum nf_tables_msg_types {
>>   	NFT_MSG_GETFLOWTABLE,
>>   	NFT_MSG_DELFLOWTABLE,
>>   	NFT_MSG_GETRULE_RESET,
>> +	NFT_MSG_DESTROYTABLE,
>> +	NFT_MSG_DESTROYCHAIN,
>> +	NFT_MSG_DESTROYRULE,
>> +	NFT_MSG_DESTROYSET,
>> +	NFT_MSG_DESTROYSETELEM,
>> +	NFT_MSG_DESTROYOBJ,
>> +	NFT_MSG_DESTROYFLOWTABLE,
>>   	NFT_MSG_MAX,
>>   };
>>   
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> index 8c09e4d12ac1..974b95dece1d 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>> @@ -1401,6 +1401,10 @@ static int nf_tables_deltable(struct sk_buff *skb, const struct nfnl_info *info,
>>   	}
>>   
>>   	if (IS_ERR(table)) {
>> +		if (PTR_ERR(table) == -ENOENT &&
>> +		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYTABLE)
>> +			return 0;
>> +
>>   		NL_SET_BAD_ATTR(extack, attr);
>>   		return PTR_ERR(table);
>>   	}
>> @@ -2639,6 +2643,10 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
>>   		chain = nft_chain_lookup(net, table, attr, genmask);
>>   	}
>>   	if (IS_ERR(chain)) {
>> +		if (PTR_ERR(chain) == -ENOENT &&
>> +		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYCHAIN)
>> +			return 0;
>> +
>>   		NL_SET_BAD_ATTR(extack, attr);
>>   		return PTR_ERR(chain);
>>   	}
>> @@ -3716,6 +3724,10 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
>>   		chain = nft_chain_lookup(net, table, nla[NFTA_RULE_CHAIN],
>>   					 genmask);
>>   		if (IS_ERR(chain)) {
>> +			if (PTR_ERR(rule) == -ENOENT &&
> 
> Coverity complains that at this point rule is not initialized yet, which
> looks like to be the case to me.
> 

Thanks, I am sending a patch fixing this.

> [...]
> 
