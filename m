Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889E11B03D7
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 10:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgDTIFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 04:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgDTIFY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 04:05:24 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A60A218AC;
        Mon, 20 Apr 2020 08:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587369923;
        bh=JFX+PqkhRvwNBakJkGhcUZ9y1fPjU6PC9WuNF//vw9E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wqewF8JbWUTYVPTE18GOHtWxNhAF/7cyZlBhSvKh4mE8gfReuKSmnOpI+jbWz6dr/
         Uu6v01JDZvtNKedc2CNXetBFjAdTtwJbLI6mK5aP7mJDnGNaelb08xfwHsShmaWI5l
         bEUXWzmldczVVZ1HFSjVl8hmcC/gMwltsgJxcEEk=
Date:   Mon, 20 Apr 2020 11:05:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Borislav Petkov <bp@suse.de>,
        Jessica Yu <jeyu@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/4] kernel/module: Hide vermagic header file
 from general use
Message-ID: <20200420080518.GC121146@unreal>
References: <20200419141850.126507-1-leon@kernel.org>
 <20200419155506.129392-1-leon@kernel.org>
 <CAK7LNASdOf0inF_-f8Gn7_mn1QSdXEi1HTR2zj3DEs38sf96xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK7LNASdOf0inF_-f8Gn7_mn1QSdXEi1HTR2zj3DEs38sf96xA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 07:59:35AM +0900, Masahiro Yamada wrote:
> Hi,
>
> On Mon, Apr 20, 2020 at 12:55 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > VERMAGIC* definitions are not supposed to be used by the drivers,
> > see this [1] bug report, so introduce special define to guard inclusion
> > of this header file and define it in kernel/modules.h and in internal
> > script that generates *.mod.c files.
> >
> > In-tree module build:
> > ➜  kernel git:(vermagic) ✗ make clean
> > ➜  kernel git:(vermagic) ✗ make M=drivers/infiniband/hw/mlx5
> > ➜  kernel git:(vermagic) ✗ modinfo drivers/infiniband/hw/mlx5/mlx5_ib.ko
> > filename:       /images/leonro/src/kernel/drivers/infiniband/hw/mlx5/mlx5_ib.ko
> > <...>
> > vermagic:       5.6.0+ SMP mod_unload modversions
> >
> > Out-of-tree module build:
> > ➜  mlx5 make -C /images/leonro/src/kernel clean M=/tmp/mlx5
> > ➜  mlx5 make -C /images/leonro/src/kernel M=/tmp/mlx5
> > ➜  mlx5 modinfo /tmp/mlx5/mlx5_ib.ko
> > filename:       /tmp/mlx5/mlx5_ib.ko
> > <...>
> > vermagic:       5.6.0+ SMP mod_unload modversions
> >
> > [1] https://lore.kernel.org/lkml/20200411155623.GA22175@zn.tnic
> > Reported-by: Borislav Petkov <bp@suse.de>
> > Acked-by: Borislav Petkov <bp@suse.de>
> > Acked-by: Jessica Yu <jeyu@kernel.org>
> > Co-developed-by: Masahiro Yamada <masahiroy@kernel.org>
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
>
>
> I did not read the full thread of [1],
> and perhaps may miss something.
>
> But, this series is trying to solve a different problem
> "driver code should not include <linux/vermagic.h>"
> isn't it?
>
>
> IIUC, Borislav reported conflict of MODULE_ARCH_VERMAGIC
> if <linux/vermagic.h> is included before <linux/module.h>.
>
> With your cleanups, the include site of <linux/vermagic.h>
> will be limited to kernel/module.c and scripts/mod/module.c
>
> Assuming those two files include them in the *correct* order,
> this problem will be suppressed.
>
> But, I do not think it addresses the problem properly.
>
>
> If
>   #include <foo.h>
>   #include <bar.h>
>
> works, but
>
>   #include <bar.h>
>   #include <foo.h>
>
> does not, the root cause is very likely
> that <bar.h> is not self-contained.
> The problem is solved by including <foo.h> from <bar.h>
>
>
> Please see my thoughts in this:
> https://lore.kernel.org/patchwork/patch/1227024/
>
>
> Of course, we are solving different issues, so I think
> we can merge both.
>
>
> What do you think?

The idea and rationale are right, include order should not be important.

Thanks
