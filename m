Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07CA449D3F
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 11:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbfFRJaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 05:30:35 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1356 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfFRJaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 05:30:35 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d08af380001>; Tue, 18 Jun 2019 02:30:32 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 18 Jun 2019 02:30:32 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 18 Jun 2019 02:30:32 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Jun
 2019 09:30:30 +0000
Subject: Re: [PATCH net-next 3/3] net: stmmac: Convert to phylink and remove
 phylib logic
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
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
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <d9ffce3d-4827-fa4a-89e8-0492c4bc1848@nvidia.com>
Date:   Tue, 18 Jun 2019 10:30:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <6226d6a0de5929ed07d64b20472c52a86e71383d.1560266175.git.joabreu@synopsys.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL106.nvidia.com (172.18.146.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1560850232; bh=4FJWx7tdMtTN5iOR/Kb6dGxSa0sthjoc6P76jeCv8Ts=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=OFsdFSAovU1D2YmtHeQWynwnr0fxuprt5l18R6CKhyMmds5Gs/QHc0d0zcgL8ZZd9
         zeBtrVRskuXOQb8bCCZrUaarMq/e57aku7cnevpweGLlrNu+te46knBw77jRsh2IOr
         rrH2FzoZmgFz3VnxrOVpecs0AR7I0mlZNz+vqcdn3CW6iAT2HrGjD8DwvM1syWQC4a
         Rtq7lNGHBp7eOzZOg1nGn/p/vH8KJF8goS9meKlh2t3qwJnDwGzO8ZAzlzF0uoeh45
         wsF8YCKzAamHa28i2fjlv31cQlP4GOZQgAeaU9EiJqopXFdzAFaI9v5K2+dkH8q/JJ
         oxUIE+CF7Mxgw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/06/2019 16:18, Jose Abreu wrote:
> Convert everything to phylink.
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>

I am seeing a boot regression on -next for some of our boards that have
a synopsys ethernet controller that uses the dwmac-dwc-qos-ethernet
driver. Git bisect is pointing to this commit, but unfortunately this
cannot be cleanly reverted on top of -next to confirm. 

The bootlog shows the following bug is triggered ...

[   10.784989] ------------[ cut here ]------------
[   10.789597] kernel BUG at /home/jonathanh/workdir/tegra/mlt-linux_next/kernel/kernel/time/timer.c:952!
[   10.798881] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[   10.804351] Modules linked in:
[   10.807400] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G S                5.2.0-rc3-00940-g425b0fad9c7e #9
[   10.816682] Hardware name: NVIDIA Tegra186 P2771-0000 Development Board (DT)
[   10.823712] pstate: 20000005 (nzCv daif -PAN -UAO)
[   10.828496] pc : mod_timer+0x208/0x2d8
[   10.832235] lr : stmmac_napi_poll_tx+0x524/0x5a0
[   10.836839] sp : ffff000010003d00
[   10.840141] x29: ffff000010003d00 x28: ffff8001f42887c0 
[   10.845438] x27: ffff8001f42887c0 x26: ffff8001f55b7100 
[   10.850735] x25: 0000000000000000 x24: 0000000000000000 
[   10.856033] x23: ffff0000112e9000 x22: 0000000000000000 
[   10.861330] x21: 0000000000000001 x20: ffff0000121ad000 
[   10.866626] x19: ffff8001f47da000 x18: 0000000000000000 
[   10.871922] x17: 0000000000000000 x16: 0000000000000001 
[   10.877218] x15: 0000000000000009 x14: 0000000000001000 
[   10.882515] x13: 0000000080000000 x12: 0000000000000001 
[   10.887811] x11: 000000000000000c x10: 0000000000000000 
[   10.893107] x9 : 0000000000000000 x8 : 00000000fffee49c 
[   10.898403] x7 : 000000000000002a x6 : 000000000000002a 
[   10.903699] x5 : ffff8001f4189c80 x4 : 0000000000290000 
[   10.908995] x3 : 0000000000000000 x2 : 0000000000000000 
[   10.914291] x1 : 00000000fffee596 x0 : ffff8001f428b160 
[   10.919587] Call trace:
[   10.922024]  mod_timer+0x208/0x2d8
[   10.925415]  stmmac_napi_poll_tx+0x524/0x5a0
[   10.929674]  net_rx_action+0x220/0x318
[   10.933413]  __do_softirq+0x110/0x23c
[   10.937066]  irq_exit+0xcc/0xd8
[   10.940199]  __handle_domain_irq+0x60/0xb8
[   10.944282]  gic_handle_irq+0x58/0xb0
[   10.947931]  el1_irq+0xb8/0x180
[   10.951063]  arch_cpu_idle+0x10/0x18
[   10.954627]  do_idle+0x1dc/0x2a8
[   10.957845]  cpu_startup_entry+0x24/0x28
[   10.961758]  rest_init+0xd4/0xe0
[   10.964978]  arch_call_rest_init+0xc/0x14
[   10.968976]  start_kernel+0x44c/0x478
[   10.972626] Code: aa1503f4 aa1403f5 17ffffc5 d503201f (d4210000) 
[   10.978709] ---[ end trace 89626c50aaab321f ]---

I have not looked at this any further, but wanted to see if you have some
thoughts. 

Cheers
Jon

-- 
nvpublic
