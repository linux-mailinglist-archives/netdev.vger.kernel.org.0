Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39418301885
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 22:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbhAWVZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 16:25:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30763 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbhAWVZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 16:25:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611437038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RMCRcAizdGn6fiv942ssgog6YXuljmJW+APZk+ZQJME=;
        b=CkohH0ZGQ1yAuL12SViVWbWnJv9gmXPfDMu9qlAJB8ruhwba6RbyXDH7EqKuqfhHJuqvyA
        k3QwaWX4x+flMx4JsAmwHz/eXlbfittVzQd9IUazpMaCps12DusdOxD3F4rdEVe7AGc8Cs
        /Vpv99149w8/Nm9Ee5OQAGIwFamFdTQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-D9SZBjIJNOGhkgDJXBZUvg-1; Sat, 23 Jan 2021 16:23:54 -0500
X-MC-Unique: D9SZBjIJNOGhkgDJXBZUvg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD93F806661;
        Sat, 23 Jan 2021 21:23:52 +0000 (UTC)
Received: from krava (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with SMTP id B702760C5B;
        Sat, 23 Jan 2021 21:23:42 +0000 (UTC)
Date:   Sat, 23 Jan 2021 22:23:41 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Subject: Re: [PATCH 2/3] bpf_encoder: Translate SHN_XINDEX in symbol's
 st_shndx values
Message-ID: <20210123212341.GC117714@krava>
References: <20210121202203.9346-1-jolsa@kernel.org>
 <20210121202203.9346-3-jolsa@kernel.org>
 <CAEf4BzZquSn0Th7bpVuM0M4XbTPU5-9jDPPd5RJBS5AH2zqaMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZquSn0Th7bpVuM0M4XbTPU5-9jDPPd5RJBS5AH2zqaMA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 03:32:40PM -0800, Andrii Nakryiko wrote:

SNIP

> But the current variant looks broken. Oh, and
> elf_symtab__for_each_symbol() is similarly broken, can you please fix
> that as well?

we'll have to change its callers a bit, because of hanging 'else'
I'll send this separately if that's ok, when I figure out how to
test ctf code

jirka


---
diff --git a/elf_symtab.h b/elf_symtab.h
index 489e2b1a3505..6823a8c37ecf 100644
--- a/elf_symtab.h
+++ b/elf_symtab.h
@@ -99,10 +99,9 @@ elf_sym__get(Elf_Data *syms, Elf_Data *syms_sec_idx_table,
  * @index: uint32_t index
  * @sym: GElf_Sym iterator
  */
-#define elf_symtab__for_each_symbol(symtab, index, sym) \
-	for (index = 0, gelf_getsym(symtab->syms, index, &sym);\
-	     index < symtab->nr_syms; \
-	     index++, gelf_getsym(symtab->syms, index, &sym))
+#define elf_symtab__for_each_symbol(symtab, index, sym)		\
+	for (index = 0; index < symtab->nr_syms; index++)	\
+		if (gelf_getsym(symtab->syms, index, &sym))
 
 /**
  * elf_symtab__for_each_symbol_index - iterate through all the symbols,
diff --git a/libctf.h b/libctf.h
index 749be8955c52..ee5412bec77e 100644
--- a/libctf.h
+++ b/libctf.h
@@ -90,11 +90,9 @@ char *ctf__string(struct ctf *ctf, uint32_t ref);
  */
 #define ctf__for_each_symtab_function(ctf, index, sym)			      \
 	elf_symtab__for_each_symbol(ctf->symtab, index, sym)		      \
-		if (ctf__ignore_symtab_function(&sym,			      \
+		if (!ctf__ignore_symtab_function(&sym,			      \
 						elf_sym__name(&sym,	      \
 							      ctf->symtab)))  \
-			continue;					      \
-		else
 
 /**
  * ctf__for_each_symtab_object - iterate thru all the symtab objects
@@ -105,11 +103,9 @@ char *ctf__string(struct ctf *ctf, uint32_t ref);
  */
 #define ctf__for_each_symtab_object(ctf, index, sym)			      \
 	elf_symtab__for_each_symbol(ctf->symtab, index, sym)		      \
-		if (ctf__ignore_symtab_object(&sym,			      \
+		if (!ctf__ignore_symtab_object(&sym,			      \
 					      elf_sym__name(&sym,	      \
 							    ctf->symtab)))    \
-			continue;					      \
-		else
 
 
 #endif /* _LIBCTF_H */

