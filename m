Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A097628C7F
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388229AbfEWVkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:40:14 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36724 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388209AbfEWVkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 17:40:14 -0400
Received: by mail-ed1-f65.google.com with SMTP id a8so11246779edx.3;
        Thu, 23 May 2019 14:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7sFc7ThnmJhmVClW066IBr+ugXYu56ow2YaUneJliW0=;
        b=tq/Xl4TibAUmg94VVJF+gOJisGDmKCiLyMJc14nMfPZXdAJk7ERCF8P96Ymgh0G9ju
         zXfESZcUOdHw0qbjIn8kgfN9S4+lvq5/vMKpP6M82gr6SHBkrTgVUQhs0QNEMIxwxe8N
         2j+eWa81owMg/n74R5C77rAc9jQb6LWfVby6ACsv9lcAtfUHnwFDS3A+9/jRCEIoveRY
         MfMW9uZxa7+GykS8GsasAk04ID42oxnsUV7kuhdCFAvu9mRHLy9Haubsy3sMrzW5eDjP
         OfKwdv4B+UW0LmdQBDxtKEzrgqb5I0+T4I8zqmypqL+X0WktI7lX4nAPz9rsFv2G3q6u
         IP7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7sFc7ThnmJhmVClW066IBr+ugXYu56ow2YaUneJliW0=;
        b=Q9pQfLxHZIaxU3VmFV1UIyRDA23AIyPz7tcMEwRZ0NU6l37CRpn4+M1bmct6PWBVAR
         k+7qRKI9NkFiNQGNRg7t+TaARJsNgOOX504Z/z4srf1ms9IRbdP6iHpsBvxSJAzVj4T0
         9fyZm505/j+xNcjr/3OWwmpgiRi9Rd5Er/3IHnQLfZXHJpET4oyHh80Z8Zemz1/bw+TC
         PeEVpyTAioaA6ylU3Yw3uk9IfFXnNYR7C+O+0+tL3eFJlYmcptdpDwoTlcZ9vWBOnx/r
         EdvLUeZYiBBVKC1f+KWx2+LXOMFbTep4iZ29WgWH2uuFGcWYz6HiCg9iVfmZhOuUjjPS
         afBQ==
X-Gm-Message-State: APjAAAWaMwRhNeB6Dg8BclYGm2eICRjlt0xYTXPMbcnkz6Nva8d1FUMC
        Rt0Cxd+9xij1n67//Oik85UQXwe9ZKgGhW+JEkQ=
X-Google-Smtp-Source: APXvYqw8tJGqA5c5wGFLyYEPWR/Y+2qo9DCjgzJefGelQCRumPO9B4e5aArLC4cN0khqMzdogT8yU2UsLQPAfJH85tg=
X-Received: by 2002:a17:906:699:: with SMTP id u25mr41633599ejb.245.1558647612145;
 Thu, 23 May 2019 14:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-2-fklassen@appneta.com>
In-Reply-To: <20190523210651.80902-2-fklassen@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 23 May 2019 17:39:36 -0400
Message-ID: <CAF=yD-Jf95De=z_nx9WFkGDa6+nRUqM_1PqGkjwaFPzOe+PfXg@mail.gmail.com>
Subject: Re: [PATCH net 1/4] net/udp_gso: Allow TX timestamp with UDP GSO
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 5:09 PM Fred Klassen <fklassen@appneta.com> wrote:
>
> Fixes an issue where TX Timestamps are not arriving on the error queue
> when UDP_SEGMENT CMSG type is combined with CMSG type SO_TIMESTAMPING.
> This can be illustrated with an updated updgso_bench_tx program which
> includes the '-T' option to test for this condition.
>
>     ./udpgso_bench_tx -4ucTPv -S 1472 -l2 -D 172.16.120.18
>     poll timeout
>     udp tx:      0 MB/s        1 calls/s      1 msg/s
>
> The "poll timeout" message above indicates that TX timestamp never
> arrived.
>
> It also appears that other TX CMSG types cause similar issues, for
> example trying to set SOL_IP/IP_TOS.
>
>     ./udpgso_bench_tx -4ucPv -S 1472 -q 182 -l2 -D 172.16.120.18
>     poll timeout
>     udp tx:      0 MB/s        1 calls/s      1 msg/s
>
> This patch preserves tx_flags for the first UDP GSO segment. This
> mirrors the stack's behaviour for IPv4 fragments.
>
> Fixes: ee80d1ebe5ba ("udp: add udp gso")
> Signed-off-by: Fred Klassen <fklassen@appneta.com>
> ---
>  net/ipv4/udp_offload.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index 065334b41d57..33de347695ae 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -228,6 +228,10 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
>         seg = segs;
>         uh = udp_hdr(seg);
>
> +       /* preserve TX timestamp and zero-copy info for first segment */
> +       skb_shinfo(seg)->tskey = skb_shinfo(gso_skb)->tskey;
> +       skb_shinfo(seg)->tx_flags = skb_shinfo(gso_skb)->tx_flags;
> +

Thanks for the report.

Zerocopy notification reference count is managed in skb_segment. That
should work.

Support for timestamping with the new GSO feature is indeed an
oversight. The solution is similar to how TCP associates the timestamp
with the right segment in tcp_gso_tstamp.

Only, I think we want to transfer the timestamp request to the last
datagram, not the first. For send timestamp, the final byte leaving
the host is usually more interesting.
