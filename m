Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393ABEB846
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729721AbfJaUMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:12:18 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39826 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfJaUMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:12:18 -0400
Received: by mail-qt1-f196.google.com with SMTP id t8so10257534qtc.6;
        Thu, 31 Oct 2019 13:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TOrQ7p/Ach8XhH3X0o1czbRwLqqDeVKyqWWNz0yiniw=;
        b=u5Ir3i7XwgUWHQakHPAg7OSyAnncurxagXjQYRJNB5Bz/OnG6DxOQxYgVkz0/e97K2
         YCmTP2Yr+LlxhW1iQD9eS8PRToH+Rmze39XExl5vUtE0GCYBjYpxRZsFHq3c2SvOs7RF
         3TfE11ynzDRPaVry9/XVq0o69vfrG5LwXl62oTmexeSY1J64JTLJlP6yZw2t24+r0VV8
         fQiD+udwJ8FiEE0yW+qHDPBLlXAoq3Y22tlRAq40kv9hIDpHeDWgBld3q+2mbh8cWDcH
         y7LPpdwb3xpGK8VOfB6kEvLWkM9SdLzLanrXgs/1x6s3fLLj63ZtvDnGHsfn8o7EFN18
         e6vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TOrQ7p/Ach8XhH3X0o1czbRwLqqDeVKyqWWNz0yiniw=;
        b=P9YceeAY66VSKuG3miAL5bovFrzv2wqZ+LMS3cg2FWLUN23Kx1qvRRrwFcbBCpGymo
         ibeUfBknN4H3g5fApS+TrBK4fdt6KVl6Ym6IDffoqT749eSO9GPPorqap2WvILVlhrJA
         rEKyTj8/pcnjmgji+7S9qKVWieILqXGnUSX+0S8lhyTh3vetA4Drg8YQi6Khf728WcdS
         GWzP/O5bhGlt0kx4gA2Wi86l7slVIpgjxZelG84y2NT2DTTRcalHZQ5J5GvaWMltSfs2
         aDkAbyyyZVdZXyxp8xbOdnoI70amrq1Ml5oJQz+hkYELTDOfND/PsmKqvmbk3ejlTmqW
         7TGQ==
X-Gm-Message-State: APjAAAUWGr/1Ietxy7OCYilBgyvkBRah7YBWOJa7gIa19qMuRa8CypQ/
        bNpJ9a4LgPw9xX6m5PLZdwAwGP8nRVqyZTTAQQY=
X-Google-Smtp-Source: APXvYqwUbLxRSprlO8zTvGYboDGaSb472nBPxyFRV86ljkBgVEKKDkwJaf4GDTJkTea4V2HfLpC3c77jNPvzz+dScbA=
X-Received: by 2002:a0c:e982:: with SMTP id z2mr6630820qvn.196.1572552736888;
 Thu, 31 Oct 2019 13:12:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1572483054.git.daniel@iogearbox.net> <59ffcedeed70cdae86fbd803b87cc581a82577d7.1572483054.git.daniel@iogearbox.net>
In-Reply-To: <59ffcedeed70cdae86fbd803b87cc581a82577d7.1572483054.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 31 Oct 2019 13:12:06 -0700
Message-ID: <CAEf4BzZ=pBcoUA7jxS7MiO8dYT4s-JGR1HG++DmbmqoKYM5qWw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/8] uaccess: Add strict non-pagefault
 kernel-space read function
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 6:00 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Add two new probe_kernel_read_strict() and strncpy_from_unsafe_strict()
> helpers which by default alias to the __probe_kernel_read() and the
> __strncpy_from_unsafe(), respectively, but can be overridden by archs
> which have non-overlapping address ranges for kernel space and user
> space in order to bail out with -EFAULT when attempting to probe user
> memory including non-canonical user access addresses [0].
>
> The idea is that these helpers are complementary to the probe_user_read()
> and strncpy_from_unsafe_user() which probe user-only memory. Both added
> helpers here do the same, but for kernel-only addresses.
>
> Both set of helpers are going to be used for BPF tracing. They also
> explicitly avoid throwing the splat for non-canonical user addresses from
> 00c42373d397 ("x86-64: add warning for non-canonical user access address
> dereferences").
>
> For compat, the current probe_kernel_read() and strncpy_from_unsafe() are
> left as-is.
>
>   [0] Documentation/x86/x86_64/mm.txt
>
>       4-level page tables: 0x0000800000000000 - 0xffff7fffffffffff
>       5-level page tables: 0x0100000000000000 - 0xfeffffffffffffff
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: x86@kernel.org
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  arch/x86/mm/Makefile    |  2 +-
>  arch/x86/mm/maccess.c   | 38 ++++++++++++++++++++++++++++++++++++++
>  include/linux/uaccess.h |  4 ++++
>  mm/maccess.c            | 25 ++++++++++++++++++++++++-
>  4 files changed, 67 insertions(+), 2 deletions(-)
>  create mode 100644 arch/x86/mm/maccess.c
>

[...]
