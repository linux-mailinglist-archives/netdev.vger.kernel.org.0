Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1394145D8F
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 22:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgAVVSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 16:18:51 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46144 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725827AbgAVVSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 16:18:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579727931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MElVa5JpgF25TjRdpyZNYMF3CvuryfMi3Vab8+75XZ4=;
        b=RGQ3MoFdl1d47ccdbSHER9C6LBQrtCzdQFEtQ6Y/5X7hBMuJwF6tmDRJGcLFuBJ17MCrab
        t8AGiJl2Wm+DdiC7o7aHz/HIuDt8vAaTY5cPfwwQ6QPdFh0zaDfrIJ20W93VdI94eMjg2M
        Pm32sflxXq2o708GR2zanTbZ1Rll1bQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-J3zpqVKwOtWTpMVyGFbVXQ-1; Wed, 22 Jan 2020 16:18:47 -0500
X-MC-Unique: J3zpqVKwOtWTpMVyGFbVXQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFE3A1012676;
        Wed, 22 Jan 2020 21:18:44 +0000 (UTC)
Received: from krava (ovpn-204-34.brq.redhat.com [10.40.204.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1620D19C69;
        Wed, 22 Jan 2020 21:18:40 +0000 (UTC)
Date:   Wed, 22 Jan 2020 22:18:38 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Martin Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Subject: Re: [PATCH 1/6] bpf: Allow ctx access for pointers to scalar
Message-ID: <20200122211838.GA828118@krava>
References: <20200121120512.758929-1-jolsa@kernel.org>
 <20200121120512.758929-2-jolsa@kernel.org>
 <CAADnVQKeR1VFEaRGY7Zy=P7KF8=TKshEy2inhFfi9qis9osS3A@mail.gmail.com>
 <0e114cc9-421d-a30d-db40-91ec7a2a7a34@fb.com>
 <20200122091336.GE801240@krava>
 <20200122160957.igyl2i4ybvbdfoiq@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122160957.igyl2i4ybvbdfoiq@ast-mbp>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 08:09:59AM -0800, Alexei Starovoitov wrote:

SNIP

> > > > It cannot dereference it. Use it as what?
> > > 
> > > If this is from original bcc code, it will use bpf_probe_read for 
> > > dereference. This is what I understand when I first reviewed this patch.
> > > But it will be good to get Jiri's confirmation.
> > 
> > it blocked me from accessing 'filename' argument when I probed
> > do_sys_open via trampoline in bcc, like:
> > 
> > 	KRETFUNC_PROBE(do_sys_open)
> > 	{
> > 	    const char *filename = (const char *) args[1];
> > 
> > AFAICS the current code does not allow for trampoline arguments
> > being other pointers than to void or struct, the patch should
> > detect that the argument is pointer to scalar type and let it
> > pass
> 
> Got it. I've looked up your bcc patches and I agree that there is no way to
> workaround. BTF type argument of that kernel function is 'const char *' and the
> verifier will enforce that if bpf program tries to cast it the verifier will
> still see 'const char *'. (It's done this way by design). How about we special
> case 'char *' in the verifier? Then my concern regarding future extensibility
> of 'int *' and 'long *' will go away.
> Compilers have a long history special casing 'char *'. In particular signed
> char because it's a pointer to null terminated string. I think it's still a
> special pointer from pointer aliasing point of view. I think the verifier can
> treat it as scalar here too. In the future the verifier will get smarter and
> will recognize it as PTR_TO_NULL_STRING while 'u8 *', 'u32 *' will be
> PTR_TO_BTF_ID. I think it will solve this particular issue. I like conservative
> approach to the verifier improvements: start with strict checking and relax it
> on case-by-case. Instead of accepting wide range of cases and cause potential
> compatibility issues.

ok, so something like below?

jirka


---
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 832b5d7fd892..dd678b8e00b7 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3664,6 +3664,19 @@ struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
 	}
 }
 
+static bool is_string_ptr(struct btf *btf, const struct btf_type *t)
+{
+	/* t comes in already as a pointer */
+	t = btf_type_by_id(btf, t->type);
+
+	/* allow const */
+	if (BTF_INFO_KIND(t->info) == BTF_KIND_CONST)
+		t = btf_type_by_id(btf, t->type);
+
+	/* char, signed char, unsigned char */
+	return btf_type_is_int(t) && t->size == 1;
+}
+
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info)
@@ -3730,6 +3743,9 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		 */
 		return true;
 
+	if (is_string_ptr(btf, t))
+		return true;
+
 	/* this is a pointer to another type */
 	info->reg_type = PTR_TO_BTF_ID;
 

