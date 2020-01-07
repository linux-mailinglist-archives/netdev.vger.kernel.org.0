Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0E3132A71
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgAGPut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:50:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27043 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727994AbgAGPut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:50:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578412247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=okkw4R7rDlzwrr1SRZoyB95nisQucs+Te4tLvgMSVEc=;
        b=UxGXnME6mJrz+8gMbrUWuw6kdTK/W+fYAhy6Q9kSY9ce+KsAuaWnSR383Y9zi5ykxgf33J
        VH9H/8NCQjkXYnCY0pxFMRAc293G9os4VO07KbrevrBKbAEPoODvB5neD79PZYp4sJg0kS
        x4fOYF0e8pn3q8FJdMwIy3oFVjz4HBw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-HUmOplTzPTKjhTxHoXNUzA-1; Tue, 07 Jan 2020 10:50:40 -0500
X-MC-Unique: HUmOplTzPTKjhTxHoXNUzA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC87DDBAE;
        Tue,  7 Jan 2020 15:50:35 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B396A10016EB;
        Tue,  7 Jan 2020 15:50:33 +0000 (UTC)
Date:   Tue, 7 Jan 2020 16:50:31 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Martin Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
Subject: Re: [PATCH 1/5] bpf: Allow non struct type for btf ctx access
Message-ID: <20200107155031.GB349285@krava>
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-2-jolsa@kernel.org>
 <d7b8cecf-d28a-1f4d-eb2b-eb8a601b9914@fb.com>
 <20200107121319.GG290055@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107121319.GG290055@krava>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 01:13:23PM +0100, Jiri Olsa wrote:
> On Mon, Jan 06, 2020 at 09:36:17PM +0000, Yonghong Song wrote:
> > 
> > 
> > On 12/29/19 6:37 AM, Jiri Olsa wrote:
> > > I'm not sure why the restriction was added,
> > > but I can't access pointers to POD types like
> > > const char * when probing vfs_read function.
> > > 
> > > Removing the check and allow non struct type
> > > access in context.
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >   kernel/bpf/btf.c | 6 ------
> > >   1 file changed, 6 deletions(-)
> > > 
> > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > index ed2075884724..ae90f60ac1b8 100644
> > > --- a/kernel/bpf/btf.c
> > > +++ b/kernel/bpf/btf.c
> > > @@ -3712,12 +3712,6 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> > >   	/* skip modifiers */
> > >   	while (btf_type_is_modifier(t))
> > >   		t = btf_type_by_id(btf, t->type);
> > > -	if (!btf_type_is_struct(t)) {
> > > -		bpf_log(log,
> > > -			"func '%s' arg%d type %s is not a struct\n",
> > > -			tname, arg, btf_kind_str[BTF_INFO_KIND(t->info)]);
> > > -		return false;
> > > -	}
> > 
> > Hi, Jiri, the RFC looks great! Especially, you also referenced this will
> > give great performance boost for bcc scripts.
> > 
> > Could you provide more context on why the above change is needed?
> > The function btf_ctx_access is used to check validity of accessing
> > function parameters which are wrapped inside a structure, I am wondering
> > what kinds of accesses you tried to address here.
> 
> when I was transforming opensnoop.py to use this I got fail in
> there when I tried to access filename arg in do_sys_open
> 
> but actualy it seems this should get recognized earlier by:
> 
>           if (btf_type_is_int(t))
>                 /* accessing a scalar */
>                 return true;
> 
> I'm not sure why it did not pass for const char*, I'll check

it seems we don't check for pointer to scalar (just void),
which is the case in my example 'const char *filename'

I'll post this in v2 with other changes

jirka


---
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index ed2075884724..650df4ed346e 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3633,7 +3633,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info)
 {
-	const struct btf_type *t = prog->aux->attach_func_proto;
+	const struct btf_type *tp, *t = prog->aux->attach_func_proto;
 	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
 	struct btf *btf = bpf_prog_get_target_btf(prog);
 	const char *tname = prog->aux->attach_func_name;
@@ -3695,6 +3695,17 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		 */
 		return true;
 
+	tp = btf_type_by_id(btf, t->type);
+	/* skip modifiers */
+	while (btf_type_is_modifier(tp))
+		tp = btf_type_by_id(btf, tp->type);
+
+	if (btf_type_is_int(tp))
+		/* This is a pointer scalar.
+		 * It is the same as scalar from the verifier safety pov.
+		 */
+		return true;
+
 	/* this is a pointer to another type */
 	info->reg_type = PTR_TO_BTF_ID;
 	info->btf_id = t->type;

