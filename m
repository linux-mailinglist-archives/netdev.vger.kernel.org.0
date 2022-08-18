Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994D5597CDB
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 06:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240486AbiHREPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 00:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239411AbiHREPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 00:15:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330A150041
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 21:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660796152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=90ff8sjY+m9HsEs6i8v1jPNF4u6ADKMljn/DWnOc7tg=;
        b=LKGSUtnbvaUkUh+WaBMKzrrtp0xuqT+4WZ8az09iMzrtboJ0vDzDQIS7zf6lbh+AB44A3K
        yvlVVd9czWwFoFJpsK6+sGvKzwjGDrniW4Ma430kEmbzKXpdR7f53TPcvHz103sS2plBOz
        kLjCT76AC2PgEWvJLns0RjNk5alWGB4=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-231-gtm5r18aPOiiAE5utWgi_w-1; Thu, 18 Aug 2022 00:15:50 -0400
X-MC-Unique: gtm5r18aPOiiAE5utWgi_w-1
Received: by mail-pf1-f200.google.com with SMTP id a19-20020aa780d3000000b0052bccd363f8so300776pfn.22
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 21:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=90ff8sjY+m9HsEs6i8v1jPNF4u6ADKMljn/DWnOc7tg=;
        b=m3TltwfhxPpVNaAxEs4Cd+jZy1dFXY9Vrx63J48Y1id51DbALvdOaLwKoq/X56HD8F
         Nc7KxIkckfBV1aXxTONF9gJ33DS0f0vA5WyDYT6vWMLeI6x54PlURSO3nKYUu9cXYJoh
         4+UcNE+nu6Bc3ptb1bOOkPRFtX2Dc2o1jNwDjJ9/Zla99SEGsmcMCqc5srIJYj6/1tsQ
         DZGabi8GUCvn8VcwRC9oDNsKjsouFxHdDxPkVVw5RaAi4GpAzHkw4J60bMFYYfTbsFGi
         /s/OgF9tdmZO8123tCarXtzZAqmThrvNrZY/l646I+pJhRllMljoQc4pv7EfMe2kIrka
         HJ6Q==
X-Gm-Message-State: ACgBeo1mUoPW+MQxIaDjuPfNexW25mXBAggIJvNGYmp7MrGNsB/5CE7o
        /GlgVa5bpuXxujKbIFKWanR3Azu6QuPqwbcer/Ll/EREkpGJhJl5UK48kmObQ1Mkh0Jm+0DnIDO
        DuNKitB9YRM7Zg4PN
X-Received: by 2002:a62:4c2:0:b0:52e:bd4d:50e1 with SMTP id 185-20020a6204c2000000b0052ebd4d50e1mr1296680pfe.8.1660796149647;
        Wed, 17 Aug 2022 21:15:49 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7t4FbXeSRyLqR6Fb1Pn3xF/TW5GpOgcSkBjfKmVbsWkrQCgDysCjqSzTKPrOnCKYR30QQCMQ==
X-Received: by 2002:a62:4c2:0:b0:52e:bd4d:50e1 with SMTP id 185-20020a6204c2000000b0052ebd4d50e1mr1296667pfe.8.1660796149336;
        Wed, 17 Aug 2022 21:15:49 -0700 (PDT)
Received: from [10.72.13.223] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c127-20020a621c85000000b005289ef6db79sm376729pfc.32.2022.08.17.21.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 21:15:48 -0700 (PDT)
Message-ID: <54aa5a5c-69e2-d372-3e0c-b87f595d213c@redhat.com>
Date:   Thu, 18 Aug 2022 12:15:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
References: <c5075d3d-9d2c-2716-1cbf-cede49e2d66f@oracle.com>
 <20e92551-a639-ec13-3d9c-13bb215422e1@intel.com>
 <9b6292f3-9bd5-ecd8-5e42-cd5d12f036e7@oracle.com>
 <22e0236f-b556-c6a8-0043-b39b02928fd6@intel.com>
 <892b39d6-85f8-bff5-030d-e21288975572@oracle.com>
 <52a47bc7-bf26-b8f9-257f-7dc5cea66d23@intel.com>
 <20220817045406-mutt-send-email-mst@kernel.org>
 <a91fa479-d1cc-a2d6-0821-93386069a2c1@intel.com>
 <20220817053821-mutt-send-email-mst@kernel.org>
 <449c2fb2-3920-7bf9-8c5c-a68456dfea76@intel.com>
 <20220817063450-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220817063450-mutt-send-email-mst@kernel.org>
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


在 2022/8/17 18:37, Michael S. Tsirkin 写道:
> On Wed, Aug 17, 2022 at 05:43:22PM +0800, Zhu, Lingshan wrote:
>>
>> On 8/17/2022 5:39 PM, Michael S. Tsirkin wrote:
>>> On Wed, Aug 17, 2022 at 05:13:59PM +0800, Zhu, Lingshan wrote:
>>>> On 8/17/2022 4:55 PM, Michael S. Tsirkin wrote:
>>>>> On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan wrote:
>>>>>> Yes it is a little messy, and we can not check _F_VERSION_1 because of
>>>>>> transitional devices, so maybe this is the best we can do for now
>>>>> I think vhost generally needs an API to declare config space endian-ness
>>>>> to kernel. vdpa can reuse that too then.
>>>> Yes, I remember you have mentioned some IOCTL to set the endian-ness,
>>>> for vDPA, I think only the vendor driver knows the endian,
>>>> so we may need a new function vdpa_ops->get_endian().
>>>> In the last thread, we say maybe it's better to add a comment for now.
>>>> But if you think we should add a vdpa_ops->get_endian(), I can work
>>>> on it for sure!
>>>>
>>>> Thanks
>>>> Zhu Lingshan
>>> I think QEMU has to set endian-ness. No one else knows.
>> Yes, for SW based vhost it is true. But for HW vDPA, only
>> the device & driver knows the endian, I think we can not
>> "set" a hardware's endian.
> QEMU knows the guest endian-ness and it knows that
> device is accessed through the legacy interface.
> It can accordingly send endian-ness to the kernel and
> kernel can propagate it to the driver.


I wonder if we can simply force LE and then Qemu can do the endian 
conversion?

Thanks


>
>> So if you think we should add a vdpa_ops->get_endian(),
>> I will drop these comments in the next version of
>> series, and work on a new patch for get_endian().
>>
>> Thanks,
>> Zhu Lingshan
> Guests don't get endian-ness from devices so this seems pointless.
>

