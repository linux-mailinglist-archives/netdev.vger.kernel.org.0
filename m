Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CA21D4942
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 11:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgEOJR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 05:17:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27949 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727785AbgEOJRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 05:17:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589534244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mnRre2Cx4ihUmsSYvpskeloE4Blh3L+V4XuwzK66mi0=;
        b=P4Iii1atA6lNryeNNVXerKJ9TF0kR6JPrrspqdkCO34DsixQTq7XZupi7qCG7b5NnGIRF/
        n4k4d1R+KCo9t3ys9jxxbH7eFEv2rc12Ob9nLHCCgQOriwIMkDRnHTMH9SFRedVnOM+mzj
        hrkBBbX7hJccOCKObugHMRJCOdKcqoQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-e0TBRx52PWahR22LB9MItA-1; Fri, 15 May 2020 05:17:20 -0400
X-MC-Unique: e0TBRx52PWahR22LB9MItA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69715835BA8;
        Fri, 15 May 2020 09:17:17 +0000 (UTC)
Received: from krava (unknown [10.40.194.127])
        by smtp.corp.redhat.com (Postfix) with SMTP id 7835478B23;
        Fri, 15 May 2020 09:17:10 +0000 (UTC)
Date:   Fri, 15 May 2020 11:17:07 +0200
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
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/8] libbpf hashmap: Localize static hashmap__* symbols
Message-ID: <20200515091707.GC3511648@krava>
References: <20200515065624.21658-1-irogers@google.com>
 <20200515065624.21658-5-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515065624.21658-5-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 11:56:20PM -0700, Ian Rogers wrote:
> Localize the hashmap__* symbols in libbpf.a. To allow for a version in
> libapi.
> 
> Before:
> $ nm libbpf.a
> ...
> 000000000002088a t hashmap_add_entry
> 000000000001712a t hashmap__append
> 0000000000020aa3 T hashmap__capacity
> 000000000002099c T hashmap__clear
> 00000000000208b3 t hashmap_del_entry
> 0000000000020fc1 T hashmap__delete
> 0000000000020f29 T hashmap__find
> 0000000000020c6c t hashmap_find_entry
> 0000000000020a61 T hashmap__free
> 0000000000020b08 t hashmap_grow
> 00000000000208dd T hashmap__init
> 0000000000020d35 T hashmap__insert
> 0000000000020ab5 t hashmap_needs_to_grow
> 0000000000020947 T hashmap__new
> 0000000000000775 t hashmap__set
> 00000000000212f8 t hashmap__set
> 0000000000020a91 T hashmap__size
> ...
> 
> After:
> $ nm libbpf.a
> ...
> 000000000002088a t hashmap_add_entry
> 000000000001712a t hashmap__append
> 0000000000020aa3 t hashmap__capacity
> 000000000002099c t hashmap__clear
> 00000000000208b3 t hashmap_del_entry
> 0000000000020fc1 t hashmap__delete
> 0000000000020f29 t hashmap__find
> 0000000000020c6c t hashmap_find_entry
> 0000000000020a61 t hashmap__free
> 0000000000020b08 t hashmap_grow
> 00000000000208dd t hashmap__init
> 0000000000020d35 t hashmap__insert
> 0000000000020ab5 t hashmap_needs_to_grow
> 0000000000020947 t hashmap__new
> 0000000000000775 t hashmap__set
> 00000000000212f8 t hashmap__set
> 0000000000020a91 t hashmap__size
> ...

I think this will break bpf selftests which use hashmap,
we need to find some other way to include this

either to use it from libbpf directly, or use the api version
only if the libbpf is not compiled in perf, we could use
following to detect that:

      CFLAGS += -DHAVE_LIBBPF_SUPPORT
      $(call detected,CONFIG_LIBBPF)

jirka

