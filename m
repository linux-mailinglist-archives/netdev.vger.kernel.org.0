Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88D77B4C30
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 12:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfIQKsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 06:48:38 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38873 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfIQKsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 06:48:38 -0400
Received: by mail-wr1-f65.google.com with SMTP id l11so2616533wrx.5;
        Tue, 17 Sep 2019 03:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2wF2csif6Bxd2Ntfn72EqZLK8iy6fsXfRIhPwvQ9j4I=;
        b=gr0YmGqkSJwboNqKmNcsQ4SUgGrurjCNWd69nS+WzxdGjEgeCi3V5Mig3OsGC7io6o
         JoiKHP37l9a5U347BOvMZT2CNYidI9JXskrumeUUCw1xdO3DVH7zQJui/MdAmBmaX73R
         t6Na5xHGV+SRls06Lx5gv4FInMHPCaR8zW0hz+hS2GNe0IAi7YMCbTWfFlSEHas9fbnJ
         lnn9gyOK0r7220AQ8VGYY8Ga0i2EQT9fLRkHMgF/m3ZrTaj0dueVrMyswzU59ibdHq39
         fGtSnFr/5TsJj0zFjdiueig7ZQHlC1YMtGP1Yu7SAsave69ooi1vzAB0hy4DtSbg7CgF
         p1ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2wF2csif6Bxd2Ntfn72EqZLK8iy6fsXfRIhPwvQ9j4I=;
        b=Gr65i9nSFYf3DJy11yQTVFOhjMbBdTpQw7CLltiMEZbRrlbAc5ISBoZAsZd2Znj4o+
         WzWO1y859dvc7MuZ1C/zX4dmrVycFrhcrbh+xZi5cNZo3qjFVw/p/r+WkSnYgVZOt2ee
         1Mv9CPMTwRrcjwftR1MrYia9XBumGWXD3UwZLMgx5wK3Fp0/XZzKuePmfXe7Db7/XteF
         s9ABfJhAltlqEq/Y8d5X2RWWpaSzMY9FqJBa3j71bFIN07aJK6SendR0ZrJC4m/xC8WV
         qRQPT4D+BkgR9de75xFMd/Njy/q4gpASHNptePDzThGVMv/p/r9/xqc0CZ5WTHOZwwMZ
         mPaw==
X-Gm-Message-State: APjAAAUbTRYXr7Q07tm39RQCjSpcEfTgnWlrhSTPE41f/bmj0e64o6nN
        cW9DGR11l1vxMqzJnaZUwnInn+92twZjqNYMAMA=
X-Google-Smtp-Source: APXvYqy5RDe58CzMnsXxoGUvtObPFrVMtDwzQ+giwspQnlLoaacKyDOy5s2PBLONAGvY0LesU95VjbrfQwnhO/6mOpE=
X-Received: by 2002:adf:df81:: with SMTP id z1mr2597191wrl.295.1568717316081;
 Tue, 17 Sep 2019 03:48:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190905011144.3513-1-kevin.laatz@intel.com>
In-Reply-To: <20190905011144.3513-1-kevin.laatz@intel.com>
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
Date:   Tue, 17 Sep 2019 13:48:09 +0300
Message-ID: <CAKErNvpe3htU-ETe0y0XQ=SwY047qc3Z3=aHN6g2BbkoGHNNUQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] i40e: fix xdp handle calculations
To:     Kevin Laatz <kevin.laatz@intel.com>, bjorn.topel@intel.com
Cc:     maximmi@mellanox.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, bruce.richardson@intel.com,
        ciara.loftus@intel.com, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 5, 2019 at 4:11 AM Kevin Laatz <kevin.laatz@intel.com> wrote:
>
> Currently, we don't add headroom to the handle in i40e_zca_free,
> i40e_alloc_buffer_slow_zc and i40e_alloc_buffer_zc. The addition of the
> headroom to the handle was removed in
> commit 2f86c806a8a8 ("i40e: modify driver for handling offsets"),

Hi, it looks to me that headroom is still broken after this commit.
i40e_run_xdp_zc adds it a second time, i.e.:

1. xdp->handle already has the headroom added (after this patch).

2. bpf_prog_run_xdp(...);

3. u64 offset =3D umem->headroom;
   offset +=3D xdp->data - xdp->data_hard_start;
   xdp->handle =3D xsk_umem_adjust_offset(umem, xdp->handle, offset);

Step 3 adds the headroom one extra time.

I didn't look at ixgbe, it might also need to be fixed.

> which
> will break things when headroom is non-zero. This patch fixes this and us=
es
> xsk_umem_adjust_offset to add it appropritely based on the mode being run=
.
>
> Fixes: 2f86c806a8a8 ("i40e: modify driver for handling offsets")
> Reported-by: Bjorn Topel <bjorn.topel@intel.com>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/eth=
ernet/intel/i40e/i40e_xsk.c
> index eaca6162a6e6..0373bc6c7e61 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -267,7 +267,7 @@ static bool i40e_alloc_buffer_zc(struct i40e_ring *rx=
_ring,
>         bi->addr =3D xdp_umem_get_data(umem, handle);
>         bi->addr +=3D hr;
>
> -       bi->handle =3D handle;
> +       bi->handle =3D xsk_umem_adjust_offset(umem, handle, umem->headroo=
m);
>
>         xsk_umem_discard_addr(umem);
>         return true;
> @@ -304,7 +304,7 @@ static bool i40e_alloc_buffer_slow_zc(struct i40e_rin=
g *rx_ring,
>         bi->addr =3D xdp_umem_get_data(umem, handle);
>         bi->addr +=3D hr;
>
> -       bi->handle =3D handle;
> +       bi->handle =3D xsk_umem_adjust_offset(umem, handle, umem->headroo=
m);
>
>         xsk_umem_discard_addr_rq(umem);
>         return true;
> @@ -469,7 +469,8 @@ void i40e_zca_free(struct zero_copy_allocator *alloc,=
 unsigned long handle)
>         bi->addr =3D xdp_umem_get_data(rx_ring->xsk_umem, handle);
>         bi->addr +=3D hr;
>
> -       bi->handle =3D (u64)handle;
> +       bi->handle =3D xsk_umem_adjust_offset(rx_ring->xsk_umem, (u64)han=
dle,
> +                                           rx_ring->xsk_umem->headroom);
>  }
>
>  /**
