Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114076791CA
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 08:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbjAXHUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 02:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjAXHUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 02:20:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8B07ED6
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 23:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674544777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7q3iqRUHEdMbAtpmNI/eVbLbK/lHpmY+A3ZIsty8k9o=;
        b=IeGUQm6ApaP21BeqK3XsK4h4ml4Ubyb8ENeB0JOcc6sg3/vJI8P56jTyQAlYV6hgQt4FvN
        Sysnkv12CPNohbYriTFawXfU9z5bB3cQJu5ZvhKJ5FQWq7JJFPQzMTVeMsKnHO9H8kRhml
        Czmw4WVCpUZatRACKDY5n2+aCWTq6Ms=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-619-8a_JGcr8PP6oL_5BRpQ_2A-1; Tue, 24 Jan 2023 02:19:36 -0500
X-MC-Unique: 8a_JGcr8PP6oL_5BRpQ_2A-1
Received: by mail-qv1-f69.google.com with SMTP id ff3-20020a0562140bc300b00534ec186e17so7218387qvb.14
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 23:19:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7q3iqRUHEdMbAtpmNI/eVbLbK/lHpmY+A3ZIsty8k9o=;
        b=BWTo4IIlX6jNPFxoqbvHqu+0FCfudgzKQ7Tdl1OnnK9dP+nR7WUqxAuJtlEW10l1Xk
         6b2jQIz6EXAIRMwMpkZE1Ff26v+HJYZAx7QJkEqet4lyJ63RG2yEgDUbLoFaNZQPe/if
         3bEy+FUbFWbAy9z0cRH2ODWIbPIZP2kTrqZA7PDr4i/MKs+r+tNE8MIqg/xcZcItGNxw
         NjpjLoXV67emCyo6bZXLUOc8NtFUlDyJmqfr9R5MXlCWZYK7QGLn1nwlpZQYaPjAJgVk
         x6tFMaG4CXx09umkcHquSiTutd1veSWYQYM1gqfQqIaEbyFGmgwj8T31PmO7lZ8ST2J+
         qsbw==
X-Gm-Message-State: AFqh2kr4c2ANM7ATM6Qbxl3e+YvPVxT6a2JdBewaCI4IB5I30V3QmjoE
        v/YKoFwaHpnkAl3wfcQaVST5Lf9X4x0u8QMidYjWOxTm9zQU0FcPnkUIY2uVxneYUiPSgsJ3jxH
        9HaBZZ6XUXTamggo8
X-Received: by 2002:a05:622a:4897:b0:3ab:a3d9:c5c8 with SMTP id fc23-20020a05622a489700b003aba3d9c5c8mr45612921qtb.3.1674544775623;
        Mon, 23 Jan 2023 23:19:35 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuN2ZdpfTVek/pkskSHS//zZArD9nCjkHIXPrwJoZbwBa9jqTPDSAuz+JqMDr1JkvokbWw8uA==
X-Received: by 2002:a05:622a:4897:b0:3ab:a3d9:c5c8 with SMTP id fc23-20020a05622a489700b003aba3d9c5c8mr45612897qtb.3.1674544775412;
        Mon, 23 Jan 2023 23:19:35 -0800 (PST)
Received: from [192.168.100.30] ([82.142.8.70])
        by smtp.gmail.com with ESMTPSA id 72-20020a37074b000000b00706c1fc62desm909030qkh.112.2023.01.23.23.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 23:19:34 -0800 (PST)
Message-ID: <3ff50750-de59-dc2b-01a9-1a453e49e26e@redhat.com>
Date:   Tue, 24 Jan 2023 08:19:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/4] virtio_net: notify MAC address change on device
 initialization
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Eli Cohen <elic@nvidia.com>
Cc:     linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
 <20230123193114.56aaec3a@kernel.org>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <20230123193114.56aaec3a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/23 04:31, Jakub Kicinski wrote:
> On Sun, 22 Jan 2023 15:47:08 +0200 Eli Cohen wrote:
>>> @@ -3956,6 +3958,18 @@ static int virtnet_probe(struct virtio_device *vdev)
>>>    	pr_debug("virtnet: registered device %s with %d RX and TX vq's\n",
>>>    		 dev->name, max_queue_pairs);
>>>    
>>> +	/* a random MAC address has been assigned, notify the device */
>>> +	if (dev->addr_assign_type == NET_ADDR_RANDOM &&
>> Maybe it's better to not count on addr_assign_type and use a local
>> variable to indicate that virtnet_probe assigned random MAC.
> 
> +1, FWIW
> 
v2 sent, but I rely on virtio_has_feature(vdev, VIRTIO_NET_F_MAC) to know if the MAC 
address is provided by the device or not:

https://lore.kernel.org/lkml/20230123120022.2364889-2-lvivier@redhat.com/T/#me9211516e12771001e0346818255c9fb48a2bf4a

Thanks,
Laurent

