Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE1E23FECC
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 16:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgHIOrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 10:47:18 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44221 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726199AbgHIOrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 10:47:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596984437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gKK414gvYPxO64jiz+P/8qj08kR5l/OAlU0hgufW1/c=;
        b=irFd1tVEYIGOHe0dg/P1yfLgaSTl1hI5HfHHNgm2+zbR/X2Yo8yOXtUuiEX/Wac2PcttVV
        hh2uZSXygrMf05XNoT4CqvuoXIb6skJoVboIeIJrGqCjjHkYZTZjGKWclplL/IzXUu5YyC
        oAKjwP0IyuRQKTKdszTEiWMcrCf4vXo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-PPsk5wR5Mw2jNQC81EhACQ-1; Sun, 09 Aug 2020 10:47:13 -0400
X-MC-Unique: PPsk5wR5Mw2jNQC81EhACQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EC768015CE;
        Sun,  9 Aug 2020 14:47:11 +0000 (UTC)
Received: from krava (unknown [10.40.192.79])
        by smtp.corp.redhat.com (Postfix) with SMTP id B150C6179B;
        Sun,  9 Aug 2020 14:47:07 +0000 (UTC)
Date:   Sun, 9 Aug 2020 16:47:06 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v10 bpf-next 08/14] bpf: Add btf_struct_ids_match function
Message-ID: <20200809144706.GD619980@krava>
References: <20200807094559.571260-1-jolsa@kernel.org>
 <20200807094559.571260-9-jolsa@kernel.org>
 <CAEf4BzY8vE8k9c5fBB+3mcEpxOWc38dWBK8ji2aRpHM79nra_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY8vE8k9c5fBB+3mcEpxOWc38dWBK8ji2aRpHM79nra_Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 07, 2020 at 01:04:26PM -0700, Andrii Nakryiko wrote:

SNIP

> > +                               }
> >                         }
> >                 } else if (!fn->check_btf_id(reg->btf_id, arg)) {
> 
> Put this on a wishlist for now. I don't think we should expect
> fb->check_btf_id() to do btf_struct_ids_match() internally, so to
> support this, we'd have to call fb->check_btf_id() inside the loop
> while doing WALK_STRUCT struct. But let's not change all this in this
> patch set, it's involved enough already.
> 
> >                         verbose(env, "Helper does not support %s in R%d\n",
> > @@ -3977,7 +3982,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
> >
> >                         return -EACCES;
> >                 }
> > -               if (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off) {
> > +               if (!ids_match &&
> > +                   (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off)) {
> 
> Isn't this still wrong? if ids_match, but reg->var_off is non-zero,
> that's still bad, right?
> ids_match just "mitigates" reg->off check, so should be something like this:
> 
> if ((reg->off && !ids_match) || !tnum_is_const(reg->var_off) ||
> reg->var_off.value)
>  ... then bad ...

damn you're right, those are separated things,
I mixed it up, I'll send new version

thanks,
jirka

