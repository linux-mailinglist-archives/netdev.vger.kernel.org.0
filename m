Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F218B114DFD
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 10:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfLFJDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 04:03:22 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34099 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfLFJDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 04:03:21 -0500
Received: by mail-qk1-f194.google.com with SMTP id d202so5928247qkb.1;
        Fri, 06 Dec 2019 01:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BhqKBqru7Z1oN0FxrbYnYkaRpOqpaaBdzDxJuVgJ27s=;
        b=EviXRXYcKfsqPGSU+h5tBnkkxxsaQlQoCrbU3CrAGWKtNTOaFLFIOOzVB7AvalgIlM
         Ue3oLOyo2GFYbkBtZnh3oKQwaDiS7PSJdyFN/qrsu/xEF3idfSgUM6WBXSzhDuZJzm3G
         smj9uZRM8aeoKJEdCIGpRMPgA98qK7UGnQ2rPMWkV09WbDUQCXROBJqt2BK0vYPe/Ujd
         JxMOeZAidStW6gj0dVjfdCPoIAbkjZ51EgQ4x2MvkSMIxH1a+kUQbMyI7DZbwtqoBQEW
         nlzERUvZKXN9+8jlHWzWO6EII7ibrTH4CjpZJwxHUbsWb/edxFlzzNT8WoHPDa9PcWi8
         9WKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BhqKBqru7Z1oN0FxrbYnYkaRpOqpaaBdzDxJuVgJ27s=;
        b=FfLOibpfKY9vTwozaRrZEIHIjsYabFourthwZZmsLjtfHPXM3aS0thC02QZVUSpjbK
         uCSFVy5r/Kh8fRaONm/vtk8/bcLGv6Jkg7/KAgFf7e18oPnz0y6pY7HQ4E2Y4o4+HWwB
         k3B2oC75U0PDeAZvXGhtdlNHYbZyO2qGkWcM19H8/PribcsmcA3jWwHKT7sjB77QLJas
         ucrabQJ3b9TdJSJx60ivE8gSFyYQ0SwAE/RKJBlcxYqnPP2xsb2oKPIWWLnluk3haUDa
         xy/f2NTf085DDe1zhaUTrOexedJWo+W4hiOpREZxjYiuvoecxHk/OCwNf02AoryaXd3t
         oLkw==
X-Gm-Message-State: APjAAAUAn6Oj1lO64rl/193ddtdX25SG4Ad3zQ3oyo6wYpH0oCUvi94O
        me/VMiT+jKMOt36S0SuNFgUpUC7T10iOBTfOo68=
X-Google-Smtp-Source: APXvYqz76byp4qnIWDHxWDm0hXqdeZjTCC05P6cVLerv/vgLqSYiiQihgoQ+QW4LYTooCP+rT5Jb0Zi1n7UOQre2IX0=
X-Received: by 2002:a37:9c0f:: with SMTP id f15mr12934167qke.297.1575623000660;
 Fri, 06 Dec 2019 01:03:20 -0800 (PST)
MIME-Version: 1.0
References: <20191205155028.28854-1-maximmi@mellanox.com> <20191205155028.28854-5-maximmi@mellanox.com>
In-Reply-To: <20191205155028.28854-5-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 6 Dec 2019 10:03:09 +0100
Message-ID: <CAJ+HfNhQ7iEoJ2QTAcqJ+z7QK850f4X+59Mj5U62LB9=RgWsmg@mail.gmail.com>
Subject: Re: [PATCH bpf 4/4] net/ixgbe: Fix concurrency issues between config
 flow and XSK
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Dec 2019 at 16:52, Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>
> Use synchronize_rcu to wait until the XSK wakeup function finishes
> before destroying the resources it uses:
>
> 1. ixgbe_down already calls synchronize_rcu after setting __IXGBE_DOWN.
>
> 2. After switching the XDP program, call synchronize_rcu to let
> ixgbe_xsk_async_xmit exit before the XDP program is freed.
>
> 3. Changing the number of channels brings the interface down.
>
> 4. Disabling UMEM sets __IXGBE_TX_DISABLED before closing hardware
> resources and resetting xsk_umem. Check that bit in ixgbe_xsk_async_xmit
> to avoid using the XDP ring when it's already destroyed. synchronize_rcu
> is called from ixgbe_txrx_ring_disable.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 6 +++++-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 8 ++++++--
>  2 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 25c097cd8100..60503318c7e5 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -10273,8 +10273,12 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
>                             adapter->xdp_prog);
>         }
>
> -       if (old_prog)
> +       if (old_prog) {
> +               /* Wait until ndo_xsk_async_xmit completes. */
> +               synchronize_rcu();
> +
>                 bpf_prog_put(old_prog);
> +       }
>
>         /* Kick start the NAPI context if there is an AF_XDP socket open
>          * on that queue id. This so that receiving will start.
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> index d6feaacfbf89..b43be9f14105 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -709,10 +709,14 @@ int ixgbe_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
>         if (qid >= adapter->num_xdp_queues)
>                 return -ENXIO;
>
> -       if (!adapter->xdp_ring[qid]->xsk_umem)
> +       ring = adapter->xdp_ring[qid];
> +
> +       if (test_bit(__IXGBE_TX_DISABLED, &ring->state))
> +               return -ENETDOWN;
> +
> +       if (!ring->xsk_umem)

Pretty much same comment as in i40e. The synchronize_rcu() is not
needed, but the additional test is!

>                 return -ENXIO;
>
> -       ring = adapter->xdp_ring[qid];
>         if (!napi_if_scheduled_mark_missed(&ring->q_vector->napi)) {
>                 u64 eics = BIT_ULL(ring->q_vector->v_idx);
>
> --
> 2.20.1
>
