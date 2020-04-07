Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0DD91A16C3
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 22:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgDGUZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 16:25:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59364 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726494AbgDGUZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 16:25:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586291135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=scImo7fc2VVLGYYgXmQngzwdo//+qw89Krq5Bdm1HOo=;
        b=h54mPhHSntiTbPy9MXyUYNUrOAnL1jqpcCdfhPamULOl/X5aSgnvCpxmjJrGi4twNvOTPC
        fObfY+dhdk+guDM/hCymcoWTUS8g0cT9spTXGlODpFmBDmumMGU0Tp5m6h1kgZ8zNntiex
        rJNzHrOawbox0MfDEjFNzZmvUOk5SgQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-aijyxqmrMsqH75FaYxNYjQ-1; Tue, 07 Apr 2020 16:25:29 -0400
X-MC-Unique: aijyxqmrMsqH75FaYxNYjQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A25998017CE;
        Tue,  7 Apr 2020 20:25:25 +0000 (UTC)
Received: from krava (unknown [10.40.192.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A305A1001B3F;
        Tue,  7 Apr 2020 20:25:13 +0000 (UTC)
Date:   Tue, 7 Apr 2020 22:25:08 +0200
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
Subject: Re: [PATCH v7] perf tools: add support for libpfm4
Message-ID: <20200407202508.GA3210726@krava>
References: <20200407064018.158555-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407064018.158555-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 06, 2020 at 11:40:18PM -0700, Ian Rogers wrote:
> From: Stephane Eranian <eranian@google.com>
> 
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
> v7 rebases and adds fallback code for libpfm4 events.
>    The fallback code is to force user only priv level in case the
>    perf_event_open() syscall failed for permissions reason.
>    the fallback forces a user privilege level restriction on the event string,
>    so depending on the syntax either u or :u is needed.
> 
>    But libpfm4 can use a : or . as the separator, so simply searching
>    for ':' vs. '/' is not good enough to determine the syntax needed.
>    Therefore, this patch introduces a new evsel boolean field to mark events
>    coming from  libpfm4. The field is then used to adjust the fallback string.

heya,
I made bunch of comments for v5, not sure you saw them:
  https://lore.kernel.org/lkml/20200323235846.104937-1-irogers@google.com/

jirka

> v6 is a rebase.
> v5 is a rebase.
> v4 is a rebase on git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
>    branch perf/core and re-adds the tools/build/feature/test-libpfm4.c
>    missed in v3.
> v3 is against acme/perf/core and removes a diagnostic warning.
> v2 of this patch makes the --pfm-events man page documentation
> conditional on libpfm4 behing configured. It tidies some of the
> documentation and adds the feature test missed in the v1 patch.
> 

SNIP

