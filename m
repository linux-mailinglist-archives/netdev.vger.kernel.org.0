Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44669550EF5
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 05:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237783AbiFTDeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 23:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiFTDeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 23:34:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89135B1C8
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 20:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655696056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dfwEK1sq7rdGyo7PvaKmvL8otVhWygQzLxR6ANVD3rU=;
        b=cXYevlXOgFjcct6pt7CIqrh9QJIPSvcffTcQyD0S8dzATYNA59CEA7dpkvSqcQ7ivmhufA
        flGdtIATdwlSLmKzMpQ9gi8JgFuJUXMrMGXQI0Tf5w5wY8krpWkCaV/XYbOzlpz7+XCUEu
        EXWimUc0G9Q5+SaimTJ1ZuHC2zRm1Dw=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-dXMLx-MIMPWHzv10rNUYHg-1; Sun, 19 Jun 2022 23:34:15 -0400
X-MC-Unique: dXMLx-MIMPWHzv10rNUYHg-1
Received: by mail-pj1-f72.google.com with SMTP id u9-20020a17090a2b8900b001ec79a1050eso4914226pjd.4
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 20:34:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dfwEK1sq7rdGyo7PvaKmvL8otVhWygQzLxR6ANVD3rU=;
        b=FyWlGWq7SEINJ6SkyZq43H8IXRd7IJDN0E9Kekx4bEsfri3ZLUrKw/eq5ToitP/PNJ
         TQToTX9ItkQ1J1/XS8RUaBYlgrKjPxMCVXeZr8myjfSss/rWjt8AkBxWFS2FHoX1H6sO
         4YN+BDSYgwgr5pcLxBqFtbnkglgK45V49GYt64JH+FiQyB5wdFugRtb+Oz11FrnfAdcH
         NZI00NcWpSUhZvmf7uamlfosvrzAhytO0z9JC+jE+ny1l16tuLuvw8KDs5P/w59Xup2z
         3nkJMptqzmJRGEybhC7p8thxMMb0F8/43RGuBktFtECEYLGakUBBgx80z7vjGuwuSPLc
         yukg==
X-Gm-Message-State: AJIora+NOeLc/kPurdLfVqK4eS9Fz2pUrPFBHVXleWCwjEYNiza4MvcV
        /xnGGNEnOa2JGaolbAU7WoxGN4865ln71KcBDb5XpYFXtAqDDPXPB+p5Gpt9/sQ9i+gMhkzFS/O
        /eRzvF6N937eK+u6i
X-Received: by 2002:a05:6a00:170b:b0:51b:d1fd:5335 with SMTP id h11-20020a056a00170b00b0051bd1fd5335mr22346549pfc.28.1655696054174;
        Sun, 19 Jun 2022 20:34:14 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uYN9VMFAa2HlkmqX/qFWqSRenF42IdfOZYHLpfaUTJHe10i9fpjJMcSHXQutXOkNBszTIlmw==
X-Received: by 2002:a05:6a00:170b:b0:51b:d1fd:5335 with SMTP id h11-20020a056a00170b00b0051bd1fd5335mr22346531pfc.28.1655696053829;
        Sun, 19 Jun 2022 20:34:13 -0700 (PDT)
Received: from [10.72.12.16] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a1-20020a170902710100b001634d581adfsm7383215pll.157.2022.06.19.20.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 20:34:13 -0700 (PDT)
Message-ID: <78d6d295-4694-c2db-5689-f0e366da9a07@redhat.com>
Date:   Mon, 20 Jun 2022 11:34:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH] virtio-net: fix race between ndo_open() and
 virtio_device_ready()
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20220617072949.30734-1-jasowang@redhat.com>
 <20220617060632-mutt-send-email-mst@kernel.org>
 <CACGkMEtTVs5W+qqt9Z6BcorJ6wcqcnSVuCBrHrLZbbKzG-7ULQ@mail.gmail.com>
 <20220617083141-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220617083141-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/6/17 20:32, Michael S. Tsirkin 写道:
> On Fri, Jun 17, 2022 at 07:46:23PM +0800, Jason Wang wrote:
>> On Fri, Jun 17, 2022 at 6:13 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>> On Fri, Jun 17, 2022 at 03:29:49PM +0800, Jason Wang wrote:
>>>> We used to call virtio_device_ready() after netdev registration. This
>>>> cause a race between ndo_open() and virtio_device_ready(): if
>>>> ndo_open() is called before virtio_device_ready(), the driver may
>>>> start to use the device before DRIVER_OK which violates the spec.
>>>>
>>>> Fixing this by switching to use register_netdevice() and protect the
>>>> virtio_device_ready() with rtnl_lock() to make sure ndo_open() can
>>>> only be called after virtio_device_ready().
>>>>
>>>> Fixes: 4baf1e33d0842 ("virtio_net: enable VQs early")
>>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>>> ---
>>>>   drivers/net/virtio_net.c | 8 +++++++-
>>>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>> index db05b5e930be..8a5810bcb839 100644
>>>> --- a/drivers/net/virtio_net.c
>>>> +++ b/drivers/net/virtio_net.c
>>>> @@ -3655,14 +3655,20 @@ static int virtnet_probe(struct virtio_device *vdev)
>>>>        if (vi->has_rss || vi->has_rss_hash_report)
>>>>                virtnet_init_default_rss(vi);
>>>>
>>>> -     err = register_netdev(dev);
>>>> +     /* serialize netdev register + virtio_device_ready() with ndo_open() */
>>>> +     rtnl_lock();
>>>> +
>>>> +     err = register_netdevice(dev);
>>>>        if (err) {
>>>>                pr_debug("virtio_net: registering device failed\n");
>>>> +             rtnl_unlock();
>>>>                goto free_failover;
>>>>        }
>>>>
>>>>        virtio_device_ready(vdev);
>>>>
>>>> +     rtnl_unlock();
>>>> +
>>>>        err = virtnet_cpu_notif_add(vi);
>>>>        if (err) {
>>>>                pr_debug("virtio_net: registering cpu notifier failed\n");
>>>
>>> Looks good but then don't we have the same issue when removing the
>>> device?
>>>
>>> Actually I looked at  virtnet_remove and I see
>>>          unregister_netdev(vi->dev);
>>>
>>>          net_failover_destroy(vi->failover);
>>>
>>>          remove_vq_common(vi); <- this will reset the device
>>>
>>> a window here?
>> Probably. For safety, we probably need to reset before unregistering.
>
> careful not to create new races, let's analyse this one to be
> sure first.


Yes, if we do that, there could be an infinite wait in ctrl commands.

So we are probably fine here since unregister_netdev() will make sure 
(otherwise it should be a bug of unregister_netdev()):

1) NAPI is disabled (and synced) so no new NAPI could be enabled by the 
callbacks
2) TX is disabled (and synced) so the qdisc could not be scheduled even 
if skb_xmit_done() is called between the window


>
>>>
>>> Really, I think what we had originally was a better idea -
>>> instead of dropping interrupts they were delayed and
>>> when driver is ready to accept them it just enables them.
>> The problem is that it works only on some specific setup:
>>
>> - doesn't work on shared IRQ
>> - doesn't work on some specific driver e.g virtio-blk
> can some core irq work fix that?


Not sure. At least for the shared IRQ part, there's no way to disable a 
specific handler currently. More below.


>
>>> We just need to make sure driver does not wait for
>>> interrupts before enabling them.


This only help for the case:

1) the virtio_device_ready() is called after subsystem 
initialization/registration
2) the driver use rx interrupt

It doesn't solve the race between subsystem registration/initialization 
and virtio_device_ready() or the case when the virtio_device_ready() 
needs to be called before subsystem registration.

Thanks


>>>
>>> And I suspect we need to make this opt-in on a per driver
>>> basis.
>> Exactly.
>>
>> Thanks
>>
>>>
>>>
>>>> --
>>>> 2.25.1

