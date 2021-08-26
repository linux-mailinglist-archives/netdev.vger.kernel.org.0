Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CE73F8F1E
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243550AbhHZTrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243546AbhHZTra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:47:30 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B01C0613D9
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:46:42 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id r6so4414832ilt.13
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ND4yn/1SmcP9xW2m2FDAl95SE8yMvUFBbr7BQutHxo=;
        b=DvDAFMdW/fQJVIb0i7cpnul6F/RQuRy4dE/R/c9FQ/D+fYMqdJaowOtPqBfG3D4Ekv
         ounmGT/A+UsimLCwsNQSkFi7ZoEsVe21zBn7l3Ow2Q8mXJHEcl992+cRXdQvzcKV4zrX
         z/dbXjA+6FPfReflCGfNDcBRHjte67+/t6g0IE/SkWdPbRJrQPP891DBELq449pQhkHZ
         VMbWBvG+jFH3/fc0MtZsKTLPtM4qP/85lbWel96mHOsEh2/AjF6FGo96PQeN8xA/QCmh
         fJNRXgP2Q3/zdH8dZHoW9GuZrl+Ag8T01TxAXutaZb+y6Ut7e6iLCS5RI7hu2LbsvJ+W
         gUiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ND4yn/1SmcP9xW2m2FDAl95SE8yMvUFBbr7BQutHxo=;
        b=CS3G8LBDXpadkApUb5nIJs9lW0IqrsIMQJFpGquGyOcUW92JtHevR8P45f4OtrWGVu
         e/qsm8iSHL/yW6+ARQQ6sZnfh3sB7kBhjK2Dfgp0I7NHM5BzPa2vfpkFVdOuVIwPq1OB
         es0k7mT9w2dxi/ODI3crhF33eWMe2w0a15aB4ce68lQWl9UdGoZsJxOgNpvpt9lgTNGd
         n8QXsl+/3hqAn6091tPH3y7q9WyvZUBnNKbjf0f0DEXdUJMS+NO6Vj5V+XcAUcZqxX4O
         p92kh1YqrpkqMK/CeA3HW9ihI/eNVX78v6TURPGGAbqGbS9vd6tfASZU+ow/eIBglWgs
         vO8g==
X-Gm-Message-State: AOAM532HVNn6u0cHe5SyYQvPRpUCwYeSuiT1uogig24wtdq1pInQX9sg
        LaXD9ZT3GKUBfUcb+oaupKzRc1fU9tU11vKUpJV9Iw==
X-Google-Smtp-Source: ABdhPJzVJOw4A7HLD1tWXIPxdj2HhG5rlJp1kikgH6+nwhFMo40kmswyupjbTigxHepHUGvKIC1RTSX6gQK1sySC32I=
X-Received: by 2002:a05:6e02:e53:: with SMTP id l19mr3992109ilk.108.1630007201637;
 Thu, 26 Aug 2021 12:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210826012722.3210359-1-pcc@google.com> <CAK8P3a0Euhxqz50SSid4GmxH1+GWG+weqYS8BLjgxR+ZcC-C=g@mail.gmail.com>
In-Reply-To: <CAK8P3a0Euhxqz50SSid4GmxH1+GWG+weqYS8BLjgxR+ZcC-C=g@mail.gmail.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Thu, 26 Aug 2021 12:46:30 -0700
Message-ID: <CAMn1gO5Nr_zQ5Sj3yFhSCtFFQfp4jXNU+UPPfCW3_gwfE6c9gA@mail.gmail.com>
Subject: Re: [PATCH] net: don't unconditionally copy_from_user a struct ifreq
 for socket ioctls
To:     Arnd Bergmann <arnd@kernel.org>
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

On Thu, Aug 26, 2021 at 1:59 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Thu, Aug 26, 2021 at 3:28 AM Peter Collingbourne <pcc@google.com> wrote:
>
> > -       } else {
> > +       } else if (is_dev_ioctl_cmd(cmd)) {
> >                 struct ifreq ifr;
> >                 bool need_copyout;
> >                 if (copy_from_user(&ifr, argp, sizeof(struct ifreq)))
> > @@ -1118,6 +1118,8 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
> >                 if (!err && need_copyout)
> >                         if (copy_to_user(argp, &ifr, sizeof(struct ifreq)))
> >                                 return -EFAULT;
> > +       } else {
> > +               err = -ENOTTY;
> >         }
> >         return err;
> >  }
> > @@ -3306,6 +3308,8 @@ static int compat_ifr_data_ioctl(struct net *net, unsigned int cmd,
> >         struct ifreq ifreq;
> >         u32 data32;
> >
> > +       if (!is_dev_ioctl_cmd(cmd))
> > +               return -ENOTTY;
> >         if (copy_from_user(ifreq.ifr_name, u_ifreq32->ifr_name, IFNAMSIZ))
> >                 return -EFAULT;
> >         if (get_user(data32, &u_ifreq32->ifr_data))
>
> This adds yet another long switch() statement into the socket ioctl
> case, when there
> is already one in compat_sock_ioctl_trans(), one in dev_ifsioc() and one in
> dev_ioctl(), all with roughly the same set of ioctl command codes. If

I think that David's suggestion of using _IOC_TYPE() should be enough
to address this for now.

> any of them
> are called frequently, that makes it all even slower, so I wonder if
> there should
> be a larger rework altogether. Maybe something based on a single lookup table
> that we search through directly from sock_ioctl()/compat_sock_ioctl() to deal
> with the differences in handling (ifreq based, compat handler, proto_ops
> override, dev_load, rtnl_lock, rcu_read_lock, CAP_NET_ADMIN, copyout, ...).
>
> You are also adding the checks into different places for native and compat
> mode, which makes them diverge more when we should be trying to
> make them more common.
>
> I think based on my recent changes, some other simplifications are possible,
> based on how the compat path already enumerates all the dev ioctls.

I think we should leave that for a followup if still necessary.

Peter
