Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38EF850E01
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbfFXO36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:29:58 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36998 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfFXO35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:29:57 -0400
Received: by mail-qt1-f194.google.com with SMTP id y57so14690313qtk.4;
        Mon, 24 Jun 2019 07:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6aelL0MYmoOsC39DEdXgcWsMn76iOSdVzTtBRnix9CY=;
        b=bPD9fJzSQhKHGsiTuI4l9fH1CJtHQoMunWWiZarqS9+JnriIG67gcEDTjK0s3yJKEf
         4DFsz1e8l947ZNusMXVQcz0HS6YGDpKdarjDw74b3E8Pk8qBjp0H2u+FWSVtH2qEHYew
         5IqrIrT5wb8uSiD1YpC05+PmxDfL1lEJcTKIKlYPANKtdgcMUK5WViPRKquEP0rcg6U1
         Be4tz+M+P/a6lruSQZPThuc1vBwEPL3OEeyeqFIOJDMu/qrT1EQgteK+I1jwodMnxiBe
         N0G+uQRcseLvebe3Nq5xQn6eH85RpZKD7YhEdHfYyS4pWQpsi/WPFqYC2vDKqVk13kRE
         MIMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6aelL0MYmoOsC39DEdXgcWsMn76iOSdVzTtBRnix9CY=;
        b=lCZhhAwOVml+6L3zXbQ+ZJsP4Eh/GmGApWzZW2oUJrAA37S09Ch57skDiCsh12/xHk
         2K5UNRff4Pu3yhKQYENNiOv9CNKD5tc8fP6S1UP0VZUjsHGxD0L4lDjLiI70H1pBJWnI
         N7jV9Pcq/UMQ13DCD9BVzIz5zYFVI0FNHJN6lDCuJP7HRI/8nmCe8iMAnMSwndUbeXYz
         WLJ8lyjrUHrU4U65taxKxOlnZ6+gdLbG6g0kr0c9vqCi4l5pUHS4GEuAzH0UIr8iltg0
         +r179JS9HXL3jdqXAeEZQ719xF3s+L1bYZmLp1yz+cwWF91Ddp3dVDk6wqVAFlBk/ASR
         fohA==
X-Gm-Message-State: APjAAAXVVcvMcJ05TpVKeC4w55ZdhLVAhGCc4zqvSgr0sWZl+zcK4myy
        PLqEdXxuGjJ0gjIY9rHEdO41ZjN3k9wOSfgP4qY=
X-Google-Smtp-Source: APXvYqwG7TgKreWxn+atApq7FFCeEtjit9RsVISUqPHmI/gF0Gc11UM2Oz0soeGxLwq8FLZIaRRvWwc3Xzuxz5BKY2M=
X-Received: by 2002:ac8:25b1:: with SMTP id e46mr110318908qte.36.1561386596482;
 Mon, 24 Jun 2019 07:29:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190620090958.2135-1-kevin.laatz@intel.com> <20190620090958.2135-2-kevin.laatz@intel.com>
In-Reply-To: <20190620090958.2135-2-kevin.laatz@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 24 Jun 2019 16:29:45 +0200
Message-ID: <CAJ+HfNh5bqmjXFQ5r0h-K10H+ZaSEYoi0Xx5j+2VJ_rq+Ktu-g@mail.gmail.com>
Subject: Re: [PATCH 01/11] i40e: simplify Rx buffer recycle
To:     Kevin Laatz <kevin.laatz@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Bruce Richardson <bruce.richardson@intel.com>,
        ciara.loftus@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 at 19:25, Kevin Laatz <kevin.laatz@intel.com> wrote:
>
> Currently, the dma, addr and handle are modified when we reuse Rx buffers
> in zero-copy mode. However, this is not required as the inputs to the
> function are copies, not the original values themselves. As we use the
> copies within the function, we can use the original 'old_bi' values
> directly without having to mask and add the headroom.
>

I like that the required change was turned into a cleanup! Nice!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/eth=
ernet/intel/i40e/i40e_xsk.c
> index 1b17486543ac..c89e692e8663 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -419,8 +419,6 @@ static void i40e_reuse_rx_buffer_zc(struct i40e_ring =
*rx_ring,
>                                     struct i40e_rx_buffer *old_bi)
>  {
>         struct i40e_rx_buffer *new_bi =3D &rx_ring->rx_bi[rx_ring->next_t=
o_alloc];
> -       unsigned long mask =3D (unsigned long)rx_ring->xsk_umem->chunk_ma=
sk;
> -       u64 hr =3D rx_ring->xsk_umem->headroom + XDP_PACKET_HEADROOM;
>         u16 nta =3D rx_ring->next_to_alloc;
>
>         /* update, and store next to alloc */
> @@ -428,14 +426,9 @@ static void i40e_reuse_rx_buffer_zc(struct i40e_ring=
 *rx_ring,
>         rx_ring->next_to_alloc =3D (nta < rx_ring->count) ? nta : 0;
>
>         /* transfer page from old buffer to new buffer */
> -       new_bi->dma =3D old_bi->dma & mask;
> -       new_bi->dma +=3D hr;
> -
> -       new_bi->addr =3D (void *)((unsigned long)old_bi->addr & mask);
> -       new_bi->addr +=3D hr;
> -
> -       new_bi->handle =3D old_bi->handle & mask;
> -       new_bi->handle +=3D rx_ring->xsk_umem->headroom;
> +       new_bi->dma =3D old_bi->dma;
> +       new_bi->addr =3D old_bi->addr;
> +       new_bi->handle =3D old_bi->handle;
>
>         old_bi->addr =3D NULL;
>  }
> --
> 2.17.1
>
