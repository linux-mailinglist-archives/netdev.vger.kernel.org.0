Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D1E1FFEDE
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 01:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgFRXor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 19:44:47 -0400
Received: from mga12.intel.com ([192.55.52.136]:55311 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbgFRXoq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 19:44:46 -0400
IronPort-SDR: ZQBg19B2J7KpKfs+yJbxtJrY39F9I/SxutnBweIjsXkigZQBERgK6s7GU77w9myNZQFmCTlzvB
 p0EwqvsvvkGw==
X-IronPort-AV: E=McAfee;i="6000,8403,9656"; a="122512518"
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="122512518"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2020 16:44:45 -0700
IronPort-SDR: qlAX8msfKkt09v5J0jmQfcyDm8n5LUSCTeGPA8bKIy4xvEvAqcjpAKs8R6KdHwHlMY+f82jVT+
 AUw2fsKbYMCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="352562028"
Received: from anambiar-mobl.amr.corp.intel.com (HELO [10.134.82.79]) ([10.134.82.79])
  by orsmga001.jf.intel.com with ESMTP; 18 Jun 2020 16:44:44 -0700
Subject: Re: [net-next PATCH] net: Avoid overwriting valid skb->napi_id
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
References: <159251533557.7557.5381023439094175695.stgit@anambiarhost.jf.intel.com>
 <CANn89i+3CZE1V5AQt0MA_ptsjfHEqUL+LV2VwiD41_3dyXq2pQ@mail.gmail.com>
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
Message-ID: <b943b5d1-aa71-4eb2-ee77-d3c56cdf494a@intel.com>
Date:   Thu, 18 Jun 2020 16:44:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CANn89i+3CZE1V5AQt0MA_ptsjfHEqUL+LV2VwiD41_3dyXq2pQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/2020 3:29 PM, Eric Dumazet wrote:
> On Thu, Jun 18, 2020 at 2:21 PM Amritha Nambiar
> <amritha.nambiar@intel.com> wrote:
>>
>> This will be useful to allow busy poll for tunneled traffic. In case of
>> busy poll for sessions over tunnels, the underlying physical device's
>> queues need to be polled.
>>
>> Tunnels schedule NAPI either via netif_rx() for backlog queue or
>> schedule the gro_cell_poll(). netif_rx() propagates the valid skb->napi_id
>> to the socket. OTOH, gro_cell_poll() stamps the skb->napi_id again by
>> calling skb_mark_napi_id() with the tunnel NAPI which is not a busy poll
>> candidate.
> 
> 
> Yes the tunnel NAPI id should be 0 really (look for NAPI_STATE_NO_BUSY_POLL)
> 
>> This was preventing tunneled traffic to use busy poll. A valid
>> NAPI ID in the skb indicates it was already marked for busy poll by a
>> NAPI driver and hence needs to be copied into the socket.
>>
>> Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
>> ---
>>   include/net/busy_poll.h |    6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
>> index 86e028388bad..b001fa91c14e 100644
>> --- a/include/net/busy_poll.h
>> +++ b/include/net/busy_poll.h
>> @@ -114,7 +114,11 @@ static inline void skb_mark_napi_id(struct sk_buff *skb,
>>                                      struct napi_struct *napi)
>>   {
>>   #ifdef CONFIG_NET_RX_BUSY_POLL
>> -       skb->napi_id = napi->napi_id;
>> +       /* If the skb was already marked with a valid NAPI ID, avoid overwriting
>> +        * it.
>> +        */
>> +       if (skb->napi_id < MIN_NAPI_ID)
>> +               skb->napi_id = napi->napi_id;
> 
> 
> It should be faster to not depend on MIN_NAPI_ID (aka NR_CPUS + 1)
> 
>      if (napi->napi_id)
>         skb->napi_id = napi->napi_id;
> 
> Probably not a big deal.
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 

Thanks for the review. Should I send a v2 with this change?

> 
> 
> 
> 
> 
>>
>>   #endif
>>   }
>>
>>
