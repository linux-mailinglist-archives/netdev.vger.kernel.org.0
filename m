Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4348A47D7E0
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 20:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhLVTkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 14:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbhLVTkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 14:40:08 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1472C061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 11:40:08 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id q74so9655898ybq.11
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 11:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ByhyrA+gQN1smj3CEydGN1iM8/bcHpzwjcby6Oy7els=;
        b=eNbI+3wQCScMjqijgh5lW5BxvhViVNBiAu9usnz9dlZ6o0cDVlU+mXSkU9MGM7/uBi
         DJ8Ins1mk5VI3C+LUtiMIvByVuLC4mOagdJCbXoiyejkQMyl2IP8t8zQKGC19/XkZa6O
         Hn82luU/RbiOPqm8YL0b+cdxU5oNjlwr+JTBF5gYClGmB2zdMJM+jmlAHG1XBWQaHHlN
         KzfiRQovOqUoaPNAJP2+dRZtn8wfZWR1QNixwwSugKUuCNM2/E0SEJPDppm6LHikpJrv
         XfpJaBkt6sIp9zI04Yff3L9Crzqj8/PtbzoEjpxMYWFcc16Bf5x/zMUmK2235Re96+NV
         1Jrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ByhyrA+gQN1smj3CEydGN1iM8/bcHpzwjcby6Oy7els=;
        b=GCFxn2mVakySC7TsxRrCrb6jAv6tlwe2cQ/CtLsujL2q1Ur4pl+D3R40QhoOlKI0Av
         HSI/YHGeOHiqZkbZaAEGM0eRrrG6vlUxDsTNynWF2Rn7h2zubLDQG+ccld0LKm4Sul9b
         C1I/xh5CoBz3N0Myyjo5gDBM9Xhy3nVIsztZOb45qy0/EACVky7/rgffkixVn0arjzW+
         T+DM9JysSIWlm8AplP96vVBNzwl3mZjPbfUF+aXghKR01+Y8ezIM6T8lJJSrPF5oQHbv
         7OeXu0i+BeLKxOvnsKNb4CevW6KKCjyxTjIhkRk6GdY1cyDPV1cIa9gMCsAVB1Mxzhzr
         3o6A==
X-Gm-Message-State: AOAM533oHAfLS4Rf1HBINhMHP7hn1yCRhGnL83Mo3bXdvsbgnJzyV+sv
        j7BZQdgGepXTrslD9D+VgIXVoaqeNxtKFkq60dwcFqSjgMf5jQ==
X-Google-Smtp-Source: ABdhPJww8xGO72cFzm1Lzdj9IOhwj3yMrD1aQ9Cv/yoYaJ1FwZhjaJJyEw07G9bxzObsMsG9B0Cv81i36rfUmUhDLN0=
X-Received: by 2002:a25:9d82:: with SMTP id v2mr6308487ybp.383.1640202007355;
 Wed, 22 Dec 2021 11:40:07 -0800 (PST)
MIME-Version: 1.0
References: <b5f61c5602aab01bac8d711d8d1bfab0a4817db7.1640197544.git.pabeni@redhat.com>
In-Reply-To: <b5f61c5602aab01bac8d711d8d1bfab0a4817db7.1640197544.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 Dec 2021 11:39:56 -0800
Message-ID: <CANn89i+QsBm=BLmU8t=_0+4=WRNS=S1+DcUeL=+CMc44bixK9w@mail.gmail.com>
Subject: Re: [PATCH v2 net] veth: ensure skb entering GRO are not cloned.
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Ignat Korchagin <ignat@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 10:40 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> After commit d3256efd8e8b ("veth: allow enabling NAPI even without XDP"),
> if GRO is enabled on a veth device and TSO is disabled on the peer
> device, TCP skbs will go through the NAPI callback. If there is no XDP
> program attached, the veth code does not perform any share check, and
> shared/cloned skbs could enter the GRO engine.
>
> Ignat reported a BUG triggered later-on due to the above condition:
>
> [   53.970529][    C1] kernel BUG at net/core/skbuff.c:3574!
> [   53.981755][    C1] invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
> [   53.982634][    C1] CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.16.0-rc5+ #25
> [   53.982634][    C1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> [   53.982634][    C1] RIP: 0010:skb_shift+0x13ef/0x23b0
> [   53.982634][    C1] Code: ea 03 0f b6 04 02 48 89 fa 83 e2 07 38 d0
> 7f 08 84 c0 0f 85 41 0c 00 00 41 80 7f 02 00 4d 8d b5 d0 00 00 00 0f
> 85 74 f5 ff ff <0f> 0b 4d 8d 77 20 be 04 00 00 00 4c 89 44 24 78 4c 89
> f7 4c 89 8c
> [   53.982634][    C1] RSP: 0018:ffff8881008f7008 EFLAGS: 00010246
> [   53.982634][    C1] RAX: 0000000000000000 RBX: ffff8881180b4c80 RCX: 0000000000000000
> [   53.982634][    C1] RDX: 0000000000000002 RSI: ffff8881180b4d3c RDI: ffff88810bc9cac2
> [   53.982634][    C1] RBP: ffff8881008f70b8 R08: ffff8881180b4cf4 R09: ffff8881180b4cf0
> [   53.982634][    C1] R10: ffffed1022999e5c R11: 0000000000000002 R12: 0000000000000590
> [   53.982634][    C1] R13: ffff88810f940c80 R14: ffff88810f940d50 R15: ffff88810bc9cac0
> [   53.982634][    C1] FS:  0000000000000000(0000) GS:ffff888235880000(0000) knlGS:0000000000000000
> [   53.982634][    C1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   53.982634][    C1] CR2: 00007ff5f9b86680 CR3: 0000000108ce8004 CR4: 0000000000170ee0
> [   53.982634][    C1] Call Trace:
> [   53.982634][    C1]  <TASK>
> [   53.982634][    C1]  tcp_sacktag_walk+0xaba/0x18e0
> [   53.982634][    C1]  tcp_sacktag_write_queue+0xe7b/0x3460
> [   53.982634][    C1]  tcp_ack+0x2666/0x54b0
> [   53.982634][    C1]  tcp_rcv_established+0x4d9/0x20f0
> [   53.982634][    C1]  tcp_v4_do_rcv+0x551/0x810
> [   53.982634][    C1]  tcp_v4_rcv+0x22ed/0x2ed0
> [   53.982634][    C1]  ip_protocol_deliver_rcu+0x96/0xaf0
> [   53.982634][    C1]  ip_local_deliver_finish+0x1e0/0x2f0
> [   53.982634][    C1]  ip_sublist_rcv_finish+0x211/0x440
> [   53.982634][    C1]  ip_list_rcv_finish.constprop.0+0x424/0x660
> [   53.982634][    C1]  ip_list_rcv+0x2c8/0x410
> [   53.982634][    C1]  __netif_receive_skb_list_core+0x65c/0x910
> [   53.982634][    C1]  netif_receive_skb_list_internal+0x5f9/0xcb0
> [   53.982634][    C1]  napi_complete_done+0x188/0x6e0
> [   53.982634][    C1]  gro_cell_poll+0x10c/0x1d0
> [   53.982634][    C1]  __napi_poll+0xa1/0x530
> [   53.982634][    C1]  net_rx_action+0x567/0x1270
> [   53.982634][    C1]  __do_softirq+0x28a/0x9ba
> [   53.982634][    C1]  run_ksoftirqd+0x32/0x60
> [   53.982634][    C1]  smpboot_thread_fn+0x559/0x8c0
> [   53.982634][    C1]  kthread+0x3b9/0x490
> [   53.982634][    C1]  ret_from_fork+0x22/0x30
> [   53.982634][    C1]  </TASK>
>
> Address the issue by skipping the GRO stage for shared or cloned skbs.
> To reduce the chance of OoO, try to unclone the skbs before giving up.
>
> v1 -> v2:
>  - use avoid skb_copy and fallback to netif_receive_skb  - Eric
>
> Reported-by: Ignat Korchagin <ignat@cloudflare.com>
> Fixes: d3256efd8e8b ("veth: allow enabling NAPI even without XDP")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  drivers/net/veth.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index b78894c38933..117526f2437d 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -879,8 +879,12 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
>
>                         stats->xdp_bytes += skb->len;
>                         skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
> -                       if (skb)
> -                               napi_gro_receive(&rq->xdp_napi, skb);
> +                       if (skb) {
> +                               if (skb_shared(skb) || skb_unclone(skb, GFP_ATOMIC))
> +                                       netif_receive_skb(skb);
> +                               else
> +                                       napi_gro_receive(&rq->xdp_napi, skb);
> +                       }

Reviewed-by: Eric Dumazet <edumazet@google.com>

Note that the skb_shared(skb) case seems not practical :
This would imply the same skb could be queued multiple times,
meaning no skb field could be changed (skb->next, skb->prev....)

veth clears IFF_TX_SKB_SHARING after all.

>                 }
>                 done++;
>         }
> --
> 2.33.1
>
