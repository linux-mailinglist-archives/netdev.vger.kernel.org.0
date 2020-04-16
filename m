Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2681ABD4B
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504099AbgDPJvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:51:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37602 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2504197AbgDPJvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 05:51:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587030669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qJZaml1bqYlNYy3uVGFrdxuVDCwUh58QATaaa/ks2z4=;
        b=De4+WC6nsaiTe9dkqWo2HlHeMMFWBNut6LidGolEvli9cR/EL9PNJOirj/xu+UKDjEkPIw
        XNUE2Rteji0vFyDtBPRBgfQAaE96QdDf1Z/6DEEnk/iG49gjFRAYhuor5tia01vSNZXu+7
        FcKg58ZzPdF1cY0vs2Lx6Wghd1mT+pk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-gRKUCZnoOIOKd_NVLHZeQw-1; Thu, 16 Apr 2020 05:51:04 -0400
X-MC-Unique: gRKUCZnoOIOKd_NVLHZeQw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1758DB60;
        Thu, 16 Apr 2020 09:51:00 +0000 (UTC)
Received: from krava (unknown [10.40.195.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B91946EF91;
        Thu, 16 Apr 2020 09:50:53 +0000 (UTC)
Date:   Thu, 16 Apr 2020 11:50:50 +0200
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
Message-ID: <20200416095050.GB369437@krava>
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

SNIP

> diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
> index 12a8204d63c6..26167ad38a47 100644
> --- a/tools/perf/Makefile.config
> +++ b/tools/perf/Makefile.config
> @@ -1012,6 +1012,18 @@ ifdef LIBCLANGLLVM
>    endif
>  endif
>  
> +ifndef NO_LIBPFM4
> +  ifeq ($(feature-libpfm4), 1)
> +    CFLAGS += -DHAVE_LIBPFM
> +    EXTLIBS += -lpfm
> +    ASCIIDOC_EXTRA = -aHAVE_LIBPFM=1
> +    $(call detected,CONFIG_LIBPFM4)
> +  else
> +    msg := $(warning libpfm4 not found, disables libpfm4 support. Please install libpfm4-dev);
> +    NO_LIBPFM4 := 1
> +  endif
> +endif

now when it's in FEATURE_TESTS_EXTRA it will not get detected,
unless you add the change below.. I wonder how come it was
still being detected for you.. might be bug in feature detection
stuff

jirka


---
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 26167ad38a47..b45c5d370b42 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -1013,6 +1013,7 @@ ifdef LIBCLANGLLVM
 endif
 
 ifndef NO_LIBPFM4
+  $(call feature_check,libpfm4)
   ifeq ($(feature-libpfm4), 1)
     CFLAGS += -DHAVE_LIBPFM
     EXTLIBS += -lpfm

