Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620B3274886
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 20:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgIVSsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 14:48:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41892 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726563AbgIVSsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 14:48:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600800485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NStKfvdSaDzipTmnacc6wA+r35m8vaKo0v9bRG+6Mb0=;
        b=dqSDrSYZjZS3ZJYL95/ms/RU66eWvxjnnv+depVjYRxIV9wXd4UXJFko4M6X8vl2OdPkAM
        NqETNgQrU4bIDwDDrZAesSsTTCt+tJ4/4gZqKqsgcnBaMD+0+xV/h/yKMN7vmfwXf+xloG
        3/4U0Ht0R41rxRaNLNZ4Ms1xcwSd3yY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-cqOZFRcdMu-77F9_GdmAhQ-1; Tue, 22 Sep 2020 14:48:01 -0400
X-MC-Unique: cqOZFRcdMu-77F9_GdmAhQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8539A6408B;
        Tue, 22 Sep 2020 18:47:59 +0000 (UTC)
Received: from krava (ovpn-112-28.ams2.redhat.com [10.36.112.28])
        by smtp.corp.redhat.com (Postfix) with SMTP id DC43A60BF4;
        Tue, 22 Sep 2020 18:47:56 +0000 (UTC)
Date:   Tue, 22 Sep 2020 20:47:55 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Use --no-fail option if CONFIG_BPF is
 not enabled
Message-ID: <20200922184755.GD2718767@krava>
References: <20200918122654.2625699-1-jolsa@kernel.org>
 <CAEf4BzZc6DE85wUTGwE=2FKPuwuuH4480Fh+v63q8J=PRxjgEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZc6DE85wUTGwE=2FKPuwuuH4480Fh+v63q8J=PRxjgEw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 02:55:27PM -0700, Andrii Nakryiko wrote:
> On Fri, Sep 18, 2020 at 5:30 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Currently all the resolve_btfids 'users' are under CONFIG_BPF
> > code, so if we have CONFIG_BPF disabled, resolve_btfids will
> > fail, because there's no data to resolve.
> >
> > In case CONFIG_BPF is disabled, using resolve_btfids --no-fail
> > option, that makes resolve_btfids leave quietly if there's no
> > data to resolve.
> >
> > Fixes: c9a0f3b85e09 ("bpf: Resolve BTF IDs in vmlinux image")
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> If no CONFIG_BTF is specified, there is no need to even run
> resolve_btfids. So why not do just that -- run resolve_btfids only
> if both CONFIG_BPF and CONFIG_DEBUG_INFO_BTF are specified?

we can have CONFIG_DEBUG_INFO_BTF without CONFIG_BPF being enabled,
so we could in theory have in future some BTF ID user outside bpf code,
but I guess we can enable that, when it actually happens

jirka

> 
> 
> >  scripts/link-vmlinux.sh | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > index e6e2d9e5ff48..3173b8cf08cb 100755
> > --- a/scripts/link-vmlinux.sh
> > +++ b/scripts/link-vmlinux.sh
> > @@ -342,8 +342,13 @@ vmlinux_link vmlinux "${kallsymso}" ${btf_vmlinux_bin_o}
> >
> >  # fill in BTF IDs
> >  if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
> > -info BTFIDS vmlinux
> > -${RESOLVE_BTFIDS} vmlinux
> > +       info BTFIDS vmlinux
> > +       # Let's be more permissive if CONFIG_BPF is disabled
> > +       # and do not fail if there's no data to resolve.
> > +       if [ -z "${CONFIG_BPF}" ]; then
> > +         no_fail=--no-fail
> > +       fi
> > +       ${RESOLVE_BTFIDS} $no_fail vmlinux
> >  fi
> >
> >  if [ -n "${CONFIG_BUILDTIME_TABLE_SORT}" ]; then
> > --
> > 2.26.2
> >
> 

