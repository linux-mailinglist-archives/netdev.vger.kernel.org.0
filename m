Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32C92DF6EF
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 22:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgLTVoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 16:44:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727446AbgLTVoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Dec 2020 16:44:16 -0500
Date:   Sun, 20 Dec 2020 22:43:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608500615;
        bh=zRypDAurjZALqdycTeLM6FlnjpYaL3xGyF7Jl1kx6wo=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=VJF6f1B8B2qhaBmMVTYvthwdFabElcMLeF5plZQPkiJCep81WhVNZF82y3T2DxTiB
         LtL666DiCuXarYr8K/jV0btKq7GIrC5hk5NA+HeRKVvjyDfjqRgZIk6Sg01GBMxPtm
         AF7DnduLJmI0C8vZL7yHQ1pa2EUks2QlRj3Q1OTR9XBCs3+VvmGCgt5jEzOhgVx7jV
         rBwGSi/qAPgZpf+ydtMzwsUuA6UIQqNntcLRW+4Bhq1lvXMWtXJz62kL1r7AdLRcOs
         LIJZXb8718PqTumZO5gzRLuXtoYjqdw8lqlYbMK/c6ASp6NgCgh9JfDuy6iPSpxqk1
         YRze22M4a03RA==
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Tsuchiya Yuto <kitakar@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl
Subject: Re: [PATCH 0/3] mwifiex: disable ps_mode by default for stability
Message-ID: <20201220214333.rxtkt72niq7adfin@pali>
References: <20201028142433.18501-1-kitakar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028142433.18501-1-kitakar@gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

Please CC me in future for mwifiex discussion :-)

On Wednesday 28 October 2020 23:24:30 Tsuchiya Yuto wrote:
> Hello all,
> 
> On Microsoft Surface devices (PCIe-88W8897), we are observing stability
> issues when ps_mode (IEEE power_save) is enabled, then eventually causes
> firmware crash. Especially on 5GHz APs, the connection is completely
> unstable and almost unusable.
> 
> I think the most desirable change is to fix the ps_mode itself. But is
> seems to be hard work [1], I'm afraid we have to go this way.
> 
> Therefore, the first patch of this series disables the ps_mode by default
> instead of enabling it on driver init. I'm not sure if explicitly
> disabling it is really required or not. I don't have access to the details
> of this chip. Let me know if it's enough to just remove the code that
> enables ps_mode.
> 
> The Second patch adds a new module parameter named "allow_ps_mode". Since
> other wifi drivers just disable power_save by default by module parameter
> like this, I also added this.
> 
> The third patch adds a message when ps_mode will be changed. Useful when
> diagnosing connection issues.

There are more issues with power save API and implementation in mwifiex.

See my email for more details:
https://lore.kernel.org/linux-wireless/20200609111544.v7u5ort3yk4s7coy@pali/T/#u

These patches would just break power save API and reporting status to
userspace even more due to WIPHY_FLAG_PS_ON_BY_DEFAULT and
CONFIG_CFG80211_DEFAULT_PS options.

I would suggest to first fix issues mentioned in my email and then start
providing a way how to blacklist or whitelist power save feature
depending on firmware or card/chip version.

From my experience I know that e.g. 88W8997 cards have lot of bugs in
their firmware and I'm not aware that bugs are going to be fixed... So
we really need workarounds, like disabling power save mode to have cards
usable.

> Thanks,
> Tsuchiya Yuto
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=109681
> 
> Tsuchiya Yuto (3):
>   mwifiex: disable ps_mode explicitly by default instead
>   mwifiex: add allow_ps_mode module parameter
>   mwifiex: print message when changing ps_mode
> 
>  .../net/wireless/marvell/mwifiex/cfg80211.c   | 23 +++++++++++++++++++
>  .../net/wireless/marvell/mwifiex/sta_cmd.c    | 11 ++++++---
>  2 files changed, 31 insertions(+), 3 deletions(-)
> 
> -- 
> 2.29.1
> 
