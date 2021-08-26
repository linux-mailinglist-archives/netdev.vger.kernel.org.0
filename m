Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6F83F8F19
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243466AbhHZTrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237981AbhHZTrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:47:15 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E254C0613C1
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:46:27 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id j18so5194331ioj.8
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IokDP2HWe55ZjXE7xtTpkpiTxzH9+5nmAT7GHdxH8j0=;
        b=EDhyloEDMIWXQ6jhn7tD6RpuUdcxtDUO/uMYJHOWezoifS7LUqd8Aa0p1Ylx35kqOW
         v93m8vH0UPd8OwluQPWFl9OHbI/E9v9m7Y1QFII/pTPOgn8ydKu94HgYW4O4UltWQmFf
         VHzJadJC2OqM1feWPQnf8DLKzTz3W0s1lNXmQDGNpwnBOt/9YLD7WTIVSkjyhjzAu2YY
         373dauNPcUBYzpxR+gc1QzZOQerEf51Gf+0p+zLT571QQkEcFKMC5ccBKZHgU+QadY7V
         8EbpBmgAEnn6qA2DQGp/mBEit5QXfEvHyF4j6IjRLWSpFGhlh34R29jKMlDsNPTLBWn5
         sIRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IokDP2HWe55ZjXE7xtTpkpiTxzH9+5nmAT7GHdxH8j0=;
        b=l800DGk4mJJylLi0q2MQgZ7ujSTXPxOhr3E/wxcu5oNp5o1AgE4nAJ5IcEWORA9IJ4
         mRnPsqNO70HSHbO61N/JExpQX4EZHWJ7l/RS9u12P9E2V0/uhDYBMpfvvFy/4Py5jSy1
         QpP64nzUtaT0h097z9J0+ERFhsN/fBlz5NKC3I9D1PlGAItObslQYHvwq5MRwZGqgs1o
         M+YHfoK3UZDAWSCtSuD+scza1dK0zZVy8IX7X/uX2k3HMvOw3uY9CqY/I5IEt+iRI+n6
         VRnmf2jHzBLgSDcOQzUSwc/oVTy8xwqSrcNgNaL1QmU0M6xdeC8YufXMh9WiXb/kFINB
         e8uA==
X-Gm-Message-State: AOAM531RpUOFHIv/2nWEPKAp1bgQNOg/NYWrdRaxH+s7I2znEV0sIsYn
        CBUt9Fv8lHpkqaqEhpToxMYyE2iVA6ZQjeVIt5asCw==
X-Google-Smtp-Source: ABdhPJwolqCx4Q3n5fEvkPYD6T0i3SEfP10DywVBByo737JOVOv+Xg4Jj5jwOEGMT29Z/FzYj+zOtKraTZ+tAbGqoXY=
X-Received: by 2002:a02:708f:: with SMTP id f137mr4853755jac.68.1630007186815;
 Thu, 26 Aug 2021 12:46:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210826012722.3210359-1-pcc@google.com> <YSc3MGVllU8qSJXV@kroah.com>
In-Reply-To: <YSc3MGVllU8qSJXV@kroah.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Thu, 26 Aug 2021 12:46:15 -0700
Message-ID: <CAMn1gO6W=pHwugxA_ep+vZMK5M6xmw7kn5GOZiM=rb0QV5Di6Q@mail.gmail.com>
Subject: Re: [PATCH] net: don't unconditionally copy_from_user a struct ifreq
 for socket ioctls
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Al Viro <viro@zeniv.linux.org.uk>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 11:39 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Aug 25, 2021 at 06:27:22PM -0700, Peter Collingbourne wrote:
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
> >
> > Fixes: 44c02a2c3dc5 ("dev_ioctl(): move copyin/copyout to callers")
> > Link: https://linux-review.googlesource.com/id/I869da6cf6daabc3e4b7b82ac979683ba05e27d4d
> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > Cc: <stable@vger.kernel.org> # 4.19
> > ---
> >  include/linux/netdevice.h |  1 +
> >  net/core/dev_ioctl.c      | 64 ++++++++++++++++++++++++++++++++-------
> >  net/socket.c              |  6 +++-
> >  3 files changed, 59 insertions(+), 12 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index eaf5bb008aa9..481b90ef0d32 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -4012,6 +4012,7 @@ int netdev_rx_handler_register(struct net_device *dev,
> >  void netdev_rx_handler_unregister(struct net_device *dev);
> >
> >  bool dev_valid_name(const char *name);
> > +bool is_dev_ioctl_cmd(unsigned int cmd);
>
> "is_socket_ioctl_cmd()" might be a better global name here.

SGTM, done in v2.

Peter
