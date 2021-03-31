Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDB934F962
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 09:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbhCaHDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 03:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233693AbhCaHC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 03:02:58 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E61C061574;
        Wed, 31 Mar 2021 00:02:58 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id i144so20120257ybg.1;
        Wed, 31 Mar 2021 00:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D0KyMxRH/MSdDpCqeXLz794JFymGnRXmUM0jutYpMxU=;
        b=a0wjM8gJkYA4DzT8s8yqg6YWcMYpORL8cJphMk1omNFSFPPv0glmy+ftTJDWyWtfwa
         6OCHDN6+OoW3yFtX+UtjNvDfZMa42hA08dldh8wr7ZavGva+BvYawRKLZNr4uRNwvEFK
         h3NZ/As6rJ6lYHnO5o5NPXd5NWXFSrduTnMEBI14HnXiN82Rw/DhG559XDMNO0EdtpDH
         Tj25siyORWk+sDcTLcD7gyRl1bp8svEVEuHWxrP9AwYXCO/rggRdrukzT9EW6qOKTZO9
         SuvHM/TVioD64Jb0aIhI3tqkgZGFKWDB7FSUlv3Er+ZAhadFLn0PAnQfwiJjJQ5VAhIb
         cIzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D0KyMxRH/MSdDpCqeXLz794JFymGnRXmUM0jutYpMxU=;
        b=cn5ru+Kh8M3p6cKLwivVXuiHG3iQ6SGRzGxYgK8GRe0tw4jSJiQABrS9lh762uXdzr
         vCdGeENW0Ucj1653zYwwkR6CaNvv8EuASJm1cHNPxfGuDuWMsBxfdyot+SY1GD7OWYjU
         o6qaykC2SC2g0tgglsuGczhzgqW0mEE/YjUdiK5w8YB6ptPLMQeb6Lcvfror+coQZA3r
         g1GzjxitzK7tkUSSdk0o4wTwhmhOH0UF1Nsd3nPPRkoo+Xl8MQu06tC/Cza3KDzilOLu
         q7iLreiO3pr/vW0XlfJuvEWg5MgbquNYDKHGwzwjmy2Ok3ue/GRhjF1mUY1/PTrC4KGT
         8/Dw==
X-Gm-Message-State: AOAM5316Vuvpv7GjB4H4XwasoY7BwY4y99537o765nSk+ahKZW0nAV8I
        XJUuH9F9FSxO1QnQjkOY7OwzdAFz83g3uq1fI3A=
X-Google-Smtp-Source: ABdhPJyDpa+3z1LUDvQCHnSRFQtrI+vI+s6CU2sMF9n1GsD+jaF9YAfLwJzkOrDUlzc9Sz3rMe1HCFUve6pE5YyV8eg=
X-Received: by 2002:a25:5b55:: with SMTP id p82mr2513780ybb.510.1617174177319;
 Wed, 31 Mar 2021 00:02:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210330223748.399563-1-pctammela@mojatatu.com> <CAADnVQK+n69_uUm6Ac1WgvqM4X0_74nXHwkYxbkWFc1F5hU98Q@mail.gmail.com>
In-Reply-To: <CAADnVQK+n69_uUm6Ac1WgvqM4X0_74nXHwkYxbkWFc1F5hU98Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 31 Mar 2021 00:02:46 -0700
Message-ID: <CAEf4BzZmBiq_JG5-Y2u9jTZraEtyyuOJYWgKivcKk0WFCzKa8g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: check flags in 'bpf_ringbuf_discard()'
 and 'bpf_ringbuf_submit()'
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Pedro Tammela <pctammela@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 4:16 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Mar 30, 2021 at 3:54 PM Pedro Tammela <pctammela@gmail.com> wrote:
> >
> >  BPF_CALL_2(bpf_ringbuf_submit, void *, sample, u64, flags)
> >  {
> > +       if (unlikely(flags & ~(BPF_RB_NO_WAKEUP | BPF_RB_FORCE_WAKEUP)))
> > +               return -EINVAL;
> > +
> >         bpf_ringbuf_commit(sample, flags, false /* discard */);
> > +
> >         return 0;
>
> I think ringbuf design was meant for bpf_ringbuf_submit to never fail.
> If we do flag validation it probably should be done at the verifier time.

Oops, replied on another version already. But yes, BPF verifier relies
on it succeeding. I don't think we can do flags validation at BPF
verification time, though, because it is defined as non-const integer
and we do have valid cases where we dynamically determine whether to
FORCE_WAKEUP or NO_WAKEUP, based on application-driven criteria (e.g.,
amount of enqueued data).
