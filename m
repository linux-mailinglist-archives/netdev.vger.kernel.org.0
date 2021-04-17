Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19D6362DC7
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 06:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbhDQEws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 00:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbhDQEwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 00:52:47 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D35C061756
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 21:52:20 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id x76so22421205ybe.5
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 21:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZTumkKaTkisDrVEGWZBcCaLBAoi1QTIBQo+X8LGcUjo=;
        b=dqt+EWPwP/WHYWqJzXJQaCIP4vGaehR/VRB2lgjPVk8f6udXtMxrtsqxBAQRnn+2du
         FFq/5FZzhd+1GIQlc1pjZH75sBWN8GmXnJWk3WYva1rK0Z02ExA/1zg5PCez/qJqHEZJ
         9M+CxqZHoMCB2/9U7W5BOLXXGy8DVb6h08oHQObnNjdWLz5vjUxIZ2O3VIdWG0X7rrqt
         5jrITktyp9P3xIOcgILsmGKMDjKGx3pyCAXOjT59CmmBgcuZWZwagWYU2HyjWNfznY4k
         EoM6klST9gvyvlooLCmqwgaRXJD6FmD2Cz478wqCwwWHf5JNynsm9BhBwn4/03dEgZBV
         brTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZTumkKaTkisDrVEGWZBcCaLBAoi1QTIBQo+X8LGcUjo=;
        b=jcI9Oh72ljugYHRD+Tdhy8I773yZNV1yNA55l2ceMVcs/lHBYXXHDDTBh9Ipz3LdbA
         bBIawJJMFvSlLFpH7tZRNaVrXvocGZQ+S4Q5wueH5AH+w3LGtQZLpmu0AoyIJsmxHKNu
         o4fsbjh4jaWWrvIOxtNN0aafEgX38+STCAPW61zcP460ruk86pBo//MvCLcFELVg+aCw
         J904qzDAHo3SOy09wvcki6YkhQcAeJyZwsg6pgG8q814J/WWMzuJZKbkl6H6L/EVAHbT
         vHVy1RGHqxy8cDG4azKcAuT0q8/boPa2NIV3+39k6Vso6K7vrr3AaRGVoQ7D+xwcIico
         SfwQ==
X-Gm-Message-State: AOAM5337KAaOE+I8Z5NEK3Lqob42VgYT1V/0leCAivIzvTQVFKx6UxSy
        anat69DEWxzCLOGEhTFHIABJkmk5Ymc8Uew3rnslTg==
X-Google-Smtp-Source: ABdhPJzOHMuvPMDpf/NEbRkxLKgUWWuCB5D8guocWOKZddbabl3/T7+vT3AyvwBChGIL+kpmmjkfnNIa3qUQzMkTaE8=
X-Received: by 2002:a25:7650:: with SMTP id r77mr3762283ybc.446.1618635139396;
 Fri, 16 Apr 2021 21:52:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210417000839.6618-1-xie.he.0141@gmail.com>
In-Reply-To: <20210417000839.6618-1-xie.he.0141@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 17 Apr 2021 06:52:08 +0200
Message-ID: <CANn89iLtsPHgaOdXxzeC61MEE96puObqOtuwCYmCAy3A79h7Yw@mail.gmail.com>
Subject: Re: [PATCH net] net/core/dev.c: Ensure pfmemalloc skbs are correctly
 handled when receiving
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Slaby <jslaby@suse.cz>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 2:08 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> When an skb is allocated by "__netdev_alloc_skb" in "net/core/skbuff.c",
> if "sk_memalloc_socks()" is true, and if there's not sufficient memory,
> the skb would be allocated using emergency memory reserves. This kind of
> skbs are called pfmemalloc skbs.
>
> pfmemalloc skbs must be specially handled in "net/core/dev.c" when
> receiving. They must NOT be delivered to the target protocol if
> "skb_pfmemalloc_protocol(skb)" is false.
>
> However, if, after a pfmemalloc skb is allocated and before it reaches
> the code in "__netif_receive_skb", "sk_memalloc_socks()" becomes false,
> then the skb will be handled by "__netif_receive_skb" as a normal skb.
> This causes the skb to be delivered to the target protocol even if
> "skb_pfmemalloc_protocol(skb)" is false.
>
> This patch fixes this problem by ensuring all pfmemalloc skbs are handled
> by "__netif_receive_skb" as pfmemalloc skbs.
>
> "__netif_receive_skb_list" has the same problem as "__netif_receive_skb".
> This patch also fixes it.
>
> Fixes: b4b9e3558508 ("netvm: set PF_MEMALLOC as appropriate during SKB processing")
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Eric B Munson <emunson@mgebm.net>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  net/core/dev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1f79b9aa9a3f..3e6b7879daef 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5479,7 +5479,7 @@ static int __netif_receive_skb(struct sk_buff *skb)
>  {
>         int ret;
>
> -       if (sk_memalloc_socks() && skb_pfmemalloc(skb)) {
> +       if (skb_pfmemalloc(skb)) {
>                 unsigned int noreclaim_flag;
>
>                 /*
> @@ -5507,7 +5507,7 @@ static void __netif_receive_skb_list(struct list_head *head)
>         bool pfmemalloc = false; /* Is current sublist PF_MEMALLOC? */
>
>         list_for_each_entry_safe(skb, next, head, list) {
> -               if ((sk_memalloc_socks() && skb_pfmemalloc(skb)) != pfmemalloc) {
> +               if (skb_pfmemalloc(skb) != pfmemalloc) {
>                         struct list_head sublist;
>
>                         /* Handle the previous sublist */
> --
> 2.27.0
>

The race window has been considered to be small that we prefer the
code as it is.

The reason why we prefer current code is that we use a static key for
the implementation
of sk_memalloc_socks()

Trading some minor condition (race) with extra cycles for each
received packet is a serious concern.

What matters is a persistent condition that would _deplete_ memory,
not for a dozen of packets,
but thousands. Can you demonstrate such an issue ?
