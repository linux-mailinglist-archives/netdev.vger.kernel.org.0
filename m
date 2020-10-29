Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8852B29F89B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgJ2WqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgJ2WqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 18:46:07 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CE1C0613CF;
        Thu, 29 Oct 2020 15:46:07 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id a12so3515325ybg.9;
        Thu, 29 Oct 2020 15:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VVt6QEy9pGzyiGP4x1mdNcouqSR3BPdXvpJ6WW5vvcA=;
        b=dCPv6UTfM5SUTRKc9CG6+5q6G2n5dS+bt3ss+D+Mx+92J+gHa+rQM4JLPMN3uSpW5/
         O8Ceid6Fg030jVJXSw1S5WAlK6yXLqZVCxTF/V5MsWoxm2WMzvHYvxeMvIe9L59Roc0G
         rlvlphIV3/ZqaaNKytKOE040AD/YwrCkvd07rxc3oIA0k2pwvBictI/ie9Na71ALNtXV
         Jes331kNSdvhRbNnOqtFJk78YtMzuE2PoPBta/TBH7bFv9C2AuW5FMS2ABKVx5agyrhC
         LuSZ818nwQKyR30iCWVAS6bNuykhziHsTtNr6GImiTruDlRkDQ4T+nprjbSPOIrLQrnV
         ncLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VVt6QEy9pGzyiGP4x1mdNcouqSR3BPdXvpJ6WW5vvcA=;
        b=U0DbqDxNx892v1xfu0mByzKXf4xxYaVTnhXQ0ERbCz0n9SUxcWDM0ll7A65Dfrv4UL
         ISD9s/fwbRcs+AU26Skltt4VUG8HyGHockYJuYatfuZk9i/K3pWukIEj6yUXErFNmOhw
         CLJ9nrScIr//citDcNgGGWL8/8YMbhKaT1ZWpL58NMU+AXPNTiAhkptkALsDlavcLA3v
         9vGZmr504/h5Nw6VPvrxz4XrRY4VqtJVyGXYIf3AqvaRFjfesxky1wspBEOGuXwwLtts
         eYR2quGEFKkiI/QkaCNmSa1p/D4kZz7qUItutC84uB7h+ouxRoWNQt0JXCkRy4/Zk2xD
         MT2w==
X-Gm-Message-State: AOAM533aZGCkFykJOZbmZgdRSLeIJYSUpIKNeFyAwciteHVtCmXPARvX
        8WE5oOyhbWBGyiNmz7nWyb1veZgUnbW2/QWuZzBeQfrigbw/MA==
X-Google-Smtp-Source: ABdhPJybcuK6gZtzYJqSFpf8JKPOvfM/h1kf+kHsoLpZKvlMb4P/mkkSHkS/3FFXho61gfM9SA+WP+BqQr+gTaQXlV0=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr9535922ybe.403.1604011566711;
 Thu, 29 Oct 2020 15:46:06 -0700 (PDT)
MIME-Version: 1.0
References: <20201022082138.2322434-1-jolsa@kernel.org> <20201022082138.2322434-8-jolsa@kernel.org>
 <20201028182534.GS2900849@krava> <20201028211502.ishg56ogvjuj7t4w@ast-mbp.dhcp.thefacebook.com>
 <20201029092953.GA3027684@krava>
In-Reply-To: <20201029092953.GA3027684@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Oct 2020 15:45:55 -0700
Message-ID: <CAEf4BzaLNeRVEYkvKoiz+1iwVkpCKALvRPPiCBOoBgyzZhbPJQ@mail.gmail.com>
Subject: Re: [RFC bpf-next 07/16] kallsyms: Use rb tree for kallsyms name search
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 2:31 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Oct 28, 2020 at 02:15:02PM -0700, Alexei Starovoitov wrote:
> > On Wed, Oct 28, 2020 at 07:25:34PM +0100, Jiri Olsa wrote:
> > > On Thu, Oct 22, 2020 at 10:21:29AM +0200, Jiri Olsa wrote:
> > > > The kallsyms_expand_symbol function showed in several bpf related
> > > > profiles, because it's doing linear search.
> > > >
> > > > Before:
> > > >
> > > >  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s* \
> > > >    { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
> > > >
> > > >      2,535,458,767      cycles:k                         ( +-  0.55% )
> > > >        940,046,382      cycles:u                         ( +-  0.27% )
> > > >
> > > >              33.60 +- 3.27 seconds time elapsed  ( +-  9.73% )
> > > >
> > > > Loading all the vmlinux symbols in rbtree and and switch to rbtree
> > > > search in kallsyms_lookup_name function to save few cycles and time.
> > > >
> > > > After:
> > > >
> > > >  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s* \
> > > >    { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
> > > >
> > > >      2,199,433,771      cycles:k                         ( +-  0.55% )
> > > >        936,105,469      cycles:u                         ( +-  0.37% )
> > > >
> > > >              26.48 +- 3.57 seconds time elapsed  ( +- 13.49% )
> > > >
> > > > Each symbol takes 160 bytes, so for my .config I've got about 18 MBs
> > > > used for 115285 symbols.
> > > >
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > >
> > > FYI there's init_kprobes dependency on kallsyms_lookup_name in early
> > > init call, so this won't work as it is :-\ will address this in v2
> > >
> > > also I'll switch to sorted array and bsearch, because kallsyms is not
> > > dynamically updated
> >
> > wait wat? kallsyms are dynamically updated. bpf adds and removes from it.
> > You even worked on some of those patches :)
>
> yes, it's tricky ;-) kallsyms_lookup_name function goes through builtin
> (compiled in) symbols and "standard modules" symbols
>
> we add bpf symbols as "pseudo module" symbol, which is not covered by
> this function search, it is covered when displaying /proc/kallsyms
> (check get_ksymbol_bpf function), same for ftrace and kprobe symbols
>
> AFAICS we use kallsyms_lookup_name only to search builtin kernel symbols,
> so we don't care it does not cover "pseudo modules"
>
> now.. what's even more funny, is that if I switch to sort/bsearch,
> performance is back on the same numbers as the current code :-\

If you do hashmap instead of RB tree or sort+bsearch, it will beat
both (assuming you have an adequate number of hash buckets, of
course).

>
> jirka
>
