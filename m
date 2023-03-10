Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09A66B39BA
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 10:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbjCJJLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 04:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbjCJJKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 04:10:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAD87604B
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678439070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=46gl8Ai7V7dH+MCugjXS8UMr3cPoA8v6IdWxTjz1/ig=;
        b=hRekxHOlcmUp1LcugywHt9dQfLJNOA9VIRg+8EubQ8SkX1xwPWQA9Km3Z/8szXvhfS7xw0
        h7ZtH+4XwnOJ8gLw6BEySSx6hGikCLf6aofYN3C5qjglZIfPTntxXBJ3gDPBNZVX908uZZ
        TYl0cXmo8seqvHkAD6xMsAGg0LU9llc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-3wSYPcKsMZ2koWftqS9liw-1; Fri, 10 Mar 2023 04:04:26 -0500
X-MC-Unique: 3wSYPcKsMZ2koWftqS9liw-1
Received: by mail-wm1-f71.google.com with SMTP id x18-20020a1c7c12000000b003e1e7d3cf9fso3584027wmc.3
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:04:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678439065;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46gl8Ai7V7dH+MCugjXS8UMr3cPoA8v6IdWxTjz1/ig=;
        b=6jk/4MTLxWN+zDTFG8qFP9Rw9aZyyu8XsAWSWXkA9B/crrXAcxFuihvuGuOba7qHtm
         0L0OWxDYvXlwNZqszkM9dl6KPBcgDbZpzZw4nLI+djnOusrKov91TD9v4gbujPLK3c3A
         yPn4WXNS/yrV5a5I9Dj6i8WVYeAvlO8x1zydRID6562X1g9vzma13r37D+6pab8/Vwbg
         fjyGWc4Zhtte0L2KKoMM9LxdgrV4DFEoEBR+x4UQY+U2TQZKjlgU1j4YaMiZinztuoxX
         2IzvfRMK5s/IDykhlcnECt5p50UZHrIsum0ZHmvbrGGBbKJAxCXq2wVPwqouIZtCo0yW
         reCg==
X-Gm-Message-State: AO0yUKUXoLtX7VfK0CHm5B5mV74Cb1cV7skyaMLPBP3VgMJXquUQOpxk
        GmnJ9LprhKuXu9jHua9+JIwo/0eTe5YCdNFHEeXE4NeIiE73WfZ5Vq6GRjwyUBFj6hCZcheJ9bR
        Won8Qz13X/a63OfIO
X-Received: by 2002:a5d:4b46:0:b0:2cb:72c2:3d12 with SMTP id w6-20020a5d4b46000000b002cb72c23d12mr14641285wrs.68.1678439065789;
        Fri, 10 Mar 2023 01:04:25 -0800 (PST)
X-Google-Smtp-Source: AK7set+Dj7EXVbKf4FaIRS7+hywjAPjXzlp5ChAxftqM7LqGTf3r7oKcF/ohX5pthjzSPMHrz72DBg==
X-Received: by 2002:a5d:4b46:0:b0:2cb:72c2:3d12 with SMTP id w6-20020a5d4b46000000b002cb72c23d12mr14641264wrs.68.1678439065444;
        Fri, 10 Mar 2023 01:04:25 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id o18-20020a056000011200b002c559def236sm1592840wrx.57.2023.03.10.01.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 01:04:24 -0800 (PST)
Date:   Fri, 10 Mar 2023 10:04:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 1/4] virtio/vsock: don't use skbuff state to
 account credit
Message-ID: <20230310090422.ybe72rkciekbit2g@sgarzare-redhat>
References: <1804d100-1652-d463-8627-da93cb61144e@sberdevices.ru>
 <71a296ad-6619-c8e6-14a1-9423ac2e4841@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <71a296ad-6619-c8e6-14a1-9423ac2e4841@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 11:26:00PM +0300, Arseniy Krasnov wrote:
>'skb->len' can vary when we partially read the data, this complicates the
>calculation of credit to be updated in 'virtio_transport_inc_rx_pkt()/
>virtio_transport_dec_rx_pkt()'.
>
>Also in 'virtio_transport_dec_rx_pkt()' we were miscalculating the
>credit since 'skb->len' was redundant.
>
>For these reasons, let's replace the use of skbuff state to calculate new
>'rx_bytes'/'fwd_cnt' values with explicit value as input argument. This
>makes code more simple, because it is not needed to change skbuff state
>before each call to update 'rx_bytes'/'fwd_cnt'.
>
>Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 23 +++++++++++------------
> 1 file changed, 11 insertions(+), 12 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index a1581c77cf84..618680fd9906 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -241,21 +241,18 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> }
>
> static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
>-					struct sk_buff *skb)
>+					u32 len)
> {
>-	if (vvs->rx_bytes + skb->len > vvs->buf_alloc)
>+	if (vvs->rx_bytes + len > vvs->buf_alloc)
> 		return false;
>
>-	vvs->rx_bytes += skb->len;
>+	vvs->rx_bytes += len;
> 	return true;
> }
>
> static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
>-					struct sk_buff *skb)
>+					u32 len)
> {
>-	int len;
>-
>-	len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr) - skb->len;
> 	vvs->rx_bytes -= len;
> 	vvs->fwd_cnt += len;
> }
>@@ -388,7 +385,9 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 		skb_pull(skb, bytes);
>
> 		if (skb->len == 0) {
>-			virtio_transport_dec_rx_pkt(vvs, skb);
>+			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
>+
>+			virtio_transport_dec_rx_pkt(vvs, pkt_len);
> 			consume_skb(skb);
> 		} else {
> 			__skb_queue_head(&vvs->rx_queue, skb);
>@@ -437,17 +436,17 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>
> 	while (!msg_ready) {
> 		struct virtio_vsock_hdr *hdr;
>+		size_t pkt_len;
>
> 		skb = __skb_dequeue(&vvs->rx_queue);
> 		if (!skb)
> 			break;
> 		hdr = virtio_vsock_hdr(skb);
>+		pkt_len = (size_t)le32_to_cpu(hdr->len);
>
> 		if (dequeued_len >= 0) {
>-			size_t pkt_len;
> 			size_t bytes_to_copy;
>
>-			pkt_len = (size_t)le32_to_cpu(hdr->len);
> 			bytes_to_copy = min(user_buf_len, pkt_len);
>
> 			if (bytes_to_copy) {
>@@ -484,7 +483,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 				msg->msg_flags |= MSG_EOR;
> 		}
>
>-		virtio_transport_dec_rx_pkt(vvs, skb);
>+		virtio_transport_dec_rx_pkt(vvs, pkt_len);
> 		kfree_skb(skb);
> 	}
>
>@@ -1040,7 +1039,7 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>
> 	spin_lock_bh(&vvs->rx_lock);
>
>-	can_enqueue = virtio_transport_inc_rx_pkt(vvs, skb);
>+	can_enqueue = virtio_transport_inc_rx_pkt(vvs, len);
> 	if (!can_enqueue) {
> 		free_pkt = true;
> 		goto out;
>-- 
>2.25.1
>

