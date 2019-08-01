Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F747DD8E
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 16:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731862AbfHAOPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 10:15:15 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:32975 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731586AbfHAOPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 10:15:15 -0400
Received: by mail-qt1-f195.google.com with SMTP id r6so66111587qtt.0
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 07:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=is8PyxvRhNytWxsxvai2fZ7Vunv6qUm5JlLk3gubz8A=;
        b=Xxvi13uMIuNd1i7qKKgkImlPAjK1xDFLxSCWyTWQlSWc0W0RYQ1MIbkdfqnYLZG9yu
         5JI71oibP9i2ddPwTU9YBExPCU3Dlsj9Hb5dtaQ5jQpFVrZe095cwJxIxT6yDBH5wF1p
         wCJApD147HK5V4ZzkFqufCd3njndvpO/gboYNoDeFKB07FcDW1Fik2Hzi8KFbGkqeU8B
         FnLAkMgm4iKJeXTHx5eicQowVzuFCmxijHVptaHIDUKgEIgd9VbBsMKuWbYIgOQnQmmN
         1oNq+b5+5oWwfawyEFBafayDt06Az4m3upS8lvLUrhifXOq6NRLkSxQqkth2e/4StwnK
         u5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=is8PyxvRhNytWxsxvai2fZ7Vunv6qUm5JlLk3gubz8A=;
        b=EPiqLKBMJ6xyFtaIquZjt+0AUFUan7iEolFqE4hk4gPghXght+x3CI4aAFXnCGDvrf
         HtnlKJPsgpKXgmoXQZ6HhDzJm21PDspw4gsUWN917RDoGsgE5WgR194kLb7Ykxq0ELtE
         qfhBPNqzlKE08rmhjkvapsYmqJykehpqsraB8YyaJCb7oL0R5uOF+M09rmKOLdb9ye7x
         MeRVoDTtQ0hll6XtuLW/pzWxxcQhCtVM4Y8ah4yOohXOLu7x1YmK5U/Gfoo09esfKG0M
         jZ/PJDl7DmB/zPJL0aD0/OwUezbm8SxQy+Cq88Q36Ybr/LHLBOm3+VvyT/4WCr9fQ49I
         68zg==
X-Gm-Message-State: APjAAAVKjiqGOVaG4J5lw0xvNVbZufw4nZh3dKhoXwCbs9j33HevAYp0
        DuAyFbg+nzllAOVh0AVYvGXweQ==
X-Google-Smtp-Source: APXvYqzpRyNA15Vg4dJPptP9AquA0hd08+YvFQ9QkFLiFtu1omZ5ju/uevoFFYsI/1tqgZOzWDDXnw==
X-Received: by 2002:ac8:1a7d:: with SMTP id q58mr88042253qtk.310.1564668914103;
        Thu, 01 Aug 2019 07:15:14 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id e125sm29217763qkd.120.2019.08.01.07.15.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 01 Aug 2019 07:15:13 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1htBrN-00082a-0Q; Thu, 01 Aug 2019 11:15:13 -0300
Date:   Thu, 1 Aug 2019 11:15:12 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190801141512.GB23899@ziepe.ca>
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-8-jasowang@redhat.com>
 <20190731123935.GC3946@ziepe.ca>
 <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
 <20190731193057.GG3946@ziepe.ca>
 <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 01:02:18PM +0800, Jason Wang wrote:
> 
> On 2019/8/1 上午3:30, Jason Gunthorpe wrote:
> > On Wed, Jul 31, 2019 at 09:28:20PM +0800, Jason Wang wrote:
> > > On 2019/7/31 下午8:39, Jason Gunthorpe wrote:
> > > > On Wed, Jul 31, 2019 at 04:46:53AM -0400, Jason Wang wrote:
> > > > > We used to use RCU to synchronize MMU notifier with worker. This leads
> > > > > calling synchronize_rcu() in invalidate_range_start(). But on a busy
> > > > > system, there would be many factors that may slow down the
> > > > > synchronize_rcu() which makes it unsuitable to be called in MMU
> > > > > notifier.
> > > > > 
> > > > > A solution is SRCU but its overhead is obvious with the expensive full
> > > > > memory barrier. Another choice is to use seqlock, but it doesn't
> > > > > provide a synchronization method between readers and writers. The last
> > > > > choice is to use vq mutex, but it need to deal with the worst case
> > > > > that MMU notifier must be blocked and wait for the finish of swap in.
> > > > > 
> > > > > So this patch switches use a counter to track whether or not the map
> > > > > was used. The counter was increased when vq try to start or finish
> > > > > uses the map. This means, when it was even, we're sure there's no
> > > > > readers and MMU notifier is synchronized. When it was odd, it means
> > > > > there's a reader we need to wait it to be even again then we are
> > > > > synchronized.
> > > > You just described a seqlock.
> > > 
> > > Kind of, see my explanation below.
> > > 
> > > 
> > > > We've been talking about providing this as some core service from mmu
> > > > notifiers because nearly every use of this API needs it.
> > > 
> > > That would be very helpful.
> > > 
> > > 
> > > > IMHO this gets the whole thing backwards, the common pattern is to
> > > > protect the 'shadow pte' data with a seqlock (usually open coded),
> > > > such that the mmu notififer side has the write side of that lock and
> > > > the read side is consumed by the thread accessing or updating the SPTE.
> > > 
> > > Yes, I've considered something like that. But the problem is, mmu notifier
> > > (writer) need to wait for the vhost worker to finish the read before it can
> > > do things like setting dirty pages and unmapping page.  It looks to me
> > > seqlock doesn't provide things like this.
> > The seqlock is usually used to prevent a 2nd thread from accessing the
> > VA while it is being changed by the mm. ie you use something seqlocky
> > instead of the ugly mmu_notifier_unregister/register cycle.
> 
> 
> Yes, so we have two mappings:
> 
> [1] vring address to VA
> [2] VA to PA
> 
> And have several readers and writers
> 
> 1) set_vring_num_addr(): writer of both [1] and [2]
> 2) MMU notifier: reader of [1] writer of [2]
> 3) GUP: reader of [1] writer of [2]
> 4) memory accessors: reader of [1] and [2]
> 
> Fortunately, 1) 3) and 4) have already synchronized through vq->mutex. We
> only need to deal with synchronization between 2) and each of the reset:
> Sync between 1) and 2): For mapping [1], I do
> mmu_notifier_unregister/register. This help to avoid holding any lock to do
> overlap check.

I suspect you could have done this with a RCU technique instead of
register/unregister.

> Sync between 2) and 4): For mapping [1], both are readers, no need any
> synchronization. For mapping [2], synchronize through RCU (or something
> simliar to seqlock).

You can't really use a seqlock, seqlocks are collision-retry locks,
and the semantic here is that invalidate_range_start *MUST* not
continue until thread doing #4 above is guarenteed no longer touching
the memory.

This must be a proper barrier, like a spinlock, mutex, or
synchronize_rcu.

And, again, you can't re-invent a spinlock with open coding and get
something better.

Jason
