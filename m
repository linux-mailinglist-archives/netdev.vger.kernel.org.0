Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A8047D76A
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 20:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345061AbhLVTIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 14:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbhLVTIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 14:08:36 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443DFC061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 11:08:36 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id x6so4108713iol.13
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 11:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7aRCdYCYOuBvgMz6GBu6vKLj8NEL8AILIdLITQaHbmE=;
        b=RX4ENsBGO73oI46ldOWx/36+v5SRIixkmutGkFNGuI3jCVktbSEtFpY3H0eY1U/ZMu
         v05ew9tNOQWwSy6LJ0q/OAZr7MiVPgWBlM25a9+C8+fsWmDsqBkHvckpuN7dCnjgAR/A
         IKFpf/NpXM9wLZnbgHsAHY2TBbRnhkS8dOE+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7aRCdYCYOuBvgMz6GBu6vKLj8NEL8AILIdLITQaHbmE=;
        b=XdY9ohypfoul+QI++JcDnuaHyW8PpEk109kK2Y9BTkZarJ54MyVfz4PgAC4VG9x4kI
         7H2M0Pc8mGO+7Sd2sL1t+IJWSVOXeqHaJe+QSxdS4cmTJ8ievb0E5ZGg82cw1XblwmME
         bsWYsUBpajL8euH+/NPq2Vj3WbhY+nq7akUtPUHSBoQ0k7l963NmMOSiKOBzHA9e4BZZ
         IBIUvsiCnpcUqt1cFGeGM0Q5pQIonmnwLm+NKi8q1IaqCfiFN8yr71/mAplNJEjHCyOw
         HgCDnMLVwn7mWAMnWOHm5CS5qqbkQrD05qxyhW046TZdbJMzvPP/J6xo53PYlI+OL0CG
         iozg==
X-Gm-Message-State: AOAM530TWJiKqWtvupo1k+bJAzxRuCVQfioueYAHe+AapUOLAL0utugp
        hAjftCePOXNMatefoD483pEJXsz51Uh57UStS1rClQ==
X-Google-Smtp-Source: ABdhPJzMt8DkdAaevZI8L4OoPGoGBFwAkCGOcli5wbsFzMLq83jWNJktN1upPr/Eo4XRQOKR0GkbDA/NuD4xJ94Gems=
X-Received: by 2002:a05:6638:d89:: with SMTP id l9mr2587014jaj.80.1640200114788;
 Wed, 22 Dec 2021 11:08:34 -0800 (PST)
MIME-Version: 1.0
References: <b5f61c5602aab01bac8d711d8d1bfab0a4817db7.1640197544.git.pabeni@redhat.com>
In-Reply-To: <b5f61c5602aab01bac8d711d8d1bfab0a4817db7.1640197544.git.pabeni@redhat.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Wed, 22 Dec 2021 19:08:23 +0000
Message-ID: <CALrw=nH-qZQEr6Hj7yL6FA9fDS3ZSd6go6_RbwoEAicVnU6pXw@mail.gmail.com>
Subject: Re: [PATCH v2 net] veth: ensure skb entering GRO are not cloned.
To:     Paolo Abeni <pabeni@redhat.com>, netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 6:40 PM Paolo Abeni <pabeni@redhat.com> wrote:
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
Tested-by: Ignat Korchagin <ignat@cloudflare.com>
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
>                 }
>                 done++;
>         }
> --
> 2.33.1
>
