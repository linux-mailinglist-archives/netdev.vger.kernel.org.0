Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64E221EBFD
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 11:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgGNJBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 05:01:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58003 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725816AbgGNJBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 05:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594717265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0ed3Xocn2VEJ7JZTYR0y+4DEJWtAkhtN40Gvl92+Xn0=;
        b=Y3SEIXKmduX/+XYTfpiDX/LuQkCdO38+Xi/MiXEVNDTueGy98byRf9/c9SUzRwGKlR6hpf
        K0ntKKDXkS8VflKTe6X8JIGQqeJaMO3QURdlg/qINkynSCYEc/IqeEectnynBAZ4por6RC
        KCEbZ/yplXE/hhFFa+dBDqVhd9gsvHI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-eftPBnxdNtuDoNxCfsMStA-1; Tue, 14 Jul 2020 05:01:01 -0400
X-MC-Unique: eftPBnxdNtuDoNxCfsMStA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C77D109D;
        Tue, 14 Jul 2020 09:00:52 +0000 (UTC)
Received: from krava (unknown [10.40.193.14])
        by smtp.corp.redhat.com (Postfix) with SMTP id 227AD5C679;
        Tue, 14 Jul 2020 09:00:49 +0000 (UTC)
Date:   Tue, 14 Jul 2020 11:00:48 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: linux-next: build warning after merge of the bpf-next tree
Message-ID: <20200714090048.GG183694@krava>
References: <20200714121608.58962d66@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714121608.58962d66@canb.auug.org.au>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 12:16:08PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the bpf-next tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> ld: warning: orphan section `.BTF_ids' from `kernel/trace/bpf_trace.o' being placed in section `.BTF_ids'
> ld: warning: orphan section `.BTF_ids' from `kernel/bpf/btf.o' being placed in section `.BTF_ids'
> ld: warning: orphan section `.BTF_ids' from `kernel/bpf/stackmap.o' being placed in section `.BTF_ids'
> ld: warning: orphan section `.BTF_ids' from `net/core/filter.o' being placed in section `.BTF_ids'
> ld: warning: orphan section `.BTF_ids' from `kernel/trace/bpf_trace.o' being placed in section `.BTF_ids'
> ld: warning: orphan section `.BTF_ids' from `kernel/bpf/btf.o' being placed in section `.BTF_ids'
> ld: warning: orphan section `.BTF_ids' from `kernel/bpf/stackmap.o' being placed in section `.BTF_ids'
> ld: warning: orphan section `.BTF_ids' from `net/core/filter.o' being placed in section `.BTF_ids'
> ld: warning: orphan section `.BTF_ids' from `kernel/trace/bpf_trace.o' being placed in section `.BTF_ids'
> ld: warning: orphan section `.BTF_ids' from `kernel/bpf/btf.o' being placed in section `.BTF_ids'
> ld: warning: orphan section `.BTF_ids' from `kernel/bpf/stackmap.o' being placed in section `.BTF_ids'
> ld: warning: orphan section `.BTF_ids' from `net/core/filter.o' being placed in section `.BTF_ids'
> 
> Presumably ntroduced by the merge of the resolve_btfids branch.

missing one more #ifdef.. chage below fixes it for me,
it's squashed with the fix for the arm build, I'll post 
both fixes today

thanks,
jirka


---
diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index fe019774f8a7..2f9754a4ab2b 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -3,6 +3,8 @@
 #ifndef _LINUX_BTF_IDS_H
 #define _LINUX_BTF_IDS_H
 
+#ifdef CONFIG_DEBUG_INFO_BTF
+
 #include <linux/compiler.h> /* for __PASTE */
 
 /*
@@ -21,7 +23,7 @@
 asm(							\
 ".pushsection " BTF_IDS_SECTION ",\"a\";       \n"	\
 ".local " #symbol " ;                          \n"	\
-".type  " #symbol ", @object;                  \n"	\
+".type  " #symbol ", STT_OBJECT;               \n"	\
 ".size  " #symbol ", 4;                        \n"	\
 #symbol ":                                     \n"	\
 ".zero 4                                       \n"	\
@@ -83,5 +85,12 @@ asm(							\
 ".zero 4                                       \n"	\
 ".popsection;                                  \n");
 
+#else
+
+#define BTF_ID_LIST(name) u32 name[5];
+#define BTF_ID(prefix, name)
+#define BTF_ID_UNUSED
+
+#endif /* CONFIG_DEBUG_INFO_BTF */
 
 #endif
diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index 948378ca73d4..a88cd4426398 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -16,6 +16,20 @@ else
   MAKEFLAGS=--no-print-directory
 endif
 
+# always use the host compiler
+ifneq ($(LLVM),)
+HOSTAR  ?= llvm-ar
+HOSTCC  ?= clang
+HOSTLD  ?= ld.lld
+else
+HOSTAR  ?= ar
+HOSTCC  ?= gcc
+HOSTLD  ?= ld
+endif
+AR       = $(HOSTAR)
+CC       = $(HOSTCC)
+LD       = $(HOSTLD)
+
 OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
 
 LIBBPF_SRC := $(srctree)/tools/lib/bpf/

