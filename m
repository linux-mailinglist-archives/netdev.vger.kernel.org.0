Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFC96828EA
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbjAaJds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjAaJdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:33:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B883C13
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675157578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DBQzfQxX4tLE3XglxaxRBTAUCUwV8ydRvRoWUBFiIAU=;
        b=DGSnsjpF8+hAxK9Dp6jp1WVDbiuROwtSAN/W8bvMZhT5RZ82wX12ixVJVS+BNFV2XV1PqQ
        ikizPHVgho8ASpxYpQfkzGoS11s3yLXccRyNZiD8Qwzx4RaBuvC8oJJY36x00LvTqbLaBE
        +TEYNUtsKG2LAt5DIWLeXjmyYS7/rXM=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-580-eCCSxuTHMKm0rb25-OwRUQ-1; Tue, 31 Jan 2023 04:32:57 -0500
X-MC-Unique: eCCSxuTHMKm0rb25-OwRUQ-1
Received: by mail-qv1-f71.google.com with SMTP id px22-20020a056214051600b00537657b0449so8059899qvb.23
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:32:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DBQzfQxX4tLE3XglxaxRBTAUCUwV8ydRvRoWUBFiIAU=;
        b=53vyDOWVtkNmIJ3ODPyihAiz7dmceuCvqfRvkbjiIkOLytoyNf0822B63uZT8hnp6p
         7MSZmEn1MCGnBHtcieB3Yjj1AaCUWPFOKQ3FsFk5jNQgHcgMUIud6PLQsuciiFRIbN49
         kTvCPqGLa94ooVuW1BnwhvVBy+DvVjOEh/Rl6gKUAYGvH4GIyw74goGHWyLB2W0i4bf3
         7ZX5WRP/UWUFvCL7HcOMFfwMsXwbdw4fp3BJzoOF99Ca2IDQ4f/oIh/gDoT+VVPSj8dZ
         4iKm5YknF6WOmaFjRp0EUnDHHDbIBpyHP9eYbSs5mQH/LnSs/XNcw8oQhY8aR62Io/xi
         ySQg==
X-Gm-Message-State: AFqh2kojOk2yYWprSSD2SxkH5PV8AnXcP5nFI1xIP3VWjj+DCXaAlLZ4
        5WYZc/tTvKTjDasFy/kGD6WppRWshJes/mkqkh9TIZbNhrvSKQCSDD2ZGanYSLuyCh+QxPB14i7
        SF3FnKEWR9Yy7BY+s
X-Received: by 2002:ac8:454e:0:b0:3a8:fdf:8ff8 with SMTP id z14-20020ac8454e000000b003a80fdf8ff8mr71681307qtn.36.1675157576800;
        Tue, 31 Jan 2023 01:32:56 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuFcusn7/Z9gSKN7OA3kQNo5zOuRPcVs4oJi5oHw2k5cV6S5N4fhP31zSpvJcDZwlm/3V5sOg==
X-Received: by 2002:ac8:454e:0:b0:3a8:fdf:8ff8 with SMTP id z14-20020ac8454e000000b003a80fdf8ff8mr71681284qtn.36.1675157576463;
        Tue, 31 Jan 2023 01:32:56 -0800 (PST)
Received: from [192.168.100.30] ([82.142.8.70])
        by smtp.gmail.com with ESMTPSA id j4-20020a37c244000000b00706a452c074sm6737880qkm.104.2023.01.31.01.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 01:32:55 -0800 (PST)
Message-ID: <8bb17aed-d643-2e33-472a-9f237e26e4d1@redhat.com>
Date:   Tue, 31 Jan 2023 10:32:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 2/2] virtio_net: notify MAC address change on device
 initialization
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Cindy Lu <lulu@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
References: <20230127204500.51930-1-lvivier@redhat.com>
 <20230127204500.51930-3-lvivier@redhat.com>
 <949500bd10077989eb21bd41d6bb1a0de296f9d8.camel@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <949500bd10077989eb21bd41d6bb1a0de296f9d8.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/23 10:01, Paolo Abeni wrote:
> On Fri, 2023-01-27 at 21:45 +0100, Laurent Vivier wrote:
>> In virtnet_probe(), if the device doesn't provide a MAC address the
>> driver assigns a random one.
>> As we modify the MAC address we need to notify the device to allow it
>> to update all the related information.
>>
>> The problem can be seen with vDPA and mlx5_vdpa driver as it doesn't
>> assign a MAC address by default. The virtio_net device uses a random
>> MAC address (we can see it with "ip link"), but we can't ping a net
>> namespace from another one using the virtio-vdpa device because the
>> new MAC address has not been provided to the hardware:
>> RX packets are dropped since they don't go through the receive filters,
>> TX packets go through unaffected.
>>
>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>> ---
>>   drivers/net/virtio_net.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 7d700f8e545a..704a05f1c279 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -3806,6 +3806,8 @@ static int virtnet_probe(struct virtio_device *vdev)
>>   		eth_hw_addr_set(dev, addr);
>>   	} else {
>>   		eth_hw_addr_random(dev);
>> +		dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
>> +			 dev->dev_addr);
>>   	}
>>   
>>   	/* Set up our device-specific information */
>> @@ -3933,6 +3935,24 @@ static int virtnet_probe(struct virtio_device *vdev)
>>   
>>   	virtio_device_ready(vdev);
>>   
>> +	/* a random MAC address has been assigned, notify the device.
>> +	 * We don't fail probe if VIRTIO_NET_F_CTRL_MAC_ADDR is not there
>> +	 * because many devices work fine without getting MAC explicitly
>> +	 */
>> +	if (!virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
>> +	    virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
>> +		struct scatterlist sg;
>> +
>> +		sg_init_one(&sg, dev->dev_addr, dev->addr_len);
>> +		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
>> +					  VIRTIO_NET_CTRL_MAC_ADDR_SET, &sg)) {
>> +			pr_debug("virtio_net: setting MAC address failed\n");
>> +			rtnl_unlock();
>> +			err = -EINVAL;
>> +			goto free_unregister_netdev;
> 
> Since the above is still dealing with device initialization, would it
> make sense moving such init step before registering the netdevice?

It depends if we can send the command using the control command queue or not.
I don't think we can use a vq before virtio_device_ready().

Thanks,
Laurent

