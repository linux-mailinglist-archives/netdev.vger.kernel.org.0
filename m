Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85262300DD8
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 21:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbhAVUgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 15:36:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728366AbhAVUec (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 15:34:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D8F123B06;
        Fri, 22 Jan 2021 20:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611347631;
        bh=SyQP41PwpeKLZope/oUux/+VUUA4Mr4nW64xb8MeMJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K95RP+AjLtLOhWYLEX9Zga4StevHNyRJbxy2U9Qw40DifgXUAhdKTOu8U/A2jEGjl
         yP4j+nm9MD/QXRgd7XTcYB4JPLvmolWxr9/pX3/t3czlrGlX7o2RqL1BfShyHTo/X0
         PmhrlQxqg8GFPD0Kse1XQmKbz/bNCVBWkGDoMSU9DeZQy6CKFbC1OviDiK9AZIhfaV
         sAazw51LpGYgDNbYev9QTtlvoc1t7qb2SfNgM4N+5TLaAz3CFoMr0YeRk1bO3vEET3
         scQBVCnReCvuxwUyGXbEvK7gPT+pCUh4eLp9cgSazKmC6ZSQVtlYXl3xfVwu2LCfEG
         54N7c06dELO6A==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id D2ECA40513; Fri, 22 Jan 2021 17:33:48 -0300 (-03)
Date:   Fri, 22 Jan 2021 17:33:48 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Yulia Kopkova <ykopkova@redhat.com>
Subject: Re: [PATCH 2/2] bpf_encoder: Translate SHN_XINDEX in symbol's
 st_shndx values
Message-ID: <20210122203348.GC617095@kernel.org>
References: <20210122163920.59177-1-jolsa@kernel.org>
 <20210122163920.59177-3-jolsa@kernel.org>
 <20210122195228.GB617095@kernel.org>
 <20210122202403.GC35850@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122202403.GC35850@krava>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Jan 22, 2021 at 09:24:03PM +0100, Jiri Olsa escreveu:
> On Fri, Jan 22, 2021 at 04:52:28PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Jan 22, 2021 at 05:39:20PM +0100, Jiri Olsa escreveu:
> > > For very large ELF objects (with many sections), we could
> > > get special value SHN_XINDEX (65535) for symbol's st_shndx.
> > > 
> > > This patch is adding code to detect the optional extended
> > > section index table and use it to resolve symbol's section
> > > index.
> > > 
> > > Adding elf_symtab__for_each_symbol_index macro that returns
> > > symbol's section index and usign it in collect functions.
> > 
> > From a quick look it seems you addressed Andrii's review comments,
> > right?
> 
> yep, it's described in the cover email
> 
> > 
> > I've merged it locally, but would like to have some detailed set of
> > steps on how to test this, so that I can add it to a "Committer testing"
> > section in the cset commit log and probably add it to my local set of
> > regression tests.
> 
> sorry I forgot to mention that:
> 
> The test was to run pahole on kernel compiled with:
>   make KCFLAGS="-ffunction-sections -fdata-sections" -j$(nproc) vmlinux
> 
> and ensure FUNC records are generated and match normal
> build (without above KCFLAGS)
> 
> Also bpf selftest passed.

Thanks, I'll come up with some shell script to test that.
 
> 
> > 
> > Who originally reported this? Joe? Also can someone provide a Tested-by:
> > in addition to mine when I get this detailed set of steps to test?
> 
> oops, it was reported by Yulia Kopkova (just cc-ed)
> 
> Joe tested the v2 of the patchset, I'll make a dwarves scratch
> build with v3 and let them test it

Thanks, and there is a new comment by Andrii that I've found relevant
about using size_t instead of Elf_something.

- Arnaldo
