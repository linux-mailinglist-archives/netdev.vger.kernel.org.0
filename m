Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B946BE8E
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 16:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfGQOv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 10:51:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfGQOv7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 10:51:59 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AFE9581F19;
        Wed, 17 Jul 2019 14:51:58 +0000 (UTC)
Received: from redhat.com (ovpn-125-71.rdu2.redhat.com [10.10.125.71])
        by smtp.corp.redhat.com (Postfix) with SMTP id 7D6B660BEE;
        Wed, 17 Jul 2019 14:51:51 +0000 (UTC)
Date:   Wed, 17 Jul 2019 10:51:47 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 3/5] vsock/virtio: fix locking in
 virtio_transport_inc_tx_pkt()
Message-ID: <20190717105056-mutt-send-email-mst@kernel.org>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-4-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717113030.163499-4-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 17 Jul 2019 14:51:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 01:30:28PM +0200, Stefano Garzarella wrote:
> fwd_cnt and last_fwd_cnt are protected by rx_lock, so we should use
> the same spinlock also if we are in the TX path.
> 
> Move also buf_alloc under the same lock.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Wait a second is this a bugfix?
If it's used under the wrong lock won't values get corrupted?
Won't traffic then stall or more data get to sent than
credits?

> ---
>  include/linux/virtio_vsock.h            | 2 +-
>  net/vmw_vsock/virtio_transport_common.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index 49fc9d20bc43..4c7781f4b29b 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -35,7 +35,6 @@ struct virtio_vsock_sock {
>  
>  	/* Protected by tx_lock */
>  	u32 tx_cnt;
> -	u32 buf_alloc;
>  	u32 peer_fwd_cnt;
>  	u32 peer_buf_alloc;
>  
> @@ -43,6 +42,7 @@ struct virtio_vsock_sock {
>  	u32 fwd_cnt;
>  	u32 last_fwd_cnt;
>  	u32 rx_bytes;
> +	u32 buf_alloc;
>  	struct list_head rx_queue;
>  };
>  
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index a85559d4d974..34a2b42313b7 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -210,11 +210,11 @@ static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
>  
>  void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct virtio_vsock_pkt *pkt)
>  {
> -	spin_lock_bh(&vvs->tx_lock);
> +	spin_lock_bh(&vvs->rx_lock);
>  	vvs->last_fwd_cnt = vvs->fwd_cnt;
>  	pkt->hdr.fwd_cnt = cpu_to_le32(vvs->fwd_cnt);
>  	pkt->hdr.buf_alloc = cpu_to_le32(vvs->buf_alloc);
> -	spin_unlock_bh(&vvs->tx_lock);
> +	spin_unlock_bh(&vvs->rx_lock);
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_inc_tx_pkt);
>  
> -- 
> 2.20.1
