Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A608D18AC41
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 06:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgCSFgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 01:36:11 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34129 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgCSFgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 01:36:11 -0400
Received: by mail-lf1-f68.google.com with SMTP id f3so600871lfc.1;
        Wed, 18 Mar 2020 22:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qIUO0hzIJLnhM3/d3IVA2vTbDbVTDn7s2q9RHhGWWzk=;
        b=JKgyRDDqHsyJru81fzR6JGLaS5tV27Y3hvzLOg+e+kRVDudFq6pWe3W95JqnGIqYoJ
         3uXUNNxJymLk+wh1uG4XGtruI+k30W3xIzOAcGg1fWZ9Nq3eZEmBXXJbK8s3juXJ88py
         SqBpp8GoJkOthyROyN3tKs1r9OiohA+4JFy7muyRasIaMGShUyKfuQErooqIp8NhHZM6
         9dGCkhvlJEzCc26udxLdcIDqs1iDQUh4PnZboba9NpuTePNwn9WajaaPQZDNt0S7iKRH
         rCeaxmm37SBaNsYB3cuKQELI+oEhHyVghIo0cmwqvV0McUvTuJarCwW0SN35q8HYHf+k
         3Lsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qIUO0hzIJLnhM3/d3IVA2vTbDbVTDn7s2q9RHhGWWzk=;
        b=Vqzx/xucqmb3md9F9s0zgyp2wztjkOKsEO6kGovDYD9dwbi+AOnrRDS7wQB1iepFt4
         DHriTfmxN/nEag+T4AeRaa3lQpHOE7l9jFa6tan/5L9Bl6LA3eygCzgrqSsNYuctQdZ7
         brnwRipkREld501EVGRaF2HRFsIwJhejI2Tv/+9pywPakhxNd6LxcYBHozyqEueImNw5
         3f5MX+oInZvVa4DOmKlmjPnOPjzYpBdcW4/4FqiDqfLJtduwDTiz8CYzHQh524TUwjW6
         QW8avB25k5noqhnijRwABGwMB4+Qu9I57zcXYV+ZidLJa7ujuK5PN3DFCMV+a5XKU/Pm
         gYhQ==
X-Gm-Message-State: ANhLgQ1u9/W8PvGTeyOrZHbN0vicWaUtu4UkWDAFcx7dBwdFIZEckzOS
        1TU+hS5fU3uo10sx7qDpJXkbg910NNQIsQMu0xI=
X-Google-Smtp-Source: ADFU+vvnztqsLBJbjkjoHTTm7baXcKYd7UsJqgu9uHhIkYfAizHxJ1tQSrgOsj5zGQ05rrB/G4RYgcvnT34n1YZeaGU=
X-Received: by 2002:a19:c748:: with SMTP id x69mr993743lff.196.1584596167869;
 Wed, 18 Mar 2020 22:36:07 -0700 (PDT)
MIME-Version: 1.0
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
 <158446619342.702578.1522482431365026926.stgit@firesoul> <87v9n2koqt.fsf@toke.dk>
 <20200318112539.6b595142@carbon>
In-Reply-To: <20200318112539.6b595142@carbon>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 18 Mar 2020 19:35:56 -1000
Message-ID: <CAADnVQK--Opu1hSfQhnzCkcE10AsyXrmJaD9hQoaeqZGAc2Djw@mail.gmail.com>
Subject: Re: [PATCH RFC v1 09/15] xdp: clear grow memory in bpf_xdp_adjust_tail()
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        sameehj@amazon.com, Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com, Daniel Borkmann <borkmann@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 12:25 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Wed, 18 Mar 2020 10:15:38 +0100
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>
> > Jesper Dangaard Brouer <brouer@redhat.com> writes:
> >
> > > To reviewers: Need some opinions if this is needed?
> > >
> > > (TODO: Squash patch)
> > > ---
> > >  net/core/filter.c |    6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index 0ceddee0c678..669f29992177 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -3432,6 +3432,12 @@ BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buf=
f *, xdp, int, offset)
> > >     if (unlikely(data_end < xdp->data + ETH_HLEN))
> > >             return -EINVAL;
> > >
> > > +   // XXX: To reviewers: How paranoid are we? Do we really need to
> > > +   /* clear memory area on grow, as in-theory can contain uninit kme=
m */
> > > +   if (offset > 0) {
> > > +           memset(xdp->data_end, 0, offset);
> > > +   }
> >
> > This memory will usually be recycled through page_pool or equivalent,
> > right? So couldn't we clear the pages when they are first allocated?
> > That way, the only data that would be left there would be packet data
> > from previous packets...
>
> Yes, that is another option, to clear pages on "real" alloc (not
> recycle alloc), but it is a bit harder to implement (when not using
> page_pool).
>
> And yes, this area will very likely just contain old packet data, but
> we cannot be 100% sure.
>
> Previously Alexei have argued that we should not leak pointer values in
> XDP.  Which is why we have xdp_scrub_frame(), but this is not 100% the
> same.  So, I would like to hear Alexei's opinion ?

those were the days when sw didn't need to worry about hw bugs.
Looks like these types of security issues are acceptable now, since
pointer leaks no longer get CVE assigned.
