Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEAF5F898F
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 07:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJIF7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 01:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiJIF7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 01:59:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE652F643
        for <netdev@vger.kernel.org>; Sat,  8 Oct 2022 22:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665295145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XyL4XgZY3fE78rf1t1J98tuq3HEa3BcmqHdSW/YDE7Y=;
        b=ZtFMWHBWnqNjqog3k0z9BaBsNKKC3WYYHQb1YiMSR0xyKpre1F8JIUNjAhx9/UiTSlbthU
        jC73DhZBJuXwTMYX9pOkiCH9HvUiUXd4nyk7H4cpT+G5stYUsnndFP5hbxnnJoYIFjC4C8
        hIShn3T2qLGnQtequZyR5FpzSSIORqE=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-454-A_hAOrw3NYOzsyj1K8_lVw-1; Sun, 09 Oct 2022 01:59:03 -0400
X-MC-Unique: A_hAOrw3NYOzsyj1K8_lVw-1
Received: by mail-pg1-f199.google.com with SMTP id 126-20020a630284000000b0043942ef3ac7so4917409pgc.11
        for <netdev@vger.kernel.org>; Sat, 08 Oct 2022 22:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XyL4XgZY3fE78rf1t1J98tuq3HEa3BcmqHdSW/YDE7Y=;
        b=poJMBigYhQf6pJNL2bgZFTnjfP7kyuv00bRua5Mce/ZBAI7krOVzRL5YJ7YK/ZjoSe
         j2yESYZbpbX5PuAS5JhzQJa9x82CaYfJGT3y8lMhxVW8VJlhxykJ4UYju2dQptY6Yy8B
         gqR3Hti+wivmXiOyjTJ3wnnYcwpmwY45U22Fe2q8zU2ACfG4E4Xj7XwpdWDDLSJ5nbs+
         huDs13jI5tfEcufCfWfvwAl7yE/3nwN2FkpEeF1WWufyb0GUO8kfoIy0X6JSP/X4z3Bp
         iwxexIJnJT2oB3idn6LvKn5NjYRyke7ghifaZEWVaQDsc+4czQYtZ5e9zY/7PJaYvEru
         BhLQ==
X-Gm-Message-State: ACrzQf1YCRamNNuIIyaQInbUN2OHFniYt76TXFFBhxzazlUYCMSiuO4Y
        d1cbpgd9lafyBo8hwuSTlfwqtegu9sU83MGIfFdDVTSkqztFfjOWpp5IPaExAPZBFmrvakEGfNC
        R+cht4G2YMC4oFFIN
X-Received: by 2002:a17:90a:1347:b0:20b:ffd:66b9 with SMTP id y7-20020a17090a134700b0020b0ffd66b9mr16351254pjf.15.1665295142929;
        Sat, 08 Oct 2022 22:59:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM57/2XHWbN7XzWOLjsjlVXU3IBSBWoYzNW9XJfotIZtsRHFNdZuR0KhTY81FYcV9G64goQDVg==
X-Received: by 2002:a17:90a:1347:b0:20b:ffd:66b9 with SMTP id y7-20020a17090a134700b0020b0ffd66b9mr16351239pjf.15.1665295142628;
        Sat, 08 Oct 2022 22:59:02 -0700 (PDT)
Received: from [10.72.12.61] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 67-20020a620446000000b0054ee4b632dasm4350688pfe.169.2022.10.08.22.58.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Oct 2022 22:59:02 -0700 (PDT)
Message-ID: <c8cd9a2e-3480-6ca5-96fa-4b5bd2c1174a@redhat.com>
Date:   Sun, 9 Oct 2022 13:58:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH net] virtio-net: add cond_resched() to the command waiting
 loop
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        davem <davem@davemloft.net>
References: <20220905045341.66191-1-jasowang@redhat.com>
 <20220905031405-mutt-send-email-mst@kernel.org>
 <CACGkMEtjQ0Jfok-gcRW+kuinsua2X0TscyTNfBJoXHny0Yob+g@mail.gmail.com>
 <056ba905a2579903a372258383afdf6579767ad0.camel@redhat.com>
 <CACGkMEuiDqqOEKUWRN9LvQKv8Jz4mi3aSZMwbhUsJkZp=C-0RQ@mail.gmail.com>
 <c9180ac41b00543e3531a343afae8f5bdca64d8d.camel@redhat.com>
 <20220907034407-mutt-send-email-mst@kernel.org>
 <d32101bb-783f-dbd1-545a-be291c27cb63@redhat.com>
 <20220908011858-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220908011858-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/9/8 13:19, Michael S. Tsirkin 写道:
> On Thu, Sep 08, 2022 at 10:21:45AM +0800, Jason Wang wrote:
>> 在 2022/9/7 15:46, Michael S. Tsirkin 写道:
>>> On Wed, Sep 07, 2022 at 09:07:20AM +0200, Paolo Abeni wrote:
>>>> On Wed, 2022-09-07 at 10:09 +0800, Jason Wang wrote:
>>>>> On Tue, Sep 6, 2022 at 6:56 PM Paolo Abeni <pabeni@redhat.com> wrote:
>>>>>> On Mon, 2022-09-05 at 15:49 +0800, Jason Wang wrote:
>>>>>>> On Mon, Sep 5, 2022 at 3:15 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>>>>> On Mon, Sep 05, 2022 at 12:53:41PM +0800, Jason Wang wrote:
>>>>>>>>> Adding cond_resched() to the command waiting loop for a better
>>>>>>>>> co-operation with the scheduler. This allows to give CPU a breath to
>>>>>>>>> run other task(workqueue) instead of busy looping when preemption is
>>>>>>>>> not allowed.
>>>>>>>>>
>>>>>>>>> What's more important. This is a must for some vDPA parent to work
>>>>>>>>> since control virtqueue is emulated via a workqueue for those parents.
>>>>>>>>>
>>>>>>>>> Fixes: bda324fd037a ("vdpasim: control virtqueue support")
>>>>>>>> That's a weird commit to fix. so it fixes the simulator?
>>>>>>> Yes, since the simulator is using a workqueue to handle control virtueue.
>>>>>> Uhmm... touching a driver for a simulator's sake looks a little weird.
>>>>> Simulator is not the only one that is using a workqueue (but should be
>>>>> the first).
>>>>>
>>>>> I can see  that the mlx5 vDPA driver is using a workqueue as well (see
>>>>> mlx5_vdpa_kick_vq()).
>>>>>
>>>>> And in the case of VDUSE, it needs to wait for the response from the
>>>>> userspace, this means cond_resched() is probably a must for the case
>>>>> like UP.
>>>>>
>>>>>> Additionally, if the bug is vdpasim, I think it's better to try to
>>>>>> solve it there, if possible.
>>>>>>
>>>>>> Looking at vdpasim_net_work() and vdpasim_blk_work() it looks like
>>>>>> neither needs a process context, so perhaps you could rework it to run
>>>>>> the work_fn() directly from vdpasim_kick_vq(), at least for the control
>>>>>> virtqueue?
>>>>> It's possible (but require some rework on the simulator core). But
>>>>> considering we have other similar use cases, it looks better to solve
>>>>> it in the virtio-net driver.
>>>> I see.
>>>>
>>>>> Additionally, this may have better behaviour when using for the buggy
>>>>> hardware (e.g the control virtqueue takes too long to respond). We may
>>>>> consider switching to use interrupt/sleep in the future (but not
>>>>> suitable for -net).
>>>> Agreed. Possibly a timeout could be useful, too.
>>>>
>>>> Cheers,
>>>>
>>>> Paolo
>>> Hmm timeouts are kind of arbitrary.
>>> regular drivers basically derive them from hardware
>>> behaviour but with a generic driver like virtio it's harder.
>>> I guess we could add timeout as a config field, have
>>> device make a promise to the driver.
>>>
>>> Making the wait interruptible seems more reasonable.
>>
>> Yes, but I think we still need this patch for -net and -stable.
>>
>> Thanks
> I was referring to Paolo's idea of having a timeout.


Ok, I think we're fine with this patch. Any chance to merge this or do I 
need to resend?

Thanks


>

