Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D98DED0448
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 01:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfJHXmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 19:42:03 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44664 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfJHXmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 19:42:02 -0400
Received: by mail-qt1-f193.google.com with SMTP id u40so716959qth.11;
        Tue, 08 Oct 2019 16:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6HiVuuo2rZvDIOVhBACObN7eVlMYASXv5ByWnYJPHms=;
        b=Apk8SrN/aDgWVwvpPsca+YwWsR2qhEhxS2RFjArDN52HbeZCzq2bcrPhNByNhjA17K
         s4ygyBzYPVGO1uBbKemEhx0d4xQ1/ksmagvZohLmd9u1tatMONUkqm32FNOV+/oRgW1i
         77gN8OunkvYy/4qY1v3oWJqjJ/MVg0bJqqbLfXFfeVkLduw9YHq8wfWRE+HfCH2/QS0+
         z/4ga94LUHYT6CgWbmN2yASnbKHjcMKz6P6tK/TGIhbRcyVda2sAW94Km7u+6WwYNZ34
         tgkSEQt0UBqCdM3p1p+pwE+23btA3KZFDX6BCxOGU/shuZWQztF4EGW5CNkHKD2jftXW
         liBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6HiVuuo2rZvDIOVhBACObN7eVlMYASXv5ByWnYJPHms=;
        b=Yk3TscfGMFvW8I4iHefcW5MrU9OufRkrAtL0zMhPAnlTHgDZdKrN49p1pN07Pg9emO
         nmiXC4LPLT9n//B3/RebezBh/+U7aO/ODhsgnq70KO1al5cZyosnOOanDRd4MMtGBgT1
         MRZBNa8c/Qdzzhh/RMrL/hETMZi80/P+rYfVioA5FSter00gXtTD0y2NdaDPHiX831At
         ySDk4BW1aBsxMWX0RwzrcdlR31bfswe1vL9yZ8lYy+lNGhjqis/eNOy2qgKOsrcsV6um
         AawpY45f7wwemOJTJya2RLlgUCLrZeFa1FGRai2U8Vo/3FDxay5iS8AiCPE7EwSuzO/w
         ZnrQ==
X-Gm-Message-State: APjAAAXF8sGhG3KZ+xOGNX65AY5PzxjqZaUlXLjsXR/FskuNTZFazoRI
        VdOCDxYVoY7/C1ScRyAkT/8gUYy5YGEzd85iVV8=
X-Google-Smtp-Source: APXvYqzoVqrm6m26F8VOzUBLXy/bvK5WFaruQMtVBkbo+3Re9cR0zVkVziTEMvFcuYFcfII3tsUppcacGxkxD3ysxs4=
X-Received: by 2002:ac8:1c34:: with SMTP id a49mr580016qtk.59.1570578121660;
 Tue, 08 Oct 2019 16:42:01 -0700 (PDT)
MIME-Version: 1.0
References: <20191008194548.2344473-1-andriin@fb.com> <20191008194548.2344473-2-andriin@fb.com>
 <20191008212945.GG27307@pc-66.home>
In-Reply-To: <20191008212945.GG27307@pc-66.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Oct 2019 16:41:50 -0700
Message-ID: <CAEf4BzbeW-H1geNZ1EBvQrfhaG-FkWKNouLen3YCNEXzKEE4dg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: track contents of read-only maps as scalars
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 8, 2019 at 2:29 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Tue, Oct 08, 2019 at 12:45:47PM -0700, Andrii Nakryiko wrote:
> > Maps that are read-only both from BPF program side and user space side
> > have their contents constant, so verifier can track referenced values
> > precisely and use that knowledge for dead code elimination, branch
> > pruning, etc. This patch teaches BPF verifier how to do this.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  kernel/bpf/verifier.c | 58 +++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 56 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index ffc3e53f5300..1e4e4bd64ca5 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -2739,6 +2739,42 @@ static void coerce_reg_to_size(struct bpf_reg_state *reg, int size)
> >       reg->smax_value = reg->umax_value;
> >  }
> >
> > +static bool bpf_map_is_rdonly(const struct bpf_map *map)
> > +{
> > +     return (map->map_flags & BPF_F_RDONLY_PROG) &&
> > +            ((map->map_flags & BPF_F_RDONLY) || map->frozen);
>
> This is definitely buggy. Testing for 'map->map_flags & BPF_F_RDONLY'
> to assume it's RO from user space side is not correct as it's just
> related to the current fd, but not the map itself. So the second part
> definitely /must/ only be: && map->frozen

Yep, you are right, map->frozen and BPF_F_RDONLY_PROG only.

>
> Thanks,
> Daniel
