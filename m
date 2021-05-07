Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C303761BD
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236016AbhEGIOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:14:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235498AbhEGIOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 04:14:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620375202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T0d4hOYJJ2KsxgrDpZv9ZxzDfxdUKbxXUPpS8SZAfUg=;
        b=cFLZI37E5ZVRQquLGA834D1+HSR6RwrzTXeLpZMf/uf70M94wTZ/CdeWpSgZu11j9kEyPl
        e8BaPpd+ko6RNmboZukJSEk6DPO+Lu1ndrtv3i7xfAg8cDLvUIhw8SiTZtNUED+FlA829k
        7g7WfN1PiInfTmjjIjYLdMJSW+mEHFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-XUGdYxIWPnW_gUR-Efp8Hw-1; Fri, 07 May 2021 04:13:18 -0400
X-MC-Unique: XUGdYxIWPnW_gUR-Efp8Hw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44E8618982A4;
        Fri,  7 May 2021 08:13:16 +0000 (UTC)
Received: from krava (unknown [10.40.194.249])
        by smtp.corp.redhat.com (Postfix) with SMTP id C188A5D745;
        Fri,  7 May 2021 08:13:13 +0000 (UTC)
Date:   Fri, 7 May 2021 10:13:09 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH] bpf: Forbid trampoline attach for functions with
 variable arguments
Message-ID: <YJT2lbKUCRo90MQV@krava>
References: <20210505132529.401047-1-jolsa@kernel.org>
 <CAEf4BzazQgrPVqKOGP8z=MPZhjZHCZDdcWQB0xBuudXbxXwaXg@mail.gmail.com>
 <c21b54a6-8d6e-f76d-e6c1-95abd8544d9d@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c21b54a6-8d6e-f76d-e6c1-95abd8544d9d@iogearbox.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 07, 2021 at 01:31:54AM +0200, Daniel Borkmann wrote:
> On 5/5/21 8:45 PM, Andrii Nakryiko wrote:
> > On Wed, May 5, 2021 at 6:42 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > 
> > > We can't currently allow to attach functions with variable arguments.
> > > The problem is that we should save all the registers for arguments,
> > > which is probably doable, but if caller uses more than 6 arguments,
> > > we need stack data, which will be wrong, because of the extra stack
> > > frame we do in bpf trampoline, so we could crash.
> > > 
> > > Also currently there's malformed trampoline code generated for such
> > > functions at the moment as described in:
> > >    https://lore.kernel.org/bpf/20210429212834.82621-1-jolsa@kernel.org/
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > 
> > LGTM.
> > 
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > 
> > >   kernel/bpf/btf.c | 13 +++++++++++++
> > >   1 file changed, 13 insertions(+)
> > > 
> > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > index 0600ed325fa0..161511bb3e51 100644
> > > --- a/kernel/bpf/btf.c
> > > +++ b/kernel/bpf/btf.c
> > > @@ -5206,6 +5206,13 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
> > >          m->ret_size = ret;
> > > 
> > >          for (i = 0; i < nargs; i++) {
> > > +               if (i == nargs - 1 && args[i].type == 0) {
> > > +                       bpf_log(log,
> > > +                               "The function %s with variable args is unsupported.\n",
> > > +                               tname);
> > > +                       return -EINVAL;
> > > +
> 
> (Jiri, fyi, I removed this extra newline while applying. Please scan for such
> things before submitting.)

sorry, will do

jirka

