Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186B51ABD63
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504354AbgDPJzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:55:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60158 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2504126AbgDPJzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 05:55:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587030918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uzkUV3nQdx/hoYoZQDt470t93oI86X5pG7zK+r/DONM=;
        b=ZNck3riqJ74S2YXFcz6g2MRgHiXBoLAChjgWzNxV1ryUutUxHmACkIeMQHOI2uRA5E07Bz
        5md455D1e6+/Vy1ojlHROIuUqqJvrfqMA47ELsyiSWtK1IfffptG4zAgmapKH8lo7ZH7zL
        QyO51XTwTItHaO70QHehAZdPBUSgP44=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-zDLWURH8Neyn4RNTbgME8g-1; Thu, 16 Apr 2020 05:55:14 -0400
X-MC-Unique: zDLWURH8Neyn4RNTbgME8g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09C6013FE;
        Thu, 16 Apr 2020 09:55:11 +0000 (UTC)
Received: from krava (unknown [10.40.195.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B4FC9118DF1;
        Thu, 16 Apr 2020 09:55:04 +0000 (UTC)
Date:   Thu, 16 Apr 2020 11:55:01 +0200
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
Subject: Re: [PATCH v9 4/4] perf tools: add support for libpfm4
Message-ID: <20200416095501.GC369437@krava>
References: <20200416063551.47637-1-irogers@google.com>
 <20200416063551.47637-5-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416063551.47637-5-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 11:35:51PM -0700, Ian Rogers wrote:
> From: Stephane Eranian <eranian@google.com>
> 
> This patch links perf with the libpfm4 library if it is available
> and NO_LIBPFM4 isn't passed to the build. The libpfm4 library
> contains hardware event tables for all processors supported by
> perf_events. It is a helper library that helps convert from a
> symbolic event name to the event encoding required by the
> underlying kernel interface. This library is open-source and
> available from: http://perfmon2.sf.net.
> 
> With this patch, it is possible to specify full hardware events
> by name. Hardware filters are also supported. Events must be
> specified via the --pfm-events and not -e option. Both options
> are active at the same time and it is possible to mix and match:
> 
> $ perf stat --pfm-events inst_retired:any_p:c=1:i -e cycles ....
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> Reviewed-by: Ian Rogers <irogers@google.com>

	# perf list
	...
	perf_raw pfm-events
	  r0000
	    [perf_events raw event syntax: r[0-9a-fA-F]+]

	skl pfm-events
	  UNHALTED_CORE_CYCLES
	    [Count core clock cycles whenever the clock signal on the specific core is running (not halted)]
	  UNHALTED_REFERENCE_CYCLES

please add ':' behind the '* pfm-events' label

jirka

