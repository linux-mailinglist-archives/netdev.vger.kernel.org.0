Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35923F840D
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 10:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240777AbhHZI7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 04:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240351AbhHZI7s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 04:59:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C8B06109F;
        Thu, 26 Aug 2021 08:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629968341;
        bh=zJGos2uCxfN4MJ+pMOdh+9WxhFJAzd4XefzJgxvmsY0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uYUXDnssrl/MJ6BBhvlyYlaoEOQ/Lm/gsRXdjxk0IzR7wQ2XDs3ng9SSAw5q5y9i9
         OLHYypmvctowYZ5EhGJBc32FKnF2OLiBHlVlZEzU8kIL0IfmB/XaOrGWEo3wHOdqLy
         VTuZ/q/7prF353IFXYjDetNf6Q+KXfh1HVJqnsE9RoZTn7XTKtmyV3bqnRCs6UAZAR
         xAyAoZv5TAJv3ZAkmTSc+Q3dfiodFW77x2916o7EYLe23hmUvrpUeldD8G1Ct1YqDm
         PpPcri/E45ahheQDNcTQ93S36YM4WgTNJeEEk3zSWyXbuov23kCgDLVL6kI9Ijn/VM
         d/upSmckY3Z3Q==
Received: by mail-wr1-f53.google.com with SMTP id x12so3787426wrr.11;
        Thu, 26 Aug 2021 01:59:01 -0700 (PDT)
X-Gm-Message-State: AOAM532mye+RFa/4DT9Dr/iLrJFYDA2uXWucA6ZM3Dxsf2XCb9TJ3XF0
        RkCih9WngM8u/O6wjoo+s1taWcHzI9SBPEU9dGs=
X-Google-Smtp-Source: ABdhPJxPFu4b6A/5ywoupNxHozm6PhwtnK000gz68HSFIxO8A6863HIRTQZJDf6tV5oTwRboWNmqqlvPRkzF+ocqcVo=
X-Received: by 2002:adf:e107:: with SMTP id t7mr2589248wrz.165.1629968339982;
 Thu, 26 Aug 2021 01:58:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210826012722.3210359-1-pcc@google.com>
In-Reply-To: <20210826012722.3210359-1-pcc@google.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 26 Aug 2021 10:58:44 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0Euhxqz50SSid4GmxH1+GWG+weqYS8BLjgxR+ZcC-C=g@mail.gmail.com>
Message-ID: <CAK8P3a0Euhxqz50SSid4GmxH1+GWG+weqYS8BLjgxR+ZcC-C=g@mail.gmail.com>
Subject: Re: [PATCH] net: don't unconditionally copy_from_user a struct ifreq
 for socket ioctls
To:     Peter Collingbourne <pcc@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 3:28 AM Peter Collingbourne <pcc@google.com> wrote:

> -       } else {
> +       } else if (is_dev_ioctl_cmd(cmd)) {
>                 struct ifreq ifr;
>                 bool need_copyout;
>                 if (copy_from_user(&ifr, argp, sizeof(struct ifreq)))
> @@ -1118,6 +1118,8 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
>                 if (!err && need_copyout)
>                         if (copy_to_user(argp, &ifr, sizeof(struct ifreq)))
>                                 return -EFAULT;
> +       } else {
> +               err = -ENOTTY;
>         }
>         return err;
>  }
> @@ -3306,6 +3308,8 @@ static int compat_ifr_data_ioctl(struct net *net, unsigned int cmd,
>         struct ifreq ifreq;
>         u32 data32;
>
> +       if (!is_dev_ioctl_cmd(cmd))
> +               return -ENOTTY;
>         if (copy_from_user(ifreq.ifr_name, u_ifreq32->ifr_name, IFNAMSIZ))
>                 return -EFAULT;
>         if (get_user(data32, &u_ifreq32->ifr_data))

This adds yet another long switch() statement into the socket ioctl
case, when there
is already one in compat_sock_ioctl_trans(), one in dev_ifsioc() and one in
dev_ioctl(), all with roughly the same set of ioctl command codes. If
any of them
are called frequently, that makes it all even slower, so I wonder if
there should
be a larger rework altogether. Maybe something based on a single lookup table
that we search through directly from sock_ioctl()/compat_sock_ioctl() to deal
with the differences in handling (ifreq based, compat handler, proto_ops
override, dev_load, rtnl_lock, rcu_read_lock, CAP_NET_ADMIN, copyout, ...).

You are also adding the checks into different places for native and compat
mode, which makes them diverge more when we should be trying to
make them more common.

I think based on my recent changes, some other simplifications are possible,
based on how the compat path already enumerates all the dev ioctls.

        Arnd
