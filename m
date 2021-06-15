Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7CA3A8990
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 21:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhFOTfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 15:35:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230012AbhFOTfH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 15:35:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A28D60E0C;
        Tue, 15 Jun 2021 19:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623785582;
        bh=Mx6wAAXn/soRKwq/hg+UAA/IhWBECd+G+9shpZSj+rQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s+556g9OCPnVI5+ewcio9gs7JtTbSK0kEbBTFHukMPNcwVXk/K9XkoxpQMEG9V6K2
         xa7MYmQCNdKpw4GjteIkhU1bajY7WA4K0tSqER20sHf2BJpuximXtWZA7BFDUdwfLy
         a5CIp1f9C6JpdMC6UvfG9TSdjdreYAsPIzLDQGYzG9j+S+L0yGoxfuVIsmkBgxZmPW
         85cxV357Znr2898TTvgeZfNb/gKhd7CFqztKshOTQcdBnUTuOZcFjMUVol8KFq65e3
         XxzEiKTfJkSj37kH19RlKg6u6y34o8SKF79C76tq/0GsVeRKw3WjjSmf3c1aI0cTSq
         71lkPV5tl5n2w==
Date:   Tue, 15 Jun 2021 12:33:00 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Kurt Manucredo <fuzzybritches0@gmail.com>,
        syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
        keescook@chromium.org, yhs@fb.com, dvyukov@google.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, nathan@kernel.org,
        ndesaulniers@google.com, clang-built-linux@googlegroups.com,
        kernel-hardening@lists.openwall.com, kasan-dev@googlegroups.com
Subject: Re: [PATCH v5] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Message-ID: <YMkAbNQiIBbhD7+P@gmail.com>
References: <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
 <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
 <202106091119.84A88B6FE7@keescook>
 <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com>
 <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com>
 <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com>
 <202106101002.DF8C7EF@keescook>
 <CAADnVQKMwKYgthoQV4RmGpZm9Hm-=wH3DoaNqs=UZRmJKefwGw@mail.gmail.com>
 <85536-177443-curtm@phaethon>
 <bac16d8d-c174-bdc4-91bd-bfa62b410190@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bac16d8d-c174-bdc4-91bd-bfa62b410190@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 07:51:07PM +0100, Edward Cree wrote:
> 
> As I understand it, the UBSAN report is coming from the eBPF interpreter,
>  which is the *slow path* and indeed on many production systems is
>  compiled out for hardening reasons (CONFIG_BPF_JIT_ALWAYS_ON).
> Perhaps a better approach to the fix would be to change the interpreter
>  to compute "DST = DST << (SRC & 63);" (and similar for other shifts and
>  bitnesses), thus matching the behaviour of most chips' shift opcodes.
> This would shut up UBSAN, without affecting JIT code generation.
> 

Yes, I suggested that last week
(https://lkml.kernel.org/netdev/YMJvbGEz0xu9JU9D@gmail.com).  The AND will even
get optimized out when compiling for most CPUs.

- Eric
