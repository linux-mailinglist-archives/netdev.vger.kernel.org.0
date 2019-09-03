Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3616FA6285
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 09:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfICHb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 03:31:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49970 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbfICHb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 03:31:26 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C19414E83E
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 07:31:25 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id 25so44406wmf.0
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 00:31:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vIdlVo3wzaAg7+E51hvuCmhSjy3lqZ2GvkawXNng+DY=;
        b=hPFvDhI0nlL5b5465eQ91zYSE/a2l5RXmDHWK3GB4RlxE+J9pzdYwK2shCF0rWkZNa
         TfkKp8hfcK23dzkWHqhS1LOJYv9ifN7+9nHhssvxcajhjh4ZOwNbNJKaTuFN3lZSUWb5
         fBdq8+fyxzPZdZ2o0L7SzF2dILzLB3qrODt+0dYx2oF15PhbQ6NfMKZOa9HxdOiKyBKd
         5ODDvQ2dvJaD1+CUcRVxa/iS7I/jNuN/VO9dpbrAhxOzqVu+xmN8dlJoXi8hSqljAaAE
         su762ksjPYOKiRjrLdIIMKds29VQD+p1Eh/6gAFQH5amcjIsXpib1Dkfrm9RccpjJn6H
         M1kQ==
X-Gm-Message-State: APjAAAUMc6EwslblRX7WXV1s3uk7Py4UZLiarGJi0J0BRi4xCEfWZO0L
        YGSpqf2rVdobSf5E1Qy6FjnxkT2CylntjSEGO6VzUxh13NJg3mUBVtf2dD5lyD9tcOkug/oqPp5
        SMolm/UfsB7LlVs4K
X-Received: by 2002:adf:8043:: with SMTP id 61mr35027584wrk.115.1567495884505;
        Tue, 03 Sep 2019 00:31:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyeFTpVz+dse95eWq0nocs/IG2NKjpvXX30eGt/rJU82VMrZ0Bsyy+QcPwkIDLVpATtIdNOPA==
X-Received: by 2002:adf:8043:: with SMTP id 61mr35027562wrk.115.1567495884199;
        Tue, 03 Sep 2019 00:31:24 -0700 (PDT)
Received: from steredhat (host170-61-dynamic.36-79-r.retail.telecomitalia.it. [79.36.61.170])
        by smtp.gmail.com with ESMTPSA id v8sm34676506wra.79.2019.09.03.00.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 00:31:23 -0700 (PDT)
Date:   Tue, 3 Sep 2019 09:31:20 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 2/5] vsock/virtio: reduce credit update messages
Message-ID: <20190903073120.kefllalytkvidcvh@steredhat>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-3-sgarzare@redhat.com>
 <20190903003050-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903003050-mutt-send-email-mst@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 12:38:02AM -0400, Michael S. Tsirkin wrote:
> On Wed, Jul 17, 2019 at 01:30:27PM +0200, Stefano Garzarella wrote:
> > In order to reduce the number of credit update messages,
> > we send them only when the space available seen by the
> > transmitter is less than VIRTIO_VSOCK_MAX_PKT_BUF_SIZE.
> > 
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> >  include/linux/virtio_vsock.h            |  1 +
> >  net/vmw_vsock/virtio_transport_common.c | 16 +++++++++++++---
> >  2 files changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > index 7d973903f52e..49fc9d20bc43 100644
> > --- a/include/linux/virtio_vsock.h
> > +++ b/include/linux/virtio_vsock.h
> > @@ -41,6 +41,7 @@ struct virtio_vsock_sock {
> >  
> >  	/* Protected by rx_lock */
> >  	u32 fwd_cnt;
> > +	u32 last_fwd_cnt;
> >  	u32 rx_bytes;
> >  	struct list_head rx_queue;
> >  };
> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > index 095221f94786..a85559d4d974 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -211,6 +211,7 @@ static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
> >  void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct virtio_vsock_pkt *pkt)
> >  {
> >  	spin_lock_bh(&vvs->tx_lock);
> > +	vvs->last_fwd_cnt = vvs->fwd_cnt;
> >  	pkt->hdr.fwd_cnt = cpu_to_le32(vvs->fwd_cnt);
> >  	pkt->hdr.buf_alloc = cpu_to_le32(vvs->buf_alloc);
> >  	spin_unlock_bh(&vvs->tx_lock);
> > @@ -261,6 +262,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> >  	struct virtio_vsock_sock *vvs = vsk->trans;
> >  	struct virtio_vsock_pkt *pkt;
> >  	size_t bytes, total = 0;
> > +	u32 free_space;
> >  	int err = -EFAULT;
> >  
> >  	spin_lock_bh(&vvs->rx_lock);
> > @@ -291,11 +293,19 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> >  			virtio_transport_free_pkt(pkt);
> >  		}
> >  	}
> > +
> > +	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
> > +
> >  	spin_unlock_bh(&vvs->rx_lock);
> >  
> > -	/* Send a credit pkt to peer */
> > -	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_STREAM,
> > -					    NULL);
> > +	/* We send a credit update only when the space available seen
> > +	 * by the transmitter is less than VIRTIO_VSOCK_MAX_PKT_BUF_SIZE
> 
> This is just repeating what code does though.
> Please include the *reason* for the condition.
> E.g. here's a better comment:
> 
> 	/* To reduce number of credit update messages,
> 	 * don't update credits as long as lots of space is available.
> 	 * Note: the limit chosen here is arbitrary. Setting the limit
> 	 * too high causes extra messages. Too low causes transmitter
> 	 * stalls. As stalls are in theory more expensive than extra
> 	 * messages, we set the limit to a high value. TODO: experiment
> 	 * with different values.
> 	 */
> 

Yes, it is better, sorry for that. I'll try to avoid unnecessary comments,
explaining the reason for certain changes.

Since this patch is already queued in net-next, should I send another
patch to fix the comment?

Thanks,
Stefano
