Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E9083124
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 14:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbfHFMES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 08:04:18 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46666 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfHFMES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 08:04:18 -0400
Received: by mail-qt1-f194.google.com with SMTP id h21so84142410qtn.13
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 05:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=/FPGr6jzHPYMmvLrWMP/4jeZ5wMtWr8MomConqYdxCw=;
        b=kwN8iZgGsA616k+ie7zVtqoKkPJCUoU9iiNH6foaeOBTxgKFKg+cZig/4zEdPfsbAE
         imTkOw+N/gal+1pboal/fWK91KxOgzhhMdL0iTRREJABvKyEt3Ufx9IKidWtLDpA7wlG
         9D0U+Ocv+7+jGN8gmxkVmfJqgoulbE7JQaMbA++nVny+EMylWeaEfpgkD0hSjvguAUdx
         LTme6+JAjIDsU31cell6nZpPIOasOpsE3BLX48Nh53wDpRS1MGS6UPgJlSEriefVBoaW
         X9Q/yQXt7r0a9KNgEj2XwtztzIPh4TLr8mCicotwiPelZo/OQ+sSdt6ODRD0nTuMLItg
         nPCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=/FPGr6jzHPYMmvLrWMP/4jeZ5wMtWr8MomConqYdxCw=;
        b=oLouP9ngiGfiU0EjiZu6hNhPQOEZi5WBGFBaf8ZLqRRKvoQ1GEfuYq0ThUaF5jMIi0
         8zFgPsmjvELELa5CHDddNUneg9MnMATDtsIbKyolcwigewyBAxwhwsuXBElz/Y4ByK7y
         Ro9qjIGRERZzMbLldWZOyl2i5d8Trz7EWGtkXR1fxauaNa0DXV/guwa+2Pak52FlO09R
         QAwWDKZMdy+7nkz6vi74XisWjAy9uH//mCQMzhdQrptia6qnX9sq9xWrCQr19D6EygCu
         XYEzh7q9JEHPCmCCStYHOgqqzJmdREZH6qOBio0E1NckciCEIXKZ9rn/hH70nG6est5o
         +DRw==
X-Gm-Message-State: APjAAAWgQAFyg3gn6DEp2X72Wao5VFeY7KL0tWXb2plj0ZWclg1WblYE
        JlWuyr8d31hP7hQS4TCwPmhtqA==
X-Google-Smtp-Source: APXvYqyl6pRejslnyvYVBtbHRarAvLE8/IwB9kBOqtljVW3kFuK45lKI6xsfV3oqosPPvOz7rhnfwA==
X-Received: by 2002:ac8:252e:: with SMTP id 43mr2606764qtm.61.1565093057443;
        Tue, 06 Aug 2019 05:04:17 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id c45sm44553632qte.70.2019.08.06.05.04.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Aug 2019 05:04:16 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1huyCO-0003hy-5t; Tue, 06 Aug 2019 09:04:16 -0300
Date:   Tue, 6 Aug 2019 09:04:16 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190806120416.GB11627@ziepe.ca>
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-8-jasowang@redhat.com>
 <20190731123935.GC3946@ziepe.ca>
 <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
 <20190731193057.GG3946@ziepe.ca>
 <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
 <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
 <20190802124613.GA11245@ziepe.ca>
 <11b2a930-eae4-522c-4132-3f8a2da05666@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11b2a930-eae4-522c-4132-3f8a2da05666@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 12:20:45PM +0800, Jason Wang wrote:
> 
> On 2019/8/2 下午8:46, Jason Gunthorpe wrote:
> > On Fri, Aug 02, 2019 at 05:40:07PM +0800, Jason Wang wrote:
> > > > This must be a proper barrier, like a spinlock, mutex, or
> > > > synchronize_rcu.
> > > 
> > > I start with synchronize_rcu() but both you and Michael raise some
> > > concern.
> > I've also idly wondered if calling synchronize_rcu() under the various
> > mm locks is a deadlock situation.
> 
> 
> Maybe, that's why I suggest to use vhost_work_flush() which is much
> lightweight can can achieve the same function. It can guarantee all previous
> work has been processed after vhost_work_flush() return.

If things are already running in a work, then yes, you can piggyback
on the existing spinlocks inside the workqueue and be Ok

However, if that work is doing any copy_from_user, then the flush
becomes dependent on swap and it won't work again...

> > > 1) spinlock: add lots of overhead on datapath, this leads 0 performance
> > > improvement.
> > I think the topic here is correctness not performance improvement> 
 
> But the whole series is to speed up vhost.

So? Starting with a whole bunch of crazy, possibly broken, locking and
claiming a performance win is not reasonable.

> Spinlock is correct but make the whole series meaningless consider it won't
> bring any performance improvement.

You can't invent a faster spinlock by opencoding some wild
scheme. There is nothing special about the usage here, it needs a
blocking lock, plain and simple.

Jason
