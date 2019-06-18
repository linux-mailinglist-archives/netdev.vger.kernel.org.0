Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C764A3E5
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbfFRO1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:27:37 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:59553 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfFRO1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:27:36 -0400
Received: from [192.168.1.5] (unknown [116.234.3.233])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 73226E01650;
        Tue, 18 Jun 2019 22:27:23 +0800 (CST)
Subject: Re: [PATCH] netfilter: nft_paylaod: add base type
 NFT_PAYLOAD_LL_HEADER_NO_TAG
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <1560151280-28908-1-git-send-email-wenxu@ucloud.cn>
 <20190610094433.3wjmpfiph7iwguan@breakpoint.cc>
 <20190617223004.tnqz2bl7qp63fcfy@salvia>
 <20190617224232.55hldt4bw2qcmnll@breakpoint.cc>
 <22ab95cb-9dca-1e48-4ca0-965d340e7d32@ucloud.cn>
 <20190618093748.dydodhngydfcfmeh@breakpoint.cc>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <591caf69-ba08-33b5-5330-8230779cc903@ucloud.cn>
Date:   Tue, 18 Jun 2019 22:27:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190618093748.dydodhngydfcfmeh@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUhXWQgYFAkeWUFZVkpVQ05KS0tLSkNCTENKSkJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OUk6Eww5KTg5NhA5Sxk*AxgQ
        LAoaCzBVSlVKTk1LQ01DS09ITE1JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE9VSFVJSEhZV1kIAVlBSEJKSTcG
X-HM-Tid: 0a6b6afc3b9820bdkuqy73226e01650
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/6/18 17:37, Florian Westphal 写道:
> wenxu <wenxu@ucloud.cn> wrote:
>> On 6/18/2019 6:42 AM, Florian Westphal wrote:
>>> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>>>> Subject: Change bridge l3 dependency to meta protocol
>>>>>
>>>>> This examines skb->protocol instead of ethernet header type, which
>>>>> might be different when vlan is involved.
>>>>>  
>>>>> +	if (ctx->pctx.family == NFPROTO_BRIDGE && desc == &proto_eth) {
>>>>> +		if (expr->payload.desc == &proto_ip ||
>>>>> +		    expr->payload.desc == &proto_ip6)
>>>>> +			desc = &proto_metaeth;
>>>>> +	}i
>>>> Is this sufficient to restrict the matching? Is this still buggy from
>>>> ingress?
>>> This is what netdev family uses as well (skb->protocol i mean).
>>> I'm not sure it will work for output however (haven't checked).
>>>
>>>> I wonder if an explicit NFT_PAYLOAD_CHECK_VLAN flag would be useful in
>>>> the kernel, if so we could rename NFTA_PAYLOAD_CSUM_FLAGS to
>>>> NFTA_PAYLOAD_FLAGS and place it there. Just an idea.
>>> Another unresolved issue is presence of multiple vlan tags, so we might
>>> have to add yet another meta key to retrieve the l3 protocol in use
>> Maybe add a l3proto meta key can handle the multiple vlan tags case with the l3proto dependency.  It
>> should travese all the vlan tags and find the real l3 proto.
> Yes, something like this.
>
> We also need to audit netdev and bridge expressions (reject is known broken)
> to handle vlans properly.
>
> Still, switching nft to prefer skb->protocol instead of eth_hdr->type
> for dependencies would be good as this doesn't need kernel changes and solves
> the immediate problem of 'ip ...' not matching in case of vlan.
>
> If you have time, could you check if using skb->protocol works for nft
> bridge in output, i.e. does 'nft ip protocol icmp' match when its used
> from bridge output path with meta protocol dependency with and without
> vlan in use?

I just check the kernel codes and test with the output chain, the meta protocol dependency can

also work in the outpu chain.

But this patch can't resolve the multiple vlan tags, It need another meta l3proto which do care about

how many vlan tags in the frame.

