Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F79E653B2B
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 05:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbiLVETO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 23:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLVETM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 23:19:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7443521829
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 20:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671682702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Qy8hVVHmVV3a9aFahEig8gWF7+7mU2tU8B+FtzuZ9U=;
        b=Jy7qT3z/PwbhKypKPt92PhcRtA48MIj+0++LG6KkrOa1Q0PZRtmoYOgIdaergqhNBQy7Wu
        56aq8c4MPD0IxnR4HY4olA7gO7XCAO5/wbsaKlN3mlR+XTZyeuphz7MpBzoWs/za3RNd4R
        5kaGI7J/5I3uqYk4SOSoc3vUJigs+Jk=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-619-mysiD3w_MLG8kcHERs_y7Q-1; Wed, 21 Dec 2022 23:18:21 -0500
X-MC-Unique: mysiD3w_MLG8kcHERs_y7Q-1
Received: by mail-pl1-f199.google.com with SMTP id o5-20020a170903210500b0018f9edbba6eso646355ple.11
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 20:18:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Qy8hVVHmVV3a9aFahEig8gWF7+7mU2tU8B+FtzuZ9U=;
        b=p9Ij0mGj7D1t+gGk3/8xi3ekkXpR98vtd/QZk1IrYgT9MLCuHr4XmBGT41FZCSiOXu
         wdkw09dQV9ebFAK53+SB6HewNNs0WLtsQ1mVSmqxa3UEdo6aJsxIwMFISt4wXc7mTIlw
         9wjBEr05nfxHfdkeExN2jrEF9R7xMW28kr8vudmo7o5W3QhOr1IXQtJ0051FMfb9ACy+
         j94LxyOCovIi0vlZweMWdicZR7oBKAtxtFvfiqL7DbhFatj86YfiX0GviNaEAmNPC1zq
         43/DYFH0j6N7cvEqNEygO+oTUlw9ju07VCz9pb88VL9vG41RhivbhDPnGi7R2lWEjpKn
         HF9Q==
X-Gm-Message-State: AFqh2kouZ2KOKHyZZWFZJBGqlnvG1VFKQc/54l0XHu6iiX7Zc62pcPtI
        HtOpiSNBxNoOdO1plv2k/VNZq6Yv3KkYUVJv2uKyEWoZ93xm1XiquIZ2wGhMBCHmjAw0UDb20g4
        O2XKFT3WtYDZhwpTQ
X-Received: by 2002:a17:902:8693:b0:191:e0b0:f8df with SMTP id g19-20020a170902869300b00191e0b0f8dfmr4257953plo.58.1671682700228;
        Wed, 21 Dec 2022 20:18:20 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvZKUVvz7e/snSM74hURYmadL6kaZsaTLi4j3NcrD1AHY0tQQj2CPhCtOvjsaEFfVjLLRP5tg==
X-Received: by 2002:a17:902:8693:b0:191:e0b0:f8df with SMTP id g19-20020a170902869300b00191e0b0f8dfmr4257947plo.58.1671682700005;
        Wed, 21 Dec 2022 20:18:20 -0800 (PST)
Received: from [10.72.13.15] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902e54a00b0018b025d9a40sm12290654plf.256.2022.12.21.20.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 20:18:19 -0800 (PST)
Message-ID: <bd1c0fea-9934-1956-b3fe-0442d90b0477@redhat.com>
Date:   Thu, 22 Dec 2022 12:18:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [RFC PATCH 1/6] vdpa: add bind_mm callback
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, eperezma@redhat.com,
        stefanha@redhat.com, netdev@vger.kernel.org
References: <20221214163025.103075-1-sgarzare@redhat.com>
 <20221214163025.103075-2-sgarzare@redhat.com>
 <CACGkMEtB6uQ_6fKU5F-D0vG+gQz9mMdYWUQwre-yp1sVpGvKPQ@mail.gmail.com>
 <20221216081738.wlhevfmvzfs3rsrg@sgarzare-redhat>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20221216081738.wlhevfmvzfs3rsrg@sgarzare-redhat>
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


在 2022/12/16 16:17, Stefano Garzarella 写道:
> On Fri, Dec 16, 2022 at 02:37:45PM +0800, Jason Wang wrote:
>> On Thu, Dec 15, 2022 at 12:30 AM Stefano Garzarella 
>> <sgarzare@redhat.com> wrote:
>>>
>>> This new optional callback is used to bind the device to a specific
>>> address space so the vDPA framework can use VA when this callback
>>> is implemented.
>>>
>>> Suggested-by: Jason Wang <jasowang@redhat.com>
>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>> ---
>>>  include/linux/vdpa.h | 8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>>> index 6d0f5e4e82c2..34388e21ef3f 100644
>>> --- a/include/linux/vdpa.h
>>> +++ b/include/linux/vdpa.h
>>> @@ -282,6 +282,12 @@ struct vdpa_map_file {
>>>   *                             @iova: iova to be unmapped
>>>   *                             @size: size of the area
>>>   *                             Returns integer: success (0) or 
>>> error (< 0)
>>> + * @bind_mm:                   Bind the device to a specific 
>>> address space
>>> + *                             so the vDPA framework can use VA 
>>> when this
>>> + *                             callback is implemented. (optional)
>>> + *                             @vdev: vdpa device
>>> + *                             @mm: address space to bind
>>
>> Do we need an unbind or did a NULL mm mean unbind?
>
> Yep, your comment in patch 6 makes it necessary. I will add it!
>
>>
>>> + *                             @owner: process that owns the 
>>> address space
>>
>> Any reason we need the task_struct here?
>
> Mainly to attach to kthread to the process cgroups, but that part is 
> still in TODO since I need to understand it better.


Ok I see.


>
> Maybe we can remove the task_struct here and use `current` directly in 
> the callback.


Yes, it's easier to start without cgroup and we can add it on top.

Thanks


>
> Thanks,
> Stefano
>

