Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C4F246FE
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 06:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfEUErg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 00:47:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47604 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725982AbfEUErg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 00:47:36 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BE8CB81DEE;
        Tue, 21 May 2019 04:47:30 +0000 (UTC)
Received: from [10.72.12.36] (ovpn-12-36.pek2.redhat.com [10.72.12.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC7EE5DA34;
        Tue, 21 May 2019 04:47:25 +0000 (UTC)
Subject: Re: [PATCH v2 net 2/2] net: core: generic XDP support for stacked
 device
To:     Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
References: <20190519031046.4049-1-sthemmin@microsoft.com>
 <20190519031046.4049-3-sthemmin@microsoft.com>
 <20190520091105.GA2142@nanopsycho>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cdfec194-30f3-f040-3bb2-98bb08add759@redhat.com>
Date:   Tue, 21 May 2019 12:47:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520091105.GA2142@nanopsycho>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 21 May 2019 04:47:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/20 下午5:11, Jiri Pirko wrote:
> Sun, May 19, 2019 at 05:10:46AM CEST, stephen@networkplumber.org wrote:
>> When a device is stacked like (team, bonding, failsafe or netvsc) the
>> XDP generic program for the parent device is not called.  In these
>> cases, the rx handler changes skb->dev to its own in the receive
>> handler, and returns RX_HANDLER_ANOTHER.  Fix this by calling
>> do_xdp_generic if necessary before starting another round.
>>
>> Review of all the places RX_HANDLER_ANOTHER is returned
>> show that the current devices do correctly change skb->dev.
>>
>> There was an older patch that got abandoned that did the
>> same thing, this is just a rewrite.
>>
>> Suggested-by: Jason Wang <jasowang@redhat.com>
>> Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
>> Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
>> Acked-by: Jason Wang <jasowang@redhat.com>
>> ---
>> net/core/dev.c | 10 ++++++++++
>> 1 file changed, 10 insertions(+)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index b6b8505cfb3e..240d0b2de1a8 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -4921,6 +4921,16 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
>> 			ret = NET_RX_SUCCESS;
>> 			goto out;
>> 		case RX_HANDLER_ANOTHER:
>> +			if (static_branch_unlikely(&generic_xdp_needed_key)) {
>> +				struct bpf_prog *xdp_prog;
>> +
>> +				xdp_prog = rcu_dereference(skb->dev->xdp_prog);
>> +				ret = do_xdp_generic(xdp_prog, skb);
>> +				if (ret != XDP_PASS) {
>> +					ret = NET_RX_SUCCESS;
>> +					goto out;
>> +				}
>> +			}
> I'm always scarred of changes like this. The history tells us that this
> codepaths are very fragile. It took us non-trivial efford to fix bonding
> here, not to mention vlans (that was pain).


I may miss something, did you see any issue for bonding with this patch?


>
> The reason for troubles was often fact that different flows were treated
> differently (vlan accel/non-accel).


Do you mean we need do something similar after vlan_do_receive() returns 
true?


> This patch calls do_xdp_generic for master device in different point in
> the receive patch comparing to lower device. Would it be possible to
> unify this? E.g. by moving do_xdp_generice() call from
> netif_rx_internal()/netif_receive_skb_internal() here,
> to the beginning of __netif_receive_skb_core()?


Probably just after another_round label. And this means generic XDP is 
done after RPS which could be even better.

Thanks


>
>
>
>> 			goto another_round;
>> 		case RX_HANDLER_EXACT:
>> 			deliver_exact = true;
>> -- 
>> 2.20.1
>>
