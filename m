Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19AD43084D4
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 06:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbhA2FJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 00:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhA2FI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 00:08:57 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDB5C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 21:08:16 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id e9so5718220pjj.0
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 21:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=frkVgokiXMUxh/3bDonNU4bK0G5SnbhdmwYN9oEyfTA=;
        b=Oa68RogVbYw0X7+iVFX+CLAap4Gst3U0Mnhkbdwf1vlC4bee4YBKLHVu5g0hGMj9sQ
         l5RQ/p3gkJLy6ZR6YnztpWXgQ3DzAPR8YTiSqfOi2Q0Bvdkg0NksPds/zEMCh3aEoM9j
         7Pm6PB+j28/2eYNMkLOCQnpLzpsUGEB++tRA6CvZwNepIUB/E2QKT7Ymw/OLAWsdi4Oy
         Y49RtEGYnnmGBPul1nMbOzQ3jtsI3/49NK+TdIv+VgzXmu+PHO71iJ1yUqvlU9Fo8l/Z
         ws2JdtHf6xPUgZkv3woygMc/fqeG3cZHHBVmeDRS0caReS+BXXTZxyRWpGLVQwa6IOya
         lQZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=frkVgokiXMUxh/3bDonNU4bK0G5SnbhdmwYN9oEyfTA=;
        b=YTmz1MeBHN4FY0kk6J4GPNiJWyYN4+JP/SEFGnMWkkwSkttyilxTPuwx83W/RCTF8m
         wz+F5gCOH2ckIizI8xNanDggjS3uW7Sdtkplsj+Pu0B/qwk+krnL22s2YZVHarDKuNdd
         7wp1QVMbm+5AlsVcp+dO9Q9gC1MBUKB0Kt4W/uq4CZIHHBipk+r1g2b+mxqDsU0JWEHK
         RdqGNsglO/qX2R/sYhp2t+jolU3I3Ut38IApj7IWwifsrp+OJCcHS+ANt28pgOg1eNT6
         UZEjoi3tMWnqnDdlgMKLuhqDNmN+FHlwUCanfQg2iv/ATQTFMU2ci3fQEeDyZjoC0Jj8
         mr4A==
X-Gm-Message-State: AOAM533cC2y64mqbJ8wna7Tr0n1gIjLHNQIlWcJ1dguod8v9o+VjH7xs
        SHcM7s991wOAYzZTyRIkFWoENmQu0cnp1waolvg=
X-Google-Smtp-Source: ABdhPJzG+1ypiMwNkS/IF2vYcVP6PnSC7wrsBJdj3xLdJ20/IgCEQWQ8bdycJ46N01gesHpcIY751hpt+K73ik7h4CE=
X-Received: by 2002:a17:902:d909:b029:df:52b4:8147 with SMTP id
 c9-20020a170902d909b02900df52b48147mr2554059plz.33.1611896896420; Thu, 28 Jan
 2021 21:08:16 -0800 (PST)
MIME-Version: 1.0
References: <20210124013049.132571-1-xiyou.wangcong@gmail.com> <20210128125529.5f902a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210128125529.5f902a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 28 Jan 2021 21:08:05 -0800
Message-ID: <CAM_iQpU-jBkmf6DYtGAA78fAZdemKNT50BSoUco-XngyUPYMhg@mail.gmail.com>
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

On Thu, Jan 28, 2021 at 12:55 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 23 Jan 2021 17:30:49 -0800 Cong Wang wrote:
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
> > will not affect the slow path.
> >
> > Fixes: 3710becf8a58 ("net: RCU locking for simple ioctl()")
> > Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
> > Cc: Eric Dumazet <eric.dumazet@gmail.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
>
> The addition of the write lock scares me a little for a fix, there's a
> lot of code which can potentially run under the callbacks and notifiers
> there.
>
> What about using a seqlock?

Actually I did use seqlock in my initial version (not posted), it does not
allow blocking inside write_seqlock() protection, so I have to change
to rwsem.

Thanks.
