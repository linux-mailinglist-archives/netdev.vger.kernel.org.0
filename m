Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF6C35F1D5
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 13:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbhDNLCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 07:02:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35895 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235355AbhDNLBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 07:01:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618398094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0gFg/Ogt8TyIcva+R8+ipOzwiflVs6gLc+fuZSdSw3U=;
        b=DwMZNlQbt89DcC/gGPIhibzEm6hdxWHk2XrFFL8H032q3UXgsJlz9ny/UAjgXOxe8RMJs+
        AIU03t5kUHTCRIMnweqAkKDdlijR5bXDVR+Fc3jOQedqeLWf96vIKJ9cN/z95j3cL1FKWS
        KMcbCp+e3Ms1kn864fhu6HAK9FJ2IfQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-gn4_252DML2TR_mudGNHvQ-1; Wed, 14 Apr 2021 07:01:29 -0400
X-MC-Unique: gn4_252DML2TR_mudGNHvQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 159C35F9FB;
        Wed, 14 Apr 2021 11:01:28 +0000 (UTC)
Received: from krava (unknown [10.40.196.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 145A3610F3;
        Wed, 14 Apr 2021 11:01:12 +0000 (UTC)
Date:   Wed, 14 Apr 2021 13:01:12 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        kernel test robot <lkp@intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCHv4 bpf-next 1/5] bpf: Allow trampoline re-attach for
 tracing and lsm programs
Message-ID: <YHbLeFtUx31iACx+@krava>
References: <20210412162502.1417018-1-jolsa@kernel.org>
 <20210412162502.1417018-2-jolsa@kernel.org>
 <CAEf4BzbbVDCuAyCPYAdc363T6uAC6QDOwqNzFOHZPrHSbnRYCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzbbVDCuAyCPYAdc363T6uAC6QDOwqNzFOHZPrHSbnRYCA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 03:03:27PM -0700, Andrii Nakryiko wrote:
> On Mon, Apr 12, 2021 at 9:28 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Currently we don't allow re-attaching of trampolines. Once
> > it's detached, it can't be re-attach even when the program
> > is still loaded.
> >
> > Adding the possibility to re-attach the loaded tracing and
> > lsm programs.
> >
> > Fixing missing unlock with proper cleanup goto jump reported
> > by Julia.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> > Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/bpf/syscall.c    | 23 +++++++++++++++++------
> >  kernel/bpf/trampoline.c |  2 +-
> >  2 files changed, 18 insertions(+), 7 deletions(-)
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 6428634da57e..f02c6a871b4f 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -2645,14 +2645,25 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
> >          *   target_btf_id using the link_create API.
> >          *
> >          * - if tgt_prog == NULL when this function was called using the old
> > -         *   raw_tracepoint_open API, and we need a target from prog->aux
> > -         *
> > -         * The combination of no saved target in prog->aux, and no target
> > -         * specified on load is illegal, and we reject that here.
> > +        *   raw_tracepoint_open API, and we need a target from prog->aux
> > +        *
> > +        * - if prog->aux->dst_trampoline and tgt_prog is NULL, the program
> > +        *   was detached and is going for re-attachment.
> >          */
> >         if (!prog->aux->dst_trampoline && !tgt_prog) {
> > -               err = -ENOENT;
> > -               goto out_unlock;
> > +               /*
> > +                * Allow re-attach for TRACING and LSM programs. If it's
> > +                * currently linked, bpf_trampoline_link_prog will fail.
> > +                * EXT programs need to specify tgt_prog_fd, so they
> > +                * re-attach in separate code path.
> > +                */
> > +               if (prog->type != BPF_PROG_TYPE_TRACING &&
> > +                   prog->type != BPF_PROG_TYPE_LSM) {
> > +                       err = -EINVAL;
> > +                       goto out_unlock;
> > +               }
> > +               btf_id = prog->aux->attach_btf_id;
> > +               key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf, btf_id);
> >         }
> >
> >         if (!prog->aux->dst_trampoline ||
> > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > index 1f3a4be4b175..48b8b9916aa2 100644
> > --- a/kernel/bpf/trampoline.c
> > +++ b/kernel/bpf/trampoline.c
> > @@ -437,7 +437,7 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
> >                 tr->extension_prog = NULL;
> >                 goto out;
> >         }
> > -       hlist_del(&prog->aux->tramp_hlist);
> > +       hlist_del_init(&prog->aux->tramp_hlist);
> 
> there is another hlist_del few lines above in error handling path of
> bpf_trampoline_link_prog(), it should probably be also updated to
> hlist_del_init(), no?

ugh, that one is missing.. will fix

thanks,
jirka

> 
> >         tr->progs_cnt[kind]--;
> >         err = bpf_trampoline_update(tr);
> >  out:
> > --
> > 2.30.2
> >
> 

