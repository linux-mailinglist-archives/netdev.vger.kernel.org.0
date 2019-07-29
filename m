Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDFA278FC9
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 17:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388263AbfG2PtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 11:49:10 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:34812 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387998AbfG2PtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 11:49:10 -0400
Received: by mail-vs1-f65.google.com with SMTP id m23so41129185vso.1
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 08:49:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/niwkJuj+kTChFIxAZJ7R3qyc1S8YzIk+KDkO6xs7tI=;
        b=CrkAQNbFGf6q4ddsCmxRlDUAY4Lqj/DlhrvDJ4vRnqWsCpxw0SLxEDUdRMxHWSPMxd
         HcL6Bj0DquT2t+76MekqDyvHthOxnEW/4ZNYSBVBbjux7JLsopMapUOL04kQt/b6mX7s
         4hDMlOI7rnYa+yPSibc+2bHDswYe5V/5wVwepEYC+NnRbjdo5v6BHLYE6JGzGK+k9jvR
         gDVXsT/9SPUQ1g21MNCbiq6rPgh4xLM816q53I4B4u9N0ciqtEfZFQdOMD133f36h/8l
         X4qz8SILfe+Phr1pSgE86KC/HREQ0FZsc2ZCnqi3n+X7JLw+j7A6xLtNDbeKx/6bcqjf
         D1oQ==
X-Gm-Message-State: APjAAAV0kQaPUQljFuR7KCHxOgVSovg6JJmyoVhgB0JFCeStNiH3+T26
        4IbDoybkwYlh/MlyzK3PaR/tRw==
X-Google-Smtp-Source: APXvYqzLzOdW28+st9J99eGOoagZRY/+6mNu7Jt6yXi0Ig2fmuLKwy4BkNu3szWlUISUaVAULlX13Q==
X-Received: by 2002:a67:694f:: with SMTP id e76mr14283114vsc.77.1564415349351;
        Mon, 29 Jul 2019 08:49:09 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id h81sm16021382vka.19.2019.07.29.08.49.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 08:49:08 -0700 (PDT)
Date:   Mon, 29 Jul 2019 11:49:02 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20190729114302-mutt-send-email-mst@kernel.org>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-2-sgarzare@redhat.com>
 <20190729095956-mutt-send-email-mst@kernel.org>
 <20190729153656.zk4q4rob5oi6iq7l@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729153656.zk4q4rob5oi6iq7l@steredhat>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 05:36:56PM +0200, Stefano Garzarella wrote:
> On Mon, Jul 29, 2019 at 10:04:29AM -0400, Michael S. Tsirkin wrote:
> > On Wed, Jul 17, 2019 at 01:30:26PM +0200, Stefano Garzarella wrote:
> > > Since virtio-vsock was introduced, the buffers filled by the host
> > > and pushed to the guest using the vring, are directly queued in
> > > a per-socket list. These buffers are preallocated by the guest
> > > with a fixed size (4 KB).
> > > 
> > > The maximum amount of memory used by each socket should be
> > > controlled by the credit mechanism.
> > > The default credit available per-socket is 256 KB, but if we use
> > > only 1 byte per packet, the guest can queue up to 262144 of 4 KB
> > > buffers, using up to 1 GB of memory per-socket. In addition, the
> > > guest will continue to fill the vring with new 4 KB free buffers
> > > to avoid starvation of other sockets.
> > > 
> > > This patch mitigates this issue copying the payload of small
> > > packets (< 128 bytes) into the buffer of last packet queued, in
> > > order to avoid wasting memory.
> > > 
> > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > This is good enough for net-next, but for net I think we
> > should figure out how to address the issue completely.
> > Can we make the accounting precise? What happens to
> > performance if we do?
> > 
> 
> In order to do more precise accounting maybe we can use the buffer size,
> instead of payload size when we update the credit available.
> In this way, the credit available for each socket will reflect the memory
> actually used.
> 
> I should check better, because I'm not sure what happen if the peer sees
> 1KB of space available, then it sends 1KB of payload (using a 4KB
> buffer).
> 
> The other option is to copy each packet in a new buffer like I did in
> the v2 [2], but this forces us to make a copy for each packet that does
> not fill the entire buffer, perhaps too expensive.
> 
> [2] https://patchwork.kernel.org/patch/10938741/
> 
> 
> Thanks,
> Stefano

Interesting. You are right, and at some level the protocol forces copies.

We could try to detect that the actual memory is getting close to
admin limits and force copies on queued packets after the fact.
Is that practical?

And yes we can extend the credit accounting to include buffer size.
That's a protocol change but maybe it makes sense.

-- 
MST
