Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38148695DB9
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 09:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbjBNI5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 03:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjBNI5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 03:57:45 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB2E026A0;
        Tue, 14 Feb 2023 00:57:42 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0604A1042;
        Tue, 14 Feb 2023 00:58:25 -0800 (PST)
Received: from [10.57.15.75] (unknown [10.57.15.75])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 959BC3F703;
        Tue, 14 Feb 2023 00:57:39 -0800 (PST)
Message-ID: <88a5c080-b5fc-f78a-af9e-eb8af66149ec@arm.com>
Date:   Tue, 14 Feb 2023 08:57:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Zachary Leaf <zachary.leaf@arm.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Cross-compile bpftool
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        linux-morello@op-lists.linaro.org,
        Quentin Monnet <quentin@isovalent.com>
References: <20230210084326.1802597-1-bjorn@kernel.org>
Content-Language: en-US
In-Reply-To: <20230210084326.1802597-1-bjorn@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn,

Thanks for the patch, I've tested it and it works for me.

I have a minor suggestion but otherwise happy to see this getting fixed.

On 10/02/2023 08:43, Björn Töpel wrote:
> From: Björn Töpel <bjorn@rivosinc.com>
> 
> When the BPF selftests are cross-compiled, only the a host version of
> bpftool is built. This version of bpftool is used to generate various
> intermediates, e.g., skeletons.
> 
> The test runners are also using bpftool. The Makefile will symlink
> bpftool from the selftest/bpf root, where the test runners will look
> for the tool:
> 
>   | ...
>   | $(Q)ln -sf $(if $2,..,.)/tools/build/bpftool/bootstrap/bpftool \
>   |    $(OUTPUT)/$(if $2,$2/)bpftool
> 
> There are two issues for cross-compilation builds:
> 
>  1. There is no native (cross-compilation target) build of bpftool
>  2. The bootstrap variant of bpftool is never cross-compiled (by
>     design)
> 
> Make sure that a native/cross-compiled version of bpftool is built,
> and if CROSS_COMPILE is set, symlink to the native/non-bootstrap
> version.
> 
> Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
> ---
>  tools/testing/selftests/bpf/Makefile | 28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index b2eb3201b85a..b706750f71e2 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -157,8 +157,9 @@ $(notdir $(TEST_GEN_PROGS)						\
>  	 $(TEST_CUSTOM_PROGS)): %: $(OUTPUT)/% ;
>  
>  # sort removes libbpf duplicates when not cross-building
> -MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf	       \
> -	       $(HOST_BUILD_DIR)/bpftool $(HOST_BUILD_DIR)/resolve_btfids      \
> +MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf	\
> +	       $(BUILD_DIR)/bpftool $(HOST_BUILD_DIR)/bpftool		\
> +	       $(HOST_BUILD_DIR)/resolve_btfids				\
>  	       $(RUNQSLOWER_OUTPUT) $(INCLUDE_DIR))
>  $(MAKE_DIRS):
>  	$(call msg,MKDIR,,$@)
> @@ -208,6 +209,14 @@ $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_tes
>  	$(Q)cp bpf_testmod/bpf_testmod.ko $@
>  
>  DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool
> +ifneq ($(CROSS_COMPILE),)
> +CROSS_BPFTOOL := $(SCRATCH_DIR)/sbin/bpftool
> +TRUNNER_BPFTOOL := $(CROSS_BPFTOOL)
> +USE_BOOTSTRAP := ""
> +else
> +TRUNNER_BPFTOOL := $(DEFAULT_BPFTOOL)
> +USE_BOOTSTRAP := "bootstrap"
> +endif
>  
>  $(OUTPUT)/runqslower: $(BPFOBJ) | $(DEFAULT_BPFTOOL) $(RUNQSLOWER_OUTPUT)
>  	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	       \

...


-TEST_GEN_PROGS_EXTENDED += $(DEFAULT_BPFTOOL)
+TEST_GEN_PROGS_EXTENDED += $(TRUNNER_BPFTOOL)

Ensure the target arch bpftool is copied into the kselftest_bpf_install
dir by selftests/lib.mk instead of always the default/host version.

Thanks,
Zach

> @@ -255,6 +264,18 @@ $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
>  		    LIBBPF_DESTDIR=$(HOST_SCRATCH_DIR)/			       \
>  		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install-bin
>  
> +ifneq ($(CROSS_COMPILE),)
> +$(CROSS_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)	\
> +		    $(BPFOBJ) | $(BUILD_DIR)/bpftool
> +	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)				\
> +		    ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)			\
> +		    EXTRA_CFLAGS='-g -O0'					\
> +		    OUTPUT=$(BUILD_DIR)/bpftool/				\
> +		    LIBBPF_OUTPUT=$(BUILD_DIR)/libbpf/				\
> +		    LIBBPF_DESTDIR=$(SCRATCH_DIR)/				\
> +		    prefix= DESTDIR=$(SCRATCH_DIR)/ install-bin
> +endif
> +
>  all: docs
>  
>  docs:
> @@ -518,11 +539,12 @@ endif
>  $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TESAT_OBJS)			\
>  			     $(TRUNNER_EXTRA_OBJS) $$(BPFOBJ)		\
>  			     $(RESOLVE_BTFIDS)		related to		\
> +			     $(TRUNNER_BPFTOOL)				\
>  			     | $(TRUNNER_BINARY)-extras
>  	$$(call msg,BINARY,,$$@)
>  	$(Q)$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
>  	$(Q)$(RESOLVE_BTFIDS) --btf $(TRUNNER_OUTPUT)/btf_data.bpf.o $$@
> -	$(Q)ln -sf $(if $2,..,.)/tools/build/bpftool/bootstrap/bpftool \
> +	$(Q)ln -sf $(if $2,..,.)/tools/build/bpftool/$(USE_BOOTSTRAP)/bpftool \>  		   $(OUTPUT)/$(if $2,$2/)bpftool
>  
>  endef
> 
> base-commit: 06744f24696e1e7598412c3df61a538b57ebec22
