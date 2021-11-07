Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3514447386
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 16:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbhKGPcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 10:32:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234272AbhKGPcy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Nov 2021 10:32:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D96C60FD7;
        Sun,  7 Nov 2021 15:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636299011;
        bh=i39reOvzohDnkfOFLebPqsEvmo91vFwHujAGFaThnho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pHn4RomukhhrdD2sAsgXXyrjyHkqWDcnRo1iivQnEPM1V4fuvSqWbWuIhQw1CFjQe
         RMJAaf2kIH1c72DoOHJ+l4kZFyKqgk8AcQ7plJR1mL3yuEeQ+Y1boIs6m5x9pn6CKA
         76oa9qawFKaf+ABUSTXlVdGeL9ySKafHcn0QwvicWQe0ApP68lkXPHH5wSXH9CGNvQ
         CGZwhMOTub8g7tXQfiOBmiUbt5uPQ9rbyGMiJPrXwW8P3R782EJJaDy2MhUFMQL7hr
         gPbjIN7/tSo7tpjD4o2pZfsZSW37ZeSbc6CuRVXwNBTfX9f1J8h5JA+TYwNafyHFpi
         eGn+psO1FeBbw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id E2F04410A1; Sun,  7 Nov 2021 12:30:07 -0300 (-03)
Date:   Sun, 7 Nov 2021 12:30:07 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] perf build: Install libbpf headers locally when
 building
Message-ID: <YYfw/y2KmjvjOax2@kernel.org>
References: <813cc0db-51d0-65b3-70f4-f1a823b0d029@isovalent.com>
 <20211107002445.4790-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211107002445.4790-1-quentin@isovalent.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sun, Nov 07, 2021 at 12:24:45AM +0000, Quentin Monnet escreveu:
> API headers from libbpf should not be accessed directly from the
> library's source directory. Instead, they should be exported with "make
> install_headers". Let's adjust perf's Makefile to install those headers
> locally when building libbpf.
> 
> v2:
> - Fix $(LIBBPF_OUTPUT) when $(OUTPUT) is null.
> - Make sure the recipe for $(LIBBPF_OUTPUT) is not under a "ifdef".

Thanks for the prompt reply, now the cases where it was failing are
passing!

Best regards,

- Arnaldo
 
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/perf/Makefile.perf | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index b856afa6eb52..e01ada5c9876 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -241,7 +241,7 @@ else # force_fixdep
>  
>  LIB_DIR         = $(srctree)/tools/lib/api/
>  TRACE_EVENT_DIR = $(srctree)/tools/lib/traceevent/
> -BPF_DIR         = $(srctree)/tools/lib/bpf/
> +LIBBPF_DIR      = $(srctree)/tools/lib/bpf/
>  SUBCMD_DIR      = $(srctree)/tools/lib/subcmd/
>  LIBPERF_DIR     = $(srctree)/tools/lib/perf/
>  DOC_DIR         = $(srctree)/tools/perf/Documentation/
> @@ -293,7 +293,6 @@ strip-libs = $(filter-out -l%,$(1))
>  ifneq ($(OUTPUT),)
>    TE_PATH=$(OUTPUT)
>    PLUGINS_PATH=$(OUTPUT)
> -  BPF_PATH=$(OUTPUT)
>    SUBCMD_PATH=$(OUTPUT)
>    LIBPERF_PATH=$(OUTPUT)
>  ifneq ($(subdir),)
> @@ -305,7 +304,6 @@ else
>    TE_PATH=$(TRACE_EVENT_DIR)
>    PLUGINS_PATH=$(TRACE_EVENT_DIR)plugins/
>    API_PATH=$(LIB_DIR)
> -  BPF_PATH=$(BPF_DIR)
>    SUBCMD_PATH=$(SUBCMD_DIR)
>    LIBPERF_PATH=$(LIBPERF_DIR)
>  endif
> @@ -324,7 +322,14 @@ LIBTRACEEVENT_DYNAMIC_LIST_LDFLAGS = $(if $(findstring -static,$(LDFLAGS)),,$(DY
>  LIBAPI = $(API_PATH)libapi.a
>  export LIBAPI
>  
> -LIBBPF = $(BPF_PATH)libbpf.a
> +ifneq ($(OUTPUT),)
> +  LIBBPF_OUTPUT = $(abspath $(OUTPUT))/libbpf
> +else
> +  LIBBPF_OUTPUT = $(CURDIR)/libbpf
> +endif
> +LIBBPF_DESTDIR = $(LIBBPF_OUTPUT)
> +LIBBPF_INCLUDE = $(LIBBPF_DESTDIR)/include
> +LIBBPF = $(LIBBPF_OUTPUT)/libbpf.a
>  
>  LIBSUBCMD = $(SUBCMD_PATH)libsubcmd.a
>  
> @@ -829,12 +834,14 @@ $(LIBAPI)-clean:
>  	$(call QUIET_CLEAN, libapi)
>  	$(Q)$(MAKE) -C $(LIB_DIR) O=$(OUTPUT) clean >/dev/null
>  
> -$(LIBBPF): FORCE
> -	$(Q)$(MAKE) -C $(BPF_DIR) O=$(OUTPUT) $(OUTPUT)libbpf.a FEATURES_DUMP=$(FEATURE_DUMP_EXPORT)
> +$(LIBBPF): FORCE | $(LIBBPF_OUTPUT)
> +	$(Q)$(MAKE) -C $(LIBBPF_DIR) FEATURES_DUMP=$(FEATURE_DUMP_EXPORT) \
> +		O= OUTPUT=$(LIBBPF_OUTPUT)/ DESTDIR=$(LIBBPF_DESTDIR) prefix= \
> +		$@ install_headers
>  
>  $(LIBBPF)-clean:
>  	$(call QUIET_CLEAN, libbpf)
> -	$(Q)$(MAKE) -C $(BPF_DIR) O=$(OUTPUT) clean >/dev/null
> +	$(Q)$(RM) -r -- $(LIBBPF_OUTPUT)
>  
>  $(LIBPERF): FORCE
>  	$(Q)$(MAKE) -C $(LIBPERF_DIR) EXTRA_CFLAGS="$(LIBPERF_CFLAGS)" O=$(OUTPUT) $(OUTPUT)libperf.a
> @@ -1034,16 +1041,15 @@ SKELETONS := $(SKEL_OUT)/bpf_prog_profiler.skel.h
>  SKELETONS += $(SKEL_OUT)/bperf_leader.skel.h $(SKEL_OUT)/bperf_follower.skel.h
>  SKELETONS += $(SKEL_OUT)/bperf_cgroup.skel.h
>  
> +$(SKEL_TMP_OUT) $(LIBBPF_OUTPUT):
> +	$(Q)$(MKDIR) -p $@
> +
>  ifdef BUILD_BPF_SKEL
>  BPFTOOL := $(SKEL_TMP_OUT)/bootstrap/bpftool
> -LIBBPF_SRC := $(abspath ../lib/bpf)
> -BPF_INCLUDE := -I$(SKEL_TMP_OUT)/.. -I$(BPF_PATH) -I$(LIBBPF_SRC)/..
> -
> -$(SKEL_TMP_OUT):
> -	$(Q)$(MKDIR) -p $@
> +BPF_INCLUDE := -I$(SKEL_TMP_OUT)/.. -I$(LIBBPF_INCLUDE)
>  
>  $(BPFTOOL): | $(SKEL_TMP_OUT)
> -	CFLAGS= $(MAKE) -C ../bpf/bpftool \
> +	$(Q)CFLAGS= $(MAKE) -C ../bpf/bpftool \
>  		OUTPUT=$(SKEL_TMP_OUT)/ bootstrap
>  
>  VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
> -- 
> 2.32.0

-- 

- Arnaldo
