Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E5869D897
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 03:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbjBUCje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 21:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbjBUCjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 21:39:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056AB211C7
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 18:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676947098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O1eETGbsNJ3o4GhZE8orvsa9aWlXBtgkGSwcd3OHgbs=;
        b=Qpyn/DRa24FN5Q0osHpA3pvuIO08RfoSU2RdhsJXYgFvlxvErfWOmO5L/EYkCu0+79R2mE
        zpVhiu22Io7MV0gLraifmTyTsdlJjow/U1fXlhLndt7eJ/T50F8bYlTRTAEByJfIVjf4Ky
        UKye+JBVn/s9GZ97xjyWpuFBiyHEnGo=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-571-fZMcsJh-NHCIN1dws4EyYQ-1; Mon, 20 Feb 2023 21:38:17 -0500
X-MC-Unique: fZMcsJh-NHCIN1dws4EyYQ-1
Received: by mail-pg1-f199.google.com with SMTP id o38-20020a635d66000000b004fbec68e875so843040pgm.1
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 18:38:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O1eETGbsNJ3o4GhZE8orvsa9aWlXBtgkGSwcd3OHgbs=;
        b=fbkC1pZeS57D22bcXiX1Cwn4tSxYjyjtUmIBE9kFtWtUxfvi7X9Qv2oekvmXWMy/HV
         EtifrILKn4YkbcH9m/SmPGD5+D+Qpf5/9gMJfwPfxxc1QKwV3HUhWtz2oeB6QER0w3+V
         7ZYPW8T92XHXdsRMNGDVHogLVUAeiRmavIJIEvfmd09MVpcdw3wE0OM5jrY9sMXyHWzz
         MB30pLSYv8IXfY2CtsZXJ3QCXfwdJK3dVQ4vxsDHFEn5XXvNpeKovDwGzGmv49cebCLG
         uGfH+LfvdVS/w36S0M3fnh069AQ47D19Q6IuNjXKiXl9Rp2QGPgDBwJSOMpgaRSe5/Sz
         hw8Q==
X-Gm-Message-State: AO0yUKVpLu9O1w3K7jMZeFY2lcW5GjkvTd5Xam83+NfYu1JR/DHOLJc+
        b9v1QivvNjKMbt1+BURdBDZCOlYUdrKSRuMw+AUxK9SzBKOQKvgsynq683fvE9SvjPR7y0RkK8l
        BZbJJSnA8gx14rpio
X-Received: by 2002:a05:6a20:3ca0:b0:be:e0c3:5012 with SMTP id b32-20020a056a203ca000b000bee0c35012mr2696229pzj.1.1676947096339;
        Mon, 20 Feb 2023 18:38:16 -0800 (PST)
X-Google-Smtp-Source: AK7set/720MKakE5XCGQ7Uh5rmW8ucJCIgp1rd9sNEeFmTZV4diZNLLhb5dWRXWL+38RQ13GmZ68VA==
X-Received: by 2002:a05:6a20:3ca0:b0:be:e0c3:5012 with SMTP id b32-20020a056a203ca000b000bee0c35012mr2696208pzj.1.1676947095997;
        Mon, 20 Feb 2023 18:38:15 -0800 (PST)
Received: from [10.72.13.11] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i26-20020aa78b5a000000b005a8e9e2f1c5sm845882pfd.187.2023.02.20.18.38.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 18:38:15 -0800 (PST)
Message-ID: <cc14248c-cd6c-d604-003c-7384363dab8e@redhat.com>
Date:   Tue, 21 Feb 2023 10:38:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [patch net-next] net: virtio_net: implement exact header length
 guest feature
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        virtualization@lists.linux-foundation.org,
        Vitaly Mireyno <vmireyno@marvell.com>
References: <20230217121547.3958716-1-jiri@resnulli.us>
 <20230217072032-mutt-send-email-mst@kernel.org> <Y+94418p73aUQyIn@nanopsycho>
 <20230217083915-mutt-send-email-mst@kernel.org> <Y/MwtAGru3yAY7r3@nanopsycho>
 <20230220074947-mutt-send-email-mst@kernel.org> <Y/N7+IJ+gzvP0IEf@nanopsycho>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <Y/N7+IJ+gzvP0IEf@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/2/20 21:56, Jiri Pirko 写道:
> Mon, Feb 20, 2023 at 01:55:33PM CET, mst@redhat.com wrote:
>> On Mon, Feb 20, 2023 at 09:35:00AM +0100, Jiri Pirko wrote:
>>> Fri, Feb 17, 2023 at 02:47:36PM CET, mst@redhat.com wrote:
>>>> On Fri, Feb 17, 2023 at 01:53:55PM +0100, Jiri Pirko wrote:
>>>>> Fri, Feb 17, 2023 at 01:22:01PM CET, mst@redhat.com wrote:
>>>>>> On Fri, Feb 17, 2023 at 01:15:47PM +0100, Jiri Pirko wrote:
>>>>>>> From: Jiri Pirko <jiri@nvidia.com>
>>>>>>>
>>>>>>> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
>>>>>>>
>>>>>>> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
>>>>>>> set implicates that the driver provides the exact size of the header.
>>>>>>>
>>>>>>> The driver already complies to fill the correct value. Introduce the
>>>>>>> feature and advertise it.
>>>>>>>
>>>>>>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>>>>>> Could you add a bit of motivation just for the record?
>>>>>> Does this improve performance for some card? By how much?
>>>>>> Expected to help some future card?
>>>>> I can get that info, but isn't that rather something to be appended to
>>>>> the virtio-spec patch? I mean, the feature is there, this is just
>>>>> implementing it in one driver.
>>>> It is more like using it in the driver.  It's not like we have to use
>>>> everything - it could be useful for e.g. dpdk but not linux.
>>>> Implementing it in the Linux driver has support costs - for example what
>>>> if there's a bug and sometimes the length is incorrect?
>>>> We'll be breaking things.
>>> I understand. To my understanding this feature just fixes the original
>>> ambiguity in the virtio spec.
>>>
>>> Quoting the original virtio spec:
>>> "hdr_len is a hint to the device as to how much of the header needs to
>>>   be kept to copy into each packet"
>>>
>>> "a hint" might not be clear for the reader what does it mean, if it is
>>> "maybe like that" of "exactly like that". This feature just makes it
>>> crystal clear.
>>>
>>> If you look at the tap implementation, it uses hdr_len to alloc
>>> skb linear part. No hint, it counts with the provided value.
>>> So if the driver is currently not precise, it breaks tap.
>> Well that's only for gso though right?
> Yep.
>
>
>> And making it bigger than necessary works fine ...
> Well yeah. But tap does not do that, does it? it uses hdr_len directly.


tap_get_user() limit the head length:


static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
                             struct iov_iter *from, int noblock)
{
     int good_linear = SKB_MAX_HEAD(TAP_RESERVE);
...


>
>
>>> I will add this to the patch description and send v2.
>>>
>> I feel this does not answer the question yet, or maybe I am being dense.
>> My point was not about making hdr_len precise.  My point was that we are
>> making a change here for no apparent reason. I am guessing you are not
>> doing it for fun - so why? Is there a device with this feature bit
>> you are aware of?
> Afaik real hw which does emulation of virtio_net would benefit from
> that, our hw including.


Note that driver can choose to no negotiate this feature, so malicious 
drivers can still try to use illegal value.

Thanks


>
>
>>
>>
>>>> The patch was submitted by Marvell but they never bothered with
>>>> using it in Linux. I guess they are using it for something else?
>>>> CC Vitaly who put this in.
>>>>
>>>>>> thanks!
>>>>>>
>>>>>>
>>>>>>> ---
>>>>>>>   drivers/net/virtio_net.c        | 6 ++++--
>>>>>>>   include/uapi/linux/virtio_net.h | 1 +
>>>>>>>   2 files changed, 5 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>>>>> index fb5e68ed3ec2..e85b03988733 100644
>>>>>>> --- a/drivers/net/virtio_net.c
>>>>>>> +++ b/drivers/net/virtio_net.c
>>>>>>> @@ -62,7 +62,8 @@ static const unsigned long guest_offloads[] = {
>>>>>>>   	VIRTIO_NET_F_GUEST_UFO,
>>>>>>>   	VIRTIO_NET_F_GUEST_CSUM,
>>>>>>>   	VIRTIO_NET_F_GUEST_USO4,
>>>>>>> -	VIRTIO_NET_F_GUEST_USO6
>>>>>>> +	VIRTIO_NET_F_GUEST_USO6,
>>>>>>> +	VIRTIO_NET_F_GUEST_HDRLEN
>>>>>>>   };
>>>>>>>   
>>>>>>>   #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
>>>>>>> @@ -4213,7 +4214,8 @@ static struct virtio_device_id id_table[] = {
>>>>>>>   	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>>>>>>>   	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>>>>>>>   	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
>>>>>>> -	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
>>>>>>> +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL, \
>>>>>>> +	VIRTIO_NET_F_GUEST_HDRLEN
>>>>>>>   
>>>>>>>   static unsigned int features[] = {
>>>>>>>   	VIRTNET_FEATURES,
>>>>>>> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
>>>>>>> index b4062bed186a..12c1c9699935 100644
>>>>>>> --- a/include/uapi/linux/virtio_net.h
>>>>>>> +++ b/include/uapi/linux/virtio_net.h
>>>>>>> @@ -61,6 +61,7 @@
>>>>>>>   #define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
>>>>>>>   #define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
>>>>>>>   #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
>>>>>>> +#define VIRTIO_NET_F_GUEST_HDRLEN  59	/* Guest provides the exact hdr_len value. */
>>>>>>>   #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
>>>>>>>   #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
>>>>>>>   #define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another device
>>>>>>> -- 
>>>>>>> 2.39.0

