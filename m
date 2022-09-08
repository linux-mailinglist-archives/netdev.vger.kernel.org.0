Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1E75B1266
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 04:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiIHCV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 22:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiIHCV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 22:21:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4F1A61C5
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 19:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662603714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iT5k9dnvMqT2ZKkMTuSIzNcN6Xuwb0rz4A/0JhBTSpk=;
        b=LD1XTlH6xG7R+OFttH9IqoH3J14DrHmR+l9wgJ5AqhFJTv5VBKn8M6KX9DdE6KHEN0/fTn
        MMFm8SIxcT/CH8T/aIW8VsGPtI22gqoSLmAE3xweP6G35mmpn3hCCcjZDXMrsVH+wHpbqi
        P9CRamAMyjuYUQ2l6rgqxn23bUKb5gQ=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-82-byKhTn9KMAiRDyj2VP6hww-1; Wed, 07 Sep 2022 22:21:53 -0400
X-MC-Unique: byKhTn9KMAiRDyj2VP6hww-1
Received: by mail-pl1-f199.google.com with SMTP id x13-20020a170902ec8d00b00177f0fa642cso675417plg.10
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 19:21:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=iT5k9dnvMqT2ZKkMTuSIzNcN6Xuwb0rz4A/0JhBTSpk=;
        b=oxxqQG/EkrAQND5LeHdAJJLZD9qPvx1HjuQM6Lyo2JqbPvJ9jkMTkAscgEV0tkvHLN
         /EQ5FLoXMNOye2qEcMF5L8qA3bmrU6a1cz3T2ZBMZcnuwLfjqbgRumF2py1JYguThpiN
         zwmpW98gYxC2E9d3z+Msqj2lbUtpXhoVK1XRTBxQGJOkKrUeG/R72sJxCtqcgqi5HPGf
         b8P/WXxC89orZKvsX8OSP4g8BpDO9OWDEhCmj+urMgnLUESW7AgY8ZYDksr2j/IiHAe4
         WrbppGNEuzBqPh4cX45Lt9ryJTOgk+LizK+E5u9CJ8FcsarxWh3bDcm//5gbZGgQRDYq
         mNEQ==
X-Gm-Message-State: ACgBeo1isdIGNG0WSV7wxJSol2i6Q9K5s0RZJ9qsMPfwfme0VMrT2til
        S3lC/ZHSXIQPCG6jcO9OaLqFlD45iXdRCswXgNaFzX3K0l20voL/LW3zV/vSbuIGzz6GwOjaogX
        IkvLrgi3irmreDbz2
X-Received: by 2002:a05:6a00:1354:b0:53a:80d6:6f61 with SMTP id k20-20020a056a00135400b0053a80d66f61mr6754059pfu.69.1662603712090;
        Wed, 07 Sep 2022 19:21:52 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7yzCmsVxrO0fzQppdwR2AxZWE75JALnDLDP+OsSK9OgJk/Tzw9u6zw5XxVbH4qF7F3wx2wQg==
X-Received: by 2002:a05:6a00:1354:b0:53a:80d6:6f61 with SMTP id k20-20020a056a00135400b0053a80d66f61mr6754042pfu.69.1662603711816;
        Wed, 07 Sep 2022 19:21:51 -0700 (PDT)
Received: from [10.72.13.192] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x9-20020a17090a294900b002005114fbf5sm401322pjf.22.2022.09.07.19.21.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 19:21:50 -0700 (PDT)
Message-ID: <d32101bb-783f-dbd1-545a-be291c27cb63@redhat.com>
Date:   Thu, 8 Sep 2022 10:21:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH net] virtio-net: add cond_resched() to the command waiting
 loop
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        davem <davem@davemloft.net>
References: <20220905045341.66191-1-jasowang@redhat.com>
 <20220905031405-mutt-send-email-mst@kernel.org>
 <CACGkMEtjQ0Jfok-gcRW+kuinsua2X0TscyTNfBJoXHny0Yob+g@mail.gmail.com>
 <056ba905a2579903a372258383afdf6579767ad0.camel@redhat.com>
 <CACGkMEuiDqqOEKUWRN9LvQKv8Jz4mi3aSZMwbhUsJkZp=C-0RQ@mail.gmail.com>
 <c9180ac41b00543e3531a343afae8f5bdca64d8d.camel@redhat.com>
 <20220907034407-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220907034407-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/9/7 15:46, Michael S. Tsirkin 写道:
> On Wed, Sep 07, 2022 at 09:07:20AM +0200, Paolo Abeni wrote:
>> On Wed, 2022-09-07 at 10:09 +0800, Jason Wang wrote:
>>> On Tue, Sep 6, 2022 at 6:56 PM Paolo Abeni <pabeni@redhat.com> wrote:
>>>> On Mon, 2022-09-05 at 15:49 +0800, Jason Wang wrote:
>>>>> On Mon, Sep 5, 2022 at 3:15 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>>> On Mon, Sep 05, 2022 at 12:53:41PM +0800, Jason Wang wrote:
>>>>>>> Adding cond_resched() to the command waiting loop for a better
>>>>>>> co-operation with the scheduler. This allows to give CPU a breath to
>>>>>>> run other task(workqueue) instead of busy looping when preemption is
>>>>>>> not allowed.
>>>>>>>
>>>>>>> What's more important. This is a must for some vDPA parent to work
>>>>>>> since control virtqueue is emulated via a workqueue for those parents.
>>>>>>>
>>>>>>> Fixes: bda324fd037a ("vdpasim: control virtqueue support")
>>>>>> That's a weird commit to fix. so it fixes the simulator?
>>>>> Yes, since the simulator is using a workqueue to handle control virtueue.
>>>> Uhmm... touching a driver for a simulator's sake looks a little weird.
>>> Simulator is not the only one that is using a workqueue (but should be
>>> the first).
>>>
>>> I can see  that the mlx5 vDPA driver is using a workqueue as well (see
>>> mlx5_vdpa_kick_vq()).
>>>
>>> And in the case of VDUSE, it needs to wait for the response from the
>>> userspace, this means cond_resched() is probably a must for the case
>>> like UP.
>>>
>>>> Additionally, if the bug is vdpasim, I think it's better to try to
>>>> solve it there, if possible.
>>>>
>>>> Looking at vdpasim_net_work() and vdpasim_blk_work() it looks like
>>>> neither needs a process context, so perhaps you could rework it to run
>>>> the work_fn() directly from vdpasim_kick_vq(), at least for the control
>>>> virtqueue?
>>> It's possible (but require some rework on the simulator core). But
>>> considering we have other similar use cases, it looks better to solve
>>> it in the virtio-net driver.
>> I see.
>>
>>> Additionally, this may have better behaviour when using for the buggy
>>> hardware (e.g the control virtqueue takes too long to respond). We may
>>> consider switching to use interrupt/sleep in the future (but not
>>> suitable for -net).
>> Agreed. Possibly a timeout could be useful, too.
>>
>> Cheers,
>>
>> Paolo
>
> Hmm timeouts are kind of arbitrary.
> regular drivers basically derive them from hardware
> behaviour but with a generic driver like virtio it's harder.
> I guess we could add timeout as a config field, have
> device make a promise to the driver.
>
> Making the wait interruptible seems more reasonable.


Yes, but I think we still need this patch for -net and -stable.

Thanks


>

