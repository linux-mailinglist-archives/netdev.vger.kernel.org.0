Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4F9D1406
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731693AbfJIQ3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:29:53 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34024 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbfJIQ3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:29:52 -0400
Received: by mail-qk1-f193.google.com with SMTP id q203so2798833qke.1;
        Wed, 09 Oct 2019 09:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cNuKAskLo6OM546RPPVM8Bvdimr1385wBhczsSTW8LY=;
        b=A2nkh74PjNB0cXeMqxfGl0lwGBoh8BlmZt1wPeYWN0Ok9RjJ3CyBSbpM+0QVIgKxmx
         n8m96GJGEyT+lpL9Kk2pTfrmO6GkBy55qnZHQa1cKcgimQEnlasq8OlOVULAf7BvyaG+
         ul3iOdySy3ePaUo6syWPTIQ1B5X+Edm6zDkaXJ6D4jdsvXS4jfh2Oaw1Yk3QrFTIPP92
         YZ4sYmR4ze/GIlzNLiNYs/wfq1sFPUhVhX0Y5XKJ12lq4Gbe0jFMin9l0De6i46AUJGB
         0UcJk7OTYY22ufYxr/KNPbWnBmiUGuEkPwTOgMqx9F8AHiTRy7iYG7MuAAV58HYwVNXG
         xgmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cNuKAskLo6OM546RPPVM8Bvdimr1385wBhczsSTW8LY=;
        b=nMJOW4lrPa7MKgG1rz9NeDd7oE9nxTT2ZXqnkPbNwJth+ViRyTSV/cuPOItxc8VYYI
         23YMrw/TLycK3gpwPpaa4v6pRvCUufkazneYtuv4FC3hZTBOIsBkV2YaUzXnxhGuEHtX
         vxhAUBBCgpt0DBQ9g1UsFsLFLN7H8Wrzk7wYFKlHYlYD/sUXPod2yKdsxfi4d+jqDlXt
         nekb9d/tFvHKOW4MQEoBsVDTByjEmkt2Ec5h7miL9GGbtMFXLzcl1teSrb6r6/ncOULM
         zr/XC3d9FVixy0HAaVZQBXa5DcVk4hfjEpzdW9Mwrs172RdS20am3MwSEdC9rmh94GFd
         5dRg==
X-Gm-Message-State: APjAAAWGkj2mxBchzZmH6KNMGW+gduORGLbQHU9Szmxz8prvfKSr3pRx
        qd1GF/0ZXGHCZMsZowEJE3mIjlLugGZGWSVCXKA=
X-Google-Smtp-Source: APXvYqzgq8qYqIV2JD8zEMGlXoEhFvZb4i55oFH8asoIQa4+GEZBCuBJV3Rx5ys8eQCG0het/opnqXkrCZVdOubivGc=
X-Received: by 2002:a37:6d04:: with SMTP id i4mr4623849qkc.36.1570638591744;
 Wed, 09 Oct 2019 09:29:51 -0700 (PDT)
MIME-Version: 1.0
References: <20191009154238.15410-1-i.maximets@ovn.org>
In-Reply-To: <20191009154238.15410-1-i.maximets@ovn.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Oct 2019 09:29:40 -0700
Message-ID: <CAEf4BzYtftYQaUa53pKE77cd5tnz3WDY2KDaixhT7XHQ8hyObg@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix passing uninitialized bytes to setsockopt
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 8:43 AM Ilya Maximets <i.maximets@ovn.org> wrote:
>
> 'struct xdp_umem_reg' has 4 bytes of padding at the end that makes
> valgrind complain about passing uninitialized stack memory to the
> syscall:
>
>   Syscall param socketcall.setsockopt() points to uninitialised byte(s)
>     at 0x4E7AB7E: setsockopt (in /usr/lib64/libc-2.29.so)
>     by 0x4BDE035: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:172)
>   Uninitialised value was created by a stack allocation
>     at 0x4BDDEBA: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:140)
>
> Padding bytes appeared after introducing of a new 'flags' field.
>
> Fixes: 10d30e301732 ("libbpf: add flags to umem config")
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---
>  tools/lib/bpf/xsk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index a902838f9fcc..26d9db783560 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -139,7 +139,7 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
>                             const struct xsk_umem_config *usr_config)
>  {
>         struct xdp_mmap_offsets off;
> -       struct xdp_umem_reg mr;
> +       struct xdp_umem_reg mr = {};

well, guess what, even with this explicit initialization, padding is
not guaranteed to be initialized (and it's sometimes is not in
practice, I ran into such problems), only since C11 standard it is
specified that padding is also zero-initialized. You have to do memset
to 0.

>         struct xsk_umem *umem;
>         socklen_t optlen;
>         void *map;
> --
> 2.17.1
>
