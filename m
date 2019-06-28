Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4909359F19
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 17:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfF1PoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 11:44:07 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:33727 "EHLO
        asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfF1PoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 11:44:03 -0400
Received: from ravnborg.org (unknown [158.248.194.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk3.altibox.net (Postfix) with ESMTPS id 97FC720022;
        Fri, 28 Jun 2019 17:43:52 +0200 (CEST)
Date:   Fri, 28 Jun 2019 17:43:49 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     linux-kbuild@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Michal Marek <michal.lkml@markovi.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Palmer Dabbelt <palmer@sifive.com>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH v3 1/4] kbuild: compile-test UAPI headers to ensure they
 are self-contained
Message-ID: <20190628154349.GA12826@ravnborg.org>
References: <20190627163903.28398-1-yamada.masahiro@socionext.com>
 <20190627163903.28398-2-yamada.masahiro@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627163903.28398-2-yamada.masahiro@socionext.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=dqr19Wo4 c=1 sm=1 tr=0
        a=UWs3HLbX/2nnQ3s7vZ42gw==:117 a=UWs3HLbX/2nnQ3s7vZ42gw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=7gkXJVJtAAAA:8
        a=VwQbUJbxAAAA:8 a=c-n4J4-pAAAA:8 a=Z0GOsA-a0XePTZBfY68A:9
        a=EPyczOORS10Pyz25:21 a=NOQbmmdwHI87PwOY:21 a=CjuIK1q_8ugA:10
        a=fqMFh-b0cAUA:10 a=E9Po1WZjFZOl8hwRPBS3:22 a=AjGcO6oz07-iQ99wixmX:22
        a=L0NDqeB7ZLmQzAogN4cw:22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Masahiro.

On Fri, Jun 28, 2019 at 01:38:59AM +0900, Masahiro Yamada wrote:
> Multiple people have suggested compile-testing UAPI headers to ensure
> they can be really included from user-space. "make headers_check" is
> obviously not enough to catch bugs, and we often leak references to
> kernel-space definition to user-space.
> 
> Use the new header-test-y syntax to implement it. Please note exported
> headers are compile-tested with a completely different set of compiler
> flags. The header search path is set to $(objtree)/usr/include since
> exported headers should not include unexported ones.

This patchset introduce a new set of tests for uapi headers.
Can we somehow consolidate so we have only one way to verify the uapi
headers?
It can be confusing for users that they see errors from testing the
uapi headers during normal build and a new class or error if they
run a "make headers_check" sometimes later.

This can be a next step to consolidate this.
With the suggestions below considered you can add my:
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>

> 
> We use -std=gnu89 for the kernel space since the kernel code highly
> depends on GNU extensions. On the other hand, UAPI headers should be
> written in more standardized C, so they are compiled with -std=c90.
> This will emit errors if C++ style comments, the keyword 'inline', etc.
> are used. Please use C style comments (/* ... */), '__inline__', etc.
> in UAPI headers.
> 
> There is additional compiler requirement to enable this test because
> many of UAPI headers include <stdlib.h>, <sys/ioctl.h>, <sys/time.h>,
> etc. directly or indirectly. You cannot use kernel.org pre-built
> toolchains [1] since they lack <stdlib.h>.
> 
> I added scripts/cc-system-headers.sh to check the system header
> availability, which CONFIG_UAPI_HEADER_TEST depends on.
> 
> For now, a lot of headers need to be excluded because they cannot
> be compiled standalone, but this is a good start point.
> 
> [1] https://mirrors.edge.kernel.org/pub/tools/crosstool/index.html
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
> 
> Changes in v3: None
> Changes in v2:
>  - Add CONFIG_CPU_{BIG,LITTLE}_ENDIAN guard to avoid build error
>  - Use 'header-test-' instead of 'no-header-test'
>  - Avoid weird 'find' warning when cleaning
> 
>  Makefile                     |   2 +-
>  init/Kconfig                 |  11 +++
>  scripts/cc-system-headers.sh |   8 +++
>  usr/.gitignore               |   1 -
>  usr/Makefile                 |   2 +
>  usr/include/.gitignore       |   3 +
>  usr/include/Makefile         | 134 +++++++++++++++++++++++++++++++++++
>  7 files changed, 159 insertions(+), 2 deletions(-)
>  create mode 100755 scripts/cc-system-headers.sh
>  create mode 100644 usr/include/.gitignore
>  create mode 100644 usr/include/Makefile
> 
> diff --git a/Makefile b/Makefile
> index 1f35aca4fe05..f23516980796 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1363,7 +1363,7 @@ CLEAN_DIRS  += $(MODVERDIR) include/ksym
>  CLEAN_FILES += modules.builtin.modinfo
>  
>  # Directories & files removed with 'make mrproper'
> -MRPROPER_DIRS  += include/config usr/include include/generated          \
> +MRPROPER_DIRS  += include/config include/generated          \
>  		  arch/$(SRCARCH)/include/generated .tmp_objdiff
>  MRPROPER_FILES += .config .config.old .version \
>  		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
> diff --git a/init/Kconfig b/init/Kconfig
> index df5bba27e3fe..667d68e1cdf4 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -105,6 +105,17 @@ config HEADER_TEST
>  	  If you are a developer or tester and want to ensure the requested
>  	  headers are self-contained, say Y here. Otherwise, choose N.
>  
> +config UAPI_HEADER_TEST
> +	bool "Compile test UAPI headers"
> +	depends on HEADER_TEST && HEADERS_INSTALL
> +	depends on $(success,$(srctree)/scripts/cc-system-headers.sh $(CC))
> +	help
> +	  Compile test headers exported to user-space to ensure they are
> +	  self-contained, i.e. compilable as standalone units.
> +
> +	  If you are a developer or tester and want to ensure the exported
> +	  headers are self-contained, say Y here. Otherwise, choose N.
> +
>  config LOCALVERSION
>  	string "Local version - append to kernel release"
>  	help
> diff --git a/scripts/cc-system-headers.sh b/scripts/cc-system-headers.sh
> new file mode 100755
> index 000000000000..1b3db369828c
> --- /dev/null
> +++ b/scripts/cc-system-headers.sh
> @@ -0,0 +1,8 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0-only
> +
> +cat << "END" | $@ -E -x c - -o /dev/null >/dev/null 2>&1
> +#include <stdlib.h>
> +#include <sys/ioctl.h>
> +#include <sys/time.h>
> +END

Add comment to this file that explains that it is used to verify that the
toolchain provides the minimal set of header-files required by uapi
headers.

> diff --git a/usr/.gitignore b/usr/.gitignore
> index 8e48117a3f3d..be5eae1df7eb 100644
> --- a/usr/.gitignore
> +++ b/usr/.gitignore
> @@ -7,4 +7,3 @@ initramfs_data.cpio.gz
>  initramfs_data.cpio.bz2
>  initramfs_data.cpio.lzma
>  initramfs_list
> -include
> diff --git a/usr/Makefile b/usr/Makefile
> index 4a70ae43c9cb..6a89eb019275 100644
> --- a/usr/Makefile
> +++ b/usr/Makefile
> @@ -56,3 +56,5 @@ $(deps_initramfs): klibcdirs
>  $(obj)/$(datafile_y): $(obj)/gen_init_cpio $(deps_initramfs) klibcdirs
>  	$(Q)$(initramfs) -l $(ramfs-input) > $(obj)/$(datafile_d_y)
>  	$(call if_changed,initfs)
> +
> +subdir-$(CONFIG_UAPI_HEADER_TEST) += include
> diff --git a/usr/include/.gitignore b/usr/include/.gitignore
> new file mode 100644
> index 000000000000..a0991ff4402b
> --- /dev/null
> +++ b/usr/include/.gitignore
> @@ -0,0 +1,3 @@
> +*
> +!.gitignore
> +!Makefile
> diff --git a/usr/include/Makefile b/usr/include/Makefile
> new file mode 100644
> index 000000000000..58ce96fa1701
> --- /dev/null
> +++ b/usr/include/Makefile
> @@ -0,0 +1,134 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +
> +# Unlike the kernel space, uapi headers are written in standard C.
> +#  - Forbid C++ style comments
> +#  - Use '__inline__', '__asm__' instead of 'inline', 'asm'
> +#
> +# -std=c90 (equivalent to -ansi) catches the violation of those.
> +# We cannot go as far as adding -Wpedantic since it emits too many warnings.
> +#
> +# REVISIT: re-consider the proper set of compiler flags for uapi compile-test.
> +
> +UAPI_CFLAGS := -std=c90 -Wall -Werror=implicit-function-declaration
> +
> +override c_flags = $(UAPI_CFLAGS) -Wp,-MD,$(depfile) -I$(objtree)/usr/include
> +
> +# The following are excluded for now because they fail to build.
> +# The cause of errors are mostly missing include directives.
> +# Check one by one, and send a patch to each subsystem.
> +#
> +# Do not add a new header to the blacklist without legitimate reason.
> +# Please consider to fix the header first.

Maybe add comment that the alphabetical sort by filename must be preserved.
Not too relevant, as we hopefully do not see files being added.

> +header-test- += asm/ipcbuf.h
> +header-test- += asm/msgbuf.h
Consider same syntax like in include/Makefile where you use
header-test-<tab><tab>...+= file

Then the alignment looks betters.

> +header-test- += asm/sembuf.h
> +header-test- += asm/shmbuf.h
> +header-test- += asm/signal.h
> +header-test- += asm/ucontext.h
> +header-test- += drm/vmwgfx_drm.h
> +header-test- += linux/am437x-vpfe.h
> +header-test- += linux/android/binderfs.h
> +header-test- += linux/android/binder.h
> +header-test-$(CONFIG_CPU_BIG_ENDIAN) += linux/byteorder/big_endian.h
> +header-test-$(CONFIG_CPU_LITTLE_ENDIAN) += linux/byteorder/little_endian.h
> +header-test- += linux/coda.h
...
List is shorter than I feared. Seems quite doable to get down to a
small number of files.

> +
> +# more headers are broken in some architectures
> +
> +ifeq ($(SRCARCH),arc)
> +header-test- += linux/bpf_perf_event.h
> +endif
Again a manageable number.

> +
> +
> +# asm-generic/*.h is used by asm/*.h, and should not be included directly
> +header-test- += asm-generic/%
> +
> +# The rest are compile-tested
> +header-test-y += $(filter-out $(header-test-), \
> +			$(patsubst $(obj)/%,%, $(wildcard \
> +			$(addprefix $(obj)/, *.h */*.h */*/*.h */*/*/*.h))))
Could you use header-test-pattern-y here?

	Sam
