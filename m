Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44EC272FEB
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 15:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfGXN1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 09:27:50 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33879 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfGXN1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 09:27:49 -0400
Received: by mail-oi1-f195.google.com with SMTP id l12so35013167oil.1;
        Wed, 24 Jul 2019 06:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D3nfT2AYfvcWNX6C4tYDq8AelH7LpYUNw5f6JDGcCi4=;
        b=Ts5E6cak4gKsQtDuVaUoYQjfi4Fars7QGaODnzf0sOIdoq+M22ArMpqO7gL0uMrp+x
         HayWpfOmKyV/GOJJwStOFUxL1tU1Kj5egy1KPy0HToxYGVTyNhFQnuzBl+d/VWBpUhRi
         eYI245UPkW2i4qB3zGlnCcnT1ZH2hZqGoMsmlHOkwmazcNw0YvhspKZGiN3sOZJXEO/5
         nQRXruRU91Yv0UBiNZ4bMgDwN0/203grFc+T28EQZ3f362gJ7j2uy/LwA0G0GBDBinQP
         umV9ebvHg64TIE8+TzfjqeNYwmsEFi88lUIgCrBP0JOveJNXXiQ2cE707TGOz+jckAvW
         fqyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D3nfT2AYfvcWNX6C4tYDq8AelH7LpYUNw5f6JDGcCi4=;
        b=IR1/INbvTjdEePbQ+LxgmSWkEkPTqHkV39ngjD/MUU6sx4eKM4N7dedwXM987gHw5o
         0TausBoIuCZlSO8YNAJqS7NOnuPFIM5JDp1x6gK6Y/py5bfZCzNb1oNHYkwlZrnNgMNq
         ggsKKphLiStiEsVHEDB48eS+LYqSllZa1W5EDXQrkEuGmL4HnvbP1Dsd7dujRKG5zHUk
         7Pti3vSnCnjgaoi10GpodA2LcXx+FSuNWZtOkaS39Db5ylxu4qArVytpBmYjZJXwBYZH
         HzgNmoO0zCgSLTOrr/gcczO9oEXjtpD+IopYQaugdHmNc4fWeqLSk38OPSfTHzgIbKR5
         Ry4g==
X-Gm-Message-State: APjAAAVhPEoiSccbp8MsM16x+4OVXArcHyNG1skqfhtKiGg09DwaZhL/
        4m7j5amg2FyqapcKBYblX/txP+aYfDQkWCwMPmLc5ltYlwqmHw==
X-Google-Smtp-Source: APXvYqxAgeTd/a8HBW6CBSZcAe9204R7/yTv8UddJqu5NB1wOBZ3N1Co6fGgk4bDSNrfK73xA0M3ZeAncwYoCpDOBuY=
X-Received: by 2002:aca:f441:: with SMTP id s62mr41989789oih.109.1563974868904;
 Wed, 24 Jul 2019 06:27:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190723220127.1815913-1-andriin@fb.com>
In-Reply-To: <20190723220127.1815913-1-andriin@fb.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 24 Jul 2019 15:27:38 +0200
Message-ID: <CAJ8uoz17j9hzDFaYXRmLc0ziC5mwRCAYvvjmCkfUKHbMtcAwcQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: silence GCC8 warning about string truncation
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        kernel-team@fb.com, Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 4:33 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Despite a proper NULL-termination after strncpy(..., ..., IFNAMSIZ - 1),
> GCC8 still complains about *expected* string truncation:
>
>   xsk.c:330:2: error: 'strncpy' output may be truncated copying 15 bytes
>   from a string of length 15 [-Werror=stringop-truncation]
>     strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
>
> This patch gets rid of the issue altogether by using memcpy instead.
> There is no performance regression, as strncpy will still copy and fill
> all of the bytes anyway.

Let us make GCC8 happy then :-). Thanks Andrii.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/xsk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 5007b5d4fd2c..65f5dd556f99 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -327,7 +327,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
>
>         channels.cmd = ETHTOOL_GCHANNELS;
>         ifr.ifr_data = (void *)&channels;
> -       strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
> +       memcpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
>         ifr.ifr_name[IFNAMSIZ - 1] = '\0';
>         err = ioctl(fd, SIOCETHTOOL, &ifr);
>         if (err && errno != EOPNOTSUPP) {
> @@ -517,7 +517,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>                 err = -errno;
>                 goto out_socket;
>         }
> -       strncpy(xsk->ifname, ifname, IFNAMSIZ - 1);
> +       memcpy(xsk->ifname, ifname, IFNAMSIZ - 1);
>         xsk->ifname[IFNAMSIZ - 1] = '\0';
>
>         err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
> --
> 2.17.1
>
