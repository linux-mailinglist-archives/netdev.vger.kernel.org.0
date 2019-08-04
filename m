Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83E1A808AA
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 02:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbfHDAOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 20:14:04 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33449 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfHDAOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 20:14:03 -0400
Received: by mail-qt1-f196.google.com with SMTP id r6so73434790qtt.0
        for <netdev@vger.kernel.org>; Sat, 03 Aug 2019 17:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WqP5IEn9c1KXpbjHniLk8HqGR3ikHJzys8MEePZlMFc=;
        b=lAi4L6Z1XyIiSM5lL1y3xq2yW7AhMhA5cc/2JWhK4Uq58oYTXRY+SEfOyGjKf6kkCb
         EPC9/wo5tKQKNgcCq7J5u94OLKKBkYAT9e7xtRKka5BNmKvZWgWXct5IFZiXhtUBed8m
         rk3hbmVvbY+x2rSZElIcRMSuJak9sbEMLouEsX5kctrioFW3dP5ZTCHUO7a88gwJF86c
         Kw4vjibh/yQ70e+pFUaKMHvh1MOZwG0UveYwUOrZxaDK9+spjQNaOE305bhzgGLhXZaG
         1qCnoPNDxKWD7uKl46B5GsKjuaJdx75qFBHdD8Xa8h8Svul5AL5C3uyvDl1nKlcQKCkP
         pPcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WqP5IEn9c1KXpbjHniLk8HqGR3ikHJzys8MEePZlMFc=;
        b=TE+6v2YIuU0UQ6aCmu5V5aKKzAs5LCQPDqICpnYZZQRtTfSUVgM+M0WfWKzWwW9yzl
         E35P1RStay9IsSsJ2HZu0acTa6sMf9Uuh4LYsZDFVC4OqhXvUhyC6TNgUzDFy3bdigy7
         un2LDdU2bxwusJRDCWZDbQXKSLDPbhqyHegUUQeNpKT9kqUEymIfc1VDazec0YagecNu
         KkEsfuIJCBw+/+1OVW1H2dkJqVzGjNFUTibn6J26lg3kB3zg0NDZF0EFVlAKisxjOBnK
         OSbksHEKn2XyezD9Nm5fOb1mgBP4u50WJHRTksm6iyb2KdZRWBSmEmGSqXdkLU1dUlkm
         A8og==
X-Gm-Message-State: APjAAAWLxwYsyYBeXQOmkaT8Sy58RSk11JVqIAjw51ptK+Q5mhV5jo9f
        TcBP9lRdKN+Qw0lSf034FO6oAMGGSsI=
X-Google-Smtp-Source: APXvYqzsyyLWq0jXkEok0bUf3FHiInYAhbn8RrkmZKAfLQFhGrLDITCXgW1cHLxjIP+uPvSHKyq3TA==
X-Received: by 2002:a05:6214:1312:: with SMTP id a18mr103640128qvv.241.1564877642991;
        Sat, 03 Aug 2019 17:14:02 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id g35sm42675590qtg.92.2019.08.03.17.14.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 03 Aug 2019 17:14:01 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hu49w-0006gS-Bm; Sat, 03 Aug 2019 21:14:00 -0300
Date:   Sat, 3 Aug 2019 21:14:00 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190804001400.GA25543@ziepe.ca>
References: <20190731123935.GC3946@ziepe.ca>
 <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
 <20190731193057.GG3946@ziepe.ca>
 <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
 <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
 <20190802124613.GA11245@ziepe.ca>
 <20190802100414-mutt-send-email-mst@kernel.org>
 <20190802172418.GB11245@ziepe.ca>
 <20190803172944-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190803172944-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 03, 2019 at 05:36:13PM -0400, Michael S. Tsirkin wrote:
> On Fri, Aug 02, 2019 at 02:24:18PM -0300, Jason Gunthorpe wrote:
> > On Fri, Aug 02, 2019 at 10:27:21AM -0400, Michael S. Tsirkin wrote:
> > > On Fri, Aug 02, 2019 at 09:46:13AM -0300, Jason Gunthorpe wrote:
> > > > On Fri, Aug 02, 2019 at 05:40:07PM +0800, Jason Wang wrote:
> > > > > > This must be a proper barrier, like a spinlock, mutex, or
> > > > > > synchronize_rcu.
> > > > > 
> > > > > 
> > > > > I start with synchronize_rcu() but both you and Michael raise some
> > > > > concern.
> > > > 
> > > > I've also idly wondered if calling synchronize_rcu() under the various
> > > > mm locks is a deadlock situation.
> > > > 
> > > > > Then I try spinlock and mutex:
> > > > > 
> > > > > 1) spinlock: add lots of overhead on datapath, this leads 0 performance
> > > > > improvement.
> > > > 
> > > > I think the topic here is correctness not performance improvement
> > > 
> > > The topic is whether we should revert
> > > commit 7f466032dc9 ("vhost: access vq metadata through kernel virtual address")
> > > 
> > > or keep it in. The only reason to keep it is performance.
> > 
> > Yikes, I'm not sure you can ever win against copy_from_user using
> > mmu_notifiers?
> 
> Ever since copy_from_user started playing with flags (for SMAP) and
> added speculation barriers there's a chance we can win by accessing
> memory through the kernel address.

You think copy_to_user will be more expensive than the minimum two
atomics required to synchronize with another thread?

> > Also, why can't this just permanently GUP the pages? In fact, where
> > does it put_page them anyhow? Worrying that 7f466 adds a get_user page
> > but does not add a put_page??

You didn't answer this.. Why not just use GUP?

Jason
