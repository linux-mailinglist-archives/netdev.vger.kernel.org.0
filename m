Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C132212A1EB
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 15:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfLXOE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 09:04:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28024 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726140AbfLXOE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 09:04:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577196295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vvRXiKtq5vVX/kJwHADw+3uJ2vxDs7xEqZhQPOrBwI8=;
        b=GGzyOZLzIXs4F+ykSj5ub0NdJT9fzbgZkB7hZFf0dTzFhXMYHfSOCijgr1oryeRU2gL+1v
        DyB99rCZ22iTfwk5gUHx0Vtry9OsKHSaVXknuJXMB9giYyQb44AbzAQJkGvoFtfmkXeydB
        NzPdP8uXN82OCyOqX5GJNZ2R8YJHL+c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-gWOpYcHqMzyMeoaF-xrf0g-1; Tue, 24 Dec 2019 09:04:54 -0500
X-MC-Unique: gWOpYcHqMzyMeoaF-xrf0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC8D71005502;
        Tue, 24 Dec 2019 14:04:52 +0000 (UTC)
Received: from carbon (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 930AF5456B;
        Tue, 24 Dec 2019 14:04:46 +0000 (UTC)
Date:   Tue, 24 Dec 2019 15:04:45 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tomislav Tomasic <tomislav.tomasic@sartura.hr>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, brouer@redhat.com
Subject: Re: [RFC net-next 0/2] mvpp2: page_pool support
Message-ID: <20191224150445.2d6ab982@carbon>
In-Reply-To: <CAGnkfhzrSaVe3zJ+0rriqqELha554Gmv-zskrJbiBjhHdUG2uQ@mail.gmail.com>
References: <20191224010103.56407-1-mcroce@redhat.com>
        <20191224095229.GA24310@apalos.home>
        <CAGnkfhzrSaVe3zJ+0rriqqELha554Gmv-zskrJbiBjhHdUG2uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Dec 2019 14:34:07 +0100
Matteo Croce <mcroce@redhat.com> wrote:

> On Tue, Dec 24, 2019 at 10:52 AM Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
> >
> > On Tue, Dec 24, 2019 at 02:01:01AM +0100, Matteo Croce wrote:  
> > > This patches change the memory allocator of mvpp2 from the frag allocator to
> > > the page_pool API. This change is needed to add later XDP support to mvpp2.
> > >
> > > The reason I send it as RFC is that with this changeset, mvpp2 performs much
> > > more slower. This is the tc drop rate measured with a single flow:
> > >
> > > stock net-next with frag allocator:
> > > rx: 900.7 Mbps 1877 Kpps
> > >
> > > this patchset with page_pool:
> > > rx: 423.5 Mbps 882.3 Kpps
> > >
> > > This is the perf top when receiving traffic:
> > >
> > >   27.68%  [kernel]            [k] __page_pool_clean_page  
> >
> > This seems extremly high on the list.
> >  
> > >    9.79%  [kernel]            [k] get_page_from_freelist
> > >    7.18%  [kernel]            [k] free_unref_page
> > >    4.64%  [kernel]            [k] build_skb
> > >    4.63%  [kernel]            [k] __netif_receive_skb_core
> > >    3.83%  [mvpp2]             [k] mvpp2_poll
> > >    3.64%  [kernel]            [k] eth_type_trans
> > >    3.61%  [kernel]            [k] kmem_cache_free
> > >    3.03%  [kernel]            [k] kmem_cache_alloc
> > >    2.76%  [kernel]            [k] dev_gro_receive
> > >    2.69%  [mvpp2]             [k] mvpp2_bm_pool_put
> > >    2.68%  [kernel]            [k] page_frag_free
> > >    1.83%  [kernel]            [k] inet_gro_receive
> > >    1.74%  [kernel]            [k] page_pool_alloc_pages
> > >    1.70%  [kernel]            [k] __build_skb
> > >    1.47%  [kernel]            [k] __alloc_pages_nodemask
> > >    1.36%  [mvpp2]             [k] mvpp2_buf_alloc.isra.0
> > >    1.29%  [kernel]            [k] tcf_action_exec
> > >
> > > I tried Ilias patches for page_pool recycling, I get an improvement
> > > to ~1100, but I'm still far than the original allocator.  
> >
> > Can you post the recycling perf for comparison?
> >  
> 
>   12.00%  [kernel]                  [k] get_page_from_freelist
>    9.25%  [kernel]                  [k] free_unref_page

Hmm, this indicate pages are not getting recycled.

>    6.83%  [kernel]                  [k] eth_type_trans
>    5.33%  [kernel]                  [k] __netif_receive_skb_core
>    4.96%  [mvpp2]                   [k] mvpp2_poll
>    4.64%  [kernel]                  [k] kmem_cache_free
>    4.06%  [kernel]                  [k] __xdp_return

You do invoke __xdp_return() code, but it might find that the page
cannot be recycled...

>    3.60%  [kernel]                  [k] kmem_cache_alloc
>    3.31%  [kernel]                  [k] dev_gro_receive
>    3.29%  [kernel]                  [k] __page_pool_clean_page
>    3.25%  [mvpp2]                   [k] mvpp2_bm_pool_put
>    2.73%  [kernel]                  [k] __page_pool_put_page
>    2.33%  [kernel]                  [k] __alloc_pages_nodemask
>    2.33%  [kernel]                  [k] inet_gro_receive
>    2.05%  [kernel]                  [k] __build_skb
>    1.95%  [kernel]                  [k] build_skb
>    1.89%  [cls_matchall]            [k] mall_classify
>    1.83%  [kernel]                  [k] page_pool_alloc_pages
>    1.80%  [kernel]                  [k] tcf_action_exec
>    1.70%  [mvpp2]                   [k] mvpp2_buf_alloc.isra.0
>    1.63%  [kernel]                  [k] free_unref_page_prepare.part.0
>    1.45%  [kernel]                  [k] page_pool_return_skb_page
>    1.42%  [act_gact]                [k] tcf_gact_act
>    1.16%  [kernel]                  [k] netif_receive_skb_list_internal
>    1.08%  [kernel]                  [k] kfree_skb
>    1.07%  [kernel]                  [k] skb_release_data

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

