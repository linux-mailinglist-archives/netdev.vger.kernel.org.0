Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B289657339
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 07:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiL1G3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 01:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiL1G3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 01:29:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F6FCE13
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 22:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672208919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DbUzAzU8qV0mppsbamYYrNEmMvPbAup+QMVCDwVAadQ=;
        b=T/vAn9RxNRyRePrgxVeRaTWCAjaGYmZ8RlFRTP416PwP5pDDrshiqrq2gYrsnhddpG9jhy
        ophNvsZ+0Mtk51+pE1pu641aPGagFKsiwHQXxnyZzqYqTJPF5hoyUdk4749CcJgLvv+U7c
        T2CSXFX2FKTNA0XPqvd1NqWoHLGTOkE=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-673-U2KN_MK8PiGz4dUZPSX-yA-1; Wed, 28 Dec 2022 01:28:37 -0500
X-MC-Unique: U2KN_MK8PiGz4dUZPSX-yA-1
Received: by mail-pj1-f70.google.com with SMTP id l21-20020a17090aec1500b00225e3da1786so2995920pjy.7
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 22:28:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DbUzAzU8qV0mppsbamYYrNEmMvPbAup+QMVCDwVAadQ=;
        b=aGdyIkxL1kVi6DgXfStODXvBgYHLxUG3amyh/+EUb3FyfStMGjUPiuZPe4ZtzCAcNY
         BNjcmgN5+QJoSOKPDJyI31JAwPlyap+cy5o4cY0dqj32K5AWbISfQYrDmUl/oDXIFtOL
         sSjy0BQvzwA64Afi47dbIskZPo+0MPXzH3O0/Sy+GpLohmLj/Wfm9HhRdHM7+8w/Ba2A
         j6uW8G7O7W5AaGdnoq69YnuQiFcceXR14YlM/UD72EE8p74AZRmQr5qjS+oRT6b40iWg
         Gd1weX2ZxxAvWVqQmOevfspg0NlBGvNloY7C2rd1tlSOStaPD+K6Pz/MgrSrSDP0Jw87
         eHYw==
X-Gm-Message-State: AFqh2koy0tnk0qi/FFVHyn9y3ptR07ZsCT4v82q2+fWX/YebF3Fj3ENz
        GyxrDw5ZAvgC0lZn0xznuPxqzO7J6WM30Sz5MYIIer21Oe5mERR1C/Rsovk0CYC/6nLc0IeI4Da
        LQUU8cVAYQupLyqsl
X-Received: by 2002:a17:902:7c90:b0:18f:6b2b:e88d with SMTP id y16-20020a1709027c9000b0018f6b2be88dmr24947394pll.36.1672208916526;
        Tue, 27 Dec 2022 22:28:36 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsfbz9Y6f4YQnAE8xRcxjVSWe8LPD3nA7dNwikMjch5zCwGSH5PZzOWcZ8vCZdu+vnyZkqV8g==
X-Received: by 2002:a17:902:7c90:b0:18f:6b2b:e88d with SMTP id y16-20020a1709027c9000b0018f6b2be88dmr24947384pll.36.1672208916285;
        Tue, 27 Dec 2022 22:28:36 -0800 (PST)
Received: from [10.72.13.7] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902a38200b0017f48a9e2d6sm9994259pla.292.2022.12.27.22.28.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 22:28:35 -0800 (PST)
Message-ID: <c1b27a21-833c-2f3d-1943-7ab68c73836b@redhat.com>
Date:   Wed, 28 Dec 2022 14:28:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/9] virtio_net: disable the hole mechanism for xdp
Content-Language: en-US
To:     Heng Qi <hengqi@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
 <20221220141449.115918-2-hengqi@linux.alibaba.com>
 <8d81ab3b-c10b-1a46-3ae1-b87228dbeb4e@redhat.com>
 <318bcc35-9699-ba94-d470-e81d246831a5@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <318bcc35-9699-ba94-d470-e81d246831a5@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/12/27 15:32, Heng Qi 写道:
>
>
> 在 2022/12/27 下午2:30, Jason Wang 写道:
>>
>> 在 2022/12/20 22:14, Heng Qi 写道:
>>> XDP core assumes that the frame_size of xdp_buff and the length of
>>> the frag are PAGE_SIZE. The hole may cause the processing of xdp to
>>> fail, so we disable the hole mechanism when xdp is set.
>>>
>>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> ---
>>>   drivers/net/virtio_net.c | 5 ++++-
>>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index 9cce7dec7366..443aa7b8f0ad 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -1419,8 +1419,11 @@ static int add_recvbuf_mergeable(struct 
>>> virtnet_info *vi,
>>>           /* To avoid internal fragmentation, if there is very 
>>> likely not
>>>            * enough space for another buffer, add the remaining 
>>> space to
>>>            * the current buffer.
>>> +         * XDP core assumes that frame_size of xdp_buff and the length
>>> +         * of the frag are PAGE_SIZE, so we disable the hole 
>>> mechanism.
>>>            */
>>> -        len += hole;
>>> +        if (!headroom)
>>> +            len += hole;
>>
>>
>> Is this only a requirement of multi-buffer XDP? If not, it need to be 
>> backported to stable.
>
> It applies to single buffer xdp and multi-buffer xdp, but even if 
> single buffer xdp has a hole
> mechanism, there will be no problem (limiting mtu and turning off 
> GUEST GSO), so there is
> no need to backport it.


Let's add this in the changelog.

With that,

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


>
> Thanks.
>
>>
>> Thanks
>>
>>
>>>           alloc_frag->offset += hole;
>>>       }
>

