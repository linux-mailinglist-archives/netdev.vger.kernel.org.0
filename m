Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674B38127A
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 08:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfHEGkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 02:40:31 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39379 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfHEGkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 02:40:31 -0400
Received: by mail-qt1-f195.google.com with SMTP id l9so79865540qtu.6
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 23:40:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TJherR/Px/4Fbrw9YV+u4NRMIhgPOAQEPfJAeZ4Vfls=;
        b=jpjilv++ZmpFMJKx7xAq9/L3mW862cm9ITQNv82QJiV955g7HElyBWob/Q4q6TjRKA
         zv1ukdV2og0SZTuQV2qJnlnvukTNpq2QyDGlxoaK8NqdFGfFM/PNPmowmB2/GXZWrz6g
         VjthZSkmGrPU9SYUwBZ1ueH074MwHNXaLah9TMTJU6frYu+fkTNqiEuMcfoIodcl1BDA
         dxXg6VEqsbvU+vsByHmASik7BIqy2rkOebnynYk7bEr17U7fe1Xt3E952UYm6pKX/twH
         HnakI/JToQPF528DPJYorZWTte8bqXW0cTafyckIpEl9Eb4eZfO9ttZk5o/URd6sqdkw
         wPkg==
X-Gm-Message-State: APjAAAW5yPdpDsZwHLXQ48s6DtFTtaouwL4I3W2zJ9xjKhmoBnnLqXYl
        cEgLGneoS6RS79GuNrDqP2CdLQ==
X-Google-Smtp-Source: APXvYqySQxd6FG3GHb6mKg/OD+gospqbuIs1GOIQkfQIZWqsFx5h/wKXKUUrJ/WUSB3S9we9808RDA==
X-Received: by 2002:aed:2dc7:: with SMTP id i65mr87212492qtd.365.1564987230384;
        Sun, 04 Aug 2019 23:40:30 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id 6sm38704287qkp.82.2019.08.04.23.40.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 23:40:29 -0700 (PDT)
Date:   Mon, 5 Aug 2019 02:40:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190805023106-mutt-send-email-mst@kernel.org>
References: <20190731123935.GC3946@ziepe.ca>
 <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
 <20190731193057.GG3946@ziepe.ca>
 <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
 <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
 <20190802124613.GA11245@ziepe.ca>
 <20190802100414-mutt-send-email-mst@kernel.org>
 <e8ecb811-6653-cff4-bc11-81f4ccb0dbbf@redhat.com>
 <494ac30d-b750-52c8-b927-16cd4b9414c4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <494ac30d-b750-52c8-b927-16cd4b9414c4@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 12:41:45PM +0800, Jason Wang wrote:
> 
> On 2019/8/5 下午12:36, Jason Wang wrote:
> > 
> > On 2019/8/2 下午10:27, Michael S. Tsirkin wrote:
> > > On Fri, Aug 02, 2019 at 09:46:13AM -0300, Jason Gunthorpe wrote:
> > > > On Fri, Aug 02, 2019 at 05:40:07PM +0800, Jason Wang wrote:
> > > > > > This must be a proper barrier, like a spinlock, mutex, or
> > > > > > synchronize_rcu.
> > > > > 
> > > > > I start with synchronize_rcu() but both you and Michael raise some
> > > > > concern.
> > > > I've also idly wondered if calling synchronize_rcu() under the various
> > > > mm locks is a deadlock situation.
> > > > 
> > > > > Then I try spinlock and mutex:
> > > > > 
> > > > > 1) spinlock: add lots of overhead on datapath, this leads 0
> > > > > performance
> > > > > improvement.
> > > > I think the topic here is correctness not performance improvement
> > > The topic is whether we should revert
> > > commit 7f466032dc9 ("vhost: access vq metadata through kernel
> > > virtual address")
> > > 
> > > or keep it in. The only reason to keep it is performance.
> > 
> > 
> > Maybe it's time to introduce the config option?
> 
> 
> Or does it make sense if I post a V3 with:
> 
> - introduce config option and disable the optimization by default
> 
> - switch from synchronize_rcu() to vhost_flush_work(), but the rest are the
> same
> 
> This can give us some breath to decide which way should go for next release?
> 
> Thanks

As is, with preempt enabled?  Nope I don't think blocking an invalidator
on swap IO is ok, so I don't believe this stuff is going into this
release at this point.

So it's more a question of whether it's better to revert and apply a clean
patch on top, or just keep the code around but disabled with an ifdef as is.
I'm open to both options, and would like your opinion on this.

> 
> > 
> > 
> > > 
> > > Now as long as all this code is disabled anyway, we can experiment a
> > > bit.
> > > 
> > > I personally feel we would be best served by having two code paths:
> > > 
> > > - Access to VM memory directly mapped into kernel
> > > - Access to userspace
> > > 
> > > 
> > > Having it all cleanly split will allow a bunch of optimizations, for
> > > example for years now we planned to be able to process an incoming short
> > > packet directly on softirq path, or an outgoing on directly within
> > > eventfd.
> > 
> > 
> > It's not hard consider we've already had our own accssors. But the
> > question is (as asked in another thread), do you want permanent GUP or
> > still use MMU notifiers.
> > 
> > Thanks
> > 
> > _______________________________________________
> > Virtualization mailing list
> > Virtualization@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
