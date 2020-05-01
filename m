Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7171C1DB3
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 21:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgEATRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 15:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725791AbgEATRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 15:17:02 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E926C061A0C;
        Fri,  1 May 2020 12:17:02 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id s9so7535651qkm.6;
        Fri, 01 May 2020 12:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3PQGbfgBxc4rjycLr7GBqZlmcKBP+RTCaMRw6hnAMaA=;
        b=XJPU40yEbq+5QfLApvCWjon5IwfabIYH/AWrsOg+h8i6FmH/7LDU8bZIkJoIU2E6Oq
         0SXiC9LLcKDa9D6vj8xfvcppq7g3Kz+lBe0P1XnXbauk0IdAh5Sft6OkWp+jOap2P3VS
         pc8ikYhgwqxAU3prNaxR5kBwWT+SPS/JN0uEG+XizlbUq3YlFPyC70+p32AQWaLZP8YR
         Y2V72XFu4nSeWdEGHMyh1JSfrj5LABnzEPwIb2a78S00m7ea7EDEMM6NnDLeVSl+zSC1
         g96n1Fl2X/FJ3Mg7sRMwvu/hnPYAN2HK8gUhjy0o26giK7bNWoT2xtFvKL1obkws1QbU
         wcpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3PQGbfgBxc4rjycLr7GBqZlmcKBP+RTCaMRw6hnAMaA=;
        b=Dp2Kg2tQShlUHBeWn9uhhAv39PmdePV1ZXw4FFmqiUO2NIM9GZxbql9kOLPqv5tfCd
         UEY6hMK1JIw04Lg/wNlCVRX/KzGTdzRxsGQeR/EnA0DjR5aj/XPnR+7gUG57yjPZJvaa
         YEHw8z4BXmjcLDkX1XZgHyGt6KNM6edxQA1Okz9+KTTen8i+fVxd86g1ESMKfOTP71aA
         Jytbp3jFUAXVEBuu3X6awfS6s4ylkm3tKNKhogu7ekevIM3JEgJ0RXCt5Hyqcfu4iZ4V
         criWU3V1zsywENXAhejFOgGRB5G8QgkLVle1uiXXZx40bVOvGBnIbUrmCk83odlSP6fK
         4T1w==
X-Gm-Message-State: AGi0Pua3Eu7QX1A98QgZUu13URLa1C7je9Lq6qm4TwspWCDMrh5+TeR9
        p2JnbH4pWog9sDSTR1e3+Og/clWze8kCgLJVRcthkQ==
X-Google-Smtp-Source: APiQypJuAXY5cJsrnA9BBWGKCbi6MLwAWdn0cUJX071K4Zqc5lJ5KMHz0bb2s6M2psqUUy++TV+TDU6T5x7VbNxfQrg=
X-Received: by 2002:ae9:e10b:: with SMTP id g11mr5491935qkm.449.1588360621552;
 Fri, 01 May 2020 12:17:01 -0700 (PDT)
MIME-Version: 1.0
References: <158824221003.2338.9700507405752328930.stgit@ebuild>
 <CAEf4BzYeJxGuPC8rbsY5yvED8KNaq=7NULFPnwPdeEs==Srd1w@mail.gmail.com> <5E1C3675-7D77-4A58-B2FD-CE92806DA363@redhat.com>
In-Reply-To: <5E1C3675-7D77-4A58-B2FD-CE92806DA363@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 May 2020 12:16:50 -0700
Message-ID: <CAEf4BzZScS-vRtiy2H6KgOHiq_xbhrNYVMtsD2Tn7Q4y1ssg4w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix probe code to return EPERM if encountered
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 1, 2020 at 2:56 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
>
>
> On 30 Apr 2020, at 20:12, Andrii Nakryiko wrote:
>
> > On Thu, Apr 30, 2020 at 3:24 AM Eelco Chaudron <echaudro@redhat.com>
> > wrote:
> >>
> >> When the probe code was failing for any reason ENOTSUP was returned,
> >> even
> >> if this was due to no having enough lock space. This patch fixes this
> >> by
> >> returning EPERM to the user application, so it can respond and
> >> increase
> >> the RLIMIT_MEMLOCK size.
> >>
> >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >> ---
> >>  tools/lib/bpf/libbpf.c |    7 ++++++-
> >>  1 file changed, 6 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index 8f480e29a6b0..a62388a151d4 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -3381,8 +3381,13 @@ bpf_object__probe_caps(struct bpf_object *obj)
> >>
> >>         for (i = 0; i < ARRAY_SIZE(probe_fn); i++) {
> >>                 ret = probe_fn[i](obj);
> >> -               if (ret < 0)
> >> +               if (ret < 0) {
> >>                         pr_debug("Probe #%d failed with %d.\n", i,
> >> ret);
> >> +                       if (ret == -EPERM) {
> >> +                               pr_perm_msg(ret);
> >> +                               return ret;
> >
> > I think this is dangerous to do. This detection loop is not supposed
> > to return error to user if any of the features are missing. I'd feel
> > more comfortable if we split bpf_object__probe_name() into two tests:
> > one testing trivial program and another testing same program with
> > name. If the first one fails with EPERM -- then we can return error to
> > user. If anything else fails -- that's ok. Thoughts?
>
> Before sending the patch I briefly checked the existing probes and did
> not see any other code path that could lead to EPERM. But you are right
> that this might not be the case for previous kernels. So you suggest
> something like this?

It both previous as well as future kernel version. We can never be
100% sure. While the idea of probe_caps() is to detect optional
features.

>
> diff --git a/src/libbpf.c b/src/libbpf.c
> index ff91742..fd5fdee 100644
> --- a/src/libbpf.c
> +++ b/src/libbpf.c
> @@ -3130,7 +3130,7 @@ int bpf_map__resize(struct bpf_map *map, __u32
> max_entries)
>   }
>
>   static int
> -bpf_object__probe_name(struct bpf_object *obj)
> +bpf_object__probe_loading(struct bpf_object *obj)
>   {
>          struct bpf_load_program_attr attr;
>          char *cp, errmsg[STRERR_BUFSIZE];
> @@ -3157,8 +3157,26 @@ bpf_object__probe_name(struct bpf_object *obj)
>          }
>          close(ret);
>
> -       /* now try the same program, but with the name */
> +       return 0;
> +}
>
> +static int
> +bpf_object__probe_name(struct bpf_object *obj)
> +{
> +       struct bpf_load_program_attr attr;
> +       struct bpf_insn insns[] = {
> +               BPF_MOV64_IMM(BPF_REG_0, 0),
> +               BPF_EXIT_INSN(),
> +       };
> +       int ret;
> +
> +       /* make sure loading with name works */
> +
> +       memset(&attr, 0, sizeof(attr));
> +       attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
> +       attr.insns = insns;
> +       attr.insns_cnt = ARRAY_SIZE(insns);
> +       attr.license = "GPL";
>          attr.name = "test";
>          ret = bpf_load_program_xattr(&attr, NULL, 0);
>          if (ret >= 0) {
> @@ -3328,6 +3346,11 @@ bpf_object__probe_caps(struct bpf_object *obj)
>          };
>          int i, ret;
>
> +       if (bpf_object__probe_loading(obj) == -EPERM) {
> +               pr_perm_msg(-EPERM);
> +               return -EPERM;
> +       }
> +
>          for (i = 0; i < ARRAY_SIZE(probe_fn); i++) {
>                  ret = probe_fn[i](obj);
>                  if (ret < 0)
>
> Let me know, and I sent out a v2.

Yes, that's the split I had in mind, but I'd move
bpf_object__probe_loading() call directly into bpf_object__load() to
be the first thing to check. probe_caps() should still be non-failing
if any feature is missing. Does it make sense?

>
> Cheers,
>
> Eelco
>
