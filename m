Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D223E23DF32
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgHFRkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729380AbgHFRje (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 13:39:34 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF4D4206B2;
        Thu,  6 Aug 2020 17:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596735574;
        bh=k8VyjNakQywVff5mE3aARE4tHjpNjuPZcVFyWpPMxzo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f1FgK7sOi2bcIKi9+O+McdfwEJGG6L5hSJzy9+8Nw3/ua9161Pa7lc1SJlQXtkSV6
         kixQZAYjcw/3NAMz3zR9MY9biKz4PW9prpNZXvy66CL6JHSb0EsLL4Fod8X42t9cmg
         X8lPdLxhrwc5dpWgB6Z/r6sqiZvJ9Vq1RyQL+QPA=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 3925140524; Thu,  6 Aug 2020 14:39:31 -0300 (-03)
Date:   Thu, 6 Aug 2020 14:39:31 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/3] Add generic and raw BTF parsing APIs to
 libbpf
Message-ID: <20200806173931.GJ71359@kernel.org>
References: <20200802013219.864880-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200802013219.864880-1-andriin@fb.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sat, Aug 01, 2020 at 06:32:16PM -0700, Andrii Nakryiko escreveu:
> It's pretty common for applications to want to parse raw (binary) BTF data
> from file, as opposed to parsing it from ELF sections. It's also pretty common
> for tools to not care whether given file is ELF or raw BTF format. This patch
> series exposes internal raw BTF parsing API and adds generic variant of BTF
> parsing, which will efficiently determine the format of a given fail and will
> parse BTF appropriately.
> 
> Patches #2 and #3 removes re-implementations of such APIs from bpftool and
> resolve_btfids tools.
> 
> Andrii Nakryiko (3):
>   libbpf: add btf__parse_raw() and generic btf__parse() APIs
>   tools/bpftool: use libbpf's btf__parse() API for parsing BTF from file
>   tools/resolve_btfids: use libbpf's btf__parse() API

I haven't checked which of the patches, or some in other series caused
this on Clear Linux:

  21 clearlinux:latest             : FAIL gcc (Clear Linux OS for Intel Architecture) 10.2.1 20200723 releases/gcc-10.2.0-3-g677b80db41, clang ver
sion 10.0.1

  gcc (Clear Linux OS for Intel Architecture) 10.2.1 20200723 releases/gcc-10.2.0-3-g677b80db41

  btf.c: In function 'btf__parse_raw':
  btf.c:625:28: error: 'btf' may be used uninitialized in this function [-Werror=maybe-uninitialized]
    625 |  return err ? ERR_PTR(err) : btf;
        |         ~~~~~~~~~~~~~~~~~~~^~~~~

This is what I have:

[acme@quaco perf]$ git log -10 --oneline tools/lib/bpf
94a1fedd63ed libbpf: Add btf__parse_raw() and generic btf__parse() APIs
2e49527e5248 libbpf: Add bpf_link detach APIs
1acf8f90ea7e libbpf: Fix register in PT_REGS MIPS macros
50450fc716c1 libbpf: Make destructors more robust by handling ERR_PTR(err) cases
dc8698cac7aa libbpf: Add support for BPF XDP link
d4b4dd6ce770 libbpf: Print hint when PERF_EVENT_IOC_SET_BPF returns -EPROTO
cd31039a7347 tools/libbpf: Add support for bpf map element iterator
da7a35062bcc libbpf bpf_helpers: Use __builtin_offsetof for offsetof
499dd29d90bb libbpf: Add support for SK_LOOKUP program type
4be556cf5aef libbpf: Add SEC name for xdp programs attached to CPUMAP
[acme@quaco perf]$

>  tools/bpf/bpftool/btf.c             |  54 +------------
>  tools/bpf/resolve_btfids/.gitignore |   4 +
>  tools/bpf/resolve_btfids/main.c     |  58 +-------------
>  tools/lib/bpf/btf.c                 | 114 +++++++++++++++++++---------
>  tools/lib/bpf/btf.h                 |   5 +-
>  tools/lib/bpf/libbpf.map            |   2 +
>  6 files changed, 89 insertions(+), 148 deletions(-)
>  create mode 100644 tools/bpf/resolve_btfids/.gitignore
> 
> -- 
> 2.24.1
> 

-- 

- Arnaldo
