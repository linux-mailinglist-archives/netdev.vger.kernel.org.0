Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E674FBC426
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 10:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439012AbfIXIdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 04:33:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390364AbfIXIdr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 04:33:47 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0C7C0307D91F;
        Tue, 24 Sep 2019 08:33:47 +0000 (UTC)
Received: from krava (unknown [10.43.17.52])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5F2F960BFB;
        Tue, 24 Sep 2019 08:33:43 +0000 (UTC)
Date:   Tue, 24 Sep 2019 10:33:42 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org, ast@fb.com, alexander.shishkin@linux.intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/5] perf/core: Add PERF_FORMAT_LOST read_format
Message-ID: <20190924083342.GA21640@krava>
References: <20190917133056.5545-1-dxu@dxuuu.xyz>
 <20190917133056.5545-2-dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917133056.5545-2-dxu@dxuuu.xyz>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 24 Sep 2019 08:33:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 06:30:52AM -0700, Daniel Xu wrote:

SNIP

> +	PERF_FORMAT_MAX = 1U << 5,		/* non-ABI */
>  };
>  
>  #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 0463c1151bae..ee08d3ed6299 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -1715,6 +1715,9 @@ static void __perf_event_read_size(struct perf_event *event, int nr_siblings)
>  	if (event->attr.read_format & PERF_FORMAT_ID)
>  		entry += sizeof(u64);
>  
> +	if (event->attr.read_format & PERF_FORMAT_LOST)
> +		entry += sizeof(u64);
> +
>  	if (event->attr.read_format & PERF_FORMAT_GROUP) {
>  		nr += nr_siblings;
>  		size += sizeof(u64);
> @@ -4734,6 +4737,24 @@ u64 perf_event_read_value(struct perf_event *event, u64 *enabled, u64 *running)
>  }
>  EXPORT_SYMBOL_GPL(perf_event_read_value);
>  
> +static struct pmu perf_kprobe;
> +static u64 perf_event_lost(struct perf_event *event)
> +{
> +	struct ring_buffer *rb;
> +	u64 lost = 0;
> +
> +	rcu_read_lock();
> +	rb = rcu_dereference(event->rb);
> +	if (likely(!!rb))
> +		lost += local_read(&rb->lost);
> +	rcu_read_unlock();
> +
> +	if (event->attr.type == perf_kprobe.type)
> +		lost += perf_kprobe_missed(event);

not sure what was the peterz's suggestion, but here you are mixing
ring buffer's lost count with kprobes missed count, seems wrong

maybe we could add PERF_FORMAT_KPROBE_MISSED

jirka
