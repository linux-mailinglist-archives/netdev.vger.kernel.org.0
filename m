Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E771325C8
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 13:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgAGMNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 07:13:31 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52163 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727658AbgAGMNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 07:13:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578399209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p79nq6vqi8QKCKrej5dVH0gLP+kIy2lKHUxy/NSpyLY=;
        b=Eith7RIaS+E0zgyQeacexRkdNWX4NNBAGqyty/Q2Kw79WTzXpQmWn496p6GOqDlZGTBfPO
        X3GdJ57FeloJJ/euz3hShZ69Ha6N0bmhT47KFQWPffUllKGcEKfOw6U7+8RQXqGakjOyEH
        pA7DmFLYpr+7OqVmeiwk5CwSDLKsGgk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-5_szLPtzMFuV9QjQP39XKA-1; Tue, 07 Jan 2020 07:13:25 -0500
X-MC-Unique: 5_szLPtzMFuV9QjQP39XKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBD5618557C4;
        Tue,  7 Jan 2020 12:13:23 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B51DB7FB53;
        Tue,  7 Jan 2020 12:13:21 +0000 (UTC)
Date:   Tue, 7 Jan 2020 13:13:19 +0100
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
Message-ID: <20200107121319.GG290055@krava>
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-2-jolsa@kernel.org>
 <d7b8cecf-d28a-1f4d-eb2b-eb8a601b9914@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7b8cecf-d28a-1f4d-eb2b-eb8a601b9914@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 06, 2020 at 09:36:17PM +0000, Yonghong Song wrote:
> 
> 
> On 12/29/19 6:37 AM, Jiri Olsa wrote:
> > I'm not sure why the restriction was added,
> > but I can't access pointers to POD types like
> > const char * when probing vfs_read function.
> > 
> > Removing the check and allow non struct type
> > access in context.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   kernel/bpf/btf.c | 6 ------
> >   1 file changed, 6 deletions(-)
> > 
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index ed2075884724..ae90f60ac1b8 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -3712,12 +3712,6 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> >   	/* skip modifiers */
> >   	while (btf_type_is_modifier(t))
> >   		t = btf_type_by_id(btf, t->type);
> > -	if (!btf_type_is_struct(t)) {
> > -		bpf_log(log,
> > -			"func '%s' arg%d type %s is not a struct\n",
> > -			tname, arg, btf_kind_str[BTF_INFO_KIND(t->info)]);
> > -		return false;
> > -	}
> 
> Hi, Jiri, the RFC looks great! Especially, you also referenced this will
> give great performance boost for bcc scripts.
> 
> Could you provide more context on why the above change is needed?
> The function btf_ctx_access is used to check validity of accessing
> function parameters which are wrapped inside a structure, I am wondering
> what kinds of accesses you tried to address here.

when I was transforming opensnoop.py to use this I got fail in
there when I tried to access filename arg in do_sys_open

but actualy it seems this should get recognized earlier by:

          if (btf_type_is_int(t))
                /* accessing a scalar */
                return true;

I'm not sure why it did not pass for const char*, I'll check

jirka

