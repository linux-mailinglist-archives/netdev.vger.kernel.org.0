Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245A0146B17
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 15:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgAWOUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 09:20:53 -0500
Received: from www62.your-server.de ([213.133.104.62]:43474 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728890AbgAWOUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 09:20:52 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iudLe-0001N4-Hy; Thu, 23 Jan 2020 15:20:42 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iudLe-000WmB-5t; Thu, 23 Jan 2020 15:20:42 +0100
Subject: Re: [PATCH v3] [net]: Fix skb->csum update in
 inet_proto_csum_replace16().
To:     Florian Westphal <fw@strlen.de>
Cc:     Praveen Chaudhary <praveen5582@gmail.com>, pablo@netfilter.org,
        davem@davemloft.net, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhenggen Xu <zxu@linkedin.com>,
        Andy Stracner <astracner@linkedin.com>
References: <1573080729-3102-1-git-send-email-pchaudhary@linkedin.com>
 <1573080729-3102-2-git-send-email-pchaudhary@linkedin.com>
 <16d56ee6-53bc-1124-3700-bc0a78f927d6@iogearbox.net>
 <20200122114333.GQ795@breakpoint.cc>
 <daf995db-37c6-a2f7-4d12-5c1a29e1c59b@iogearbox.net>
 <20200123082106.GT795@breakpoint.cc>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1c1fc75d-e69c-f2f6-78ce-de9dc8aa89ca@iogearbox.net>
Date:   Thu, 23 Jan 2020 15:20:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200123082106.GT795@breakpoint.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25704/Thu Jan 23 12:37:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/20 9:21 AM, Florian Westphal wrote:
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 1/22/20 12:43 PM, Florian Westphal wrote:
>>> Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>>> @@ -449,9 +464,6 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
>>>>>     	if (skb->ip_summed != CHECKSUM_PARTIAL) {
>>>>>     		*sum = csum_fold(csum_partial(diff, sizeof(diff),
>>>>>     				 ~csum_unfold(*sum)));
>>>>> -		if (skb->ip_summed == CHECKSUM_COMPLETE && pseudohdr)
>>>>> -			skb->csum = ~csum_partial(diff, sizeof(diff),
>>>>> -						  ~skb->csum);
>>>>
>>>> What is the technical rationale in removing this here but not in any of the
>>>> other inet_proto_csum_replace*() functions? You changelog has zero analysis
>>>> on why here but not elsewhere this change would be needed?
>>>
>>> Right, I think it could be dropped everywhere BUT there is a major caveat:
>>>
>>> At least for the nf_nat case ipv4 header manipulation (which uses the other
>>> helpers froum utils.c) will eventually also update iph->checksum field
>>> to account for the changed ip addresses.
>>>
>>> And that update doesn't touch skb->csum.
>>>
>>> So in a way the update of skb->csum in the other helpers indirectly account
>>> for later ip header checksum update.
>>>
>>> At least that was my conclusion when reviewing the earlier incarnation
>>> of the patch.
>>
>> Mainly asking because not inet_proto_csum_replace16() but the other ones are
>> exposed via BPF and they are all in no way fundamentally different to each
>> other, but my concern is that depending on how the BPF prog updates the csums
>> things could start to break. :/
> 
> I'm reasonably sure removing the skb->csum update from the other
> helpers will also break ipv4 nat :)
> 
> So, AFAIU from what you're saying above the patch seems fine as-is and
> just needs a more verbose commit message explaining why replace16()
> doesn't update skb->csum while all the other ones do.
> 
> Is that correct?

Probably better a comment in the code to avoid confusion on why it's not done in
inet_proto_csum_replace16() but all the other cases; mainly to avoid some folks
in future sending random cleanup patches w/ removal attempts.

Thanks,
Daniel
