Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAFC6DC0DD
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 19:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjDIR3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 13:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjDIR3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 13:29:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211C43580
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 10:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681061300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ul+/dKXn/9Aoa7w0M6JqAO3AJNJgUt88C2iIBDxOZdY=;
        b=JRJrHLWSRd3bMJrz5zj1lruxR2k/XC1AtTztOhub3N+S1CPXbVyaCOkKOp2PeJMj6v43Zb
        VqprycEY5D8xxHD7lUVCpfVdd0cD9sdY7DoYhOHEUGbTArOFv8ylxa9kzpCsLB+0yF77tq
        N6fYuhPN6BLipWI20/OhQMq/iUuKrcs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390-x9IijrkfMCmHI4pPooBXUw-1; Sun, 09 Apr 2023 13:28:18 -0400
X-MC-Unique: x9IijrkfMCmHI4pPooBXUw-1
Received: by mail-ed1-f70.google.com with SMTP id z35-20020a509e26000000b0050470b9aeabso4121470ede.1
        for <netdev@vger.kernel.org>; Sun, 09 Apr 2023 10:28:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681061297; x=1683653297;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ul+/dKXn/9Aoa7w0M6JqAO3AJNJgUt88C2iIBDxOZdY=;
        b=UVA1UJLyndrHDjO7ROrLBSYx31WowlwxjnWzrhJ6sarXXrHL2QCxfhAYOwmeBVdwKV
         TfVuEqINi2JcRj2m4k8GfIaQVE1cK/lv5RCUNEeB706F1cMKZ35Qd8AAqoM4a8fbdUyJ
         vDGqjZIHfb4v3KHReFsqSCGdpD+4I25jPCSRlS54IiF5tXHle0RDsK6meDWuaAop6yKI
         lXKiHILfdAZ3sax1ZoUCeng0VvIQ3o15dZ1FBmDl5dc560ekEptSAUTFXFecxIq6iMOP
         S7qfyW3zVz3pO5uBQ5OimXD0jAK6l60mPCSwvo/GkE8w2iYRhWQDCdydTPF+YnBcbBss
         uZcQ==
X-Gm-Message-State: AAQBX9cCx1N+5eSWdKt4zDuup9pCNkcYjYfEfDUJIBMcFEVCBH4a8Y4A
        hIpav3L9rj44rOBzbxzYxSkyLWMZMD5fZEOwoyYlelkjEsxvis1ZM+hMPMgYp5NvFP38FkkmKYY
        31zNh4DlMgOaVgJJq
X-Received: by 2002:a17:907:c60f:b0:94a:6fe4:c309 with SMTP id ud15-20020a170907c60f00b0094a6fe4c309mr1736597ejc.16.1681061297843;
        Sun, 09 Apr 2023 10:28:17 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z10xDtxaN40+Oj5aqE/77p/7HUCRuoo4w1neUC2D2yeG15oElya9PVF2S32TmdANBkzp5m4g==
X-Received: by 2002:a17:907:c60f:b0:94a:6fe4:c309 with SMTP id ud15-20020a170907c60f00b0094a6fe4c309mr1736587ejc.16.1681061297526;
        Sun, 09 Apr 2023 10:28:17 -0700 (PDT)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id v22-20020a170906489600b00939faf4be97sm4324625ejq.215.2023.04.09.10.28.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Apr 2023 10:28:17 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <51926b9f-80f5-9b52-3377-0807b6340662@redhat.com>
Date:   Sun, 9 Apr 2023 19:28:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC net-next v2 1/3] net: skb: plumb napi state thru skb freeing
 paths
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>
References: <20230405232100.103392-1-kuba@kernel.org>
 <20230405232100.103392-2-kuba@kernel.org>
 <2628d71f-ef66-6ea9-61da-6d01c04fbda9@huawei.com>
 <20230407071402.09fa792f@kernel.org> <20230407082818.1aefb90f@kernel.org>
In-Reply-To: <20230407082818.1aefb90f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07/04/2023 17.28, Jakub Kicinski wrote:
> On Fri, 7 Apr 2023 07:14:02 -0700 Jakub Kicinski wrote:
>>>> -static bool skb_pp_recycle(struct sk_buff *skb, void *data)
>>>> +static bool skb_pp_recycle(struct sk_buff *skb, void *data, bool in_normal_napi)
>>>
>>> What does *normal* means in 'in_normal_napi'?
>>> can we just use in_napi?
>>
>> Technically netpoll also calls NAPI, that's why I threw in the
>> "normal". If folks prefer in_napi or some other name I'm more
>> than happy to change. Naming is hard.
> 
> Maybe I should rename it to in_softirq ? Or napi_safe ?
> Because __kfree_skb_defer() gets called from the Tx side.
> And even the Rx deferred free isn't really *in* NAPI.
> 

I like the name "napi_safe".

--Jesper

