Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 915C849DA7
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 11:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbfFRJmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 05:42:37 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7289 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729230AbfFRJmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 05:42:37 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d08b20d0000>; Tue, 18 Jun 2019 02:42:37 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 18 Jun 2019 02:42:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 18 Jun 2019 02:42:36 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Jun
 2019 09:42:33 +0000
Subject: Re: [PATCH net-next 3/3] net: stmmac: Convert to phylink and remove
 phylib logic
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <cover.1560266175.git.joabreu@synopsys.com>
 <6226d6a0de5929ed07d64b20472c52a86e71383d.1560266175.git.joabreu@synopsys.com>
 <d9ffce3d-4827-fa4a-89e8-0492c4bc1848@nvidia.com>
 <78EB27739596EE489E55E81C33FEC33A0B9C8D6E@DE02WEMBXB.internal.synopsys.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <26cfaeff-a310-3b79-5b57-fd9c93bd8929@nvidia.com>
Date:   Tue, 18 Jun 2019 10:42:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B9C8D6E@DE02WEMBXB.internal.synopsys.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1560850957; bh=6ywibFbCY0rz8BUxmWv9bQKBe+TuciATlqPC1X2BbkA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=P2kn25Hju8a0JGq4HOpr3oesLS3VbStz41WoXn91E7n4tmfJGN2W1tVzoLcxiJYGW
         omIDk2J1SSNSo5ACYqkCYb+Sd/YDDeV/7M1jHkL4z1o7Kc6xPwivIcSmOR5O2p3lWi
         gBOFxP+wK1+yK6SJIq7W7bwpkadbnxtGkBZraG/+hsbCb1jd38YKBCtPi7P7Izsruu
         CsuCoFImUu5v1uTBM9iUsgCMoY8ZycyN7VsXI6tYs2S3azEl5eHBMbaoyOT9Q54izE
         6aDSWg7UekE2X9EMGaPmxUSVgECI4fa6aSzlc7YCU073KkVpxZTE7keP2M3Tn3m+RH
         WlBUUzdSOQh9A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18/06/2019 10:35, Jose Abreu wrote:
> From: Jon Hunter <jonathanh@nvidia.com>
> 
>> I am seeing a boot regression on -next for some of our boards that have
>> a synopsys ethernet controller that uses the dwmac-dwc-qos-ethernet
>> driver. Git bisect is pointing to this commit, but unfortunately this
>> cannot be cleanly reverted on top of -next to confirm. 
> 
> Thanks for reporting. Looks like the timer is not setup when 
> stmmac_tx_clean() is called. When do you see this stacktrace ? After 
> ifdown ?

I am not certain but I don't believe so. We are using a static IP address
and mounting the root file-system via NFS when we see this ...

[   10.607510] dwc-eth-dwmac 2490000.ethernet eth0: phy link up rgmii/1Gbps/Full
[   10.607536] dwc-eth-dwmac 2490000.ethernet eth0: phylink_mac_config: mode=phy/rgmii/1Gbps/Full adv=00,00000000,00000000 pause=0f link=1 an=0
[   10.608804] dwc-eth-dwmac 2490000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
[   10.630979] IP-Config: Complete:
[   10.639046]      device=eth0, hwaddr=d2:e5:1c:57:26:4b, ipaddr=192.168.99.2, mask=255.255.255.0, gw=192.168.99.1
[   10.649201]      host=192.168.99.2, domain=, nis-domain=(none)
[   10.655022]      bootserver=192.168.0.1, rootserver=192.168.0.1, rootpath=
[   10.677531] VDD_1V8_AP_PLL: disabling
[   10.681194] VDD_RTC: disabling
[   10.684246] VDDIO_SDMMC3_AP: disabling
[   10.688132] VDD_HDMI_1V05: disabling
[   10.691704] SD_CARD_SW_PWR: disabling
[   10.695357] VDD_USB0: disabling
[   10.698488] VDD_USB1: disabling
[   10.701621] VDD_HDMI_5V0: disabling
[   10.705100] ALSA device list:
[   10.708063]   No soundcards found.
[   10.711914] Freeing unused kernel memory: 1472K
[   10.727005] Run /init as init process
[   10.784989] ------------[ cut here ]------------
[   10.789597] kernel BUG at /home/jonathanh/workdir/tegra/mlt-linux_next/kernel/kernel/time/timer.c:952!

Cheers
Jon

-- 
nvpublic
