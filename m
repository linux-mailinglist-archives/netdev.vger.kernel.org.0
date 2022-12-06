Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9120C64412C
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbiLFKV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiLFKVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:21:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6A5BE09
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670322029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jHrzc7nXr4YvCNaFmiJ1lG1BHgrUaPmAIMwaF5/OBO4=;
        b=WSb9TPf/XHVYiQ9DqQPamakc2PzVPqdFx1QSBqVQzpvjMM5WbMuQOgrGKt4F07NQjmwvEg
        lLQ7woBJ+RivoI6jCluwcrxQhzVvgdXhGbmXPHfKMBMz5Eb4sux+VB3rLly0qRcLVMhAhI
        v0BOBq6J8r60YPXFzveHvRVR2SazhBY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-382-Ujdr0hLnNFWBONVMq7LBng-1; Tue, 06 Dec 2022 05:20:28 -0500
X-MC-Unique: Ujdr0hLnNFWBONVMq7LBng-1
Received: by mail-qk1-f199.google.com with SMTP id s7-20020a05620a0bc700b006fcb1a3bb9dso12950848qki.15
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 02:20:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jHrzc7nXr4YvCNaFmiJ1lG1BHgrUaPmAIMwaF5/OBO4=;
        b=sDvXEIJY2wZZiC/gqZYSwb35jgiP3BOoyL32GqYA9W+3ehMfQ6SMT6z9NQO9PRqEsd
         4Fvx6/n5eyPj3qPV+OexneCBuQ+SsNzuGf4dF1/dh0ctY0XO37YxF2JhFQfmVN8olnOJ
         bChZdbCD3cnzJdmV/d6fLid5IJmx+omDP4hYe6KJZmGLQHGvGbSWOpBtG2r+Keu2Lu99
         8WScllGdQVwB0GXYPeOhJr309dmyHLbN/rCc/mpjIQ0fWAWfvUAVkp7Hli2checQ1E9s
         +A3vKmFRNke7BGq4TYNFdUQ1zhQ0y/3IRMMrCEOAmDrSCNDVanYcxVZvTUQ8uh7RIIb7
         Gg7g==
X-Gm-Message-State: ANoB5pnOCyf8lOLEuW4+N3TjhpLv7dQb62QRJkNOO04EtpYvb8cChuk9
        NkpHgLxEf40shFL2bGzoPjKXq3iDUJ/cessxzNfcQpCERgqZm+OuOg9vMNI4a9qAY/u7KuoMJV/
        ploZm6VchWjkdfRzy
X-Received: by 2002:a05:622a:4017:b0:3a5:4f7e:bab2 with SMTP id cf23-20020a05622a401700b003a54f7ebab2mr64363593qtb.527.1670322026694;
        Tue, 06 Dec 2022 02:20:26 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5qvnmSSJhD7XhInjAoVoAZX/6OMJ6iTD3rm9lH6Om7UxRSOVZ1bSbEKEISqvQ5FcAl/6HHWQ==
X-Received: by 2002:a05:622a:4017:b0:3a5:4f7e:bab2 with SMTP id cf23-20020a05622a401700b003a54f7ebab2mr64363575qtb.527.1670322026401;
        Tue, 06 Dec 2022 02:20:26 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-106-100.dyn.eolo.it. [146.241.106.100])
        by smtp.gmail.com with ESMTPSA id bi6-20020a05620a318600b006fa16fe93bbsm14341627qkb.15.2022.12.06.02.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 02:20:26 -0800 (PST)
Message-ID: <863a58452b4a4c0d63a41b0f78b59d32919067fa.camel@redhat.com>
Subject: Re: [PATCH v5] virtio/vsock: replace virtio_vsock_pkt with sk_buff
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
Date:   Tue, 06 Dec 2022 11:20:21 +0100
In-Reply-To: <20221202173520.10428-1-bobby.eshleman@bytedance.com>
References: <20221202173520.10428-1-bobby.eshleman@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2022-12-02 at 09:35 -0800, Bobby Eshleman wrote:
[...]
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index 35d7eedb5e8e..6c0b2d4da3fe 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -3,10 +3,129 @@
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
> +
> +static inline struct virtio_vsock_hdr *virtio_vsock_hdr(struct sk_buff *skb)
> +{
> +	return (struct virtio_vsock_hdr *)skb->head;
> +}
> +
> +static inline bool virtio_vsock_skb_reply(struct sk_buff *skb)
> +{
> +	return skb->_skb_refdst & VIRTIO_VSOCK_SKB_FLAGS_REPLY;
> +}

I'm sorry for the late feedback. The above is extremelly risky: if the
skb will land later into the networking stack, we could experience the
most difficult to track bugs.

You should use the skb control buffer instead (skb->cb), with the
additional benefit you could use e.g. bool - the compiler could emit
better code to manipulate such fields - and you will not need to clear
the field before release nor enqueue.

[...]

> @@ -352,37 +360,38 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>  				   size_t len)
>  {
>  	struct virtio_vsock_sock *vvs = vsk->trans;
> -	struct virtio_vsock_pkt *pkt;
>  	size_t bytes, total = 0;
> -	u32 free_space;
> +	struct sk_buff *skb;
>  	int err = -EFAULT;
> +	u32 free_space;
>  
>  	spin_lock_bh(&vvs->rx_lock);
> -	while (total < len && !list_empty(&vvs->rx_queue)) {
> -		pkt = list_first_entry(&vvs->rx_queue,
> -				       struct virtio_vsock_pkt, list);
> +	while (total < len && !skb_queue_empty_lockless(&vvs->rx_queue)) {
> +		skb = __skb_dequeue(&vvs->rx_queue);

Here the locking schema is confusing. It looks like vvs->rx_queue is
under vvs->rx_lock protection, so the above should be skb_queue_empty()
instead of the lockless variant.

[...]

> @@ -858,16 +873,11 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
>  static void virtio_transport_remove_sock(struct vsock_sock *vsk)
>  {
>  	struct virtio_vsock_sock *vvs = vsk->trans;
> -	struct virtio_vsock_pkt *pkt, *tmp;
>  
>  	/* We don't need to take rx_lock, as the socket is closing and we are
>  	 * removing it.
>  	 */
> -	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
> -		list_del(&pkt->list);
> -		virtio_transport_free_pkt(pkt);
> -	}
> -
> +	virtio_vsock_skb_queue_purge(&vvs->rx_queue);

Still assuming rx_queue is under the rx_lock, given you don't need the
locking here as per the above comment, you should use the lockless
purge variant.

Thanks!

Paolo

