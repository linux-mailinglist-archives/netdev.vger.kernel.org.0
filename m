Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB2546B357
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 08:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhLGHIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 02:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhLGHIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 02:08:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55284C061746;
        Mon,  6 Dec 2021 23:05:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB6C2B812A7;
        Tue,  7 Dec 2021 07:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0391EC341C3;
        Tue,  7 Dec 2021 07:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638860702;
        bh=yWzt1aeH4MsSwkVPM8nWDF34gvx3pob6VEdOOSFPds8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YZeC7ZwcgZB7JAui1TaysBm8KP7oTxOJsIWO7AtwiVlgdXWdD/3LG/U28Es8vyDLn
         Sk3Vk2DZ0QR9Q7UfQKsXffIYv1/Ksy9MvjH1Pb8HrCf1SvdKDCeiChQcPeQf2Uty4G
         OfYrebBOT747Clx5eiOscyAQ2ACzjiKwGEg1+tMCf2+eDWk9BKG1MPK2OwgVyF4xja
         B9OwXkLSfSO4Ib6m+trpA3HqEXv4Ug7ee91cFX/B49hh4jX1cR7oXAmkCNaUb+GjwC
         xwvAYOdb2YrcnErfFCcdgH//Gna9w3JzxKWStmD4TCOendMEyD6MMIyZcDNIVssdTH
         KzYCsjPWyyd/w==
From:   Kalle Valo <kvalo@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Stanislaw Gruszka <stf_xl@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Ayala Beker <ayala.beker@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] iwlwifi: fix LED dependencies
References: <20211204173848.873293-1-arnd@kernel.org>
Date:   Tue, 07 Dec 2021 09:04:56 +0200
In-Reply-To: <20211204173848.873293-1-arnd@kernel.org> (Arnd Bergmann's
        message of "Sat, 4 Dec 2021 18:38:33 +0100")
Message-ID: <87ilw0uc87.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

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

Luca, I would like to take this to wireless-drivers. Ack?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
