Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E83BE9F3C0
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 22:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbfH0UHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 16:07:14 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:43291 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbfH0UHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 16:07:14 -0400
Received: by mail-yw1-f66.google.com with SMTP id n205so8319258ywb.10
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 13:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vBDQYXl9pE0DPWauduy9QLniFJplS5TjX9NW+kRHK2s=;
        b=Ba2wEGlNz1JT+0GU9GbkoY5OpARCt7L/bl4hIRlVQ2KQfEc3DRv8HroDUjukhk+KET
         gJbM/5fE+iq4E7mWbh+7xwBVjvE3s4kvrIBAz/AMEKRISw2UQ8N4mGsn4wqBpUgBbpl0
         /e60mvIlf1HHdbIkFUFEhoxoUx+gvdt/e2nqLHejKjB0q8+qj+5g6pSqFYpaYfE2Mj29
         hpA+vzOQOfk5NVFxSTRV/ABFjvpxNZsKRD5miCQPbhvy/lV5J+RHsJH6iunEoY/foxJA
         MCnoyIvpa3Ouk7TgmjLkTfM0Y+gbuoAzQHHvipI2Kafi3bBo8RLWI0Puh2GEaK4F6um+
         S2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vBDQYXl9pE0DPWauduy9QLniFJplS5TjX9NW+kRHK2s=;
        b=dtEe7bi6Cyu8NOhqaWxGnfj3embAvBRhL3w6kmzSBiy8MeKh4vlU7Yf79fwjAStc4+
         mTIcp2fYIHBSeMvp3cp+PcXzsVygqK6UZAGDJDnBW8yvA8hgQEWsrxdPXgqRFmtfPve4
         AU6/JSokliydp5Bojwz61WXdr73t1h/hatWGTfGIxV1ZODAhgms2GKfeG6Znr0mmIfMd
         b1kk2w0x+rcMDF869Iya2me7HefVrgHPVZSQGiZ49vRONMMHrfCtkpOXAW28azWZ+BlK
         0VyqRjYDOhDtCU/uB8fdmK/zf+b6Do/PkNBlheAqx/uutT1Xov7MQRXoxbm/PTmb7Nyc
         8PBA==
X-Gm-Message-State: APjAAAX5WVJFwiMiNolNjncbwJHr9EZN/FobWHY7o3C+cCv0dzD6Mik7
        cWTntMAashTqk6Nghew0kIwEJWFndIw+EwPVLPo6Hw==
X-Google-Smtp-Source: APXvYqxYIwKYc6AFYHNIU7ruucvez0g11Y8ERaeZvrQ1mdnK22vxsUIvv9QqCxDnZLFML/ZWzC1OdEYMl6JtEaHubto=
X-Received: by 2002:a81:2e09:: with SMTP id u9mr533719ywu.146.1566936433095;
 Tue, 27 Aug 2019 13:07:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190827190933.227725-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20190827190933.227725-1-willemdebruijn.kernel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Aug 2019 22:07:01 +0200
Message-ID: <CANn89iKwaar9fmgfoDTKebfRGHjR2K3gLeeJCr-bvturzgj3zQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: inherit timestamp on mtu probe
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 9:09 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> TCP associates tx timestamp requests with a byte in the bytestream.
> If merging skbs in tcp_mtu_probe, migrate the tstamp request.
>
> Similar to MSG_EOR, do not allow moving a timestamp from any segment
> in the probe but the last. This to avoid merging multiple timestamps.
>
> Tested with the packetdrill script at
> https://github.com/wdebruij/packetdrill/commits/mtu_probe-1
>
> Link: http://patchwork.ozlabs.org/patch/1143278/#2232897
> Fixes: 4ed2d765dfac ("net-timestamp: TCP timestamping")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  net/ipv4/tcp_output.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 5c46bc4c7e8d..42abc9bd687a 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2053,7 +2053,7 @@ static bool tcp_can_coalesce_send_queue_head(struct sock *sk, int len)
>                 if (len <= skb->len)
>                         break;
>
> -               if (unlikely(TCP_SKB_CB(skb)->eor))
> +               if (unlikely(TCP_SKB_CB(skb)->eor) || tcp_has_tx_tstamp(skb))
>                         return false;
>
>                 len -= skb->len;
> @@ -2170,6 +2170,7 @@ static int tcp_mtu_probe(struct sock *sk)
>                          * we need to propagate it to the new skb.
>                          */
>                         TCP_SKB_CB(nskb)->eor = TCP_SKB_CB(skb)->eor;
> +                       tcp_skb_collapse_tstamp(nskb, skb);

nit: maybe rename tcp_skb_collapse_tstamp() to tcp_skb_tstamp_copy()
or something ?

Its name came from the fact that it was only used from
tcp_collapse_retrans(), but it will no
longer be the case after your fix.

>                         tcp_unlink_write_queue(skb, sk);
>                         sk_wmem_free_skb(sk, skb);
>                 } else {
> --
> 2.23.0.187.g17f5b7556c-goog
>
