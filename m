Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7C8F1BB8
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 17:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732338AbfKFQxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 11:53:22 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41551 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727824AbfKFQxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 11:53:21 -0500
Received: by mail-ot1-f65.google.com with SMTP id 94so21383096oty.8
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 08:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eI1R5EyNmsLlTXQw1zC6NwZtbg4vnYGvl3wZnFPUCsQ=;
        b=rP/avvSDCawcScyR/ZiGgbMAFFlRIaRghmYoKTGd0pSBorxjE8SISAsRLdotrBjrkd
         XsOt9L3QN+h69W8zfBlDQKI7/zTGL+aIGIVNVnT5I8L/QXyMojbSo/2yAOTSDANMj7Ms
         ZAkwywQC0zRz2mdz45h9GyytFuFqxvcV6YrQQ62sRU8RSB80OaKlAwj9hnMWXKF+Vz+u
         tnQtSlzS6IxSlM2RSKCV3djUobb1VHwfaduM9oIt/ob7NaMYktdg/bDxAIY5RXfG07HU
         wKRKPaI8D/fVcQiKvpEStYyUk++t/oROA0X1RnPhHHEUMFUGMkyeSDJcoBCMGqw/YFqh
         /Kww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eI1R5EyNmsLlTXQw1zC6NwZtbg4vnYGvl3wZnFPUCsQ=;
        b=J8nRebk4s5PASAwvFLomTkSoPnZICuNO1w7pUT6G0qzw+iaIJ36PJFpVSqAe3QN/43
         0zVFZEkexfi34pss72FgXf+OANolhsZ//EFX4YRwPG4iiBLGw3qbSFV1kT18/2DqXgwe
         ddaCLXhCwNCoT3ljTFvIz/jwnbM+RxAVxGadg9adXAssDe9n+o4eh/RbnrNK/AgCTEee
         M4k5BXial8TZdMF6WH1LYMUhe7NG1qTtZ0oCTEnPUtbV8Fi5Xc1KR3WJcyPrEdLe1YXX
         khVGigbOP4M6Vg6t31st5whbrs1YWwUJKw3z6ZdhASzaoM+Gpz7Igc1GPV/RsVrNzEbk
         jH9g==
X-Gm-Message-State: APjAAAU3l7DOTj5cRVcrEY/5cHBykenUQG8/6vdDQTx2Gq90yn85QAnN
        lFjphc47N1csbe1KpEFn3Pj5z3wqcbLsWSQqM+Q=
X-Google-Smtp-Source: APXvYqwLmdzdpaSOZnsrQFK3KmKGPxi0cGRFZgPo7YgKW4feCQmi/2y7KFxuWcLW9CujjvJE81aKp+sXNbT+iDHr4h8=
X-Received: by 2002:a9d:61cd:: with SMTP id h13mr2663279otk.196.1573059200569;
 Wed, 06 Nov 2019 08:53:20 -0800 (PST)
MIME-Version: 1.0
References: <1572996938-23957-1-git-send-email-u9012063@gmail.com>
In-Reply-To: <1572996938-23957-1-git-send-email-u9012063@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 6 Nov 2019 17:53:09 +0100
Message-ID: <CAJ8uoz1voxsk9+xnKtcvrjmObO8SbOB0BZGxgkqPdejbOmM_ZA@mail.gmail.com>
Subject: Re: [PATCH net-next] xsk: Enable shared umem support.
To:     William Tu <u9012063@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>, dev@openvswitch.org,
        i.maximets@ovn.org, Eelco Chaudron <echaudro@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 12:41 AM William Tu <u9012063@gmail.com> wrote:
>
> Currently the shared umem feature is not supported in libbpf.
> The patch removes the refcount check in libbpf to enable use of
> shared umem.  Also, a umem can be shared by multiple netdevs,
> so remove the checking at xsk_bind.

Hi William,

I do have a five part patch set sitting on the shelf that implements
this as well as a sample, added documentation and support for Rx-only
and Tx-only sockets. Let me just rebase it, retest it then submit it
to the list and you can see what you think of it. It is along the
lines of what you are suggesting here. I am travelling at the moment,
so this might not happen until tomorrow.

Structure of the patch set that I will submit:

Patch 1: Adds shared umem support to libbpf
Patch 2: Shared umem support and example XPD program added to xdpsock sample
Patch 3: Adds Rx-only and Tx-only support to libbpf
Patch 4: Uses Rx-only sockets for rxdrop and Tx-only sockets for txpush in
         the xdpsock sample
Patch 5: Add documentation entries for these two features

> Tested using OVS at:
> https://mail.openvswitch.org/pipermail/ovs-dev/2019-November/364392.html
>
> Signed-off-by: William Tu <u9012063@gmail.com>
> ---
>  net/xdp/xsk.c       |  5 -----
>  tools/lib/bpf/xsk.c | 10 +++++-----
>  2 files changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 6040bc2b0088..0f2b16e275e3 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -697,11 +697,6 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>                         sockfd_put(sock);
>                         goto out_unlock;
>                 }
> -               if (umem_xs->dev != dev || umem_xs->queue_id != qid) {
> -                       err = -EINVAL;
> -                       sockfd_put(sock);
> -                       goto out_unlock;
> -               }
>
>                 xdp_get_umem(umem_xs->umem);
>                 WRITE_ONCE(xs->umem, umem_xs->umem);
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 74d84f36a5b2..e6c4eb077dcd 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -579,16 +579,13 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>         struct sockaddr_xdp sxdp = {};
>         struct xdp_mmap_offsets off;
>         struct xsk_socket *xsk;
> +       bool shared;
>         int err;
>
>         if (!umem || !xsk_ptr || !rx || !tx)
>                 return -EFAULT;
>
> -       if (umem->refcount) {
> -               pr_warn("Error: shared umems not supported by libbpf.\n");
> -               return -EBUSY;
> -       }
> -
> +       shared = !!(usr_config->bind_flags & XDP_SHARED_UMEM);
>         xsk = calloc(1, sizeof(*xsk));
>         if (!xsk)
>                 return -ENOMEM;
> @@ -687,6 +684,9 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>         sxdp.sxdp_queue_id = xsk->queue_id;
>         sxdp.sxdp_flags = xsk->config.bind_flags;
>
> +       if (shared)
> +               sxdp.sxdp_shared_umem_fd = umem->fd;
> +
>         err = bind(xsk->fd, (struct sockaddr *)&sxdp, sizeof(sxdp));
>         if (err) {
>                 err = -errno;
> --
> 2.7.4
>
