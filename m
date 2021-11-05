Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F4A446268
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 11:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhKEK6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 06:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231818AbhKEK6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 06:58:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 631006112D;
        Fri,  5 Nov 2021 10:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636109723;
        bh=aq1MUVKkLEHWOaFoQZe0Z4p8O2u7B2hr14jr+EYsSXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f0dNXoJm630YIjZ+9SbxrB5wfRtRy8nCdzwALJlTS4PdfrQeU7NSs+AX5n88tUbgW
         spSq2X275b24coeVu2HKeaMpJZLmFDanhKNk/yMt+V8FZxmUqVdNeooHJ8GVnSLLgv
         o/BIrFQvdGyw+Dk/tO/16rZ8xsNvFboNR5N7fMS/X1qxfiQ0EeG3Q+UiTsdK8+SWTe
         IwRvW+B6A+PXaFZfHmxyLb3bNw/2OLIoqXD9a3Br0N02OYEW+ye9kgzBpF8Be/Dd0H
         KkvMfCq4ehKg91ighNyEI8alNKJ6o6jByzIHHIHUj1x0YzSI7dQButeQa7unKVwUfu
         L3L+67p+rl0Wg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id BF384410A1; Fri,  5 Nov 2021 07:55:20 -0300 (-03)
Date:   Fri, 5 Nov 2021 07:55:20 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf] bpftool: Install libbpf headers for the bootstrap
 version, too
Message-ID: <YYUNmAexMZ1RQhWk@kernel.org>
References: <20211105015813.6171-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105015813.6171-1-quentin@isovalent.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Nov 05, 2021 at 01:58:13AM +0000, Quentin Monnet escreveu:
> We recently changed bpftool's Makefile to make it install libbpf's
> headers locally instead of pulling them from the source directory of the
> library. Although bpftool needs two versions of libbpf, a "regular" one
> and a "bootstrap" version, we would only install headers for the regular
> libbpf build. Given that this build always occurs before the bootstrap
> build when building bpftool, this is enough to ensure that the bootstrap
> bpftool will have access to the headers exported through the regular
> libbpf build.
> 
> However, this did not account for the case when we only want the
> bootstrap version of bpftool, through the "bootstrap" target. For
> example, perf needs the bootstrap version only, to generate BPF
> skeletons. In that case, when are the headers installed? For some time,
> the issue has been masked, because we had a step (the installation of
> headers internal to libbpf) which would depend on the regular build of
> libbpf and hence trigger the export of the headers, just for the sake of
> creating a directory. But this changed with commit 8b6c46241c77
> ("bpftool: Remove Makefile dep. on $(LIBBPF) for
> $(LIBBPF_INTERNAL_HDRS)"), where we cleaned up that stage and removed
> the dependency on the regular libbpf build. As a result, when we only
> want the bootstrap bpftool version, the regular libbpf is no longer
> built. The bootstrap libbpf version is built, but headers are not
> exported, and the bootstrap bpftool build fails because of the missing
> headers.
> 
> To fix this, we also install the library headers for the bootstrap
> version of libbpf, to use them for the bootstrap bpftool and for
> generating the skeletons.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Testing now.

- Arnaldo
 
> Fixes: f012ade10b34 ("bpftool: Install libbpf headers instead of including the dir")
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/Makefile | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index c0c30e56988f..7cfba11c3014 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -22,24 +22,29 @@ else
>    _OUTPUT := $(CURDIR)
>  endif
>  BOOTSTRAP_OUTPUT := $(_OUTPUT)/bootstrap/
> +
>  LIBBPF_OUTPUT := $(_OUTPUT)/libbpf/
>  LIBBPF_DESTDIR := $(LIBBPF_OUTPUT)
>  LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)/include
>  LIBBPF_HDRS_DIR := $(LIBBPF_INCLUDE)/bpf
> +LIBBPF := $(LIBBPF_OUTPUT)libbpf.a
>  
> -LIBBPF = $(LIBBPF_OUTPUT)libbpf.a
> -LIBBPF_BOOTSTRAP_OUTPUT = $(BOOTSTRAP_OUTPUT)libbpf/
> -LIBBPF_BOOTSTRAP = $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
> +LIBBPF_BOOTSTRAP_OUTPUT := $(BOOTSTRAP_OUTPUT)libbpf/
> +LIBBPF_BOOTSTRAP_DESTDIR := $(LIBBPF_BOOTSTRAP_OUTPUT)
> +LIBBPF_BOOTSTRAP_INCLUDE := $(LIBBPF_BOOTSTRAP_DESTDIR)/include
> +LIBBPF_BOOTSTRAP_HDRS_DIR := $(LIBBPF_BOOTSTRAP_INCLUDE)/bpf
> +LIBBPF_BOOTSTRAP := $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
>  
>  # We need to copy hashmap.h and nlattr.h which is not otherwise exported by
>  # libbpf, but still required by bpftool.
>  LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nlattr.h)
> +LIBBPF_BOOTSTRAP_INTERNAL_HDRS := $(addprefix $(LIBBPF_BOOTSTRAP_HDRS_DIR)/,hashmap.h)
>  
>  ifeq ($(BPFTOOL_VERSION),)
>  BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
>  endif
>  
> -$(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT) $(LIBBPF_HDRS_DIR):
> +$(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT) $(LIBBPF_HDRS_DIR) $(LIBBPF_BOOTSTRAP_HDRS_DIR):
>  	$(QUIET_MKDIR)mkdir -p $@
>  
>  $(LIBBPF): $(wildcard $(BPF_DIR)/*.[ch] $(BPF_DIR)/Makefile) | $(LIBBPF_OUTPUT)
> @@ -52,7 +57,12 @@ $(LIBBPF_INTERNAL_HDRS): $(LIBBPF_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_HDRS_
>  
>  $(LIBBPF_BOOTSTRAP): $(wildcard $(BPF_DIR)/*.[ch] $(BPF_DIR)/Makefile) | $(LIBBPF_BOOTSTRAP_OUTPUT)
>  	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_BOOTSTRAP_OUTPUT) \
> -		ARCH= CC=$(HOSTCC) LD=$(HOSTLD) $@
> +		DESTDIR=$(LIBBPF_BOOTSTRAP_DESTDIR) prefix= \
> +		ARCH= CC=$(HOSTCC) LD=$(HOSTLD) $@ install_headers
> +
> +$(LIBBPF_BOOTSTRAP_INTERNAL_HDRS): $(LIBBPF_BOOTSTRAP_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_BOOTSTRAP_HDRS_DIR)
> +	$(call QUIET_INSTALL, $@)
> +	$(Q)install -m 644 -t $(LIBBPF_BOOTSTRAP_HDRS_DIR) $<
>  
>  $(LIBBPF)-clean: FORCE | $(LIBBPF_OUTPUT)
>  	$(call QUIET_CLEAN, libbpf)
> @@ -172,11 +182,11 @@ else
>  	$(Q)cp "$(VMLINUX_H)" $@
>  endif
>  
> -$(OUTPUT)%.bpf.o: skeleton/%.bpf.c $(OUTPUT)vmlinux.h $(LIBBPF)
> +$(OUTPUT)%.bpf.o: skeleton/%.bpf.c $(OUTPUT)vmlinux.h $(LIBBPF_BOOTSTRAP)
>  	$(QUIET_CLANG)$(CLANG) \
>  		-I$(if $(OUTPUT),$(OUTPUT),.) \
>  		-I$(srctree)/tools/include/uapi/ \
> -		-I$(LIBBPF_INCLUDE) \
> +		-I$(LIBBPF_BOOTSTRAP_INCLUDE) \
>  		-g -O2 -Wall -target bpf -c $< -o $@ && $(LLVM_STRIP) -g $@
>  
>  $(OUTPUT)%.skel.h: $(OUTPUT)%.bpf.o $(BPFTOOL_BOOTSTRAP)
> @@ -209,8 +219,10 @@ $(BPFTOOL_BOOTSTRAP): $(BOOTSTRAP_OBJS) $(LIBBPF_BOOTSTRAP)
>  $(OUTPUT)bpftool: $(OBJS) $(LIBBPF)
>  	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
>  
> -$(BOOTSTRAP_OUTPUT)%.o: %.c $(LIBBPF_INTERNAL_HDRS) | $(BOOTSTRAP_OUTPUT)
> -	$(QUIET_CC)$(HOSTCC) $(CFLAGS) -c -MMD -o $@ $<
> +$(BOOTSTRAP_OUTPUT)%.o: %.c $(LIBBPF_BOOTSTRAP_INTERNAL_HDRS) | $(BOOTSTRAP_OUTPUT)
> +	$(QUIET_CC)$(HOSTCC) \
> +		$(subst -I$(LIBBPF_INCLUDE),-I$(LIBBPF_BOOTSTRAP_INCLUDE),$(CFLAGS)) \
> +		-c -MMD -o $@ $<
>  
>  $(OUTPUT)%.o: %.c
>  	$(QUIET_CC)$(CC) $(CFLAGS) -c -MMD -o $@ $<
> @@ -257,6 +269,6 @@ doc-uninstall:
>  FORCE:
>  
>  .SECONDARY:
> -.PHONY: all FORCE clean install-bin install uninstall
> +.PHONY: all FORCE bootstrap clean install-bin install uninstall
>  .PHONY: doc doc-clean doc-install doc-uninstall
>  .DEFAULT_GOAL := all
> -- 
> 2.32.0

-- 

- Arnaldo
