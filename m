Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A542634527
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 21:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbiKVUHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 15:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiKVUHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 15:07:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1590CA7C1A
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669147610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0xAdJctF6H+O/M4MLLhKCg5TO/+mCew7BZYqlNiSSIs=;
        b=RDRiia6HkKLAQTo4o6OjU/X6ZH0fl7VP5zvjG5KBbm0OJHRpK4NECDLQ4bCI64ICkR1xNs
        PGRz/g8Jan2BeOcGIIh2bDidH5YXLipRGmtBaP0Ta3I+vmlem0xlsGjkjFlDv7i7izc0BI
        5etxIO/2X3jK5I6OrdZDLbH0i3Mbymg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-472-sdeWfsdSMY6kOEELNOQJBg-1; Tue, 22 Nov 2022 15:06:49 -0500
X-MC-Unique: sdeWfsdSMY6kOEELNOQJBg-1
Received: by mail-wm1-f71.google.com with SMTP id i65-20020a1c3b44000000b003d02dc20735so200837wma.0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:06:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0xAdJctF6H+O/M4MLLhKCg5TO/+mCew7BZYqlNiSSIs=;
        b=xN4zmEWL0nqBO3SatQexl1ouUfcOJ7tWzEB7vMHcds0EpYXk6B33WmSpkutMot8u5k
         +pm2n3qvhn8wX8b2edDnn2g7ofei7zEhEke8emrYnPqLNl85vSA8Bmo08qpbVZfno1ZJ
         6Y3XeZQmJ5ywiV546SYjvIw2XjA1n8lrYcuCunuHyOn8W+kd4QJOK8DIRDweUxL+0Gw2
         ndjo5GtaFE9E+55sPPyZTbZKtzBoifP6n4RHkDxNHSg/4nZ9QEtouPy6F3TLuJBe4mD8
         +L7IW0myUEyTUWmL0KQigA736MzLu3UVz3o32zsHE50VSGnXbaL3Mf5HEZOGzAHtcCdP
         c32g==
X-Gm-Message-State: ANoB5pl225O7ueImB0+pnhNuHzfjUY5AVfeJhNQqAeRNSTRgSuNBu4GT
        POF016dv/KFhb/6+3Hf+f2AZXVtoWnxV4KRP42C4i6CuKXv5KmuMjIV6J6q7D+b6iqdEnI4MWWg
        2JSAUDRYsu6fvr7oi
X-Received: by 2002:a05:600c:19d1:b0:3cf:ca1a:332a with SMTP id u17-20020a05600c19d100b003cfca1a332amr21535833wmq.118.1669147607593;
        Tue, 22 Nov 2022 12:06:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7YWFh65HU9KyRpvxonEkQl/n1raz9o7hhsaT5c6a6bnb78L5u0hylpoRzGwVF6Heua+k5RZA==
X-Received: by 2002:a05:600c:19d1:b0:3cf:ca1a:332a with SMTP id u17-20020a05600c19d100b003cfca1a332amr21535811wmq.118.1669147607355;
        Tue, 22 Nov 2022 12:06:47 -0800 (PST)
Received: from redhat.com ([2.52.16.74])
        by smtp.gmail.com with ESMTPSA id c2-20020a05600c0a4200b003cfd4cf0761sm25248305wmq.1.2022.11.22.12.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 12:06:46 -0800 (PST)
Date:   Tue, 22 Nov 2022 15:06:43 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Li Zetao <lizetao1@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, jasowang@redhat.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, rusty@rustcorp.com.au,
        cornelia.huck@de.ibm.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2] virtio_net: Fix probe failed when modprobe virtio_net
Message-ID: <20221122150459-mutt-send-email-mst@kernel.org>
References: <20221121132935.2032325-1-lizetao1@huawei.com>
 <20221122150046.3910638-1-lizetao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122150046.3910638-1-lizetao1@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 11:00:46PM +0800, Li Zetao wrote:
> When doing the following test steps, an error was found:
>   step 1: modprobe virtio_net succeeded
>     # modprobe virtio_net        <-- OK
> 
>   step 2: fault injection in register_netdevice()
>     # modprobe -r virtio_net     <-- OK
>     # ...
>       FAULT_INJECTION: forcing a failure.
>       name failslab, interval 1, probability 0, space 0, times 0
>       CPU: 0 PID: 3521 Comm: modprobe
>       Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>       Call Trace:
>        <TASK>
>        ...
>        should_failslab+0xa/0x20
>        ...
>        dev_set_name+0xc0/0x100
>        netdev_register_kobject+0xc2/0x340
>        register_netdevice+0xbb9/0x1320
>        virtnet_probe+0x1d72/0x2658 [virtio_net]
>        ...
>        </TASK>
>       virtio_net: probe of virtio0 failed with error -22
> 
>   step 3: modprobe virtio_net failed
>     # modprobe virtio_net        <-- failed
>       virtio_net: probe of virtio0 failed with error -2
> 
> The root cause of the problem is that the queues are not
> disable

if you need to resend it:

not disabled

but that's minor, ok to ignore

> on the error handling path when register_netdevice()
> fails in virtnet_probe(), resulting in an error "-ENOENT"
> returned in the next modprobe call in setup_vq().
> 
> virtio_pci_modern_device uses virtqueues to send or
> receive message, and "queue_enable" records whether the
> queues are available. In vp_modern_find_vqs(), all queues
> will be selected and activated, but once queues are enabled
> there is no way to go back except reset.
> 
> Fix it by reset virtio device on error handling path. This
> makes error handling follow the same order as normal device
> cleanup in virtnet_remove() which does: unregister, destroy
> failover, then reset. And that flow is better tested than
> error handling so we can be reasonably sure it works well.
> 
> Fixes: 024655555021 ("virtio_net: fix use after free on allocation failure")
> Signed-off-by: Li Zetao <lizetao1@huawei.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Thanks, LGTM, feel free to merge.



> ---
> v1 was posted at: https://lore.kernel.org/all/20221121132935.2032325-1-lizetao1@huawei.com/
> v1 -> v2: modify commit log and fixes tag
> 
>  drivers/net/virtio_net.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7106932c6f88..86e52454b5b5 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3949,12 +3949,11 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	return 0;
>  
>  free_unregister_netdev:
> -	virtio_reset_device(vdev);
> -
>  	unregister_netdev(dev);
>  free_failover:
>  	net_failover_destroy(vi->failover);
>  free_vqs:
> +	virtio_reset_device(vdev);
>  	cancel_delayed_work_sync(&vi->refill);
>  	free_receive_page_frags(vi);
>  	virtnet_del_vqs(vi);
> -- 
> 2.25.1

