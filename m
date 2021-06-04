Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE55639B0A7
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 05:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhFDDCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 23:02:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20311 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhFDDCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 23:02:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622775635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h7/4MS6/UAZIaNxIFBPyQzBnfKTG+9XLJhdmv1C+xeQ=;
        b=hVJESxuYq6QpLChFJCBc2dLdz3LFEg1URC+kF1PVe71L9qM0WBMgJlqkz2rakqgIJwi7G9
        B4Bbm/Jijq9rWKn1/miBU6Hg6Pdq3NnIYf4yjH8uTaJ/GgFnkRXQeHUOk9toeoGSMO5K07
        d6gEmEfuOVSSf0vjoCwokY8/J8NJG9w=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-IV2fPdkLPeScynGtjnOzAA-1; Thu, 03 Jun 2021 23:00:34 -0400
X-MC-Unique: IV2fPdkLPeScynGtjnOzAA-1
Received: by mail-pj1-f71.google.com with SMTP id z3-20020a17090a4683b029015f6c19f126so4971795pjf.1
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 20:00:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=h7/4MS6/UAZIaNxIFBPyQzBnfKTG+9XLJhdmv1C+xeQ=;
        b=jKzZ0Xj6awd4ZHyO4vOp6d4QxbBjcZq9ub6K6KMpW1MdO12DPM0ovdKjEQK6h1pPsm
         GLBYAQSzYZSHM2Vmrjbmqqut4hARbG+RkwzME+TQReBH5Kr20rxbScoUQfqmnDO+snqo
         tJr0NEAYp8dhv2dNF4BxXO+9NXbfI3aPpdBDUDxbq53FgfD+GX0Vuh2+6VP9FO0idFD3
         3PUUaE6qMX6Mj8qM1uFDPmgRK2hNM0pkSAJUdr7sUIL94GE/6Q7GqlNydBisWISB/SvH
         YplsFH0G//vTyNGFOgZAON6+nZHJMlOmIHjj9COe/+xQ3KEGbiFPn9wghBlRW2s1Y2p+
         9ZnA==
X-Gm-Message-State: AOAM530wtkd5sbHkftWptnCxE9nmIVuF/yJp5Kw/0bNCurA+UpYv3IYZ
        0KHfFdJ5as8cGSW6YAIfUu3shXz0dyq5s+jwkuEld4m4gYhazoqo9ss7v/PnpkVE4XF2/PLuhLh
        l9gTOdH1DPY137EhtxQLqWM4Xj+pezvu7d2pXDu/EnqKeDWB/JLtXc27IqfPyG//cMxkx
X-Received: by 2002:a17:90a:a395:: with SMTP id x21mr2476706pjp.63.1622775633222;
        Thu, 03 Jun 2021 20:00:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxesy3zu14mg5kPb+7fRdWWOa2at1J+p0Hk3DlmS27KByrxCzwqi/z7jYjn+PTiQAlZCnXvMw==
X-Received: by 2002:a17:90a:a395:: with SMTP id x21mr2476666pjp.63.1622775632819;
        Thu, 03 Jun 2021 20:00:32 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d12sm354020pfo.113.2021.06.03.20.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 20:00:32 -0700 (PDT)
Subject: Re: [PATCH net] virtio-net: fix for skb_over_panic inside big mode
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        =?UTF-8?Q?Corentin_No=c3=abl?= <corentin.noel@collabora.com>,
        netdev@vger.kernel.org
References: <1622773823.5042562-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e2ab6611-69fc-480e-f126-b69fecad5280@redhat.com>
Date:   Fri, 4 Jun 2021 11:00:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1622773823.5042562-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/4 上午10:30, Xuan Zhuo 写道:
> On Fri, 4 Jun 2021 10:28:41 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> 在 2021/6/4 上午1:09, Xuan Zhuo 写道:
>>> In virtio-net's large packet mode, there is a hole in the space behind
>>> buf.
>>
>> before the buf actually or behind the vnet header?
>>
>>
>>>       hdr_padded_len - hdr_len
>>>
>>> We must take this into account when calculating tailroom.
>>>
>>> [   44.544385] skb_put.cold (net/core/skbuff.c:5254 (discriminator 1) net/core/skbuff.c:5252 (discriminator 1))
>>> [   44.544864] page_to_skb (drivers/net/virtio_net.c:485) [   44.545361] receive_buf (drivers/net/virtio_net.c:849 drivers/net/virtio_net.c:1131)
>>> [   44.545870] ? netif_receive_skb_list_internal (net/core/dev.c:5714)
>>> [   44.546628] ? dev_gro_receive (net/core/dev.c:6103)
>>> [   44.547135] ? napi_complete_done (./include/linux/list.h:35 net/core/dev.c:5867 net/core/dev.c:5862 net/core/dev.c:6565)
>>> [   44.547672] virtnet_poll (drivers/net/virtio_net.c:1427 drivers/net/virtio_net.c:1525)
>>> [   44.548251] __napi_poll (net/core/dev.c:6985)
>>> [   44.548744] net_rx_action (net/core/dev.c:7054 net/core/dev.c:7139)
>>> [   44.549264] __do_softirq (./arch/x86/include/asm/jump_label.h:19 ./include/linux/jump_label.h:200 ./include/trace/events/irq.h:142 kernel/softirq.c:560)
>>> [   44.549762] irq_exit_rcu (kernel/softirq.c:433 kernel/softirq.c:637 kernel/softirq.c:649)
>>> [   44.551384] common_interrupt (arch/x86/kernel/irq.c:240 (discriminator 13))
>>> [   44.551991] ? asm_common_interrupt (./arch/x86/include/asm/idtentry.h:638)
>>> [   44.552654] asm_common_interrupt (./arch/x86/include/asm/idtentry.h:638)
>>>
>>> Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> Reported-by: Corentin Noël <corentin.noel@collabora.com>
>>> Tested-by: Corentin Noël <corentin.noel@collabora.com>
>>> ---
>>>    drivers/net/virtio_net.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index fa407eb8b457..78a01c71a17c 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -406,7 +406,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>>    	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
>>>    	 */
>>>    	truesize = headroom ? PAGE_SIZE : truesize;
>>> -	tailroom = truesize - len - headroom;
>>> +	tailroom = truesize - len - headroom - (hdr_padded_len - hdr_len);
>>
>> The patch looks correct and I saw it has been merged.
>>
>> But I prefer to do that in receive_big() instead of here.
>>
>> Thanks
> How?
>
> change truesize or headroom?
>
> I didn't find a good way. Do you have a good way?


Something like the following? The API is designed to let the caller to 
pass a correct headroom instead of figure it out by itself.

         struct sk_buff *skb =
                 page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0, 
hdr_padded_len - hdr_len);

Thanks


>
> Thanks.
>
>>
>>
>>>    	buf = p - headroom;
>>>
>>>    	len -= hdr_len;

