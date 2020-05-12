Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2849B1CEC94
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 07:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgELFyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 01:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725536AbgELFyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 01:54:36 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E8CC061A0C;
        Mon, 11 May 2020 22:54:34 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gtucker)
        with ESMTPSA id 44C582A021E
Subject: Re: stable/linux-4.4.y bisection: baseline.login on
 at91-sama5d4_xplained
References: <5eb8399a.1c69fb81.c5a60.8316@mx.google.com>
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Message-ID: <2db7e52e-86ae-7c87-1782-8c0cafcbadd8@collabora.com>
Date:   Tue, 12 May 2020 06:54:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <5eb8399a.1c69fb81.c5a60.8316@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please see the bisection report below about a boot failure.

Reports aren't automatically sent to the public while we're
trialing new bisection features on kernelci.org but this one
looks valid.

It appears to be due to the fact that the network interface is
failing to get brought up:

[  114.385000] Waiting up to 10 more seconds for network.
[  124.355000] Sending DHCP requests ...#
..#
.#
 timed out!
[  212.355000] IP-Config: Reopening network devices...
[  212.365000] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
#


I guess the board would boot fine without network if it didn't
have ip=dhcp in the command line, so it's not strictly a kernel
boot failure but still an ethernet issue.

There wasn't any failure reported by kernelci on linux-4.9.y so
maybe this patch was applied by mistake on linux-4.4.y but I
haven't investigated enough to prove this.

Thanks,
Guillaume


On 10/05/2020 18:27, kernelci.org bot wrote:
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> * This automated bisection report was sent to you on the basis  *
> * that you may be involved with the breaking commit it has      *
> * found.  No manual investigation has been done to verify it,   *
> * and the root cause of the problem may be somewhere else.      *
> *                                                               *
> * If you do send a fix, please include this trailer:            *
> *   Reported-by: "kernelci.org bot" <bot@kernelci.org>          *
> *                                                               *
> * Hope this helps!                                              *
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> 
> stable/linux-4.4.y bisection: baseline.login on at91-sama5d4_xplained
> 
> Summary:
>   Start:      e157447efd85b Linux 4.4.223
>   Plain log:  https://storage.kernelci.org/stable/linux-4.4.y/v4.4.223/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
>   HTML log:   https://storage.kernelci.org/stable/linux-4.4.y/v4.4.223/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
>   Result:     0d1951fa23ba0 net: phy: Avoid polling PHY with PHY_IGNORE_INTERRUPTS
> 
> Checks:
>   revert:     PASS
>   verify:     PASS
> 
> Parameters:
>   Tree:       stable
>   URL:        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
>   Branch:     linux-4.4.y
>   Target:     at91-sama5d4_xplained
>   CPU arch:   arm
>   Lab:        lab-baylibre
>   Compiler:   gcc-8
>   Config:     multi_v7_defconfig
>   Test case:  baseline.login
> 
> Breaking commit found:
> 
> -------------------------------------------------------------------------------
> commit 0d1951fa23ba0d35a4c5498ff28d1c5206d6fcdd
> Author: Florian Fainelli <f.fainelli@gmail.com>
> Date:   Mon Jan 18 19:33:06 2016 -0800
> 
>     net: phy: Avoid polling PHY with PHY_IGNORE_INTERRUPTS
>     
>     commit d5c3d84657db57bd23ecd58b97f1c99dd42a7b80 upstream.
>     
>     Commit 2c7b49212a86 ("phy: fix the use of PHY_IGNORE_INTERRUPT") changed
>     a hunk in phy_state_machine() in the PHY_RUNNING case which was not
>     needed. The change essentially makes the PHY library treat PHY devices
>     with PHY_IGNORE_INTERRUPT to keep polling for the PHY device, even
>     though the intent is not to do it.
>     
>     Fix this by reverting that specific hunk, which makes the PHY state
>     machine wait for state changes, and stay in the PHY_RUNNING state for as
>     long as needed.
>     
>     Fixes: 2c7b49212a86 ("phy: fix the use of PHY_IGNORE_INTERRUPT")
>     Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 7d2cf015c5e76..b242bec834f4b 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -912,10 +912,10 @@ void phy_state_machine(struct work_struct *work)
>  		phydev->adjust_link(phydev->attached_dev);
>  		break;
>  	case PHY_RUNNING:
> -		/* Only register a CHANGE if we are polling or ignoring
> -		 * interrupts and link changed since latest checking.
> +		/* Only register a CHANGE if we are polling and link changed
> +		 * since latest checking.
>  		 */
> -		if (!phy_interrupt_is_valid(phydev)) {
> +		if (phydev->irq == PHY_POLL) {
>  			old_link = phydev->link;
>  			err = phy_read_status(phydev);
>  			if (err)
> @@ -1015,8 +1015,13 @@ void phy_state_machine(struct work_struct *work)
>  	dev_dbg(&phydev->dev, "PHY state change %s -> %s\n",
>  		phy_state_to_str(old_state), phy_state_to_str(phydev->state));
>  
> -	queue_delayed_work(system_power_efficient_wq, &phydev->state_queue,
> -			   PHY_STATE_TIME * HZ);
> +	/* Only re-schedule a PHY state machine change if we are polling the
> +	 * PHY, if PHY_IGNORE_INTERRUPT is set, then we will be moving
> +	 * between states from phy_mac_interrupt()
> +	 */
> +	if (phydev->irq == PHY_POLL)
> +		queue_delayed_work(system_power_efficient_wq, &phydev->state_queue,
> +				   PHY_STATE_TIME * HZ);
>  }
>  
>  void phy_mac_interrupt(struct phy_device *phydev, int new_link)
> -------------------------------------------------------------------------------
> 
> 
> Git bisection log:
> 
> -------------------------------------------------------------------------------
> git bisect start
> # good: [b63f449e18b130fdc372b9717e72c19b83fc4876] Linux 4.4.222
> git bisect good b63f449e18b130fdc372b9717e72c19b83fc4876
> # bad: [e157447efd85bb2e6f8deaabbb62663bccd9bad2] Linux 4.4.223
> git bisect bad e157447efd85bb2e6f8deaabbb62663bccd9bad2
> # bad: [5733a9f4a3df384097c92c532aed34bc698a9acd] net: dsa: slave: fix of-node leak and phy priority
> git bisect bad 5733a9f4a3df384097c92c532aed34bc698a9acd
> # good: [1ce6993b857318a4b8c674b1bbaaf79aced34136] net/mlx5e: Fix blue flame quota logic
> git bisect good 1ce6993b857318a4b8c674b1bbaaf79aced34136
> # good: [c32532162f8ea4beed50a20cf4f9b205c75fe1b1] serial: samsung: Fix possible out of bounds access on non-DT platform
> git bisect good c32532162f8ea4beed50a20cf4f9b205c75fe1b1
> # good: [25e8aad6f491da6ae330148da09585371a3790f2] Revert "ACPI / LPSS: allow to use specific PM domain during ->probe()"
> git bisect good 25e8aad6f491da6ae330148da09585371a3790f2
> # good: [2f3e56e4b6020812350190f1cada230d790ce0e8] powerpc/tm: Fix stack pointer corruption in __tm_recheckpoint()
> git bisect good 2f3e56e4b6020812350190f1cada230d790ce0e8
> # bad: [0d1951fa23ba0d35a4c5498ff28d1c5206d6fcdd] net: phy: Avoid polling PHY with PHY_IGNORE_INTERRUPTS
> git bisect bad 0d1951fa23ba0d35a4c5498ff28d1c5206d6fcdd
> # good: [4ebef63e925e37f5de2f9da8fc86a545e4e0b945] sctp: fix the transports round robin issue when init is retransmitted
> git bisect good 4ebef63e925e37f5de2f9da8fc86a545e4e0b945
> # good: [c175435fdf50c81ca2b6576f090cba31c3489209] NFC: nci: memory leak in nci_core_conn_create()
> git bisect good c175435fdf50c81ca2b6576f090cba31c3489209
> # first bad commit: [0d1951fa23ba0d35a4c5498ff28d1c5206d6fcdd] net: phy: Avoid polling PHY with PHY_IGNORE_INTERRUPTS
> -------------------------------------------------------------------------------
> 

