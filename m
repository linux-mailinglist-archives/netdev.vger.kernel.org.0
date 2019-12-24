Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5A1129E7A
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 08:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbfLXHlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 02:41:11 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52491 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfLXHlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 02:41:10 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so1712695wmc.2
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 23:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v0VAmnhdebnxv7lTrxqMAa5GegnphCGLfAXE1e+3WA0=;
        b=U3YZm9DjXESahYqKFAj3AISEVv0ieD5Bo9qmUOZtsv+5KFkiSVxrossklLGPtr86lx
         4MBeBfC8IxOOISBxRWIOD5E9QfZdpGrW9OlUBZfyEjivxg9A2FA3DbQpkpry73y+0b6N
         k+HCYkNWQQ7y6de42E/zcX9CF6D/kiThUj/ftiusjMIJpODCoi7nZOnJuRNksTGXImTD
         E91+x9K9RHqsJyHZYoqcUvn6INyYLYB9QbqyJuSp/nn4d/g6FxpTnqAmLlOxtTA8EeqD
         Y5Gwrb4q7QXyn8UEey4JjxbJfbMllQO7wvyDY+HZ67Hxc4/J3ZmMaCXc7BXrHdnUEe0/
         B3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v0VAmnhdebnxv7lTrxqMAa5GegnphCGLfAXE1e+3WA0=;
        b=EbruhnpPM31jSREX6cYep4T5ylLyQEloKl5+noAh4nuKfVVUaiOgXp3owBC/4Y2XOK
         DWys2mluD975q4I7Ijlt0pb+V/jmqRxF9XX6N8RbUruTRFpllU80q1NQLQoOb+UQLDT6
         zoa7BuGsGJabk4sm+6vuHJIdZt+p32k+vID242CTuzSed2L1v1aSCtKbLGT29QH1y9k2
         f08wQPsDwS37/ProK/ZfHrVKxurJ7h5Tqu9BzJW7a83e1CP+ZLnIwCb2zYQA0juC+ETT
         /GzAlpCZdn7xbhq7oKRqJSXXnYP3I1BKEh4wQrBpDlbL9hxYBBO1e18Bnutvph5mx6hc
         7R5Q==
X-Gm-Message-State: APjAAAX9rGgihXKRDcobtqOh0EqZ7LSebaFCUwcDLArM1kQYPioz7Zx3
        tsyfjl4ItXL8OMgLdyRKa9YCBA==
X-Google-Smtp-Source: APXvYqwo4ltOAsTEdb6NMVSH4uNofK/s7WAP4ylQc5u4tmNuXWYau1WZfd7HeptLiAYByP4IsjC5PQ==
X-Received: by 2002:a7b:c5cd:: with SMTP id n13mr2722602wmk.172.1577173267101;
        Mon, 23 Dec 2019 23:41:07 -0800 (PST)
Received: from apalos.home (ppp-94-64-118-170.home.otenet.gr. [94.64.118.170])
        by smtp.gmail.com with ESMTPSA id n3sm22689586wrs.8.2019.12.23.23.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 23:41:06 -0800 (PST)
Date:   Tue, 24 Dec 2019 09:41:03 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, lirongqing@baidu.com,
        linyunsheng@huawei.com, Saeed Mahameed <saeedm@mellanox.com>,
        mhocko@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next v5 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Message-ID: <20191224074103.GB2819@apalos.home>
References: <20191218084437.6db92d32@carbon>
 <157676523108.200893.4571988797174399927.stgit@firesoul>
 <20191220102314.GB14269@apalos.home>
 <20191220114116.59d86ff6@carbon>
 <20191220104937.GA15487@apalos.home>
 <20191220162254.0138263e@carbon>
 <20191220160649.GA26788@apalos.home>
 <20191223075700.GA5333@apalos.home>
 <20191223175257.164557cd@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191223175257.164557cd@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper,

On Mon, Dec 23, 2019 at 05:52:57PM +0100, Jesper Dangaard Brouer wrote:
> On Mon, 23 Dec 2019 09:57:00 +0200
> Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> 
> > Hi Jesper,
> > 
> > Looking at the overall path again, i still need we need to reconsider 
> > pool->p.nid semantics.
> > 
> > As i said i like the patch and the whole functionality and code seems fine,
> > but here's the current situation.
> 
> > If a user sets pool->p.nid == NUMA_NO_NODE and wants to use
> > page_pool_update_nid() the whole behavior feels a liitle odd.
> 
> As soon as driver uses page_pool_update_nid() than means they want to
> control the NUMA placement explicitly.  As soon as that happens, it is
> the drivers responsibility and choice, and page_pool API must respect
> that (and not automatically change that behind drivers back).
> 
> 
> > page_pool_update_nid() first check will always be true since .nid =
> > NUMA_NO_NODE). Then we'll update this to a real nid. So we end up
> > overwriting what the user initially coded in.
> >
> > This is close to what i proposed in the previous mails on this
> > thread. Always store a real nid even if the user explicitly requests
> > NUMA_NO_NODE.
> > 
> > So  semantics is still a problem. I'll stick to what we initially
> > suggested.
> >  1. We either *always* store a real nid
> > or 
> >  2. If NUMA_NO_NODE is present ignore every other check and recycle
> >  the memory blindly. 
> > 
> 
> Hmm... I actually disagree with both 1 and 2.
> 
> My semantics proposal:
> If driver configures page_pool with NUMA_NO_NODE, then page_pool tried
> to help get the best default performance. (Which according to
> performance measurements is to have RX-pages belong to the NUMA node
> RX-processing runs on).
> 
> The reason I want this behavior is that during driver init/boot, it can
> easily happen that a driver allocates RX-pages from wrong NUMA node.
> This will cause a performance slowdown, that normally doesn't happen,
> because without a cache (like page_pool) RX-pages would fairly quickly
> transition over to the RX NUMA node (instead we keep recycling these,
> in your case #2, where you suggest recycle blindly in case of
> NUMA_NO_NODE). IMHO page_pool should hide this border-line case from
> driver developers.

Yea #2 has different semantics than the one you propose. So if he chooses
NUMA_NO_NODE, i'd expect the machines(s) the driver sits on, are not NUMA-aware.
Think specific SoC's, i'd never expect PCI cards to use that.
As i said i don't feel strongly about this anyway, it's just another case i had
under consideration but i like what you propose more. I'll try to add 
documentation on page_pool API and describe the semantics you have in mind.


Thanks
/Ilias

> 
> --Jesper
> 
> 
> > On Fri, Dec 20, 2019 at 06:06:49PM +0200, Ilias Apalodimas wrote:
> > > On Fri, Dec 20, 2019 at 04:22:54PM +0100, Jesper Dangaard Brouer
> > > wrote:  
> > > > On Fri, 20 Dec 2019 12:49:37 +0200
> > > > Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> > > >   
> > > > > On Fri, Dec 20, 2019 at 11:41:16AM +0100, Jesper Dangaard
> > > > > Brouer wrote:  
> > > > > > On Fri, 20 Dec 2019 12:23:14 +0200
> > > > > > Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> > > > > >     
> > > > > > > Hi Jesper, 
> > > > > > > 
> > > > > > > I like the overall approach since this moves the check out
> > > > > > > of  the hotpath. @Saeed, since i got no hardware to test
> > > > > > > this on, would it be possible to check that it still works
> > > > > > > fine for mlx5?
> > > > > > > 
> > > > > > > [...]    
> > > > > > > > +	struct ptr_ring *r = &pool->ring;
> > > > > > > > +	struct page *page;
> > > > > > > > +	int pref_nid; /* preferred NUMA node */
> > > > > > > > +
> > > > > > > > +	/* Quicker fallback, avoid locks when ring is
> > > > > > > > empty */
> > > > > > > > +	if (__ptr_ring_empty(r))
> > > > > > > > +		return NULL;
> > > > > > > > +
> > > > > > > > +	/* Softirq guarantee CPU and thus NUMA node is
> > > > > > > > stable. This,
> > > > > > > > +	 * assumes CPU refilling driver RX-ring will
> > > > > > > > also run RX-NAPI.
> > > > > > > > +	 */
> > > > > > > > +	pref_nid = (pool->p.nid == NUMA_NO_NODE) ?
> > > > > > > > numa_mem_id() : pool->p.nid;      
> > > > > > > 
> > > > > > > One of the use cases for this is that during the allocation
> > > > > > > we are not guaranteed to pick up the correct NUMA node. 
> > > > > > > This will get automatically fixed once the driver starts
> > > > > > > recycling packets. 
> > > > > > > 
> > > > > > > I don't feel strongly about this, since i don't usually
> > > > > > > like hiding value changes from the user but, would it make
> > > > > > > sense to move this into __page_pool_alloc_pages_slow() and
> > > > > > > change the pool->p.nid?
> > > > > > > 
> > > > > > > Since alloc_pages_node() will replace NUMA_NO_NODE with
> > > > > > > numa_mem_id() regardless, why not store the actual node in
> > > > > > > our page pool information? You can then skip this and check
> > > > > > > pool->p.nid == numa_mem_id(), regardless of what's
> > > > > > > configured.     
> > > > > > 
> > > > > > This single code line helps support that drivers can control
> > > > > > the nid themselves.  This is a feature that is only used my
> > > > > > mlx5 AFAIK.
> > > > > > 
> > > > > > I do think that is useful to allow the driver to "control"
> > > > > > the nid, as pinning/preferring the pages to come from the
> > > > > > NUMA node that matches the PCI-e controller hardware is
> > > > > > installed in does have benefits.    
> > > > > 
> > > > > Sure you can keep the if statement as-is, it won't break
> > > > > anything. Would we want to store the actual numa id in
> > > > > pool->p.nid if the user selects 'NUMA_NO_NODE'?  
> > > >  
> > > > No. pool->p.nid should stay as NUMA_NO_NODE, because that makes it
> > > > dynamic.  If someone moves an RX IRQ to another CPU on another
> > > > NUMA node, then this 'NUMA_NO_NODE' setting makes pages
> > > > transitioned automatically.  
> > > Ok this assumed that drivers were going to use
> > > page_pool_nid_changed(), but with the current code we don't have to
> > > force them to do that. Let's keep this as-is.
> > > 
> > > I'll be running a few more tests  and wait in case Saeed gets a
> > > chance to test it and send my reviewed-by
> 
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
