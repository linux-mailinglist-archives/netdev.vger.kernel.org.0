Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37873CF0C0
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 04:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbfJHCRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 22:17:00 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36483 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729212AbfJHCRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 22:17:00 -0400
Received: by mail-lf1-f68.google.com with SMTP id x80so10714254lff.3;
        Mon, 07 Oct 2019 19:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jMe1IF53cpM9+lc2eUsi/9GRHQADpXnkXe2XnB2yJXA=;
        b=BqFryqYg1TaKSl4AATw2ngQfYv7SQTJ6qkxElJhxd3PIiQbpHyQCLg9L+5KS8EZpX5
         p7JSUJfMm/JbwHacS4P4zvHdfLER7Cbry0GQd8EesPFcJWplb/jullDh0GZ/GZZhEqe3
         TElB029kxfhL7BC+2sFZCx/9ZIZPlyA61P3VEAjpKT9BhfGsUQoayILmwJeDCZcSzMdv
         NhgdTAZNZRbNHCIPat9nJ5IVG1ANLDUyweFRz80/xY7VQjjnDdmFC9ouvc8wzepPBIM4
         ZJYKRseCmkm2weN734HcDm0R/AQFVW+7urfKBcdzeyCxPsMo0Njmxt66xor2EdeFPaSB
         MItg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jMe1IF53cpM9+lc2eUsi/9GRHQADpXnkXe2XnB2yJXA=;
        b=pQsrV9ew3hDkc+VQMt4ZGgJb+/UjKFLd0XKrz5AbvG26ai3r/+hI19XGCESdpVIE9f
         JNy/n216QkZkPg3sv4ywQvl7hIXgOaaarHFgOIrsdIfu3tLUWqJ8QBJTvSErFH54mYfr
         Y2rnTBDVCQXDv0BJDCdgD1HXhyJ0mP9eBAhBIeUWWRuyytdGMipgI867rOPqTztc+85n
         KJLfCz0zIu5J7i8e6R6PbAe9pousye0Pwozaf3JW8Ks3c/LAhmuinCFW/Wf0Kr1LNa7K
         3MSYILM3XXfTzkFjw/x1CpjPasCtkfaFw7waAZA4Xf8OA7TUgyu3iogoradgeiIqWDX8
         QDuw==
X-Gm-Message-State: APjAAAU1V8L9BZN6ywxvLHkOvCQa0zi37cQXr7QZXgvuX6Ngs0FSyTkt
        Hs7PanVF2ooM0kcyrbiF/qZmaev05K2TT7aUQdI=
X-Google-Smtp-Source: APXvYqzR7wO7OasBq58KTHjzCy0IGws72eAWa7TwYO/nUbxneGrvH8glk43iCo9NZV8hG5tc8lObIGbQ0fjURr5bQh8=
X-Received: by 2002:a05:6512:304:: with SMTP id t4mr19300535lfp.15.1570501016678;
 Mon, 07 Oct 2019 19:16:56 -0700 (PDT)
MIME-Version: 1.0
References: <20191007225604.2006146-1-andriin@fb.com> <20191007185932.24d00391@cakuba.netronome.com>
In-Reply-To: <20191007185932.24d00391@cakuba.netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 7 Oct 2019 19:16:45 -0700
Message-ID: <CAADnVQ+XrFG25PaT_859Vz+9HmenKm4F1y4m8F-KauKkBCZp7Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] bpftool: fix bpftool build by switching to bpf_object__open_file()
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 7:00 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon, 7 Oct 2019 15:56:04 -0700, Andrii Nakryiko wrote:
> > diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> > index 43fdbbfe41bb..27da96a797ab 100644
> > --- a/tools/bpf/bpftool/prog.c
> > +++ b/tools/bpf/bpftool/prog.c
> > @@ -1092,9 +1092,7 @@ static int do_run(int argc, char **argv)
> >  static int load_with_options(int argc, char **argv, bool first_prog_only)
> >  {
> >       struct bpf_object_load_attr load_attr = { 0 };
> > -     struct bpf_object_open_attr open_attr = {
> > -             .prog_type = BPF_PROG_TYPE_UNSPEC,
> > -     };
> > +     enum bpf_prog_type common_prog_type = BPF_PROG_TYPE_UNSPEC;
> >       enum bpf_attach_type expected_attach_type;
> >       struct map_replace *map_replace = NULL;
> >       struct bpf_program *prog = NULL, *pos;
>
> Please maintain reverse xmas tree..

There are exceptions. I don't think it's worth doing everywhere.
