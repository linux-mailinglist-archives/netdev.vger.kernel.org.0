Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6A66493D9
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 12:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiLKLTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 06:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiLKLTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 06:19:15 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC11655B3
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 03:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1/0PqUsOmRXu/00wK7b4mz01EtG5IQc3H88g2/V7PHg=; b=DYdAD2kgel8YV+Y6+KyH5MEWYV
        yfEeeMsW96JmtOMDNDZEAzumlJt+ydROS1U+vMtfceYdn/veMY2Dz+LIw9zFssh55YgBXX+yQtgv8
        Cgv4jHw/grBYXbHSmX/zqH+6i7+6RqcGK5TN08gUIqvnBLadGTOd3t3IAUGcxIYBPO9U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p4KM5-0050ph-Jo; Sun, 11 Dec 2022 12:18:49 +0100
Date:   Sun, 11 Dec 2022 12:18:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Julien Beraud <julien.beraud@orolia.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net 1/1] stmmac: fix potential division by 0
Message-ID: <Y5W8mbkdi1E1MFzh@lunn.ch>
References: <de4c64ccac9084952c56a06a8171d738604c4770.1670678513.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de4c64ccac9084952c56a06a8171d738604c4770.1670678513.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 11:37:22PM +0100, Piergiorgio Beruto wrote:
> When the MAC is connected to a 10 Mb/s PHY and the PTP clock is derived
> from the MAC reference clock (default), the clk_ptp_rate becomes too
> small and the calculated sub second increment becomes 0 when computed by
> the stmmac_config_sub_second_increment() function within
> stmmac_init_tstamp_counter().
> 
> Therefore, the subsequent div_u64 in stmmac_init_tstamp_counter()
> operation triggers a divide by 0 exception as shown below.
> 
> [   95.062067] socfpga-dwmac ff700000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
> [   95.076440] socfpga-dwmac ff700000.ethernet eth0: PHY [stmmac-0:08] driver [NCN26000] (irq=49)
> [   95.095964] dwmac1000: Master AXI performs any burst length
> [   95.101588] socfpga-dwmac ff700000.ethernet eth0: No Safety Features support found
> [   95.109428] Division by zero in kernel.
> [   95.113447] CPU: 0 PID: 239 Comm: ifconfig Not tainted 6.1.0-rc7-centurion3-1.0.3.0-01574-gb624218205b7-dirty #77
> [   95.123686] Hardware name: Altera SOCFPGA
> [   95.127695]  unwind_backtrace from show_stack+0x10/0x14
> [   95.132938]  show_stack from dump_stack_lvl+0x40/0x4c
> [   95.137992]  dump_stack_lvl from Ldiv0+0x8/0x10
> [   95.142527]  Ldiv0 from __aeabi_uidivmod+0x8/0x18
> [   95.147232]  __aeabi_uidivmod from div_u64_rem+0x1c/0x40
> [   95.152552]  div_u64_rem from stmmac_init_tstamp_counter+0xd0/0x164
> [   95.158826]  stmmac_init_tstamp_counter from stmmac_hw_setup+0x430/0xf00
> [   95.165533]  stmmac_hw_setup from __stmmac_open+0x214/0x2d4
> [   95.171117]  __stmmac_open from stmmac_open+0x30/0x44
> [   95.176182]  stmmac_open from __dev_open+0x11c/0x134
> [   95.181172]  __dev_open from __dev_change_flags+0x168/0x17c
> [   95.186750]  __dev_change_flags from dev_change_flags+0x14/0x50
> [   95.192662]  dev_change_flags from devinet_ioctl+0x2b4/0x604
> [   95.198321]  devinet_ioctl from inet_ioctl+0x1ec/0x214
> [   95.203462]  inet_ioctl from sock_ioctl+0x14c/0x3c4
> [   95.208354]  sock_ioctl from vfs_ioctl+0x20/0x38
> [   95.212984]  vfs_ioctl from sys_ioctl+0x250/0x844
> [   95.217691]  sys_ioctl from ret_fast_syscall+0x0/0x4c
> [   95.222743] Exception stack(0xd0ee1fa8 to 0xd0ee1ff0)
> [   95.227790] 1fa0:                   00574c4f be9aeca4 00000003 00008914 be9aeca4 be9aec50
> [   95.235945] 1fc0: 00574c4f be9aeca4 0059f078 00000036 be9aee8c be9aef7a 00000015 00000000
> [   95.244096] 1fe0: 005a01f0 be9aec38 004d7484 b6e67d74
> 
> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> Fixes: 91a2559c1dc5 ("net: stmmac: Fix sub-second increment")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
