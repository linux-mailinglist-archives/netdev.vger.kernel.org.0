Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF3A77D9A0
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 12:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbfHAKsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 06:48:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38226 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728783AbfHAKr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 06:47:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so73051315wrr.5
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 03:47:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qw6j853wZUG0P4ng1fQNKfQUl03rC9IHR3/FL4fgPwk=;
        b=Su6gMItDCbEiPYNTn5tPh0lKE+1AskxssGfdLHNVAmc2Z7Pkh85kZwXislxpuXdtDx
         tViSlRN8jIjyjgckcu5ELOIu3GMauG1XohPm9HdmRxKdF3hCpCQ7ovmONSLOzsGt/0a0
         AzIYQFy83L3PAVMWSW/F2y6IZyNRYgQ1rgWI6XvBAxdd0rwwbZTIDUvhYU0+ZcfwyKZx
         AbK0vHtWpNKRMOUMmqqlQ736z1ZjclJk6RUZJ6Fmqcr6c3RyDmpZdKnUdUkf5LD4zRbV
         G+E2P9OCQrMRS11tqhFc89t1MntgDhHj3jiaK5Id7q5JMGqfMfXyBLk9RROxatRN1Cqs
         lbBg==
X-Gm-Message-State: APjAAAXY8SunD22Hq9UPgu8wcEoj6wXAd5fnCpZkPi+s3NnhPOLi/KwE
        Bt2AINfz30X7HcGtlBOL27ataw==
X-Google-Smtp-Source: APXvYqxw85Z/h+/LijJBZKEF9X3Av4FcGm9GhgdFvPrI4Hc/B6vXckRANX/RaJawe7pCHRv8hHxJ0Q==
X-Received: by 2002:adf:e8c8:: with SMTP id k8mr36986014wrn.285.1564656477234;
        Thu, 01 Aug 2019 03:47:57 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id h8sm75520711wmf.12.2019.08.01.03.47.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 03:47:56 -0700 (PDT)
Date:   Thu, 1 Aug 2019 12:47:54 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20190801104754.lb3ju5xjfmnxioii@steredhat>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-2-sgarzare@redhat.com>
 <20190729095956-mutt-send-email-mst@kernel.org>
 <20190729153656.zk4q4rob5oi6iq7l@steredhat>
 <20190729114302-mutt-send-email-mst@kernel.org>
 <20190729161903.yhaj5rfcvleexkhc@steredhat>
 <20190729165056.r32uzj6om3o6vfvp@steredhat>
 <20190729143622-mutt-send-email-mst@kernel.org>
 <20190730093539.dcksure3vrykir3g@steredhat>
 <20190730163807-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730163807-mutt-send-email-mst@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 04:42:25PM -0400, Michael S. Tsirkin wrote:
> On Tue, Jul 30, 2019 at 11:35:39AM +0200, Stefano Garzarella wrote:

(...)

> > 
> > The problem here is the compatibility. Before this series virtio-vsock
> > and vhost-vsock modules had the RX buffer size hard-coded
> > (VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE = 4K). So, if we send a buffer smaller
> > of 4K, there might be issues.
> 
> Shouldn't be if they are following the spec. If not let's fix
> the broken parts.
> 
> > 
> > Maybe it is the time to add add 'features' to virtio-vsock device.
> > 
> > Thanks,
> > Stefano
> 
> Why would a remote care about buffer sizes?
> 
> Let's first see what the issues are. If they exist
> we can either fix the bugs, or code the bug as a feature in spec.
> 

The vhost_transport '.stream_enqueue' callback
[virtio_transport_stream_enqueue()] calls the virtio_transport_send_pkt_info(),
passing the user message. This function allocates a new packet, copying
the user message, but (before this series) it limits the packet size to
the VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE (4K):

static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
					  struct virtio_vsock_pkt_info *info)
{
 ...
	/* we can send less than pkt_len bytes */
	if (pkt_len > VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE)
		pkt_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;

	/* virtio_transport_get_credit might return less than pkt_len credit */
	pkt_len = virtio_transport_get_credit(vvs, pkt_len);

	/* Do not send zero length OP_RW pkt */
	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
		return pkt_len;
 ...
}

then it queues the packet for the TX worker calling .send_pkt()
[vhost_transport_send_pkt() in the vhost_transport case]

The main function executed by the TX worker is
vhost_transport_do_send_pkt() that picks up a buffer from the virtqueue
and it tries to copy the packet (up to 4K) on it.  If the buffer
allocated from the guest will be smaller then 4K, I think here it will
be discarded with an error:

static void
vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
				struct vhost_virtqueue *vq)
{
 ...
		nbytes = copy_to_iter(pkt->buf, pkt->len, &iov_iter);
		if (nbytes != pkt->len) {
			virtio_transport_free_pkt(pkt);
			vq_err(vq, "Faulted on copying pkt buf\n");
			break;
		}
 ...
}


This series changes this behavior since now we will split the packet in
vhost_transport_do_send_pkt() depending on the buffer found in the
virtqueue.

We didn't change the buffer size in this series, so we still backward
compatible, but if we will use buffers smaller than 4K, we should
encounter the error described above.

How do you suggest we proceed if we want to change the buffer size?
Maybe adding a feature to "support any buffer size"?

Thanks,
Stefano
