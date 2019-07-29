Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB26E79034
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbfG2QBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:01:48 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:38276 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbfG2QBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:01:44 -0400
Received: by mail-vs1-f65.google.com with SMTP id k9so41122738vso.5
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 09:01:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F22IOpvGzuwCs+Et2Wm6c0mIYlOT2lCTjpD6ddOFTas=;
        b=EEleUH6KGvyjWySkMW4PkjRd/gy/1r4xi5WYELDNuCerfwAsA6piVa/nfiMltGJFEF
         8wavUKaciUBOBtPjsZURhontblYBgiNb6dRwmQkjmx8ydSlweF5pEyvaXSjdeKLuunRL
         /iFJXnoHIrhKvS0fzSy9HfQxtQopVrKWlBOHltLj6UGDsnzQflvg7G3r8ulKmcN6Cp6s
         Rjy62C5zvlN+eb1oLVbWZsqugzSvuEvV8azAgKnC8m5i0WV9wCdtMwABbqfVO921yotp
         r1zise2tk97eSWnWI9iqt7goS8nRlrUg7titK0Bsp5HLJOTdkXf0rAbpYKRrSvkactbz
         g/Fw==
X-Gm-Message-State: APjAAAUfv++jH4Dd6wQzAxaKS4Vm760wEaWbDSSUozP/46JBSqWmAtY4
        X2+2S73YKfjkgFaMh3z9dkjnoA==
X-Google-Smtp-Source: APXvYqyL15XGjOVMiK+yH1llx7jj3/of29D33b3O3EZv3RPYANUrqdhIF1TDRY/qzMWca1WS02erEA==
X-Received: by 2002:a67:89c7:: with SMTP id l190mr68587815vsd.13.1564416103428;
        Mon, 29 Jul 2019 09:01:43 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id t200sm25600663vke.5.2019.07.29.09.01.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:01:42 -0700 (PDT)
Date:   Mon, 29 Jul 2019 12:01:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20190729115904-mutt-send-email-mst@kernel.org>
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
> The other option is to copy each packet in a new buffer like I did in
> the v2 [2], but this forces us to make a copy for each packet that does
> not fill the entire buffer, perhaps too expensive.
> 
> [2] https://patchwork.kernel.org/patch/10938741/
> 

So one thing we can easily do is to under-report the
available credit. E.g. if we copy up to 256bytes,
then report just 256bytes for every buffer in the queue.


> 
> Thanks,
> Stefano
