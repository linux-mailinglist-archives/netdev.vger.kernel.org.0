Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B0235428E
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 16:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237544AbhDEOGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 10:06:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26260 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235903AbhDEOGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 10:06:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617631605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aN1fi47EGlDgwe9o6GywTFTS7+FOcVXASndg2JLaDnA=;
        b=O7yyLq/HJPY8RiCYxXEmiZqKIxLnhFq319dYpC/4P6vFsfkeqZG30XG20Of5mAy0qsNsTc
        ShbP3jgppefTiRJynbBoJehqJ7Jq3s4lLhtAAOubgXqkOQtySrQdNGBUXWtilgvRDvZmp5
        2xlMFP2fL1mAX0JtMsPR3ZgR+N1KQOk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-WztmHwGgNSup-j8N3JJQHA-1; Mon, 05 Apr 2021 10:06:44 -0400
X-MC-Unique: WztmHwGgNSup-j8N3JJQHA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7406F81621;
        Mon,  5 Apr 2021 14:06:42 +0000 (UTC)
Received: from krava (unknown [10.40.192.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDAB15D9C6;
        Mon,  5 Apr 2021 14:06:36 +0000 (UTC)
Date:   Mon, 5 Apr 2021 16:06:35 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC PATCH bpf-next 1/4] bpf: Allow trampoline re-attach
Message-ID: <YGsZa1fT/Sbff9rB@krava>
References: <20210328112629.339266-1-jolsa@kernel.org>
 <20210328112629.339266-2-jolsa@kernel.org>
 <87blavd31f.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87blavd31f.fsf@toke.dk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 01:24:12PM +0200, Toke Høiland-Jørgensen wrote:
> Jiri Olsa <jolsa@kernel.org> writes:
> 
> > Currently we don't allow re-attaching of trampolines. Once
> > it's detached, it can't be re-attach even when the program
> > is still loaded.
> >
> > Adding the possibility to re-attach the loaded tracing
> > kernel program.
> 
> Hmm, yeah, didn't really consider this case when I added the original
> disallow. But don't see why not, so (with one nit below):
> 
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/bpf/syscall.c    | 25 +++++++++++++++++++------
> >  kernel/bpf/trampoline.c |  2 +-
> >  2 files changed, 20 insertions(+), 7 deletions(-)
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 9603de81811a..e14926b2e95a 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -2645,14 +2645,27 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
> >  	 *   target_btf_id using the link_create API.
> >  	 *
> >  	 * - if tgt_prog == NULL when this function was called using the old
> > -         *   raw_tracepoint_open API, and we need a target from prog->aux
> > -         *
> > -         * The combination of no saved target in prog->aux, and no target
> > -         * specified on load is illegal, and we reject that here.
> > +	 *   raw_tracepoint_open API, and we need a target from prog->aux
> > +	 *
> > +	 * The combination of no saved target in prog->aux, and no target
> > +	 * specified on is legal only for tracing programs re-attach, rest
> > +	 * is illegal, and we reject that here.
> >  	 */
> >  	if (!prog->aux->dst_trampoline && !tgt_prog) {
> > -		err = -ENOENT;
> > -		goto out_unlock;
> > +		/*
> > +		 * Allow re-attach for tracing programs, if it's currently
> > +		 * linked, bpf_trampoline_link_prog will fail.
> > +		 */
> > +		if (prog->type != BPF_PROG_TYPE_TRACING) {
> > +			err = -ENOENT;
> > +			goto out_unlock;
> > +		}
> > +		if (!prog->aux->attach_btf) {
> > +			err = -EINVAL;
> > +			goto out_unlock;
> > +		}
> 
> I'm wondering about the two different return codes here. Under what
> circumstances will aux->attach_btf be NULL, and why is that not an
> ENOENT error? :)

right, that should be always there.. I'll remove it

thanks,
jirka

