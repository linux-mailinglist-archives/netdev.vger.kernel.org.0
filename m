Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF55B17BE
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 06:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfIMEcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 00:32:22 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41877 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfIMEcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 00:32:21 -0400
Received: by mail-qt1-f194.google.com with SMTP id x4so654174qtq.8;
        Thu, 12 Sep 2019 21:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Yse8g8Q3UwGovp9kmEu/ngI/ZbWCMGb6gH3RV7HcZFA=;
        b=kC2TX1ensAA3ANidZN+R3xInNoGyBjIrz+f8zg2IfQ1rTGc8sjOw69hQL33RGItTNa
         TSOGL9ocNapSDLjHpsR+NvAACob8IJw1LbZvKQRsuIgCC8U0eiIE0ZUgJy0VIUJCkzeu
         BgXHDg+GtdZ6nL1e56QeEyNwrYYLW4drWSrkEHdTkwtTgD9/QYT2guFHmRBqO6ICpUDx
         Y7C2ocB5rkK9Vp8bAwgOzFKs6b9NkmozdKC8NAlWPIijnMpBwmCqUUgE9mPTF3CofFh6
         17xcB35IaTqVUNEl0uh2OoAbl9zZVQknrykzpqiQaQQAc7YYIVuxjC8lwP8VSambt9Vt
         CDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Yse8g8Q3UwGovp9kmEu/ngI/ZbWCMGb6gH3RV7HcZFA=;
        b=PVaofW66UhcZozSonc5PiRYocNoPj7TM3vQp+cE7v2z46P6W5Y0HEuqab3pT5bTi4E
         a/AE4dmfOyimgZsCiGSwW0tDqDLTL7yGaSmVUwrds040A7X2sLWQ4UvT26vdvkmR/w/E
         HIAiNcGDWjEtD5cG/nD2O1X5RdWQDIaO+Q5fWLIvVAJnYZ0zOgFc+g1vVdn8oQVzSHo5
         OiQijIaUEPrrTxZBbJ6mWwfV7a76+eEfI2PZUFNMLB8XBI3GeSlMEt2/3p1eAYngJDEq
         hBsenGMeB+YDXxxRymYmmQHADRQaqOtB3yuhLTC88m3+e5aFgtPL34JHA4F0SFc676My
         3coQ==
X-Gm-Message-State: APjAAAU5ryVLutvuz9aoyxak2pOUIMyK9Sj/dLh5u3q+q/52A+fsmTSA
        NjTxEKlOrNUuYA1ps3CL5s/PmCgCRDDu7Tv3Ao2VfSZIe/hzPg==
X-Google-Smtp-Source: APXvYqyFRo+kMM4H0/cH+ZcHpMFiZE0C1FPWmpFQ8UVQbm/cULX1srRSxjrDyA1OMn3Gib+K6YJhy4XenWKfNkpJpKY=
X-Received: by 2002:ad4:54e3:: with SMTP id k3mr30475927qvx.9.1568349139276;
 Thu, 12 Sep 2019 21:32:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190911172435.21042-1-ciara.loftus@intel.com>
In-Reply-To: <20190911172435.21042-1-ciara.loftus@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 13 Sep 2019 06:32:08 +0200
Message-ID: <CAJ+HfNiL3AKHYOv42d5oca7CaYLso18dV=+=_oDpBQsKMk7-fw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] i40e: fix xdp handle calculations
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Bruce Richardson <bruce.richardson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Kevin Laatz <kevin.laatz@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Sep 2019 at 19:27, Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> Commit 4c5d9a7fa149 ("i40e: fix xdp handle calculations") reintroduced
> the addition of the umem headroom to the xdp handle in the i40e_zca_free,
> i40e_alloc_buffer_slow_zc and i40e_alloc_buffer_zc functions. However,
> the headroom is already added to the handle in the function i40_run_xdp_z=
c.
> This commit removes the latter addition and fixes the case where the
> headroom is non-zero.
>
> Fixes: 4c5d9a7fa149 ("i40e: fix xdp handle calculations")
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/eth=
ernet/intel/i40e/i40e_xsk.c
> index 0373bc6c7e61..5f285ba1f1f9 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -192,7 +192,7 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring,=
 struct xdp_buff *xdp)
>  {
>         struct xdp_umem *umem =3D rx_ring->xsk_umem;
>         int err, result =3D I40E_XDP_PASS;
> -       u64 offset =3D umem->headroom;
> +       u64 offset;

Hi Ciara! Thanks for the patch; Small nit: Please sort local variable
declarations from longest to shortest line.


Cheers,
Bj=C3=B6rn


>         struct i40e_ring *xdp_ring;
>         struct bpf_prog *xdp_prog;
>         u32 act;
> @@ -203,7 +203,7 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring,=
 struct xdp_buff *xdp)
>          */
>         xdp_prog =3D READ_ONCE(rx_ring->xdp_prog);
>         act =3D bpf_prog_run_xdp(xdp_prog, xdp);
> -       offset +=3D xdp->data - xdp->data_hard_start;
> +       offset =3D xdp->data - xdp->data_hard_start;
>
>         xdp->handle =3D xsk_umem_adjust_offset(umem, xdp->handle, offset)=
;
>
> --
> 2.17.1
>
