Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A444F0E40
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 06:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356335AbiDDEtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 00:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiDDEtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 00:49:04 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EBA33885;
        Sun,  3 Apr 2022 21:47:09 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id b16so9926676ioz.3;
        Sun, 03 Apr 2022 21:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kl5JwZFmA2pGivDvke+PUH5tpyb6kuM1SWuUPM9Urjg=;
        b=SR8PR2rvjll0AaHFZLDTculDS3tn6vXmNnQaVBjO+XDgH6lgmR9jA8JtyJJOo35qiR
         N/HQ4D47Vo/P14a0Y3gH0stSqVgQDrxtCYNpuOYZ8/rYKqzhZKZFsyjTI/jJ+iFNYYPv
         VHWOh4SJWL1ptJSsNkIL4+jYq5G+df590mPeVURjAjhHvLLdCKC3jwBJkO0rnphgH1Gd
         mjKMl1OpXy1lJvUU8oM5vs9KrBtScoH89Cq5jN+3rVXZHfKiytO2isUWhBsvqAV5dSqr
         OGXFoIDkJYQI7EkYrM9rhUgIy7wdK+1H5cEkWiZB3NXHw75nXmIrQjdre9a831C9oNDD
         3cfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kl5JwZFmA2pGivDvke+PUH5tpyb6kuM1SWuUPM9Urjg=;
        b=2rKvidnj+Ijv6xf8H8hYrTtFcacmuKfZW5iAQXpiW0dRG9A6oShinq5X1kys84iOGK
         3u/uS/9grWEPZyIhwYFL8dcWyt0oy20xb0jMIVV4KarmAbA1Kk9LvNs1enUSy4Gg88hA
         VfQdKYAD2lxQA/rk++9OJd26qTc7h/LurWLL3jD+/QUJhMLhPoJZZIpnVOZqsMCvlDcI
         Sr0Gytgm7aCmmm1gL1jQ34F+/VxTwUY6FAvps5nIc4bUcuNQtcLkqL+bJIvYPcYaP/rv
         ZHvRDDdsTv+33AxSy2r5f4c0P0xy4nO+V8qjDBSuhusfBmDm/NTtWWyKD12o+v/xMgS4
         Jn+A==
X-Gm-Message-State: AOAM533MkLovhdxcFFsDcshgeCkZrfXCpxZ1GY769KZqxE0Aq8M0uvv9
        HTEaUnrabVrxAo/n7IJT/0byEqmPHzQzkdR4fekuVoPK
X-Google-Smtp-Source: ABdhPJwhfa5VyzpfDA4FzQev2QMyDJzegKwl396OYo4WuZkftWD8AHq7tW1I5AKnShVwM5n6Sm1IolxVf1X9MgApU6s=
X-Received: by 2002:a05:6638:1685:b0:323:9fed:890a with SMTP id
 f5-20020a056638168500b003239fed890amr10844786jat.103.1649047628572; Sun, 03
 Apr 2022 21:47:08 -0700 (PDT)
MIME-Version: 1.0
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
 <1648654000-21758-4-git-send-email-alan.maguire@oracle.com> <CAEf4BzbB3yeKdxqGewFs=BA+bXBNfhDf2Xh4XzBjrsSp_0khPQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbB3yeKdxqGewFs=BA+bXBNfhDf2Xh4XzBjrsSp_0khPQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 3 Apr 2022 21:46:57 -0700
Message-ID: <CAEf4BzZ5iLi=Xuw=+Ez30LWqPQuuVK8hGaVwfyHL5A+XDkFWgw@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 3/5] libbpf: add auto-attach for uprobes based
 on section name
To:     Alan Maguire <alan.maguire@oracle.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 3, 2022 at 6:14 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Mar 30, 2022 at 8:27 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > Now that u[ret]probes can use name-based specification, it makes
> > sense to add support for auto-attach based on SEC() definition.
> > The format proposed is
> >
> >         SEC("u[ret]probe/binary:[raw_offset|[function_name[+offset]]")
> >
> > For example, to trace malloc() in libc:
> >
> >         SEC("uprobe/libc.so.6:malloc")
> >
> > ...or to trace function foo2 in /usr/bin/foo:
> >
> >         SEC("uprobe//usr/bin/foo:foo2")
> >
> > Auto-attach is done for all tasks (pid -1).  prog can be an absolute
> > path or simply a program/library name; in the latter case, we use
> > PATH/LD_LIBRARY_PATH to resolve the full path, falling back to
> > standard locations (/usr/bin:/usr/sbin or /usr/lib64:/usr/lib) if
> > the file is not found via environment-variable specified locations.
> >
> > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 72 insertions(+), 2 deletions(-)
> >
>
> [...]
>
> > +static int attach_uprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link)
> > +{
> > +       DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
> > +       char *func, *probe_name, *func_end;
> > +       char *func_name, binary_path[512];
> > +       unsigned long long raw_offset;
> > +       size_t offset = 0;
> > +       int n;
> > +
> > +       *link = NULL;
> > +
> > +       opts.retprobe = str_has_pfx(prog->sec_name, "uretprobe/");
> > +       if (opts.retprobe)
> > +               probe_name = prog->sec_name + sizeof("uretprobe/") - 1;
> > +       else
> > +               probe_name = prog->sec_name + sizeof("uprobe/") - 1;
>
> I think this will mishandle SEC("uretprobe"), let's fix this in a
> follow up (and see a note about uretprobe selftests)

So I actually fixed it up a little bit to avoid test failure on s390x
arch. But now it's a different problem, complaining about not being
able to resolve libc.so.6. CC'ing Ilya, but I was wondering if it's
better to use more generic "libc.so" instead of "libc.so.6"? Have you
tried that?

We should also probably refactor attach_probe.c selftest to be a
collection of subtest, so that we can blacklist only some subtests.
For now I have to blacklist it entirely on s390x.

>
> > +
> > +       /* handle SEC("u[ret]probe") - format is valid, but auto-attach is impossible. */
> > +       if (strlen(probe_name) == 0) {
> > +               pr_debug("section '%s' is old-style u[ret]probe/function, cannot auto-attach\n",
> > +                        prog->sec_name);
>
> this seems excessive to log this, it's expected situation. The message
> itself is also misleading, SEC("uretprobe") isn't old-style, it's
> valid and supported case. SEC("uretprobe/something") is an error now,
> so that's a different thing (let's improve handling in the follow up).
>
> > +               return 0;
> > +       }
> > +       snprintf(binary_path, sizeof(binary_path), "%s", probe_name);
> > +       /* ':' should be prior to function+offset */
> > +       func_name = strrchr(binary_path, ':');
> > +       if (!func_name) {
> > +               pr_warn("section '%s' missing ':function[+offset]' specification\n",
> > +                       prog->sec_name);
> > +               return -EINVAL;
> > +       }
> > +       func_name[0] = '\0';
> > +       func_name++;
> > +       n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%li", &func, &offset);
> > +       if (n < 1) {
> > +               pr_warn("uprobe name '%s' is invalid\n", func_name);
> > +               return -EINVAL;
> > +       }
>
> I have this feeling that you could have simplified this a bunch with
> just one sscanf. Something along the lines of
> "%m[^/]/%m[^:]:%m[a-zA-Z0-9_.]+%li". If one argument matched (supposed
> to be uprobe or uretprobe), then it is a no-auto-attach case, just
> exit. If two matched -- invalid definition (old-style definition you
> were reporting erroneously above in pr_debug). If 3 matched -- binary
> + func (or abs offset), if 4 matched - binary + func + offset. That
> should cover everything, right?
>
> Please try to do this in a follow up.
>
> > +       if (opts.retprobe && offset != 0) {
> > +               free(func);
> > +               pr_warn("uretprobes do not support offset specification\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       /* Is func a raw address? */
> > +       errno = 0;
> > +       raw_offset = strtoull(func, &func_end, 0);
> > +       if (!errno && !*func_end) {
> > +               free(func);
> > +               func = NULL;
> > +               offset = (size_t)raw_offset;
> > +       }
> > +       opts.func_name = func;
> > +
> > +       *link = bpf_program__attach_uprobe_opts(prog, -1, binary_path, offset, &opts);
> > +       free(func);
> > +       return 0;
>
> this should have been return libbpf_get_error(*link), fixed it
>
>
> > +}
> > +
> >  struct bpf_link *bpf_program__attach_uprobe(const struct bpf_program *prog,
> >                                             bool retprobe, pid_t pid,
> >                                             const char *binary_path,
> > --
> > 1.8.3.1
> >
