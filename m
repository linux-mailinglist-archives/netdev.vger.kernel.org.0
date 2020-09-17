Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A40926D827
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 11:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgIQJy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 05:54:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49238 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgIQJy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 05:54:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600336464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PfgTD4QYp7HdelC/Cdt/0p7DJlm562Qxcolq6GnkE9E=;
        b=IknfHHJniumpYiT/JzVvMXvYOFDSXryZZecG2Z2KWKUV763Y0AD9V40w3siaMVf8XaD/vP
        s7MdOUdIjiAo4CxW9HglXwWbrUnz7t23Y4c64TF0/QcAL3CxmKM8pZBCU0u4iWBmHcFK56
        3KS/ggwqJMcYHLI5v4pFbfDP/X/WiZw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-vgJu2ttfNdah2wYv3YNUsQ-1; Thu, 17 Sep 2020 05:54:20 -0400
X-MC-Unique: vgJu2ttfNdah2wYv3YNUsQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDA5681F03B;
        Thu, 17 Sep 2020 09:54:18 +0000 (UTC)
Received: from krava (ovpn-114-176.ams2.redhat.com [10.36.114.176])
        by smtp.corp.redhat.com (Postfix) with SMTP id 273927BE44;
        Thu, 17 Sep 2020 09:54:16 +0000 (UTC)
Date:   Thu, 17 Sep 2020 11:54:15 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Seth Forshee <seth.forshee@canonical.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: resolve_btfids breaks kernel cross-compilation
Message-ID: <20200917095415.GG2411168@krava>
References: <20200916194733.GA4820@ubuntu-x1>
 <20200917080452.GB2411168@krava>
 <20200917083809.GE2411168@krava>
 <20200917091406.GF2411168@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917091406.GF2411168@krava>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 11:14:08AM +0200, Jiri Olsa wrote:
> On Thu, Sep 17, 2020 at 10:38:12AM +0200, Jiri Olsa wrote:
> > On Thu, Sep 17, 2020 at 10:04:55AM +0200, Jiri Olsa wrote:
> > > On Wed, Sep 16, 2020 at 02:47:33PM -0500, Seth Forshee wrote:
> > > > The requirement to build resolve_btfids whenever CONFIG_DEBUG_INFO_BTF
> > > > is enabled breaks some cross builds. For example, when building a 64-bit
> > > > powerpc kernel on amd64 I get:
> > > > 
> > > >  Auto-detecting system features:
> > > >  ...                        libelf: [ [32mon[m  ]
> > > >  ...                          zlib: [ [32mon[m  ]
> > > >  ...                           bpf: [ [31mOFF[m ]
> > > >  
> > > >  BPF API too old
> > > >  make[6]: *** [Makefile:295: bpfdep] Error 1
> > > > 
> > > > The contents of tools/bpf/resolve_btfids/feature/test-bpf.make.output:
> > > > 
> > > >  In file included from /home/sforshee/src/u-k/unstable/tools/arch/powerpc/include/uapi/asm/bitsperlong.h:11,
> > > >                   from /usr/include/asm-generic/int-ll64.h:12,
> > > >                   from /usr/include/asm-generic/types.h:7,
> > > >                   from /usr/include/x86_64-linux-gnu/asm/types.h:1,
> > > >                   from /home/sforshee/src/u-k/unstable/tools/include/linux/types.h:10,
> > > >                   from /home/sforshee/src/u-k/unstable/tools/include/uapi/linux/bpf.h:11,
> > > >                   from test-bpf.c:3:
> > > >  /home/sforshee/src/u-k/unstable/tools/include/asm-generic/bitsperlong.h:14:2: error: #error Inconsistent word size. Check asm/bitsperlong.h
> > > >     14 | #error Inconsistent word size. Check asm/bitsperlong.h
> > > >        |  ^~~~~
> > > > 
> > > > This is because tools/arch/powerpc/include/uapi/asm/bitsperlong.h sets
> > > > __BITS_PER_LONG based on the predefinied compiler macro __powerpc64__,
> > > > which is not defined by the host compiler. What can we do to get cross
> > > > builds working again?
> > > 
> > > could you please share the command line and setup?
> > 
> > I just reproduced.. checking on fix
> 
> I still need to check on few things, but patch below should help
> 
> we might have a problem for cross builds with different endianity
> than the host because libbpf does not support reading BTF data
> with different endianity, and we get:
> 
>   BTFIDS  vmlinux
> libbpf: non-native ELF endianness is not supported
> 
> jirka
> 
> 
> ---
> diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> index a88cd4426398..d3c818b8d8d3 100644
> --- a/tools/bpf/resolve_btfids/Makefile
> +++ b/tools/bpf/resolve_btfids/Makefile
> @@ -1,5 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  include ../../scripts/Makefile.include
> +include ../../scripts/Makefile.arch
>  
>  ifeq ($(srctree),)
>  srctree := $(patsubst %/,%,$(dir $(CURDIR)))
> @@ -29,6 +30,7 @@ endif
>  AR       = $(HOSTAR)
>  CC       = $(HOSTCC)
>  LD       = $(HOSTLD)
> +ARCH     = $(HOSTARCH)
>  
>  OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
>  

and I realized we can have CONFIG_DEBUG_INFO_BTF without
CONFIG_BPF, so we need also fix below for such cases

jirka


---
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index e6e2d9e5ff48..8a990933a690 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -343,7 +343,10 @@ vmlinux_link vmlinux "${kallsymso}" ${btf_vmlinux_bin_o}
 # fill in BTF IDs
 if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
 info BTFIDS vmlinux
-${RESOLVE_BTFIDS} vmlinux
+if [ -z "${CONFIG_BPF}" ]; then
+  no_fail=--no-fail
+fi
+${RESOLVE_BTFIDS} $no_fail vmlinux
 fi
 
 if [ -n "${CONFIG_BUILDTIME_TABLE_SORT}" ]; then

