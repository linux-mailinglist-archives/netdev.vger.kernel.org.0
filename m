Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C766777DF
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 10:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbjAWJyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 04:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbjAWJyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 04:54:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8105E22781
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 01:53:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674467582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XGBr/F0XFzE0vVYozw1/BKRP3jPgyxC9gUjhQB9Xc7E=;
        b=c7U7OZ+jrczNzreyjnvOkM8sMgpFeX6jNteXxCfp7KlwTy1izzKtSQPunhtGn4NS5fWLKj
        3van3cy18e686LiQMDttW5LgkCEFXL+Dsq0DEgWC9VcYRu+933qe4p3CJ4q4nF4bYRbJfa
        e5+WfW32OIN2I/6h4t2gd5wfzXkxJog=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-638-86tx_IzbOTWqpahf6-9brQ-1; Mon, 23 Jan 2023 04:53:01 -0500
X-MC-Unique: 86tx_IzbOTWqpahf6-9brQ-1
Received: by mail-qt1-f200.google.com with SMTP id z25-20020ac84559000000b003b69eb9e75bso2163517qtn.17
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 01:53:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XGBr/F0XFzE0vVYozw1/BKRP3jPgyxC9gUjhQB9Xc7E=;
        b=BMReC08Ss2CZ3PhrNhJ0kzHqfLPBrpiw09aV5stEwz2jK58gB2mvGqt9HPXCTMV0Id
         5vaqkq7pyJlMmIAMahmqoo5C9S+hsHSG1puV6m3rCg8899zq4fPEbb6IcTpXzzWpx/nk
         O8JlSy61SOpcEDY1wIpjTDq6Mg+OP5PcZwAgOhNnhhv5Bfcez5qDDLCtdlaeQDR2/J3x
         B1JlYQV3oNMB+dEqVU6pIxUMAFJ65lGoMGlZFXtVtWGIeI9P2C7enBPxX//8oHNxxTcS
         e5X8sl30d8TyLAFakwmoN6U98lEB+wSht8jOmJXX2m+w8j4gf2PHZicNbRhzqEg7uvZF
         uZpg==
X-Gm-Message-State: AFqh2koawppSxtolixKpKDdUoAXotQFAwcN/9WwAtoIkHZ9OK8jezp50
        PabN9jp4aqWubPnolHvFsO1bEy6pQDyXhYEJTrpwH3cgQsKew9PNb/Z50XAPY8hZb80PZ+/9nSG
        Eof/nBeJG57hvnRqk
X-Received: by 2002:a05:6214:37c6:b0:532:35a1:af91 with SMTP id nj6-20020a05621437c600b0053235a1af91mr36780673qvb.27.1674467580910;
        Mon, 23 Jan 2023 01:53:00 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtGVUKKbQfXcHL30rqUuIDlvGIgB5ckTck/POv0Vt/uPjVDeonGJ8IteOq2bZBAnoCEGaxYYg==
X-Received: by 2002:a05:6214:37c6:b0:532:35a1:af91 with SMTP id nj6-20020a05621437c600b0053235a1af91mr36780656qvb.27.1674467580648;
        Mon, 23 Jan 2023 01:53:00 -0800 (PST)
Received: from [192.168.100.30] ([82.142.8.70])
        by smtp.gmail.com with ESMTPSA id g8-20020ae9e108000000b006b5cc25535fsm5651738qkm.99.2023.01.23.01.52.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 01:53:00 -0800 (PST)
Message-ID: <8b80ac91-cf60-f5ff-a5dd-c5247c9c8f64@redhat.com>
Date:   Mon, 23 Jan 2023 10:52:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/4] virtio_net: notify MAC address change on device
 initialization
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, linux-kernel@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Cindy Lu <lulu@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <20230122100526.2302556-1-lvivier@redhat.com>
 <20230122100526.2302556-2-lvivier@redhat.com>
 <07a24753-767b-4e1e-2bcf-21ec04bc044a@nvidia.com>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <07a24753-767b-4e1e-2bcf-21ec04bc044a@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/23 14:47, Eli Cohen wrote:
> 
> On 22/01/2023 12:05, Laurent Vivier wrote:
>> In virtnet_probe(), if the device doesn't provide a MAC address the
>> driver assigns a random one.
>> As we modify the MAC address we need to notify the device to allow it
>> to update all the related information.
>>
>> The problem can be seen with vDPA and mlx5_vdpa driver as it doesn't
>> assign a MAC address by default. The virtio_net device uses a random
>> MAC address (we can see it with "ip link"), but we can't ping a net
>> namespace from another one using the virtio-vdpa device because the
>> new MAC address has not been provided to the hardware.
>>
>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>> ---
>>   drivers/net/virtio_net.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 7723b2a49d8e..25511a86590e 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -3800,6 +3800,8 @@ static int virtnet_probe(struct virtio_device *vdev)
>>           eth_hw_addr_set(dev, addr);
>>       } else {
>>           eth_hw_addr_random(dev);
>> +        dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
>> +             dev->dev_addr);
>>       }
>>       /* Set up our device-specific information */
>> @@ -3956,6 +3958,18 @@ static int virtnet_probe(struct virtio_device *vdev)
>>       pr_debug("virtnet: registered device %s with %d RX and TX vq's\n",
>>            dev->name, max_queue_pairs);
>> +    /* a random MAC address has been assigned, notify the device */
>> +    if (dev->addr_assign_type == NET_ADDR_RANDOM &&
> Maybe it's better to not count on addr_assign_type and use a local variable to indicate 
> that virtnet_probe assigned random MAC. The reason is that the hardware driver might have 
> done that as well and does not need notification.

eth_hw_addr_random() sets explicitly NET_ADDR_RANDOM, while eth_hw_addr_set() doesn't 
change addr_assign_type so it doesn't seem this value is set by the hardware driver.

So I guess it's the default value (NET_ADDR_PERM) in this case (even if it's a random 
address from the point of view of the hardware).

If you prefer I can replace it by "!virtio_has_feature(vdev, VIRTIO_NET_F_MAC)"?

Thanks,
Laurent

