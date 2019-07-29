Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855A178D5F
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 16:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbfG2OEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 10:04:35 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43212 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbfG2OEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 10:04:35 -0400
Received: by mail-qt1-f196.google.com with SMTP id w17so15439809qto.10
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 07:04:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9TGrSWXBSPwHy8jYtphhW0dEmj0QZhEapSIaBCYSsds=;
        b=ReyKO7ynCX4XG7e45B5xtvdUExUeRhz/PzLPt512LnmS7fPWcNdjOY1KGsxTkJluVO
         SEF2kRsf0b+MeGkCJ1nznUin1hf+amcxvb3MmDs8OThMQOhqX3UH1be3B+K6I84UE3DX
         fD+HkHXm1/FDkhRAhIIfG7cEnmfZecsOazcZ2NTLlI8LIgDoijnOAOr4yOXsgstqh6Xv
         JyrTF6MweSGHzYQ0O6tC6/hIbV3Std/w+oTKPrABXbxKqHhFCpbZvD7LF9Q6wGaT7Ua4
         NSdSILR47XWT9cuVJqVqb+N9DH4DzYraoGqKULvnfHZA+pDqGOYEWBi7YtRkRKAgVsBu
         jRzA==
X-Gm-Message-State: APjAAAWtFx1Xqo0kzUu0SgBRMSXVN+8vGNvGSobsxLSXBReJuwe2CeNq
        +FRbAeql5fR2L/6Weq0MACiOCkD3B/GFkg==
X-Google-Smtp-Source: APXvYqxjkWPX2jNn/Dzz4DX/RzsFfIydjYDR0yXBAhz1UUZ7xlpbws8nDmZPX4DMGukA3N0rsbT+uA==
X-Received: by 2002:ac8:333d:: with SMTP id t58mr79478835qta.167.1564409074630;
        Mon, 29 Jul 2019 07:04:34 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id f25sm32100187qta.81.2019.07.29.07.04.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 07:04:33 -0700 (PDT)
Date:   Mon, 29 Jul 2019 10:04:29 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20190729095956-mutt-send-email-mst@kernel.org>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-2-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717113030.163499-2-sgarzare@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 01:30:26PM +0200, Stefano Garzarella wrote:
> Since virtio-vsock was introduced, the buffers filled by the host
> and pushed to the guest using the vring, are directly queued in
> a per-socket list. These buffers are preallocated by the guest
> with a fixed size (4 KB).
> 
> The maximum amount of memory used by each socket should be
> controlled by the credit mechanism.
> The default credit available per-socket is 256 KB, but if we use
> only 1 byte per packet, the guest can queue up to 262144 of 4 KB
> buffers, using up to 1 GB of memory per-socket. In addition, the
> guest will continue to fill the vring with new 4 KB free buffers
> to avoid starvation of other sockets.
> 
> This patch mitigates this issue copying the payload of small
> packets (< 128 bytes) into the buffer of last packet queued, in
> order to avoid wasting memory.
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

This is good enough for net-next, but for net I think we
should figure out how to address the issue completely.
Can we make the accounting precise? What happens to
performance if we do?


> ---
>  drivers/vhost/vsock.c                   |  2 +
>  include/linux/virtio_vsock.h            |  1 +
>  net/vmw_vsock/virtio_transport.c        |  1 +
>  net/vmw_vsock/virtio_transport_common.c | 60 +++++++++++++++++++++----
>  4 files changed, 55 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 6a50e1d0529c..6c8390a2af52 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -329,6 +329,8 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
>  		return NULL;
>  	}
>  
> +	pkt->buf_len = pkt->len;
> +
>  	nbytes = copy_from_iter(pkt->buf, pkt->len, &iov_iter);
>  	if (nbytes != pkt->len) {
>  		vq_err(vq, "Expected %u byte payload, got %zu bytes\n",
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index e223e2632edd..7d973903f52e 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -52,6 +52,7 @@ struct virtio_vsock_pkt {
>  	/* socket refcnt not held, only use for cancellation */
>  	struct vsock_sock *vsk;
>  	void *buf;
> +	u32 buf_len;
>  	u32 len;
>  	u32 off;
>  	bool reply;
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index 0815d1357861..082a30936690 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -307,6 +307,7 @@ static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
>  			break;
>  		}
>  
> +		pkt->buf_len = buf_len;
>  		pkt->len = buf_len;
>  
>  		sg_init_one(&hdr, &pkt->hdr, sizeof(pkt->hdr));
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 6f1a8aff65c5..095221f94786 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -26,6 +26,9 @@
>  /* How long to wait for graceful shutdown of a connection */
>  #define VSOCK_CLOSE_TIMEOUT (8 * HZ)
>  
> +/* Threshold for detecting small packets to copy */
> +#define GOOD_COPY_LEN  128
> +
>  static const struct virtio_transport *virtio_transport_get_ops(void)
>  {
>  	const struct vsock_transport *t = vsock_core_get_transport();
> @@ -64,6 +67,9 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
>  		pkt->buf = kmalloc(len, GFP_KERNEL);
>  		if (!pkt->buf)
>  			goto out_pkt;
> +
> +		pkt->buf_len = len;
> +
>  		err = memcpy_from_msg(pkt->buf, info->msg, len);
>  		if (err)
>  			goto out;
> @@ -841,24 +847,60 @@ virtio_transport_recv_connecting(struct sock *sk,
>  	return err;
>  }
>  
> +static void
> +virtio_transport_recv_enqueue(struct vsock_sock *vsk,
> +			      struct virtio_vsock_pkt *pkt)
> +{
> +	struct virtio_vsock_sock *vvs = vsk->trans;
> +	bool free_pkt = false;
> +
> +	pkt->len = le32_to_cpu(pkt->hdr.len);
> +	pkt->off = 0;
> +
> +	spin_lock_bh(&vvs->rx_lock);
> +
> +	virtio_transport_inc_rx_pkt(vvs, pkt);
> +
> +	/* Try to copy small packets into the buffer of last packet queued,
> +	 * to avoid wasting memory queueing the entire buffer with a small
> +	 * payload.
> +	 */
> +	if (pkt->len <= GOOD_COPY_LEN && !list_empty(&vvs->rx_queue)) {
> +		struct virtio_vsock_pkt *last_pkt;
> +
> +		last_pkt = list_last_entry(&vvs->rx_queue,
> +					   struct virtio_vsock_pkt, list);
> +
> +		/* If there is space in the last packet queued, we copy the
> +		 * new packet in its buffer.
> +		 */
> +		if (pkt->len <= last_pkt->buf_len - last_pkt->len) {
> +			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
> +			       pkt->len);
> +			last_pkt->len += pkt->len;
> +			free_pkt = true;
> +			goto out;
> +		}
> +	}
> +
> +	list_add_tail(&pkt->list, &vvs->rx_queue);
> +
> +out:
> +	spin_unlock_bh(&vvs->rx_lock);
> +	if (free_pkt)
> +		virtio_transport_free_pkt(pkt);
> +}
> +
>  static int
>  virtio_transport_recv_connected(struct sock *sk,
>  				struct virtio_vsock_pkt *pkt)
>  {
>  	struct vsock_sock *vsk = vsock_sk(sk);
> -	struct virtio_vsock_sock *vvs = vsk->trans;
>  	int err = 0;
>  
>  	switch (le16_to_cpu(pkt->hdr.op)) {
>  	case VIRTIO_VSOCK_OP_RW:
> -		pkt->len = le32_to_cpu(pkt->hdr.len);
> -		pkt->off = 0;
> -
> -		spin_lock_bh(&vvs->rx_lock);
> -		virtio_transport_inc_rx_pkt(vvs, pkt);
> -		list_add_tail(&pkt->list, &vvs->rx_queue);
> -		spin_unlock_bh(&vvs->rx_lock);
> -
> +		virtio_transport_recv_enqueue(vsk, pkt);
>  		sk->sk_data_ready(sk);
>  		return err;
>  	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
> -- 
> 2.20.1
