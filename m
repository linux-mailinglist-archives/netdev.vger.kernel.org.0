Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A664BA6042
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 06:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfICEiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 00:38:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfICEiJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 00:38:09 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 31FB6C028320
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 04:38:09 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id l23so3758614qtp.4
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 21:38:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HyhlRljTDeAFaElZzW29mxoUpUqbbX7yuY1HM+Z3ooo=;
        b=OqhNZWw1K3/42mpVtN8PRj9qwoZppjIbu5nyoHDA1iRehQf7m8Lw2gcV2jCWMm74Ro
         0/bSEWhtFi9ARcpLP2G3p8C6OFLhT9mjko9VAK+K0Bs/oFmUA2zAcSMqFv4oXc3rV55+
         WzQYJ9gWTLjiKeuKuLECkqWiuWXnfDu9+8tdIG3AqiVoC22YBGWBJArcL+EXCR1h2WAh
         MZ2/nVmJ7ITQPdNv82ggPLdNfq0USms//gFNogNo0Y247nmVQ3jqbWQHneZFI8Nkahd5
         2+ZrNlaQCTDGiacG7FncrCcvWst1+xLzJtVVzVk9Vencb8qr911Wju2vBKFQGM8Pe7IK
         L75A==
X-Gm-Message-State: APjAAAWNy34awKe6rpmndWjkJHFn8IXJUCJLH2pxWN5JkAW7YsLC+XEn
        K+U7/pM2Y6XybhhGXXv9Y+TZMBX/8T0WKgjkzrp78Vzv4CGCC0315nLETPm4ezJMTPzE+FfgdZO
        6bfJUUodOhFH42xX0
X-Received: by 2002:a05:620a:1037:: with SMTP id a23mr25086415qkk.287.1567485488537;
        Mon, 02 Sep 2019 21:38:08 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwtyQdlTmiZPOlqu1w1TwZvFjyv5qe4H/TBrecDHCyCHz4CXpvVw+PctTpIorzXinTE+wPlmQ==
X-Received: by 2002:a05:620a:1037:: with SMTP id a23mr25086406qkk.287.1567485488344;
        Mon, 02 Sep 2019 21:38:08 -0700 (PDT)
Received: from redhat.com (bzq-79-180-62-110.red.bezeqint.net. [79.180.62.110])
        by smtp.gmail.com with ESMTPSA id y17sm3313998qtb.82.2019.09.02.21.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 21:38:07 -0700 (PDT)
Date:   Tue, 3 Sep 2019 00:38:02 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 2/5] vsock/virtio: reduce credit update messages
Message-ID: <20190903003050-mutt-send-email-mst@kernel.org>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-3-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717113030.163499-3-sgarzare@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 01:30:27PM +0200, Stefano Garzarella wrote:
> In order to reduce the number of credit update messages,
> we send them only when the space available seen by the
> transmitter is less than VIRTIO_VSOCK_MAX_PKT_BUF_SIZE.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/linux/virtio_vsock.h            |  1 +
>  net/vmw_vsock/virtio_transport_common.c | 16 +++++++++++++---
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index 7d973903f52e..49fc9d20bc43 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -41,6 +41,7 @@ struct virtio_vsock_sock {
>  
>  	/* Protected by rx_lock */
>  	u32 fwd_cnt;
> +	u32 last_fwd_cnt;
>  	u32 rx_bytes;
>  	struct list_head rx_queue;
>  };
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 095221f94786..a85559d4d974 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -211,6 +211,7 @@ static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
>  void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct virtio_vsock_pkt *pkt)
>  {
>  	spin_lock_bh(&vvs->tx_lock);
> +	vvs->last_fwd_cnt = vvs->fwd_cnt;
>  	pkt->hdr.fwd_cnt = cpu_to_le32(vvs->fwd_cnt);
>  	pkt->hdr.buf_alloc = cpu_to_le32(vvs->buf_alloc);
>  	spin_unlock_bh(&vvs->tx_lock);
> @@ -261,6 +262,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>  	struct virtio_vsock_sock *vvs = vsk->trans;
>  	struct virtio_vsock_pkt *pkt;
>  	size_t bytes, total = 0;
> +	u32 free_space;
>  	int err = -EFAULT;
>  
>  	spin_lock_bh(&vvs->rx_lock);
> @@ -291,11 +293,19 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>  			virtio_transport_free_pkt(pkt);
>  		}
>  	}
> +
> +	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
> +
>  	spin_unlock_bh(&vvs->rx_lock);
>  
> -	/* Send a credit pkt to peer */
> -	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_STREAM,
> -					    NULL);
> +	/* We send a credit update only when the space available seen
> +	 * by the transmitter is less than VIRTIO_VSOCK_MAX_PKT_BUF_SIZE

This is just repeating what code does though.
Please include the *reason* for the condition.
E.g. here's a better comment:

	/* To reduce number of credit update messages,
	 * don't update credits as long as lots of space is available.
	 * Note: the limit chosen here is arbitrary. Setting the limit
	 * too high causes extra messages. Too low causes transmitter
	 * stalls. As stalls are in theory more expensive than extra
	 * messages, we set the limit to a high value. TODO: experiment
	 * with different values.
	 */


> +	 */
> +	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
> +		virtio_transport_send_credit_update(vsk,
> +						    VIRTIO_VSOCK_TYPE_STREAM,
> +						    NULL);
> +	}
>  
>  	return total;
>  
> -- 
> 2.20.1
