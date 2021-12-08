Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7103C46DAE2
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 19:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbhLHSVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 13:21:19 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39196 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238761AbhLHSVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 13:21:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9D054CE22FD;
        Wed,  8 Dec 2021 18:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38865C00446;
        Wed,  8 Dec 2021 18:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638987463;
        bh=GphJXWtAKWGWnOk8D6UZiXQve1MESdZihzekQ7unsk0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SpvAIRytYXwboKBCw9ipE8oSVGSrLvBIJxSyBqINpd1yXx9EpeB6LHtQSI6hLXtpo
         Il053Of0TtKOnoGCITUC3cT/X0C8WtDr1BC2/iVXdDiaU+xkXbV6fEruevK9cgvshR
         J2oU9uheW/UfJxiNcl4h1HS5quJOTdImEDTyOFLwehJCIMQ3CjbuvT0oydLrPxzxjw
         7UI8p5whAPWU+YTGA/yi+1PSSfP/VWJUKqvHBR0d7EspJcb7++HjfDXvSerPaXQBst
         k0nY077C4OEnp07k3Mo2yWtYq4ke6xgZlb0KjRlYq9H+ZQhwzKsVjccuXR3UvykbL1
         N9lomo+I+3jFg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] iwlwifi: fix LED dependencies
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211204173848.873293-1-arnd@kernel.org>
References: <20211204173848.873293-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Ayala Beker <ayala.beker@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163898745953.8681.9953401691821732230.kvalo@kernel.org>
Date:   Wed,  8 Dec 2021 18:17:41 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> The dependencies for LED configuration are highly inconsistent and too
> complicated at the moment. One of the results is a randconfig failure I
> get very rarely when LEDS_CLASS is in a loadable module, but the wireless
> core is built-in:
> 
> WARNING: unmet direct dependencies detected for MAC80211_LEDS
>   Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=y] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=MAC80211 [=y])
>   Selected by [m]:
>   - IWLEGACY [=m] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_INTEL [=y]
>   - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_INTEL [=y] && IWLWIFI [=m] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=IWLWIFI [=m]) && (IWLMVM [=m] || IWLDVM [=m])
> 
> aarch64-linux-ld: drivers/net/wireless/ath/ath5k/led.o: in function `ath5k_register_led':
> led.c:(.text+0x60): undefined reference to `led_classdev_register_ext'
> aarch64-linux-ld: drivers/net/wireless/ath/ath5k/led.o: in function `ath5k_unregister_leds':
> led.c:(.text+0x200): undefined reference to `led_classdev_unregister'
> 
> For iwlwifi, the dependency is wrong, since this config prevents the
> MAC80211_LEDS code from being part of a built-in MAC80211 driver.
> 
> For iwlegacy, this is worse because the driver tries to force-enable
> the other subsystems, which is both a layering violation and a bug
> because it will still fail with MAC80211=y and IWLEGACY=m, leading
> to LEDS_CLASS being a module as well.
> 
> The actual link failure in the ath5k driver is a result of MAC80211_LEDS
> being enabled but not usable. With the Kconfig logic fixed in the
> Intel drivers, the ath5k driver works as expected again.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Luca Coelho <luciano.coelho@intel.com>

3 patches applied to wireless-drivers.git, thanks.

efdbfa0ad03e iwlwifi: fix LED dependencies
c68115fc5375 brcmsmac: rework LED dependencies
f7d55d2e439f mt76: mt7921: fix build regression

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211204173848.873293-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

