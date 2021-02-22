Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F9E3220E8
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 21:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhBVUqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 15:46:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40798 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230240AbhBVUp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 15:45:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614026671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=erluArlaVAOIhhxxcfXEzi/7V6axp72oHCGJmv+45x0=;
        b=X/+j5Nr1P8zSnHj4na53MJq5TeYdtZpEoRT/PLZ60/w4Kd16l4NCy+tSiXMT3nod1d4cCf
        PfE34ls7WUcaiNYftWxtc6uvT9pYJ1OdWBoF/k90G4RBy+qXKyz8YZHilujqLR3SDiYmPf
        X/e0l7G9iUKWAhklWQ+tXAK0+0+jvBA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-GImMfmVFPsaqzxcBzxSfGg-1; Mon, 22 Feb 2021 15:44:28 -0500
X-MC-Unique: GImMfmVFPsaqzxcBzxSfGg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C6B5107ACE6;
        Mon, 22 Feb 2021 20:44:27 +0000 (UTC)
Received: from carbon (unknown [10.36.110.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 756B85C1BD;
        Mon, 22 Feb 2021 20:44:22 +0000 (UTC)
Date:   Mon, 22 Feb 2021 21:44:20 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Chuck Lever <chuck.lever@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, brouer@redhat.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: alloc_pages_bulk()
Message-ID: <20210222214420.1341e50f@carbon>
In-Reply-To: <20210215120608.GE3697@techsingularity.net>
References: <2A0C36E7-8CB0-486F-A8DB-463CA28C5C5D@oracle.com>
        <EEB0B974-6E63-41A0-9C01-F0DEA39FC4BF@oracle.com>
        <20210209113108.1ca16cfa@carbon>
        <20210210084155.GA3697@techsingularity.net>
        <20210210124103.56ed1e95@carbon>
        <20210210130705.GC3629@suse.de>
        <B123FB11-661F-45A6-8235-2982BF3C4B83@oracle.com>
        <20210211091235.GC3697@techsingularity.net>
        <F3CD435E-905F-4262-B4DA-0C721A4235E1@oracle.com>
        <20210215120608.GE3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Feb 2021 12:06:09 +0000
Mel Gorman <mgorman@techsingularity.net> wrote:

> On Thu, Feb 11, 2021 at 04:20:31PM +0000, Chuck Lever wrote:
> > > On Feb 11, 2021, at 4:12 AM, Mel Gorman <mgorman@techsingularity.net> wrote:
> > > 
> > > <SNIP>
> > > 
> > > Parameters to __rmqueue_pcplist are garbage as the parameter order changed.
> > > I'm surprised it didn't blow up in a spectacular fashion. Again, this
> > > hasn't been near any testing and passing a list with high orders to
> > > free_pages_bulk() will corrupt lists too. Mostly it's a curiousity to see
> > > if there is justification for reworking the allocator to fundamentally
> > > deal in batches and then feed batches to pcp lists and the bulk allocator
> > > while leaving the normal GFP API as single page "batches". While that
> > > would be ideal, it's relatively high risk for regressions. There is still
> > > some scope for adding a basic bulk allocator before considering a major
> > > refactoring effort.
> > > 
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index f8353ea7b977..8f3fe7de2cf7 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -5892,7 +5892,7 @@ __alloc_pages_bulk_nodemask(gfp_t gfp_mask, unsigned int order,
> > > 	pcp_list = &pcp->lists[migratetype];
> > > 
> > > 	while (nr_pages) {
> > > -		page = __rmqueue_pcplist(zone, gfp_mask, migratetype,
> > > +		page = __rmqueue_pcplist(zone, migratetype, alloc_flags,
> > > 								pcp, pcp_list);
> > > 		if (!page)
> > > 			break;  
> > 
> > The NFS server is considerably more stable now. Thank you!
> >   
> 
> Thanks for testing!

I've done some testing here:
 https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org

Performance summary:
 - Before: 3,677,958 pps
 - After : 4,066,028 pps

I'll describe/show the page_pool changes tomorrow.
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

