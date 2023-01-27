Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C097567E52E
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 13:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjA0M3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 07:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjA0M3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 07:29:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8962479233
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 04:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674822489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5xclzS60WKfmjFavTzqp+B0Uxio42pgew/o/vyaA76o=;
        b=BfVYgSjc8rxSby7ysNQrFh5Z105JXfuyHMBakwupYe24aR9/JjvIEurhHM5yy91iIT+Ojb
        luhjWbKowqDjvGMSb+SvQvzkGB24erHWW0lE8yZslM/A+aL79rYyIdXN9gqJY+C1kdckp8
        4VYHw9JCQOmSGIu1gYnLEEMNyxu5qWc=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-119-l4u3VIcRP22soTcHhZiVBw-1; Fri, 27 Jan 2023 07:28:06 -0500
X-MC-Unique: l4u3VIcRP22soTcHhZiVBw-1
Received: by mail-qv1-f69.google.com with SMTP id ob12-20020a0562142f8c00b004c6c72bf1d0so2688424qvb.9
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 04:28:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5xclzS60WKfmjFavTzqp+B0Uxio42pgew/o/vyaA76o=;
        b=w1vrWab5VYbusU0ZX+aAGqBob+pyEuhl6bVk+xAJan1mdk2FsEpsI7nbG+pOgknZVf
         //jWH8yGCxREDgNnHZgVskwGAQ11PvnvNH0N93lT6ad3IhDztOzmzP8QAcNZ3GLZL3Su
         IrDC6b6Qt1YXedrZAWSqV1lkmecM5dokiVdCQSS1gazM1pS9vWBjUSBCl+HuwJYLXLof
         a4Z5Vl2U4jW6CRmJCb7oWwVWl9LD0+eXb0oepaGlDU7teIUIeOC5bIPIB8/M0fOPKUgp
         lYdjF7IXP0t/Ih8Mxy/Fa3zly/LPPI2fhUsUmGk8IDZOj9BmSklsmRTvNlbeoCyle7aF
         5pYg==
X-Gm-Message-State: AO0yUKX7FIR1XgOsbiL8+gNs6lULvBlJ8u0/eW8boFWiJjSmiLpPZpxK
        Sx4ZNB0+tC6TzcuzQ69HloZ5WyPv//GMOS2v7cQ8WinI+s4knGfmL6qbJYTcX48HalTKjiDAKgN
        4jpkfMgmSJ3g1k3Z2
X-Received: by 2002:a05:622a:1016:b0:3b8:248b:a035 with SMTP id d22-20020a05622a101600b003b8248ba035mr2601182qte.19.1674822485731;
        Fri, 27 Jan 2023 04:28:05 -0800 (PST)
X-Google-Smtp-Source: AK7set8IDSemL3lqiCbkX9GCb5pAEaPeJPkc2xzrAclCoOfx1/pjTc6meh6Iz3ye7+UdTcLWZOvLSQ==
X-Received: by 2002:a05:622a:1016:b0:3b8:248b:a035 with SMTP id d22-20020a05622a101600b003b8248ba035mr2601133qte.19.1674822485329;
        Fri, 27 Jan 2023 04:28:05 -0800 (PST)
Received: from [192.168.100.30] ([82.142.8.70])
        by smtp.gmail.com with ESMTPSA id d15-20020a05620a136f00b006fb112f512csm2751566qkl.74.2023.01.27.04.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 04:28:04 -0800 (PST)
Message-ID: <5d82047d-411b-a98d-ce0e-1195838db42c@redhat.com>
Date:   Fri, 27 Jan 2023 13:28:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 1/1] virtio_net: notify MAC address change on device
 initialization
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Eli Cohen <elic@nvidia.com>, Cindy Lu <lulu@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Parav Pandit <parav@nvidia.com>
References: <20230123120022.2364889-1-lvivier@redhat.com>
 <20230123120022.2364889-2-lvivier@redhat.com>
 <20230124024711-mutt-send-email-mst@kernel.org>
 <971beeaf-5e68-eb4a-1ceb-63a5ffa74aff@redhat.com>
 <20230127060453-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <20230127060453-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/23 12:08, Michael S. Tsirkin wrote:
> On Tue, Jan 24, 2023 at 12:04:24PM +0100, Laurent Vivier wrote:
>> On 1/24/23 11:15, Michael S. Tsirkin wrote:
>>> On Mon, Jan 23, 2023 at 01:00:22PM +0100, Laurent Vivier wrote:
>>>> In virtnet_probe(), if the device doesn't provide a MAC address the
>>>> driver assigns a random one.
>>>> As we modify the MAC address we need to notify the device to allow it
>>>> to update all the related information.
>>>>
>>>> The problem can be seen with vDPA and mlx5_vdpa driver as it doesn't
>>>> assign a MAC address by default. The virtio_net device uses a random
>>>> MAC address (we can see it with "ip link"), but we can't ping a net
>>>> namespace from another one using the virtio-vdpa device because the
>>>> new MAC address has not been provided to the hardware.
>>>
>>> And then what exactly happens? Does hardware drop the outgoing
>>> or the incoming packets? Pls include in the commit log.
>>
>> I don't know. There is nothing in the kernel logs.
>>
>> The ping error is: "Destination Host Unreachable"
>>
>> I found the problem with the mlx5 driver as in "it doesn't work when MAC
>> address is not set"...
>>
>> Perhaps Eli can explain what happens when the MAC address is not set?
>>
>>>
>>>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>>>> ---
>>>>    drivers/net/virtio_net.c | 14 ++++++++++++++
>>>>    1 file changed, 14 insertions(+)
>>>>
>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>> index 7723b2a49d8e..4bdc8286678b 100644
>>>> --- a/drivers/net/virtio_net.c
>>>> +++ b/drivers/net/virtio_net.c
>>>> @@ -3800,6 +3800,8 @@ static int virtnet_probe(struct virtio_device *vdev)
>>>>    		eth_hw_addr_set(dev, addr);
>>>>    	} else {
>>>>    		eth_hw_addr_random(dev);
>>>> +		dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
>>>> +			 dev->dev_addr);
>>>>    	}
>>>>    	/* Set up our device-specific information */
>>>> @@ -3956,6 +3958,18 @@ static int virtnet_probe(struct virtio_device *vdev)
>>>>    	pr_debug("virtnet: registered device %s with %d RX and TX vq's\n",
>>>>    		 dev->name, max_queue_pairs);
>>>> +	/* a random MAC address has been assigned, notify the device */
>>>> +	if (!virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
>>>> +	    virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
>>>
>>> Maybe add a comment explaining that we don't fail probe if
>>> VIRTIO_NET_F_CTRL_MAC_ADDR is not there because
>>> many devices work fine without getting MAC explicitly.
>>
>> OK
>>
>>>
>>>> +		struct scatterlist sg;
>>>> +
>>>> +		sg_init_one(&sg, dev->dev_addr, dev->addr_len);
>>>> +		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
>>>> +					  VIRTIO_NET_CTRL_MAC_ADDR_SET, &sg)) {
>>>> +			dev_warn(&vdev->dev, "Failed to update MAC address.\n");
>>>
>>> Here, I'm not sure we want to proceed. Is it useful sometimes?
>>
>> I think reporting an error is always useful, but I can remove that if you prefer.
> 
> No the question was whether we should fail probe not
> whether we print the warning.

Good question.

After all, as VIRTIO_NET_F_CTRL_MAC_ADDR is set, if VIRTIO_NET_CTRL_MAC_ADDR_SET fails it 
means there is a real problem, so yes, we should fail.

> 
> 
>>> I note that we deny with virtnet_set_mac_address.
>>>
>>>> +		}
>>>> +	}
>>>> +
>>>>    	return 0;
>>>
>>>
>>>
>>> Also, some code duplication with virtnet_set_mac_address here.
>>>
>>> Also:
>>> 	When using the legacy interface, \field{mac} is driver-writable
>>> 	which provided a way for drivers to update the MAC without
>>> 	negotiating VIRTIO_NET_F_CTRL_MAC_ADDR.
>>>
>>> How about factoring out code in virtnet_set_mac_address
>>> and reusing that?
>>>
>>
>> In fact, we can write in the field only if we have VIRTIO_NET_F_MAC
>> (according to virtnet_set_mac_address(), and this code is executed only if
>> we do not have VIRTIO_NET_F_MAC. So I think it's better not factoring the
>> code as we have only the control queue case to manage.
>>
>>> This will also handle corner cases such as VIRTIO_NET_F_STANDBY
>>> which are not currently addressed.
>>
>> F_STANDBY is only enabled when virtio-net device MAC address is equal to the
>> VFIO device MAC address, I don't think it can be enabled when the MAC
>> address is randomly assigned (in this case it has already failed in
>> net_failover_create(), as it has been called using the random mac address),
>> it's why I didn't check for it.
> 
> But the spec did not say there's a dependency :(.
> My point is what should we do if there's F_STANDBY but no MAC?
> Maybe add a separate patch clearing F_STANDBY in this case?

The simplest would be to add at the beginning of the probe function:

if (!virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
     virtio_has_feature(vdev, VIRTIO_NET_F_STANDBY)) {
	pr_err("virtio-net: a standby device cannot be used without a MAC address");
	return -EOPNOTSUPP;
}

And I think it would help a lot to debug misconfiguration of the interface.

Thanks,
Laurent

> 
>>>
>>>
>>>>    free_unregister_netdev:
>>>> -- 
>>>> 2.39.0
>>>
>>
>> Thanks,
>> Laurent
> 

