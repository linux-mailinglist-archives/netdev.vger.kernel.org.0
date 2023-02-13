Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B43693FF1
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 09:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjBMIsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 03:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjBMIs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 03:48:26 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3495912F3B;
        Mon, 13 Feb 2023 00:48:23 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id o8so10420936pls.11;
        Mon, 13 Feb 2023 00:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VU8YT94mr4dhXpDmDTkyXxNq8P2h96KqWCwP/P0uQLc=;
        b=ba7vC1lm1LjlnvuRnP+BamKjlAhhTANfarwxJ4MT7TOcfu6bL1KIzNNrHZtQUnW9GI
         vCKGmmKOHTG18h7aMIY2LVcV1pSHpLdXr2alWFDfGvxOLC/jic/vrQ2o9x3T0Zvz3nH1
         tdKA02NC1xD0URSN/1gYGZ1JZsnG3TGF/+AECHSlZNl1WKY8pSM7ShkUNz37pCZR9IZk
         /B8Way6J1IoHfMpeYIx0aWY1ze5PPiKiRqDLcl626E9M5TIja68L4NhvTkOSLi9D9FdH
         fbc/JXA/CqQ2XfjMqJOgv5kFbBgQhe9WzEKNRkicBAtNUxNUaCY+nnH2Ke8IJ2U54Hdp
         C5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VU8YT94mr4dhXpDmDTkyXxNq8P2h96KqWCwP/P0uQLc=;
        b=MD2zQdbeWe9cugivcXr3Jdh34Xwe/5K9Og8z0nEcLFP4k0r2ZuPrKIqc1h+gaw9qCV
         VGoW0M9EEZklbUujGCXwj3M/qOLNAxOuSf2QYb7jVrhEXkIxw5o9Ut0mm226R5P7oOVS
         zvNpeABI2OOCHl28zIw1t5clVrB10/As5ZGNVb1bGERwwlIKuSygtnhduChEBW2XnPHJ
         2FrUby3DTwKx5jChacuYzxaM7eUmyYV6faYFSdQPR2gBZ3hmmfq/CR+oi19r9Vg30L0l
         mvaVkvYygULQfMZhOOOIZD2O5xxOxFvH49emA3qWfVasWEMoPpK+IDczNl1j07OSK3dg
         6FGw==
X-Gm-Message-State: AO0yUKUFwxQ3PNbdBSc2p8qPwYo5NcD+FCXQap4mbgmSBOTdrHS42TYK
        jld3hxkOoN00ZJkj9/0KCbo=
X-Google-Smtp-Source: AK7set9ZcQVcU1LQyt3zf6yriHiaVCqXVoEtLx0G9+wgnvCwZF2D08bzUbWNAFZsiImNFpTev9S9jA==
X-Received: by 2002:a05:6a20:a01d:b0:bd:f7f:5d55 with SMTP id p29-20020a056a20a01d00b000bd0f7f5d55mr23991129pzj.5.1676278102643;
        Mon, 13 Feb 2023 00:48:22 -0800 (PST)
Received: from [192.168.50.247] ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id q18-20020a170902b11200b0019928ce257dsm7626670plr.99.2023.02.13.00.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 00:48:22 -0800 (PST)
Message-ID: <61f38f9c-2a1f-b9a8-251b-567b7642a190@gmail.com>
Date:   Mon, 13 Feb 2023 16:48:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: netfilter: fix possible refcount leak in
 ctnetlink_create_conntrack()
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@netfilter.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230210071730.21525-1-hbh25y@gmail.com>
 <20230210103250.GC17303@breakpoint.cc> <Y+ZrvJZ2lJPhYFtq@salvia>
 <20230212125320.GA780@breakpoint.cc>
 <4c1e4e28-1dea-9750-348d-cb36bd5f5286@gmail.com>
 <20230213081701.GA10665@breakpoint.cc>
Content-Language: en-US
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20230213081701.GA10665@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/2/2023 16:17, Florian Westphal wrote:
> Hangyu Hua <hbh25y@gmail.com> wrote:
>> On 12/2/2023 20:53, Florian Westphal wrote:
>>> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>>>> One way would be to return 0 in that case (in
>>>>> nf_conntrack_hash_check_insert()).  What do you think?
>>>>
>>>> This is misleading to the user that adds an entry via ctnetlink?
>>>>
>>>> ETIMEDOUT also looks a bit confusing to report to userspace.
>>>> Rewinding: if the intention is to deal with stale conntrack extension,
>>>> for example, helper module has been removed while this entry was
>>>> added. Then, probably call EAGAIN so nfnetlink has a chance to retry
>>>> transparently?
>>>
>>> Seems we first need to add a "bool *inserted" so we know when the ct
>>> entry went public.
>>>
>> I don't think so.
>>
>> nf_conntrack_hash_check_insert(struct nf_conn *ct)
>> {
>> ...
>> 	/* The caller holds a reference to this object */
>> 	refcount_set(&ct->ct_general.use, 2);			// [1]
>> 	__nf_conntrack_hash_insert(ct, hash, reply_hash);
>> 	nf_conntrack_double_unlock(hash, reply_hash);
>> 	NF_CT_STAT_INC(net, insert);
>> 	local_bh_enable();
>>
>> 	if (!nf_ct_ext_valid_post(ct->ext)) {
>> 		nf_ct_kill(ct);					// [2]
>> 		NF_CT_STAT_INC_ATOMIC(net, drop);
>> 		return -ETIMEDOUT;
>> 	}
>> ...
>> }
>>
>> We set ct->ct_general.use to 2 in nf_conntrack_hash_check_insert()([1]).
>> nf_ct_kill willn't put the last refcount. So ct->master will not be freed in
>> this way. But this means the situation not only causes ct->master's refcount
>> leak but also releases ct whose refcount is still 1 in nf_conntrack_free()
>> (in ctnetlink_create_conntrack() err1).
> 
> at [2] The refcount could be > 1, as entry became public.  Other CPU
> might have obtained a reference.
> 
>> I think it may be a good idea to set ct->ct_general.use to 0 after
>> nf_ct_kill() ([2]) to put the caller's reference. What do you think?
> 
> We can't, see above.  We need something similar to this (not even compile
> tested):
> 

I see. This patch look good to me. Do I need to make a v2 like this one? 
Or you guys can handle this.

Thanks,
Hangyu

> diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
> index 24002bc61e07..b9e0e01dae43 100644
> --- a/net/netfilter/nf_conntrack_bpf.c
> +++ b/net/netfilter/nf_conntrack_bpf.c
> @@ -379,12 +379,16 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
>   struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct_i)
>   {
>   	struct nf_conn *nfct = (struct nf_conn *)nfct_i;
> +	bool inserted;
>   	int err;
>   
>   	nfct->status |= IPS_CONFIRMED;
> -	err = nf_conntrack_hash_check_insert(nfct);
> +	err = nf_conntrack_hash_check_insert(nfctm, &inserted);
>   	if (err < 0) {
> -		nf_conntrack_free(nfct);
> +		if (inserted)
> +			nf_ct_put(nfct);
> +		else
> +			nf_conntrack_free(nfct);
>   		return NULL;
>   	}
>   	return nfct;
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 496c4920505b..5f7b1fd744ef 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -872,7 +872,7 @@ static bool nf_ct_ext_valid_post(struct nf_ct_ext *ext)
>   }
>   
>   int
> -nf_conntrack_hash_check_insert(struct nf_conn *ct)
> +nf_conntrack_hash_check_insert(struct nf_conn *ct, bool *inserted)
>   {
>   	const struct nf_conntrack_zone *zone;
>   	struct net *net = nf_ct_net(ct);
> @@ -884,12 +884,11 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
>   	unsigned int sequence;
>   	int err = -EEXIST;
>   
> +	*inserted = false;
>   	zone = nf_ct_zone(ct);
>   
> -	if (!nf_ct_ext_valid_pre(ct->ext)) {
> -		NF_CT_STAT_INC_ATOMIC(net, insert_failed);
> -		return -ETIMEDOUT;
> -	}
> +	if (!nf_ct_ext_valid_pre(ct->ext))
> +		return -EAGAIN;
>   
>   	local_bh_disable();
>   	do {
> @@ -924,6 +923,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
>   			goto chaintoolong;
>   	}
>   
> +	*inserted = true;
>   	smp_wmb();
>   	/* The caller holds a reference to this object */
>   	refcount_set(&ct->ct_general.use, 2);
> @@ -934,8 +934,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
>   
>   	if (!nf_ct_ext_valid_post(ct->ext)) {
>   		nf_ct_kill(ct);
> -		NF_CT_STAT_INC_ATOMIC(net, drop);
> -		return -ETIMEDOUT;
> +		return -EAGAIN;
>   	}
>   
>   	return 0;
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 1286ae7d4609..7ada6350c34d 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -2244,8 +2244,10 @@ ctnetlink_create_conntrack(struct net *net,
>   	int err = -EINVAL;
>   	struct nf_conntrack_helper *helper;
>   	struct nf_conn_tstamp *tstamp;
> +	bool inserted;
>   	u64 timeout;
>   
> +restart:
>   	ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_ATOMIC);
>   	if (IS_ERR(ct))
>   		return ERR_PTR(-ENOMEM);
> @@ -2373,10 +2375,26 @@ ctnetlink_create_conntrack(struct net *net,
>   	if (tstamp)
>   		tstamp->start = ktime_get_real_ns();
>   
> -	err = nf_conntrack_hash_check_insert(ct);
> -	if (err < 0)
> -		goto err2;
> +	err = nf_conntrack_hash_check_insert(ct, &inserted);
> +	if (err < 0) {
> +		if (inserted) {
> +			nf_ct_put(ct);
> +			rcu_read_unlock();
> +			if (err == -EAGAIN)
> +				goto restart;
> +			return err;
> +		}
>   
> +		if (ct->master)
> +			nf_ct_put(ct->master);
> +
> +		if (err == -EAGAIN) {
> +			rcu_read_unlock();
> +			nf_conntrack_free(ct);
> +			goto restart;
> +		}
> +		goto err2;
> +	}
>   	rcu_read_unlock();
>   
>   	return ct;
