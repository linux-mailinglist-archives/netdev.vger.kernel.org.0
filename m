Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B40BA798DA
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbfG2ULA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:11:00 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:33543 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388040AbfG2Td5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 15:33:57 -0400
Received: by mail-vs1-f68.google.com with SMTP id m8so41830910vsj.0
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 12:33:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=APfgCVofNAxTgIpWJJctDNySOFsZWXGHU5vcxTekT1w=;
        b=VffsDnkrIY6mioaHIVm9+N5PqEOA01xrK78l1Wty5BdwA4OxOF2fBwLJSob6poL3Yr
         QwIEp3MbS8C6Aj6cx0Mkgp1lqb0zrJi/BvQ/Xe6KFk98b5fZR4ga0z/WnnFevsKymXNH
         JIU0LS/uuABJZ9/XqYRMOnWfPR9wYh8nAVXvghiFD1jj9gjsgQPVu890ouePGt1FS62o
         IF+0UpEj8iM3xbA1pPQcvqn2SGl4dzlgwUSEZgHbNMNB+eKLUQh7nlXsHmqvNBcFL2/O
         4mtOAitopKb7A0gXTRVGUqpEhNWIHgK9DVU5SYShm99r+6oTJBvWPpHw/ydmNurdT5c+
         qNhw==
X-Gm-Message-State: APjAAAXpZ8TCpTpkBgcEqpcrTan9fiy+0CzZmvOWHq0H7+TngvjsdTXr
        QZOs8Eu+OPxiJB2pO+s+U0C8+g==
X-Google-Smtp-Source: APXvYqzRLP/c6oL54wDBJQuKWm3Ku8BrREq1OSA8ge6Iw1WLkwaDnlWWbhuSQBXPE/VnBAgrAnjwqw==
X-Received: by 2002:a67:f518:: with SMTP id u24mr26227759vsn.87.1564428837005;
        Mon, 29 Jul 2019 12:33:57 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id u27sm12353175vkk.53.2019.07.29.12.33.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 12:33:56 -0700 (PDT)
Date:   Mon, 29 Jul 2019 15:33:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20190729152634-mutt-send-email-mst@kernel.org>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-2-sgarzare@redhat.com>
 <20190729095956-mutt-send-email-mst@kernel.org>
 <20190729153656.zk4q4rob5oi6iq7l@steredhat>
 <20190729115904-mutt-send-email-mst@kernel.org>
 <CAGxU2F5F1KcaFNJ6n7++ApZiYMGnoEWKVRgo3Vc4h5hpxSJEZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F5F1KcaFNJ6n7++ApZiYMGnoEWKVRgo3Vc4h5hpxSJEZg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 06:41:27PM +0200, Stefano Garzarella wrote:
> On Mon, Jul 29, 2019 at 12:01:37PM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jul 29, 2019 at 05:36:56PM +0200, Stefano Garzarella wrote:
> > > On Mon, Jul 29, 2019 at 10:04:29AM -0400, Michael S. Tsirkin wrote:
> > > > On Wed, Jul 17, 2019 at 01:30:26PM +0200, Stefano Garzarella wrote:
> > > > > Since virtio-vsock was introduced, the buffers filled by the host
> > > > > and pushed to the guest using the vring, are directly queued in
> > > > > a per-socket list. These buffers are preallocated by the guest
> > > > > with a fixed size (4 KB).
> > > > >
> > > > > The maximum amount of memory used by each socket should be
> > > > > controlled by the credit mechanism.
> > > > > The default credit available per-socket is 256 KB, but if we use
> > > > > only 1 byte per packet, the guest can queue up to 262144 of 4 KB
> > > > > buffers, using up to 1 GB of memory per-socket. In addition, the
> > > > > guest will continue to fill the vring with new 4 KB free buffers
> > > > > to avoid starvation of other sockets.
> > > > >
> > > > > This patch mitigates this issue copying the payload of small
> > > > > packets (< 128 bytes) into the buffer of last packet queued, in
> > > > > order to avoid wasting memory.
> > > > >
> > > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > >
> > > > This is good enough for net-next, but for net I think we
> > > > should figure out how to address the issue completely.
> > > > Can we make the accounting precise? What happens to
> > > > performance if we do?
> > > >
> > >
> > > In order to do more precise accounting maybe we can use the buffer size,
> > > instead of payload size when we update the credit available.
> > > In this way, the credit available for each socket will reflect the memory
> > > actually used.
> > >
> > > I should check better, because I'm not sure what happen if the peer sees
> > > 1KB of space available, then it sends 1KB of payload (using a 4KB
> > > buffer).
> > > The other option is to copy each packet in a new buffer like I did in
> > > the v2 [2], but this forces us to make a copy for each packet that does
> > > not fill the entire buffer, perhaps too expensive.
> > >
> > > [2] https://patchwork.kernel.org/patch/10938741/
> > >
> >
> > So one thing we can easily do is to under-report the
> > available credit. E.g. if we copy up to 256bytes,
> > then report just 256bytes for every buffer in the queue.
> >
> 
> Ehm sorry, I got lost :(
> Can you explain better?
> 
> 
> Thanks,
> Stefano

I think I suggested a better idea more recently.
But to clarify this option: we are adding a 4K buffer.
Let's say we know we will always copy 128 bytes.

So we just tell remote we have 128.
If we add another 4K buffer we add another 128 credits.

So we are charging local socket 16x more (4k for a 128 byte packet) but
we are paying remote 16x less (128 credits for 4k byte buffer). It evens
out.

Way less credits to go around so I'm not sure it's a good idea,
at least as the only solution. Can be combined with other
optimizations and probably in a less drastic fashion
(e.g. 2x rather than 16x).


-- 
MST
