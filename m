Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D595B314737
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 04:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhBIDt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 22:49:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:43590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229876AbhBIDpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 22:45:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A53964DC3;
        Tue,  9 Feb 2021 03:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612842258;
        bh=/w2jiMlzkVdm1RkJJYVUh/o8YnxGktYLR7xd2szI5c4=;
        h=Date:From:To:Cc:Subject:From;
        b=PHX+ZK+Arb5cWnNYZpf97OGFqbMtHfXDNCtEC3Lkk1vl8m2CpxFQV0t01ifyCaWeb
         Ko7L30yurDqYEizZzktwjgKjyWnnMwZ3I3Ew4LP8kN8j3SwapZ7YMUQ7cCj+4OiRog
         ZS79DXDFKrai15edV/bFwHL5EhD1+TT4ylax5b9R3HALDMI4zIf2wZRhJexM7OmaZl
         20jiB0sou0wP6o0EMMDDZHdWNVYNemvhGpbMumHj0HmsfPmB8XOoTWShB7HjWbnGfm
         tygIIMfFLdebhaD+TPcltzamy9aWukk5DQd2C4uSYwUsPUfeW9eUEPOttW5Fr3JLlh
         iC0feCChgkpoA==
Date:   Mon, 8 Feb 2021 20:44:16 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Message-ID: <20210209034416.GA1669105@ubuntu-m3-large-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Recently, an issue with CONFIG_DEBUG_INFO_BTF was reported for arm64:
https://groups.google.com/g/clang-built-linux/c/de_mNh23FOc/m/E7cu5BwbBAAJ

$ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
                      LLVM=1 O=build/aarch64 defconfig

$ scripts/config \
    --file build/aarch64/.config \
    -e BPF_SYSCALL \
    -e DEBUG_INFO_BTF \
    -e FTRACE \
    -e FUNCTION_TRACER

$ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
                      LLVM=1 O=build/aarch64 olddefconfig all
...
FAILED unresolved symbol vfs_truncate
...

My bisect landed on commit 6e22ab9da793 ("bpf: Add d_path helper")
although that seems obvious given that is what introduced
BTF_ID(func, vfs_truncate).

I am using the latest pahole v1.20 and LLVM is at
https://github.com/llvm/llvm-project/commit/14da287e18846ea86e45b421dc47f78ecc5aa7cb
although I can reproduce back to LLVM 10.0.1, which is the earliest
version that the kernel supports. I am very unfamiliar with BPF so I
have no idea what is going wrong here. Is this a known issue?

Cheers,
Nathan
