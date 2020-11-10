Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C9C2AD3DC
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 11:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgKJKfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 05:35:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726280AbgKJKfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 05:35:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605004519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3WdHRgzh6m24DGxayaLsrf/V9Yc2q4Ysir/wfVOClqQ=;
        b=Rq58pQfQ9bcqHaxrlUFucBACU4/mONFt1TUcrEdZiPzYDKqaYyDRsJJPA2bwSFAeZyi9I+
        Q7nK/D6BSqjoWQ6qAiS1+9nZGEcjZa/zUMwZseomiXpur8PK80cmILyN1V3WbMI8yd446c
        +IFlswh2cuWCgqq02GE8ntlod62EEDk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-cHKs_xnzPq2l9lPg3i6jqg-1; Tue, 10 Nov 2020 05:35:15 -0500
X-MC-Unique: cHKs_xnzPq2l9lPg3i6jqg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D35F186DD25;
        Tue, 10 Nov 2020 10:35:13 +0000 (UTC)
Received: from krava (unknown [10.40.195.135])
        by smtp.corp.redhat.com (Postfix) with SMTP id BA5442C605;
        Tue, 10 Nov 2020 10:35:10 +0000 (UTC)
Date:   Tue, 10 Nov 2020 11:35:09 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCHv5 bpf] bpf: Move iterator functions into special init
 section
Message-ID: <20201110103509.GD387652@krava>
References: <20201109185754.377373-1-jolsa@kernel.org>
 <9205a69f-95db-6bc3-51f8-8b6f79c5e8fd@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9205a69f-95db-6bc3-51f8-8b6f79c5e8fd@iogearbox.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 11:04:34PM +0100, Daniel Borkmann wrote:

SNIP

> > index 7b53cb3092ee..a7c71e3b5f9a 100644
> > --- a/include/linux/init.h
> > +++ b/include/linux/init.h
> > @@ -52,6 +52,7 @@
> >   #define __initconst	__section(".init.rodata")
> >   #define __exitdata	__section(".exit.data")
> >   #define __exit_call	__used __section(".exitcall.exit")
> > +#define __init_bpf_preserve_type __section(".init.bpf.preserve_type")
> 
> Small nit, why this detour via BPF_INIT define? Couldn't we just:
> 
> #ifdef CONFIG_DEBUG_INFO_BTF
> #define __init_bpf_preserve_type   __section(".init.bpf.preserve_type")
> #else
> #define __init_bpf_preserve_type   __init
> #endif
> 
> Also, the comment above the existing defines says '/* These are for everybody (although
> not all archs will actually discard it in modules) */' ... We should probably not add
> the __init_bpf_preserve_type right under this listing as-is in your patch, but instead
> 'separate' it by adding a small comment on top of its definition by explaining its
> purpose more clearly for others.

ok, for some reason I thought I needed to add it to init.h,
but as it's bpf specific, perhaps we can omit init.h change
completely.. how about the change below?

thanks,
jirka


---
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b2b3d81b1535..f91029b3443b 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -685,8 +685,21 @@
 	.BTF_ids : AT(ADDR(.BTF_ids) - LOAD_OFFSET) {			\
 		*(.BTF_ids)						\
 	}
+
+/*
+ * .init.bpf.preserve_type
+ *
+ * This section store special BPF function and marks them
+ * with begin/end symbols pair for the sake of pahole tool.
+ */
+#define INIT_BPF_PRESERVE_TYPE						\
+	__init_bpf_preserve_type_begin = .;                             \
+	*(.init.bpf.preserve_type)                                      \
+	__init_bpf_preserve_type_end = .;				\
+	MEM_DISCARD(init.bpf.preserve_type)
 #else
 #define BTF
+#define INIT_BPF_PRESERVE_TYPE
 #endif
 
 /*
@@ -741,7 +754,8 @@
 #define INIT_TEXT							\
 	*(.init.text .init.text.*)					\
 	*(.text.startup)						\
-	MEM_DISCARD(init.text*)
+	MEM_DISCARD(init.text*)						\
+	INIT_BPF_PRESERVE_TYPE
 
 #define EXIT_DATA							\
 	*(.exit.data .exit.data.*)					\
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2b16bf48aab6..1739a92516ed 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1276,10 +1276,20 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
 
+/* In case we generate BTF data, we need to group all iterator
+ * functions into special init section, so pahole can track them.
+ * Otherwise pure __init section is enough.
+ */
+#ifdef CONFIG_DEBUG_INFO_BTF
+#define __init_bpf_preserve_type __section(".init.bpf.preserve_type")
+#else
+#define __init_bpf_preserve_type __init
+#endif
+
 #define BPF_ITER_FUNC_PREFIX "bpf_iter_"
 #define DEFINE_BPF_ITER_FUNC(target, args...)			\
 	extern int bpf_iter_ ## target(args);			\
-	int __init bpf_iter_ ## target(args) { return 0; }
+	int __init_bpf_preserve_type bpf_iter_ ## target(args) { return 0; }
 
 struct bpf_iter_aux_info {
 	struct bpf_map *map;

