Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46ADB34BB25
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 06:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbhC1EuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 00:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhC1Eth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 00:49:37 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762FDC061762;
        Sat, 27 Mar 2021 21:49:37 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id w8so10233967ybt.3;
        Sat, 27 Mar 2021 21:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ffP3+wfBWsf8vIWZ/6c7whWFmPxjdrz/IWxiXdxjeqo=;
        b=UN5aZnWuLBvo+9UnJTu142oE29v87MLGn5aAGIc+eOF9KMG3dTTyskjXTAb/C9Q/+s
         iaDYWTEwNmLRRPnQPmWZtBAyxcBFrULhsTV6MSp9sfR3bjvO9ibSd8fP2u9QFQh8Do0A
         L3zjxli47dN+6EdNhTv3uTHAmTzNG6jOqpRIM28ZGRkgHemNRx1jhId4s2SVGr4QUgZ/
         WQ6HwuSGEoGro8D9z+J8BI+ZICwo6ofdrYljwHOZzNDQs65vXEq+/1svrtC8aT7I+9iI
         ji22Z4puz2wt8Kg0zYfWfzIHmlhL7maryVG9kHgPDijgvWqD2EVqXKiVRCAIz3jvgqUf
         K8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ffP3+wfBWsf8vIWZ/6c7whWFmPxjdrz/IWxiXdxjeqo=;
        b=lvYyFYUvJ6WcePxiDpP3UDUmrDmLhrQab8FEDt7d7MX2GUbQ1XtaMsw/Pq5jjRzPUt
         dxxEERQ4qElAJLAcAgPBHVJ1NuKsHJ4w4wYOfFymERYYymAGHBQjDI9U9JNb6EyQuNMB
         AWm/OWE8u3FoxhoXhd2UEiCUTPKIkyT/y1VESB2SElGazfTWmyrhXatYmaIeXI5L36xE
         kMVtAIz06BdyOsD7Ixf1znDjybSFfPtH31ip1Zh0KAqGkA0oSFxzxeFEux4XBTkMNZbu
         J2q0Bw9xvQr5jf9TkYpYyAS88fQk5Lv4E9YbK/brUq0JMYh/136YWBpBpsqSWoP6TLAo
         svnw==
X-Gm-Message-State: AOAM533cynCbr/Gm1GVNW9AXWum50EljRg8ThjjATS2gDBPHWREd9Z25
        8Xa/5hEm4hs6ArCZOz1+fKe5M3h6RFiEaNq3u2U=
X-Google-Smtp-Source: ABdhPJynUglZUFlrw2GPgNs2YOah2gU00awERsc+dZuQwPdQzCR1e5/xW0WPjbQmEd2JNa95mi52jxZSyuxmmAw1W5Q=
X-Received: by 2002:a25:37c1:: with SMTP id e184mr30090907yba.260.1616906976844;
 Sat, 27 Mar 2021 21:49:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210326160501.46234-1-lmb@cloudflare.com>
In-Reply-To: <20210326160501.46234-1-lmb@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 27 Mar 2021 21:49:26 -0700
Message-ID: <CAEf4Bzaj+WgM5WEVTrZgN9oSND+_wdQoWOZYdo-sNyujZ9S0KQ@mail.gmail.com>
Subject: Re: [PATCH bpf v2 1/2] bpf: link: refuse non-O_RDWR flags in BPF_OBJ_GET
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 9:05 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Invoking BPF_OBJ_GET on a pinned bpf_link checks the path access
> permissions based on file_flags, but the returned fd ignores flags.
> This means that any user can acquire a "read-write" fd for a pinned
> link with mode 0664 by invoking BPF_OBJ_GET with BPF_F_RDONLY in
> file_flags. The fd can be used to invoke BPF_LINK_DETACH, etc.
>
> Fix this by refusing non-O_RDWR flags in BPF_OBJ_GET. This works
> because OBJ_GET by default returns a read write mapping and libbpf
> doesn't expose a way to override this behaviour for programs
> and links.
>
> Fixes: 70ed506c3bbc ("bpf: Introduce pinnable bpf_link abstraction")
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  kernel/bpf/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index 1576ff331ee4..dc56237d6960 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -547,7 +547,7 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
>         else if (type == BPF_TYPE_MAP)
>                 ret = bpf_map_new_fd(raw, f_flags);
>         else if (type == BPF_TYPE_LINK)
> -               ret = bpf_link_new_fd(raw);
> +               ret = (f_flags != O_RDWR) ? -EINVAL : bpf_link_new_fd(raw);
>         else
>                 return -ENOENT;
>
> --
> 2.27.0
>
