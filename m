Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13AFCBB4A4
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 15:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394861AbfIWNBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 09:01:52 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35711 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394853AbfIWNBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 09:01:52 -0400
Received: by mail-yw1-f65.google.com with SMTP id r134so5155527ywg.2
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 06:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ue87GpUhAZ9kFHhc+m7veD7Le98aKOUJV1k5ZDbuBsw=;
        b=anP2V0sWEfYqRMocHjRsldEIpMW7aGC0+NGgsN9FG75rkVYehhbw3xp6tYS2vZG4bp
         jAWSdgOLQVHz1S16pczRkYlO8lHYNleXttzLsnq1lvVBAUPCYFy0NO9ni2yrJbE0Y816
         ES+lvHEGAQdRlGiBvIr8F3SnBMl4TxqsWWyMIG65pJy77PgeudgaCXnDIo2zmGbrniEj
         SuQkcM29mse1QSqwhYgAAcJLnEDkXPurxLAmAUHvI4Xtua2cYDCwjZDHpox9/FmioqR7
         a+135MmcmXDaRNH1AIRWAMegWjEf6ht43LNCo0CUjfcKdgmppzJVIXZM+eT9yxNgKDc7
         qQgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ue87GpUhAZ9kFHhc+m7veD7Le98aKOUJV1k5ZDbuBsw=;
        b=kzBT3abJJUjx07zaYfe7baMq7i+DJCCRXouRPoqtbM9FfCPkmmmnlwgji3IX9xg2xX
         NnBCNkr7fsfqNTRrXQyvCCtdwKheg776m2YG33Kz8JcLh4hpWijdlm1mbcWDo1RDEnkt
         wsgwdUgmu9Z2Ny3UBwLdgHBd/ED7QeB21Wao76a/N5gGmStCxhNHngVYovdlAtWjeNi5
         J3mx2CJBGvlYrFE4lFNj/wRPBNenz9n7hDHnGpr0XcQixJm5px4d8dHPW5QfzjF+cJNz
         1Ie8hLj1cw9YN2hI3V3ft898DW4PQLYrAiRce6Ipu1Dl1394C9avx3a1sM7PbUdoAQ1/
         FdxQ==
X-Gm-Message-State: APjAAAX4HgDSbdPZWM1NrS6yNUoGj2R5qJHsAaP9nT9hBfLLIp28fMI5
        MuNLNpXgDkqKr2oBbMfXExAhDhGv8w5mv/+H29yOAA==
X-Google-Smtp-Source: APXvYqyvpkQRz4q9G52DfUX+5uJxahINZfWvONE7tqpqPhskhxNVU0hg96ZUQ1kGV7x8u4moEkbbNiH53aAQzd/457g=
X-Received: by 2002:a81:7d55:: with SMTP id y82mr23765065ywc.111.1569243710588;
 Mon, 23 Sep 2019 06:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190920044905.31759-1-steffen.klassert@secunet.com> <20190920044905.31759-6-steffen.klassert@secunet.com>
In-Reply-To: <20190920044905.31759-6-steffen.klassert@secunet.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Mon, 23 Sep 2019 09:01:13 -0400
Message-ID: <CA+FuTScYar_FNP9igCbxafMciUEYnjbnGiJyX3JhrU74VEGksg@mail.gmail.com>
Subject: Re: [PATCH RFC 5/5] udp: Support UDP fraglist GRO/GSO.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 12:49 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> This patch extends UDP GRO to support fraglist GRO/GSO
> by using the previously introduced infrastructure.
> All UDP packets that are not targeted to a GRO capable
> UDP sockets are going to fraglist GRO now (local input
> and forward).
>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

> @@ -538,6 +579,15 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
>         const struct iphdr *iph = ip_hdr(skb);
>         struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
>
> +       if (NAPI_GRO_CB(skb)->is_flist) {
> +               uh->len = htons(skb->len - nhoff);
> +
> +               skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
> +               skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
> +
> +               return 0;
> +       }
> +
>         if (uh->check)
>                 uh->check = ~udp_v4_check(skb->len - nhoff, iph->saddr,
>                                           iph->daddr, 0);
> diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
> index 435cfbadb6bd..8836f2b69ef3 100644
> --- a/net/ipv6/udp_offload.c
> +++ b/net/ipv6/udp_offload.c
> @@ -150,6 +150,15 @@ INDIRECT_CALLABLE_SCOPE int udp6_gro_complete(struct sk_buff *skb, int nhoff)
>         const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
>         struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
>
> +       if (NAPI_GRO_CB(skb)->is_flist) {
> +               uh->len = htons(skb->len - nhoff);
> +
> +               skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
> +               skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
> +
> +               return 0;
> +       }
> +

This is the same logic as in udp4_gro_complete. Can it be deduplicated
in udp_gro_complete?

>         if (uh->check)
>                 uh->check = ~udp_v6_check(skb->len - nhoff, &ipv6h->saddr,
>                                           &ipv6h->daddr, 0);
