Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCDA43AD07
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 09:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbhJZHUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 03:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232346AbhJZHUk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 03:20:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E74560F70;
        Tue, 26 Oct 2021 07:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635232696;
        bh=CdUMdfRcqWDhNwmQAj36vhLVojZNQHy9lT5K/KjKYMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IMpKhDTgk6qqXvEK8Vgym2DSX6Naz4rVly5Do50+AOuPPaIlLj9qBJzG7D36obCd8
         TN+SXW3iqrLtZMG6sQfE/i3h/zSKqW5GcBbkvHZWk0fGNPKLUo/dv67/CTQRxTrQcq
         L4EZIp0z0o3CcP59cYH/+leLWRH1MeqVZzGf06Psc3QlBZGyeLnIrzoy3BdMfD+uE2
         QtLg65RaI+w6n27LgCUUxgbOCgDfWTeEOOY5u9Pyw1MEZXcI6P3nlH8stw9Oq2UjMi
         a0c55bWAv9y2MfdX2k7Cx3W/7iwQUPuc+dsE6Ft2+w3on8OvcNsQTgQm9jlLcVj3yb
         21hrdM24YswBg==
Date:   Tue, 26 Oct 2021 10:18:12 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <YXertDP8ouVbdnUt@unreal>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder>
 <YXUtbOpjmmWr71dU@unreal>
 <YXU5+XLhQ9zkBGNY@shredder>
 <YXZB/3+IR6I0b2xE@unreal>
 <YXZl4Gmq6DYSdDM3@shredder>
 <YXaNUQv8RwDc0lif@unreal>
 <YXelYVqeqyVJ5HLc@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXelYVqeqyVJ5HLc@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 09:51:13AM +0300, Ido Schimmel wrote:

<...>

> > 
> > Can you please explain why is it so important to touch devlink SW
> > objects, reallocate them again and again on every reload in mlxsw?
> 
> Because that's how reload was defined and implemented. A complete
> reload. We are not changing the semantics 4 years later.

Please put your emotions aside and explain me technically why are you
must to do it?

The proposed semantics was broken for last 4 years, it can even seen as
dead on arrival, because it never worked for us in real production.

So I'm fixing bugs without relation to when they were introduced.

For example, this fix from Jiri [1] for basic design flow was merged almost
two years later after devlink reload was introduced [2], or this patch from
Parav [3] that fixed an issue introduced year before [4].

[1] 
commit 5a508a254bed9a2e36a5fb96c9065532a6bf1e9c
Author: Jiri Pirko <jiri@mellanox.com>
Date:   Sat Nov 9 11:29:46 2019 +0100

    devlink: disallow reload operation during device cleanup
    
[2] 
commit 2d8dc5bbf4e7603747875eb5cadcd67c1fa8b1bb
Author: Arkadi Sharshevsky <arkadis@mellanox.com>
Date:   Mon Jan 15 08:59:04 2018 +0100

    devlink: Add support for reload

[3]
commit a7b43649507dae4e55ff0087cad4e4dd1c6d5b99
Author: Parav Pandit <parav@nvidia.com>
Date:   Wed Nov 25 11:16:20 2020 +0200

    devlink: Make sure devlink instance and port are in same net namespace

[4]
commit 070c63f20f6c739a3c534555f56c7327536bfcc2
Author: Jiri Pirko <jiri@mellanox.com>
Date:   Thu Oct 3 11:49:39 2019 +0200

    net: devlink: allow to change namespaces during reload

Thanks
