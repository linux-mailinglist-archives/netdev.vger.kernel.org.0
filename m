Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC82C21EB6A
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 10:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgGNIbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 04:31:44 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51029 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725801AbgGNIbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 04:31:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594715501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jxagKFMPTlHYLlE9FXu+4jDWBv7YXV1lVPgmdIJdZ48=;
        b=dgJEVof3/woRI/ZiF+ROdFJqHDMEfZYzqIN/FmZUsK8iDNciky9iG7//aIxhOcHT0N4BlM
        ZXpUt7bKhAgBLi3Vn42pWU66g712mgAWkKUCxTEbn48sjuibLC5+GFwnrCgDfW8vfpVku1
        0RC+I9WbN6lYWr9YNODV/nQsHI0vaeo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-gT-4-w__MF-EnDVmh3g0kw-1; Tue, 14 Jul 2020 04:31:37 -0400
X-MC-Unique: gT-4-w__MF-EnDVmh3g0kw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C175106B244;
        Tue, 14 Jul 2020 08:31:36 +0000 (UTC)
Received: from krava (unknown [10.40.193.14])
        by smtp.corp.redhat.com (Postfix) with SMTP id 558B12DE6A;
        Tue, 14 Jul 2020 08:31:34 +0000 (UTC)
Date:   Tue, 14 Jul 2020 10:31:33 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20200714083133.GF183694@krava>
References: <20200714122247.797cf01e@canb.auug.org.au>
 <20200714061654.GE183694@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714061654.GE183694@krava>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 08:16:54AM +0200, Jiri Olsa wrote:
> On Tue, Jul 14, 2020 at 12:22:47PM +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the bpf-next tree, today's linux-next build (arm
> > multi_v7_defconfig) failed like this:
> > 
> > tmp/ccsqpVCY.s: Assembler messages:
> > tmp/ccsqpVCY.s:78: Error: unrecognized symbol type ""
> > tmp/ccsqpVCY.s:91: Error: unrecognized symbol type ""
> > 
> > I don't know what has caused this (I guess maybe the resolve_btfids
> > branch).
> > 
> > I have used the bpf-next tree from next-20200713 for today.
> 
> ok, trying to reproduce

damn crossbuilds.. change below fixes it for me,
will do some more testing and post it today

jirka


---
diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index fe019774f8a7..8b9194e22c7c 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -21,7 +21,7 @@
 asm(							\
 ".pushsection " BTF_IDS_SECTION ",\"a\";       \n"	\
 ".local " #symbol " ;                          \n"	\
-".type  " #symbol ", @object;                  \n"	\
+".type  " #symbol ", STT_OBJECT;               \n"	\
 ".size  " #symbol ", 4;                        \n"	\
 #symbol ":                                     \n"	\
 ".zero 4                                       \n"	\
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

