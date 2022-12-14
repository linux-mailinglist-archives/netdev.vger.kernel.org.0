Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3017A64C78B
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 11:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238090AbiLNK7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 05:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237506AbiLNK7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 05:59:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E4013F1E
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 02:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671015532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bsm8rypiWXXlAJ/OnIAvVOQDlYOOMt1+SaQ7hOIMf78=;
        b=T6CDKCDihF+0BOz/Fb8yhLYxRctXcgmKlxfotPR6NdPFrwq97drZnM5v/rPOEl4cyi+Sld
        ZIy8QF3Gf6MmtN08vjyCC1Lz2tScKY5/4paDrv9Vx01pLksy9/KaedqbU5WD0VcBAhNvBc
        V0gw1mmL4lIITBIilRRHPeuJFdXw+/k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-267-OR725q0vNsaolOXan4Puwg-1; Wed, 14 Dec 2022 05:58:50 -0500
X-MC-Unique: OR725q0vNsaolOXan4Puwg-1
Received: by mail-wm1-f72.google.com with SMTP id i9-20020a1c3b09000000b003d21fa95c38so4273096wma.3
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 02:58:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bsm8rypiWXXlAJ/OnIAvVOQDlYOOMt1+SaQ7hOIMf78=;
        b=Uo35Db6iHmjU9BrRoVcYZYMlXkySCelKwE4As3mv7ihTMlrNYcjv2zXFRfUqtJ2QOz
         xSzCBKmfcsUAJmNb2j8tTdnBilEI032T3Nq5LZYO3sy0PMefiAOTcmi44qa9qario3cQ
         YJJngDra8RA7AmSjTfdYCoHHxCFXSYrsKn2r8XqT3ThJh8BMbvCOt0NJp5tZdxKGbR+I
         ctOGkEU/+e4GabqBGTCvPuSB9kyYV3fQOGzagweVABZvaWOTCgYXRdK3oUVMd4uyuoax
         QQ36dtOFDyH683gdw8BmR8g11jIKJ0cUYBM0ADYwC+Xzt3tTXp6jwB5gz8hrRtwBhTjT
         3maA==
X-Gm-Message-State: ANoB5pkKLVotTfHVD1UbdVoIwf9+zaKZly087hcmhsVpxRXQ8x8W2IVj
        7wkDRzTPpfQggeZKwi6gM6L4ue0C7UN4PqRg5SeCCfQap+VtDepNF/QdRJXrLzYmR/ZZvcJtVlb
        P2YsOOP8/hxEEtPdx
X-Received: by 2002:a05:600c:1c9e:b0:3d2:7a7:5cc6 with SMTP id k30-20020a05600c1c9e00b003d207a75cc6mr16127435wms.18.1671015529756;
        Wed, 14 Dec 2022 02:58:49 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4GhTuy3yFMob3cVWbwQSim+kT62Pp9g1pSNQfJtskVOvtO6CT9jLknO7unhHjf9Ss6p0OSBw==
X-Received: by 2002:a05:600c:1c9e:b0:3d2:7a7:5cc6 with SMTP id k30-20020a05600c1c9e00b003d207a75cc6mr16127414wms.18.1671015529490;
        Wed, 14 Dec 2022 02:58:49 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-97-87.dyn.eolo.it. [146.241.97.87])
        by smtp.gmail.com with ESMTPSA id m17-20020a05600c3b1100b003c6b7f5567csm7893601wms.0.2022.12.14.02.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 02:58:49 -0800 (PST)
Message-ID: <4b66f91f23a3eb91c3232bc68f45bdb799217c40.camel@redhat.com>
Subject: Re: [PATCH net-next v7] virtio/vsock: replace virtio_vsock_pkt with
 sk_buff
From:   Paolo Abeni <pabeni@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 14 Dec 2022 11:58:47 +0100
In-Reply-To: <20221213192843.421032-1-bobby.eshleman@bytedance.com>
References: <20221213192843.421032-1-bobby.eshleman@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-13 at 19:28 +0000, Bobby Eshleman wrote:
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 5703775af129..2a5994b029b2 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -51,8 +51,7 @@ struct vhost_vsock {
>  	struct hlist_node hash;
>  
>  	struct vhost_work send_pkt_work;
> -	spinlock_t send_pkt_list_lock;
> -	struct list_head send_pkt_list;	/* host->guest pending packets */
> +	struct sk_buff_head send_pkt_queue; /* host->guest pending packets */
>  
>  	atomic_t queued_replies;
>  
> @@ -108,40 +107,33 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  	vhost_disable_notify(&vsock->dev, vq);
>  
>  	do {
> -		struct virtio_vsock_pkt *pkt;
> +		struct virtio_vsock_hdr *hdr;
> +		size_t iov_len, payload_len;
>  		struct iov_iter iov_iter;
> +		u32 flags_to_restore = 0;
> +		struct sk_buff *skb;
>  		unsigned out, in;
>  		size_t nbytes;
> -		size_t iov_len, payload_len;
>  		int head;
> -		u32 flags_to_restore = 0;
>  
> -		spin_lock_bh(&vsock->send_pkt_list_lock);
> -		if (list_empty(&vsock->send_pkt_list)) {
> -			spin_unlock_bh(&vsock->send_pkt_list_lock);
> +		spin_lock(&vsock->send_pkt_queue.lock);
> +		skb = __skb_dequeue(&vsock->send_pkt_queue);
> +		spin_unlock(&vsock->send_pkt_queue.lock);

Here you use a plain spin_lock(), but every other lock has the _bh()
variant. A few lines above this functions acquires a mutex, so this is
process context (and not BH context): I guess you should use _bh()
here, too.

[...]

> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index 35d7eedb5e8e..0385df976d41 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -3,10 +3,116 @@
>  #define _LINUX_VIRTIO_VSOCK_H
>  
>  #include <uapi/linux/virtio_vsock.h>
> +#include <linux/bits.h>
>  #include <linux/socket.h>
>  #include <net/sock.h>
>  #include <net/af_vsock.h>
>  
> +#define VIRTIO_VSOCK_SKB_HEADROOM (sizeof(struct virtio_vsock_hdr))
> +
> +enum virtio_vsock_skb_flags {
> +	VIRTIO_VSOCK_SKB_FLAGS_REPLY		= BIT(0),
> +	VIRTIO_VSOCK_SKB_FLAGS_TAP_DELIVERED	= BIT(1),
> +};

It looks like the above enum is not used anymore, you can drop it.

[...]

> @@ -121,20 +108,18 @@ static void vsock_loopback_work(struct work_struct *work)
>  {
>  	struct vsock_loopback *vsock =
>  		container_of(work, struct vsock_loopback, pkt_work);
> -	LIST_HEAD(pkts);
> +	struct sk_buff_head pkts;
> +	struct sk_buff *skb;
> +
> +	skb_queue_head_init(&pkts);
>  
>  	spin_lock_bh(&vsock->pkt_list_lock);
> -	list_splice_init(&vsock->pkt_list, &pkts);
> +	skb_queue_splice_init(&vsock->pkt_queue, &pkts);
>  	spin_unlock_bh(&vsock->pkt_list_lock);
>  
> -	while (!list_empty(&pkts)) {
> -		struct virtio_vsock_pkt *pkt;
> -
> -		pkt = list_first_entry(&pkts, struct virtio_vsock_pkt, list);
> -		list_del_init(&pkt->list);
> -
> -		virtio_transport_deliver_tap_pkt(pkt);
> -		virtio_transport_recv_pkt(&loopback_transport, pkt);
> +	while ((skb = skb_dequeue(&pkts))) {

Minor nit: since this code has complete ownership of the pkts queue,
you can use the lockless dequeue variant here:

	while ((skb = __skb_dequeue(&pkts))) {

> +		virtio_transport_deliver_tap_pkt(skb);
> +		virtio_transport_recv_pkt(&loopback_transport, skb);
>  	}
>  }
>  

Other then that LGTM. @Michael: feel free to take this via your tree,
once that the above feedback has been addressed, thanks!

Paolo

