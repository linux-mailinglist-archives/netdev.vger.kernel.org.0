Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12043F8F1B
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243505AbhHZTr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhHZTrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:47:25 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA67C061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:46:38 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id e186so5187824iof.12
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W8kFVRLQYAesDVBxw8WdPC0As1KdCG134iI/ODY2Y1Y=;
        b=nKi+TXGJ7ujecbEHxzXU7dV0s9QVYGm3fq19pyC76e7VF80u0pqHzxFWXNGXd7Q0W6
         q+KkLjUzofYGedVr9f4tCicjHYbo6TKFaabPsSk3ZF29izDbmCcBkS0H3q3QHctKgMTy
         /Zn+PvwsDS4mrbz36eTZRZs199Pqibc3QDGDCWbcYu57cU3F3NNCjz35WwM3pw+GFTVc
         HpliF9G1dtalQe47kZy2kG9svB11c7EtcF7xZQVkCZ2TjFi5lNnxrYJnN6h6IA00IJ8z
         BHTQ6bMNNU+ueTlRgkxgeBGM5pNFAyBvBnmFJHOAb0xaRvklgXfc8ocs6X7pR2N1w67H
         kbHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W8kFVRLQYAesDVBxw8WdPC0As1KdCG134iI/ODY2Y1Y=;
        b=e0KrHLiiXvjCeqaz99MQplZzksRFf8agoatoKO34ZkqVHUk6zFl6m1YJ3p1kujJibh
         PwDFFEHZkr+EN0KZsT9A+QvQZ+8fXRDtYUYclECei9F38zGrKTkdb9VpvVmMivHV8qzP
         qs2Uxj0hbl4+dPeZEAG7L5b9V9hFO526afC++VFEys7XplCbJRM8x3/agRCc4xoQWAi+
         Sh1t4en2QOujHEEGz/TMQGnRTQfAsgBuo2Hftgs9uDA4c23J4ZN62S9mTYS6KhI6ddat
         V/L/mRILXq+AwcBcxyI89kKkpEFi6+1AbNBoHh5X/iCOeziztqndRg8qy+G5HwTjC6wx
         Of1g==
X-Gm-Message-State: AOAM532D7IM3iVcBtVoUG18oxrrrEAraF8Zkf8Y89Yd+b6P/kalYEEv9
        WURyb7Op+RZG7VLTIzsJGfTm/HOVSkQa329fg0hLwacooU8=
X-Google-Smtp-Source: ABdhPJwdOThufTbwmrsrSHbN9TM7Lh/yHgwXnAtct0tgQ1dnf0UERIoytNbfjVlu0wHDov2HMm2WPHkKEh44DQcwOxE=
X-Received: by 2002:a05:6602:2ac7:: with SMTP id m7mr4404288iov.66.1630007197520;
 Thu, 26 Aug 2021 12:46:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210826012722.3210359-1-pcc@google.com> <11f72b27c12f46eb8bef1d1773980c54@AcuMS.aculab.com>
In-Reply-To: <11f72b27c12f46eb8bef1d1773980c54@AcuMS.aculab.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Thu, 26 Aug 2021 12:46:26 -0700
Message-ID: <CAMn1gO5eT=S-BcbhDDM9=s5r1zspO==nbJjYV-p9JFq-U5U+eA@mail.gmail.com>
Subject: Re: [PATCH] net: don't unconditionally copy_from_user a struct ifreq
 for socket ioctls
To:     David Laight <David.Laight@aculab.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 1:12 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Peter Collingbourne
> > Sent: 26 August 2021 02:27
> >
> > A common implementation of isatty(3) involves calling a ioctl passing
> > a dummy struct argument and checking whether the syscall failed --
> > bionic and glibc use TCGETS (passing a struct termios), and musl uses
> > TIOCGWINSZ (passing a struct winsize). If the FD is a socket, we will
> > copy sizeof(struct ifreq) bytes of data from the argument and return
> > -EFAULT if that fails. The result is that the isatty implementations
> > may return a non-POSIX-compliant value in errno in the case where part
> > of the dummy struct argument is inaccessible, as both struct termios
> > and struct winsize are smaller than struct ifreq (at least on arm64).
> >
> > Although there is usually enough stack space following the argument
> > on the stack that this did not present a practical problem up to now,
> > with MTE stack instrumentation it's more likely for the copy to fail,
> > as the memory following the struct may have a different tag.
> >
> > Fix the problem by adding an early check for whether the ioctl is a
> > valid socket ioctl, and return -ENOTTY if it isn't.
> ..
> > +bool is_dev_ioctl_cmd(unsigned int cmd)
> > +{
> > +     switch (cmd) {
> > +     case SIOCGIFNAME:
> > +     case SIOCGIFHWADDR:
> > +     case SIOCGIFFLAGS:
> > +     case SIOCGIFMETRIC:
> > +     case SIOCGIFMTU:
> > +     case SIOCGIFSLAVE:
> > +     case SIOCGIFMAP:
> > +     case SIOCGIFINDEX:
> > +     case SIOCGIFTXQLEN:
> > +     case SIOCETHTOOL:
> > +     case SIOCGMIIPHY:
> > +     case SIOCGMIIREG:
> > +     case SIOCSIFNAME:
> > +     case SIOCSIFMAP:
> > +     case SIOCSIFTXQLEN:
> > +     case SIOCSIFFLAGS:
> > +     case SIOCSIFMETRIC:
> > +     case SIOCSIFMTU:
> > +     case SIOCSIFHWADDR:
> > +     case SIOCSIFSLAVE:
> > +     case SIOCADDMULTI:
> > +     case SIOCDELMULTI:
> > +     case SIOCSIFHWBROADCAST:
> > +     case SIOCSMIIREG:
> > +     case SIOCBONDENSLAVE:
> > +     case SIOCBONDRELEASE:
> > +     case SIOCBONDSETHWADDR:
> > +     case SIOCBONDCHANGEACTIVE:
> > +     case SIOCBRADDIF:
> > +     case SIOCBRDELIF:
> > +     case SIOCSHWTSTAMP:
> > +     case SIOCBONDSLAVEINFOQUERY:
> > +     case SIOCBONDINFOQUERY:
> > +     case SIOCGIFMEM:
> > +     case SIOCSIFMEM:
> > +     case SIOCSIFLINK:
> > +     case SIOCWANDEV:
> > +     case SIOCGHWTSTAMP:
> > +             return true;
>
> That is horrid.
> Can't you at least use _IOC_TYPE() to check for socket ioctls.
> Clearly it can succeed for 'random' driver ioctls, but will fail
> for the tty ones.

Yes, that works, since all of the ioctls listed above are in the range
where the _IOC_TYPE() check would succeed. It now also makes sense to
move the check inline into the header. I've done all of that in v2.

> The other sane thing is to check _IOC_SIZE().
> Since all the SIOCxxxx have a correct _IOC_SIZE() that can be
> used to check the user copy length.
> (Unlike socket options the correct length is always supplied.

FWIW, it doesn't look like any of them have the _IOC_SIZE() bits set,
so that won't work. _IOC_TYPE() seems better anyway.

Peter
