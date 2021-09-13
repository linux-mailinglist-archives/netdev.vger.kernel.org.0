Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D35540891A
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 12:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239149AbhIMKiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 06:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239136AbhIMKiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 06:38:06 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918DBC061574;
        Mon, 13 Sep 2021 03:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5cZgY+h2VLjKmM5rPcBYeoFqyIYGYh7lJNiFwhwUejg=; b=YxO+yq6Nfw5pNJZd/1y0ZUCWiD
        k78zpd8bvVZfIfpZ7hJXZybcBf6kxzts0xeKzu+yGsyZMVUMDwziMzmsbw2J3YOKlQWyVqCzDpH4a
        XSzBo14adAxwPXr9cC8z/6g1AYP7p8HmU6vxwjoWjLUz0Y9W38th8T8MuBI1Tke4ye1ego6CGmdCM
        O6/w+vxst0O1/35362z/HiWz/JuQxQVdA43OkjvigMb/wvbjmyNeVyiHfPKIqpwkmmkzyAkeOPlrv
        M0vA0SjNlgsn59ZIGLoArrcRO6d2gVNnohzjGmPABM3teK3os4xLl8GAvajPCehEpENIkabUQ0Q9l
        Nt4xcP8w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPjKH-002nu6-3p; Mon, 13 Sep 2021 10:36:37 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 63601300047;
        Mon, 13 Sep 2021 12:36:36 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 241292BDAF0DC; Mon, 13 Sep 2021 12:36:36 +0200 (CEST)
Date:   Mon, 13 Sep 2021 12:36:36 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     =?utf-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:PERFORMANCE EVENTS SUBSYSTEM" 
        <linux-perf-users@vger.kernel.org>,
        "open list:PERFORMANCE EVENTS SUBSYSTEM" 
        <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH] perf: fix panic by mark recursion inside
 perf_log_throttle
Message-ID: <YT8ptOoN0age04PQ@hirez.programming.kicks-ass.net>
References: <ff979a43-045a-dc56-64d1-2c31dd4db381@linux.alibaba.com>
 <20210910153839.GH4323@worktop.programming.kicks-ass.net>
 <f38987a5-dc36-a20d-8c5e-81e8ead5b4dc@linux.alibaba.com>
 <YT8m2B6D2yWc5Umq@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YT8m2B6D2yWc5Umq@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 12:24:24PM +0200, Peter Zijlstra wrote:

FWIW:

> I'm confused tho; where does the #DF come from? Because taking a #PF
> from NMI should be perfectly fine.
> 
> AFAICT that callchain is something like:
> 
> 	NMI
> 	  perf_event_nmi_handler()
> 	    (part of the chain is missing here)
> 	      perf_log_throttle()
> 	        perf_output_begin() /* events/ring_buffer.c */
> 		  rcu_read_lock()
> 		    rcu_lock_acquire()
> 		      lock_acquire()
> 		        trace_lock_acquire() --> perf_trace_foo

This function also calls perf_trace_buf_alloc(), and will have
incremented the recursion count, such that:

> 
> 			  ...
> 			    perf_callchain()
> 			      perf_callchain_user()
> 			        #PF (fully expected during a userspace callchain)
> 				  (some stuff, until the first __fentry)
> 				    perf_trace_function_call
> 				      perf_trace_buf_alloc()
> 				        perf_swevent_get_recursion_context()
> 					  *BOOM*

this one, if it wouldn't mysteriously explode, would find recursion and
terminate, except that seems to be going side-ways.

> Now, supposedly we then take another #PF from get_recursion_context() or
> something, but that doesn't make sense. That should just work...
> 
> Can you figure out what's going wrong there? going with the RIP, this
> almost looks like 'swhash->recursion' goes splat, but again that makes
> no sense, that's a per-cpu variable.
> 
> 
