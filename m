Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53949168AE9
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 01:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgBVAVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 19:21:48 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:38097 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgBVAVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 19:21:48 -0500
Received: by mail-qv1-f68.google.com with SMTP id g6so1781859qvy.5;
        Fri, 21 Feb 2020 16:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yFY3ILLk6reG7reBIyS4OQDforKAa8H5TmzpyxdGoYs=;
        b=iY9TwESNJ0Sz0tzjeYWX1hVlLm6IxTHRnpTyuxH+4+/MZ4P1n8aSN/eiKZcX99iFDH
         DIU0YcfDygLOWncRThbyW5oqM6vHZn//0OntLK2kuwjTx3m6v8r5Yk8unIi4nl0WJMby
         a3yHeTIwYmgthFlwyn43K3mmlJC+jWmuiSYYqqfAPS7U61yknVIhC8MFscOIr8w3nvk8
         OS4aEvxfuLjvQKiiTgam0KypHqdDXL7fq9T+EQ1DtqqCUGNorGFj0C0l1KETorpUSqz9
         QcRTQoRIhRewltvQPQABR8oarXVnR8GZFylirRWJA386GjxDuGynzY5o5ZYTlCxWVj6l
         k4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yFY3ILLk6reG7reBIyS4OQDforKAa8H5TmzpyxdGoYs=;
        b=tJ/leETHtVdVoASaQdv/nUhrv4oUPxTNuN85C0JopiV7b2C1GFyxhFz1XziKaqqf7c
         z5Mnvo5HpUqx7CX49f4Sbt0d9sQ+aNTHLAYrgUaNg/JigbgD0oq2WOSAxupEJCFqAlYd
         GQ0rEqNs8ifYJoc3XCcCUvw0Plf485dydqhA+1q37bqgNKVJksGpTfDCT9z6sOduTa+Y
         JUEsYFanGQByYRSxTJSqNJIydBCbRFWofK8WnPDh731hney57CbnU/BQZP39O9XL6FOn
         nN5uHmvHFTwNGpRLVg5KckuinfkUeIi9y9IRI+cGY86p7FryXb+VQdnSUSgHCGl/cuE+
         jPQA==
X-Gm-Message-State: APjAAAXZHoKxlCVSKsh1mixw02Te6KE+gON1oo7Rb4ijri5Et0J4r/Ok
        YS5wNWfdH8SzZq2ABRDdvBVTgMW8/AWWZ0naw3M=
X-Google-Smtp-Source: APXvYqxw54q0lr9jdmtBg6+w4Cf5rUNAFAIzSCm5ZWH8MwTY6VO8PNlKPftoNXfuDvXWryRGDAIJt39AnmR7YZRGzMo=
X-Received: by 2002:a05:6214:8cb:: with SMTP id da11mr31015915qvb.228.1582330906998;
 Fri, 21 Feb 2020 16:21:46 -0800 (PST)
MIME-Version: 1.0
References: <20200220230546.769250-1-andriin@fb.com> <87eeuo5jgg.fsf@cloudflare.com>
In-Reply-To: <87eeuo5jgg.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Feb 2020 16:21:36 -0800
Message-ID: <CAEf4BzYuMr56P3EVyvdr4mvV3qbx496GMgfAU1Gd4aJo5RUR2A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix trampoline_count clean up logic
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 2:21 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Thu, Feb 20, 2020 at 11:05 PM GMT, Andrii Nakryiko wrote:
> > Libbpf's Travis CI tests caught this issue. Ensure bpf_link and bpf_object
> > clean up is performed correctly.
> >
> > Fixes: d633d57902a5 ("selftest/bpf: Add test for allowed trampolines count")
> > Cc: Jiri Olsa <jolsa@kernel.org>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  .../bpf/prog_tests/trampoline_count.c         | 25 +++++++++++++------
> >  1 file changed, 18 insertions(+), 7 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
> > index 1f6ccdaed1ac..781c8d11604b 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
> > @@ -55,31 +55,40 @@ void test_trampoline_count(void)
> >       /* attach 'allowed' 40 trampoline programs */
> >       for (i = 0; i < MAX_TRAMP_PROGS; i++) {
> >               obj = bpf_object__open_file(object, NULL);
> > -             if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
> > +             if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj))) {
> > +                     obj = NULL;
> >                       goto cleanup;
> > +             }
> >
> >               err = bpf_object__load(obj);
> >               if (CHECK(err, "obj_load", "err %d\n", err))
> >                       goto cleanup;
> >               inst[i].obj = obj;
> > +             obj = NULL;
> >
> >               if (rand() % 2) {
> > -                     link = load(obj, fentry_name);
> > -                     if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link)))
> > +                     link = load(inst[i].obj, fentry_name);
> > +                     if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link))) {
> > +                             link = NULL;
> >                               goto cleanup;
> > +                     }
> >                       inst[i].link_fentry = link;
> >               } else {
> > -                     link = load(obj, fexit_name);
> > -                     if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link)))
> > +                     link = load(inst[i].obj, fexit_name);
> > +                     if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link))) {
> > +                             link = NULL;
> >                               goto cleanup;
> > +                     }
> >                       inst[i].link_fexit = link;
> >               }
> >       }
> >
> >       /* and try 1 extra.. */
> >       obj = bpf_object__open_file(object, NULL);
> > -     if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
> > +     if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj))) {
> > +             obj = NULL;
> >               goto cleanup;
> > +     }
> >
> >       err = bpf_object__load(obj);
> >       if (CHECK(err, "obj_load", "err %d\n", err))
> > @@ -104,7 +113,9 @@ void test_trampoline_count(void)
> >  cleanup_extra:
> >       bpf_object__close(obj);
> >  cleanup:
> > -     while (--i) {
> > +     if (i >= MAX_TRAMP_PROGS)
> > +             i = MAX_TRAMP_PROGS - 1;
> > +     for (; i >= 0; i--) {
> >               bpf_link__destroy(inst[i].link_fentry);
> >               bpf_link__destroy(inst[i].link_fexit);
> >               bpf_object__close(inst[i].obj);
>
> I'm not sure I'm grasping what the fix is about.
>
> We don't access obj or link from cleanup, so what is the point of
> setting them to NULL before jumping there?
>
> Or is it all just an ancillary change to clamping the loop index
> variable to (MAX_TRAMP_PROGS - 1)?

Yeah, mostly ancillary. But this is not just clamping to
MAX_TRAMP_PROGS-1. As Jiri pointed out, it's also handling a case of i
== 0.
