Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08221114DFB
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 10:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfLFJDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 04:03:19 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37535 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfLFJDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 04:03:19 -0500
Received: by mail-qt1-f194.google.com with SMTP id w47so6506585qtk.4;
        Fri, 06 Dec 2019 01:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NSnp1F1eiqqOQQa5ixU1Izrumj5P9RZf5bIJmaqc2cs=;
        b=KXl3ijaN2ackTyhmmSc0GBFN7DcLPOmhE5jmi5a1DuBEf78B3N1FG4qNXtli0OZG6k
         6gbqnzBOHm0xeVlFwXNdtBoonjosI0Zi0wNhgiCq2DJ6iSeF3Du2DH65l/fZGA/gJ8SY
         roxCAw/LGBrh8KgO1vkP02sgUQC9QGG5QLHaU7rE9FwXsHMySztQwxzeXwmzeqEQelMD
         wKx9Ec2WDKcddo0JW9myXmkFqYdkQf5O1a93ea7y1S1Lvgg3JW3Q+VkrYs/x623T8jny
         TZl+pKxbyVz1s8O0WAzHTUd75U4b31aSin5E0do/rZA7QMaCRInVlWS+Cyo/cUjJKZt6
         HnJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NSnp1F1eiqqOQQa5ixU1Izrumj5P9RZf5bIJmaqc2cs=;
        b=V0sfp/DC5C5OyYwYXiPylV2+DiBIdEa3eJz6YC6sq6mbx2+Z0piLkQiSeXuk1gKzzn
         PJju9C/m7cEg7NHh6R3kkLBlZA9E1ri0vNp2T+nnOlqImHbc5eBlGjq+TO1q19E88cz8
         IYr/+rOwoRHePDqr1rA291dOd1Nuy5UUBukXnO3aPWY+efd3SFEegP1w7daPzJ77SGwd
         x5gS8nkDlVgrAYNfN4Z2h+N7G+qfHkdMUewUoBk55tGB5KCvUFxyfs5dZWvONel8a6yj
         ol9r/v3wucnrDJ+qYxacr3p45J1bFl7MsLZZymNCR1cSJvP1nHCjf6uGNpyXlop7H/tw
         oMmw==
X-Gm-Message-State: APjAAAXDBYrXMLXtCHB0pniFgXcnP6S2X8rQMeD3aEGmcrwm47rbJG3x
        KS+3kZSv9R+FahikRZDH8iEEWXULm28yfe5MH7A=
X-Google-Smtp-Source: APXvYqy36Txmetid8jTIeyTmt/N0w69VPWXz8/aOWLeVHWm7ezZkcjneOM8kuTe0whvQ2JqpsWwxUJkXB/bqtBLR3Oo=
X-Received: by 2002:ac8:1bed:: with SMTP id m42mr11921618qtk.359.1575622997936;
 Fri, 06 Dec 2019 01:03:17 -0800 (PST)
MIME-Version: 1.0
References: <20191205155028.28854-1-maximmi@mellanox.com> <20191205155028.28854-4-maximmi@mellanox.com>
In-Reply-To: <20191205155028.28854-4-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 6 Dec 2019 10:03:06 +0100
Message-ID: <CAJ+HfNiXPo_Qkja=tCakX6a=swVY_KRMXmT79wQuQa_+kORQ=g@mail.gmail.com>
Subject: Re: [PATCH bpf 3/4] net/i40e: Fix concurrency issues between config
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
> 1. i40e_down already calls synchronize_rcu. On i40e_down either
> __I40E_VSI_DOWN or __I40E_CONFIG_BUSY is set. Check the latter in
> i40e_xsk_async_xmit (the former is already checked there).
>
> 2. After switching the XDP program, call synchronize_rcu to let
> i40e_xsk_async_xmit exit before the XDP program is freed.
>
> 3. Changing the number of channels brings the interface down (see
> i40e_prep_for_reset and i40e_pf_quiesce_all_vsi).
>
> 4. Disabling UMEM sets __I40E_CONFIG_BUSY, too.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 7 +++++--
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 4 ++++
>  2 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 1ccabeafa44c..afa3a99e68e1 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -6823,8 +6823,8 @@ void i40e_down(struct i40e_vsi *vsi)
>         for (i = 0; i < vsi->num_queue_pairs; i++) {
>                 i40e_clean_tx_ring(vsi->tx_rings[i]);
>                 if (i40e_enabled_xdp_vsi(vsi)) {
> -                       /* Make sure that in-progress ndo_xdp_xmit
> -                        * calls are completed.
> +                       /* Make sure that in-progress ndo_xdp_xmit and
> +                        * ndo_xsk_async_xmit calls are completed.
>                          */
>                         synchronize_rcu();
>                         i40e_clean_tx_ring(vsi->xdp_rings[i]);
> @@ -12545,6 +12545,9 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
>                 i40e_prep_for_reset(pf, true);
>
>         old_prog = xchg(&vsi->xdp_prog, prog);
> +       if (old_prog)
> +               /* Wait until ndo_xsk_async_xmit completes. */
> +               synchronize_rcu();

This is not needed -- please correct me if I'm missing something! If
we're disabling XDP, the need_reset-clause will take care or the
proper synchronization. And we don't need to worry about old_prog for
the swap-XDP case, because bpf_prog_put() does cleanup with
call_rcu().


>
>         if (need_reset)
>                 i40e_reset_and_rebuild(pf, true, true);
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> index d07e1a890428..f73cd917c44f 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -787,8 +787,12 @@ int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
>  {
>         struct i40e_netdev_priv *np = netdev_priv(dev);
>         struct i40e_vsi *vsi = np->vsi;
> +       struct i40e_pf *pf = vsi->back;
>         struct i40e_ring *ring;
>
> +       if (test_bit(__I40E_CONFIG_BUSY, pf->state))
> +               return -ENETDOWN;
> +

You right that we need to check for BUSY, since the XDP ring might be
stale! Thanks for catching this! Can you respin this patch, with just
this hunk? (Unless I'm wrong! :-))



>         if (test_bit(__I40E_VSI_DOWN, vsi->state))
>                 return -ENETDOWN;
>
> --
> 2.20.1
>
