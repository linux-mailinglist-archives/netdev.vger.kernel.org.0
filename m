Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D0B1298EE
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 17:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLWQxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 11:53:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33617 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726718AbfLWQxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 11:53:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577119991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0I/TmtKmaCoCn2cmkchViISfqupPgahWP/OoSgDPUdw=;
        b=e61pZwn3264gchyUYHZCewAawIrmfbMuHMQDLOpAeRy7FnHleCHI74+ZZ1Bj/DkBtiiAzJ
        GSEmmSVSDlWz9bHm2ZyzC6z/sryr9n3DuCOL9kmmhzZS1yGR2S2KAS2AmkACt81Z903t0F
        Bnw7ugmpYisSdhB0hezOB1p40OOOsRw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-qolTNmXSM8idDpfAwBwgRA-1; Mon, 23 Dec 2019 11:53:07 -0500
X-MC-Unique: qolTNmXSM8idDpfAwBwgRA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4681A107ACC5;
        Mon, 23 Dec 2019 16:53:06 +0000 (UTC)
Received: from carbon (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A597860BE2;
        Mon, 23 Dec 2019 16:52:59 +0000 (UTC)
Date:   Mon, 23 Dec 2019 17:52:57 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, lirongqing@baidu.com,
        linyunsheng@huawei.com, Saeed Mahameed <saeedm@mellanox.com>,
        mhocko@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, brouer@redhat.com
Subject: Re: [net-next v5 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Message-ID: <20191223175257.164557cd@carbon>
In-Reply-To: <20191223075700.GA5333@apalos.home>
References: <20191218084437.6db92d32@carbon>
        <157676523108.200893.4571988797174399927.stgit@firesoul>
        <20191220102314.GB14269@apalos.home>
        <20191220114116.59d86ff6@carbon>
        <20191220104937.GA15487@apalos.home>
        <20191220162254.0138263e@carbon>
        <20191220160649.GA26788@apalos.home>
        <20191223075700.GA5333@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Dec 2019 09:57:00 +0200
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> Hi Jesper,
> 
> Looking at the overall path again, i still need we need to reconsider 
> pool->p.nid semantics.
> 
> As i said i like the patch and the whole functionality and code seems fine,
> but here's the current situation.

> If a user sets pool->p.nid == NUMA_NO_NODE and wants to use
> page_pool_update_nid() the whole behavior feels a liitle odd.

As soon as driver uses page_pool_update_nid() than means they want to
control the NUMA placement explicitly.  As soon as that happens, it is
the drivers responsibility and choice, and page_pool API must respect
that (and not automatically change that behind drivers back).


> page_pool_update_nid() first check will always be true since .nid =
> NUMA_NO_NODE). Then we'll update this to a real nid. So we end up
> overwriting what the user initially coded in.
>
> This is close to what i proposed in the previous mails on this
> thread. Always store a real nid even if the user explicitly requests
> NUMA_NO_NODE.
> 
> So  semantics is still a problem. I'll stick to what we initially
> suggested.
>  1. We either *always* store a real nid
> or 
>  2. If NUMA_NO_NODE is present ignore every other check and recycle
>  the memory blindly. 
> 

Hmm... I actually disagree with both 1 and 2.

My semantics proposal:
If driver configures page_pool with NUMA_NO_NODE, then page_pool tried
to help get the best default performance. (Which according to
performance measurements is to have RX-pages belong to the NUMA node
RX-processing runs on).

The reason I want this behavior is that during driver init/boot, it can
easily happen that a driver allocates RX-pages from wrong NUMA node.
This will cause a performance slowdown, that normally doesn't happen,
because without a cache (like page_pool) RX-pages would fairly quickly
transition over to the RX NUMA node (instead we keep recycling these,
in your case #2, where you suggest recycle blindly in case of
NUMA_NO_NODE). IMHO page_pool should hide this border-line case from
driver developers.

--Jesper


> On Fri, Dec 20, 2019 at 06:06:49PM +0200, Ilias Apalodimas wrote:
> > On Fri, Dec 20, 2019 at 04:22:54PM +0100, Jesper Dangaard Brouer
> > wrote:  
> > > On Fri, 20 Dec 2019 12:49:37 +0200
> > > Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> > >   
> > > > On Fri, Dec 20, 2019 at 11:41:16AM +0100, Jesper Dangaard
> > > > Brouer wrote:  
> > > > > On Fri, 20 Dec 2019 12:23:14 +0200
> > > > > Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> > > > >     
> > > > > > Hi Jesper, 
> > > > > > 
> > > > > > I like the overall approach since this moves the check out
> > > > > > of  the hotpath. @Saeed, since i got no hardware to test
> > > > > > this on, would it be possible to check that it still works
> > > > > > fine for mlx5?
> > > > > > 
> > > > > > [...]    
> > > > > > > +	struct ptr_ring *r = &pool->ring;
> > > > > > > +	struct page *page;
> > > > > > > +	int pref_nid; /* preferred NUMA node */
> > > > > > > +
> > > > > > > +	/* Quicker fallback, avoid locks when ring is
> > > > > > > empty */
> > > > > > > +	if (__ptr_ring_empty(r))
> > > > > > > +		return NULL;
> > > > > > > +
> > > > > > > +	/* Softirq guarantee CPU and thus NUMA node is
> > > > > > > stable. This,
> > > > > > > +	 * assumes CPU refilling driver RX-ring will
> > > > > > > also run RX-NAPI.
> > > > > > > +	 */
> > > > > > > +	pref_nid = (pool->p.nid == NUMA_NO_NODE) ?
> > > > > > > numa_mem_id() : pool->p.nid;      
> > > > > > 
> > > > > > One of the use cases for this is that during the allocation
> > > > > > we are not guaranteed to pick up the correct NUMA node. 
> > > > > > This will get automatically fixed once the driver starts
> > > > > > recycling packets. 
> > > > > > 
> > > > > > I don't feel strongly about this, since i don't usually
> > > > > > like hiding value changes from the user but, would it make
> > > > > > sense to move this into __page_pool_alloc_pages_slow() and
> > > > > > change the pool->p.nid?
> > > > > > 
> > > > > > Since alloc_pages_node() will replace NUMA_NO_NODE with
> > > > > > numa_mem_id() regardless, why not store the actual node in
> > > > > > our page pool information? You can then skip this and check
> > > > > > pool->p.nid == numa_mem_id(), regardless of what's
> > > > > > configured.     
> > > > > 
> > > > > This single code line helps support that drivers can control
> > > > > the nid themselves.  This is a feature that is only used my
> > > > > mlx5 AFAIK.
> > > > > 
> > > > > I do think that is useful to allow the driver to "control"
> > > > > the nid, as pinning/preferring the pages to come from the
> > > > > NUMA node that matches the PCI-e controller hardware is
> > > > > installed in does have benefits.    
> > > > 
> > > > Sure you can keep the if statement as-is, it won't break
> > > > anything. Would we want to store the actual numa id in
> > > > pool->p.nid if the user selects 'NUMA_NO_NODE'?  
> > >  
> > > No. pool->p.nid should stay as NUMA_NO_NODE, because that makes it
> > > dynamic.  If someone moves an RX IRQ to another CPU on another
> > > NUMA node, then this 'NUMA_NO_NODE' setting makes pages
> > > transitioned automatically.  
> > Ok this assumed that drivers were going to use
> > page_pool_nid_changed(), but with the current code we don't have to
> > force them to do that. Let's keep this as-is.
> > 
> > I'll be running a few more tests  and wait in case Saeed gets a
> > chance to test it and send my reviewed-by


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

