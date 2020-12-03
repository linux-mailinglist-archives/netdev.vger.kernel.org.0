Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D68B2CCFF0
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 07:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbgLCG66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 01:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgLCG65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 01:58:57 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58F5C061A4D
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 22:58:17 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id h7so1623073pjk.1
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 22:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YsmUWAir1b5Cki8mRIguhpP0JOCeBAGFzmuzsMza7Bg=;
        b=Def33h22jTS2hyweuH6CldMV6vSSY54coAaTh/4noAeWWG+dtnOACR+W7TO0fz1suh
         zM80Lu9mTAr3Equ7nJ6saR/Cr8Xbpr1C9kCyIf+wz656UXHvlPMVpfSzH0Gycuz7ufAv
         TyeT/20NAAprLUW7NQXIYqq/drVWQfEKgFWN7My/hmdaKZ/Zuif9kH3XK65SVE6lpSC7
         gJnKjcZeOkP4fuBCs06cv+EwF0hnKL3TT84sXetU5WNcHU4zbssbymjZylItGlKfPig9
         vV6ml2Mg8AeZzOkklOQyP2Y/Ilv3lX9x7SphipFOYGcloFEGo2g81nKp1fUlThHV6FAD
         vCFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YsmUWAir1b5Cki8mRIguhpP0JOCeBAGFzmuzsMza7Bg=;
        b=dFSZL2kdogzSC9fr4gpFqoiI7k5JshnWzTuQ7dqbWowre4M93FqHmRGDQBRwJ8diUp
         2vxv3CcVFL+h01ypbikiXC5NLR52CtPIiuGEuz6w8vTMfDUCbx0GaO3/NnssEmSWRddv
         uTZKjkBuxA9xuM/8hz3g2GwZvoZdCKuB6bW7rcgcuqG1HHlbkYpGqGUdxxu1xuydA2Zk
         QPXxvIl1ndC+lTKeu60AZjDDsSHd9VxS3Pfp6f3GwXL6+skOdAkso9NAshhlxFORZFZ8
         lyf78mrWFQfSuy/jyN/Ia4xFNNdCg68uQu2rdNFJMAX6TKqYp5QAZKxyUSQXsF6M4kUu
         Diuw==
X-Gm-Message-State: AOAM5325W89EqyXo/UDZONsK98lz0Q0gg0AUdvJK7zUyHEkoRbZyKMyR
        MMNK3Vg2x+71pNoLpvN04dVHiI+p+G2qeg9QL7dzMa+sjTc6HQoT
X-Google-Smtp-Source: ABdhPJx+E1N0OEAyN6x4UdYwJstVEoeYMazJKS4KFK+eH868p3JFsnCe8ItLhA80rRSTM1sQ/U80s/BTqmELuy5i/xU=
X-Received: by 2002:a17:90a:8c4:: with SMTP id 4mr1762593pjn.204.1606978697290;
 Wed, 02 Dec 2020 22:58:17 -0800 (PST)
MIME-Version: 1.0
References: <20201202150724.31439-1-magnus.karlsson@gmail.com> <20201202204041.GA30907@ranger.igk.intel.com>
In-Reply-To: <20201202204041.GA30907@ranger.igk.intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 3 Dec 2020 07:58:06 +0100
Message-ID: <CAJ8uoz04dFruNnDDyvgbPBZBbMqZxHS6xQJ66dnoPLFtWXv0Uw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] i40e, ice, ixgbe: optimize for XDP_REDIRECT
 in xsk path
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        anthony.l.nguyen@intel.com,
        Network Development <netdev@vger.kernel.org>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 9:49 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Wed, Dec 02, 2020 at 04:07:21PM +0100, Magnus Karlsson wrote:
> > Optimize run_xdp_zc() for the XDP program verdict being XDP_REDIRECT
> > in the zsk zero-copy path. This path is only used when having AF_XDP
> > zero-copy on and in that case most packets will be directed to user
> > space. This provides around 100k extra packets in throughput on my
> > server when running l2fwd in xdpsock.
> >
> > Thanks: Magnus
>
> For series:
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>
> You only ate 'e' from i40e subject line.

Sorry, you are right. Tony, would you please be so kind to add this
missing "e" in the commit message before you send the pull request?

Thanks: Magnus

> >
> > Magnus Karlsson (3):
> >   i40: optimize for XDP_REDIRECT in xsk path
> >   ixgbe: optimize for XDP_REDIRECT in xsk path
> >   ice: optimize for XDP_REDIRECT in xsk path
> >
> >  drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 11 +++++++----
> >  drivers/net/ethernet/intel/ice/ice_xsk.c     | 12 ++++++++----
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 11 +++++++----
> >  3 files changed, 22 insertions(+), 12 deletions(-)
> >
> >
> > base-commit: 6b4f503186b73e3da24c6716c8c7ea903e6b74d4
> > --
> > 2.29.0
