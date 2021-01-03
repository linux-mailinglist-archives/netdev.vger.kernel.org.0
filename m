Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86772E8E61
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 22:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbhACVR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 16:17:26 -0500
Received: from forward102o.mail.yandex.net ([37.140.190.182]:45763 "EHLO
        forward102o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725840AbhACVR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 16:17:26 -0500
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jan 2021 16:17:18 EST
Received: from myt6-f96510cd1fe5.qloud-c.yandex.net (myt6-f96510cd1fe5.qloud-c.yandex.net [IPv6:2a02:6b8:c12:4e12:0:640:f965:10cd])
        by forward102o.mail.yandex.net (Yandex) with ESMTP id 64D006680722;
        Mon,  4 Jan 2021 00:08:00 +0300 (MSK)
Received: from myt6-9bdf92ffd111.qloud-c.yandex.net (myt6-9bdf92ffd111.qloud-c.yandex.net [2a02:6b8:c12:468a:0:640:9bdf:92ff])
        by myt6-f96510cd1fe5.qloud-c.yandex.net (mxback/Yandex) with ESMTP id xtMZzzjGWj-7xD4BftO;
        Mon, 04 Jan 2021 00:08:00 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1609708080;
        bh=XiaicodhoYFuIG+rOfciMRGEj/GcD4dlWHqXqZD9+Lo=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=HLHaEqhKitJRy0+RcvhCFkAh6ji6HN5vLChOKSHwkIHjSUnQCJOXRQDrsxy0sxUAe
         ay8HRfmPdboV5UVXQoveRNINi3p7eBc426nt3F0etCxG/+QwtV4s/SHwdnrfgGFCcJ
         PwRwGavy350F3sYMRNOdRdMpTvzGtlkU8rvQj2jE=
Authentication-Results: myt6-f96510cd1fe5.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt6-9bdf92ffd111.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id kyj9Hze314-7wImZqo4;
        Mon, 04 Jan 2021 00:07:58 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH 1/5] vsock/virtio: support for SOCK_SEQPACKET socket.
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arseniy Krasnov <oxffffaa@gmail.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210103195454.1954169-1-arseny.krasnov@kaspersky.com>
 <20210103195752.1954958-1-arseny.krasnov@kaspersky.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <4ef8fa37-df76-e3bc-3f5c-ed4392f509ad@yandex.ru>
Date:   Mon, 4 Jan 2021 00:07:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210103195752.1954958-1-arseny.krasnov@kaspersky.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

03.01.2021 22:57, Arseny Krasnov пишет:
> 	This extends rx loop for SOCK_SEQPACKET packets and implements
> callback which user calls to copy data to its buffer.
>
> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
> ---
>   include/linux/virtio_vsock.h            |   7 +
>   include/net/af_vsock.h                  |   4 +
>   include/uapi/linux/virtio_vsock.h       |   9 +
>   net/vmw_vsock/virtio_transport.c        |   3 +
>   net/vmw_vsock/virtio_transport_common.c | 323 +++++++++++++++++++++---
>   5 files changed, 305 insertions(+), 41 deletions(-)
>
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index dc636b727179..4902d71b3252 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -36,6 +36,10 @@ struct virtio_vsock_sock {
>   	u32 rx_bytes;
>   	u32 buf_alloc;
>   	struct list_head rx_queue;
> +
> +	/* For SOCK_SEQPACKET */
> +	u32 user_read_seq_len;
> +	u32 user_read_copied;
>   };
>   
>   struct virtio_vsock_pkt {
> @@ -80,6 +84,9 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>   			       struct msghdr *msg,
>   			       size_t len, int flags);
>   
> +bool virtio_transport_seqpacket_seq_send_len(struct vsock_sock *vsk, size_t len);
> +size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk);
> +
>   s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
>   s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>   
> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> index b1c717286993..792ea7b66574 100644
> --- a/include/net/af_vsock.h
> +++ b/include/net/af_vsock.h
> @@ -135,6 +135,10 @@ struct vsock_transport {
>   	bool (*stream_is_active)(struct vsock_sock *);
>   	bool (*stream_allow)(u32 cid, u32 port);
>   
> +	/* SEQ_PACKET. */
> +	bool (*seqpacket_seq_send_len)(struct vsock_sock *, size_t len);
> +	size_t (*seqpacket_seq_get_len)(struct vsock_sock *);
> +
>   	/* Notification. */
>   	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
>   	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
> index 1d57ed3d84d2..058908bc19fc 100644
> --- a/include/uapi/linux/virtio_vsock.h
> +++ b/include/uapi/linux/virtio_vsock.h
> @@ -65,6 +65,7 @@ struct virtio_vsock_hdr {
>   
>   enum virtio_vsock_type {
>   	VIRTIO_VSOCK_TYPE_STREAM = 1,
> +	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
>   };
>   
>   enum virtio_vsock_op {
> @@ -83,6 +84,9 @@ enum virtio_vsock_op {
>   	VIRTIO_VSOCK_OP_CREDIT_UPDATE = 6,
>   	/* Request the peer to send the credit info to us */
>   	VIRTIO_VSOCK_OP_CREDIT_REQUEST = 7,
> +
> +	/* Record begin for SOCK_SEQPACKET */
> +	VIRTIO_VSOCK_OP_SEQ_BEGIN = 8,
>   };
>   
>   /* VIRTIO_VSOCK_OP_SHUTDOWN flags values */
> @@ -91,4 +95,9 @@ enum virtio_vsock_shutdown {
>   	VIRTIO_VSOCK_SHUTDOWN_SEND = 2,
>   };
>   
> +/* VIRTIO_VSOCK_OP_RW flags values for SOCK_SEQPACKET type */
> +enum virtio_vsock_rw_seqpacket {
> +	VIRTIO_VSOCK_RW_EOR = 1,
> +};
> +
>   #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index 2700a63ab095..2bd3f7cbffcb 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -469,6 +469,9 @@ static struct virtio_transport virtio_transport = {
>   		.stream_is_active         = virtio_transport_stream_is_active,
>   		.stream_allow             = virtio_transport_stream_allow,
>   
> +		.seqpacket_seq_send_len	  = virtio_transport_seqpacket_seq_send_len,
> +		.seqpacket_seq_get_len	  = virtio_transport_seqpacket_seq_get_len,
> +
>   		.notify_poll_in           = virtio_transport_notify_poll_in,
>   		.notify_poll_out          = virtio_transport_notify_poll_out,
>   		.notify_recv_init         = virtio_transport_notify_recv_init,
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 5956939eebb7..77c42004e422 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -139,6 +139,7 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
>   		break;
>   	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
>   	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:
> +	case VIRTIO_VSOCK_OP_SEQ_BEGIN:
>   		hdr->op = cpu_to_le16(AF_VSOCK_OP_CONTROL);
>   		break;
>   	default:
> @@ -157,6 +158,10 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
>   
>   void virtio_transport_deliver_tap_pkt(struct virtio_vsock_pkt *pkt)
>   {
> +	/* TODO: implement tap support for SOCK_SEQPACKET. */
> +	if (le32_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_SEQPACKET)
> +		return;
> +
>   	if (pkt->tap_delivered)
>   		return;
>   
> @@ -230,10 +235,10 @@ static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
>   }
>   
>   static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
> -					struct virtio_vsock_pkt *pkt)
> +					u32 len)
>   {
> -	vvs->rx_bytes -= pkt->len;
> -	vvs->fwd_cnt += pkt->len;
> +	vvs->rx_bytes -= len;
> +	vvs->fwd_cnt += len;
>   }
>   
>   void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct virtio_vsock_pkt *pkt)
> @@ -365,7 +370,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>   		total += bytes;
>   		pkt->off += bytes;
>   		if (pkt->off == pkt->len) {
> -			virtio_transport_dec_rx_pkt(vvs, pkt);
> +			virtio_transport_dec_rx_pkt(vvs, pkt->len);
>   			list_del(&pkt->list);
>   			virtio_transport_free_pkt(pkt);
>   		}
> @@ -397,15 +402,202 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>   	return err;
>   }
>   
> +static u16 virtio_transport_get_type(struct sock *sk)
> +{
> +	if (sk->sk_type == SOCK_STREAM)
> +		return VIRTIO_VSOCK_TYPE_STREAM;
> +	else
> +		return VIRTIO_VSOCK_TYPE_SEQPACKET;
> +}
> +
> +bool virtio_transport_seqpacket_seq_send_len(struct vsock_sock *vsk, size_t len)
> +{
> +	struct virtio_vsock_pkt_info info = {
> +		.type = VIRTIO_VSOCK_TYPE_SEQPACKET,
> +		.op = VIRTIO_VSOCK_OP_SEQ_BEGIN,
> +		.vsk = vsk,
> +		.flags = len
> +	};
> +
> +	return virtio_transport_send_pkt_info(vsk, &info);
> +}
> +EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_seq_send_len);
> +
> +static inline void virtio_transport_del_n_free_pkt(struct virtio_vsock_pkt *pkt)
> +{
> +	list_del(&pkt->list);
> +	virtio_transport_free_pkt(pkt);
> +}
> +
> +static size_t virtio_transport_drop_until_seq_begin(struct virtio_vsock_sock *vvs)
> +{
> +	struct virtio_vsock_pkt *pkt, *n;
> +	size_t bytes_dropped = 0;
> +
> +	list_for_each_entry_safe(pkt, n, &vvs->rx_queue, list) {
> +		if (le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_SEQ_BEGIN)
> +			break;
> +
> +		bytes_dropped += le32_to_cpu(pkt->hdr.len);
> +		virtio_transport_dec_rx_pkt(vvs, pkt->len);
> +		virtio_transport_del_n_free_pkt(pkt);
> +	}
> +
> +	return bytes_dropped;
> +}
> +
> +size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk)
> +{
> +	struct virtio_vsock_sock *vvs = vsk->trans;
> +	struct virtio_vsock_pkt *pkt;
> +	size_t bytes_dropped;
> +
> +	spin_lock_bh(&vvs->rx_lock);
> +
> +	/* Fetch all orphaned 'RW', packets, and
> +	 * send credit update.
> +	 */
> +	bytes_dropped = virtio_transport_drop_until_seq_begin(vvs);
> +
> +	if (list_empty(&vvs->rx_queue))
> +		goto out;
> +
> +	pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
> +
> +	vvs->user_read_copied = 0;
> +	vvs->user_read_seq_len = le32_to_cpu(pkt->hdr.flags);
> +	virtio_transport_del_n_free_pkt(pkt);
> +out:
> +	spin_unlock_bh(&vvs->rx_lock);
> +
> +	if (bytes_dropped)
> +		virtio_transport_send_credit_update(vsk,
> +						    VIRTIO_VSOCK_TYPE_SEQPACKET,
> +						    NULL);
> +
> +	return vvs->user_read_seq_len;
> +}
> +EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_seq_get_len);
> +
> +static ssize_t virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> +						     struct msghdr *msg,
> +						     size_t user_buf_len)
> +{
> +	struct virtio_vsock_sock *vvs = vsk->trans;
> +	struct virtio_vsock_pkt *pkt;
> +	size_t bytes_handled = 0;
> +	int err = 0;
> +
> +	spin_lock_bh(&vvs->rx_lock);
> +
> +	if (user_buf_len == 0) {
IMHO you can avoid this special-casing
by introducing yet another outer loop just
for draining the extra data from buffer.
Admittedly that may also require an extra
transport op.

> +		/* User's buffer is full, we processing rest of
> +		 * record and drop it. If 'SEQ_BEGIN' is found
> +		 * while iterating, user will be woken up,
> +		 * because record is already copied, and we
> +		 * don't care about absent of some tail RW packets
> +		 * of it. Return number of bytes(rest of record),
> +		 * but ignore credit update for such absent bytes.
> +		 */
> +		bytes_handled = virtio_transport_drop_until_seq_begin(vvs);
> +		vvs->user_read_copied += bytes_handled;
> +
> +		if (!list_empty(&vvs->rx_queue) &&
> +		    vvs->user_read_copied < vvs->user_read_seq_len) {
> +			/* 'SEQ_BEGIN' found, but record isn't complete.
> +			 * Set number of copied bytes to fit record size
> +			 * and force counters to finish receiving.
> +			 */
> +			bytes_handled += (vvs->user_read_seq_len - vvs->user_read_copied);
> +			vvs->user_read_copied = vvs->user_read_seq_len;
> +		}
> +	}
> +
> +	/* Now start copying. */
> +	while (vvs->user_read_copied < vvs->user_read_seq_len &&
> +	       vvs->rx_bytes &&
> +	       user_buf_len &&
> +	       !err) {
> +		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
> +
> +		switch (le16_to_cpu(pkt->hdr.op)) {
> +		case VIRTIO_VSOCK_OP_SEQ_BEGIN: {
> +			/* Unexpected 'SEQ_BEGIN' during record copy:
> +			 * Leave receive loop, 'EAGAIN' will restart it from
> +			 * outer receive loop, packet is still in queue and
> +			 * counters are cleared. So in next loop enter,
> +			 * 'SEQ_BEGIN' will be dequeued first. User's iov
> +			 * iterator will be reset in outer loop. Also
> +			 * send credit update, because some bytes could be
> +			 * copied. User will never see unfinished record.
> +			 */
> +			err = -EAGAIN;
> +			break;
> +		}
> +		case VIRTIO_VSOCK_OP_RW: {
> +			size_t bytes_to_copy;
> +			size_t pkt_len;
> +
> +			pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
> +			bytes_to_copy = min(user_buf_len, pkt_len);
> +
> +			/* sk_lock is held by caller so no one else can dequeue.
> +			 * Unlock rx_lock since memcpy_to_msg() may sleep.
> +			 */
> +			spin_unlock_bh(&vvs->rx_lock);
> +
> +			if (memcpy_to_msg(msg, pkt->buf, bytes_to_copy)) {
> +				spin_lock_bh(&vvs->rx_lock);
> +				err = -EINVAL;
> +				break;
> +			}
> +
> +			spin_lock_bh(&vvs->rx_lock);
> +			user_buf_len -= bytes_to_copy;
> +			bytes_handled += pkt->len;
> +			vvs->user_read_copied += bytes_to_copy;
> +
> +			if (le16_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_RW_EOR)
> +				msg->msg_flags |= MSG_EOR;
> +			break;
> +		}
> +		default:
> +			;
> +		}
> +
> +		/* For unexpected 'SEQ_BEGIN', keep such packet in queue,
> +		 * but drop any other type of packet.
> +		 */
> +		if (le16_to_cpu(pkt->hdr.op) != VIRTIO_VSOCK_OP_SEQ_BEGIN) {
> +			virtio_transport_dec_rx_pkt(vvs, pkt->len);
> +			virtio_transport_del_n_free_pkt(pkt);
> +		}
> +	}
> +
> +	spin_unlock_bh(&vvs->rx_lock);
> +
> +	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_SEQPACKET,
> +					    NULL);
> +
> +	return err ?: bytes_handled;
> +}
> +
>   ssize_t
>   virtio_transport_stream_dequeue(struct vsock_sock *vsk,
>   				struct msghdr *msg,
>   				size_t len, int flags)
>   {
> -	if (flags & MSG_PEEK)
> -		return virtio_transport_stream_do_peek(vsk, msg, len);
> -	else
> +	if (virtio_transport_get_type(sk_vsock(vsk)) == VIRTIO_VSOCK_TYPE_SEQPACKET) {
> +		if (flags & MSG_PEEK)
> +			return -EOPNOTSUPP;
> +
> +		return virtio_transport_seqpacket_do_dequeue(vsk, msg, len);
> +	} else {
> +		if (flags & MSG_PEEK)
> +			return virtio_transport_stream_do_peek(vsk, msg, len);
> +
>   		return virtio_transport_stream_do_dequeue(vsk, msg, len);
> +	}
>   }
>   EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
>   
> @@ -481,6 +673,8 @@ int virtio_transport_do_socket_init(struct vsock_sock *vsk,
>   	spin_lock_init(&vvs->rx_lock);
>   	spin_lock_init(&vvs->tx_lock);
>   	INIT_LIST_HEAD(&vvs->rx_queue);
> +	vvs->user_read_copied = 0;
> +	vvs->user_read_seq_len = 0;
>   
>   	return 0;
>   }
> @@ -490,13 +684,16 @@ EXPORT_SYMBOL_GPL(virtio_transport_do_socket_init);
>   void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val)
>   {
>   	struct virtio_vsock_sock *vvs = vsk->trans;
> +	int type;
>   
>   	if (*val > VIRTIO_VSOCK_MAX_BUF_SIZE)
>   		*val = VIRTIO_VSOCK_MAX_BUF_SIZE;
>   
>   	vvs->buf_alloc = *val;
>   
> -	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_STREAM,
> +	type = virtio_transport_get_type(sk_vsock(vsk));
> +
> +	virtio_transport_send_credit_update(vsk, type,
>   					    NULL);
>   }
>   EXPORT_SYMBOL_GPL(virtio_transport_notify_buffer_size);
> @@ -624,10 +821,11 @@ int virtio_transport_connect(struct vsock_sock *vsk)
>   {
>   	struct virtio_vsock_pkt_info info = {
>   		.op = VIRTIO_VSOCK_OP_REQUEST,
> -		.type = VIRTIO_VSOCK_TYPE_STREAM,
>   		.vsk = vsk,
>   	};
>   
> +	info.type = virtio_transport_get_type(sk_vsock(vsk));
> +
>   	return virtio_transport_send_pkt_info(vsk, &info);
>   }
>   EXPORT_SYMBOL_GPL(virtio_transport_connect);
> @@ -636,7 +834,6 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
>   {
>   	struct virtio_vsock_pkt_info info = {
>   		.op = VIRTIO_VSOCK_OP_SHUTDOWN,
> -		.type = VIRTIO_VSOCK_TYPE_STREAM,
>   		.flags = (mode & RCV_SHUTDOWN ?
>   			  VIRTIO_VSOCK_SHUTDOWN_RCV : 0) |
>   			 (mode & SEND_SHUTDOWN ?
> @@ -644,6 +841,8 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
>   		.vsk = vsk,
>   	};
>   
> +	info.type = virtio_transport_get_type(sk_vsock(vsk));
> +
>   	return virtio_transport_send_pkt_info(vsk, &info);
>   }
>   EXPORT_SYMBOL_GPL(virtio_transport_shutdown);
> @@ -665,12 +864,18 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
>   {
>   	struct virtio_vsock_pkt_info info = {
>   		.op = VIRTIO_VSOCK_OP_RW,
> -		.type = VIRTIO_VSOCK_TYPE_STREAM,
>   		.msg = msg,
>   		.pkt_len = len,
>   		.vsk = vsk,
> +		.flags = 0,
>   	};
>   
> +	info.type = virtio_transport_get_type(sk_vsock(vsk));
> +
> +	if (info.type == VIRTIO_VSOCK_TYPE_SEQPACKET &&
> +	    msg->msg_flags & MSG_EOR)
> +		info.flags |= VIRTIO_VSOCK_RW_EOR;
> +
>   	return virtio_transport_send_pkt_info(vsk, &info);
>   }
>   EXPORT_SYMBOL_GPL(virtio_transport_stream_enqueue);
> @@ -688,7 +893,6 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
>   {
>   	struct virtio_vsock_pkt_info info = {
>   		.op = VIRTIO_VSOCK_OP_RST,
> -		.type = VIRTIO_VSOCK_TYPE_STREAM,
>   		.reply = !!pkt,
>   		.vsk = vsk,
>   	};
> @@ -697,6 +901,8 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
>   	if (pkt && le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_RST)
>   		return 0;
>   
> +	info.type = virtio_transport_get_type(sk_vsock(vsk));
> +
>   	return virtio_transport_send_pkt_info(vsk, &info);
>   }
>   
> @@ -884,44 +1090,59 @@ virtio_transport_recv_connecting(struct sock *sk,
>   	return err;
>   }
>   
> -static void
> +static bool
>   virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>   			      struct virtio_vsock_pkt *pkt)
>   {
>   	struct virtio_vsock_sock *vvs = vsk->trans;
> -	bool can_enqueue, free_pkt = false;
> +	bool data_ready = false;
> +	bool free_pkt = false;
>   
> -	pkt->len = le32_to_cpu(pkt->hdr.len);
>   	pkt->off = 0;
> +	pkt->len = le32_to_cpu(pkt->hdr.len);
>   
>   	spin_lock_bh(&vvs->rx_lock);
>   
> -	can_enqueue = virtio_transport_inc_rx_pkt(vvs, pkt);
> -	if (!can_enqueue) {
> -		free_pkt = true;
> -		goto out;
> -	}
> +	switch (le32_to_cpu(pkt->hdr.type)) {
> +	case VIRTIO_VSOCK_TYPE_STREAM: {
> +		if (!virtio_transport_inc_rx_pkt(vvs, pkt)) {
> +			free_pkt = true;
> +			goto out;
> +		}
>   
> -	/* Try to copy small packets into the buffer of last packet queued,
> -	 * to avoid wasting memory queueing the entire buffer with a small
> -	 * payload.
> -	 */
> -	if (pkt->len <= GOOD_COPY_LEN && !list_empty(&vvs->rx_queue)) {
> -		struct virtio_vsock_pkt *last_pkt;
> +		/* Try to copy small packets into the buffer of last packet queued,
> +		 * to avoid wasting memory queueing the entire buffer with a small
> +		 * payload.
> +		 */
> +		if (pkt->len <= GOOD_COPY_LEN && !list_empty(&vvs->rx_queue)) {
> +			struct virtio_vsock_pkt *last_pkt;
>   
> -		last_pkt = list_last_entry(&vvs->rx_queue,
> -					   struct virtio_vsock_pkt, list);
> +			last_pkt = list_last_entry(&vvs->rx_queue,
> +						   struct virtio_vsock_pkt, list);
>   
> -		/* If there is space in the last packet queued, we copy the
> -		 * new packet in its buffer.
> -		 */
> -		if (pkt->len <= last_pkt->buf_len - last_pkt->len) {
> -			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
> -			       pkt->len);
> -			last_pkt->len += pkt->len;
> -			free_pkt = true;
> -			goto out;
> +			/* If there is space in the last packet queued, we copy the
> +			 * new packet in its buffer.
> +			 */
> +			if (pkt->len <= last_pkt->buf_len - last_pkt->len) {
> +				memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
> +				       pkt->len);
> +				last_pkt->len += pkt->len;
> +				free_pkt = true;
> +				goto out;
> +			}
>   		}
> +
> +		data_ready = true;
> +		break;
> +	}
> +
> +	case VIRTIO_VSOCK_TYPE_SEQPACKET: {
> +		data_ready = true;
> +		vvs->rx_bytes += pkt->len;
> +		break;
> +	}
> +	default:
> +		goto out;
>   	}
>   
>   	list_add_tail(&pkt->list, &vvs->rx_queue);
> @@ -930,6 +1151,8 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>   	spin_unlock_bh(&vvs->rx_lock);
>   	if (free_pkt)
>   		virtio_transport_free_pkt(pkt);
> +
> +	return data_ready;
>   }
>   
>   static int
> @@ -940,9 +1163,17 @@ virtio_transport_recv_connected(struct sock *sk,
>   	int err = 0;
>   
>   	switch (le16_to_cpu(pkt->hdr.op)) {
> +	case VIRTIO_VSOCK_OP_SEQ_BEGIN: {
> +		struct virtio_vsock_sock *vvs = vsk->trans;
> +
> +		spin_lock_bh(&vvs->rx_lock);
> +		list_add_tail(&pkt->list, &vvs->rx_queue);
> +		spin_unlock_bh(&vvs->rx_lock);
> +		return err;
> +	}
>   	case VIRTIO_VSOCK_OP_RW:
> -		virtio_transport_recv_enqueue(vsk, pkt);
> -		sk->sk_data_ready(sk);
> +		if (virtio_transport_recv_enqueue(vsk, pkt))
> +			sk->sk_data_ready(sk);

Why do you need this change?
(maybe its ok, just wondering)


>   		return err;
>   	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
>   		sk->sk_write_space(sk);
> @@ -990,13 +1221,14 @@ virtio_transport_send_response(struct vsock_sock *vsk,
>   {
>   	struct virtio_vsock_pkt_info info = {
>   		.op = VIRTIO_VSOCK_OP_RESPONSE,
> -		.type = VIRTIO_VSOCK_TYPE_STREAM,
>   		.remote_cid = le64_to_cpu(pkt->hdr.src_cid),
>   		.remote_port = le32_to_cpu(pkt->hdr.src_port),
>   		.reply = true,
>   		.vsk = vsk,
>   	};
>   
> +	info.type = virtio_transport_get_type(sk_vsock(vsk));
> +
>   	return virtio_transport_send_pkt_info(vsk, &info);
>   }
>   
> @@ -1086,6 +1318,12 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
>   	return 0;
>   }
>   
> +static bool virtio_transport_valid_type(u16 type)
> +{
> +	return (type == VIRTIO_VSOCK_TYPE_STREAM) ||
> +	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET);
> +}
> +
>   /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->mutex
>    * lock.
>    */
> @@ -1111,7 +1349,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>   					le32_to_cpu(pkt->hdr.buf_alloc),
>   					le32_to_cpu(pkt->hdr.fwd_cnt));
>   
> -	if (le16_to_cpu(pkt->hdr.type) != VIRTIO_VSOCK_TYPE_STREAM) {
> +	if (!virtio_transport_valid_type(le16_to_cpu(pkt->hdr.type))) {
>   		(void)virtio_transport_reset_no_sock(t, pkt);
>   		goto free_pkt;
>   	}
> @@ -1128,6 +1366,9 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>   		}
>   	}
>   
> +	if (virtio_transport_get_type(sk) != le16_to_cpu(pkt->hdr.type))
> +		goto free_pkt;
No need to reset here, like a few lines
above in a seemingly similar condition?
