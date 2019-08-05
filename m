Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05C898125A
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 08:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfHEGal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 02:30:41 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:47029 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfHEGal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 02:30:41 -0400
Received: by mail-qk1-f195.google.com with SMTP id r4so59194731qkm.13
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 23:30:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PVqIsmchklCTrdzugsyQL+AeUL8kmqaAFQiz9HKaITE=;
        b=pem1D/DpBD3lkh7V+9sNrFcZEnAlF9DZo1odRHz5uBqH28fsOTl0V33D6IUAH+a8Df
         O5RetvnEAmcEUAzOh8huXsiH6yQ9UzIsDe79K4B+E+h0UYRqH4OTQUZ8ZOjyciyYgn85
         vZ4kfAPUGddf6CKk/GEHxw9qpT6lqvVk1x0PgeSfiiyLwC0dWqnojnzsuAyeuGvgBaJv
         /WV4dn4yB3F+PxYSiKkyatL6Z0gDiGYP9uXSK7lq4fRUBBSu0J+9YI9jA3Cs4i0KCzp0
         Avt+y2R9kyEvpG9rTTDMsbtykkw02VaPogFg9mz20biVJsZ3JwuM9sFcY3xVtKXJ8L6E
         zweg==
X-Gm-Message-State: APjAAAWcj+9LhaECvMoQKZVYfxu+zrW5n4K36hq+z58X/yDwBNoBUCd+
        yptvnBjnhMHdojzxSQvvkazO1g==
X-Google-Smtp-Source: APXvYqwS0Eo1lXfnBu6u3xqFFZLty3hYj+avFeIYmNSdIaVzfHVVLe9QhqalA5xTV3YZrONCooErvg==
X-Received: by 2002:a37:86c4:: with SMTP id i187mr100882695qkd.464.1564986640071;
        Sun, 04 Aug 2019 23:30:40 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id n3sm34029874qkk.54.2019.08.04.23.30.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 23:30:39 -0700 (PDT)
Date:   Mon, 5 Aug 2019 02:30:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190805022833-mutt-send-email-mst@kernel.org>
References: <20190731084655.7024-8-jasowang@redhat.com>
 <20190731123935.GC3946@ziepe.ca>
 <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
 <20190731193057.GG3946@ziepe.ca>
 <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
 <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
 <20190802124613.GA11245@ziepe.ca>
 <20190802100414-mutt-send-email-mst@kernel.org>
 <e8ecb811-6653-cff4-bc11-81f4ccb0dbbf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e8ecb811-6653-cff4-bc11-81f4ccb0dbbf@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 12:36:40PM +0800, Jason Wang wrote:
> 
> On 2019/8/2 下午10:27, Michael S. Tsirkin wrote:
> > On Fri, Aug 02, 2019 at 09:46:13AM -0300, Jason Gunthorpe wrote:
> > > On Fri, Aug 02, 2019 at 05:40:07PM +0800, Jason Wang wrote:
> > > > > This must be a proper barrier, like a spinlock, mutex, or
> > > > > synchronize_rcu.
> > > > 
> > > > I start with synchronize_rcu() but both you and Michael raise some
> > > > concern.
> > > I've also idly wondered if calling synchronize_rcu() under the various
> > > mm locks is a deadlock situation.
> > > 
> > > > Then I try spinlock and mutex:
> > > > 
> > > > 1) spinlock: add lots of overhead on datapath, this leads 0 performance
> > > > improvement.
> > > I think the topic here is correctness not performance improvement
> > The topic is whether we should revert
> > commit 7f466032dc9 ("vhost: access vq metadata through kernel virtual address")
> > 
> > or keep it in. The only reason to keep it is performance.
> 
> 
> Maybe it's time to introduce the config option?

Depending on CONFIG_BROKEN? I'm not sure it's a good idea.

> 
> > 
> > Now as long as all this code is disabled anyway, we can experiment a
> > bit.
> > 
> > I personally feel we would be best served by having two code paths:
> > 
> > - Access to VM memory directly mapped into kernel
> > - Access to userspace
> > 
> > 
> > Having it all cleanly split will allow a bunch of optimizations, for
> > example for years now we planned to be able to process an incoming short
> > packet directly on softirq path, or an outgoing on directly within
> > eventfd.
> 
> 
> It's not hard consider we've already had our own accssors. But the question
> is (as asked in another thread), do you want permanent GUP or still use MMU
> notifiers.
> 
> Thanks

We want THP and NUMA to work. Both are important for performance.

-- 
MST
