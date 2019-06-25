Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13BB055B2C
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfFYWar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:30:47 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45380 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfFYWar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:30:47 -0400
Received: by mail-ed1-f67.google.com with SMTP id a14so164174edv.12
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 15:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VIcCkPfsGN+DRVeDchqgQWuuaUTOneIAy2PwSnIe5BQ=;
        b=g/9bqyEkhyXUx0p6LY9kPgVEjARTHWO+Nv2QLK9DRz3kmwdou4xQEOQY28ftOFmFEK
         k45LqIXye7EqzpEH5vDSfxsFgfTDdUuerS4BQKVqFIsJmwUImt8byDbAU5UYMUwialUj
         m5nni1EXXbQ/8RWnkqKKY5YvIEbwIpsqbEqymud66bOWm5qBpL0MUJspLm6v8oeBOPkf
         VnCtLIFG6aPj7u4Wdr0jexuv+HXgVotxwg8VQA7bbLOi2PDxryU4BZHLnM9AZxfvVW1z
         cnoEG3gdxf7NKYxImMvBCA/j/f3//AyRbCJGSVkdbbCL5OcsOejZ00S2hbzXjKx+bO/k
         BNhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VIcCkPfsGN+DRVeDchqgQWuuaUTOneIAy2PwSnIe5BQ=;
        b=Wv25Qhf7UB2YImMmhYC4P+zGz+rlkBq/uk64yZqWFCIzQjwIJG2uudTJB5sGve1PYN
         nD13fqH9c+Jnq2nCnA+MG3vn2mYU4CBKoHndNb44rC67BbyCfba+xUuKHkjacGUX6RXX
         qohhlyGNqPjD07abQg0gggx/dqkiJdGuKcbYHQUN0DlHNXLTqFf1+vggMZcjsHSof/3N
         Wv6muDyd2GSQWiCuMmmfFnLJTGNBne0aEYxYdETiNcF4oZn8967I/BzTVevfnA0QRwYW
         PcLLCrW8PzvTsx1GJmnZYA4j9l/4L/AbobXsa41y0kikL/vR3suJN83mODp+AMCddBnJ
         O4Lw==
X-Gm-Message-State: APjAAAXHq1qFt3YrP9fcpj5MBuZgjZAcEplUUuLURYy3p6IUEWPK5b16
        SjJpYotAlcxE5ggI3muoqKO+9VU57W/DUUgqIBQ=
X-Google-Smtp-Source: APXvYqxG33SdnmV9qHctdM9TJJ9XafYZA4FMjc7crQTobhlraTSob7cqTATF8ZPZ9Cx6Aa7pvBgXXkv3h5jKTowPJJ0=
X-Received: by 2002:a17:906:d7a8:: with SMTP id pk8mr809167ejb.246.1561501845228;
 Tue, 25 Jun 2019 15:30:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190619202533.4856-1-nhorman@tuxdriver.com> <20190625215749.22840-1-nhorman@tuxdriver.com>
In-Reply-To: <20190625215749.22840-1-nhorman@tuxdriver.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 25 Jun 2019 18:30:08 -0400
Message-ID: <CAF=yD-+fCNGQyoRNAZngof3=_gGbHn9aSCQA_hNvFSsSZtZQxA@mail.gmail.com>
Subject: Re: [PATCH v4 net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index a29d66da7394..a7ca6a003ebe 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2401,6 +2401,9 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
>
>                 ts = __packet_set_timestamp(po, ph, skb);
>                 __packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
> +
> +               if (!packet_read_pending(&po->tx_ring))
> +                       complete(&po->skb_completion);
>         }
>
>         sock_wfree(skb);
> @@ -2585,7 +2588,7 @@ static int tpacket_parse_header(struct packet_sock *po, void *frame,
>
>  static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  {
> -       struct sk_buff *skb;
> +       struct sk_buff *skb = NULL;
>         struct net_device *dev;
>         struct virtio_net_hdr *vnet_hdr = NULL;
>         struct sockcm_cookie sockc;
> @@ -2600,6 +2603,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>         int len_sum = 0;
>         int status = TP_STATUS_AVAILABLE;
>         int hlen, tlen, copylen = 0;
> +       long timeo = 0;
>
>         mutex_lock(&po->pg_vec_lock);
>
> @@ -2646,12 +2650,21 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>         if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)
>                 size_max = dev->mtu + reserve + VLAN_HLEN;
>
> +       reinit_completion(&po->skb_completion);
> +
>         do {
>                 ph = packet_current_frame(po, &po->tx_ring,
>                                           TP_STATUS_SEND_REQUEST);
>                 if (unlikely(ph == NULL)) {
> -                       if (need_wait && need_resched())
> -                               schedule();
> +                       if (need_wait && skb) {
> +                               timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
> +                               timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);

This looks really nice.

But isn't it still susceptible to the race where tpacket_destruct_skb
is called in between po->xmit and this
wait_for_completion_interruptible_timeout?

The test for skb is shorthand for packet_read_pending  != 0, right?

> +                               if (timeo <= 0) {
> +                                       err = !timeo ? -ETIMEDOUT : -ERESTARTSYS;
> +                                       goto out_put;
> +                               }
> +                       }
> +                       /* check for additional frames */
>                         continue;
>                 }
>
