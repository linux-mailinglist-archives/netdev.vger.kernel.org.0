Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4D6C127F30
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfLTPXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:23:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29130 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727362AbfLTPXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:23:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576855388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=REPT/CW2BcWBlFErj4a87Ibw25mwKgnWDpl3f0NJphc=;
        b=jBJ8C1Kiks0f86+E3JuJqJbDmRwclFf6scJMw1h4/M22cIJI8BsQRiVyJ3RrBKlQwBlq/M
        r1N/DGPoTTyOib5CL+qozntTkq4EhKRIHurTGKTUA8Ab83O/2Pwd9UIblNEbZ2kVBa6zXl
        mOsEuWKsDycudsyRw7XaH381HA8x4rQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-UxnnOdlxOiufnf7vQkk-kA-1; Fri, 20 Dec 2019 10:23:04 -0500
X-MC-Unique: UxnnOdlxOiufnf7vQkk-kA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47E97189DF6C;
        Fri, 20 Dec 2019 15:23:03 +0000 (UTC)
Received: from carbon (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 311FB60C81;
        Fri, 20 Dec 2019 15:22:55 +0000 (UTC)
Date:   Fri, 20 Dec 2019 16:22:54 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, lirongqing@baidu.com,
        linyunsheng@huawei.com, Saeed Mahameed <saeedm@mellanox.com>,
        mhocko@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, brouer@redhat.com
Subject: Re: [net-next v5 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Message-ID: <20191220162254.0138263e@carbon>
In-Reply-To: <20191220104937.GA15487@apalos.home>
References: <20191218084437.6db92d32@carbon>
        <157676523108.200893.4571988797174399927.stgit@firesoul>
        <20191220102314.GB14269@apalos.home>
        <20191220114116.59d86ff6@carbon>
        <20191220104937.GA15487@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Dec 2019 12:49:37 +0200
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> On Fri, Dec 20, 2019 at 11:41:16AM +0100, Jesper Dangaard Brouer wrote:
> > On Fri, 20 Dec 2019 12:23:14 +0200
> > Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> >   
> > > Hi Jesper, 
> > > 
> > > I like the overall approach since this moves the check out of  the hotpath. 
> > > @Saeed, since i got no hardware to test this on, would it be possible to check
> > > that it still works fine for mlx5?
> > > 
> > > [...]  
> > > > +	struct ptr_ring *r = &pool->ring;
> > > > +	struct page *page;
> > > > +	int pref_nid; /* preferred NUMA node */
> > > > +
> > > > +	/* Quicker fallback, avoid locks when ring is empty */
> > > > +	if (__ptr_ring_empty(r))
> > > > +		return NULL;
> > > > +
> > > > +	/* Softirq guarantee CPU and thus NUMA node is stable. This,
> > > > +	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
> > > > +	 */
> > > > +	pref_nid = (pool->p.nid == NUMA_NO_NODE) ? numa_mem_id() : pool->p.nid;    
> > > 
> > > One of the use cases for this is that during the allocation we are not
> > > guaranteed to pick up the correct NUMA node. 
> > > This will get automatically fixed once the driver starts recycling packets. 
> > > 
> > > I don't feel strongly about this, since i don't usually like hiding value
> > > changes from the user but, would it make sense to move this into 
> > > __page_pool_alloc_pages_slow() and change the pool->p.nid?
> > > 
> > > Since alloc_pages_node() will replace NUMA_NO_NODE with numa_mem_id()
> > > regardless, why not store the actual node in our page pool information?
> > > You can then skip this and check pool->p.nid == numa_mem_id(), regardless of
> > > what's configured.   
> > 
> > This single code line helps support that drivers can control the nid
> > themselves.  This is a feature that is only used my mlx5 AFAIK.
> > 
> > I do think that is useful to allow the driver to "control" the nid, as
> > pinning/preferring the pages to come from the NUMA node that matches
> > the PCI-e controller hardware is installed in does have benefits.  
> 
> Sure you can keep the if statement as-is, it won't break anything. 
> Would we want to store the actual numa id in pool->p.nid if the user
> selects 'NUMA_NO_NODE'?
 
No. pool->p.nid should stay as NUMA_NO_NODE, because that makes it
dynamic.  If someone moves an RX IRQ to another CPU on another NUMA
node, then this 'NUMA_NO_NODE' setting makes pages transitioned
automatically.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

