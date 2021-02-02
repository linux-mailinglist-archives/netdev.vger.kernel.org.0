Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDAF30B710
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 06:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhBBFcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 00:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbhBBFcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 00:32:45 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AF7C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 21:27:44 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id lw17so1090179pjb.0
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 21:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LXIyPYOIJaWg4hluaasGkPQ5AmlHk1prYYZONq/DOrI=;
        b=ik5nBR+VSBEZD4jZFMn0tE+dIlvJjxXElbmKE4pMYu1KDQ9Efv+xL61XDIwCiFOzuk
         FiC6TWnXVhZnqCa3MS6FAGHP8i5nEB5pmiWgP+gezHMMB9IDcL7TLefKCNkvpBO3dgUk
         O76pjWRwufebtd6x3NzbGzsO9pvZm/uTgrXzAjsNgIhBxndyYThHNgFxkpnixfqIHjJp
         vrWttIP7DbJ6YhBJGP1plTV2QORJw1Xa95LdQmVys3i2+sVwWfxX4gaybfxPCILFlUxE
         kWCUFmHtDGg2TIKZ/uPeSnT7+1K8thfq2G9XcE73BZ/0cCyHuvH22Xk12JftXZqchZJt
         ctCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LXIyPYOIJaWg4hluaasGkPQ5AmlHk1prYYZONq/DOrI=;
        b=Sn0hbCbbOoIbuvH+y4hK2dDSn6fbtvce93Emx2UVXyEGh5oNq890CHVh26iuFiV5nJ
         LM6qFp5S7rRns+uCw7CXrXBtOva0hmg7lNXAhpi9cKhb4MoZ1Q0fzfJKajS4zm+qvmWy
         K+1GiKZ1coeaX0YcB3qUuW49xvqX9e483qCbhOz+LTU6ChVPQntWEzsLxZ3Gz4qDGUUn
         AMFN0l+mAST3zRsJ6Io/BfdWGQw+Xmbgr0i5hClOiRT7ks1Ox1kyO9JpPU37RjxUnWRl
         8K/gEur7MxTu2ThxEosgHmd9wNY3UUVdorBp/Z3r6J2QbXU2j4rQF8CVPKRma0aR6xQU
         o4Fg==
X-Gm-Message-State: AOAM533Ps57rLgPkmXKaj8s6yQG1QARpR0XTPw0CuNvY/1rdwJFc2JZY
        sVI4r2bcBQUhVycaNbPXMVDgZzySPhTmvkByf8sYOMg5Ek4=
X-Google-Smtp-Source: ABdhPJzHLK1XyFg81swrqwAwbrrryFdQXAlxyc7UFbZ5RHdQ55QHUpL8HMRREEmLXgkj1j6vAY6P58SmTpS9j8W+b8A=
X-Received: by 2002:a17:90a:8594:: with SMTP id m20mr2418421pjn.215.1612243664451;
 Mon, 01 Feb 2021 21:27:44 -0800 (PST)
MIME-Version: 1.0
References: <20210131022755.106005-1-xiyou.wangcong@gmail.com> <20210201194014.1bffeb9e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210201194014.1bffeb9e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 1 Feb 2021 21:27:33 -0800
Message-ID: <CAM_iQpVa8KSD5GKf0reC8=Ni_uT+GveXtR1qADPff1DvwWyTFw@mail.gmail.com>
Subject: Re: [Patch net-next v2] net: fix dev_ifsioc_locked() race condition
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 7:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 30 Jan 2021 18:27:55 -0800 Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > dev_ifsioc_locked() is called with only RCU read lock, so when
> > there is a parallel writer changing the mac address, it could
> > get a partially updated mac address, as shown below:
> >
> > Thread 1                      Thread 2
> > // eth_commit_mac_addr_change()
> > memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
> >                               // dev_ifsioc_locked()
> >                               memcpy(ifr->ifr_hwaddr.sa_data,
> >                                       dev->dev_addr,...);
> >
> > Close this race condition by guarding them with a RW semaphore,
> > like netdev_get_name(). The writers take RTNL anyway, so this
> > will not affect the slow path. To avoid bothering existing
> > dev_set_mac_address() callers in drivers, introduce a new wrapper
> > just for user-facing callers in ioctl and rtnetlink.
>
> Some of the drivers need to be update, tho, right? At a quick look at
> least bond and tun seem to be making calls to dev_set_mac_address()
> on IOCTL paths.

Ah, good catch! Clearly I missed those special IOCTL's.

Thanks,
