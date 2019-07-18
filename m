Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD6ED6CD6D
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 13:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389951AbfGRLfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 07:35:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727655AbfGRLfy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 07:35:54 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 09FDD30832DA;
        Thu, 18 Jul 2019 11:35:54 +0000 (UTC)
Received: from redhat.com (ovpn-120-147.rdu2.redhat.com [10.10.120.147])
        by smtp.corp.redhat.com (Postfix) with SMTP id B83BD5D96F;
        Thu, 18 Jul 2019 11:35:47 +0000 (UTC)
Date:   Thu, 18 Jul 2019 07:35:46 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 4/5] vhost/vsock: split packets to send using multiple
 buffers
Message-ID: <20190718072741-mutt-send-email-mst@kernel.org>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-5-sgarzare@redhat.com>
 <20190717105336-mutt-send-email-mst@kernel.org>
 <CAGxU2F45v40qAOHkm1Hk2E69gCS0UwVgS5NS+tDXXuzdF4EixA@mail.gmail.com>
 <20190718041234-mutt-send-email-mst@kernel.org>
 <CAGxU2F6oo7Cou7t9o=gG2=wxHMKX9xYQXNxVtDYeHq5fyEhJWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F6oo7Cou7t9o=gG2=wxHMKX9xYQXNxVtDYeHq5fyEhJWg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 18 Jul 2019 11:35:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 11:37:30AM +0200, Stefano Garzarella wrote:
> On Thu, Jul 18, 2019 at 10:13 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Thu, Jul 18, 2019 at 09:50:14AM +0200, Stefano Garzarella wrote:
> > > On Wed, Jul 17, 2019 at 4:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > On Wed, Jul 17, 2019 at 01:30:29PM +0200, Stefano Garzarella wrote:
> > > > > If the packets to sent to the guest are bigger than the buffer
> > > > > available, we can split them, using multiple buffers and fixing
> > > > > the length in the packet header.
> > > > > This is safe since virtio-vsock supports only stream sockets.
> > > > >
> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > >
> > > > So how does it work right now? If an app
> > > > does sendmsg with a 64K buffer and the other
> > > > side publishes 4K buffers - does it just stall?
> > >
> > > Before this series, the 64K (or bigger) user messages was split in 4K packets
> > > (fixed in the code) and queued in an internal list for the TX worker.
> > >
> > > After this series, we will queue up to 64K packets and then it will be split in
> > > the TX worker, depending on the size of the buffers available in the
> > > vring. (The idea was to allow EWMA or a configuration of the buffers size, but
> > > for now we postponed it)
> >
> > Got it. Using workers for xmit is IMHO a bad idea btw.
> > Why is it done like this?
> 
> Honestly, I don't know the exact reasons for this design, but I suppose
> that the idea was to have only one worker that uses the vring, and
> multiple user threads that enqueue packets in the list.
> This can simplify the code and we can put the user threads to sleep if
> we don't have "credit" available (this means that the receiver doesn't
> have space to receive the packet).


I think you mean the reverse: even without credits you can copy from
user and queue up data, then process it without waking up the user
thread.
Does it help though? It certainly adds up work outside of
user thread context which means it's not accounted for
correctly.

Maybe we want more VQs. Would help improve parallelism. The question
would then become how to map sockets to VQs. With a simple hash
it's easy to create collisions ...


> 
> What are the drawbacks in your opinion?
> 
> 
> Thanks,
> Stefano

- More pressure on scheduler
- Increased latency


-- 
MST
