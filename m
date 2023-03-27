Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464BA6CA891
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 17:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbjC0PGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 11:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbjC0PGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 11:06:15 -0400
Received: from tretyak2.mcst.ru (tretyak2.mcst.ru [212.5.119.215])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE23D49E0;
        Mon, 27 Mar 2023 08:05:54 -0700 (PDT)
Received: from tretyak2.mcst.ru (localhost [127.0.0.1])
        by tretyak2.mcst.ru (Postfix) with ESMTP id ADE3110238E;
        Mon, 27 Mar 2023 18:05:52 +0300 (MSK)
Received: from frog.lab.sun.mcst.ru (frog.lab.sun.mcst.ru [172.16.4.50])
        by tretyak2.mcst.ru (Postfix) with ESMTP id A748D102376;
        Mon, 27 Mar 2023 18:04:52 +0300 (MSK)
Received: from [172.16.7.18] (gang [172.16.7.18])
        by frog.lab.sun.mcst.ru (8.13.4/8.12.11) with ESMTP id 32RF4pED030907;
        Mon, 27 Mar 2023 18:04:52 +0300
Message-ID: <a5b24f66-4169-4204-034d-872340b4c141@mcst.ru>
Date:   Mon, 27 Mar 2023 18:09:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [lvc-project] [PATCH] netfilter: nfnetlink: NULL-check skb->dev
 in __build_packet_message()
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
References: <20230327094116.1763201-1-Igor.A.Artemiev@mcst.ru>
 <ZCFuaDrSdsyzRdgJ@salvia>
From:   "Igor A. Artemiev" <Igor.A.Artemiev@mcst.ru>
In-Reply-To: <ZCFuaDrSdsyzRdgJ@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.39/RELEASE,
         bases: 20111107 #2745587, check: 20230327 notchecked
X-AV-Checked: ClamAV using ClamSMTP
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/27/23 13:22, Pablo Neira Ayuso wrote:
> On Mon, Mar 27, 2023 at 12:41:16PM +0300, Igor Artemiev wrote:
>> After having been compared to NULL value at nfnetlink_log.c:560,
>> pointer 'skb->dev' is dereferenced at nfnetlink_log.c:576.
>>
>> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>>
>> Signed-off-by: Igor Artemiev <Igor.A.Artemiev@mcst.ru>
>> ---
>>   net/netfilter/nfnetlink_log.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
>> index d97eb280cb2e..2711509eb9a5 100644
>> --- a/net/netfilter/nfnetlink_log.c
>> +++ b/net/netfilter/nfnetlink_log.c
>> @@ -572,7 +572,7 @@ __build_packet_message(struct nfnl_log_net *log,
>>   		}
>>   	}
>>   
>> -	if (indev && skb_mac_header_was_set(skb)) {
>> +	if (indev && skb->dev && skb_mac_header_was_set(skb)) {
> This cannot ever happen, we assume skb->dev is always set on.
>
>>   		if (nla_put_be16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
>>   		    nla_put_be16(inst->skb, NFULA_HWLEN,
>>   				 htons(skb->dev->hard_header_len)))
>> -- 
>> 2.30.2
>>

If skb->dev is always set on, should the check at nfnetlink_log.c:560 be removed?
|

if  (indev  &&  skb->dev  &&
	skb_mac_header_was_set(skb)  &&
	    	skb_mac_header_len(skb)  !=  0)  { |

||Thanks, Igor

