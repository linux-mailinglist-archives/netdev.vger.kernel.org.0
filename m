Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4296CE26
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 14:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390276AbfGRMdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 08:33:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51384 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727692AbfGRMdx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 08:33:53 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 43D52307D941;
        Thu, 18 Jul 2019 12:33:53 +0000 (UTC)
Received: from redhat.com (ovpn-120-147.rdu2.redhat.com [10.10.120.147])
        by smtp.corp.redhat.com (Postfix) with SMTP id AD1EA5D720;
        Thu, 18 Jul 2019 12:33:47 +0000 (UTC)
Date:   Thu, 18 Jul 2019 08:33:40 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 5/5] vsock/virtio: change the maximum packet size
 allowed
Message-ID: <20190718083105-mutt-send-email-mst@kernel.org>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-6-sgarzare@redhat.com>
 <20190717105703-mutt-send-email-mst@kernel.org>
 <CAGxU2F5ybg1_8VhS=COMnxSKC4AcW4ZagYwNMi==d6-rNPgzsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F5ybg1_8VhS=COMnxSKC4AcW4ZagYwNMi==d6-rNPgzsg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 18 Jul 2019 12:33:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 09:52:41AM +0200, Stefano Garzarella wrote:
> On Wed, Jul 17, 2019 at 5:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Jul 17, 2019 at 01:30:30PM +0200, Stefano Garzarella wrote:
> > > Since now we are able to split packets, we can avoid limiting
> > > their sizes to VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE.
> > > Instead, we can use VIRTIO_VSOCK_MAX_PKT_BUF_SIZE as the max
> > > packet size.
> > >
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> >
> >
> > OK so this is kind of like GSO where we are passing
> > 64K packets to the vsock and then split at the
> > low level.
> 
> Exactly, something like that in the Host->Guest path, instead in the
> Guest->Host we use the entire 64K packet.
> 
> Thanks,
> Stefano

btw two allocations for each packet isn't great. How about
allocating the struct linearly with the data?
And all buffers are same length for you - so you can actually
do alloc_pages.
Allocating/freeing pages in a batch should also be considered.

-- 
MST
