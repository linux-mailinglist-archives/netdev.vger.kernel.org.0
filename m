Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380D94E3FA1
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 14:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbiCVNhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 09:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbiCVNhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 09:37:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2DCA7B13A
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 06:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647956181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yEfbx3KDPFlRi9NsR3t9OxuLawKBXpgCccFQfHQvcxA=;
        b=NiQSgX5t4rKEK6e25+vvVswrgluzj7pQqCaQpFqDv5qqDJ12e6bnSoL8KA1rE8k7Mnew+0
        IYannNNRQw+fuKefyrvHxiIQp0q7CwuVZ6btshHbDY78VCjNw2rvVfLpfu4Hy362TMRfhm
        MAV81cjRudpPPlwaKD7IP9qhIpMhMdQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-D0pnsMENP56HNtyDCMpT-A-1; Tue, 22 Mar 2022 09:36:20 -0400
X-MC-Unique: D0pnsMENP56HNtyDCMpT-A-1
Received: by mail-wm1-f69.google.com with SMTP id i65-20020a1c3b44000000b00385c3f3defaso5276617wma.3
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 06:36:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yEfbx3KDPFlRi9NsR3t9OxuLawKBXpgCccFQfHQvcxA=;
        b=03v5CWRJDwnbLhje0mlxCJYPDiwdbnAnmAv5qdBVMf4EPNy9igBf4k0OI0G2R/mVv3
         g8VFvuwQnbgucINkphSZw8hi9Wks9dsEET6VI/clfkZ9WdsY1XGbN31LDRWOpAn0jHZk
         rO2Iux+Gwcew+o1CtHNBpojOkq9g/n7RjZ6P3EGsfKHl1oq0VWH5B6Sf110xtK89Kn7K
         53mqGB+Ztq4cG9YYWj45Non9Gbd5s+2AMw1dwTFxlm67/w8mg/Rjv4aAgVQMadw8dYL9
         ZzIRwSNtXmJYBxDn53pqNR1H+xYxgQUwKRCN7PLTLoZpgTA+XHaL/3+GDtRymtCtBpym
         ZPKg==
X-Gm-Message-State: AOAM531mhGu9aBX4pzv3b6zS335njCLQ1L4CnJyROM4efsoC35ZaEgBd
        F+6K5fmNOjD+1Xy6sPlxyYt/aOx/GzSMg+D4HpLb6Xob6PVIEXq8uzQzXmz1Kdfx+9WNz4an5YS
        2G9goZcD/7YykV+HM
X-Received: by 2002:a5d:5982:0:b0:204:1b19:40da with SMTP id n2-20020a5d5982000000b002041b1940damr6150026wri.23.1647956179332;
        Tue, 22 Mar 2022 06:36:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzt2WiiDuMgW7o4aI8TTeUozv/0SKfKOVFu6npOXGitY0mPpGVzP8XK+kXs7cco7hBpouXLOw==
X-Received: by 2002:a5d:5982:0:b0:204:1b19:40da with SMTP id n2-20020a5d5982000000b002041b1940damr6150004wri.23.1647956179070;
        Tue, 22 Mar 2022 06:36:19 -0700 (PDT)
Received: from redhat.com ([2.55.132.0])
        by smtp.gmail.com with ESMTPSA id q14-20020a1cf30e000000b0038986a18ec8sm1910031wmq.46.2022.03.22.06.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 06:36:18 -0700 (PDT)
Date:   Tue, 22 Mar 2022 09:36:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Asias He <asias@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] vsock/virtio: enable VQs early on probe
Message-ID: <20220322092723-mutt-send-email-mst@kernel.org>
References: <20220322103823.83411-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322103823.83411-1-sgarzare@redhat.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 11:38:23AM +0100, Stefano Garzarella wrote:
> virtio spec requires drivers to set DRIVER_OK before using VQs.
> This is set automatically after probe returns, but virtio-vsock
> driver uses VQs in the probe function to fill rx and event VQs
> with new buffers.


So this is a spec violation. absolutely.

> Let's fix this, calling virtio_device_ready() before using VQs
> in the probe function.
> 
> Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index 5afc194a58bb..b1962f8cd502 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -622,6 +622,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>  	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
>  	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
>  
> +	virtio_device_ready(vdev);
> +
>  	mutex_lock(&vsock->tx_lock);
>  	vsock->tx_run = true;
>  	mutex_unlock(&vsock->tx_lock);

Here's the whole code snippet:


        mutex_lock(&vsock->tx_lock);
        vsock->tx_run = true;
        mutex_unlock(&vsock->tx_lock);

        mutex_lock(&vsock->rx_lock);
        virtio_vsock_rx_fill(vsock);
        vsock->rx_run = true;
        mutex_unlock(&vsock->rx_lock);

        mutex_lock(&vsock->event_lock);
        virtio_vsock_event_fill(vsock);
        vsock->event_run = true;
        mutex_unlock(&vsock->event_lock);

        if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
                vsock->seqpacket_allow = true;

        vdev->priv = vsock;
        rcu_assign_pointer(the_virtio_vsock, vsock);

        mutex_unlock(&the_virtio_vsock_mutex);


I worry that this is not the only problem here:
seqpacket_allow and setting of vdev->priv at least after
device is active look suspicious.
E.g.:

static void virtio_vsock_event_done(struct virtqueue *vq)
{
        struct virtio_vsock *vsock = vq->vdev->priv;

        if (!vsock)
                return;
        queue_work(virtio_vsock_workqueue, &vsock->event_work);
}

looks like it will miss events now they will be reported earlier.
One might say that since vq has been kicked it might send
interrupts earlier too so not a new problem, but
there's a chance device actually waits until DRIVER_OK
to start operating.


> -- 
> 2.35.1

