Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9AEA620A31
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 08:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiKHHco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 02:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiKHHco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 02:32:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09E7165B8
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 23:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667892713;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qMzkFr5wWO2ErYRr9fFrSjmX0hB7P0RxUcl1SJ2pD3Q=;
        b=hebxVy/KhHdnXgDhVAKHR/AwFitjqfYw7obvWhb8PBtX232/48DxWz8fLQxKO/d20pMHxv
        3niROHu4fyK6aUqAPBo8ZmREu9yHynMbZBY0rKqwDAp1BHk7bvmeSrBEWb4JuQJHndj3kW
        8s6CCZqAEJGKuNpk+2g2nNTScdOV8AU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-616-lnD-nxO0MGmt4eVZlv9lQw-1; Tue, 08 Nov 2022 02:31:51 -0500
X-MC-Unique: lnD-nxO0MGmt4eVZlv9lQw-1
Received: by mail-wm1-f70.google.com with SMTP id i82-20020a1c3b55000000b003cf9bd60855so2364367wma.6
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 23:31:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qMzkFr5wWO2ErYRr9fFrSjmX0hB7P0RxUcl1SJ2pD3Q=;
        b=WPiAXTkFxvsd0pS4XLAFDpucvB8YxvfXdJ75ttxQOpubre66q1Je4THUbZm2nOhmm1
         6veZ1Wh6EQud7+Z7HdI0rMiSJ3JvwTdaiTteLcItFCnijoYpT1vC4hLaLepiCWLxlyQ3
         mGHyzSVYtB1oZqItBnxBZrJleYVjLZcemD5e7jxuXtKSZcEf2S8dwHW7idUBFvwxFXUK
         50QLp0Dl98tLESrFrH1GwGm25BuDRxBYq4GFkWdztMI6MuzNYrIMGmB5YW8QM6X17tnU
         fh9XHLJK28Gk5pf6E8d2fiFynApgCeP10h4n2u6Yd2kOYVBikmdN2IxDRdsi+ELRa93+
         q4BA==
X-Gm-Message-State: ANoB5pnh3+p26Kn7ZtSvRJz0vHBUZIavpqI6BFLz6D/E+W8zhvljbyWc
        culXrzxD2ChcktdvVJk4KeXJVKCE0zsnPOlbpMJ/4eMB7nHp+NDDbvURZlx3iUk9F1W8NIZWO7R
        BM/ck+yBoeN0essEm
X-Received: by 2002:a1c:a1c4:0:b0:3cf:a616:cc8d with SMTP id k187-20020a1ca1c4000000b003cfa616cc8dmr8088680wme.62.1667892710086;
        Mon, 07 Nov 2022 23:31:50 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5uIx7UmC0fECL2xHHWwwpOMztkaHKJt1L2WyCKzX01NL2l1JGJEX5qifjLTMybc5+Tr12N5A==
X-Received: by 2002:a1c:a1c4:0:b0:3cf:a616:cc8d with SMTP id k187-20020a1ca1c4000000b003cfa616cc8dmr8088667wme.62.1667892709861;
        Mon, 07 Nov 2022 23:31:49 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id p4-20020a05600c1d8400b003b497138093sm10405740wms.47.2022.11.07.23.31.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 23:31:49 -0800 (PST)
Message-ID: <c9c0ca0d-d100-c789-dbb8-b308652695e7@redhat.com>
Date:   Tue, 8 Nov 2022 08:31:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC] vhost: Clear the pending messages on
 vhost_init_device_iotlb()
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterx@redhat.com
References: <20221107203431.368306-1-eric.auger@redhat.com>
 <20221107153924-mutt-send-email-mst@kernel.org>
 <b8487793-d7b8-0557-a4c2-b62754e14830@redhat.com>
 <20221107180022-mutt-send-email-mst@kernel.org>
 <CACGkMEsYyH5P2h6XkBgrW4O-xJXxdzzRa1+T2zjJ07OHiYObVA@mail.gmail.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CACGkMEsYyH5P2h6XkBgrW4O-xJXxdzzRa1+T2zjJ07OHiYObVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/8/22 04:09, Jason Wang wrote:
> On Tue, Nov 8, 2022 at 7:06 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>> On Mon, Nov 07, 2022 at 10:10:06PM +0100, Eric Auger wrote:
>>> Hi Michael,
>>> On 11/7/22 21:42, Michael S. Tsirkin wrote:
>>>> On Mon, Nov 07, 2022 at 09:34:31PM +0100, Eric Auger wrote:
>>>>> When the vhost iotlb is used along with a guest virtual iommu
>>>>> and the guest gets rebooted, some MISS messages may have been
>>>>> recorded just before the reboot and spuriously executed by
>>>>> the virtual iommu after the reboot. Despite the device iotlb gets
>>>>> re-initialized, the messages are not cleared. Fix that by calling
>>>>> vhost_clear_msg() at the end of vhost_init_device_iotlb().
>>>>>
>>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>> ---
>>>>>  drivers/vhost/vhost.c | 1 +
>>>>>  1 file changed, 1 insertion(+)
>>>>>
>>>>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>>>>> index 40097826cff0..422a1fdee0ca 100644
>>>>> --- a/drivers/vhost/vhost.c
>>>>> +++ b/drivers/vhost/vhost.c
>>>>> @@ -1751,6 +1751,7 @@ int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled)
>>>>>    }
>>>>>
>>>>>    vhost_iotlb_free(oiotlb);
>>>>> +  vhost_clear_msg(d);
>>>>>
>>>>>    return 0;
>>>>>  }
>>>> Hmm.  Can't messages meanwhile get processes and affect the
>>>> new iotlb?
>>> Isn't the msg processing stopped at the moment this function is called
>>> (VHOST_SET_FEATURES)?
>>>
>>> Thanks
>>>
>>> Eric
>> It's pretty late here I'm not sure.  You tell me what prevents it.
> So the proposed code assumes that Qemu doesn't process device IOTLB
> before VHOST_SET_FEAETURES. Consider there's no reset in the general
> vhost uAPI,  I wonder if it's better to move the clear to device code
> like VHOST_NET_SET_BACKEND. So we can clear it per vq?

OK I will look at this alternative
>
>> BTW vhost_init_device_iotlb gets enabled parameter but ignores
>> it, we really should drop that.
> Yes.
Yes I saw that too. I will send a patch.
>
>> Also, it looks like if features are set with VIRTIO_F_ACCESS_PLATFORM
>> and then cleared, iotlb is not properly cleared - bug?
> Not sure, old IOTLB may still work. But for safety, we need to disable
> device IOTLB in this case.
OK

Thanks

Eric
>
> Thanks
>
>>
>>>>
>>>>> --
>>>>> 2.37.3

