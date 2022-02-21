Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9421A4BD761
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 08:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345779AbiBUHA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 02:00:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345757AbiBUHAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 02:00:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BEB3BAF
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 23:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645426827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vSm8KOrS6kS8NyCwUABzD6TbHfkGQCSFiSd91tlc1bI=;
        b=XcQfDFVvrbr9+RL50j+DnPCDtztfVqayNxFh6wdrFlYqlAa1OKQ4AXKkVkEa81lRoQDngJ
        TYF1Duku/rmXYbGiSgjUvi2EqRFXKBPiixQRVg9qmgJ4T9VlSoaEmVfWbmkN41QGuz5/WD
        UwJutpdHNE4sIPLlSxM1q3uDozruvaA=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-i2UTHHm-P8OEMMxbOsHWUA-1; Mon, 21 Feb 2022 02:00:24 -0500
X-MC-Unique: i2UTHHm-P8OEMMxbOsHWUA-1
Received: by mail-pj1-f72.google.com with SMTP id e4-20020a17090a630400b001bbdea72a9bso3506320pjj.8
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 23:00:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=vSm8KOrS6kS8NyCwUABzD6TbHfkGQCSFiSd91tlc1bI=;
        b=X3b0NdYOsb1ibDvR4D3xjco9dxNVB1V9rFI48DOlF6goe6ZG5y47sj4C2SNeSslsau
         gEwy5WkSku2ZBCXxqZlYQcR9XTpmBQ+gJSiXPbQoX/f7m377jEqKRSMH+9JiI2RMI/nT
         kukmfSbAQaeUjn/VJz+8D+gqGF/UMi+C8q2wyNu3fzDJmvshcEwYv0NAmKElwl5l+7lF
         53lZz7b6pfMnSLzJKg0+A0mn/AVC/CfRpu/RYN3fmMIzRy9XqapwnECTi0vYYWi1C+iR
         oySNndcxAwTQxMvIlw/e8Z05+dxwru5nqFw8yvxlD9CHaX43oExv4FHYo+0yS9JeHcQh
         RqIg==
X-Gm-Message-State: AOAM530i31yoamxjACWFK6qwQ44/ISNqJ17wBneV6BRtta7DFC04bvKS
        jlRcG5D1S+02l+kR8EOeYMg9i5YE8P4Od2R4I07aHn9fyFrg2ZSK/ipxpVhackcu9vz1gh1JkfL
        d/+T702M51r7RI5Dz
X-Received: by 2002:a63:704a:0:b0:373:a701:3725 with SMTP id a10-20020a63704a000000b00373a7013725mr14766706pgn.101.1645426823793;
        Sun, 20 Feb 2022 23:00:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxOCsOnJpfCs2Ur27qkG8aelxMfqGd8HXrf0XQLIXFa2I9GNA2KGgrTJIAy9veH8bCg/ZRDxQ==
X-Received: by 2002:a63:704a:0:b0:373:a701:3725 with SMTP id a10-20020a63704a000000b00373a7013725mr14766686pgn.101.1645426823494;
        Sun, 20 Feb 2022 23:00:23 -0800 (PST)
Received: from [10.72.12.96] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f16sm11737293pfe.52.2022.02.20.23.00.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Feb 2022 23:00:23 -0800 (PST)
Message-ID: <d8011051-dc45-85f6-3630-4ba0cf6179b2@redhat.com>
Date:   Mon, 21 Feb 2022 15:00:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v5 20/22] virtio_net: set the default max ring num
Content-Language: en-US
From:   Jason Wang <jasowang@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
References: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com>
 <20220214081416.117695-21-xuanzhuo@linux.alibaba.com>
 <CACGkMEvZvhSb0veCynEHN3EfFu_FwbCAb8w1b0Oi3LDc=ffNaw@mail.gmail.com>
 <1644997568.827981-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEt_AEw2Jh9VzkGQ2A8f8Y0nuuFxr193_vnkFpc=JyD2Sg@mail.gmail.com>
 <1645090228.2917905-1-xuanzhuo@linux.alibaba.com>
 <2a7acc5a-2c4d-2176-efd6-2aa828833587@redhat.com>
In-Reply-To: <2a7acc5a-2c4d-2176-efd6-2aa828833587@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/2/21 上午11:40, Jason Wang 写道:
>
> 在 2022/2/17 下午5:30, Xuan Zhuo 写道:
>> On Thu, 17 Feb 2022 15:21:26 +0800, Jason Wang <jasowang@redhat.com> 
>> wrote:
>>> On Wed, Feb 16, 2022 at 3:52 PM Xuan Zhuo 
>>> <xuanzhuo@linux.alibaba.com> wrote:
>>>> On Wed, 16 Feb 2022 12:14:31 +0800, Jason Wang 
>>>> <jasowang@redhat.com> wrote:
>>>>> On Mon, Feb 14, 2022 at 4:14 PM Xuan Zhuo 
>>>>> <xuanzhuo@linux.alibaba.com> wrote:
>>>>>> Sets the default maximum ring num based on 
>>>>>> virtio_set_max_ring_num().
>>>>>>
>>>>>> The default maximum ring num is 1024.
>>>>> Having a default value is pretty useful, I see 32K is used by 
>>>>> default for IFCVF.
>>>>>
>>>>> Rethink this, how about having a different default value based on 
>>>>> the speed?
>>>>>
>>>>> Without SPEED_DUPLEX, we use 1024. Otherwise
>>>>>
>>>>> 10g 4096
>>>>> 40g 8192
>>>> We can define different default values of tx and rx by the way. 
>>>> This way I can
>>>> just use it in the new interface of find_vqs().
>>>>
>>>> without SPEED_DUPLEX:  tx 512 rx 1024
>>>>
>>> Any reason that TX is smaller than RX?
>>>
>> I've seen some NIC drivers with default tx smaller than rx.
>
>
> Interesting, do they use combined channels?


Adding Ling Shan.

I see 32K is used for IFCVF by default, this is another call for the 
this patch:

# ethtool -g eth0
Ring parameters for eth0:
Pre-set maximums:
RX:        32768
RX Mini:    0
RX Jumbo:    0
TX:        32768
Current hardware settings:
RX:        32768
RX Mini:    0
RX Jumbo:    0
TX:        32768

Thanks


>
>
>>
>> One problem I have now is that inside virtnet_probe, init_vqs is 
>> before getting
>> speed/duplex. I'm not sure, can the logic to get speed/duplex be put 
>> before
>> init_vqs? Is there any risk?
>>
>> Can you help me?
>
>
> The feature has been negotiated during probe(), so I don't see any risk.
>
> Thanks
>
>
>>
>> Thanks.
>>
>>> Thanks
>>>
>>>> Thanks.
>>>>
>>>>
>>>>> etc.
>>>>>
>>>>> (The number are just copied from the 10g/40g default parameter from
>>>>> other vendors)
>>>>>
>>>>> Thanks
>>>>>
>>>>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>>>>> ---
>>>>>>   drivers/net/virtio_net.c | 4 ++++
>>>>>>   1 file changed, 4 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>>>> index a4ffd7cdf623..77e61fe0b2ce 100644
>>>>>> --- a/drivers/net/virtio_net.c
>>>>>> +++ b/drivers/net/virtio_net.c
>>>>>> @@ -35,6 +35,8 @@ module_param(napi_tx, bool, 0644);
>>>>>>   #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
>>>>>>   #define GOOD_COPY_LEN  128
>>>>>>
>>>>>> +#define VIRTNET_DEFAULT_MAX_RING_NUM 1024
>>>>>> +
>>>>>>   #define VIRTNET_RX_PAD (NET_IP_ALIGN + NET_SKB_PAD)
>>>>>>
>>>>>>   /* Amount of XDP headroom to prepend to packets for use by 
>>>>>> xdp_adjust_head */
>>>>>> @@ -3045,6 +3047,8 @@ static int virtnet_find_vqs(struct 
>>>>>> virtnet_info *vi)
>>>>>>                          ctx[rxq2vq(i)] = true;
>>>>>>          }
>>>>>>
>>>>>> +       virtio_set_max_ring_num(vi->vdev, 
>>>>>> VIRTNET_DEFAULT_MAX_RING_NUM);
>>>>>> +
>>>>>>          ret = virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, 
>>>>>> callbacks,
>>>>>>                                    names, ctx, NULL);
>>>>>>          if (ret)
>>>>>> -- 
>>>>>> 2.31.0
>>>>>>

