Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FFB360F8A
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 17:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbhDOPzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 11:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234048AbhDOPzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 11:55:43 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E14C061574;
        Thu, 15 Apr 2021 08:55:18 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 101-20020a9d0d6e0000b02902816815ff62so17105315oti.9;
        Thu, 15 Apr 2021 08:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pStlUn1qBb+9eiPHL/0Eb/IV7iFG70VO+iwkbbQjxbI=;
        b=Rv6xpXhW2dcvW76pB+Lx04HG2tL645Qqn/VGp/+EPx6OZ/o8Gz0WBPLFXoiLvLmDMJ
         TY7vSFxAVOZ3cSVrwINdZjDGik6tbQlKoYsu9esRNdyiaTpFvyFlOYySQCm7iWvnkPne
         PnMzCHAPxRdWykbZqhgFm8teT1N5/65SpH5P9ipv5MO6e111QXGskzHCxJlGZ9O+7+I2
         E3rM8mdZBNuX2rYzSmP3Gho/Z83Y3PJ3ViW5tleQW2gPq6ej5yCmt/rTuNUf33SnVwiJ
         vB+ykzjBuLu0gQlCgY7AHTZkpwPcNEiUeFF/vbsiVLqGcLvawg4J3zKb4KNqhBXsXFP6
         LbLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pStlUn1qBb+9eiPHL/0Eb/IV7iFG70VO+iwkbbQjxbI=;
        b=nCgPHlMZCfjBjI+3wdKCIYf8C34HqwB2wiovleKYzl5JU2vPeKvSftCQjls2e4YrYr
         jmlww9LxVJLLW6r95omIJ/r8GBcBpJKsa4RL3Dyxpw8u13jS2XUkhPakdZa2HDGflyLk
         axNWP8HtTpT+TIbAdjydBYWuv8uSSzwmnaInqzONhgORYdenU67bdqNfMXpzgygf6AIp
         UHd/Go8CQfYm6JDEa88i2z968aWThD9sbvFK/hFxvCDyWGkySwSYHjhnMyGf1FMMaBiT
         mQixD/qOg2k7gXjl6VUavc0TRIyUBCTxiLvnw+pX2nS3UEdjlTqjMQ8oGJQvJHeIsbCD
         Fxqw==
X-Gm-Message-State: AOAM5307ePtCnft2/6BBxhcsv3jRQ5VMhsZrj+lgunHw9dMpgzjNkGS4
        BEpBLhxP1NnR1oJ7U0YgYQm076b2kt4=
X-Google-Smtp-Source: ABdhPJxBqD6tZleKegDmco4eGGoqID4jcRozaM12Y7EhiB5EmefvOGHdLrD0vRyije98dbjR7CKGsg==
X-Received: by 2002:a9d:3a4a:: with SMTP id j68mr1327otc.4.1618502117971;
        Thu, 15 Apr 2021 08:55:17 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.70])
        by smtp.googlemail.com with ESMTPSA id w7sm706528ote.52.2021.04.15.08.55.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 08:55:17 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next] cpumap: bulk skb using netif_receive_skb_list
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        brouer@redhat.com, song@kernel.org
References: <bb627106428ea3223610f5623142c24270f0e14e.1618330734.git.lorenzo@kernel.org>
 <252403c5-d3a7-03fb-24c3-0f328f8f8c70@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <47f3711d-e13a-a537-4e0e-13c3c5ff6822@gmail.com>
Date:   Thu, 15 Apr 2021 08:55:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <252403c5-d3a7-03fb-24c3-0f328f8f8c70@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/21 8:05 AM, Daniel Borkmann wrote:
> On 4/13/21 6:22 PM, Lorenzo Bianconi wrote:
>> Rely on netif_receive_skb_list routine to send skbs converted from
>> xdp_frames in cpu_map_kthread_run in order to improve i-cache usage.
>> The proposed patch has been tested running xdp_redirect_cpu bpf sample
>> available in the kernel tree that is used to redirect UDP frames from
>> ixgbe driver to a cpumap entry and then to the networking stack.
>> UDP frames are generated using pkt_gen.
>>
>> $xdp_redirect_cpu  --cpu <cpu> --progname xdp_cpu_map0 --dev <eth>
>>
>> bpf-next: ~2.2Mpps
>> bpf-next + cpumap skb-list: ~3.15Mpps
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> ---
>> Changes since v1:
>> - fixed comment
>> - rebased on top of bpf-next tree
>> ---
>>   kernel/bpf/cpumap.c | 11 +++++------
>>   1 file changed, 5 insertions(+), 6 deletions(-)
>>
>> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
>> index 0cf2791d5099..d89551a508b2 100644
>> --- a/kernel/bpf/cpumap.c
>> +++ b/kernel/bpf/cpumap.c
>> @@ -27,7 +27,7 @@
>>   #include <linux/capability.h>
>>   #include <trace/events/xdp.h>
>>   -#include <linux/netdevice.h>   /* netif_receive_skb_core */
>> +#include <linux/netdevice.h>   /* netif_receive_skb_list */
>>   #include <linux/etherdevice.h> /* eth_type_trans */
>>     /* General idea: XDP packets getting XDP redirected to another CPU,
>> @@ -257,6 +257,7 @@ static int cpu_map_kthread_run(void *data)
>>           void *frames[CPUMAP_BATCH];
>>           void *skbs[CPUMAP_BATCH];
>>           int i, n, m, nframes;
>> +        LIST_HEAD(list);
>>             /* Release CPU reschedule checks */
>>           if (__ptr_ring_empty(rcpu->queue)) {
>> @@ -305,7 +306,6 @@ static int cpu_map_kthread_run(void *data)
>>           for (i = 0; i < nframes; i++) {
>>               struct xdp_frame *xdpf = frames[i];
>>               struct sk_buff *skb = skbs[i];
>> -            int ret;
>>                 skb = __xdp_build_skb_from_frame(xdpf, skb,
>>                                xdpf->dev_rx);
>> @@ -314,11 +314,10 @@ static int cpu_map_kthread_run(void *data)
>>                   continue;
>>               }
>>   -            /* Inject into network stack */
>> -            ret = netif_receive_skb_core(skb);
>> -            if (ret == NET_RX_DROP)
>> -                drops++;
>> +            list_add_tail(&skb->list, &list);
>>           }
>> +        netif_receive_skb_list(&list);
>> +
>>           /* Feedback loop via tracepoint */
>>           trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched,
>> &stats);
> 
> Given we stop counting drops with the netif_receive_skb_list(), we
> should then
> also remove drops from trace_xdp_cpumap_kthread(), imho, as otherwise it
> is rather
> misleading (as in: drops actually happening, but 0 are shown from the
> tracepoint).
> Given they are not considered stable API, I would just remove those to
> make it clear
> to users that they cannot rely on this counter anymore anyway.
> 

What's the visibility into drops then? Seems like it would be fairly
easy to have netif_receive_skb_list return number of drops.
