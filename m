Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E64744CA42
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 21:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhKJUO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 15:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbhKJUO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 15:14:26 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B8BC061767
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 12:11:38 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id i12so2423921wmq.4
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 12:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OWTPgVJnueHkxFEIUf6VDXE+mQNwR15b3RG+2t+lLFg=;
        b=MuG2HGcxj8Fylb+z3NhMaag1UIicfo4w2QsrPK8ZYdEr09jxSz1wMqxA+cqfgwydA8
         KP1wuTX2jUXfWEaKe2ESxSu/4R8akg+wy+a/EETM1QX0vn+hp5xb9XoIpIfnrwaxaS7o
         OMRWa+L60bEYP9Eg9J69hFCg9YRf+9gh2swTAsNyjxQQtP/P+uLcCmw65kJcYLCnHw/W
         1D/lywOZVcXTXEvSkSbbztpuMvysZ/capmfrGRTr3vPKvKxxmFwVBAl2ziQeQpxC716q
         aI6nJic4PZFfK62fTXoFGSOR0BgSbu6RTAauGn3YJ/uPWnpdieX3sveqZ/8eE3xNPWjz
         b9Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OWTPgVJnueHkxFEIUf6VDXE+mQNwR15b3RG+2t+lLFg=;
        b=FU8bHPjBgzjago7aW8dlWKokIyCPZu3/z1hZ3SZ1k4V7s57pkq+SpILcNIXBPJUhyX
         t/dgcgjvGkF4oh7jrBmIoLDoKyJlV5g8DGogjacdrQvodI+sEPDGR25vImM59ewkYCfQ
         QMLELmR8wuuRv9zmkYkiqOUch9z1cWF4LMmWFsCB0DEZD/gS5AkRBMriaDPpvX/NN1Nj
         bePHRxAxpMn89Yc58bU3OoIlQuSRZDC1S3KoIdTcOmtvw5vzF/4I+XIbOEoLeLWwi/4R
         2vonPcVSNmHPa4lsTtbSYuMPIq+SjOyotjV6j/CaSyDFUo0WzAnPQZGKpym6JhP6vd+J
         Ey6g==
X-Gm-Message-State: AOAM53371qV+rjkWmj39mDKvZOD7qqM8hn3EDeZNQIXAOSg3iF2D27n+
        zndWmphipbGnPArx22v+Oglzy26g4PLRGkb/vtqPzQ==
X-Google-Smtp-Source: ABdhPJz2w1x4uMql2NaYrLepa+M24PkUgWoHHoR+u50R1U/HMBcQQRj4m13aigkD4Y2qp0d+kwFK6z+uilUBm/L8eNI=
X-Received: by 2002:a7b:c8c8:: with SMTP id f8mr2041010wml.49.1636575096439;
 Wed, 10 Nov 2021 12:11:36 -0800 (PST)
MIME-Version: 1.0
References: <20211110195605.1304-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211110195605.1304-1-alexandr.lobakin@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 10 Nov 2021 12:11:24 -0800
Message-ID: <CANn89i+67J4GNbWmpMf8ieFFRK5BuPRA=1Q83KU+9-gRvg+aGQ@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: fix premature exit from NAPI state polling in napi_disable()
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 11:56 AM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> Commit 719c57197010 ("net: make napi_disable() symmetric with
> enable") accidentally introduced a bug sometimes leading to a kernel
> BUG when bringing an iface up/down under heavy traffic load.
>
> Prior to this commit, napi_disable() was polling n->state until
> none of (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC) is set and then
> always flip them. Now there's a possibility to get away with the
> NAPIF_STATE_SCHE unset as 'continue' drops us to the cmpxchg()
> call with an unitialized variable, rather than straight to
> another round of the state check.
>

...

>
> [0] https://lore.kernel.org/netdev/20211110191126.1214-1-alexandr.lobakin@intel.com
>
> Fixes: 719c57197010 ("net: make napi_disable() symmetric with enable")
> Suggested-by: Eric Dumazet <edumazet@google.com> # for-loop
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---

Thanks a lot !
Reviewed-by: Eric Dumazet <edumazet@google.com>
