Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDDD1ADCF6
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 14:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgDQMJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 08:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgDQMJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 08:09:36 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5FDC061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 05:09:36 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id i2so920778ybk.2
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 05:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J2VwpMHDruurLAkZ8tY6Y0C7uBDHQtpeGJUXXg0TbCk=;
        b=TPe89O3WSr/0OH6HO4NM2orfODdxqxCbcRNtiMBsx69+KaPhsi6mSA5fw30Ynq6afU
         Dv1Mh3mbXTo4tqLpAAW5ufSaduq3w6NbAOmB4ZHFC4ReYbVLYyTphRQhKpAbyrRL0ooe
         7+n9bJ55mAOZilft0Mdo6fyk8WuOAB7W+bc7griIAROVqz0A9D53DlmD0vbZAFfVJ542
         jfYkjYop5J0jVDgXnK8by7eJfz3oSirjSkk2SlxWjLWTnIG4DGyYghJ/NJPpif3JVIBX
         CkYot+0vhaRxU5adCxyZmtx8+/11LIn3+Owwfs4HEYI522S82CqjIFvU2iINC46fWEsa
         Qw9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J2VwpMHDruurLAkZ8tY6Y0C7uBDHQtpeGJUXXg0TbCk=;
        b=HXfgY5u4h5p5IxNIVgOQnHQ5V0BXvswiGEy5acGLbxwyMIkoYniQ9eACY0oNfSBt5o
         1jsbKnSuYPZO0tZVp6oq2MkKL+erGvCtxbk+UzlckMuYGFDn9u7PbIcUcUmJ2OZCVHd3
         vmGH9U2FHm5vg6V16uanchSa71HV0yoIezVbTKXCyOC7CLYMV4rrenmsc6+gFALvtub+
         PwsqWvgq1AI4piKPrYuJ63SSq/J6nxujpFqGdcftwiEA4C196bGXJk97BaY/q8ADWHW7
         /B26/d3DSxCaM+kA26ZdfZJMV+KIFZM2OmGkH9RAK8qX5qat6mca6P1fSsiI2KyRbZBg
         gpug==
X-Gm-Message-State: AGi0PuZTRm2/8Ix24MnBL+HvTbyoHSBB5vVI6nBajoA3wc8Haw+OvyaW
        woPVKyvKgJWMtJajXDWYkt/cvn2hVU9VGpPWzIQjYg==
X-Google-Smtp-Source: APiQypLDw76Jv74Z0sxM1XlJHRn2lM/dlcSYQXGQGn0B65cU9pX+gBSoy+DBB0Qg2EY4F9CQFw23db/094gyIEf2Css=
X-Received: by 2002:a5b:58a:: with SMTP id l10mr5294503ybp.173.1587125374855;
 Fri, 17 Apr 2020 05:09:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200415164652.68245-1-edumazet@google.com> <761fa4422e5576b087c8e6d26a9046126f5dff2f.camel@mellanox.com>
In-Reply-To: <761fa4422e5576b087c8e6d26a9046126f5dff2f.camel@mellanox.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 17 Apr 2020 05:09:23 -0700
Message-ID: <CANn89i+Vs63kwJZXXHTvhnNgDLPsPmXzJ99pSD5GimXd5Qt0EA@mail.gmail.com>
Subject: Re: [PATCH net-next] net/mlx4_en: avoid indirect call in TX completion
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "willemb@google.com" <willemb@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 8:55 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> On Wed, 2020-04-15 at 09:46 -0700, Eric Dumazet wrote:
> > Commit 9ecc2d86171a ("net/mlx4_en: add xdp forwarding and data write
> > support")
> > brought another indirect call in fast path.
> >
> > Use INDIRECT_CALL_2() helper to avoid the cost of the indirect call
> > when/if CONFIG_RETPOLINE=y
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Tariq Toukan <tariqt@mellanox.com>
> > Cc: Willem de Bruijn <willemb@google.com>
> > ---
>
> Hi Eric, I believe net-next is still closed.
>
> But FWIW,
>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
>

Well, this can be pushed to net then, since this is a trivial patch
that helps performance.

With this COVID-19 thing, we need more capacity from the serving fleet
(Youtube and all..)
distributed all over the world and using a high number of CX-3 NIC.

Thanks.


>
> >  drivers/net/ethernet/mellanox/mlx4/en_tx.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> > b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> > index
> > 4d5ca302c067126b8627cb4809485b45c10e2460..a30edb436f4af11526e04c09623
> > 840288ebe4a29 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> > @@ -43,6 +43,7 @@
> >  #include <linux/ip.h>
> >  #include <linux/ipv6.h>
> >  #include <linux/moduleparam.h>
> > +#include <linux/indirect_call_wrapper.h>
> >
> >  #include "mlx4_en.h"
> >
> > @@ -261,6 +262,10 @@ static void mlx4_en_stamp_wqe(struct
> > mlx4_en_priv *priv,
> >       }
> >  }
> >
> > +INDIRECT_CALLABLE_DECLARE(u32 mlx4_en_free_tx_desc(struct
> > mlx4_en_priv *priv,
> > +                                                struct
> > mlx4_en_tx_ring *ring,
> > +                                                int index, u64
> > timestamp,
> > +                                                int napi_mode));
> >
> >  u32 mlx4_en_free_tx_desc(struct mlx4_en_priv *priv,
> >                        struct mlx4_en_tx_ring *ring,
> > @@ -329,6 +334,11 @@ u32 mlx4_en_free_tx_desc(struct mlx4_en_priv
> > *priv,
> >       return tx_info->nr_txbb;
> >  }
> >
> > +INDIRECT_CALLABLE_DECLARE(u32 mlx4_en_recycle_tx_desc(struct
> > mlx4_en_priv *priv,
> > +                                                   struct
> > mlx4_en_tx_ring *ring,
> > +                                                   int index, u64
> > timestamp,
> > +                                                   int napi_mode));
> > +
> >  u32 mlx4_en_recycle_tx_desc(struct mlx4_en_priv *priv,
> >                           struct mlx4_en_tx_ring *ring,
> >                           int index, u64 timestamp,
> > @@ -449,7 +459,9 @@ bool mlx4_en_process_tx_cq(struct net_device
> > *dev,
> >                               timestamp = mlx4_en_get_cqe_ts(cqe);
> >
> >                       /* free next descriptor */
> > -                     last_nr_txbb = ring->free_tx_desc(
> > +                     last_nr_txbb = INDIRECT_CALL_2(ring-
> > >free_tx_desc,
> > +                                                    mlx4_en_free_tx_
> > desc,
> > +                                                    mlx4_en_recycle_
> > tx_desc,
> >                                       priv, ring, ring_index,
> >                                       timestamp, napi_budget);
> >
