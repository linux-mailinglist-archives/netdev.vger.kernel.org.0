Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2831F3997
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 21:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfKGUhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 15:37:10 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32816 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfKGUhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 15:37:10 -0500
Received: by mail-wm1-f66.google.com with SMTP id a17so4979130wmb.0
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 12:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TP2gfIB44smTv89rJyokmz9BkOyIn2LvUmWAiBH1d+E=;
        b=umWywYcPK3FTy94uZjfwZArOxYGDSgRVzysG9MhLIphBRp4npsSGJ8NhBmJ12FkTY/
         L2UOnAS0ObAT1aqj87ue1joW7soLQsnkIHtpXyx3/qXUAwfANwh80RpLDaUROptOYb4v
         gSjbCuS1S21wE5AfwBQD9fnNyo6eBD1QNbZxLXwSe73fhlUxeftUzek8uLeRdJ5gbxxX
         xQGi7jifnf/uOK5IixDVewN3GPKyVTT3S00PymXSl9B0h+C+tjPfaVUh6ehSLXLQTidS
         u128ewtd6//6/798cB7kY/pBZyB1K2mXHjsASpGDjJgt8baWaxV9vad1XGAvDPITfyFX
         fbjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TP2gfIB44smTv89rJyokmz9BkOyIn2LvUmWAiBH1d+E=;
        b=IHjxXy6SIV7fcA7Na8kS7tI2PdDZSCCh1jqAufiv8LSW9EdAR4XQCTxrF+CMHWwadl
         3kJdeJ1PBLDj2LO06/sCWol1qQtX/lds9zwHWCbNrkk55ORENtbe8AoyHnJOp2aLyZ2N
         GFkKUsSbUtnj6xYyEyvQbq8avFQwx18Wjy4fKdNoTW/ey8Ev4q+2jPy3ucR5r4/X3bm8
         bquVDuR6RFHrKsqeQcWp3JtZ1gPxZIEhM3Zh0hbdjufFwGVTkylyoIxRf9AnmjJEWRBJ
         9w31knFwLXh3Dv5j0DG+XEypjWsEuIjRRt4vhVbKt8Bu4y/kOSPVlZH41FmQVdpKj+/D
         Ov7w==
X-Gm-Message-State: APjAAAXWeegktC+RYF9JBo3LDk6zXBiQpE60ujthz+JflFDDf5k623vu
        C+d5X152bVZM8tH7K7WeQSVqxA6xnazpuXcPd7quKg==
X-Google-Smtp-Source: APXvYqztqexKXKcO7Zyo/fIvnofwCL3joaaYVmLLlUTPXYs6q4ub3xzzwDEzsVrXL4C7WaxlF/O0r6SM0zNDk3CgHIw=
X-Received: by 2002:a1c:a9cb:: with SMTP id s194mr5135816wme.92.1573159027084;
 Thu, 07 Nov 2019 12:37:07 -0800 (PST)
MIME-Version: 1.0
References: <20191107132755.8517-1-jonas@norrbonn.se> <20191107132755.8517-2-jonas@norrbonn.se>
In-Reply-To: <20191107132755.8517-2-jonas@norrbonn.se>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Thu, 7 Nov 2019 12:36:50 -0800
Message-ID: <CAF2d9jjRLZ07Qx0NJ9fi1iUpHn+qYEJ+cacKgBmeZ2FvZLObEQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] rtnetlink: allow RTM_SETLINK to reference other namespaces
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     nicolas.dichtel@6wind.com, linux-netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 5:30 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> Netlink currently has partial support for acting on interfaces outside
> the current namespace.  This patch extends RTM_SETLINK with this
> functionality.
>
> The current implementation has an unfortunate semantic ambiguity in the
> IFLA_TARGET_NETNSID attribute.  For setting the interface namespace, one
> may pass the IFLA_TARGET_NETNSID attribute with the namespace to move the
> interface to.  This conflicts with the meaning of this attribute for all
> other methods where IFLA_TARGET_NETNSID identifies the namespace in
> which to search for the interface to act upon:  the pair (namespace,
> ifindex) is generally given by (IFLA_TARGET_NETNSID, ifi->ifi_index).
>
> In order to change the namespace of an interface outside the current
> namespace, we would need to specify both an IFLA_TARGET_NETNSID
> attribute and a namespace to move to using IFLA_NET_NS_[PID|FD].  This is
> currently now allowed as only one of these three flags may be specified.
>
> This patch loosens the restrictions a bit but tries to maintain
> compatibility with the previous behaviour:
> i)  IFLA_TARGET_NETNSID may be passed together with one of
> IFLA_NET_NS_[PID|FD]
> ii)  IFLA_TARGET_NETNSID is primarily defined to be the namespace in
> which to find the interface to act upon
> iii)  In order to maintain backwards compatibility, if the device is not
> found in the specified namespace, we also look for it in the current
> namespace
> iv)  If only IFLA_TARGET_NETNSID is given, the device is still moved to
> that namespace, as before; and, as before, IFLA_NET_NS_[PID|FD] take
> precedence as namespace selectors
>
> Ideally, IFLA_TARGET_NETNSID would only ever have been used to select the
> namespace of the device to act upon.  A separate flag, IFLA_NET_NS_ID
> would have been made available for changing namespaces
>
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  net/core/rtnetlink.c | 37 ++++++++++++++++++++++++++++++-------
>  1 file changed, 30 insertions(+), 7 deletions(-)
>
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index c81cd80114d9..aa3924c9813c 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -2109,13 +2109,7 @@ static int rtnl_ensure_unique_netns(struct nlattr *tb[],
>                 return -EOPNOTSUPP;
>         }
>
> -       if (tb[IFLA_TARGET_NETNSID] && (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD]))
> -               goto invalid_attr;
> -
> -       if (tb[IFLA_NET_NS_PID] && (tb[IFLA_TARGET_NETNSID] || tb[IFLA_NET_NS_FD]))
> -               goto invalid_attr;
> -
> -       if (tb[IFLA_NET_NS_FD] && (tb[IFLA_TARGET_NETNSID] || tb[IFLA_NET_NS_PID]))
> +       if (tb[IFLA_NET_NS_PID] && tb[IFLA_NET_NS_FD])
>                 goto invalid_attr;
>
>         return 0;
> @@ -2727,6 +2721,7 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>                         struct netlink_ext_ack *extack)
>  {
>         struct net *net = sock_net(skb->sk);
> +       struct net *tgt_net = NULL;
>         struct ifinfomsg *ifm;
>         struct net_device *dev;
>         int err;
> @@ -2742,6 +2737,15 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>         if (err < 0)
>                 goto errout;
>
> +       if (tb[IFLA_TARGET_NETNSID]) {
> +               s32 netnsid = nla_get_s32(tb[IFLA_TARGET_NETNSID]);
> +
> +               tgt_net = rtnl_get_net_ns_capable(NETLINK_CB(skb).sk, netnsid);
> +               if (IS_ERR(net))
> +                       return PTR_ERR(net);
> +               net = tgt_net;
> +       }
> +
>         if (tb[IFLA_IFNAME])
>                 nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
>         else
> @@ -2756,6 +2760,23 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>         else
>                 goto errout;
>
> +       /* A hack to preserve kernel<->userspace interface.
> +        * It was previously allowed to pass the IFLA_TARGET_NETNSID
> +        * attribute as a way to _set_ the network namespace.  In this
> +        * case, the device interface was assumed to be in the  _current_
> +        * namespace.
> +        * If the device cannot be found in the target namespace then we
> +        * assume that the request is to set the device in the current
> +        * namespace and thus we attempt to find the device there.
> +        */
Could this bypasses the ns_capable() check? i.e. if the target is
"foo" but your current ns is bar. The process may be "capable" is foo
but the interface is not found in foo but present in bar and ends up
modifying it (especially when you are not capable in bar)?

> +       if (!dev && tgt_net) {
> +               net = sock_net(skb->sk);
> +               if (ifm->ifi_index > 0)
> +                       dev = __dev_get_by_index(net, ifm->ifi_index);
> +               else if (tb[IFLA_IFNAME])
> +                       dev = __dev_get_by_name(net, ifname);
> +       }
> +
>         if (dev == NULL) {
>                 err = -ENODEV;
>                 goto errout;
> @@ -2763,6 +2784,8 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>
>         err = do_setlink(skb, dev, ifm, extack, tb, ifname, 0);
>  errout:
> +       if (tgt_net)
> +               put_net(tgt_net);
>         return err;
>  }
>
> --
> 2.20.1
>
