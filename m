Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694D56E28B
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 10:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfGSIaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 04:30:00 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37190 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfGSI37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 04:29:59 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so6296139wrr.4
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 01:29:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=k1bnFro2XXdwmJgrGLhv6xKBwMHqJtL+pcbxH+NzjmM=;
        b=ZL9x2fkPYNiqREudMuaw6mXIfASA8Hkw1y6H7QwtFfdY5Z1dBILWLTJ5mgwRlKsuPA
         4a6yKbMripUBYBEIwV05Au0kdF8QnUWKailibOj+oe2twZCXIP2SBDOEbIJgxoZkuTwy
         WGGz6bS/RtktncDvoJovzUwwD58B0mPgiBjhjPg13dGFDP2dy5+sjHjNrhRhTRWx3UFm
         S5J5A2uX4gD/m1eb+YYVwoDbRQgFHk4zn23ac/jZVtAx0uGi4t8sipkDkYpfcNxlYhrM
         dVfaRvn5/ObHBqkEJKKuQsHAUG3wT3IbUa85RL4fAnBkeQMOC3S56xjPs/BNnvqe+EAm
         qxfw==
X-Gm-Message-State: APjAAAUVB+oN2R427owQ8Cmqlzn35OlPTHeF7mJBLS/c76iJmm3HYEQX
        qw6Wph0TvRgAGtaxqipeMxnrAhMQd8o=
X-Google-Smtp-Source: APXvYqyq9acl68xOlc1ZDifwAYF0lAew9EnZOZvpXAWnTf1hg09lgAOCC1cGT8vja/tQpaOoGLEkHQ==
X-Received: by 2002:a5d:4212:: with SMTP id n18mr53314416wrq.261.1563524997628;
        Fri, 19 Jul 2019 01:29:57 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id l17sm16941335wrr.94.2019.07.19.01.29.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 01:29:56 -0700 (PDT)
Date:   Fri, 19 Jul 2019 10:29:54 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 5/5] vsock/virtio: change the maximum packet size
 allowed
Message-ID: <20190719082954.m2lw77adpp5dylxw@steredhat>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-6-sgarzare@redhat.com>
 <20190717105703-mutt-send-email-mst@kernel.org>
 <CAGxU2F5ybg1_8VhS=COMnxSKC4AcW4ZagYwNMi==d6-rNPgzsg@mail.gmail.com>
 <20190718083105-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718083105-mutt-send-email-mst@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 08:33:40AM -0400, Michael S. Tsirkin wrote:
> On Thu, Jul 18, 2019 at 09:52:41AM +0200, Stefano Garzarella wrote:
> > On Wed, Jul 17, 2019 at 5:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Wed, Jul 17, 2019 at 01:30:30PM +0200, Stefano Garzarella wrote:
> > > > Since now we are able to split packets, we can avoid limiting
> > > > their sizes to VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE.
> > > > Instead, we can use VIRTIO_VSOCK_MAX_PKT_BUF_SIZE as the max
> > > > packet size.
> > > >
> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > >
> > >
> > > OK so this is kind of like GSO where we are passing
> > > 64K packets to the vsock and then split at the
> > > low level.
> > 
> > Exactly, something like that in the Host->Guest path, instead in the
> > Guest->Host we use the entire 64K packet.
> > 
> > Thanks,
> > Stefano
> 
> btw two allocations for each packet isn't great. How about
> allocating the struct linearly with the data?

Are you referring to the kzalloc() to allocate the 'struct
virtio_vsock_pkt', followed by the kmalloc() to allocate the buffer?

Actually they don't look great, I will try to do a single allocation.

> And all buffers are same length for you - so you can actually
> do alloc_pages.

Yes, also Jason suggested it and we decided to postpone since we will
try to reuse the virtio-net where it comes for free.

> Allocating/freeing pages in a batch should also be considered.

For the allocation of guest rx buffers we do some kind of batching (we
refill the queue when it reaches the half), but only it this case :(

I'll try to do more alloc/free batching.

Thanks,
Stefano
