Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD91C609DC8
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiJXJSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiJXJRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:17:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3DB6CD1D
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666603036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K/RXTTzcVuB4RdpzBY2ycAwiDIJOL5W2bI6nipF+ZbY=;
        b=i4KJecf/kiKGAX4gIlv/tVXduWg8ZIhdS7Wfy0aeE3TKMzMR6Awlf6CpUbZH32vrcCtgAs
        FkRdJz5JJM8V2M6soZZYKWvPOrNmRS3EQo84p+7PaubdRxwqbzz657YQg78Vbm8DeAUs71
        upiIsWO2N3uZ1MEzFgl5+Q0ExiCOFkU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-665-946xW8K7OGqOnpp42AUz_Q-1; Mon, 24 Oct 2022 05:17:14 -0400
X-MC-Unique: 946xW8K7OGqOnpp42AUz_Q-1
Received: by mail-ed1-f71.google.com with SMTP id y14-20020a056402270e00b0045d1baf4951so9027701edd.11
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:17:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K/RXTTzcVuB4RdpzBY2ycAwiDIJOL5W2bI6nipF+ZbY=;
        b=q5NhhuLpSDTQvUXRqUoVi8bAqpNgR0xgCZf3sT6+B737xDeJTAE2/DWDauHPLM1/r7
         GqgdvgDaoh7ZvtHFMcuHk1HHz0a0Tm7zE75LXF+yzgoKWMoxX6Rd3neiKC45RmY9x8t+
         aZRQjM5TGKIbxzkcdha0wnx1/ZTlBMf0DtyDPWgvDpxfZdKQJg0yUbzOj1TQKXrzTlKX
         J3JvAG0el2MTvgvh1tupr8o12HUbG1XJ9/ZBeoDev1uEQjlor5nC8hjBQTfkt9KCrwXd
         dlu+7+cCDU91zY+SgIS9tEm7voOUb6w4TUFrFy9Yt44/vnVeEtWqveNa1jL/8jJgN686
         zXwQ==
X-Gm-Message-State: ACrzQf0+pxW0udAJJErscIE4elQ4+VOoK5CdcqM9ITiLI759hWa1kH3F
        KLkbN3iQilF96HuBDeTZSTajazsbKY4WgwQBwfJqOrhZRzJEgXYXA33/5k+JuEuIh9I6dNCpDoA
        HG2xe5eKY+cN2gPw+
X-Received: by 2002:a17:906:8a62:b0:78d:a05c:c37f with SMTP id hy2-20020a1709068a6200b0078da05cc37fmr26235695ejc.159.1666603032289;
        Mon, 24 Oct 2022 02:17:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4dbx7xxmx2TFtNq00OGSs3nAGgjLkEykBvEPyidT0PsslwhYNPY3IGA0nyQdT3JzcQRmlERw==
X-Received: by 2002:a17:906:8a62:b0:78d:a05c:c37f with SMTP id hy2-20020a1709068a6200b0078da05cc37fmr26235684ejc.159.1666603032137;
        Mon, 24 Oct 2022 02:17:12 -0700 (PDT)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id dv20-20020a170906b81400b0078ba492db81sm15376235ejb.9.2022.10.24.02.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 02:17:11 -0700 (PDT)
Message-ID: <e78222b2-947f-b922-a8a7-e04f6a1d868e@redhat.com>
Date:   Mon, 24 Oct 2022 11:17:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] net: wwan: iosm: initialize pc_wwan->if_mutex earlier
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org
References: <20221014093632.8487-1-hdegoede@redhat.com>
 <CAHNKnsSvvM3_JEdr1znAWTup-LG-A=cuO8h-A8G6Cwf=h_rjNQ@mail.gmail.com>
 <ea022df4-2baf-48ae-e5ed-85a6242a5774@redhat.com>
 <CAHNKnsSaNuU3xcnRpnP2CM8ycOqomaaeT9Tz40FLJbbKFXgTzw@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <CAHNKnsSaNuU3xcnRpnP2CM8ycOqomaaeT9Tz40FLJbbKFXgTzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 10/24/22 11:14, Sergey Ryazanov wrote:
> On Mon, Oct 24, 2022 at 12:04 PM Hans de Goede <hdegoede@redhat.com> wrote:
>> On 10/15/22 09:55, Sergey Ryazanov wrote:
>>> On Fri, Oct 14, 2022 at 1:36 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>>> wwan_register_ops() ends up calls ipc_wwan_newlink() before it returns.
>>>>
>>>> ipc_wwan_newlink() uses pc_wwan->if_mutex, so we must initialize it
>>>> before calling wwan_register_ops(). This fixes the following WARN()
>>>> when lock-debugging is enabled:
>>>>
>>>> [skipped]
>>>>
>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>
>>> Should we add a Fixes: tag for this change? Besides this:
>>
>> This issue was present already in the driver as originally introduced, so:
>>
>> Fixes: 2a54f2c77934 ("net: iosm: net driver")
>>
>> I guess?
> 
> The wwan_register_ops() call has been here since the driver
> introduction. But at that time, this call did not create any
> interfaces. The issue was most probably introduced by my change:
> 
> 83068395bbfc ("net: iosm: create default link via WWAN core")
> 
> after which the wwan_register_ops() call was modified in such a way
> that it started calling ipc_wwan_newlink() internally.

Ok, lets go with:

Fixes: 83068395bbfc ("net: iosm: create default link via WWAN core")

Shall I send a v2 with this ? or is this just going to get added
in while merging this?

Regards,

Hans

