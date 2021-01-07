Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE72D2ECE93
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 12:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbhAGLTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 06:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbhAGLTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 06:19:21 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32164C0612F6
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 03:18:41 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id i18so5800319ioa.1
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 03:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=krlPO3wRXyNdebnI/vEBKc7/tb3h/+kftjKjNBCm79k=;
        b=YBxq1T5RQBV8qRwJmucIunOPj3vZ00rJwdCCvbqQ5XpZ2QPsVU8QZgD2tPYWdfhX53
         oVHX90Zk8TBjGzlhtoBSWyFyEobGo9yFkKSc7jU/ucyLhcUM9lSfOSHmugZcljkadK1z
         /5wBN3UECkJkG1qNFL6RpY0Q2Uf03yS53hhenVy+zZSU6SRcStZXLu5VruSupMg/lyGQ
         5HbHAg6IovgAQuQDFp9I5sNevVkN0beNQxENIVqnSCKgKVYwRhZ00kEQCqEJwY0Tmr7O
         0Rf2Htirn1PMUqMzZEn7lGIbFNwVfhq3YtOWdKicEr0pZV4zuTNgl97JR1JRWDogfd31
         k7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=krlPO3wRXyNdebnI/vEBKc7/tb3h/+kftjKjNBCm79k=;
        b=EkTSKaaFGJfQO4mWFCjfz+bghiq5+eBE5441k7s6l/vSqSH1McBOPLo9vd7K1O1fnv
         QSL+mTLeui8NCppk5bYmFjGwB7R5WB9kiIr/HMBU3Q2GQVJBNM76HZgebWqX1f8KekaQ
         eymIcZKnUqc2mJiN4wEMtZ6MSiycR6HCO8I08vBavbKVoSgOhZ+N7hWs1aHjaRJZHqqK
         cH/qYCxTi03QGjJ58xdfe/iQ9lteVBQ8Cc/pohCaJptI1Pj8A8pExXl4Y0gWH5m9qBMY
         3HuXosetTOTUdrunhNDk5uk/l287PeoeTU9p5YiIKheKcuHlWstaYhvynBP+yjhNvEnM
         YSWg==
X-Gm-Message-State: AOAM532MysrCN0RfypnZOBLC335cKBQX1iSj1Io8RXmWy90nOXh2+pqA
        cRPQACjDOD+wsfQleEjPbQOK5GGIIPFmoDC5GrOiMA==
X-Google-Smtp-Source: ABdhPJxVndiZfMkoYcLT3dqnPLUikGYI8+xkyRHImFPcyoi/RT51Ybf736u+38umQHqzeuhX35bFgTK3M7iZq6XbtD8=
X-Received: by 2002:a6b:c8c1:: with SMTP id y184mr826699iof.99.1610018320229;
 Thu, 07 Jan 2021 03:18:40 -0800 (PST)
MIME-Version: 1.0
References: <20210107094951.1772183-1-olteanv@gmail.com> <20210107094951.1772183-11-olteanv@gmail.com>
In-Reply-To: <20210107094951.1772183-11-olteanv@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 7 Jan 2021 12:18:28 +0100
Message-ID: <CANn89i+NfBw7ZpL-DTDA3QGBK=neT2R7qKYn_pcvDmRAOkaUsQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 10/12] net: bonding: ensure .ndo_get_stats64
 can sleep
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 7, 2021 at 10:51 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>

-
>  static void bond_get_stats(struct net_device *bond_dev,
>                            struct rtnl_link_stats64 *stats)
>  {
>         struct bonding *bond = netdev_priv(bond_dev);
> -       struct rtnl_link_stats64 temp;
> -       struct list_head *iter;
> -       struct slave *slave;
> -       int nest_level = 0;
> +       struct rtnl_link_stats64 *dev_stats;
> +       struct net_device **slaves;
> +       int i, res, num_slaves;
>
> +       res = bond_get_slave_arr(bond, &slaves, &num_slaves);
> +       if (res) {
> +               netdev_err(bond->dev,
> +                          "failed to allocate memory for slave array\n");
> +               return;
> +       }
>

What a mess really.

You chose to keep the assumption that ndo_get_stats() would not fail,
since we were providing the needed storage from callers.

If ndo_get_stats() are now allowed to sleep, and presumably allocate
memory, we need to make sure
we report potential errors back to the user.

I think your patch series is mostly good, but I would prefer not
hiding errors and always report them to user space.
And no, netdev_err() is not appropriate, we do not want tools to look
at syslog to guess something went wrong.

Last point about drivers having to go to slow path, talking to
firmware : Make sure that malicious/innocent users
reading /proc/net/dev from many threads in parallel wont brick these devices.

Maybe they implicitly _relied_ on the fact that firmware was gently
read every second and results were cached from a work queue or
something.

Thanks.
