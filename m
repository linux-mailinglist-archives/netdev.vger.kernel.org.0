Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AE5144E67
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 10:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgAVJOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 04:14:01 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51432 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726077AbgAVJOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 04:14:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579684440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KYS56R1UsNZJ8fJM8BHO+cjdDskI/GYF3zalFp7uT70=;
        b=M/XFD2E6L2mDgi+CCcd3nyTya2bZXg544rB6Y3wZi6YXxyz/WhJxi0LNPoRQ2ED7oTnndD
        97wDhxhZnQ1pmyscwRESoTRqdleP6E2Jeub38+5sE7Oa0K6ZHAGBap/4Wofi3mN5OIddQl
        /ahwDKZiQvHwusE8GoH6D70dNOeUJRs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-UOUvOiqjPP6i7rWwH0MLUg-1; Wed, 22 Jan 2020 04:13:56 -0500
X-MC-Unique: UOUvOiqjPP6i7rWwH0MLUg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77C7B800D4E;
        Wed, 22 Jan 2020 09:13:54 +0000 (UTC)
Received: from krava (ovpn-205-123.brq.redhat.com [10.40.205.123])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A70D5D9C9;
        Wed, 22 Jan 2020 09:13:50 +0000 (UTC)
Date:   Wed, 22 Jan 2020 10:13:36 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
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
Message-ID: <20200122091336.GE801240@krava>
References: <20200121120512.758929-1-jolsa@kernel.org>
 <20200121120512.758929-2-jolsa@kernel.org>
 <CAADnVQKeR1VFEaRGY7Zy=P7KF8=TKshEy2inhFfi9qis9osS3A@mail.gmail.com>
 <0e114cc9-421d-a30d-db40-91ec7a2a7a34@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e114cc9-421d-a30d-db40-91ec7a2a7a34@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 02:33:32AM +0000, Yonghong Song wrote:
> 
> 
> On 1/21/20 5:51 PM, Alexei Starovoitov wrote:
> > On Tue, Jan 21, 2020 at 4:05 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >>
> >> When accessing the context we allow access to arguments with
> >> scalar type and pointer to struct. But we omit pointer to scalar
> >> type, which is the case for many functions and same case as
> >> when accessing scalar.
> >>
> >> Adding the check if the pointer is to scalar type and allow it.
> >>
> >> Acked-by: John Fastabend <john.fastabend@gmail.com>
> >> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> >> ---
> >>   kernel/bpf/btf.c | 13 ++++++++++++-
> >>   1 file changed, 12 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> >> index 832b5d7fd892..207ae554e0ce 100644
> >> --- a/kernel/bpf/btf.c
> >> +++ b/kernel/bpf/btf.c
> >> @@ -3668,7 +3668,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> >>                      const struct bpf_prog *prog,
> >>                      struct bpf_insn_access_aux *info)
> >>   {
> >> -       const struct btf_type *t = prog->aux->attach_func_proto;
> >> +       const struct btf_type *tp, *t = prog->aux->attach_func_proto;
> >>          struct bpf_prog *tgt_prog = prog->aux->linked_prog;
> >>          struct btf *btf = bpf_prog_get_target_btf(prog);
> >>          const char *tname = prog->aux->attach_func_name;
> >> @@ -3730,6 +3730,17 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> >>                   */
> >>                  return true;
> >>
> >> +       tp = btf_type_by_id(btf, t->type);
> >> +       /* skip modifiers */
> >> +       while (btf_type_is_modifier(tp))
> >> +               tp = btf_type_by_id(btf, tp->type);
> >> +
> >> +       if (btf_type_is_int(tp) || btf_type_is_enum(tp))
> >> +               /* This is a pointer scalar.
> >> +                * It is the same as scalar from the verifier safety pov.
> >> +                */
> >> +               return true;
> > 
> > The reason I didn't do it earlier is I was thinking to represent it
> > as PTR_TO_BTF_ID as well, so that corresponding u8..u64
> > access into this memory would still be possible.
> > I'm trying to analyze the situation that returning a scalar now
> > and converting to PTR_TO_BTF_ID in the future will keep progs
> > passing the verifier. Is it really the case?
> > Could you give a specific example that needs this support?
> > It will help me understand this backward compatibility concern.
> > What prog is doing with that 'u32 *' that is seen as scalar ?
> > It cannot dereference it. Use it as what?
> 
> If this is from original bcc code, it will use bpf_probe_read for 
> dereference. This is what I understand when I first reviewed this patch.
> But it will be good to get Jiri's confirmation.

it blocked me from accessing 'filename' argument when I probed
do_sys_open via trampoline in bcc, like:

	KRETFUNC_PROBE(do_sys_open)
	{
	    const char *filename = (const char *) args[1];

AFAICS the current code does not allow for trampoline arguments
being other pointers than to void or struct, the patch should
detect that the argument is pointer to scalar type and let it
pass

jirka

