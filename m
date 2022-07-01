Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C57F5630CB
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 11:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbiGAJ6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 05:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbiGAJ6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 05:58:04 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C859874DDC
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 02:58:03 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-3137316bb69so18161687b3.10
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 02:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8iWWk/hgkV8wOLDzOpBeJQKLT4DJagEdptWHyoqwqBY=;
        b=FANPRJpiv4CVOn86XMcd9xl4Badvusn8OsWz99MIc9GZ6pHE8n1cTcTmd77FpuUQnY
         okMMc+CCqjkQVHtZkRVLQ/HJyh3z+lG7GZ2ItFCvUMUgD97I0Mw3gw7nxx7zMNvBLYtk
         bw2mWFqQdgPrGofIaDRFtiBFzrP4qiXzBBzce757cmFDpLteUcEQdM3Nl16clcJEBaku
         TRjOgrpIHaC4FgJ3nFPcFb3jgPK6Z4mkfpPM9DIZLaTWDEa07yJvATR83sjYbVKQFdUy
         526eOdlX3+6eCIKgGwuJRiSfxeuY2YH93OSGBMMPNMTiwA4Roj4rWAUH6Kb41twXoGYK
         SLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8iWWk/hgkV8wOLDzOpBeJQKLT4DJagEdptWHyoqwqBY=;
        b=RFcIkq2VhxgSRUv7DbXbBsYXoqSL5zOL14UzoYRsveJKqT3usGMye72Pa0TANcZeSH
         bzKxW5A2YbLgyNsYY+EK0j27d0RMKLItLOJuvAyVdrEG90WZt3OYtuujP2HqcioxQSkG
         7RlqRG0l04awX41jYTDfjH0Xiu0wyegLwICcyLGrvOkxGxETx7mtMFoUjeyx1dxjEjRy
         m2Ys6UsrEZIyMPyf8cAoe1NgftsFFBxkSTDkiXa230Yuy+JuLUqZwsxXOox1QhtazwgA
         1LK8IWqlq1LGvKozrXHIFaWi3Ny9fdOPJufF2Icm3zmPQwlwnTyiGTbaVRP3fpXk3Uft
         zhXQ==
X-Gm-Message-State: AJIora9jQXYScE22HnK9ObbZ9J6ikUCY9ZBYBhy7BjgLHMGRWp5BbBR/
        z12CtsWrqUwvKdF7qK+JC1RPT023A7GHsx4baz5WUw==
X-Google-Smtp-Source: AGRyM1veLeHzsoTk/7wuqo+G4A5bgwzl83EdSc/CE62rjHNmBQbSEr+9Q9ry1NmfYA2qehE1oXVH2Lx6yx5IUZDNUwE=
X-Received: by 2002:a81:9b93:0:b0:317:8c9d:4c22 with SMTP id
 s141-20020a819b93000000b003178c9d4c22mr15436316ywg.278.1656669482740; Fri, 01
 Jul 2022 02:58:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220701094256.1970076-1-johan.almbladh@anyfinetworks.com>
In-Reply-To: <20220701094256.1970076-1-johan.almbladh@anyfinetworks.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 1 Jul 2022 11:57:51 +0200
Message-ID: <CANn89i+FZ7t6F6tA8iFMjAzGmKkK=A+kdFpsm6ioygg5DnwT8g@mail.gmail.com>
Subject: Re: [PATCH bpf] xdp: Fix spurious packet loss in generic XDP TX path
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, song@kernel.org,
        martin.lau@linux.dev, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>, haoluo@google.com,
        jolsa@kernel.org, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 1, 2022 at 11:43 AM Johan Almbladh
<johan.almbladh@anyfinetworks.com> wrote:
>
> The byte queue limits (BQL) mechanism is intended to move queuing from
> the driver to the network stack in order to reduce latency caused by
> excessive queuing in hardware. However, when transmitting or redirecting
> a packet with XDP, the qdisc layer is bypassed and there are no
> additional queues. Since netif_xmit_stopped() also takes BQL limits into
> account, but without having any alternative queuing, packets are
> silently dropped.
>
> This patch modifies the drop condition to only consider cases when the
> driver itself cannot accept any more packets. This is analogous to the
> condition in __dev_direct_xmit(). Dropped packets are also counted on
> the device.

This means XDP packets are able to starve other packets going through a qdisc,
DDOS attacks will be more effective.

in-driver-XDP use dedicated TX queues, so they do not have this
starvation issue.

This should be mentioned somewhere I guess.

>
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>  net/core/dev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 8e6f22961206..41b5d7ac5ec5 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4875,10 +4875,12 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
>         txq = netdev_core_pick_tx(dev, skb, NULL);
>         cpu = smp_processor_id();
>         HARD_TX_LOCK(dev, txq, cpu);
> -       if (!netif_xmit_stopped(txq)) {
> +       if (!netif_xmit_frozen_or_drv_stopped(txq)) {
>                 rc = netdev_start_xmit(skb, dev, txq, 0);
>                 if (dev_xmit_complete(rc))
>                         free_skb = false;
> +       } else {
> +               dev_core_stats_tx_dropped_inc(dev);
>         }
>         HARD_TX_UNLOCK(dev, txq);
>         if (free_skb) {
> --
> 2.30.2
>
