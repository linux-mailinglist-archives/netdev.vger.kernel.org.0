Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DACED99B20
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 19:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733098AbfHVRV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 13:21:27 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33242 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730997AbfHVRV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 13:21:26 -0400
Received: by mail-io1-f68.google.com with SMTP id z3so13513311iog.0;
        Thu, 22 Aug 2019 10:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aLr+sd5BMRYCClHI4smsxLPlBWSdoS3nfQ+XpNRCO6U=;
        b=bLz1UxSg3goHpLmdM1XGhxTgPMZasAb3H3QPWRN13W+SCAgmQtFI59RkBF9I1BoCJ3
         gfRTGkAtZBHs5sOF5tM7Khx4mYb3AP6M7MXD1f6xuIe8/SXnKS9oo6RYV4MIkKamVuru
         iVoY5Ljg7iov3VuRbjauI0Sg79O0/G3qyJde2n4wkKIl+nVzSEmRKCBB/Xn0DC0g39Um
         f/x0pzC3lDmi3nSbI6X+6MNSUMXbIPZ7/Z9BEpkck9KXUKhTqFXZ7gFl0cQT9jNgWi9/
         9BSNLwRyKkqqgogpRFtZkWxcmAqawm1GyV4bX/86wQZFTQ+ME0Q6GpJFGHPkG6DfwaOV
         5mfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aLr+sd5BMRYCClHI4smsxLPlBWSdoS3nfQ+XpNRCO6U=;
        b=CH4vkIMzBCzE7R5qYyDv8neBVUs3bnmISBIMKfI/9a6en9Zql5v+C6+5IOXKFTCFDA
         Heb4bxDonvtkfFT7ZCiJWOJcS3RWlExcmy/AXbRb9paNtxQMI9exR/m2LXTifhuCBsf/
         a2MSVYpkuYnM1hYydAcmV0nEIpndz0uGIQZkpxjH18TToupsTpc1pCaY8A/YXW586EK/
         yThtaBNLHAf0wZWALAEWSzqhk35gYkDqSOSlhsHZCPNpGg3mXWLggUm7WdoDgyGz2abs
         0jYFuQZiYn6GkgyVjyt0ZQgxAl4V377BjvCUcKSqXaLOxffR5vQpDYot3XM0nso8Dj1K
         yMqw==
X-Gm-Message-State: APjAAAX9jT/ojJqiNKAsDEMeU5cYtULPyfypXicAs/Cum98mIMffW+tv
        XnBXgq1nbQbyijvqYItexF3sh/G1UMK4DG/oHZY=
X-Google-Smtp-Source: APXvYqykF88NuCgoRLHTX/hVhk0s0dNsXSMT17jlWltng3t8DPaOm3ksoWuywjYftSzM8MoX7TQAYwNO1f30b9Sh0cI=
X-Received: by 2002:a5d:8908:: with SMTP id b8mr965993ion.237.1566494485368;
 Thu, 22 Aug 2019 10:21:25 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190822171243eucas1p12213f2239d6c36be515dade41ed7470b@eucas1p1.samsung.com>
 <20190822171237.20798-1-i.maximets@samsung.com>
In-Reply-To: <20190822171237.20798-1-i.maximets@samsung.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 22 Aug 2019 10:21:14 -0700
Message-ID: <CAKgT0UepBGqx=FiqrdC-r3kvkMxVAHonkfc6rDt_HVQuzahZPQ@mail.gmail.com>
Subject: Re: [PATCH net v3] ixgbe: fix double clean of tx descriptors with xdp
To:     Ilya Maximets <i.maximets@samsung.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 10:12 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>
> Tx code doesn't clear the descriptors' status after cleaning.
> So, if the budget is larger than number of used elems in a ring, some
> descriptors will be accounted twice and xsk_umem_complete_tx will move
> prod_tail far beyond the prod_head breaking the completion queue ring.
>
> Fix that by limiting the number of descriptors to clean by the number
> of used descriptors in the tx ring.
>
> 'ixgbe_clean_xdp_tx_irq()' function refactored to look more like
> 'ixgbe_xsk_clean_tx_ring()' since we're allowed to directly use
> 'next_to_clean' and 'next_to_use' indexes.
>
> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> ---
>
> Version 3:
>   * Reverted some refactoring made for v2.
>   * Eliminated 'budget' for tx clean.
>   * prefetch returned.
>
> Version 2:
>   * 'ixgbe_clean_xdp_tx_irq()' refactored to look more like
>     'ixgbe_xsk_clean_tx_ring()'.
>
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 29 ++++++++------------
>  1 file changed, 11 insertions(+), 18 deletions(-)

Thanks for addressing my concerns.

Acked-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
