Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB36560AED
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 22:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiF2UMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 16:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiF2UMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 16:12:07 -0400
X-Greylist: delayed 522 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Jun 2022 13:12:04 PDT
Received: from mx06lb.world4you.com (mx06lb.world4you.com [81.19.149.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C8C222A8
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 13:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1X4rKzGXhKFY7e+W1xApLYR5sdtv4Tvz+MvKKMmRb6s=; b=LPjUdcBH0BWD/XDBhVvFtm4uX4
        vXcYvNjBdMafFR8ggzPZIPKmjY2H981Z76Jd59OjmWAaKS7ub39DqMDYUFHO/xq+lpikYMUN4C96y
        DcKLUEmPfQwA3XLr2Jpg6ems3vyG/RdBisdHU+StGvHDPZpX5hH6RdgBsqQYhopERC88=;
Received: from [88.117.62.106] (helo=[10.0.0.160])
        by mx06lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1o6du7-0004zy-OX; Wed, 29 Jun 2022 22:03:15 +0200
Message-ID: <424a0586-b546-14d6-faa3-1e8e8131a885@engleder-embedded.com>
Date:   Wed, 29 Jun 2022 22:03:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 2/2] net: phylink: disable PCS polling over major
 configuration
Content-Language: en-US
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <YrmYEC2N9mVpg9g6@shell.armlinux.org.uk>
 <E1o5nAZ-004RRE-So@rmk-PC.armlinux.org.uk>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <E1o5nAZ-004RRE-So@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.06.22 13:44, Russell King (Oracle) wrote:
> While we are performing a major configuration, there is no point having
> the PCS polling timer running. Stop it before we begin preparing for
> the configuration change, and restart it only once we've successfully
> completed the change.
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>   drivers/net/phy/phylink.c | 30 ++++++++++++++++++++----------
>   1 file changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 0216ea978261..1a7550f5fdf5 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -758,6 +758,18 @@ static void phylink_resolve_flow(struct phylink_link_state *state)
>   	}
>   }
>   
> +static void phylink_pcs_poll_stop(struct phylink *pl)
> +{
> +	if (pl->cfg_link_an_mode == MLO_AN_INBAND)
> +		del_timer(&pl->link_poll);
> +}
> +
> +static void phylink_pcs_poll_start(struct phylink *pl)
> +{
> +	if (pl->pcs->poll && pl->cfg_link_an_mode == MLO_AN_INBAND)
> +		mod_timer(&pl->link_poll, jiffies + HZ);
> +}
> +
>   static void phylink_mac_config(struct phylink *pl,
>   			       const struct phylink_link_state *state)
>   {
> @@ -789,6 +801,7 @@ static void phylink_major_config(struct phylink *pl, bool restart,
>   				  const struct phylink_link_state *state)
>   {
>   	struct phylink_pcs *pcs = NULL;
> +	bool pcs_changed = false;
>   	int err;
>   
>   	phylink_dbg(pl, "major config %s\n", phy_modes(state->interface));
> @@ -801,8 +814,12 @@ static void phylink_major_config(struct phylink *pl, bool restart,
>   				    pcs);
>   			return;
>   		}
> +
> +		pcs_changed = pcs && pl->pcs != pcs;
>   	}
>   
> +	phylink_pcs_poll_stop(pl);
> +
>   	if (pl->mac_ops->mac_prepare) {
>   		err = pl->mac_ops->mac_prepare(pl->config, pl->cur_link_an_mode,
>   					       state->interface);
> @@ -816,18 +833,9 @@ static void phylink_major_config(struct phylink *pl, bool restart,
>   	/* If we have a new PCS, switch to the new PCS after preparing the MAC
>   	 * for the change.
>   	 */
> -	if (pcs) {
> +	if (pcs_changed)
>   		pl->pcs = pcs;
>   
> -		if (!pl->phylink_disable_state &&
> -		    pl->cfg_link_an_mode == MLO_AN_INBAND) {
> -			if (pcs->poll)
> -				mod_timer(&pl->link_poll, jiffies + HZ);
> -			else
> -				del_timer(&pl->link_poll);
> -		}
> -	}
> -
>   	phylink_mac_config(pl, state);
>   
>   	if (pl->pcs) {
> @@ -852,6 +860,8 @@ static void phylink_major_config(struct phylink *pl, bool restart,
>   			phylink_err(pl, "mac_finish failed: %pe\n",
>   				    ERR_PTR(err));
>   	}
> +
> +	phylink_pcs_poll_start(pl);
>   }
>   
>   /*
With latest net-next I got the following crash:

Jun 29 21:18:01 zcu104-1 kernel: [    8.814176] macb ff0e0000.ethernet 
eth0: PHY [ff0e0000.ethernet-ffffffff:0c] driver [TI DP83867] (irq=POLL)
Jun 29 21:18:01 zcu104-1 kernel: [    8.814193] macb ff0e0000.ethernet 
eth0: configuring for phy/rgmii-id link mode
Jun 29 21:18:01 zcu104-1 kernel: [    8.814213] Unable to handle kernel 
NULL pointer dereference at virtual address 0000000000000008
Jun 29 21:18:01 zcu104-1 kernel: [    8.881046] Mem abort info:
Jun 29 21:18:01 zcu104-1 kernel: [    8.893065]   ESR = 0x0000000096000005
Jun 29 21:18:01 zcu104-1 kernel: [    8.907481]   EC = 0x25: DABT 
(current EL), IL = 32 bits
Jun 29 21:18:01 zcu104-1 kernel: [    8.913269]   SET = 0, FnV = 0
Jun 29 21:18:01 zcu104-1 kernel: [    8.916586]   EA = 0, S1PTW = 0
Jun 29 21:18:01 zcu104-1 kernel: [    8.919719]   FSC = 0x05: level 1 
translation fault
Jun 29 21:18:01 zcu104-1 kernel: [    8.924667] Data abort info:
Jun 29 21:18:01 zcu104-1 kernel: [    8.927539]   ISV = 0, ISS = 0x00000005
Jun 29 21:18:01 zcu104-1 kernel: [    8.931372]   CM = 0, WnR = 0
Jun 29 21:18:01 zcu104-1 kernel: [    8.934339] user pgtable: 4k pages, 
39-bit VAs, pgdp=00000000018b1000
Jun 29 21:18:01 zcu104-1 kernel: [    8.940778] [0000000000000008] 
pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000
Jun 29 21:18:01 zcu104-1 kernel: [    8.949486] Internal error: Oops: 
96000005 [#1] PREEMPT SMP
Jun 29 21:18:01 zcu104-1 kernel: [    8.955048] Modules linked in: 
uio_pdrv_genirq tsnep
Jun 29 21:18:01 zcu104-1 kernel: [    8.960014] CPU: 1 PID: 345 Comm: 
ifplugd Not tainted 5.19.0-rc3-zynqmp #5
Jun 29 21:18:01 zcu104-1 kernel: [    8.960023] Hardware name: TSN 
endpoint (DT)
Jun 29 21:18:01 zcu104-1 kernel: [    8.960027] pstate: a0000005 (NzCv 
daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
Jun 29 21:18:01 zcu104-1 kernel: [    8.960035] pc : 
phylink_major_config+0xf8/0x2f0
Jun 29 21:18:01 zcu104-1 kernel: [    8.960052] lr : 
phylink_major_config+0xd4/0x2f0
Jun 29 21:18:01 zcu104-1 kernel: [    8.960061] sp : ffffffc00a6139c0
Jun 29 21:18:01 zcu104-1 kernel: [    8.960064] x29: ffffffc00a6139c0 
x28: ffffff8005ddb180 x27: 0000000000000000
Jun 29 21:18:01 zcu104-1 kernel: [    8.960076] x26: 0000000000000000 
x25: ffffff8005e40240 x24: 0000000000000010
Jun 29 21:18:01 zcu104-1 kernel: [    8.960087] x23: 0000000000000001 
x22: 0000000000000000 x21: 0000000000000000
Jun 29 21:18:01 zcu104-1 kernel: [    8.960098] x20: ffffffc00a613a20 
x19: ffffff8000b43a00 x18: 0000000000000000
Jun 29 21:18:01 zcu104-1 kernel: [    8.960109] x17: 0000000000000001 
x16: 00008c294d41fe3e x15: 0230df5a173cf71e
Jun 29 21:18:01 zcu104-1 kernel: [    8.960121] x14: 0000000000000000 
x13: 20726f6620676e69 x12: 72756769666e6f63
Jun 29 21:18:01 zcu104-1 kernel: [    8.960132] x11: 0000000000000001 
x10: 000000000000002f x9 : ffffffc008944714
Jun 29 21:18:01 zcu104-1 kernel: [    8.960143] x8 : 00000000ffffffff x7 
: 0a65646f6d206b6e x6 : 0000000000000000
Jun 29 21:18:01 zcu104-1 kernel: [    8.960154] x5 : 0000000000000001 x4 
: ffffffc008982e28 x3 : 0000000000000000
Jun 29 21:18:01 zcu104-1 kernel: [    8.960165] x2 : 0000000000000001 x1 
: 00000000fffffff5 x0 : 0000000000000000
Jun 29 21:18:01 zcu104-1 kernel: [    8.960176] Call trace:
Jun 29 21:18:01 zcu104-1 kernel: [    8.960179] 
phylink_major_config+0xf8/0x2f0
Jun 29 21:18:01 zcu104-1 kernel: [    8.960188] 
phylink_mac_initial_config.constprop.0+0xb0/0x11c
Jun 29 21:18:01 zcu104-1 kernel: [    8.960197] phylink_start+0x50/0x260
Jun 29 21:18:01 zcu104-1 kernel: [    8.960205] 
macb_phylink_connect+0x64/0x130
Jun 29 21:18:01 zcu104-1 kernel: [    8.960214] macb_open+0x23c/0x350
Jun 29 21:18:01 zcu104-1 kernel: [    8.960222] __dev_open+0x11c/0x1b0
Jun 29 21:18:01 zcu104-1 kernel: [    8.960231] 
__dev_change_flags+0x198/0x210
Jun 29 21:18:01 zcu104-1 kernel: [    8.960239] dev_change_flags+0x30/0x70
Jun 29 21:18:01 zcu104-1 kernel: [    8.960247] dev_ifsioc+0x2c4/0x4f0
Jun 29 21:18:01 zcu104-1 kernel: [    8.960257] dev_ioctl+0x374/0x650
Jun 29 21:18:01 zcu104-1 kernel: [    8.960265] 
sock_do_ioctl.constprop.0+0xac/0xf0
Jun 29 21:18:01 zcu104-1 kernel: [    8.960272] sock_ioctl+0x138/0x3b0
Jun 29 21:18:01 zcu104-1 kernel: [    8.960278] __arm64_sys_ioctl+0xb4/0x100
Jun 29 21:18:01 zcu104-1 kernel: [    8.960289] invoke_syscall+0x5c/0x130
Jun 29 21:18:01 zcu104-1 kernel: [    8.960299] 
el0_svc_common.constprop.0+0xd4/0xf4
Jun 29 21:18:01 zcu104-1 kernel: [    8.960307] do_el0_svc+0x98/0xec
Jun 29 21:18:01 zcu104-1 kernel: [    8.960314]  el0_svc+0x50/0xac
Jun 29 21:18:01 zcu104-1 kernel: [    8.960322] 
el0t_64_sync_handler+0x1ac/0x1b0
Jun 29 21:18:01 zcu104-1 kernel: [    8.960329] el0t_64_sync+0x18c/0x190
Jun 29 21:18:01 zcu104-1 kernel: [    8.960340] Code: f9400a60 d63f0060 
37f80620 f9400e60 (39402000)
Jun 29 21:18:01 zcu104-1 kernel: [    8.960345] ---[ end trace 
0000000000000000 ]---

$ scripts/faddr2line vmlinux.o phylink_major_config+0xf8/0x2f0
phylink_major_config+0xf8/0x2f0:
phylink_pcs_poll_start at 
/home/gerhard/git/linux/drivers/net/phy/phylink.c:769 (discriminator 6)
(inlined by) phylink_major_config at 
/home/gerhard/git/linux/drivers/net/phy/phylink.c:864 (discriminator 6)

Crash can be fixed by reverting this commit. Any ideas?

Gerhard
