Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA2BDF5C09
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbfKHXrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:47:07 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:42800 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfKHXrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 18:47:06 -0500
Received: by mail-qv1-f65.google.com with SMTP id c9so2898177qvz.9;
        Fri, 08 Nov 2019 15:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pdaTyuO8wYrV/7xvqbSHtKCASuB+OKSh/iIe2H42fEA=;
        b=VPWpmpsZlKO7ChvTZ+GMSXLc8D6Rr+xxDzpkU6FFnCxsJW0WZQJ+8bmXvg63wl6FN2
         to41nJRdZVSrPnJilRdHC5jmNUwXFFcGzlQF2F1pZXmNrKv5qydK9Cz4M7MxnYK09nfZ
         tdilalmZyRbZZ30DYsadYUCXhfS1M7FeU47K8HXZmn7EFpc1gXDJb2NdMcg9jKnbbPkr
         9nyr+HJamz8R8mtsQUZCHPiduNYns1YXCioJYrgdDMJ0oWstjuszrP4A+3XCgCbhJqFK
         RCYSRP+HhLHtgjuHDuzA47sTUFCcgqzzP0cHTKOqps848nixiMumLa1RKQvEdQh7C1kd
         00LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pdaTyuO8wYrV/7xvqbSHtKCASuB+OKSh/iIe2H42fEA=;
        b=fTk+pfytn7Ljn7HFVh06Gp3vR8SNFpOjE3FXvvGbKFkwgBBaUvZjPgoN7CPQVWhwMz
         z0DcM+GKV/030M41F1XTKjfIDFwOia/1N9HfVuB6rTVywTw12AIzJDjLGtYD1eMkiPnO
         BwSRIvpuBLyQo76tkX9htfgzz9+Hp6DrsYjxSLjN/5d90hnHnh69O57Hs0aCn+DGqGZf
         3KD4ISLmBy53pxfxt/ykFWYRqHEmETlemDQCjyM0l3aCRcJUrzbeiMzwK6a2ea7+0p7l
         fT7MosSU3c9eWbqPWzz/xNPAZMaVSeatiwP4IgPeCXb9E0FdsCjJBeXo6C5fVf13OXEt
         F+JQ==
X-Gm-Message-State: APjAAAXfm97Jz68EFuTN2T4tVNZ1mRhYIB1rsvuHN9EVwkqy0hhrtbAj
        2mp8iWYUqrX1fVERvExdUmejQcZO5WZyHEWu6T6d7A==
X-Google-Smtp-Source: APXvYqzMyBfMQ6b7r1wxbnby3PzUO9TnKlKTR5+DPkAjcblbyFJC1li1lGVzaqcrQfPaqhVef/boTrZdFWthNo7Mwr0=
X-Received: by 2002:ad4:58a9:: with SMTP id ea9mr12495622qvb.179.1573256825668;
 Fri, 08 Nov 2019 15:47:05 -0800 (PST)
MIME-Version: 1.0
References: <20191108064039.2041889-1-ast@kernel.org> <20191108064039.2041889-15-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-15-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 15:46:54 -0800
Message-ID: <CAEf4BzYLSaXLwp3Ujk07TcjQSvOo1RKcGE6fT7jh_tOpREne2w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 14/18] bpf: Compare BTF types of functions
 arguments with actual types
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 10:42 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Make the verifier check that BTF types of function arguments match actual types
> passed into top-level BPF program and into BPF-to-BPF calls. If types match
> such BPF programs and sub-programs will have full support of BPF trampoline. If
> types mismatch the trampoline has to be conservative. It has to save/restore
> all 5 program arguments and assume 64-bit scalars. If FENTRY/FEXIT program is
> attached to this program in the future such FENTRY/FEXIT program will be able
> to follow pointers only via bpf_probe_read_kernel().
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h          |   8 +++
>  include/linux/bpf_verifier.h |   1 +
>  kernel/bpf/btf.c             | 117 +++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c         |   1 +
>  kernel/bpf/verifier.c        |  18 +++++-
>  5 files changed, 142 insertions(+), 3 deletions(-)
>

[...]
