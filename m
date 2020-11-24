Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1AD92C1F21
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 08:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730041AbgKXHuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 02:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbgKXHuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 02:50:06 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD2FC0613CF;
        Mon, 23 Nov 2020 23:50:06 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id w5so18406134ybj.11;
        Mon, 23 Nov 2020 23:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MCr9yurgtDaUMxiJ7mKazCnLV7ap7nqWiu58RHAmVXo=;
        b=n0ZrSFvEhkTdK67AHyeDFOfteccD81MLY1pAIi9xWhMfZr/qzK7RSsCgk3/64FxpPb
         lGUSK9cbACu01OVqDTK+bixulzFDQzMESUevN8RvWpNXSvukq5KCtLL4awnB35pBRTBd
         oekBo6Vm9wcJscdKRuTMAvjsJr7jWcd2PtuMpvck6HBuO1ZM2P5HmYeldAFYgfxZ2A51
         rggEt0eJE6p4lywtol2/ozGFprg54MM8FQOglp7jz7NIRs0NskfJFguOzmw03gbOAbWw
         ZFjHYJDWQAiapJg287MK6aWQM80F8AHkMnCaV12YZhD7FE+9tsXWhvGKxH1cBEjtmaos
         RXGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MCr9yurgtDaUMxiJ7mKazCnLV7ap7nqWiu58RHAmVXo=;
        b=IuEUaVvz5Z7BnujDZoI17jSWEtwLj1THqq77FAg0awfAxdIlrK7+EM/TfJmnfWpLGy
         tlgImZ5HhWwKE0GVsRROd7fDQNeXbREDyGDeNVf7ss7feEuUdokPXjAvbkY7qQ27AwR1
         j3gsMHlbsqkOwwj3jNFHQNuIHVfYy4m5ZdZ3fK7hRjmYv87U2iDKmC22Vt0uVnkZ9gqU
         xL30vAiz6K2wk3e+nnsXBGqZrX+qXhVecSRTNjr94BDAUAjUO/LbKAt/Zu2qBrFKMi57
         YHeS0Wsd0ihxsEWbOrdpB59jTWavcjB2kt+lC9FGPaz38V0ekN63NzIUzyZH/5N5rL/v
         cf/Q==
X-Gm-Message-State: AOAM531stn4q98oPhomWm2CIyI5UutCfnVrEuDRzkf0cB+Xzl5qvaEk6
        UgHg41oC2D/m4Jd6IDyIwAOC9J6A59GBFnpicsO1wXm5TVc=
X-Google-Smtp-Source: ABdhPJx34S4tI2/pz6jPfz2xAj+di1kmGKUBFtkiuqP/9HJ3DpPG5JxcoTyId50E88zowAm6tiwSTqNC0GpGANq5uNQ=
X-Received: by 2002:a25:df82:: with SMTP id w124mr4702486ybg.347.1606204205135;
 Mon, 23 Nov 2020 23:50:05 -0800 (PST)
MIME-Version: 1.0
References: <20201119232244.2776720-1-andrii@kernel.org> <20201119232244.2776720-2-andrii@kernel.org>
 <20201124054924.i7zq7vig4xqmddyr@ast-mbp>
In-Reply-To: <20201124054924.i7zq7vig4xqmddyr@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Nov 2020 23:49:54 -0800
Message-ID: <CAEf4BzbjgSv2u+rZs-97PkeXwtKdcvkAdTG=nrX9DNus0ufOPg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: fix bpf_put_raw_tracepoint()'s use of __module_address()
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 9:49 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Nov 19, 2020 at 03:22:39PM -0800, Andrii Nakryiko wrote:
> > __module_address() needs to be called with preemption disabled or with
> > module_mutex taken. preempt_disable() is enough for read-only uses, which is
> > what this fix does.
> >
> > Fixes: a38d1107f937 ("bpf: support raw tracepoints in modules")
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >  kernel/trace/bpf_trace.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index d255bc9b2bfa..bb98a377050a 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -2060,7 +2060,11 @@ struct bpf_raw_event_map *bpf_get_raw_tracepoint(const char *name)
> >
> >  void bpf_put_raw_tracepoint(struct bpf_raw_event_map *btp)
> >  {
> > -     struct module *mod = __module_address((unsigned long)btp);
> > +     struct module *mod;
> > +
> > +     preempt_disable();
> > +     mod = __module_address((unsigned long)btp);
> > +     preempt_enable();
> >
> >       if (mod)
> >               module_put(mod);
>
> I don't understand why 'mod' cannot become dangling pointer after preempt_enable().
> Either it needs a comment explaining why it's ok or module_put() should
> be in preempt disabled section.

Yeah, I think it can, assuming the kernel module can be unloaded
despite non-zero refcnt (probably happens with force unload?). I'll
drop the `if (mod)` part (module_put() checks that internally) and
will move module_put(mod) inside the preempt disable/enable region.
