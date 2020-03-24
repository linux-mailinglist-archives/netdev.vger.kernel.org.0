Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480BA190AE9
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 11:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgCXK0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 06:26:52 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:26817 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbgCXK0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 06:26:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585045610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sioQHJ/gqYmdZ2quk2XdjeUt1wNNtFtGmhdgWYbayjc=;
        b=RU2Is5NME33z+NqXVJVbwxxISz34jMvG2vfRH9+QrQBUu/L49ACEW755f7uppbfPmbVcKH
        XErfVRJOwHfQARwvUbFPcvZOhyBAH7psxR9QX7l3FYIT806F4ZQ9SwY4yhjfefJUI7Kjer
        nfRTxB6Lbz6Lt7QXoiqTire78dH7v0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-rZ0geVkpMPGbklEvQJuDlA-1; Tue, 24 Mar 2020 06:26:47 -0400
X-MC-Unique: rZ0geVkpMPGbklEvQJuDlA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF63C800D54;
        Tue, 24 Mar 2020 10:26:43 +0000 (UTC)
Received: from krava (unknown [10.40.192.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E0E25A0A60;
        Tue, 24 Mar 2020 10:26:24 +0000 (UTC)
Date:   Tue, 24 Mar 2020 11:26:20 +0100
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
Subject: Re: [PATCH v5] perf tools: add support for libpfm4
Message-ID: <20200324102620.GO1534489@krava>
References: <20200323235846.104937-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323235846.104937-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 04:58:46PM -0700, Ian Rogers wrote:

SNIP

>  INTERACTIVE PROMPTING KEYS
>  --------------------------
> diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
> index 80e55e796be9..571aa6b1af40 100644
> --- a/tools/perf/Makefile.config
> +++ b/tools/perf/Makefile.config
> @@ -999,6 +999,18 @@ ifdef LIBCLANGLLVM
>    endif
>  endif
>  
> +ifndef NO_LIBPFM4
> +  ifeq ($(feature-libpfm4), 1)
> +    CFLAGS += -DHAVE_LIBPFM
> +    EXTLIBS += -lpfm
> +    ASCIIDOC_EXTRA = -aHAVE_LIBPFM=1
> +    $(call detected,CONFIG_LIBPFM4)

you don't use CONFIG_LIBPFM4

but I was wondering if we should put it all in separate
object like util/pfm.c to get rid of some of those ifdefs

jirka

