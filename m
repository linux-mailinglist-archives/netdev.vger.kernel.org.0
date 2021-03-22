Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F1F34406F
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 13:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhCVMFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 08:05:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230374AbhCVMFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 08:05:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616414702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U/bXzYpa0lKIDumM59ovfcEAUhcz1AW0rt4Zc9RBDwI=;
        b=M0Up/iKJpZnbO7t0K1fd0fLiSB5tvOGtQ2oMOod88DocD1ooqXrD5pFawtrIqFYO8BqGzK
        7mA8WxqcOu+t2c9Zbjp7R+l6vIWpGakuaO7ZONX+1OLLpN2P8Wy5tdpUM2hEGDIQGzB41x
        dLOc6toXvsotH28sHtfkEgj4UeNLnuY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-G68X7_svO-SvZ5akdVQh2w-1; Mon, 22 Mar 2021 08:04:58 -0400
X-MC-Unique: G68X7_svO-SvZ5akdVQh2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 968B97BA0;
        Mon, 22 Mar 2021 12:04:56 +0000 (UTC)
Received: from carbon (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74A3219C99;
        Mon, 22 Mar 2021 12:04:48 +0000 (UTC)
Date:   Mon, 22 Mar 2021 13:04:46 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH 0/3 v5] Introduce a bulk order-0 page allocator
Message-ID: <20210322130446.0a505db0@carbon>
In-Reply-To: <20210322091845.16437-1-mgorman@techsingularity.net>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Mar 2021 09:18:42 +0000
Mel Gorman <mgorman@techsingularity.net> wrote:

> This series is based on top of Matthew Wilcox's series "Rationalise
> __alloc_pages wrapper" and does not apply to 5.12-rc2. If you want to
> test and are not using Andrew's tree as a baseline, I suggest using the
> following git tree
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v5r9

page_bench04_bulk[1] micro-benchmark on branch: mm-bulk-rebase-v5r9
 [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/mm/bench/page_bench04_bulk.c

BASELINE
 single_page alloc+put: Per elem: 199 cycles(tsc) 55.472 ns

LIST variant: time_bulk_page_alloc_free_list: step=bulk size

 Per elem: 206 cycles(tsc) 57.478 ns (step:1)
 Per elem: 154 cycles(tsc) 42.861 ns (step:2)
 Per elem: 145 cycles(tsc) 40.536 ns (step:3)
 Per elem: 142 cycles(tsc) 39.477 ns (step:4)
 Per elem: 142 cycles(tsc) 39.610 ns (step:8)
 Per elem: 137 cycles(tsc) 38.155 ns (step:16)
 Per elem: 135 cycles(tsc) 37.739 ns (step:32)
 Per elem: 134 cycles(tsc) 37.282 ns (step:64)
 Per elem: 133 cycles(tsc) 36.993 ns (step:128)

ARRAY variant: time_bulk_page_alloc_free_array: step=bulk size

 Per elem: 202 cycles(tsc) 56.383 ns (step:1)
 Per elem: 144 cycles(tsc) 40.047 ns (step:2)
 Per elem: 134 cycles(tsc) 37.339 ns (step:3)
 Per elem: 128 cycles(tsc) 35.578 ns (step:4)
 Per elem: 120 cycles(tsc) 33.592 ns (step:8)
 Per elem: 116 cycles(tsc) 32.362 ns (step:16)
 Per elem: 113 cycles(tsc) 31.476 ns (step:32)
 Per elem: 110 cycles(tsc) 30.633 ns (step:64)
 Per elem: 110 cycles(tsc) 30.596 ns (step:128)

Compared to the previous results (see below) list-variant got faster,
but array-variant is still faster.  The array variant lost a little
performance.  I think this can be related to the stats counters got
added/moved inside the loop, in this patchset.

Previous results from:
 https://lore.kernel.org/netdev/20210319181031.44dd3113@carbon/

On Fri, 19 Mar 2021 18:10:31 +0100 Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> BASELINE
>  single_page alloc+put: 207 cycles(tsc) 57.773 ns
> 
> LIST variant: time_bulk_page_alloc_free_list: step=bulk size
> 
>  Per elem: 294 cycles(tsc) 81.866 ns (step:1)
>  Per elem: 214 cycles(tsc) 59.477 ns (step:2)
>  Per elem: 199 cycles(tsc) 55.504 ns (step:3)
>  Per elem: 192 cycles(tsc) 53.489 ns (step:4)
>  Per elem: 188 cycles(tsc) 52.456 ns (step:8)
>  Per elem: 184 cycles(tsc) 51.346 ns (step:16)
>  Per elem: 183 cycles(tsc) 50.883 ns (step:32)
>  Per elem: 184 cycles(tsc) 51.236 ns (step:64)
>  Per elem: 189 cycles(tsc) 52.620 ns (step:128)
> 
> ARRAY variant: time_bulk_page_alloc_free_array: step=bulk size
> 
>  Per elem: 195 cycles(tsc) 54.174 ns (step:1)
>  Per elem: 123 cycles(tsc) 34.224 ns (step:2)
>  Per elem: 113 cycles(tsc) 31.430 ns (step:3)
>  Per elem: 108 cycles(tsc) 30.003 ns (step:4)
>  Per elem: 102 cycles(tsc) 28.417 ns (step:8)
>  Per elem:  98 cycles(tsc) 27.475 ns (step:16)
>  Per elem:  96 cycles(tsc) 26.901 ns (step:32)
>  Per elem:  95 cycles(tsc) 26.487 ns (step:64)
>  Per elem:  94 cycles(tsc) 26.170 ns (step:128)

> The users of the API have been dropped in this version as the callers
> need to check whether they prefer an array or list interface (whether
> preference is based on convenience or performance).

I'll start coding up the page_pool API user and benchmark that.

> Changelog since v4
> o Drop users of the API
> o Remove free_pages_bulk interface, no users

In [1] benchmark I just open-coded free_pages_bulk():
 https://github.com/netoptimizer/prototype-kernel/commit/49d224b19850b767c

> o Add array interface
> o Allocate single page if watermark checks on local zones fail

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

