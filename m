Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7E9330FBB
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 14:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhCHNmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 08:42:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhCHNlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 08:41:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 298E065100;
        Mon,  8 Mar 2021 13:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615210897;
        bh=VJUKujo7WxafrOc8jPvmlgV1PGGLFcyoKaimjk+JkbI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qafNv49/9sAq64knyWCJuaryRmCy9UedUNxRal+C/ORVyFogRcMJRyGS6b0VLyt5S
         l01/0XZfBjpNbq6jHvpykfvYPVkFMd2qZtjtzWGQc1lg5CQDexK2mxUs3JLP+LwAqB
         k7D2CL5uLJNWGspYwGDTN/TSDBsHjNsPx2LhCLPQnhqxr7a3gsbDmBMojuGXfNHS4J
         QWap0loHYZ5ZP3a3U1BDc9FLL/VfmXHiPJmzpXK5oDjw0OZEJTypjQXbxQe9iTpNOS
         M4yN+b7zxO4CMywHcI79NyziACG2PlZMToQcyCg25B8mA7wQKvvsYPc6vSIUPvPept
         Qx8dDNfmVnsMQ==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 1234940647; Mon,  8 Mar 2021 10:41:34 -0300 (-03)
Date:   Mon, 8 Mar 2021 10:41:34 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tiezhu Yang <yangtiezhu@loongson.cn>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] tools include: Add __sum16 and __wsum definitions.
Message-ID: <YEYpjqar4SW08CTK@kernel.org>
References: <20210307223024.4081067-1-irogers@google.com>
 <4aa2a66d-b8e4-adfe-8b61-615d98012a65@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4aa2a66d-b8e4-adfe-8b61-615d98012a65@iogearbox.net>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Mar 08, 2021 at 02:37:32PM +0100, Daniel Borkmann escreveu:
> On 3/7/21 11:30 PM, Ian Rogers wrote:
> > This adds definitions available in the uapi version.
> > 
> > Explanation:
> > In the kernel include of types.h the uapi version is included.
> > In tools the uapi/linux/types.h and linux/types.h are distinct.
> > For BPF programs a definition of __wsum is needed by the generated
> > bpf_helpers.h. The definition comes either from a generated vmlinux.h or
> > from <linux/types.h> that may be transitively included from bpf.h. The
> > perf build prefers linux/types.h over uapi/linux/types.h for
> > <linux/types.h>*. To allow tools/perf/util/bpf_skel/bpf_prog_profiler.bpf.c
> > to compile with the same include path used for perf then these
> > definitions are necessary.
> > 
> > There is likely a wider conversation about exactly how types.h should be
> > specified and the include order used by the perf build - it is somewhat
> > confusing that tools/include/uapi/linux/bpf.h is using the non-uapi
> > types.h.
> > 
> > *see tools/perf/Makefile.config:
> > ...
> > INC_FLAGS += -I$(srctree)/tools/include/
> > INC_FLAGS += -I$(srctree)/tools/arch/$(SRCARCH)/include/uapi
> > INC_FLAGS += -I$(srctree)/tools/include/uapi
> > ...
> > The include directories are scanned from left-to-right:
> > https://gcc.gnu.org/onlinedocs/gcc/Directory-Options.html
> > As tools/include/linux/types.h appears before
> > tools/include/uapi/linux/types.h then I say it is preferred.
> > 
> > Signed-off-by: Ian Rogers <irogers@google.com>
> 
> Given more related to perf build infra, I presume Arnaldo would pick
> this one up?

I'll process it.

- Arnaldo
