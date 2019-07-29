Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B55179144
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfG2Qlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:41:40 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36672 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfG2Qlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:41:39 -0400
Received: by mail-oi1-f193.google.com with SMTP id q4so16564730oij.3
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 09:41:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qEnidYZvMtI0djmi8U0ZEWcmJ8XfKi49GrC/Gx0OghM=;
        b=iJR7OYOjRzHWCCc8hOGH9yDLDqur7PrWF3ZEKmrW+3hmOJMJ12aA8kZO1bQlJUX/03
         RKi5vUgMtqT6dpX8biC2UN2b/XyLL9IfYwaeHjYIrIqEXzyLljQrRG435gZ/4hwHbSPl
         shyRur4wVIRwWOrw+faP6rDbKVv1c1Elt5vcb52VMsLXXsMoE2cb+Qn1KD+UfWj4vVyb
         RW0i3Uk5K2hgeG41swH88ZrrJCzCWwgxmuFHgw9EYE7qRBf88Be6lUmQDgOFPD84E1h+
         4KwRGB6Aal0lA5ComJblcDqV6C/iE9bvePu1FGpnD9Lu56m2RTll1Pz2g6qAx+wBiyAB
         IOyA==
X-Gm-Message-State: APjAAAXRCw/WgrW+P5X2FoLtwblpBd3+wuEXnVQMSv6j0929zA8g/38u
        vkeNICl5KziVOcnDuQKUbWRBU4GR8poCxu3bWJnr1A==
X-Google-Smtp-Source: APXvYqwLmyK1E/4jrfGUT98xeH//0WmrilX5ZcE9+u6f94aZr6eu7bn4vAgIsx2aZWLhabtNB/WLd0Vdna3tzy2IXKU=
X-Received: by 2002:aca:1803:: with SMTP id h3mr20756041oih.24.1564418498709;
 Mon, 29 Jul 2019 09:41:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190717113030.163499-1-sgarzare@redhat.com> <20190717113030.163499-2-sgarzare@redhat.com>
 <20190729095956-mutt-send-email-mst@kernel.org> <20190729153656.zk4q4rob5oi6iq7l@steredhat>
 <20190729115904-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190729115904-mutt-send-email-mst@kernel.org>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Mon, 29 Jul 2019 18:41:27 +0200
Message-ID: <CAGxU2F5F1KcaFNJ6n7++ApZiYMGnoEWKVRgo3Vc4h5hpxSJEZg@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 12:01:37PM -0400, Michael S. Tsirkin wrote:
> On Mon, Jul 29, 2019 at 05:36:56PM +0200, Stefano Garzarella wrote:
> > On Mon, Jul 29, 2019 at 10:04:29AM -0400, Michael S. Tsirkin wrote:
> > > On Wed, Jul 17, 2019 at 01:30:26PM +0200, Stefano Garzarella wrote:
> > > > Since virtio-vsock was introduced, the buffers filled by the host
> > > > and pushed to the guest using the vring, are directly queued in
> > > > a per-socket list. These buffers are preallocated by the guest
> > > > with a fixed size (4 KB).
> > > >
> > > > The maximum amount of memory used by each socket should be
> > > > controlled by the credit mechanism.
> > > > The default credit available per-socket is 256 KB, but if we use
> > > > only 1 byte per packet, the guest can queue up to 262144 of 4 KB
> > > > buffers, using up to 1 GB of memory per-socket. In addition, the
> > > > guest will continue to fill the vring with new 4 KB free buffers
> > > > to avoid starvation of other sockets.
> > > >
> > > > This patch mitigates this issue copying the payload of small
> > > > packets (< 128 bytes) into the buffer of last packet queued, in
> > > > order to avoid wasting memory.
> > > >
> > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > >
> > > This is good enough for net-next, but for net I think we
> > > should figure out how to address the issue completely.
> > > Can we make the accounting precise? What happens to
> > > performance if we do?
> > >
> >
> > In order to do more precise accounting maybe we can use the buffer size,
> > instead of payload size when we update the credit available.
> > In this way, the credit available for each socket will reflect the memory
> > actually used.
> >
> > I should check better, because I'm not sure what happen if the peer sees
> > 1KB of space available, then it sends 1KB of payload (using a 4KB
> > buffer).
> > The other option is to copy each packet in a new buffer like I did in
> > the v2 [2], but this forces us to make a copy for each packet that does
> > not fill the entire buffer, perhaps too expensive.
> >
> > [2] https://patchwork.kernel.org/patch/10938741/
> >
>
> So one thing we can easily do is to under-report the
> available credit. E.g. if we copy up to 256bytes,
> then report just 256bytes for every buffer in the queue.
>

Ehm sorry, I got lost :(
Can you explain better?


Thanks,
Stefano
