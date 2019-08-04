Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62FB7809EB
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 10:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfHDIHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 04:07:23 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42578 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfHDIHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 04:07:23 -0400
Received: by mail-wr1-f65.google.com with SMTP id x1so31406320wrr.9
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 01:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9iGihd0uQZm0OhWtfPGT4IVKLzhJ/X1+ULeDAnIt+iM=;
        b=dy5yHhxphCtjLeIek4NAOAp/+T0cZ04kRw64mN8Vy8yX4KnGxGD+XrBA70zNoJ4li1
         X4T8VBnOaPjWNwebTyQuwKwshyXFbq0OpRlIU8fpDwfVHb6PkbXMdKYYwb+b5/n5Na7v
         TBDw/6XmNNlGaPFpqwEU3g/V6b3CpT+/d9UelH7OSRzO0t/xiznVg8wcV+hSHOJcdemn
         wxRtSUt21PnQRaUElQb9UYiahO1zMe7wSLPRFEdqFTUDzADd++PL22SoOHs52DohEgqu
         MXoVJrWrbk9vUB5h/CTM1xkcEdejyw4fybRXj9/TSEFijcml2mJyqEs+TAHFpSi283FU
         7tiw==
X-Gm-Message-State: APjAAAUeA88YrI/bduj/O9a5QM3q1zN34W1nKFPv59wcbD7m+4I5f/Oe
        4Jjeji9hKrJ9pEc5QRpjlS6dtA==
X-Google-Smtp-Source: APXvYqwI+gaRAvVddfB9OVUlNyUeUxov9xoEZgkuKZzlqBcvGCZoK4Z/LJM3l40Bq9U3eA5YbA17zQ==
X-Received: by 2002:adf:e2c1:: with SMTP id d1mr163081358wrj.283.1564906041363;
        Sun, 04 Aug 2019 01:07:21 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id r11sm124352644wre.14.2019.08.04.01.07.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 01:07:20 -0700 (PDT)
Date:   Sun, 4 Aug 2019 04:07:17 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190804040034-mutt-send-email-mst@kernel.org>
References: <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
 <20190731193057.GG3946@ziepe.ca>
 <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
 <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
 <20190802124613.GA11245@ziepe.ca>
 <20190802100414-mutt-send-email-mst@kernel.org>
 <20190802172418.GB11245@ziepe.ca>
 <20190803172944-mutt-send-email-mst@kernel.org>
 <20190804001400.GA25543@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190804001400.GA25543@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 03, 2019 at 09:14:00PM -0300, Jason Gunthorpe wrote:
> On Sat, Aug 03, 2019 at 05:36:13PM -0400, Michael S. Tsirkin wrote:
> > On Fri, Aug 02, 2019 at 02:24:18PM -0300, Jason Gunthorpe wrote:
> > > On Fri, Aug 02, 2019 at 10:27:21AM -0400, Michael S. Tsirkin wrote:
> > > > On Fri, Aug 02, 2019 at 09:46:13AM -0300, Jason Gunthorpe wrote:
> > > > > On Fri, Aug 02, 2019 at 05:40:07PM +0800, Jason Wang wrote:
> > > > > > > This must be a proper barrier, like a spinlock, mutex, or
> > > > > > > synchronize_rcu.
> > > > > > 
> > > > > > 
> > > > > > I start with synchronize_rcu() but both you and Michael raise some
> > > > > > concern.
> > > > > 
> > > > > I've also idly wondered if calling synchronize_rcu() under the various
> > > > > mm locks is a deadlock situation.
> > > > > 
> > > > > > Then I try spinlock and mutex:
> > > > > > 
> > > > > > 1) spinlock: add lots of overhead on datapath, this leads 0 performance
> > > > > > improvement.
> > > > > 
> > > > > I think the topic here is correctness not performance improvement
> > > > 
> > > > The topic is whether we should revert
> > > > commit 7f466032dc9 ("vhost: access vq metadata through kernel virtual address")
> > > > 
> > > > or keep it in. The only reason to keep it is performance.
> > > 
> > > Yikes, I'm not sure you can ever win against copy_from_user using
> > > mmu_notifiers?
> > 
> > Ever since copy_from_user started playing with flags (for SMAP) and
> > added speculation barriers there's a chance we can win by accessing
> > memory through the kernel address.
> 
> You think copy_to_user will be more expensive than the minimum two
> atomics required to synchronize with another thread?

I frankly don't know. With SMAP you flip flags twice, and with spectre
you flush the pipeline. Is that cheaper or more expensive than an atomic
operation? Testing is the only way to tell.

> > > Also, why can't this just permanently GUP the pages? In fact, where
> > > does it put_page them anyhow? Worrying that 7f466 adds a get_user page
> > > but does not add a put_page??
> 
> You didn't answer this.. Why not just use GUP?
> 
> Jason

Sorry I misunderstood the question. Permanent GUP breaks lots of
functionality we need such as THP and numa balancing.

release_pages is used instead of put_page.




-- 
MST
