Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A90308551
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 06:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhA2Fr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 00:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbhA2Fr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 00:47:56 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47641C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 21:47:16 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id o63so5910271pgo.6
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 21:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=auSLXYhhYbjwbYiADe8DSIg7ijrWddQQMaLMri865iI=;
        b=m8Qd8I8KWETbo4Yd2HUZ4fu4yXkub+Z49wLTGAbM5P+yHKMHzt4ctJ8nF7h4fxirhw
         VcOLXBePlOgoGVIVDveKaL6o9UibsrUdvZT4JaDTipbc5EAXdGYvmP9G61U0VLb2vTwr
         SZZhxc/KqJgChqkqg/SZ8EsaJa8z+TXiNgIUKT/nSZqlnksvfDvpQlV5YmerloWzY0UG
         sKlfFVRU4JhF+yQz1k3u42KLzmQKut2E9yN8A9wSuSJ3oeXM+VrXytAvpyV4wOURspgb
         oe0LF9RySDLa0963vQc/cXN6HbaD0dBApTgnNXsCyCkhJbb/41U0VlytebxTs1HUvhSV
         4/EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=auSLXYhhYbjwbYiADe8DSIg7ijrWddQQMaLMri865iI=;
        b=gd9EoMU0dPvfYU6EAYZyxsIwc2f5SuSxAWLsCRCdcrpY9nXbYXoFzD26H4/Y61iKqW
         xC3QTU+Y4to1X0V6h++HVrC5zY1PIhq+9vm7KpINw9NSQAfIqGS2mX++bC+dbK5VzWQ0
         0T5tvezSssiKDvYBwanLaf7D/M6DXYrTiJqtMa1+BmVStRRVFK4OvWmJ0gm+XyDjZ/QK
         50jKJ6Af92v95Vin9P/t+vQdMPvwonaTAPsFlruvL+WZwLCkX15BBmNSCopuOQC1ovA5
         ZpVGwYFoy3+dCCZ5f6qCTlRw8qv95xzoU8QHK14ETCm5qVALLWyDvdzvgsy/ocrQgYR+
         A//g==
X-Gm-Message-State: AOAM533RCrMR4/JKIYX2AxaVNk+uqIdgUG2Ma90T4CHwVukNOVr32sQn
        ZdH3q+glFnobkzoLVI868BqK5EKxmqjSkFj5bR1DWEU/AklmtA==
X-Google-Smtp-Source: ABdhPJwOZBNV8WahLaUOxVZPsVWJPuJ0iXX+Ekxs+FYArtPSSK2MfZ2TMQ5SeJ84EPPttf2RgiBfkAQcrgOJjNgR0Nk=
X-Received: by 2002:a62:ac18:0:b029:1c0:4398:33b5 with SMTP id
 v24-20020a62ac180000b02901c0439833b5mr2940612pfe.10.1611899235713; Thu, 28
 Jan 2021 21:47:15 -0800 (PST)
MIME-Version: 1.0
References: <20210124013049.132571-1-xiyou.wangcong@gmail.com>
 <20210128125529.5f902a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpU-jBkmf6DYtGAA78fAZdemKNT50BSoUco-XngyUPYMhg@mail.gmail.com> <20210128212130.6bda5d5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210128212130.6bda5d5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 28 Jan 2021 21:47:04 -0800
Message-ID: <CAM_iQpUGR1OjeEcsFqkeZZRHDkiQ=+=OiSAB8EgzxG9Dh-5c5w@mail.gmail.com>
Subject: Re: [Patch net] net: fix dev_ifsioc_locked() race condition
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 9:21 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 28 Jan 2021 21:08:05 -0800 Cong Wang wrote:
> > On Thu, Jan 28, 2021 at 12:55 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Sat, 23 Jan 2021 17:30:49 -0800 Cong Wang wrote:
> > > > From: Cong Wang <cong.wang@bytedance.com>
> > > >
> > > > dev_ifsioc_locked() is called with only RCU read lock, so when
> > > > there is a parallel writer changing the mac address, it could
> > > > get a partially updated mac address, as shown below:
> > > >
> > > > Thread 1                      Thread 2
> > > > // eth_commit_mac_addr_change()
> > > > memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
> > > >                               // dev_ifsioc_locked()
> > > >                               memcpy(ifr->ifr_hwaddr.sa_data,
> > > >                                       dev->dev_addr,...);
> > > >
> > > > Close this race condition by guarding them with a RW semaphore,
> > > > like netdev_get_name(). The writers take RTNL anyway, so this
> > > > will not affect the slow path.
> > > >
> > > > Fixes: 3710becf8a58 ("net: RCU locking for simple ioctl()")
> > > > Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
> > > > Cc: Eric Dumazet <eric.dumazet@gmail.com>
> > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > >
> > > The addition of the write lock scares me a little for a fix, there's a
> > > lot of code which can potentially run under the callbacks and notifiers
> > > there.
> > >
> > > What about using a seqlock?
> >
> > Actually I did use seqlock in my initial version (not posted), it does not
> > allow blocking inside write_seqlock() protection, so I have to change
> > to rwsem.
>
> Argh, you're right. No way we can construct something that tries to
> read once and if it fails falls back to waiting for RTNL?

I don't think there is any way to tell whether the read fails, a partially
updated address can not be detected without additional flags etc..

And devnet_rename_sem is already there, pretty much similar to this
one.

Thanks.
