Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE1A30093B
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbhAVRGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 12:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729718AbhAVRFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 12:05:47 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F72C06178B
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 09:05:06 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id n15so1108422qkh.8
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 09:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PagpKKYHrimAyJj24L8Bk3YzjjtGo1A9w2b9ySnmzPg=;
        b=kkjk18XUfWrHShM1sL++Cd5qQ9OQcDVLjnQ7LCi95k5HaFWDy3RzUKGFKurj5yc9JK
         rbHhxtb3HKzv786f/RFp5TSZL+JsJPyb9EVd98C+rkP9sQ5OI9Qp6IMjRa5bP0n2UhFz
         lVRRBUMTGjvq11/UaHnm63dMlMgMf8Xl6jau+hc+r4jupSvLTCEOL4NYLN6ZtCYlH2au
         edckYYC/85VYSi8+2b9MVLvrrCLMUrQwfHleSPuCbwMTmyX4pX6yK8Ngv5qgjrlWcjuS
         gDiUGgxmM1+/T5z5sjis1DgHKWoge6JJ46645SjsF5g8QKyz4fOjrw5I/v6rHXmfVrmn
         ku/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PagpKKYHrimAyJj24L8Bk3YzjjtGo1A9w2b9ySnmzPg=;
        b=DMNwyTHlSX1G+OABmeLbn7X86GouhSVmEo4uWzyntxG5shATVMHJu3esjcktI6OreH
         mBsYiuYqj0p8L2/elsxOQ6mmkdB/l1rPN+luZzT2HTvmZigVU7uiTPMAOjFNiAsTBlt/
         +cbOu/bDUHhpp6yf4n2ivcVe29OY3u2uNz95QuHYVpPdtIzplYlEURM8BPf63kVyvy1U
         ZNP/oSPtlqa6uAnNuwF9/T5xtKkKKgjAmY+i5ZJpMli1ukXzNYxaPSyFK/CZ48B7q65Y
         A6kHJmC62gRgogObwB1JL0WY4FPoYIrA6ITZZssyMbcL7Q7R+adbT7QRmUWMsC5OXp2b
         ZDMg==
X-Gm-Message-State: AOAM533mWwD59uZre1OIofa+dpzGYakUAPBYSJRwOhP2AGd8tyVhUNh/
        Qc7FEjTssXAcBFWS3Y/QdBYGWQ5/21DKrGgZb6W9Hw==
X-Google-Smtp-Source: ABdhPJyLhQKL59L23NciXi/VFE/tmeccGcXmCOvRVM4ez0WSsphAE3r/WXK2sadIT/5VOKo24wEphlOx8ufuEjQzLr8=
X-Received: by 2002:a37:6c81:: with SMTP id h123mr1995282qkc.448.1611335105786;
 Fri, 22 Jan 2021 09:05:05 -0800 (PST)
MIME-Version: 1.0
References: <20210122164232.61770-1-loris.reiff@liblor.ch> <20210122164232.61770-2-loris.reiff@liblor.ch>
In-Reply-To: <20210122164232.61770-2-loris.reiff@liblor.ch>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 22 Jan 2021 09:04:54 -0800
Message-ID: <CAKH8qBtOVr_y2r2dSC+p7E1jfehXsh-RUdNLeo3n7zquMzogBw@mail.gmail.com>
Subject: Re: [PATCH 2/2] bpf: cgroup: Fix problematic bounds check
To:     Loris Reiff <loris.reiff@liblor.ch>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 8:43 AM Loris Reiff <loris.reiff@liblor.ch> wrote:
>
> Since ctx.optlen is signed, a larger value than max_value could be
> passed, as it is later on used as unsigned, which causes a WARN_ON_ONCE
> in the copy_to_user.
>
> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> Signed-off-by: Loris Reiff <loris.reiff@liblor.ch>
> ---
>  kernel/bpf/cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 6ec8f02f4..6aa9e10c6 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1464,7 +1464,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
>                 goto out;
>         }
>
> -       if (ctx.optlen > max_optlen) {
> +       if (ctx.optlen > max_optlen || ctx.optlen < 0) {
>                 ret = -EFAULT;
>                 goto out;
>         }
> --
> 2.29.2
Thanks! I assume this is only an issue if the BPF program is written
incorrectly.

Reviewed-by: Stanislav Fomichev <sdf@google.com>
