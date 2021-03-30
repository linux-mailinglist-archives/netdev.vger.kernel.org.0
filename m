Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841B134EF66
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 19:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhC3R0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 13:26:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231636AbhC3RZm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 13:25:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B78E619C0;
        Tue, 30 Mar 2021 17:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617125142;
        bh=3m3n1CisZOWSF8y2dPFzwvPHYbC9T7DjCEhT4Mq0874=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YR4/jn/ivVjx8xP+VSHCIB3rXaFVmY9Co8KWU/Mpje5KnAEoFXqJaVw+Y+SPRpJQ5
         0sotTwKAsCUEblVH6MBk7TxHM6Ft/H2fJ+BeOr6x5VKE6NOMRW4lrvtdNheuNpa3wv
         5P6W4WtDF+CnQJVfGG/DDoaUfXDzHCSHEs6pDWKsVsjQDp/vDrUZ3dyp8SSWnhIm1z
         3eZP5egc2IQpwhXVbcAr1OYuBF09wzn7DtncIXJjIRxwbNSb6JDuHtPovS0pBvLWA5
         oVU+KpUFZd6GJi8pzFzIrgY6TGzToW4KMzqrTS+ANBL1X9n04lNup1bd4OVB8PFUEx
         887BMlLBuzWTQ==
Received: by mail-wr1-f46.google.com with SMTP id v11so16974439wro.7;
        Tue, 30 Mar 2021 10:25:41 -0700 (PDT)
X-Gm-Message-State: AOAM5335o1HBcWqYbg40AgfOJN5KMbZT68l+5icMuOVRGJT9Ddt1N1hN
        gRiRztQ6HiluoUHdX1ndwPQ3iM9jHsVJJhApeUk=
X-Google-Smtp-Source: ABdhPJxcgd+w6lzaIHyrXLbKihocSpP1qPfgqfzCmQjn8ea4TdoS660U6qmDW7VOWW9/69JdtoB+uhzrPenZkBdC3Mk=
X-Received: by 2002:adf:8b58:: with SMTP id v24mr34306606wra.160.1617125140703;
 Tue, 30 Mar 2021 10:25:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210330113419.4616-1-ciara.loftus@intel.com> <20210330113419.4616-4-ciara.loftus@intel.com>
In-Reply-To: <20210330113419.4616-4-ciara.loftus@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Date:   Tue, 30 Mar 2021 19:25:29 +0200
X-Gmail-Original-Message-ID: <CAJ+HfNicARR3ZoH38_ANx9t5cqFn9DEfvegjUSN019un5xcgnA@mail.gmail.com>
Message-ID: <CAJ+HfNicARR3ZoH38_ANx9t5cqFn9DEfvegjUSN019un5xcgnA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf 3/3] libbpf: only create rx and tx XDP rings when necessary
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Mar 2021 at 14:05, Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> Prior to this commit xsk_socket__create(_shared) always attempted to crea=
te
> the rx and tx rings for the socket. However this causes an issue when the
> socket being setup is that which shares the fd with the UMEM. If a
> previous call to this function failed with this socket after the rings we=
re
> set up, a subsequent call would always fail because the rings are not tor=
n
> down after the first call and when we try to set them up again we encount=
er
> an error because they already exist. Solve this by remembering whether th=
e
> rings were set up by introducing a new flag to struct xsk_umem, and
> checking it before setting up the rings for sockets which share the fd
> with the UMEM.
>
> Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  tools/lib/bpf/xsk.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index d4991ddff05a..12110bba4cc0 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -14,6 +14,7 @@
>  #include <unistd.h>
>  #include <arpa/inet.h>
>  #include <asm/barrier.h>
> +#include <linux/bitops.h>
>  #include <linux/compiler.h>
>  #include <linux/ethtool.h>
>  #include <linux/filter.h>
> @@ -46,6 +47,9 @@
>   #define PF_XDP AF_XDP
>  #endif
>
> +#define XDP_RX_RING_SETUP_DONE BIT(0)
> +#define XDP_TX_RING_SETUP_DONE BIT(1)
> +
>  enum xsk_prog {
>         XSK_PROG_FALLBACK,
>         XSK_PROG_REDIRECT_FLAGS,
> @@ -59,6 +63,7 @@ struct xsk_umem {
>         int fd;
>         int refcount;
>         struct list_head ctx_list;
> +       __u8 ring_setup_status;

Are we envisioning any more flags here? Otherwise, just a simple
bool/__u8 stating ring_setup_complete or ring_is_setup and just use
true/false and a simple check w/o bitwise and.


Bj=C3=B6rn
