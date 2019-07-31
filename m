Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC217CCC0
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730906AbfGaTbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:31:00 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:36392 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729094AbfGaTbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:31:00 -0400
Received: by mail-ua1-f65.google.com with SMTP id v20so27442360uao.3
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 12:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=V4Wcp011k9h7N5iAJkWpP1Nbu9oN4M2GGvG06LvdU2U=;
        b=fUaCEUhNC4Tuu1n1nF8asI51cgg70GaR9H/nMdDM2BZwKIGwYESyC+ANrzEzNbyCCK
         Oo9kAgTUGUCRJpgDkeKVwv2v7LNE0yerjxD0FFu+TlVm1wemvoI2V5qJum7RZWCsIsFu
         caZSoA1qPEKO3nEIy2wlsOXadZQb5TaaAqtNv95x4AfEvUSG01PbXA2WgagTZHsb7aMz
         DXvwhLJ2m6xnSVDL9BTKqy7XAh7eilMxSkpBweTk3v2EiycxvGfTJMtMv1lYRBGBE0MV
         Tk6sq+Q07tuHcFgS507UyAJFXfBxy4xzy4NGxxbF1CNkFe49Cf8Iq4yLVLNYGHjD92T2
         DCGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=V4Wcp011k9h7N5iAJkWpP1Nbu9oN4M2GGvG06LvdU2U=;
        b=uVD+zEBsOwS96y1cKK+dL3MuUxXtEL2dNEaKx7zdaARNggpgkYKFieWKLiBzkhE60+
         n+hXItjmghDgnEMpzXBo65Mm35W79XOLExSQWFOYu6JxoKf2MJtxJB0SED56ZnBRgjRU
         Poc9CLqjbeNWulg2JwtUdIw3W8xKJQRpBaGRYx/CLwaf0XKjKflz0bXYo29QfAguVxEs
         wNNcaHA8RZfSy4eAaqnbThaHQdWeDHO5uK1sUEAfJ85vkigEYxyOg0xlIdswlHd2uWW+
         jT6SNNPggpPwqetG3YTcziSSCbHkgzTcQsxxOEbIHDrKZiASeJa00VK4wBP2VkFutIZ4
         9JuA==
X-Gm-Message-State: APjAAAXycZE7D2SYuWcN7SaG09x48HxwyRi+POncHmWJrgBZ9lz8Nj5l
        PgMeDJkNbn4swCbN4Z9VYvjJxQ==
X-Google-Smtp-Source: APXvYqzup5DZ6q8bxH1OXHSeDiBtafoJQmznWiwBSNHtM04i2y2ha7deX2jX6U9UfYm6veI89m6bZw==
X-Received: by 2002:ab0:49b0:: with SMTP id e45mr17499877uad.120.1564601458846;
        Wed, 31 Jul 2019 12:30:58 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id 10sm28842460vkl.33.2019.07.31.12.30.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 31 Jul 2019 12:30:58 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hsuJN-0007XW-Lr; Wed, 31 Jul 2019 16:30:57 -0300
Date:   Wed, 31 Jul 2019 16:30:57 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190731193057.GG3946@ziepe.ca>
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-8-jasowang@redhat.com>
 <20190731123935.GC3946@ziepe.ca>
 <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 09:28:20PM +0800, Jason Wang wrote:
> 
> On 2019/7/31 下午8:39, Jason Gunthorpe wrote:
> > On Wed, Jul 31, 2019 at 04:46:53AM -0400, Jason Wang wrote:
> > > We used to use RCU to synchronize MMU notifier with worker. This leads
> > > calling synchronize_rcu() in invalidate_range_start(). But on a busy
> > > system, there would be many factors that may slow down the
> > > synchronize_rcu() which makes it unsuitable to be called in MMU
> > > notifier.
> > > 
> > > A solution is SRCU but its overhead is obvious with the expensive full
> > > memory barrier. Another choice is to use seqlock, but it doesn't
> > > provide a synchronization method between readers and writers. The last
> > > choice is to use vq mutex, but it need to deal with the worst case
> > > that MMU notifier must be blocked and wait for the finish of swap in.
> > > 
> > > So this patch switches use a counter to track whether or not the map
> > > was used. The counter was increased when vq try to start or finish
> > > uses the map. This means, when it was even, we're sure there's no
> > > readers and MMU notifier is synchronized. When it was odd, it means
> > > there's a reader we need to wait it to be even again then we are
> > > synchronized.
> > You just described a seqlock.
> 
> 
> Kind of, see my explanation below.
> 
> 
> > 
> > We've been talking about providing this as some core service from mmu
> > notifiers because nearly every use of this API needs it.
> 
> 
> That would be very helpful.
> 
> 
> > 
> > IMHO this gets the whole thing backwards, the common pattern is to
> > protect the 'shadow pte' data with a seqlock (usually open coded),
> > such that the mmu notififer side has the write side of that lock and
> > the read side is consumed by the thread accessing or updating the SPTE.
> 
> 
> Yes, I've considered something like that. But the problem is, mmu notifier
> (writer) need to wait for the vhost worker to finish the read before it can
> do things like setting dirty pages and unmapping page.  It looks to me
> seqlock doesn't provide things like this.  

The seqlock is usually used to prevent a 2nd thread from accessing the
VA while it is being changed by the mm. ie you use something seqlocky
instead of the ugly mmu_notifier_unregister/register cycle.

You are supposed to use something simple like a spinlock or mutex
inside the invalidate_range_start to serialized tear down of the SPTEs
with their accessors.

> write_seqcount_begin()
> 
> map = vq->map[X]
> 
> write or read through map->addr directly
> 
> write_seqcount_end()
> 
> 
> There's no rmb() in write_seqcount_begin(), so map could be read before
> write_seqcount_begin(), but it looks to me now that this doesn't harm at
> all, maybe we can try this way.

That is because it is a write side lock, not a read lock. IIRC
seqlocks have weaker barriers because the write side needs to be
serialized in some other way.

The requirement I see is you need invalidate_range_start to block
until another thread exits its critical section (ie stops accessing
the SPTEs). 

That is a spinlock/mutex.

You just can't invent a faster spinlock by open coding something with
barriers, it doesn't work.

Jason
