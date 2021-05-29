Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95292394DD2
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 21:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhE2TQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 15:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhE2TQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 15:16:46 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775C4C061574;
        Sat, 29 May 2021 12:15:08 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id e7so1138061plj.7;
        Sat, 29 May 2021 12:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4JV2W29y26pepLG4gekNYXoV2EP+6kk949X/NrDMyWs=;
        b=JKM1zRuRupca+dp8XU2VFl9BlSLzntOr8wWJXSKnJ7SEsz6L1y449tyXvkd3DPM8fh
         U2N0aw1FuVz/4bmhhwI8X8OczdScQVWANE2H2CVUN/XFxIXzvpRIMEarGAgWNLxOlUZc
         YWup5xUXUqp/Y/DYP8FtmQUf5QJOMCmP3DJ3zwo9VqWDIXSgnJimp9LcPjQsZ8AdeETm
         5yaktuR6h4bkQ/srUPVXZXxkkfE/vznIvlrAJ9FNjhimyvF6Lzv2PqRmKVG97tN+ZSYR
         sCuBoxG9RInyMdHy1zAt7pXr6I+mRHILoeXiSVyqlgavuBItyhiURNJLpt0p8D5sKNdo
         LGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4JV2W29y26pepLG4gekNYXoV2EP+6kk949X/NrDMyWs=;
        b=S3b/118uPfim1djAeLtbC7/OhvCZ3igU82fMHGgoD1yRDt6QJgqqyzdEvxeR7XNEU0
         ypdEsrCPd2WiIarv86We3/t6+plC7q2U2xQmAs/9D7CVxbjaoIbDojv5cOMwm1k0LlBq
         f4QYBH9U5bkQ5H7g0GxznoFi7l8A10rJyW4rmPeShp3pqqEwfCs1QbxqWo3FCQSQqz0V
         Y3fL3Ipe8HUeiQ/4K/HKDX1ayI+dBqo9Dr2AoPe0MePASNpKPvuuzLylwr5JTjCZBGa1
         dJ5mqQyL77BuMYTr5Q3X8nDc6btYzMmo9yDH6QH3n6U5p5/cZPrOeAOvRHdKAdkD9PsK
         B80w==
X-Gm-Message-State: AOAM531puBUZtDN0Vgnn8yg1+KOEoijRi1C/0wxGU3EfZhBjhhXfB+Qx
        gndZ88w9/i3Af1Xy7JGKq338hEudKC+xPWdA0xA=
X-Google-Smtp-Source: ABdhPJzuKeaiPjj6k1A6fPPa/Rxqnjv0guMS59rNdf5owM9nzddwR3th00IWeJyI6huQfyQgIi/nGmPcuRrisUFtmGY=
X-Received: by 2002:a17:90a:1141:: with SMTP id d1mr10987300pje.56.1622315707909;
 Sat, 29 May 2021 12:15:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210529060526.422987-1-changbin.du@gmail.com>
In-Reply-To: <20210529060526.422987-1-changbin.du@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 29 May 2021 12:14:57 -0700
Message-ID: <CAM_iQpWwApLVg39rUkyXxnhsiP0SZf=0ft6vsq=VxFtJ2SumAQ@mail.gmail.com>
Subject: Re: [PATCH] net: fix oops in socket ioctl cmd SIOCGSKNS when NET_NS
 is disabled
To:     Changbin Du <changbin.du@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kici nski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 11:08 PM Changbin Du <changbin.du@gmail.com> wrote:
> diff --git a/net/socket.c b/net/socket.c
> index 27e3e7d53f8e..644b46112d35 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -1149,11 +1149,15 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>                         mutex_unlock(&vlan_ioctl_mutex);
>                         break;
>                 case SIOCGSKNS:
> +#ifdef CONFIG_NET_NS
>                         err = -EPERM;
>                         if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
>                                 break;
>
>                         err = open_related_ns(&net->ns, get_net_ns);
> +#else
> +                       err = -ENOTSUPP;
> +#endif

I wonder if it is easier if we just reject ns->ops==NULL case
in open_related_ns(). For 1) we can save an ugly #ifdef here;
2) drivers/net/tun.c has the same bugs.

Something like this:

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 800c1d0eb0d0..d63414604e99 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -152,6 +152,9 @@ int open_related_ns(struct ns_common *ns,
        int err;
        int fd;

+       if (!ns->ops)
+               return -EOPNOTSUPP;
+
        fd = get_unused_fd_flags(O_CLOEXEC);
        if (fd < 0)
                return fd;
