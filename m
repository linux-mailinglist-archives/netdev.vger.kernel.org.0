Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F8E50E0E
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbfFXOat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:30:49 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34222 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfFXOat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:30:49 -0400
Received: by mail-qk1-f196.google.com with SMTP id t8so9911603qkt.1;
        Mon, 24 Jun 2019 07:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=11lK59YDMxKSz6mXU2KGCY9MvqRCcSB/VBlnjMcKATg=;
        b=hIa1fwnHi0E4pA9ODwnJCh3iy8AyQE783+J8LO2nFASHhu/uth6PuSh+YStKX1qLEs
         67WNcet5NG1Ew0RHAXfqUrNqmA6GQEWl9HbDtMiy60kgIAxhYVdMZ6B9q4WuFUx79+r/
         iDt4O0ppH29XJ0+x65eWif+LRlI2+s4bAFnOCOm25kA8uIAv2Jfl4tAo5rlQSr6SEwZO
         XH57MVyUkPOxiVulGkyn/AP4pShbrMsqyH13QXJiYJ2k/KzZ5ct7l4yESIhjatjJ3+B6
         0Uwxg+j78/VAghHvLnUK5cwC00PkL/6jjc6ynV0crdpdK9bgyjKZWH2t+jQa0jJaX2jA
         5qog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=11lK59YDMxKSz6mXU2KGCY9MvqRCcSB/VBlnjMcKATg=;
        b=ufmUzNK/sPeexoa/yb7sQqUSI/1EbAumkQ5OcGQrTbifzmhd8eK7+dQWHiGyCW86Gl
         cralBBJ3PmaplYe8wQ+bfHuvxas5L4HfEYXe4px4R3aTOIc7b/13eiHAW5ulMQxioncY
         d8s6FbG88IHwUPNSBhTUCKhIYWYfPumJuA4wDI+sqebnrTvufBvMRYx6SQ65dcS+HXZy
         tk5A2umgHk/ABC/XUBAv0AfRFwwUr6CDBgXGxk7QuXOtZDR8j2qgbBLmi4Qs8e+dpkh4
         cLXPI3cMGJJl54igHb+nweS4ZyfanSGTHqC0EvK8gH8toTiruo4jXWTTmfBOmU0FbfF0
         DrwA==
X-Gm-Message-State: APjAAAXnSswKh81q2Wj4xGLT1E5AHht69BE/wKeN3njL96PMHDEIQVaZ
        YDeKk3b0noIYbddL+YGmZR/w7sMlaE1I/W/rK2k=
X-Google-Smtp-Source: APXvYqz1SFCvmwZ3IST4zw4OAov3RX6uDX06+jQAWwGYOQYABIagXpRAjY8php/Q1DdRkquo/W/PeSV0JZF1Z14ThiM=
X-Received: by 2002:a37:d16:: with SMTP id 22mr102835149qkn.232.1561386648099;
 Mon, 24 Jun 2019 07:30:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190620090958.2135-1-kevin.laatz@intel.com> <20190620090958.2135-3-kevin.laatz@intel.com>
In-Reply-To: <20190620090958.2135-3-kevin.laatz@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 24 Jun 2019 16:30:37 +0200
Message-ID: <CAJ+HfNhcj+LOQ5uLmyj0rZnomvW83NFDty0CQqj4a1wV7sQnmA@mail.gmail.com>
Subject: Re: [PATCH 02/11] ixgbe: simplify Rx buffer recycle
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
> copies within the function, we can use the original 'obi' values
> directly without having to mask and add the headroom.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>


> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/e=
thernet/intel/ixgbe/ixgbe_xsk.c
> index bfe95ce0bd7f..49536adafe8e 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -251,8 +251,6 @@ ixgbe_rx_buffer *ixgbe_get_rx_buffer_zc(struct ixgbe_=
ring *rx_ring,
>  static void ixgbe_reuse_rx_buffer_zc(struct ixgbe_ring *rx_ring,
>                                      struct ixgbe_rx_buffer *obi)
>  {
> -       unsigned long mask =3D (unsigned long)rx_ring->xsk_umem->chunk_ma=
sk;
> -       u64 hr =3D rx_ring->xsk_umem->headroom + XDP_PACKET_HEADROOM;
>         u16 nta =3D rx_ring->next_to_alloc;
>         struct ixgbe_rx_buffer *nbi;
>
> @@ -262,14 +260,9 @@ static void ixgbe_reuse_rx_buffer_zc(struct ixgbe_ri=
ng *rx_ring,
>         rx_ring->next_to_alloc =3D (nta < rx_ring->count) ? nta : 0;
>
>         /* transfer page from old buffer to new buffer */
> -       nbi->dma =3D obi->dma & mask;
> -       nbi->dma +=3D hr;
> -
> -       nbi->addr =3D (void *)((unsigned long)obi->addr & mask);
> -       nbi->addr +=3D hr;
> -
> -       nbi->handle =3D obi->handle & mask;
> -       nbi->handle +=3D rx_ring->xsk_umem->headroom;
> +       nbi->dma =3D obi->dma;
> +       nbi->addr =3D obi->addr;
> +       nbi->handle =3D obi->handle;
>
>         obi->addr =3D NULL;
>         obi->skb =3D NULL;
> --
> 2.17.1
>
