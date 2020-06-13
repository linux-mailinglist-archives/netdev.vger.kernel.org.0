Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9031F8017
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 03:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgFMBDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 21:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgFMBDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 21:03:16 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D93DC03E96F
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 18:03:16 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id dp10so5216871qvb.10
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 18:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uWvi7+6qg8050KnLcF7RqqwsSRkHb7fXq+P8wk9d2x4=;
        b=dXeqj+POezAcqsggGCMnvtUHFdTR71mDcabIgl3rJ2mVPchK0zVYtPp11m9wuc/Ag+
         q04BUm0JH93+GwsRMvY3I5XTj9janG2a0A6uy+9MJHVxfsiqy8/KPFVOGGUgtDXBdr+F
         Df3p6mHPtvAizrLnhYbVshvVMowwH/wQkgd4ceRDztG13SW4+uFxjxeVRc4UEmTijUlk
         2HI8vdPDRfpyXq9pOfQZeNY8U69Xt33P1YhOQyK04Lxw5VRatcAQSXb1McNCI4hrJwd9
         Zmd/Xl6rEYKfcY2XYP6BPaVKtO6oMwmGrQDoW60uaaaLkYdqiTraFtfRqCeieUQsEXsK
         rRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uWvi7+6qg8050KnLcF7RqqwsSRkHb7fXq+P8wk9d2x4=;
        b=KGgjZMSv4piFsYtt2NHAhAi6K6eGU9pP2buxHMQXk7gI91Bkz93U5syi3pMb67PMh/
         LZoxuWEoPeYvIHtbaY9uNshG9t4UYheVoo8IMsgZQXbpBdppjhhDfdTyYuP915sL83Wy
         VRgj7c/zUdxLChR+VgaUC51cLB5GwypCgYwczERcUvuIpwADdt8v7gU8UxSpYmd+BA9D
         /techN0Pilqw76ovg26A1oc5FTIcJg5fzq+nhdq+HCS9j8UmlRn7IyO8kefoTJSBt6SM
         ZiZzLq9jPygKW2OEa25+ZEHK/QbBOxUsOSoYJAdt4yEhHRD/ZgCjH6J9giAyFeyfCW0o
         NXiQ==
X-Gm-Message-State: AOAM533dQnPrbCC+YS5DXXlleI5c52O6Rk7AaQE0AGn+IKjCXlGlcbKC
        HU0bptmiDrMxfGShP0XM0pDQicU/m8qzFMXIJQhjUA==
X-Google-Smtp-Source: ABdhPJyU8I0/Bty6HNJsK/KEz5WXvQdFWli3DpOJ4ABCfmIEG0q1glpzaUwpyoMb58JU9fgMbUZKfe62oxVqiGaDuto=
X-Received: by 2002:a0c:d444:: with SMTP id r4mr15090129qvh.67.1592010194225;
 Fri, 12 Jun 2020 18:03:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200608182748.6998-1-sdf@google.com> <20200613003356.sqp6zn3lnh4qeqyl@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200613003356.sqp6zn3lnh4qeqyl@ast-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 12 Jun 2020 18:03:03 -0700
Message-ID: <CAKH8qBuJpks_ny-8MDzzZ5axobn=35P3krVbyz2mtBBtR8Uv+A@mail.gmail.com>
Subject: Re: [PATCH bpf v3 1/2] bpf: don't return EINVAL from {get,set}sockopt
 when optlen > PAGE_SIZE
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 5:34 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jun 08, 2020 at 11:27:47AM -0700, Stanislav Fomichev wrote:
> > Attaching to these hooks can break iptables because its optval is
> > usually quite big, or at least bigger than the current PAGE_SIZE limit.
> > David also mentioned some SCTP options can be big (around 256k).
> >
> > There are two possible ways to fix it:
> > 1. Increase the limit to match iptables max optval. There is, however,
> >    no clear upper limit. Technically, iptables can accept up to
> >    512M of data (not sure how practical it is though).
> >
> > 2. Bypass the value (don't expose to BPF) if it's too big and trigger
> >    BPF only with level/optname so BPF can still decide whether
> >    to allow/deny big sockopts.
> >
> > The initial attempt was implemented using strategy #1. Due to
> > listed shortcomings, let's switch to strategy #2. When there is
> > legitimate a real use-case for iptables/SCTP, we can consider increasing
> > the PAGE_SIZE limit.
> >
> > v3:
> > * don't increase the limit, bypass the argument
> >
> > v2:
> > * proper comments formatting (Jakub Kicinski)
> >
> > Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> > Cc: David Laight <David.Laight@ACULAB.COM>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  kernel/bpf/cgroup.c | 18 ++++++++++++++----
> >  1 file changed, 14 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index fdf7836750a3..758082853086 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -1276,9 +1276,18 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
> >
> >  static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
> >  {
> > -     if (unlikely(max_optlen > PAGE_SIZE) || max_optlen < 0)
> > +     if (unlikely(max_optlen < 0))
> >               return -EINVAL;
> >
> > +     if (unlikely(max_optlen > PAGE_SIZE)) {
> > +             /* We don't expose optvals that are greater than PAGE_SIZE
> > +              * to the BPF program.
> > +              */
> > +             ctx->optval = NULL;
> > +             ctx->optval_end = NULL;
> > +             return 0;
> > +     }
>
> It's probably ok, but makes me uneasy about verifier consequences.
> ctx->optval is PTR_TO_PACKET and it's a valid pointer from verifier pov.
> Do we have cases already where PTR_TO_PACKET == PTR_TO_PACKET_END ?
> I don't think we have such tests. I guess bpf prog won't be able to read
> anything and nothing will crash, but having PTR_TO_PACKET that is
> actually NULL would be an odd special case to keep in mind for everyone
> who will work on the verifier from now on.
>
> Also consider bpf prog that simply reads something small like 4 bytes.
> IP_FREEBIND sockopt (like your selftest in the patch 2) will have
> those 4 bytes, so it's natural for the prog to assume that it can read it.
> It will have
> p = ctx->optval;
> if (p + 4 > ctx->optval_end)
>  /* goto out and don't bother logging, since that never happens */
> *(u32*)p;
>
> but 'clever' user space would pass long optlen and prog suddenly
> 'not seeing' the sockopt. It didn't crash, but debugging would be
> surprising.
>
> I feel it's better to copy the first 4k and let the program see it.
Agreed with the IP_FREEBIND example wrt observability, however it's
not clear what to do with the cropped buffer if the bpf program
modifies it.

Consider that huge iptables setsockopts where the usespace passes
PAGE_SIZE*10 optlen with real data and bpf prog sees only part of it.
Now, if the bpf program modifies the buffer (say, flips some byte), we
are back to square one. We either have to silently discard that buffer
or reallocate/merge. My reasoning with data == NULL, is that at least
there is a clear signal that the program can't access the data (and
can look at optlen to see if the original buffer is indeed non-zero
and maybe deny such requests?).
At this point I'm really starting to think that maybe we should just
vmalloc everything that is >PAGE_SIZE and add a sysclt to limit an
upper bound :-/
I'll try to think about this a bit more over the weekend.
