Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26DF61BA1E
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 17:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbfEMPbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 11:31:55 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40905 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728760AbfEMPbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 11:31:55 -0400
Received: by mail-ed1-f65.google.com with SMTP id j12so17425582eds.7
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 08:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FPMqnDxV2G48/sjRkHWawqtFwugJOIeddUzU1D1MZjk=;
        b=Ssahj6LcRsO+eAQTaXU7FmI/t3Jlkcd4Dy43QMKAt6oTySGZlB5zt3wxW2P2uhl57h
         gPCxPYAzz4faa6GYTphJlcDxi0MUwtXMuGzC74QtTbMpFFHwaTcUiL3fTdJlVKCIciJI
         jrDRs/jFoJxppPjhjEZNVXu1FY0ViVHUpiwcSaYsG8/5EVMUE0XKbWNcYSWdK2CNKvYk
         l4aNnjqC03xsc0DL1C1VzH6zSW9QUIHyF5WiPsrJNSs6MAjx0tTsx5PgwJtYbsZCuwCl
         L+o4Ldx/kuqJhhizDaQVaPlX40wiWYoV2OtYu7RlkT8hyhMdy7DS3/jZMQzlcl4E+qp1
         oPvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FPMqnDxV2G48/sjRkHWawqtFwugJOIeddUzU1D1MZjk=;
        b=hJPK8hz/IsuyTEXnn/yzg1X6DfcQRIZrV8MvBlbl0DxbqLJcm2+0a0VEh3xrKoJnVq
         A3VC/fL9bfd/SHd7pLoWfzsDNHHBfZDVXgKOAYrCBxSav9aye+EzEmQRx6yrv8JCTU4T
         ZLpzGDICekU0Ci93iUDyKY3ILM48BltZlkAAfqRI4sMq1By8CdocnbnkdLtuD+nv2l/p
         OGy2hUqCKF64YTAc6r1v0g9lrYARZ1q/IcBTUYmMQQp1X4GWCbJ5nZtwKgFAG8bUAyCT
         Hs5k759LwowuwTo32Cx1c0n5KhFbtbGf2OVzFRCbw6zxwDouP2hZFFkZYNVFignO1c5X
         fCfw==
X-Gm-Message-State: APjAAAUqQXjlFVFCyHHWEtG+piwdNQB6Xem9AW68OKqhfph/CyEUeEXK
        r8QYlCL/MuKYEfOcPBho5ZF8lGXU3lR+4qC/qQ0=
X-Google-Smtp-Source: APXvYqx9ANU0LxPJ7zmyLRALYvfKW0RhOkQgswO82wuQfsk09vWQUPsZzPaR3cao+6YztFMLJVFTUVw0tjTk/+tA6fQ=
X-Received: by 2002:a05:6402:70b:: with SMTP id w11mr6954487edx.139.1557761513735;
 Mon, 13 May 2019 08:31:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190509155542.25494-1-dsahern@kernel.org>
In-Reply-To: <20190509155542.25494-1-dsahern@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 13 May 2019 11:31:17 -0400
Message-ID: <CAF=yD-+U+6AVpWfRAznXeaJm5jpQQOT=5kn4=wE900=Eu4QZpA@mail.gmail.com>
Subject: Re: [PATCH RFC net-next] netlink: Add support for timestamping messages
To:     David Ahern <dsahern@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 9, 2019 at 11:57 AM David Ahern <dsahern@kernel.org> wrote:
>
> From: David Ahern <dsahern@gmail.com>
>
> Add support for timestamping netlink messages. If a socket wants a
> timestamp, it is added when the skb clone is queued to the socket.
>
> Allow userspace to know the actual time an event happened. In a
> busy system there can be a long lag between when the event happened
> and when the message is read from the socket. Further, this allows
> separate netlink sockets for various RTNLGRP's where the timestamp
> can be used to sort the messages if needed.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
> one question I have is whether it would be better to add the timestamp
> when the skb is created so it is the same for all sockets as opposed to
> setting the time per socket.
>
>  net/netlink/af_netlink.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
>
> +/* based on tcp_recv_timestamp */

Which itself is based on __sock_recv_timestamp. Which this resembles
even more closely, as both pass an skb. Instead of duplicating the
core code yet again, we can probably factor out and reuse it. Netlink
only does not need the SOF_TIMESTAMPING part.


> +static void netlink_cmsg_timestamp(struct msghdr *msg, struct sk_buff *skb,
> +                                  struct sock *sk)
> +{
> +       int new_tstamp;
> +
> +       if (!skb_get_ktime(skb))
> +               return;
> +
> +       new_tstamp = sock_flag(sk, SOCK_TSTAMP_NEW);
> +       if (sock_flag(sk, SOCK_RCVTSTAMPNS)) {
> +               if (new_tstamp) {
> +                       struct __kernel_timespec kts;
> +
> +                       skb_get_new_timestampns(skb, &kts);
> +                       put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_NEW,
> +                                sizeof(kts), &kts);
> +               } else {
> +                       struct timespec ts;
> +
> +                       skb_get_timestampns(skb, &ts);
> +                       put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_OLD,
> +                                sizeof(ts), &ts);
> +               }
> +       } else {
> +               if (new_tstamp) {
> +                       struct __kernel_sock_timeval stv;
> +
> +                       skb_get_new_timestamp(skb, &stv);
> +                       put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_NEW,
> +                                sizeof(stv), &stv);
> +               } else {
> +                       struct __kernel_old_timeval tv;
> +
> +                       skb_get_timestamp(skb, &tv);
> +                       put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_OLD,
> +                                sizeof(tv), &tv);
> +               }
> +       }
> +}
