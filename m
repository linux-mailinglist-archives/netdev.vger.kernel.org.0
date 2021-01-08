Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B592EF711
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbhAHSKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbhAHSKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:10:52 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491EFC0612EA
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:10:12 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id h3so3420355ils.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tJCMnZDQRG+yICTrVFXgl07IkUGgW4ffeedDQxXWSUA=;
        b=ZU19YM9WG6E1VWZF8uF/wS37+CuTGQKIRdrlJ+8lKWMEhNROSz2L0MQBF0AEdJwyyw
         BBOdo54OqeFWMudXj+WhhXPcWItaodVanDqWkmZn0d0/RYSDN/c1ybMzM/h4qGKuVvdN
         bOqjbBXssMfyCnFQLdV+0qwGUfZkB3HcBp7eFjQbSw6RyyF4m0DZQwF6yQlxpn5ywkJp
         e7OrjK5t7o85UeYaCfBkYhsZ0ekkmNogiQw0ABB8Kunmh1VYqFpHjxdGNL2ZsPgP1UPV
         DIPM1tiuYBAQFwMtTRDc5vFkgT1s5g62xiptaLQMQlE3sBQafm1atYOe7dZS3qR4W3lA
         sFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tJCMnZDQRG+yICTrVFXgl07IkUGgW4ffeedDQxXWSUA=;
        b=jvEoT1fhr+i0bFp03u2u8vXXygxkTQRgEymLEhCJOtbJBT3GPUXW9D5dpCthO6n0bm
         3iuuNpzP9PIPkXV3q2E2Mq37NXJmx3ZoQsYLusfRKUZ7xcbrKCu67jUnl2e3YfM3S5Nf
         vbSmP/Z+EwPj2qRWHvb8BAK1/XBcOkTYEiJ8e8lO+zmIip9FA4v7Vb+7qpxtnK4RLrHu
         dVFg3KyQvO3CH5A5zFVhY8NYLaUn/mJZ5oCs6D/Zfr+FbpAZcTKNT8+lMHMf+N2mx2EH
         uSoNfDhfcLZc+LuzCDXw1d4YXdiSTOrnQwEFj6WFXAo/zkr2XCTxSOvw4wNy2TQ2m8mO
         A+nA==
X-Gm-Message-State: AOAM532gs90PUveNd22eRZkc2cTMd8PMYcVU1sNQuCkHZbRka/7DUHdj
        xKjZnMF9F4fd2a/NvQmjrJxZsbUr+d6nTFoFRfKgJXUk21CiC6NS
X-Google-Smtp-Source: ABdhPJwSC793u3H0HplyYWxFScsoFtkPkp8knDTOHC8o3AC106aC44U575EIW4hR0QGD4xhd7nOFfGTH+iVkd7jCp3g=
X-Received: by 2002:a92:9f59:: with SMTP id u86mr5016729ili.205.1610129411358;
 Fri, 08 Jan 2021 10:10:11 -0800 (PST)
MIME-Version: 1.0
References: <20210108180333.180906-1-sdf@google.com> <20210108180333.180906-2-sdf@google.com>
In-Reply-To: <20210108180333.180906-2-sdf@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 Jan 2021 19:09:59 +0100
Message-ID: <CANn89i+GvEUmoapF+C0Mf1qw+AuWhU5_MMPz-jy8fND0HmUJ=Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 7:03 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> call in do_tcp_getsockopt using the on-stack data. This removes
> 3% overhead for locking/unlocking the socket.
>
> Without this patch:
>      3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
>             |
>              --3.30%--__cgroup_bpf_run_filter_getsockopt
>                        |
>                         --0.81%--__kmalloc
>
> With the patch applied:
>      0.52%     0.12%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern
>


OK but we are adding yet another indirect call.

Can you add a patch on top of it adding INDIRECT_CALL_INET() avoidance ?

Thanks.
