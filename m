Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBE3E1094B2
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 21:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKYUii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 15:38:38 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39596 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfKYUii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 15:38:38 -0500
Received: by mail-qk1-f196.google.com with SMTP id z65so9301995qka.6;
        Mon, 25 Nov 2019 12:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7wfCAOkAtI2dIwNtEg23RNa78x89DlDv0OXUGxtuOPc=;
        b=Liu/yiT/Dc5+N5ceLS3y87d5oEW2eHe+wrSYyUSwzmzmI5WseGHNuJ/iMamukX0u3r
         9jAB0B+5uzYqh9EkChkpbmETuYUdqtCy1FaIGcmcxd1F3vwHcDpmrF2FM8nCHa4790MP
         fVAB9z4tJbJbV2vNRQF9QkN5GJ9y6AkG6wptp+8ppZfrYiTglcYrZFHsnmpKszMZ7HjX
         VpeD24thWLaGIh/KvTH+qpnS//NlzoVsNYXV2n8HYQ8XB0oM9YW3EqNNmnf/zsrnP1L3
         RUK20/fltFOEB9OZgKaGewmD/QE9mQGl81GBpKYEsc1dRg7fhVp3nWlU9yTbyMeEQQfy
         V6Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7wfCAOkAtI2dIwNtEg23RNa78x89DlDv0OXUGxtuOPc=;
        b=f1XqPJz3La9d2Lh62YHDC9zrASfehFhNYNtk8hYm1dAPYctDuwcTJb9eZ+uOZMB9Sy
         Jhnn/8dCq4c3l5kjw/az98zi5HTIA85SXJIJk6OAyXHHLYEqcr1S+PG4fsd48efvsy2c
         kEfcvIYrGwDcp91+ADmzZq0KuwYB6VhVwpPXuEyvGRbHGsXHWIM36ftzsSDxSmHkphH3
         hwyirqROrSyjUFEkzHQNh8vJeSXjLcl1DhNGNqjvxzfcSPsxLaSp1ZmO8Qz3jGJP0gz0
         QJ1vcNn1t2/CF3mGsYu7VeAcOqv+ARmnEv3BWgltVmMvbzZhNGe/EeMA7jK1VUmvV6TN
         a3gg==
X-Gm-Message-State: APjAAAVUmCOTfOmuDeplYt/saZNqssfslTEU6UJyE2tvgUmlhLCxb2Bg
        oftJxm5WqqiwJa3qxfpbUcalkM11ODiCxXFXNeA=
X-Google-Smtp-Source: APXvYqzNlRnLkbuesinS8bGqEB08HKKYhmhwuUAIVl7UQxne7bt2cvgTUDb7pJSIPFkYP+yasL2xx95cvJnmJJt9nNQ=
X-Received: by 2002:a37:b3c4:: with SMTP id c187mr28755732qkf.36.1574714317134;
 Mon, 25 Nov 2019 12:38:37 -0800 (PST)
MIME-Version: 1.0
References: <20191123220835.1237773-1-andriin@fb.com> <5ddc3b355840f_2b082aba75a825b46@john-XPS-13-9370.notmuch>
In-Reply-To: <5ddc3b355840f_2b082aba75a825b46@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Nov 2019 12:38:26 -0800
Message-ID: <CAEf4Bzbii9W=Frc3aPLrLsCWq1fFJXADhhQ4w7_d15ucqBuWHg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] mm: implement no-MMU variant of vmalloc_user_node_flags
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 25, 2019 at 12:36 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > To fix build with !CONFIG_MMU, implement it for no-MMU configurations as well.
> >
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
> > Reported-by: kbuild test robot <lkp@intel.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  mm/nommu.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/nommu.c b/mm/nommu.c
> > index 99b7ec318824..7de592058ab4 100644
> > --- a/mm/nommu.c
> > +++ b/mm/nommu.c
> > @@ -155,11 +155,11 @@ void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags)
> >       return __vmalloc(size, flags, PAGE_KERNEL);
> >  }
> >
> > -void *vmalloc_user(unsigned long size)
> > +static void *__vmalloc_user_flags(unsigned long size, gfp_t flags)
> >  {
> >       void *ret;
> >
> > -     ret = __vmalloc(size, GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL);
> > +     ret = __vmalloc(size, flags, PAGE_KERNEL);
> >       if (ret) {
> >               struct vm_area_struct *vma;
> >
> > @@ -172,8 +172,19 @@ void *vmalloc_user(unsigned long size)
> >
> >       return ret;
> >  }
> > +
> > +void *vmalloc_user(unsigned long size)
> > +{
> > +     return __vmalloc_user_flags(size, GFP_KERNEL | __GFP_ZERO);
> > +}
> >  EXPORT_SYMBOL(vmalloc_user);
> >
> > +void *vmalloc_user_node_flags(unsigned long size, int node, gfp_t flags)
> > +{
> > +     return __vmalloc_user_flags(size, flags | __GFP_ZERO);
> > +}
> > +EXPORT_SYMBOL(vmalloc_user_node_flags);
> > +
>
> Hi Andrii, my first reaction was that it seemed not ideal to just ignore
> the node value like this but everything I came up with was uglier. I
> guess only user is BPF at the moment so it should be fine.

Yeah, but that's what other node-aware vmalloc() variants do in
nommu.c, so at least it's consistent with other cases. Thanks for
review!

>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
