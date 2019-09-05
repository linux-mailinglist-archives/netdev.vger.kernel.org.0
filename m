Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1ACA9E64
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 11:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732309AbfIEJaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 05:30:08 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38175 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731158AbfIEJaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 05:30:08 -0400
Received: by mail-qt1-f195.google.com with SMTP id b2so1988106qtq.5;
        Thu, 05 Sep 2019 02:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1/qBPzDGnwVwTtxvRSJOqoyvYczgN5gLAndEkApQaJs=;
        b=ki0xGu2Js/snPqI+c0IIWa47EJGHUgBYRbMSqdSD78z57sq6oeR0Pwl3Es48C15I71
         fyWzhny81kyDZNMDcqhWmZcHsDqN0z9PDCqMMqOT6a8YjMhGjzFN4PlPW5WK23hnTNd0
         dyaiCqoSRJDmUfmj04BdUbbJ8xZMjFMkN59OTt8ZDFsOrHWD+BIVcVSXot4B7L4UAkMp
         S1XzH3jMOdby77bqbKc4aEz/4Gy7BPni6MqMf0Cce6/uoIOc/86NqhZJ8yuTv5D+1feJ
         qJmrv8p7dlr9k3MmPDnwlE9dsx9lBFuaA0//ZQjwyBBc07If8Eqx5vJJJhZ2WQvQA6lg
         2fWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1/qBPzDGnwVwTtxvRSJOqoyvYczgN5gLAndEkApQaJs=;
        b=and2RMPxKYYD5mycA5bEKBeiEfPTFGihEP1RVZHjliWH6LwpmMHRpulOLUzp+jlY1L
         w/hOS/X2E+ColuQfUWS8dhBehqd+xAdnONc/VidxoYLe2izpEqXGgr0igoMt7QMK0M8T
         q469g26gnR4XBI8qKTd1JS+gDZN6dwW49knjhXyiHve/z5b9gWhrIWecLIXr5M1/ITIU
         78aEv7N+fXMgWss9skv9GfTwtx5BiWi2Y9uIs1D0Pa1Sv4FlV0k2lkE6uy4W8z4w6Imc
         rDIBwng/XUzI42fwXe8kDhPMmp2cC5zjf70+Mz/fvfzFNiXMq1c2Oo4m3bk3wJI7uU48
         +7cg==
X-Gm-Message-State: APjAAAUe8jqg8ATQ3C5R0JIexTxqZtPsiefWdyI+i/d9mgfqjxrxfkjq
        sSMZOM9A/5KS+eYPLmVyg7LNN0hpoAmFjcZrCUo=
X-Google-Smtp-Source: APXvYqxNvrXejuh7WfEYSj+4SEHc1+NhdCLqNWpmkEnNmRDa90kjv0KgzmfMBT6Brk2/zCch5ckLa3rLdJnWeHzSJ3E=
X-Received: by 2002:a05:6214:1369:: with SMTP id c9mr1049810qvw.3.1567675806930;
 Thu, 05 Sep 2019 02:30:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190905011144.3513-1-kevin.laatz@intel.com>
In-Reply-To: <20190905011144.3513-1-kevin.laatz@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 5 Sep 2019 11:29:55 +0200
Message-ID: <CAJ+HfNib5qSX13wquSe8WbuZ3CMQCyeS2cdhqPG7NTjqvSq2Ew@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH bpf-next] i40e: fix xdp handle calculations
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

On Thu, 5 Sep 2019 at 11:27, Kevin Laatz <kevin.laatz@intel.com> wrote:
>
> Currently, we don't add headroom to the handle in i40e_zca_free,
> i40e_alloc_buffer_slow_zc and i40e_alloc_buffer_zc. The addition of the
> headroom to the handle was removed in
> commit 2f86c806a8a8 ("i40e: modify driver for handling offsets"), which
> will break things when headroom is non-zero. This patch fixes this and us=
es
> xsk_umem_adjust_offset to add it appropritely based on the mode being run=
.
>
> Fixes: 2f86c806a8a8 ("i40e: modify driver for handling offsets")
> Reported-by: Bjorn Topel <bjorn.topel@intel.com>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>

Thanks Kevin!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

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
> --
> 2.17.1
>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
