Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54ED2A9E68
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 11:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732968AbfIEJaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 05:30:30 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34754 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfIEJa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 05:30:29 -0400
Received: by mail-qt1-f193.google.com with SMTP id a13so2026043qtj.1;
        Thu, 05 Sep 2019 02:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j+NuWsvGg4YSTg+pY5U+WlBuaH5AU3qjPVHa3XzIK1k=;
        b=ZVscebx2X28emBP2unFzKnyKKxk5Ur7cs8Lpr09wpbqrCzquT7NG05gIf02ZCwrl9f
         DX8nrQZj/6xufRt9KH2fUN5soQyv7FqrQ3ZLZ6uFzg9rwBVLfAeIs7n9ejpOjMIaJe5G
         Jg3rEF38OvOe5G5PlKXV0p/gw6aEIqrI3RoSaX622LTUuOboeV9Hj1fes8ikfi8FcNE/
         ONvUBA1QoSbCm8Q8504y7jPdX92QFQhyi0XJdesYMUVnBgulxJkHTUD22W91ErRFuG8s
         /GYgspMFhWHK9M4Is9fQLrFetdc1fBiL2aCkVuSkDMQTk6xNZY6pGFzt6OflMUls+MyD
         Ff1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j+NuWsvGg4YSTg+pY5U+WlBuaH5AU3qjPVHa3XzIK1k=;
        b=oFJBP/dAqf8zR9D1aMYQ4iCF4OUHoJAT7k4F51VHrQ/o6DcyId3ODa+qTS0C63ssvd
         6HYVRl5iamdAcnfPNxLKTLSLih22uMHrsA93tFWoUmv86Ad+ZiowFqSHu7GQKC9/i5J4
         6myt1EyZPh6ppNPFbUkf4wO7CNxjY9rRE368+PuD7BlnZgTMHBExUAKnHx0dD6Kth9py
         pyYyCNhIMgTYcs0ZXj9pvWF7stjFrivecq/3Qc338IwBv9KCCY9OOVwNND+iR0x3tWO0
         qhetPZAdPx23S3/8bDzbQFy0z4wukKNtAYqVXLciWnJWj+G4IZ2qZB4V1OPkqk2Gj6cE
         Ar5w==
X-Gm-Message-State: APjAAAV2ffYwfYpzn3O8hnhL6EA6tK4n7Gciimy7jdb5jSMsWITZBpOp
        rE3ikJuIwVjpuqnzE/Nvzlfzam+dmlrrm0QTHNw=
X-Google-Smtp-Source: APXvYqwqtWEX/881MOd0kLoFhBC3PlmXYNpEUU838tQra9LNf+OzMUL5loXZdD+fMlpBG4M/oR1ESOugQ1GAOCo4uN8=
X-Received: by 2002:ac8:254c:: with SMTP id 12mr2489157qtn.36.1567675829060;
 Thu, 05 Sep 2019 02:30:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190905011217.3567-1-kevin.laatz@intel.com>
In-Reply-To: <20190905011217.3567-1-kevin.laatz@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 5 Sep 2019 11:30:17 +0200
Message-ID: <CAJ+HfNhBmP6sUt+vidOzk1GDNRmXqhvqgN72s5Ce3ysRd=YYQA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH bpf-next] ixgbe: fix xdp handle calculations
To:     Kevin Laatz <kevin.laatz@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Bruce Richardson <bruce.richardson@intel.com>,
        ciara.loftus@intel.com,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Sep 2019 at 11:28, Kevin Laatz <kevin.laatz@intel.com> wrote:
>
> Currently, we don't add headroom to the handle in ixgbe_zca_free,
> ixgbe_alloc_buffer_slow_zc and ixgbe_alloc_buffer_zc. The addition of the
> headroom to the handle was removed in
> commit d8c3061e5edd ("ixgbe: modify driver for handling offsets"), which
> will break things when headroom isvnon-zero. This patch fixes this and us=
es
> xsk_umem_adjust_offset to add it appropritely based on the mode being run=
.
>
> Fixes: d8c3061e5edd ("ixgbe: modify driver for handling offsets")
> Reported-by: Bjorn Topel <bjorn.topel@intel.com>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/e=
thernet/intel/ixgbe/ixgbe_xsk.c
> index 17061c799f72..ad802a8909e0 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -248,7 +248,8 @@ void ixgbe_zca_free(struct zero_copy_allocator *alloc=
, unsigned long handle)
>         bi->addr =3D xdp_umem_get_data(rx_ring->xsk_umem, handle);
>         bi->addr +=3D hr;
>
> -       bi->handle =3D (u64)handle;
> +       bi->handle =3D xsk_umem_adjust_offset(rx_ring->xsk_umem, (u64)han=
dle,
> +                                           rx_ring->xsk_umem->headroom);
>  }
>
>  static bool ixgbe_alloc_buffer_zc(struct ixgbe_ring *rx_ring,
> @@ -274,7 +275,7 @@ static bool ixgbe_alloc_buffer_zc(struct ixgbe_ring *=
rx_ring,
>         bi->addr =3D xdp_umem_get_data(umem, handle);
>         bi->addr +=3D hr;
>
> -       bi->handle =3D handle;
> +       bi->handle =3D xsk_umem_adjust_offset(umem, handle, umem->headroo=
m);
>
>         xsk_umem_discard_addr(umem);
>         return true;
> @@ -301,7 +302,7 @@ static bool ixgbe_alloc_buffer_slow_zc(struct ixgbe_r=
ing *rx_ring,
>         bi->addr =3D xdp_umem_get_data(umem, handle);
>         bi->addr +=3D hr;
>
> -       bi->handle =3D handle;
> +       bi->handle =3D xsk_umem_adjust_offset(umem, handle, umem->headroo=
m);
>
>         xsk_umem_discard_addr_rq(umem);
>         return true;
> --
> 2.17.1
>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
