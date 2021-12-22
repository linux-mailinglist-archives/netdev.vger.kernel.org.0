Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264F047CC21
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 05:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242401AbhLVEcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 23:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242396AbhLVEcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 23:32:06 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FCFC061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 20:32:06 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id e136so2784954ybc.4
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 20:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dWuHrxtoi84W/Y7YmqPSSeCXXglxNwhHt2w0/oD8cjg=;
        b=tgSuIc8Na4hNr4PBivkk7dpnnIBGyucisfW3ipzzDs1FZhD8UCeWgkYKQdu5e+Vvwv
         qsWgaeE1GFde3SMYKnij5o8tyn0l/n267C/stB4OlBzmTium8enymipnHcU1BxbXeIJ9
         gjfPmkzagCI2BHVwnz6OYJAPvvcHeUgAA6cUNaAwIC0/Wg2N9xMkgrx9Ia99AWZ4nQVh
         JtEk5ZvxN/OoaKbjKb5ZQsz9I60MCQyMgEwK+4G73/TmGZcGLUnuq9gx1qDrffYLiUNS
         MZwKD4n3PO1JriyX9MHnDnLDKFrvQdP7jMrO/qmFF5JkZI3WJJOnAMLT0kLLH/9yB+wV
         3x3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dWuHrxtoi84W/Y7YmqPSSeCXXglxNwhHt2w0/oD8cjg=;
        b=e09aHenIPhGTIuORk4WzQzPCiSBM08/1GadOuIksQ8lBhe8ciAzg0hz9Vo6mQ6EY9X
         vFrWE/J86ui5Ec1nEic15+RdHwNCBn/Eni3SEkDZK8+J3hW9bpizCTtaIw6XaEBiO1l7
         V7vgqr2xLoPxbCoiEq61QLQPw2gMFMcyBe0bexGvNgoM4j+ZkWVVUCXqqeHVZinpFHSw
         BXJLG26knMhXq4JLAAvOGUBAY9OBj+rIYGbWTOfIoHKVS7Cmi6dOWjKSVx1RQs21tlN/
         1rHl6pBLLiZTJJFjy2Rmy7ojTttLo68Eez+w0vzyiV1B8Ye1u6xcZfzb4nd0Ma5H31VF
         6e+A==
X-Gm-Message-State: AOAM5308iJav9PdOo5/zw59iLI5ZUfN62+Os+zw09oroGMR/xX6nVuuq
        Ae0yoCWf0q9aGpyVE3wN4rhTtQZU/RXbw5fWLJs2jQ==
X-Google-Smtp-Source: ABdhPJxQ0XH06YMk0/plrox+FtCo/CGXENwULxd/2B+0wnvVmqwvMvZD0z88sii4a5J3uLdhQ7HbFOpBNCf98cSunXs=
X-Received: by 2002:a25:2344:: with SMTP id j65mr1956551ybj.293.1640147525370;
 Tue, 21 Dec 2021 20:32:05 -0800 (PST)
MIME-Version: 1.0
References: <26109603287b4d21545bec125e43b218b545b746.1640111022.git.pabeni@redhat.com>
In-Reply-To: <26109603287b4d21545bec125e43b218b545b746.1640111022.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 21 Dec 2021 20:31:53 -0800
Message-ID: <CANn89iKpiQzW1UnsQSYzULJ8d-QHsy7Wz=NtgvVXBqh-iuNptQ@mail.gmail.com>
Subject: Re: [PATCH net] veth: ensure skb entering GRO are not cloned.
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Ignat Korchagin <ignat@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 1:34 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> After commit d3256efd8e8b ("veth: allow enabling NAPI even without XDP"),
> if GRO is enabled on a veth device and TSO is disabled on the peer
> device, TCP skbs will go through the NAPI callback. If there is no XDP
> program attached, the veth code does not perform any share check, and
> shared/cloned skbs could enter the GRO engine.
>
>

...

> Address the issue checking for cloned skbs even in the GRO-without-XDP
> input path.
>
> Reported-and-tested-by: Ignat Korchagin <ignat@cloudflare.com>
> Fixes: d3256efd8e8b ("veth: allow enabling NAPI even without XDP")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  drivers/net/veth.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index b78894c38933..abd1f949b2f5 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -718,6 +718,14 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
>         rcu_read_lock();
>         xdp_prog = rcu_dereference(rq->xdp_prog);
>         if (unlikely(!xdp_prog)) {
> +               if (unlikely(skb_shared(skb) || skb_head_is_locked(skb))) {

Why skb_head_is_locked() needed here ?
I would think skb_cloned() is enough for the problem we want to address.

> +                       struct sk_buff *nskb = skb_copy(skb, GFP_ATOMIC | __GFP_NOWARN);
> +
> +                       if (!nskb)
> +                               goto drop;
> +                       consume_skb(skb);
> +                       skb = nskb;
> +               }
>                 rcu_read_unlock();
>                 goto out;
>         }
> --
> 2.33.1
>

- It seems adding yet memory alloc/free and copies is defeating GRO purpose.
- After skb_copy(), GRO is forced to use the expensive frag_list way
for aggregation anyway.
- veth mtu could be set to 64KB, so we could have order-4 allocation
attempts here.

Would the following fix [1] be better maybe, in terms of efficiency,
and keeping around skb EDT/tstamp
information (see recent thread with Martin and Daniel )

I think it also focuses more on the problem (GRO is not capable of
dealing with cloned skb yet).
Who knows, maybe in the future we will _have_ to add more checks in
GRO fast path for some other reason,
since it is becoming the Swiss army knife of networking :)

Although I guess this whole case (disabling TSO) is moot, I have no
idea why anyone would do that :)

[1]
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 50eb43e5bf459bb998e264d399bc85d4e9d73594..fe7a4d2f7bfc834ea56d1da185c0f53bfbd22ad0
100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -879,8 +879,12 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,

                        stats->xdp_bytes += skb->len;
                        skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
-                       if (skb)
-                               napi_gro_receive(&rq->xdp_napi, skb);
+                       if (skb) {
+                               if (skb_shared(skb) || skb_cloned(skb))
+                                       netif_receive_skb(skb);
+                               else
+                                       napi_gro_receive(&rq->xdp_napi, skb);
+                       }
                }
                done++;
        }
