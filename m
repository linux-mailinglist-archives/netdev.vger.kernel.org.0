Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C4D3C971E
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 06:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbhGOEY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 00:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhGOEY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 00:24:56 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9EFC06175F;
        Wed, 14 Jul 2021 21:22:03 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 70so1335361pgh.2;
        Wed, 14 Jul 2021 21:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dBTosmdSR7CNRm+mVOCFUNDe7m3yGam3kuEQEMXECBA=;
        b=jpCB6haMNRn6FeOt67XPmN/G6rC9i3yRZ1ldqp++fUAhpf1FuNnkGqEhcXxDitTwSU
         C5VLnl+A8+6T0QEZjtKhsrGnnd8AoQseaYdnty0hGm5y+Ewt1IPc0efpVq76baqlQ3MH
         McWFGTYeo/zaVorZaakJ6MfbLGd8OruASzvzF98IpWe4xpYYM+hd1SKjsrzDAzEHqcv+
         VPpqHvOLIKzZK93lIUrm6O1tjXsQ3HLmslzlaXdteKXXdRRk+iRVdcw2Bi5W5XRsT5vW
         2dZTFXXxKStMKtU6syiQcxB5pLlbaecXiH099f4f9okVFGnw7AIiizFzeRLDpPk70UjF
         2MCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dBTosmdSR7CNRm+mVOCFUNDe7m3yGam3kuEQEMXECBA=;
        b=Qcfg+aEnYcCUZMToOuHO/mGWgOkFkjVBLoq4ow/aN+wx9D4QFXPsK3vROuE7W6ksR/
         4k+yncc2cmsLS5EqXkLyE6HecwuT3ERdDs2s2ahRGn8jVQbpeZ0gzT62t6WwPaI4fDjB
         vl2oY3A7iZ6SCwLjeXf8DtQjj5/pP4Kivqz3rPQZXooChTw6/Kr/61ckWvQuJVUHSnvb
         roj6S+sZjhlOm0dKxUasCzNSjFN1atCgvsx/tJoz6rfm0K0FVaQqTCHhtcRq3q4NQ+y1
         xo79ZYFnCgugZZTAJVez5bhf9SGrROJEB/ozPNG3FtrJSRK68YlmflGhxhhGeB7ZfXBN
         G9Ww==
X-Gm-Message-State: AOAM530H9s76UgbwFUar4YHy7rdE2qT5B2T84vW+nUxwIVQSBzjVeK15
        F+hN9XgJQ9g4txeIJK39AN595/rOJ75a5LpsKDY=
X-Google-Smtp-Source: ABdhPJxJW9zid6uRT39sNlQTtUjQqUhJDLC0/3g0cCCZO3+zpm2GXCmsZmkdlkUhBQ1BWuxxNDi8F9LRfXKTLUikCNo=
X-Received: by 2002:a63:4302:: with SMTP id q2mr2141513pga.428.1626322923333;
 Wed, 14 Jul 2021 21:22:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210713123654.31174-1-yajun.deng@linux.dev> <20210713123654.31174-2-yajun.deng@linux.dev>
In-Reply-To: <20210713123654.31174-2-yajun.deng@linux.dev>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 14 Jul 2021 21:21:52 -0700
Message-ID: <CAM_iQpUMxAOzMBJhxbYYYq2D2Fn_yYSxsWkxCDGVavGZhdKxHw@mail.gmail.com>
Subject: Re: [PATCH 1/2] rtnetlink: use nlmsg_{multicast, unicast} instead of netlink_{broadcast,unicast}
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Johannes Berg <johannes.berg@intel.com>,
        ryazanov.s.a@gmail.com, Andrey Wagin <avagin@gmail.com>,
        vladimir.oltean@nxp.com, Roopa Prabhu <roopa@cumulusnetworks.com>,
        "zhudi (J)" <zhudi21@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 5:37 AM Yajun Deng <yajun.deng@linux.dev> wrote:
>
> It has a 'NETLINK_CB(' statement in nlmsg_multicast() and has 'if (err'
> in nlmsg_{multicast, unicast}, use nlmsg_{multicast, unicast} instead
> of netlink_{broadcast,unicast}. so the caller would not deal with the
> 'if (err >0 )' statement. Add the return value for nlmsg_multicast.
> As also, rename rtnetlink_send() to rtnl_send(), this makes style
> uniform.
>
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  include/linux/rtnetlink.h |  2 +-
>  net/core/rtnetlink.c      | 13 +++++++------
>  2 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
> index bb9cb84114c1..60bef82e42ab 100644
> --- a/include/linux/rtnetlink.h
> +++ b/include/linux/rtnetlink.h
> @@ -9,7 +9,7 @@
>  #include <linux/refcount.h>
>  #include <uapi/linux/rtnetlink.h>
>
> -extern int rtnetlink_send(struct sk_buff *skb, struct net *net, u32 pid, u32 group, int echo);
> +extern int rtnl_send(struct sk_buff *skb, struct net *net, u32 pid, u32 group, int echo);
>  extern int rtnl_unicast(struct sk_buff *skb, struct net *net, u32 pid);
>  extern void rtnl_notify(struct sk_buff *skb, struct net *net, u32 pid,
>                         u32 group, struct nlmsghdr *nlh, gfp_t flags);
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index f6af3e74fc44..c081d607bb69 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -707,17 +707,18 @@ static int rtnl_link_fill(struct sk_buff *skb, const struct net_device *dev)
>         return err;
>  }
>
> -int rtnetlink_send(struct sk_buff *skb, struct net *net, u32 pid, unsigned int group, int echo)
> +int rtnl_send(struct sk_buff *skb, struct net *net, u32 pid, unsigned int group, int echo)
>  {
>         struct sock *rtnl = net->rtnl;
>         int err = 0;
>
> -       NETLINK_CB(skb).dst_group = group;
> -       if (echo)
> +       err = nlmsg_multicast(rtnl, skb, pid, group, GFP_KERNEL);
> +
> +       if (echo) {
>                 refcount_inc(&skb->users);

You also moved this refcount_inc() down after nlmsg_multicast().
Are you sure it is safe?

And the name rtnl_send() is bad given that rtnl_unicast() follows it...

Thanks.
