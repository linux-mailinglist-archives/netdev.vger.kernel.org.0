Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D70E718F339
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 11:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgCWK5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 06:57:15 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:57971 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728043AbgCWK5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 06:57:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584961033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mUgQdjJOCe8LYPuhSHRKvdBK4TOX26jZ2J8UF+h308I=;
        b=EttZ1BPvE1FxssBQ7By0XiCRVqKpMNCu6RqCeNRiz6UT60GczrCWfNKVmx7+jPpVlx7wF0
        U7zYNvlhNKUyPROvmmhEnUUYVcIOyXTJPSyyA+Vz0yC9tE6PYjmd06ZqfIRLtlE1p1yhvT
        ETlkc5tPd+DMHsbXIlC5ABcP6vxvmOA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-_nXr-6aPOH62YfVebRTr5w-1; Mon, 23 Mar 2020 06:57:10 -0400
X-MC-Unique: _nXr-6aPOH62YfVebRTr5w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB3AD8017CE;
        Mon, 23 Mar 2020 10:57:05 +0000 (UTC)
Received: from krava (unknown [10.40.192.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CF3D66EF93;
        Mon, 23 Mar 2020 10:56:58 +0000 (UTC)
Date:   Mon, 23 Mar 2020 11:56:56 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v4] perf tools: add support for libpfm4
Message-ID: <20200323105656.GC1534489@krava>
References: <20200319041134.116241-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319041134.116241-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 09:11:34PM -0700, Ian Rogers wrote:
> This patch links perf with the libpfm4 library if it is available and
> NO_LIBPFM4 isn't passed to the build. The libpfm4 library contains hardware
> event tables for all processors supported by perf_events. It is a helper
> library that helps convert from a symbolic event name to the event
> encoding required by the underlying kernel interface. This
> library is open-source and available from: http://perfmon2.sf.net.
> 
> With this patch, it is possible to specify full hardware events
> by name. Hardware filters are also supported. Events must be
> specified via the --pfm-events and not -e option. Both options
> are active at the same time and it is possible to mix and match:
> 
> $ perf stat --pfm-events inst_retired:any_p:c=1:i -e cycles ....
> 
> v4 is a rebase on git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
>    branch perf/core and re-adds the tools/build/feature/test-libpfm4.c
>    missed in v3.

ugh.. I might have waited too long, but I can't apply it
anymore on Arnaldo's perf/core, sorry

jirka

