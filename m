Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA21264FF5
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgIJT5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgIJTzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:55:51 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAD9C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:55:49 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id k15so5305147pfc.12
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4XllmOs8krK5AbKZwpUMDJTOPh7GLehBf9mQv5KvBYk=;
        b=nHIl6DIgbjrpzAk+9GEArTOubJ1JB7RmIdhS5QOwRQQ+WSLZgIjICHsD+oFidGWeqo
         +gxzLp6cOQipgZIJxGRmDhO1cPBOp2fDd4V4wQ9CXeZYTaUJUXYWRcmofxm9diZQ0uuR
         hawPTNuDxJBa0Z1lcXMVz+eiZ1u0fAuoZj++kwRDLEbIg+lbF+DhxfBtqp//714gnCpF
         vYoUCOiXtAHeNLNAbGIzzfUKAHRErFq4F7lg8aMpwi5ISIvEsM0U2OMdXNAQus15/MCN
         YVZ9BLQJvTZ7AT0hQSJv7YZ/G9vldHJmRBGUiQN1o7YTvnKD2lMWADR7Fwxrpnr+LT3I
         wtIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4XllmOs8krK5AbKZwpUMDJTOPh7GLehBf9mQv5KvBYk=;
        b=Sobe7xjMGnNLHtESaJKjSxLYBxiLhNRFEXdzzQ+qKZPe2bQ6FEvx9B0LQBrgipKpha
         fWWP5H0qB0b+QVbgDSJutFZeIa5iFcgwSbtwZio/vqFGIXOJSrFuchRtPf7K0OBBGa3E
         Js8MXoNBzpMA3EtEPYzkEVykLCScCpMB2YBaCmdCGNhYI/lpO7pr1WCiZ6eLaKl1q+KP
         t39m1pS5g1RFcaOv1N/tQ6PuU4JsQzUAaYQpcdZhdUupet7K+JxfPmxmp8/FyKPnjbrC
         00l1gZ7jLyJ8m6BFeCh1XHger0gDpbD863MEzpxdWenvyq8jLrcJNTnZt6e//gtW41Vv
         Sx3A==
X-Gm-Message-State: AOAM531wB4NKotx3aCiFkwZOWL8rgZLzklZF1kZqiSM5O4Ovtwo6VPJU
        aOzZYerjaDsXecnvaLWxDupIMNDZNQM=
X-Google-Smtp-Source: ABdhPJw/np2XdJX8i5RsVcM6CNSihqZe9GXSChugVpxDzWIBq3cjKhepFV3UCvkxLktsXyxlZw9ehA==
X-Received: by 2002:aa7:90cf:: with SMTP id k15mr6762787pfk.78.1599767748782;
        Thu, 10 Sep 2020 12:55:48 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j35sm5336207pgi.91.2020.09.10.12.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 12:55:48 -0700 (PDT)
Subject: Re: [RFC PATCH] __netif_receive_skb_core: don't untag vlan from skb
 on DSA master
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>, kuba@kernel.org,
        andrew@lunn.ch, willemdebruijn.kernel@gmail.com,
        edumazet@google.com
Cc:     netdev@vger.kernel.org
References: <20200910162218.1216347-1-olteanv@gmail.com>
 <ea9437b4-e7ba-e31c-0576-36eaeee806a1@gmail.com>
Message-ID: <3ae92181-b80c-c152-4274-50711c3ed062@gmail.com>
Date:   Thu, 10 Sep 2020 12:55:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <ea9437b4-e7ba-e31c-0576-36eaeee806a1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 12:46 PM, Florian Fainelli wrote:
> 
> 
> On 9/10/2020 9:22 AM, Vladimir Oltean wrote:
>> A DSA master interface has upper network devices, each representing an
>> Ethernet switch port attached to it. Demultiplexing the source ports and
>> setting skb->dev accordingly is done through the catch-all ETH_P_XDSA
>> packet_type handler. Catch-all because DSA vendors have various header
>> implementations, which can be placed anywhere in the frame: before the
>> DMAC, before the EtherType, before the FCS, etc. So, the ETH_P_XDSA
>> handler acts like an rx_handler more than anything.
>>
>> It is unlikely for the DSA master interface to have any other upper than
>> the DSA switch interfaces themselves. Only maybe a bridge upper*, but it
>> is very likely that the DSA master will have no 8021q upper. So
>> __netif_receive_skb_core() will try to untag the VLAN, despite the fact
>> that the DSA switch interface might have an 8021q upper. So the skb will
>> never reach that.
>>
>> So far, this hasn't been a problem because most of the possible
>> placements of the DSA switch header mentioned in the first paragraph
>> will displace the VLAN header when the DSA master receives the frame, so
>> __netif_receive_skb_core() will not actually execute any VLAN-specific
>> code for it. This only becomes a problem when the DSA switch header does
>> not displace the VLAN header (for example with a tail tag).
>>
>> What the patch does is it bypasses the untagging of the skb when there
>> is a DSA switch attached to this net device. So, DSA is the only
>> packet_type handler which requires seeing the VLAN header. Once skb->dev
>> will be changed, __netif_receive_skb_core() will be invoked again and
>> untagging, or delivery to an 8021q upper, will happen in the RX of the
>> DSA switch interface itself.
>>
>> *see commit 9eb8eff0cf2f ("net: bridge: allow enslaving some DSA master
>> network devices". This is actually the reason why I prefer keeping DSA
>> as a packet_type handler of ETH_P_XDSA rather than converting to an
>> rx_handler. Currently the rx_handler code doesn't support chaining, and
>> this is a problem because a DSA master might be bridged.
>>
>> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>> ---
>> Resent, sorry, I forgot to copy the list.
>>
>>   net/core/dev.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 152ad3b578de..952541ce1d9d 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -98,6 +98,7 @@
>>   #include <net/busy_poll.h>
>>   #include <linux/rtnetlink.h>
>>   #include <linux/stat.h>
>> +#include <net/dsa.h>
>>   #include <net/dst.h>
>>   #include <net/dst_metadata.h>
>>   #include <net/pkt_sched.h>
>> @@ -5192,7 +5193,7 @@ static int __netif_receive_skb_core(struct 
>> sk_buff **pskb, bool pfmemalloc,
>>           }
>>       }
>> -    if (unlikely(skb_vlan_tag_present(skb))) {
>> +    if (unlikely(skb_vlan_tag_present(skb)) && 
>> !netdev_uses_dsa(skb->dev)) {
> 
> Not that I have performance numbers to claim  this, but we would 
> probably want:
> 
> && likely(!netdev_uses_dsa(skb->dev))
> 
> as well?

And #include <net/dsa.h> as it does not look like there is any implicit 
header inclusion that provides that definition:

net/core/dev.c: In function '__netif_receive_skb_core':
net/core/dev.c:5196:46: error: implicit declaration of function 
'netdev_uses_dsa'; did you mean 'netdev_reset_tc'? 
[-Werror=implicit-function-declaration]


> 
>>   check_vlan_id:
>>           if (skb_vlan_tag_get_id(skb)) {
>>               /* Vlan id is non 0 and vlan_do_receive() above couldn't
>>
> 

-- 
Florian
