Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A208913452F
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 15:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgAHOjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 09:39:11 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26462 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728004AbgAHOjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 09:39:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578494349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h9+DSUTEoW4Ms6eDRN/TImF0DC6qQJdGuv6SQQnAFzo=;
        b=JsjvP+fHHN8zHRQ5Wn19tVEmAPulSoFtq91GWXgzuWB0Q+LCazkngbabhWkLYWcx0CuEOm
        21lVuMlUW0XcpnUDRLl5+clXhjujM15ImEDSSMXVqLvE0YqC3jOy5eWFXaSrp/0/in1DBK
        xWmMYHL65ebVctMIB4z3bePooWd/85I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-MBqUlLyJPcCb4WMv-2SL-g-1; Wed, 08 Jan 2020 09:39:06 -0500
X-MC-Unique: MBqUlLyJPcCb4WMv-2SL-g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4D388024D5;
        Wed,  8 Jan 2020 14:39:04 +0000 (UTC)
Received: from krava (ovpn-204-186.brq.redhat.com [10.40.204.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 15FF677340;
        Wed,  8 Jan 2020 14:39:01 +0000 (UTC)
Date:   Wed, 8 Jan 2020 15:38:59 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Martin Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
Subject: Re: Re: [PATCH 1/5] bpf: Allow non struct type for btf ctx access
Message-ID: <20200108143859.GF387467@krava>
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-2-jolsa@kernel.org>
 <d7b8cecf-d28a-1f4d-eb2b-eb8a601b9914@fb.com>
 <20200107121319.GG290055@krava>
 <20200107155031.GB349285@krava>
 <c8ed83dc-3f3b-30d2-69fa-3a5c59152034@fb.com>
 <962209d7-cdfa-9ee3-8a12-6375091843cf@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <962209d7-cdfa-9ee3-8a12-6375091843cf@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 06:28:11PM +0000, Yonghong Song wrote:

SNIP

> >> index ed2075884724..650df4ed346e 100644
> >> --- a/kernel/bpf/btf.c
> >> +++ b/kernel/bpf/btf.c
> >> @@ -3633,7 +3633,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> >>    		    const struct bpf_prog *prog,
> >>    		    struct bpf_insn_access_aux *info)
> >>    {
> >> -	const struct btf_type *t = prog->aux->attach_func_proto;
> >> +	const struct btf_type *tp, *t = prog->aux->attach_func_proto;
> >>    	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
> >>    	struct btf *btf = bpf_prog_get_target_btf(prog);
> >>    	const char *tname = prog->aux->attach_func_name;
> >> @@ -3695,6 +3695,17 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> >>    		 */
> >>    		return true;
> >>    
> >> +	tp = btf_type_by_id(btf, t->type);
> >> +	/* skip modifiers */
> >> +	while (btf_type_is_modifier(tp))
> >> +		tp = btf_type_by_id(btf, tp->type);
> >> +
> >> +	if (btf_type_is_int(tp))
> >> +		/* This is a pointer scalar.
> >> +		 * It is the same as scalar from the verifier safety pov.
> >> +		 */
> >> +		return true;
> > 
> > This should work since:
> >      - the int pointer will be treated as a scalar later on
> >      - bpf_probe_read() will be used to read the contents
> > 
> > I am wondering whether we should add proper verifier support
> > to allow pointer to int ctx access. There, users do not need
> > to use bpf_probe_read() to dereference the pointer.
> > 
> > Discussed with Martin, maybe somewhere in check_ptr_to_btf_access(),
> > before btf_struct_access(), checking if it is a pointer to int/enum,
> > it should just allow and return SCALAR_VALUE.
> 
> double checked check_ptr_to_btf_access() and btf_struct_access().
> btf_struct_access() already returns SCALAR_VALUE for pointer to 
> int/enum. So verifier change is probably not needed.

ok, great

> 
> In your above code, could you do
>     btf_type_is_int(t) || btf_type_is_enum(t)
> which will cover pointer to enum as well?

sure, I'll include that

thanks,
jirka

