Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6382141FB
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 01:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgGCXon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 19:44:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbgGCXol (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 19:44:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAC3120826;
        Fri,  3 Jul 2020 23:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593819881;
        bh=ogKugypFrNuL4/kvviId7s2E/IlniHWc42em6EWrtjM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qgPKOJ9tw0xVJOvP7r8dcl+gdhHqGtCNeZYohs+aZ1hOfcyhonFx9hQE428T3lsNg
         GBC0ncmQWlHE4E5Ust1qUkf/WwGm95f79oIY96iqSxM0GPYnbvTqC4/B3j/WKDZ3Sc
         Uv9XuO71nqAyQGM201iqYRhO3up3VEjBeLCryE5A=
Date:   Fri, 3 Jul 2020 16:44:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/7] Add devlink-health support for devlink
 ports
Message-ID: <20200703164439.5872f809@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1593746858-6548-1-git-send-email-moshe@mellanox.com>
References: <1593746858-6548-1-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Jul 2020 06:27:31 +0300 Moshe Shemesh wrote:
> Implement support for devlink health reporters on per-port basis. First
> part in the series prepares common functions parts for health reporter
> implementation. Second introduces required API to devlink-health and
> mlx5e ones demonstrate its usage and effectively implement the feature
> for mlx5 driver.
> The per-port reporter functionality is achieved by adding a list of
> devlink_health_reporters to devlink_port struct in a manner similar to
> existing device infrastructure. This is the only major difference and
> it makes possible to fully reuse device reporters operations.
> The effect will be seen in conjunction with iproute2 additions and
> will affect all devlink health commands. User can distinguish between
> device and port reporters by looking at a devlink handle. Port reporters
> have a port index at the end of the address and such addresses can be
> provided as a parameter in every place where devlink-health accepted it.
> These can be obtained from devlink port show command.
> For example:
> $ devlink health show
> pci/0000:00:0a.0:
>   reporter fw
>     state healthy error 0 recover 0 auto_dump true
> pci/0000:00:0a.0/1:
>   reporter tx
>     state healthy error 0 recover 0 grace_period 500 auto_recover true auto_dump true
> $ devlink health set pci/0000:00:0a.0/1 reporter tx grace_period 1000 \
> auto_recover false auto_dump false
> $ devlink health show pci/0000:00:0a.0/1 reporter tx
> pci/0000:00:0a.0/1:
>   reporter tx
>     state healthy error 0 recover 0 grace_period 1000 auto_recover flase auto_dump false

What's the motivation, though?

This patch series achieves nothing that couldn't be previously achieved.

Is there no concern of uAPI breakage with moving the existing health
reporters in patch 7?
