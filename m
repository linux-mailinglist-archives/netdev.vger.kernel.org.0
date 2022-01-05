Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D298E485A4E
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 21:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244249AbiAEUz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 15:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244239AbiAEUzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 15:55:52 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87898C061245;
        Wed,  5 Jan 2022 12:55:52 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id w7so461473plp.13;
        Wed, 05 Jan 2022 12:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cBznVAld5K088tv2SFB3Jx7CG3DaWx7P5YgQ6E60k30=;
        b=ZX/ipq78Z/qT9BexoxBGBt5nTLa4YCb42OcArXJsesE/Zc06YCebybONJaio6L+MHV
         RrKMTV0quo8yrORE3OAi6FzWVIE5kapedqd11p8wYxmMTIxa3yFRFpEXdp7qo8cWT6S1
         stc6p+J+GXDmzOW3RoakGC1HvscyK+bASVbQeDPSQwfwWnCjnfe4XzWg5d4hVKFh5eQd
         7NjXOsK56kIwBW5Rp5oiUSREcMEq+ekabMU0gwSm7LwKpbTqrezacOEi9ujQOQmNSNbL
         MpaJ3rDOB4pQWrdN+jfNTX42DuVfFbY0u2jxfgDpN2SCrU8QtP8QFJDX0st4Tz9tpnjK
         SfMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cBznVAld5K088tv2SFB3Jx7CG3DaWx7P5YgQ6E60k30=;
        b=smFvlVa7xsWrLeSp0yCIFpKTl9bUyGVZwNOaqHXnFk5UVMiAEqRmp0Y11G2vQb5TMQ
         Rm3y8o0Rr8PAahAo8AVhar7J/13XNeFN+XduiQEvdGPdo1/4fI6ARtuG0kdhm0t6IUx8
         pqgixBQHE2sGjw8zlSogEYbNyWoxQ9zXhgw0+nsbw/um5lIulVkL+mkGH9OHjOh1nYnP
         ckQJ/8Vo+FklthCVm32H6Jp5VS++u7SBsckMj/U9XDAX0U9n6O4Ce6Qm96vBZdc9zNVB
         AnvJCShCAD3Q2KNoID0lRo+oZW3Z502nzlpOSUo34+5+6Rr2VddglLZDURIgoFXqmhHD
         pCUA==
X-Gm-Message-State: AOAM533AoU+Tf1lUP16amutVzrk9BgQIcRI7U/C/1uzcjhyjly3J3Ji+
        p8tsc8Y36XdKPyKH7e7MGQ5qG85vebZSvQV2Afw=
X-Google-Smtp-Source: ABdhPJyeNoxNyXrXYGhHTjrkUMnCGi/lEoxOeWAFRzdO51AMks+q6og/kJz9AUDfPKek229TrSxKU1boMr21vQh+3Ms=
X-Received: by 2002:a17:902:c443:b0:148:f689:d924 with SMTP id
 m3-20020a170902c44300b00148f689d924mr55310145plm.78.1641416151921; Wed, 05
 Jan 2022 12:55:51 -0800 (PST)
MIME-Version: 1.0
References: <20211216135958.3434-1-maciej.fijalkowski@intel.com>
 <20211216135958.3434-4-maciej.fijalkowski@intel.com> <20211229131131.1460702-1-alexandr.lobakin@intel.com>
 <Yc2wZvfA8qr/XB8P@boxer> <20211230160755.26019-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211230160755.26019-1-alexandr.lobakin@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 5 Jan 2022 12:55:40 -0800
Message-ID: <CAADnVQKjGykDYuCS=LQJ3g0brWACpMyaKjgQ9qm4szxHOLXV=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/4] ice: xsk: improve AF_XDP ZC Tx and use
 batching API
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 8:09 AM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Date: Thu, 30 Dec 2021 14:13:10 +0100
>
> > On Wed, Dec 29, 2021 at 02:11:31PM +0100, Alexander Lobakin wrote:
> > > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > Date: Thu, 16 Dec 2021 14:59:57 +0100
> > >
> > > > Follow mostly the logic from commit 9610bd988df9 ("ice: optimize XDP_TX
> > > > workloads") that has been done in order to address the massive tx_busy
> > > > statistic bump and improve the performance as well.
> > > >
> > > > Increase the ICE_TX_THRESH to 64 as it seems to work out better for both
> > > > XDP and AF_XDP. Also, separating the stats structs onto separate cache
> > > > lines seemed to improve the performance. Batching approach is inspired
> > > > by i40e's implementation with adjustments to the cleaning logic.
> > > >
> > > > One difference from 'xdpdrv' XDP_TX is when ring has less than
> > > > ICE_TX_THRESH free entries, the cleaning routine will not stop after
> > > > cleaning a single ICE_TX_THRESH amount of descs but rather will forward
> > > > the next_dd pointer and check the DD bit and for this bit being set the
> > > > cleaning will be repeated. IOW clean until there are descs that can be
> > > > cleaned.
> > > >
> > > > It takes three separate xdpsock instances in txonly mode to achieve the
> > > > line rate and this was not previously possible.
> > > >
> > > > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > > ---
> > > >  drivers/net/ethernet/intel/ice/ice_txrx.c |   2 +-
> > > >  drivers/net/ethernet/intel/ice/ice_txrx.h |   4 +-
> > > >  drivers/net/ethernet/intel/ice/ice_xsk.c  | 249 ++++++++++++++--------
> > > >  drivers/net/ethernet/intel/ice/ice_xsk.h  |  26 ++-
> > > >  4 files changed, 182 insertions(+), 99 deletions(-)
> > > >
> > >
> > > -- 8< --
> > >
> > > > diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
> > > > index 4c7bd8e9dfc4..f2eb99063c1f 100644
> > > > --- a/drivers/net/ethernet/intel/ice/ice_xsk.h
> > > > +++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
> > > > @@ -6,19 +6,36 @@
> > > >  #include "ice_txrx.h"
> > > >  #include "ice.h"
> > > >
> > > > +#define PKTS_PER_BATCH 8
> > > > +
> > > > +#ifdef __clang__
> > > > +#define loop_unrolled_for _Pragma("clang loop unroll_count(8)") for
> > > > +#elif __GNUC__ >= 4
> > > > +#define loop_unrolled_for _Pragma("GCC unroll 8") for
> > > > +#else
> > > > +#define loop_unrolled_for for
> > > > +#endif
> > >
> > > It's used in a bunch more places across the tree, what about
> > > defining that in linux/compiler{,_clang,_gcc}.h?
> > > Is it possible to pass '8' as an argument? Like
> >
> > Like where besides i40e? I might currently suck at grepping, let's blame
> > christmas break for that.
>
> Ah okay, I confused it with a work around this pragma here: [0]
>
> >
> > If there are actually other callsites besides i40e then this is a good
> > idea to me, maybe as a follow-up?
>
> I think there are more potential call sites for that to come, I'd
> make linux/unroll.h in the future I guess. But not as a part of
> this series, right.

Please don't, since loop unroll pragma is a hint.
The compilers don't have to actually do the unroll.
Both gcc and clang try to do it when it looks ok-ish from
compiler perspective, but they don't have to.
Try large unroll values and check the code.
Ideally add compiler debug flags, so it can tell what it's actually doing.
It's hard to figure out loop unroll factor looking at the assembly.
