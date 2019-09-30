Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B01F4C1B41
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 08:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbfI3GGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 02:06:14 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42408 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfI3GGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 02:06:14 -0400
Received: by mail-qk1-f196.google.com with SMTP id f16so6751711qkl.9;
        Sun, 29 Sep 2019 23:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3AYbhlSyOGHd/YWMdKD1wO/4O/Z+7TVbIdFmQebCqUQ=;
        b=WHunc1V+2GTwQPnHQ04fsUDddEl0IMlOH6eowiasqtSkM+2Ju3XDUmqTAtSqox1jPU
         Eu22gcZsMu5S7TnwjxwFjuCmoFPrapcueTfBC51rQPmj4NraAzkNVzcVOIWbhBeyoEL1
         bQ+wvrGRYfgyAtm6AMmbXXpW6EJdE2u/DcuwRR4+tC+amxani49naqEognHi8ppB6AXQ
         4bqgfwI3dwnvg8YxoRfO8XkIbuVQtKMy7M8+jHziqQFUpK168oZK/HCJaAK5X9DY1n5h
         gitK9IzG633hk/p2Hy2kw3H9cXxYJRPVW2j9OzJX02fqSgFpwQNd96fv9BrngG933NpB
         F+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3AYbhlSyOGHd/YWMdKD1wO/4O/Z+7TVbIdFmQebCqUQ=;
        b=CYB/sM4ZIapNOkpre2RFVDtw85G9372C6HeAVdsKOChe02bptdOmRxi6YGmSHgoYMi
         /ux1XWz1rvmb7D7+BcHwN3qmKr+4K4Mt0XpRDztH68P4veIp6LDLr6fX3PW7g84ga1tv
         OPBhXtqfeJLHXFlofpitbm0ZUus59kkx0u15f0TW1uHEZG++H5zfjpMrQSgiKSQjrJ3R
         wdazihlCGvXeXbOumlIOP8o0b9fkwv0Aw7VbzEAnBAxqvvh63G9bKzYYCZYtRTYK+mMk
         4FB3nRSPMLW37QWN6M618H60InZ4Jtin3CLQ4u8UIvzYE9tUV58eI0106KMHizXH1JyM
         Lvwg==
X-Gm-Message-State: APjAAAV2c1gKSeK56y+GKDCgRLEDnCeKcTGGbQ8zKZbA/58NyrGChZW0
        Fx3BbagcnuOVr5DtED+MCuHtLeYviUPHVtgi88M=
X-Google-Smtp-Source: APXvYqwdUMWQICjGJO3tZeED7knCzZ+5BDTWhKu97fjIIZqS59Xiemczq6rQg7KIMw/7baPtZqm3bUqezBi2qORmYs0=
X-Received: by 2002:a05:620a:119a:: with SMTP id b26mr17169165qkk.39.1569823572755;
 Sun, 29 Sep 2019 23:06:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190928231916.3054271-1-yhs@fb.com>
In-Reply-To: <20190928231916.3054271-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 29 Sep 2019 23:06:01 -0700
Message-ID: <CAEf4BzY6-Nvu=Gc4+zwVQd9UQzJt-DBj9dEO+=D8XQ6K8K847w@mail.gmail.com>
Subject: Re: [PATCH bpf v2] libbpf: handle symbol versioning properly for libbpf.a
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Kevin Laatz <kevin.laatz@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 28, 2019 at 4:23 PM Yonghong Song <yhs@fb.com> wrote:
>
> bcc uses libbpf repo as a submodule. It brings in libbpf source
> code and builds everything together to produce shared libraries.
> With latest libbpf, I got the following errors:
>   /bin/ld: libbcc_bpf.so.0.10.0: version node not found for symbol xsk_umem__create@LIBBPF_0.0.2
>   /bin/ld: failed to set dynamic section sizes: Bad value
>   collect2: error: ld returned 1 exit status
>   make[2]: *** [src/cc/libbcc_bpf.so.0.10.0] Error 1
>
> In xsk.c, we have
>   asm(".symver xsk_umem__create_v0_0_2, xsk_umem__create@LIBBPF_0.0.2");
>   asm(".symver xsk_umem__create_v0_0_4, xsk_umem__create@@LIBBPF_0.0.4");
> The linker thinks the built is for LIBBPF but cannot find proper version
> LIBBPF_0.0.2/4, so emit errors.
>
> I also confirmed that using libbpf.a to produce a shared library also
> has issues:
>   -bash-4.4$ cat t.c
>   extern void *xsk_umem__create;
>   void * test() { return xsk_umem__create; }
>   -bash-4.4$ gcc -c -fPIC t.c
>   -bash-4.4$ gcc -shared t.o libbpf.a -o t.so
>   /bin/ld: t.so: version node not found for symbol xsk_umem__create@LIBBPF_0.0.2
>   /bin/ld: failed to set dynamic section sizes: Bad value
>   collect2: error: ld returned 1 exit status
>   -bash-4.4$
>
> Symbol versioning does happens in commonly used libraries, e.g., elfutils
> and glibc. For static libraries, for a versioned symbol, the old definitions
> will be ignored, and the symbol will be an alias to the latest definition.
> For example, glibc sched_setaffinity is versioned.
>   -bash-4.4$ readelf -s /usr/lib64/libc.so.6 | grep sched_setaffinity
>      756: 000000000013d3d0    13 FUNC    GLOBAL DEFAULT   13 sched_setaffinity@GLIBC_2.3.3
>      757: 00000000000e2e70   455 FUNC    GLOBAL DEFAULT   13 sched_setaffinity@@GLIBC_2.3.4
>     1800: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS sched_setaffinity.c
>     4228: 00000000000e2e70   455 FUNC    LOCAL  DEFAULT   13 __sched_setaffinity_new
>     4648: 000000000013d3d0    13 FUNC    LOCAL  DEFAULT   13 __sched_setaffinity_old
>     7338: 000000000013d3d0    13 FUNC    GLOBAL DEFAULT   13 sched_setaffinity@GLIBC_2
>     7380: 00000000000e2e70   455 FUNC    GLOBAL DEFAULT   13 sched_setaffinity@@GLIBC_
>   -bash-4.4$
> For static library, the definition of sched_setaffinity aliases to the new definition.
>   -bash-4.4$ readelf -s /usr/lib64/libc.a | grep sched_setaffinity
>   File: /usr/lib64/libc.a(sched_setaffinity.o)
>      8: 0000000000000000   455 FUNC    GLOBAL DEFAULT    1 __sched_setaffinity_new
>     12: 0000000000000000   455 FUNC    WEAK   DEFAULT    1 sched_setaffinity
>
> For both elfutils and glibc, additional macros are used to control different handling
> of symbol versioning w.r.t static and shared libraries.
> For elfutils, the macro is SYMBOL_VERSIONING
> (https://sourceware.org/git/?p=elfutils.git;a=blob;f=lib/eu-config.h).
> For glibc, the macro is SHARED
> (https://sourceware.org/git/?p=glibc.git;a=blob;f=include/shlib-compat.h;hb=refs/heads/master)
>
> This patch used SYMBOL_VERSIONING as the macro name as it clearly indicates the
> intention. The macro name can be changed later if necessary as it is internal

I actually like SHARED more, because it's really is a generic
indicator of whether we are linking as static or shared library. The
fact that we are using that flag for symbol versioning is specific to
NEW_VERSION/OLD_VERSION macros, but SHARED itself can be later used
for some other static vs shared logic. But it's subjective matter, so
I won't insist.

> to libbpf. After this patch, the libbpf.a has
>   -bash-4.4$ readelf -s libbpf.a | grep xsk_umem__create
>      372: 0000000000017145  1190 FUNC    GLOBAL DEFAULT    1 xsk_umem__create_v0_0_4
>      405: 0000000000017145  1190 FUNC    WEAK   DEFAULT    1 xsk_umem__create
>      499: 00000000000175eb   103 FUNC    GLOBAL DEFAULT    1 xsk_umem__create_v0_0_2
>   -bash-4.4$
> No versioned symbols for xsk_umem__create.
> The libbpf.a can be used to build a shared library succesfully.
>   -bash-4.4$ cat t.c
>   extern void *xsk_umem__create;
>   void * test() { return xsk_umem__create; }
>   -bash-4.4$ gcc -c -fPIC t.c
>   -bash-4.4$ gcc -shared t.o libbpf.a -o t.so
>   -bash-4.4$
>
> Fixes: 10d30e301732 ("libbpf: add flags to umem config")
> Cc: Kevin Laatz <kevin.laatz@intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

I only have few minor nits, otherwise this looks good, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/Makefile          | 27 ++++++++++++++++++---------
>  tools/lib/bpf/libbpf_internal.h | 16 ++++++++++++++++
>  tools/lib/bpf/xsk.c             |  4 ++--
>  3 files changed, 36 insertions(+), 11 deletions(-)
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index c6f94cffe06e..9533e185d9b6 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -110,6 +110,9 @@ override CFLAGS += $(INCLUDES)
>  override CFLAGS += -fvisibility=hidden
>  override CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
>
> +# flags specific for shared library
> +SHLIB_FLAGS = -DSYMBOL_VERSIONING

Nit: use :=, there is no need for expansions at later point.

> +
>  ifeq ($(VERBOSE),1)
>    Q =
>  else
> @@ -126,14 +129,17 @@ all:
>  export srctree OUTPUT CC LD CFLAGS V
>  include $(srctree)/tools/build/Makefile.include
>
> -BPF_IN         := $(OUTPUT)libbpf-in.o
> +SHARED_OBJDIR  := $(OUTPUT)sharedobjs/
> +STATIC_OBJDIR  := $(OUTPUT)staticobjs/
> +BPF_IN_SHARED  := $(SHARED_OBJDIR)libbpf-in.o
> +BPF_IN_STATIC  := $(STATIC_OBJDIR)libbpf-in.o
>  VERSION_SCRIPT := libbpf.map
>
>  LIB_TARGET     := $(addprefix $(OUTPUT),$(LIB_TARGET))
>  LIB_FILE       := $(addprefix $(OUTPUT),$(LIB_FILE))
>  PC_FILE                := $(addprefix $(OUTPUT),$(PC_FILE))
>
> -GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN) | \
> +GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
>                            cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | \
>                            awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}' | \
>                            sort -u | wc -l)
> @@ -155,7 +161,7 @@ all: fixdep
>
>  all_cmd: $(CMD_TARGETS) check
>
> -$(BPF_IN): force elfdep bpfdep
> +$(BPF_IN_SHARED): force elfdep bpfdep
>         @(test -f ../../include/uapi/linux/bpf.h -a -f ../../../include/uapi/linux/bpf.h && ( \
>         (diff -B ../../include/uapi/linux/bpf.h ../../../include/uapi/linux/bpf.h >/dev/null) || \
>         echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' differs from latest version at 'include/uapi/linux/bpf.h'" >&2 )) || true
> @@ -171,17 +177,20 @@ $(BPF_IN): force elfdep bpfdep
>         @(test -f ../../include/uapi/linux/if_xdp.h -a -f ../../../include/uapi/linux/if_xdp.h && ( \
>         (diff -B ../../include/uapi/linux/if_xdp.h ../../../include/uapi/linux/if_xdp.h >/dev/null) || \
>         echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/if_xdp.h' differs from latest version at 'include/uapi/linux/if_xdp.h'" >&2 )) || true
> -       $(Q)$(MAKE) $(build)=libbpf
> +       $(Q)$(MAKE) $(build)=libbpf OUTPUT=$(SHARED_OBJDIR) CFLAGS="$(CFLAGS) $(SHLIB_FLAGS)"
> +
> +$(BPF_IN_STATIC): force elfdep bpfdep
> +       $(Q)$(MAKE) $(build)=libbpf OUTPUT=$(STATIC_OBJDIR)
>
>  $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
>
> -$(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN)
> +$(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN_SHARED)
>         $(QUIET_LINK)$(CC) --shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
>                                     -Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
>         @ln -sf $(@F) $(OUTPUT)libbpf.so
>         @ln -sf $(@F) $(OUTPUT)libbpf.so.$(LIBBPF_MAJOR_VERSION)
>
> -$(OUTPUT)libbpf.a: $(BPF_IN)
> +$(OUTPUT)libbpf.a: $(BPF_IN_STATIC)
>         $(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
>
>  $(OUTPUT)test_libbpf: test_libbpf.cpp $(OUTPUT)libbpf.a
> @@ -197,7 +206,7 @@ check: check_abi
>
>  check_abi: $(OUTPUT)libbpf.so
>         @if [ "$(GLOBAL_SYM_COUNT)" != "$(VERSIONED_SYM_COUNT)" ]; then  \
> -               echo "Warning: Num of global symbols in $(BPF_IN)"       \
> +               echo "Warning: Num of global symbols in $(BPF_IN_SHARED)"        \
>                      "($(GLOBAL_SYM_COUNT)) does NOT match with num of"  \
>                      "versioned symbols in $^ ($(VERSIONED_SYM_COUNT))." \
>                      "Please make sure all LIBBPF_API symbols are"       \
> @@ -255,9 +264,9 @@ config-clean:
>         $(Q)$(MAKE) -C $(srctree)/tools/build/feature/ clean >/dev/null
>
>  clean:
> -       $(call QUIET_CLEAN, libbpf) $(RM) $(TARGETS) $(CXX_TEST_TARGET) \
> +       $(call QUIET_CLEAN, libbpf) $(RM) -rf $(TARGETS) $(CXX_TEST_TARGET) \
>                 *.o *~ *.a *.so *.so.$(LIBBPF_MAJOR_VERSION) .*.d .*.cmd \
> -               *.pc LIBBPF-CFLAGS
> +               *.pc LIBBPF-CFLAGS $(SHARED_OBJDIR) $(STATIC_OBJDIR)
>         $(call QUIET_CLEAN, core-gen) $(RM) $(OUTPUT)FEATURE-DUMP.libbpf
>
>
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index 2e83a34f8c79..40a6d376de9a 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -34,6 +34,22 @@
>         (offsetof(TYPE, FIELD) + sizeof(((TYPE *)0)->FIELD))
>  #endif
>
> +/* Symbol versoining is different between static and shared library.

typo: versioning

> + * Properly versioned symbols are needed for shared library, but
> + * only the symbol of the new version is needed.
> + */
> +#ifdef SYMBOL_VERSIONING

I like that those projects that are building libbpf from sources as
submodule won't have to define anything to get correctly linked static
library!

> +# define OLD_VERSION(internal_name, api_name, version) \
> +       asm(".symver " #internal_name "," #api_name "@" #version);
> +# define NEW_VERSION(internal_name, api_name, version) \

Again, subjective, but CUR_VERSION or DEFAULT_VERSION name seems more
precise to me.

> +       asm(".symver " #internal_name "," #api_name "@@" #version);
> +#else
> +# define OLD_VERSION(internal_name, api_name, version)
> +# define NEW_VERSION(internal_name, api_name, version) \
> +       extern typeof(internal_name) api_name \
> +       __attribute__ ((weak, alias (#internal_name)));

nit: is extra space after alias necessary?

> +#endif
> +
>  extern void libbpf_print(enum libbpf_print_level level,
>                          const char *format, ...)
>         __attribute__((format(printf, 2, 3)));
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 24fa313524fb..6b983a4b7664 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -261,8 +261,8 @@ int xsk_umem__create_v0_0_2(struct xsk_umem **umem_ptr, void *umem_area,
>         return xsk_umem__create_v0_0_4(umem_ptr, umem_area, size, fill, comp,
>                                         &config);
>  }
> -asm(".symver xsk_umem__create_v0_0_2, xsk_umem__create@LIBBPF_0.0.2");
> -asm(".symver xsk_umem__create_v0_0_4, xsk_umem__create@@LIBBPF_0.0.4");
> +OLD_VERSION(xsk_umem__create_v0_0_2, xsk_umem__create, LIBBPF_0.0.2)
> +NEW_VERSION(xsk_umem__create_v0_0_4, xsk_umem__create, LIBBPF_0.0.4)
>
>  static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>  {
> --
> 2.17.1
>
