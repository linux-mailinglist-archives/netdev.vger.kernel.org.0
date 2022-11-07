Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9296C6200B3
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 22:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiKGVO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 16:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbiKGVOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 16:14:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF58317C2
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 13:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667855411;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S5uHAm/YMaHSV2rOFAm9u7M75Iy7HbODE/InmExnaAE=;
        b=PRoAuTx6ivBM4dcWT6Elj0ieI/8F8YyTwMWEJ3LnJZXLzoHLilPpFpSqQW7iCqCcI6zJDs
        DvNmuybthNlfj/odrOmdZ8rF8T7JkqRplyI6n8EmxMiWFQH6sEn7eG9b2URvM6p11D6FM1
        XCXbdswLzKgROtHhyp4LFA0O1Yq0VjE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-14-7-I0NwSsNMSZTMfeMTLr-A-1; Mon, 07 Nov 2022 16:10:09 -0500
X-MC-Unique: 7-I0NwSsNMSZTMfeMTLr-A-1
Received: by mail-wm1-f71.google.com with SMTP id s7-20020a1cf207000000b003cf56bad2e2so3441242wmc.9
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 13:10:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S5uHAm/YMaHSV2rOFAm9u7M75Iy7HbODE/InmExnaAE=;
        b=Hf5bNOgP3f7MN1c5TkJb4zAIoY559Gbkhvytqszj7BCIQ7Kp38qvnR2LodVo36abdt
         ZWVUo5PnMbD14tgbWOMhRfpdsmSuILbPLcLVHhvO33z+DkAk3Y4QB5YE9LWxgfN50tTT
         gK5b8jHmwkaFWhYFHMq6vzl/ZYhuGWG/3q1cMdqm6WEMiaJuePkhtXCYI8HrRfkPbJjR
         APcAnwEVwHJ/tJJj1nQlL4yrbE1y1BXn6Vco4cu4svYZ1FzpokmpKOK9PZg5V9hAMW1N
         oPaLFSkIrCkpr4StKFaGCm8BhxkE+D5RkHB4EO/KRBp4FIgrL6j3offa7sZ6BO+wnn+9
         nThg==
X-Gm-Message-State: ACrzQf07eCrwxMpsHdy6fJmfNLxXQQpaihQiHto0RqDpAr6wZv5dgR6c
        5Qjcjwt93oaivQGGP9f9/7vqcd6KfjS4bk273/31HKgPnHXEmkvIKrDtBtxx2flBQfz22i9Etpi
        Im+5DbxIY5SgOhApv
X-Received: by 2002:a5d:4b45:0:b0:236:501f:7a41 with SMTP id w5-20020a5d4b45000000b00236501f7a41mr33248888wrs.516.1667855408511;
        Mon, 07 Nov 2022 13:10:08 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7OiDI4F9MI4Y77S9G7vRAA8ji/J8GVqtN7aNFdugsfuItxHBGzX5veSqv7kZTArZsQcUceGA==
X-Received: by 2002:a5d:4b45:0:b0:236:501f:7a41 with SMTP id w5-20020a5d4b45000000b00236501f7a41mr33248873wrs.516.1667855408285;
        Mon, 07 Nov 2022 13:10:08 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id i5-20020adffc05000000b0023660f6cecfsm8312230wrr.80.2022.11.07.13.10.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 13:10:07 -0800 (PST)
Message-ID: <b8487793-d7b8-0557-a4c2-b62754e14830@redhat.com>
Date:   Mon, 7 Nov 2022 22:10:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC] vhost: Clear the pending messages on
 vhost_init_device_iotlb()
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     eric.auger.pro@gmail.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterx@redhat.com
References: <20221107203431.368306-1-eric.auger@redhat.com>
 <20221107153924-mutt-send-email-mst@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20221107153924-mutt-send-email-mst@kernel.org>
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

Hi Michael,
On 11/7/22 21:42, Michael S. Tsirkin wrote:
> On Mon, Nov 07, 2022 at 09:34:31PM +0100, Eric Auger wrote:
>> When the vhost iotlb is used along with a guest virtual iommu
>> and the guest gets rebooted, some MISS messages may have been
>> recorded just before the reboot and spuriously executed by
>> the virtual iommu after the reboot. Despite the device iotlb gets
>> re-initialized, the messages are not cleared. Fix that by calling
>> vhost_clear_msg() at the end of vhost_init_device_iotlb().
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  drivers/vhost/vhost.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 40097826cff0..422a1fdee0ca 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -1751,6 +1751,7 @@ int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled)
>>  	}
>>  
>>  	vhost_iotlb_free(oiotlb);
>> +	vhost_clear_msg(d);
>>  
>>  	return 0;
>>  }
> Hmm.  Can't messages meanwhile get processes and affect the
> new iotlb?
Isn't the msg processing stopped at the moment this function is called
(VHOST_SET_FEATURES)?

Thanks

Eric
>
>
>> -- 
>> 2.37.3

