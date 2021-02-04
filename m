Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1BC30EF4E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 10:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbhBDJKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 04:10:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25892 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234977AbhBDJHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 04:07:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612429587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B3XB7bhuMyDBoFacNy+YTRK/8xPrEseZ54khKHzy2Gk=;
        b=KPeTkwoyx8i7XY0/YzpWrw2yU/c/ZWt635XKIMORZs8jZT1IFLDyeKtjzbDZjp2s+/1BYs
        /indxotUQWZf2gVs/7F0GrbLv61uWI9I4OCWJ0n0vMWXyPwF9Y2UDMgdP4r8YjnXFnLkpV
        q9bRa3jXwJhAkLJmMJW3N6dg0ozaViA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-TCtX5yv2MMaauNfig9HizQ-1; Thu, 04 Feb 2021 04:06:23 -0500
X-MC-Unique: TCtX5yv2MMaauNfig9HizQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83C5E100A8EA;
        Thu,  4 Feb 2021 09:06:21 +0000 (UTC)
Received: from carbon.lan (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E212B57;
        Thu,  4 Feb 2021 09:05:59 +0000 (UTC)
Date:   Thu, 4 Feb 2021 10:05:56 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, toshiaki.makita1@gmail.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, brouer@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 bpf-next] net: veth: alloc skb in bulk for
 ndo_xdp_xmit
Message-ID: <20210204100556.59459549@carbon.lan>
In-Reply-To: <e2ae0d97-376a-07db-94fb-14f1220acca5@iogearbox.net>
References: <a14a30d3c06fff24e13f836c733d80efc0bd6eb5.1611957532.git.lorenzo@kernel.org>
        <e2ae0d97-376a-07db-94fb-14f1220acca5@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Feb 2021 01:14:56 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 1/29/21 11:04 PM, Lorenzo Bianconi wrote:
> > Split ndo_xdp_xmit and ndo_start_xmit use cases in veth_xdp_rcv routine
> > in order to alloc skbs in bulk for XDP_PASS verdict.
> > Introduce xdp_alloc_skb_bulk utility routine to alloc skb bulk list.
> > The proposed approach has been tested in the following scenario:  
> [...]
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index 0d2630a35c3e..05354976c1fc 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -514,6 +514,17 @@ void xdp_warn(const char *msg, const char *func, const int line)
> >   };
> >   EXPORT_SYMBOL_GPL(xdp_warn);
> >   
> > +int xdp_alloc_skb_bulk(void **skbs, int n_skb, gfp_t gfp)
> > +{
> > +	n_skb = kmem_cache_alloc_bulk(skbuff_head_cache, gfp,
> > +				      n_skb, skbs);  
> 
> Applied, but one question I was wondering about when reading the kmem_cache_alloc_bulk()
> code was whether it would be safer to simply test for kmem_cache_alloc_bulk() != n_skb
> given it could potentially in future also alloc less objs than requested, but I presume
> if such extension would get implemented then call-sites might need to indicate 'best
> effort' somehow via flag instead (to handle < n_skb case). Either way all current callers
> assume for != 0 that everything went well, so lgtm.

It was Andrew (AKPM) that wanted the API to either return the requested
number of objects or fail. I respected the MM-maintainers request at
that point, even-though I wanted the other API as there is a small
performance advantage (not crossing page boundary in SLUB).

At that time we discussed it on MM-list, and I see his/the point:
If API can allocate less objs than requested, then think about how this
complicated the surrounding code. E.g. in this specific code we already
have VETH_XDP_BATCH(16) xdp_frame objects, which we need to get 16 SKB
objects for.  What should the code do if it cannot get 16 SKBs(?).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

