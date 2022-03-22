Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B984E402C
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiCVOHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbiCVOHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:07:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7A624BFDB
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 07:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647957908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WWSu3wiWy99oqRDajCtjPLsUAPwXYFjyrn/okc9AKDQ=;
        b=ONW+mvp9oggZT7X+HtAXL/d8Ku/3aSRKt0t15O5X3Yx/3XtgCI4bNxJLGD+JTu+gIrADVd
        020zQJHqym9be7eYrwdzOE8RhBfgYacYLMrXTYnNX9P2vZlK6XpyjexmcgnCAo/iZugxJY
        tsmqMvFWxJa3JaqXfKJCO3yKR3kcRnc=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-k0FpN4VwNOaoAzfQ6sj79Q-1; Tue, 22 Mar 2022 10:05:07 -0400
X-MC-Unique: k0FpN4VwNOaoAzfQ6sj79Q-1
Received: by mail-qv1-f69.google.com with SMTP id p12-20020a0c9a0c000000b0043299cbbd36so13784426qvd.16
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 07:05:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WWSu3wiWy99oqRDajCtjPLsUAPwXYFjyrn/okc9AKDQ=;
        b=DYPvFKt2TzQtChPQugIPTAYwUh3amj1mQaB7xxg59JMmdnp7wyKd7sUg3aiisV8bwd
         TrgSw/9ukI0J77oJ+dd/z9K2eC7boNZoR6aTvOm9ehl7jxAVSJk+gTV0LWOfsLPPhC4G
         Ag35MoDQE1DY3h+kdVsEN5YvSEpRHDJgmTQUqCAVN8xElmVW4QZqgB0Tk58uilGzus3U
         B3BmnWLyc9z+n9As2lFuStirX2xzWxoDLEsaP309eJYIBl7TCxgQgqBTJ3PMwMsApo9Q
         l6F7S9F/V7wu6NWqpH2t4xs1h//BCE1YgEjZpj2VgqQNjOrBIlB3nVmqPkzgBG6xHhYs
         yZZA==
X-Gm-Message-State: AOAM533q6oQywSX6vgfPHY8bOO70pd58ZAvRSCQbXZNgZlNXE0sMw1jp
        ROZf2JnuVxnjb74JiJrgPtaCsa7OYrAyYFPWCqlHe/0miyo3lMFsxfMm7duVUgl486CaCco6e0V
        FojcupAH2rLJSo1wu
X-Received: by 2002:a05:6214:e87:b0:441:a5d:681c with SMTP id hf7-20020a0562140e8700b004410a5d681cmr12300780qvb.38.1647957907073;
        Tue, 22 Mar 2022 07:05:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8/P7gBREOiebiPL6hs1ySKYG/JtpPyzM46Q58fFbmK5VNi/3+BC5pcuLrkbzn9AowdZrExg==
X-Received: by 2002:a05:6214:e87:b0:441:a5d:681c with SMTP id hf7-20020a0562140e8700b004410a5d681cmr12300737qvb.38.1647957906751;
        Tue, 22 Mar 2022 07:05:06 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id l8-20020a05622a174800b002e1e3f7d4easm14583649qtk.86.2022.03.22.07.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 07:05:06 -0700 (PDT)
Date:   Tue, 22 Mar 2022 15:05:00 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] vsock/virtio: enable VQs early on probe
Message-ID: <20220322140500.bn5yrqj5ljckhcdb@sgarzare-redhat>
References: <20220322103823.83411-1-sgarzare@redhat.com>
 <20220322092723-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220322092723-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 09:36:14AM -0400, Michael S. Tsirkin wrote:
>On Tue, Mar 22, 2022 at 11:38:23AM +0100, Stefano Garzarella wrote:
>> virtio spec requires drivers to set DRIVER_OK before using VQs.
>> This is set automatically after probe returns, but virtio-vsock
>> driver uses VQs in the probe function to fill rx and event VQs
>> with new buffers.
>
>
>So this is a spec violation. absolutely.
>
>> Let's fix this, calling virtio_device_ready() before using VQs
>> in the probe function.
>>
>> Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>  net/vmw_vsock/virtio_transport.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> index 5afc194a58bb..b1962f8cd502 100644
>> --- a/net/vmw_vsock/virtio_transport.c
>> +++ b/net/vmw_vsock/virtio_transport.c
>> @@ -622,6 +622,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>>  	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
>>  	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
>>
>> +	virtio_device_ready(vdev);
>> +
>>  	mutex_lock(&vsock->tx_lock);
>>  	vsock->tx_run = true;
>>  	mutex_unlock(&vsock->tx_lock);
>
>Here's the whole code snippet:
>
>
>        mutex_lock(&vsock->tx_lock);
>        vsock->tx_run = true;
>        mutex_unlock(&vsock->tx_lock);
>
>        mutex_lock(&vsock->rx_lock);
>        virtio_vsock_rx_fill(vsock);
>        vsock->rx_run = true;
>        mutex_unlock(&vsock->rx_lock);
>
>        mutex_lock(&vsock->event_lock);
>        virtio_vsock_event_fill(vsock);
>        vsock->event_run = true;
>        mutex_unlock(&vsock->event_lock);
>
>        if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
>                vsock->seqpacket_allow = true;
>
>        vdev->priv = vsock;
>        rcu_assign_pointer(the_virtio_vsock, vsock);
>
>        mutex_unlock(&the_virtio_vsock_mutex);
>
>
>I worry that this is not the only problem here:
>seqpacket_allow and setting of vdev->priv at least after
>device is active look suspicious.

Right, so if you agree I'll move these before virtio_device_ready().

>E.g.:
>
>static void virtio_vsock_event_done(struct virtqueue *vq)
>{
>        struct virtio_vsock *vsock = vq->vdev->priv;
>
>        if (!vsock)
>                return;
>        queue_work(virtio_vsock_workqueue, &vsock->event_work);
>}
>
>looks like it will miss events now they will be reported earlier.
>One might say that since vq has been kicked it might send
>interrupts earlier too so not a new problem, but
>there's a chance device actually waits until DRIVER_OK
>to start operating.

Yes I see, should I break into 2 patches (one where I move the code 
already present and this one)?

Maybe a single patch is fine since it's the complete solution.

Thank you for the detailed explanation,
Stefano

