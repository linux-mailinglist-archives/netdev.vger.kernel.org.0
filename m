Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCE52CC64
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfE1Qpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:45:33 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52324 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbfE1Qp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 12:45:28 -0400
Received: by mail-wm1-f68.google.com with SMTP id y3so3720831wmm.2
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 09:45:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=YfCDy8k/dL7Dko33LF05Qlo/QHsbXR3MAXNOFcVS/RA=;
        b=sIrwbrBoejdrhL9AfnVZu0AFEtTDpXXBBMwDtAKTkS0bTpEco5RjAZ0JWLYwt0VVNe
         mvsN+UooTtav3rkbold4TjXB4MqMqvZqKa4K1IkOB4Pwzn7rvuQii2BGmPNRtx/F4iKS
         5lFIrHU3H1XkRjRnwak7i+cZpfPTn6nuqHfXyA9R7nLnW5s3aPR/7AssmkCg7SLzAaj0
         CozP9urN71ieIU7gPR4uB8JKx927GZlxQCyGEboYHeMkACrRYE5hjVyqYvL/gJojKE0s
         p+0Jwgz7nc8u2U/NuCXb5eiNsSYNkcbJ5YDbcEktjYNUYALbdIzzTcAgOPKzMSmkf6BA
         +tEQ==
X-Gm-Message-State: APjAAAU/z/kvdLFqZUeSL9eXbRDRC3Q9ghR2V9ThVR6o//mj0rZW542Y
        g3UZ1ie3aHolXPEp5zTur+xymQ==
X-Google-Smtp-Source: APXvYqxeKaGT5CziyQa01axCoTDbNIqIxP59JKIWEdNof8CFJIQ5zifxSdiU0fS+Hx4pML1S3A6kJg==
X-Received: by 2002:a1c:7d56:: with SMTP id y83mr3545448wmc.77.1559061925586;
        Tue, 28 May 2019 09:45:25 -0700 (PDT)
Received: from steredhat.homenet.telecomitalia.it (host253-229-dynamic.248-95-r.retail.telecomitalia.it. [95.248.229.253])
        by smtp.gmail.com with ESMTPSA id x7sm1868809wmc.44.2019.05.28.09.45.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 09:45:24 -0700 (PDT)
Date:   Tue, 28 May 2019 18:45:21 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/8] vsock/virtio: limit the memory used per-socket
Message-ID: <20190528164521.k2euedfcmtvvynew@steredhat.homenet.telecomitalia.it>
References: <20190510125843.95587-1-sgarzare@redhat.com>
 <20190510125843.95587-2-sgarzare@redhat.com>
 <3b275b52-63d9-d260-1652-8e8bf7dd679f@redhat.com>
 <20190513172322.vcgenx7xk4v6r2ay@steredhat>
 <f834c9e9-5d0e-8ebb-44e0-6d99b6284e5c@redhat.com>
 <20190514163500.a7moalixvpn5mkcr@steredhat>
 <034a5081-b4fb-011f-b5b7-fbf293c13b23@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <034a5081-b4fb-011f-b5b7-fbf293c13b23@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 10:48:44AM +0800, Jason Wang wrote:
> 
> On 2019/5/15 上午12:35, Stefano Garzarella wrote:
> > On Tue, May 14, 2019 at 11:25:34AM +0800, Jason Wang wrote:
> > > On 2019/5/14 上午1:23, Stefano Garzarella wrote:
> > > > On Mon, May 13, 2019 at 05:58:53PM +0800, Jason Wang wrote:
> > > > > On 2019/5/10 下午8:58, Stefano Garzarella wrote:
> > > > > > +static struct virtio_vsock_buf *
> > > > > > +virtio_transport_alloc_buf(struct virtio_vsock_pkt *pkt, bool zero_copy)
> > > > > > +{
> > > > > > +	struct virtio_vsock_buf *buf;
> > > > > > +
> > > > > > +	if (pkt->len == 0)
> > > > > > +		return NULL;
> > > > > > +
> > > > > > +	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
> > > > > > +	if (!buf)
> > > > > > +		return NULL;
> > > > > > +
> > > > > > +	/* If the buffer in the virtio_vsock_pkt is full, we can move it to
> > > > > > +	 * the new virtio_vsock_buf avoiding the copy, because we are sure that
> > > > > > +	 * we are not use more memory than that counted by the credit mechanism.
> > > > > > +	 */
> > > > > > +	if (zero_copy && pkt->len == pkt->buf_len) {
> > > > > > +		buf->addr = pkt->buf;
> > > > > > +		pkt->buf = NULL;
> > > > > > +	} else {
> > > > > Is the copy still needed if we're just few bytes less? We meet similar issue
> > > > > for virito-net, and virtio-net solve this by always copy first 128bytes for
> > > > > big packets.
> > > > > 
> > > > > See receive_big()
> > > > I'm seeing, It is more sophisticated.
> > > > IIUC, virtio-net allocates a sk_buff with 128 bytes of buffer, then copies the
> > > > first 128 bytes, then adds the buffer used to receive the packet as a frag to
> > > > the skb.
> > > 
> > > Yes and the point is if the packet is smaller than 128 bytes the pages will
> > > be recycled.
> > > 
> > > 
> > So it's avoid the overhead of allocation of a large buffer. I got it.
> > 
> > Just a curiosity, why the threshold is 128 bytes?
> 
> 
> From its name (GOOD_COPY_LEN), I think it just a value that won't lose much
> performance, e.g the size two cachelines.
> 

Jason, Stefan,
since I'm removing the patches to increase the buffers to 64 KiB and I'm
adding a threshold for small packets, I would simplify this patch,
removing the new buffer allocation and copying small packets into the
buffers already queued (if there is a space).
In this way, I should solve the issue of 1 byte packets.

Do you think could be better?

Thanks,
Stefano
