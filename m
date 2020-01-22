Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A571D145432
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 13:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgAVMJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 07:09:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29810 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726094AbgAVMJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 07:09:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579694986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zHwfkuc8Q3299qOemlSlUkZGJlKQhR4nHzpqwZfcinM=;
        b=CEnYEk1U1F4SFCQoy7zkIa33cd5TlZE9JkJNHHVL+dNSZaItJGSO+UFNxlcTEP7S1Pn+W8
        bor0Ibq/xkPXC1Ism0Xh7q/o39K+pQY5ggNyPv7dnIXa0I/OllqJ7nk++43QN7F12L2o4w
        hZFB3BpwUt7qdLnj3sHRJu3zQOmOpC0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-krULHh6UM_-acb1iRKThLw-1; Wed, 22 Jan 2020 07:09:44 -0500
X-MC-Unique: krULHh6UM_-acb1iRKThLw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34FAF8010CC;
        Wed, 22 Jan 2020 12:09:43 +0000 (UTC)
Received: from carbon (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F6181CB;
        Wed, 22 Jan 2020 12:09:33 +0000 (UTC)
Date:   Wed, 22 Jan 2020 13:09:32 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Matteo Croce <mcroce@redhat.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        brouer@redhat.com
Subject: Re: Created benchmarks modules for page_pool
Message-ID: <20200122130932.0209cb27@carbon>
In-Reply-To: <20200122104205.GA569175@apalos.home>
References: <20200121170945.41e58f32@carbon>
        <20200122104205.GA569175@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jan 2020 12:42:05 +0200
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> Hi Jesper, 
> 
> On Tue, Jan 21, 2020 at 05:09:45PM +0100, Jesper Dangaard Brouer wrote:
> > Hi Ilias and Lorenzo, (Cc others + netdev)
> > 
> > I've created two benchmarks modules for page_pool.
> > 
> > [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c
> > [2] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_cross_cpu.c
> > 
> > I think we/you could actually use this as part of your presentation[3]?  
> 
> I think we can mention this as part of the improvements we can offer,
> alongside with native SKB recycling.

Yes, but you should notice that the cross CPU return benchmark test
show that we/page_pool is too slow...


> > 
> > The first benchmark[1] illustrate/measure what happen when page_pool
> > alloc and free/return happens on the same CPU.  Here there are 3
> > modes of operations with different performance characteristic.
> > 
> > Fast_path NAPI recycle (XDP_DROP use-case)
> >  - cost per elem: 15 cycles(tsc) 4.437 ns
> > 
> > Recycle via ptr_ring
> >  - cost per elem: 48 cycles(tsc) 13.439 ns
> > 
> > Failed recycle, return to page-allocator
> >  - cost per elem: 256 cycles(tsc) 71.169 ns
> > 
> > 
> > The second benchmark[2] measures what happens cross-CPU.  It is
> > primarily the concurrent return-path that I want to capture. As this
> > is page_pool's weak spot, that we/I need to improve performance of.
> > Hint when SKBs use page_pool return this will happen more often.
> > It is a little more tricky to get proper measurement as we want to
> > observe the case, where return-path isn't stalling/waiting on pages
> > to return.
> > 
> > - 1 CPU returning  , cost per elem: 110 cycles(tsc)   30.709 ns
> > - 2 concurrent CPUs, cost per elem: 989 cycles(tsc)  274.861 ns
> > - 3 concurrent CPUs, cost per elem: 2089 cycles(tsc) 580.530 ns
> > - 4 concurrent CPUs, cost per elem: 2339 cycles(tsc) 649.984 ns  

Add a small bug, thus re-run of cross_cpu bench numbers:

- 2 concurrent CPUs, cost per elem:  462 cycles(tsc) 128.502 ns
- 3 concurrent CPUs, cost per elem: 1992 cycles(tsc) 553.507 ns
- 4 concurrent CPUs, cost per elem: 2323 cycles(tsc) 645.389 ns


> Interesting, i'll try having a look at the code and maybe run then on
> my armv8 board.

That will be great, but we/you have to fixup the Intel specific ASM
instructions in time_bench.c (which we already discussed on IRC).

> > 
> > [3] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-to-a-NIC-driver


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

