Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6FE30E974
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 02:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbhBDBax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 20:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232478AbhBDBas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 20:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 44DA264F60;
        Thu,  4 Feb 2021 01:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612402207;
        bh=nwfi/1UxhX12mPrvHki7pPxyX4rl5qXPeqI9vhAMKkE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AgKPb70r+3owl/Dm07v5Q+fzFu0P1F7aWoHWjPkzkad73UrlHq+DsZB4NDMJFgpuA
         4Nq1CTaESYk9piNimS92t4bWTpL8ikvdVEt3ISeZcX1gQaR6ED7Fop5d11ZsIvfvAU
         2mnE8McoeRtDfCxKuxiO32NodpC6nYxiRowd5xZjJLiKOxtSxv3rZeGgxGfTgQr688
         BTcJ5slfXj8iJ5b9FBmLF0wCzwzYYhr7U4t8uR+UInxRN6+URgo6XDj205Sox84ElW
         caqvJUajmFIhzdvKnstuOX4V4oGyirU4Kfc5+4XCtv3z8yUU38UuQqN8lKrGrNiAut
         f1imesKxuVVZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 254AC609EC;
        Thu,  4 Feb 2021 01:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mscc: ocelot: fix error handling bugs in
 mscc_ocelot_init_ports()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161240220714.12107.14490522702137689689.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Feb 2021 01:30:07 +0000
References: <YBkXhqRxHtRGzSnJ@mwanda>
In-Reply-To: <YBkXhqRxHtRGzSnJ@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 2 Feb 2021 12:12:38 +0300 you wrote:
> There are several error handling bugs in mscc_ocelot_init_ports().  I
> went through the code, and carefully audited it and made fixes and
> cleanups.
> 
> 1) The ocelot_probe_port() function didn't have a mirror release function
>    so it was hard to follow.  I created the ocelot_release_port()
>    function.
> 2) In the ocelot_probe_port() function, if the register_netdev() call
>    failed, then it lead to a double free_netdev(dev) bug.  Fix this by
>    setting "ocelot->ports[port] = NULL" on the error path.
> 3) I was concerned that the "port" which comes from of_property_read_u32()
>    might be out of bounds so I added a check for that.
> 4) In the original code if ocelot_regmap_init() failed then the driver
>    tried to continue but I think that should be a fatal error.
> 5) If ocelot_probe_port() failed then the most recent devlink was leaked.
>    The fix for mostly came Vladimir Oltean.  Get rid of "registered_ports"
>    and just set a bit in "devlink_ports_registered" to say when the
>    devlink port has been registered (and needs to be unregistered on
>    error).  There are fewer than 32 ports so a u32 is large enough for
>    this purpose.
> 6) The error handling if the final ocelot_port_devlink_init() failed had
>    two problems.  The "while (port-- >= 0)" loop should have been
>    "--port" pre-op instead of a post-op to avoid a buffer underflow.
>    The "if (!registered_ports[port])" condition was reversed leading to
>    resource leaks and double frees.
> 
> [...]

Here is the summary with links:
  - [net-next] net: mscc: ocelot: fix error handling bugs in mscc_ocelot_init_ports()
    https://git.kernel.org/netdev/net-next/c/e0c16233577f
  - [v3,2/2,net-next] net: mscc: ocelot: fix error code in mscc_ocelot_probe()
    https://git.kernel.org/netdev/net-next/c/4160d9ec5b41

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


