Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9701057FE4
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 12:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfF0KGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 06:06:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37391 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfF0KGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 06:06:01 -0400
Received: by mail-wm1-f66.google.com with SMTP id f17so5038216wme.2
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 03:05:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=l1NwZTpnYPouG/Q6w8KVsqVGc7B8RfSH5Nd1fRhhCTg=;
        b=B2NsLmGz6/y+L4TmAzjbqc/OxKPinNKVM85RvFroGuXN7IyPoJEzLCAAV8OnvQYEtm
         B1iDDBazVc3zFrA/fwV8KhIUmJtq5QXwDIDwMDfAlV11LXgxaAJGEKxdKG1RteX2C5Sr
         5e1FII9PhHReEh4ew0Ija0FQk4vX1j7Hp8yiRBmhLNY2fVAd1od1KsLcRy19Md0Sqwfb
         Jj39vh1/kkRUTMZneoCWe4VVKbgmWe5f+pr7rxTlFsJL1cafJ8HgK0sl+1huTFptpJEB
         48i885inIr2XzywCbRV4ojqhfbaVhIfaAtmk1IVgOlUjOer9qCo6ux9MQmJguNFLoWix
         lSbA==
X-Gm-Message-State: APjAAAVjuOuLvu7FChIFbqEPInUaGXMM9OgJpvuR96wcJfFQlunxkU5i
        EgqotvOwfd2UJ4qTGazyKBCmEw==
X-Google-Smtp-Source: APXvYqzQ0sKIY6ZChWYC2WJ9R3q0SreK0ALQXZZlzrAyFs4jZYqRQY8Nns9g7u2vtKtU2ORhMeHCKQ==
X-Received: by 2002:a1c:4484:: with SMTP id r126mr2685540wma.27.1561629959060;
        Thu, 27 Jun 2019 03:05:59 -0700 (PDT)
Received: from steredhat.homenet.telecomitalia.it (host21-207-dynamic.52-79-r.retail.telecomitalia.it. [79.52.207.21])
        by smtp.gmail.com with ESMTPSA id l12sm3249628wrb.81.2019.06.27.03.05.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:05:57 -0700 (PDT)
Date:   Thu, 27 Jun 2019 12:05:55 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/4] vsock/virtio: several fixes in the .probe() and
 .remove()
Message-ID: <20190627100555.pmnecffewzsopxyw@steredhat.homenet.telecomitalia.it>
References: <20190528105623.27983-1-sgarzare@redhat.com>
 <20190610130945.GL14257@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610130945.GL14257@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 02:09:45PM +0100, Stefan Hajnoczi wrote:
> On Tue, May 28, 2019 at 12:56:19PM +0200, Stefano Garzarella wrote:
> > During the review of "[PATCH] vsock/virtio: Initialize core virtio vsock
> > before registering the driver", Stefan pointed out some possible issues
> > in the .probe() and .remove() callbacks of the virtio-vsock driver.
> > 
> > This series tries to solve these issues:
> > - Patch 1 postpones the 'the_virtio_vsock' assignment at the end of the
> >   .probe() to avoid that some sockets queue works when the initialization
> >   is not finished.
> > - Patches 2 and 3 stop workers before to call vdev->config->reset(vdev) to
> >   be sure that no one is accessing the device, and adds another flush at the
> >   end of the .remove() to avoid use after free.
> > - Patch 4 free also used buffers in the virtqueues during the .remove().
> > 
> > Stefano Garzarella (4):
> >   vsock/virtio: fix locking around 'the_virtio_vsock'
> >   vsock/virtio: stop workers during the .remove()
> >   vsock/virtio: fix flush of works during the .remove()
> >   vsock/virtio: free used buffers during the .remove()
> > 
> >  net/vmw_vsock/virtio_transport.c | 105 ++++++++++++++++++++++++++-----
> >  1 file changed, 90 insertions(+), 15 deletions(-)
> 
> Looking forward to v2.  I took a look at the discussion and I'll review
> v2 from scratch.  Just keep in mind that the mutex is used more for
> mutual exclusion of the init/exit code than to protect the_virtio_vsock,
> so we'll still need protection of init/exit code even with RCU.

Thanks for the advice! I'll send the v2 ASAP.

Thanks,
Stefano
