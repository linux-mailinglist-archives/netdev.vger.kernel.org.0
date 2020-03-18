Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0FC189935
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 11:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgCRKXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 06:23:20 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:26304 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727566AbgCRKXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 06:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584526996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eQbwZedV0nkhvYUGX8gyCaRA65cSElbfrTc3COHZe40=;
        b=NssB5stoXkLQkgz2JhASD4iASesdHOYCptlWu6GZM4mbf4uH+c4LfOKGNrdLwkIkebXcBl
        6z1XPsNYGVdNyvSd4nmURU+hHZxovg2v0dFXqo5eCZq4r0GN4GmRcoaNDZ7DJgxBvcnsEm
        BVLy5i3ZxKoSs6NU3jwr2OYmPFN8I9M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-GKAGB1blMR6bANhmUOdkxw-1; Wed, 18 Mar 2020 06:23:12 -0400
X-MC-Unique: GKAGB1blMR6bANhmUOdkxw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CBAF800D54;
        Wed, 18 Mar 2020 10:23:09 +0000 (UTC)
Received: from krava (unknown [10.40.195.82])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AD4A25C1BB;
        Wed, 18 Mar 2020 10:22:58 +0000 (UTC)
Date:   Wed, 18 Mar 2020 11:22:54 +0100
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
Subject: Re: [PATCH v3] perf tools: add support for libpfm4
Message-ID: <20200318102254.GC821557@krava>
References: <20200311213613.210749-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311213613.210749-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 02:36:13PM -0700, Ian Rogers wrote:
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
> v3 is against acme/perf/core removes a diagnostic warning
> v2 of this patch makes the --pfm-events man page documentation
> conditional on libpfm4 behing configured. It tidies some of the
> documentation and adds the feature test missed in the v1 patch.
> 
> Author: Stephane Eranian <eranian@google.com>
> Signed-off-by: Ian Rogers <irogers@google.com>

hi,
is this the latest version? I can't apply it on Arnaldo's perf/core

jirka

