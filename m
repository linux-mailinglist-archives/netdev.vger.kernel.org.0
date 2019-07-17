Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 746356BEA0
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 16:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfGQOzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 10:55:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56520 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfGQOzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 10:55:04 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6C68460CC;
        Wed, 17 Jul 2019 14:55:03 +0000 (UTC)
Received: from redhat.com (ovpn-125-71.rdu2.redhat.com [10.10.125.71])
        by smtp.corp.redhat.com (Postfix) with SMTP id D977360920;
        Wed, 17 Jul 2019 14:54:58 +0000 (UTC)
Date:   Wed, 17 Jul 2019 10:54:57 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 4/5] vhost/vsock: split packets to send using multiple
 buffers
Message-ID: <20190717105336-mutt-send-email-mst@kernel.org>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-5-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717113030.163499-5-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 17 Jul 2019 14:55:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 01:30:29PM +0200, Stefano Garzarella wrote:
> If the packets to sent to the guest are bigger than the buffer
> available, we can split them, using multiple buffers and fixing
> the length in the packet header.
> This is safe since virtio-vsock supports only stream sockets.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

So how does it work right now? If an app
does sendmsg with a 64K buffer and the other
side publishes 4K buffers - does it just stall?


> ---
>  drivers/vhost/vsock.c                   | 66 ++++++++++++++++++-------
>  net/vmw_vsock/virtio_transport_common.c | 15 ++++--
>  2 files changed, 60 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 6c8390a2af52..9f57736fe15e 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -102,7 +102,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  		struct iov_iter iov_iter;
>  		unsigned out, in;
>  		size_t nbytes;
> -		size_t len;
> +		size_t iov_len, payload_len;
>  		int head;
>  
>  		spin_lock_bh(&vsock->send_pkt_list_lock);
> @@ -147,8 +147,24 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  			break;
>  		}
>  
> -		len = iov_length(&vq->iov[out], in);
> -		iov_iter_init(&iov_iter, READ, &vq->iov[out], in, len);
> +		iov_len = iov_length(&vq->iov[out], in);
> +		if (iov_len < sizeof(pkt->hdr)) {
> +			virtio_transport_free_pkt(pkt);
> +			vq_err(vq, "Buffer len [%zu] too small\n", iov_len);
> +			break;
> +		}
> +
> +		iov_iter_init(&iov_iter, READ, &vq->iov[out], in, iov_len);
> +		payload_len = pkt->len - pkt->off;
> +
> +		/* If the packet is greater than the space available in the
> +		 * buffer, we split it using multiple buffers.
> +		 */
> +		if (payload_len > iov_len - sizeof(pkt->hdr))
> +			payload_len = iov_len - sizeof(pkt->hdr);
> +
> +		/* Set the correct length in the header */
> +		pkt->hdr.len = cpu_to_le32(payload_len);
>  
>  		nbytes = copy_to_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
>  		if (nbytes != sizeof(pkt->hdr)) {
> @@ -157,33 +173,47 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  			break;
>  		}
>  
> -		nbytes = copy_to_iter(pkt->buf, pkt->len, &iov_iter);
> -		if (nbytes != pkt->len) {
> +		nbytes = copy_to_iter(pkt->buf + pkt->off, payload_len,
> +				      &iov_iter);
> +		if (nbytes != payload_len) {
>  			virtio_transport_free_pkt(pkt);
>  			vq_err(vq, "Faulted on copying pkt buf\n");
>  			break;
>  		}
>  
> -		vhost_add_used(vq, head, sizeof(pkt->hdr) + pkt->len);
> +		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
>  		added = true;
>  
> -		if (pkt->reply) {
> -			int val;
> -
> -			val = atomic_dec_return(&vsock->queued_replies);
> -
> -			/* Do we have resources to resume tx processing? */
> -			if (val + 1 == tx_vq->num)
> -				restart_tx = true;
> -		}
> -
>  		/* Deliver to monitoring devices all correctly transmitted
>  		 * packets.
>  		 */
>  		virtio_transport_deliver_tap_pkt(pkt);
>  
> -		total_len += pkt->len;
> -		virtio_transport_free_pkt(pkt);
> +		pkt->off += payload_len;
> +		total_len += payload_len;
> +
> +		/* If we didn't send all the payload we can requeue the packet
> +		 * to send it with the next available buffer.
> +		 */
> +		if (pkt->off < pkt->len) {
> +			spin_lock_bh(&vsock->send_pkt_list_lock);
> +			list_add(&pkt->list, &vsock->send_pkt_list);
> +			spin_unlock_bh(&vsock->send_pkt_list_lock);
> +		} else {
> +			if (pkt->reply) {
> +				int val;
> +
> +				val = atomic_dec_return(&vsock->queued_replies);
> +
> +				/* Do we have resources to resume tx
> +				 * processing?
> +				 */
> +				if (val + 1 == tx_vq->num)
> +					restart_tx = true;
> +			}
> +
> +			virtio_transport_free_pkt(pkt);
> +		}
>  	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
>  	if (added)
>  		vhost_signal(&vsock->dev, vq);
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 34a2b42313b7..56fab3f03d0e 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -97,8 +97,17 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
>  	struct virtio_vsock_pkt *pkt = opaque;
>  	struct af_vsockmon_hdr *hdr;
>  	struct sk_buff *skb;
> +	size_t payload_len;
> +	void *payload_buf;
>  
> -	skb = alloc_skb(sizeof(*hdr) + sizeof(pkt->hdr) + pkt->len,
> +	/* A packet could be split to fit the RX buffer, so we can retrieve
> +	 * the payload length from the header and the buffer pointer taking
> +	 * care of the offset in the original packet.
> +	 */
> +	payload_len = le32_to_cpu(pkt->hdr.len);
> +	payload_buf = pkt->buf + pkt->off;
> +
> +	skb = alloc_skb(sizeof(*hdr) + sizeof(pkt->hdr) + payload_len,
>  			GFP_ATOMIC);
>  	if (!skb)
>  		return NULL;
> @@ -138,8 +147,8 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
>  
>  	skb_put_data(skb, &pkt->hdr, sizeof(pkt->hdr));
>  
> -	if (pkt->len) {
> -		skb_put_data(skb, pkt->buf, pkt->len);
> +	if (payload_len) {
> +		skb_put_data(skb, payload_buf, payload_len);
>  	}
>  
>  	return skb;
> -- 
> 2.20.1
