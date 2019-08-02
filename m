Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84AB67FC30
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 16:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394908AbfHBO1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 10:27:31 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:32931 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394890AbfHBO1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 10:27:30 -0400
Received: by mail-qt1-f196.google.com with SMTP id r6so69814347qtt.0
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 07:27:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P2Hb3FZglhIdbXiYdjxjKY7R3yX7bFoilggrVili8pk=;
        b=EiqCEwDQDAJ32ASKF0jMo90upqnaEDmS/tzI9b/IFOtzpf/8Cs4iBKJv87wwTsJNBx
         7JN98d2G5tFLR8xVOLw14Tq4+VpPMqgsyKC0F4KDKh3j4gOqisxVDFRI1GemD5fWBa9Y
         dWskr3MrLKaS9YNkE9Aj+6IB9NnCMfp5OF5E0MEDRQObmE23jECkJha44Mh8vuMx7qxK
         2ILmciol0Kr+xfmMni/WgkM4kyZ8I9GLmvWHpqaCjuLrIPLdYKD3Z0AQc02HOAXQ7vd2
         3rgdz3HS5Sn4FOvsa6SJSIEZcfwio4ZV1svttW3gFv66tpb5q1UYP8W7c+am2PiPfe06
         BlZg==
X-Gm-Message-State: APjAAAX4JAd1NAMbT2i6KfHNJr/2adygkLYyDXNhwUbzBEzt6AOCxWB5
        mJRb/1U4ZJU5w1di17WT3kIEeA==
X-Google-Smtp-Source: APXvYqw3KBnCa3P7200Yn0foGxB3Mb3u607NCRK+HftBdUxylQNUOizF39tGc/1MfSlJjVQ6mmiQyA==
X-Received: by 2002:aed:3944:: with SMTP id l62mr96389184qte.34.1564756049676;
        Fri, 02 Aug 2019 07:27:29 -0700 (PDT)
Received: from redhat.com ([147.234.38.1])
        by smtp.gmail.com with ESMTPSA id d20sm30304231qto.59.2019.08.02.07.27.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 07:27:28 -0700 (PDT)
Date:   Fri, 2 Aug 2019 10:27:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190802100414-mutt-send-email-mst@kernel.org>
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-8-jasowang@redhat.com>
 <20190731123935.GC3946@ziepe.ca>
 <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
 <20190731193057.GG3946@ziepe.ca>
 <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
 <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
 <20190802124613.GA11245@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802124613.GA11245@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 09:46:13AM -0300, Jason Gunthorpe wrote:
> On Fri, Aug 02, 2019 at 05:40:07PM +0800, Jason Wang wrote:
> > > This must be a proper barrier, like a spinlock, mutex, or
> > > synchronize_rcu.
> > 
> > 
> > I start with synchronize_rcu() but both you and Michael raise some
> > concern.
> 
> I've also idly wondered if calling synchronize_rcu() under the various
> mm locks is a deadlock situation.
> 
> > Then I try spinlock and mutex:
> > 
> > 1) spinlock: add lots of overhead on datapath, this leads 0 performance
> > improvement.
> 
> I think the topic here is correctness not performance improvement

The topic is whether we should revert
commit 7f466032dc9 ("vhost: access vq metadata through kernel virtual address")

or keep it in. The only reason to keep it is performance.

Now as long as all this code is disabled anyway, we can experiment a
bit.

I personally feel we would be best served by having two code paths:

- Access to VM memory directly mapped into kernel
- Access to userspace


Having it all cleanly split will allow a bunch of optimizations, for
example for years now we planned to be able to process an incoming short
packet directly on softirq path, or an outgoing on directly within
eventfd.


-- 
MST
