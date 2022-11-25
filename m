Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E79F638D72
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 16:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiKYPab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 10:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKYPaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 10:30:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044F325E8A
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669390175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m1BChkWM80kgyYM0SCDcwv+2ZPer/HomIwTgropL0ac=;
        b=UD1zdeXXbKFNTy/j3j7doEZ5Msw4/MWHh1FKraO8zrE7ORcWdWw8jUTdExdFYskM99BgCa
        AHRdIdiRYOh9XBKJKBh1781EhMb7dOQvBIkDOYYzB6hHpAl7vwc71Kd4hoIDbwDZOx9xLj
        DvpGGHUXCOmmfrKarsSH4/degN8EWJk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-213-auJMlzNqM9GX3SbH5PeicQ-1; Fri, 25 Nov 2022 10:29:33 -0500
X-MC-Unique: auJMlzNqM9GX3SbH5PeicQ-1
Received: by mail-qk1-f199.google.com with SMTP id y22-20020a05620a25d600b006fc49e06062so4226504qko.4
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:29:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m1BChkWM80kgyYM0SCDcwv+2ZPer/HomIwTgropL0ac=;
        b=NRrpfJJL1U3w/ZMMcvbrGlH4Jh28k0J0sr/Xl4UdCPDCihzOV6wec/hyU+qswhZKpF
         R+pA75rPqYPc38EZy+/xrNxkwmwnCfVW3idGTkSLbcIs1eoidMJDjhQWVqtz8pXMc0GN
         5N3l8BHyC9iFhCcO6Pd2CrnPdIBsYZCCOO+G7Ms7aeYQb5hqEsMuGHaBZeJJcbov2IwK
         kec1iWEnrUrs4W+YrVfGOrpmsNEaBd0XwDhsFa4YBedkrVAcE6soCasm+dCz6upJCech
         qXJOZKfd+NRRZIBVnU9NAZuBWK5Y2CD0/hL4snl7McY/BriUzQE/umqy/+3tF7EtnsqJ
         8EVw==
X-Gm-Message-State: ANoB5pnizg97nocoHtPsA8QNtfNfM5nUIUmsdNj2M/qwRIHIGmCAAAcj
        zMN0hUAZ23FhFqhR2aRLfx6d1FMnXvAltp3AR8Wg43XXOyXRdz12fvvhkEbDuiWNSUhgo6do0zj
        m5SiQcHkgFCWVjamk
X-Received: by 2002:a37:8e05:0:b0:6fc:53ae:a979 with SMTP id q5-20020a378e05000000b006fc53aea979mr3317497qkd.735.1669390173395;
        Fri, 25 Nov 2022 07:29:33 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7QqsBor66MxTzYPMb3it/9mbW0UcvGZ8swgbJR9AuZEedlRi01xoZpxj56zdIsD6rMTkp1UQ==
X-Received: by 2002:a37:8e05:0:b0:6fc:53ae:a979 with SMTP id q5-20020a378e05000000b006fc53aea979mr3317469qkd.735.1669390173123;
        Fri, 25 Nov 2022 07:29:33 -0800 (PST)
Received: from [192.168.0.146] ([139.47.72.25])
        by smtp.gmail.com with ESMTPSA id u12-20020a05620a430c00b006fa4cac54a5sm2932849qko.72.2022.11.25.07.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 07:29:32 -0800 (PST)
Message-ID: <83a0b3e4-1327-c1c4-4eb4-9a25ff533d1d@redhat.com>
Date:   Fri, 25 Nov 2022 16:29:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [ovs-dev] [RFC net-next 1/6] openvswitch: exclude kernel flow key
 from upcalls
Content-Language: en-US
To:     Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>, netdev@vger.kernel.org
Cc:     dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kselftest@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20221122140307.705112-1-aconole@redhat.com>
 <20221122140307.705112-2-aconole@redhat.com>
 <c04242ee-f125-6d95-e263-65470222d3cf@ovn.org>
From:   Adrian Moreno <amorenoz@redhat.com>
In-Reply-To: <c04242ee-f125-6d95-e263-65470222d3cf@ovn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/23/22 22:22, Ilya Maximets wrote:
> On 11/22/22 15:03, Aaron Conole wrote:
>> When processing upcall commands, two groups of data are available to
>> userspace for processing: the actual packet data and the kernel
>> sw flow key data.  The inclusion of the flow key allows the userspace
>> avoid running through the dissection again.
>>
>> However, the userspace can choose to ignore the flow key data, as is
>> the case in some ovs-vswitchd upcall processing.  For these messages,
>> having the flow key data merely adds additional data to the upcall
>> pipeline without any actual gain.  Userspace simply throws the data
>> away anyway.
> 
> Hi, Aaron.  While it's true that OVS in userpsace is re-parsing the
> packet from scratch and using the newly parsed key for the OpenFlow
> translation, the kernel-porvided key is still used in a few important
> places.  Mainly for the compatibility checking.  The use is described
> here in more details:
>    https://docs.kernel.org/networking/openvswitch.html#flow-key-compatibility
> 
> We need to compare the key generated in userspace with the key
> generated by the kernel to know if it's safe to install the new flow
> to the kernel, i.e. if the kernel and OVS userpsace are parsing the
> packet in the same way.
> 

Hi Ilya,

Do we need to do that for every packet?
Could we send a bitmask of supported fields to userspace at feature negotiation 
and let OVS slowpath flows that it knows the kernel won't be able to handle 
properly?


> On the other hand, OVS today doesn't check the data, it only checks
> which fields are present.  So, if we can generate and pass the bitmap
> of fields present in the key or something similar without sending the
> full key, that might still save some CPU cycles and memory in the
> socket buffer while preserving the ability to check for forward and
> backward compatibility.  What do you think?
> 
> 
> The rest of the patch set seems useful even without patch #1 though.
> 
> Nit: This patch #1 should probably be merged with the patch #6 and be
> at the end of a patch set, so the selftest and the main code are updated
> at the same time.
> 
> Best regards, Ilya Maximets.
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
> 

Thanks
-- 
Adrián Moreno

