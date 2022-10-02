Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465535F251C
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 21:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiJBTZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 15:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiJBTZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 15:25:35 -0400
Received: from matoro.tk (unknown [IPv6:2600:1700:4b10:9d80::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF93310574;
        Sun,  2 Oct 2022 12:25:01 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; bh=o+ZxQOJ1EhVyjExniGlU6Dk1b6u1QMfEfjOgxiQzFbg=;
 c=relaxed/relaxed; d=matoro.tk;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@matoro.tk; s=20220801; t=1664738697; v=1; x=1665170697;
 b=DQjhH9uDDosk06LGjM2JUQgQ69DUV3+RkLohxTVgHYq3dlDqldZLEqw5vGl6dRgUG7GIEIsy
 jBgN6xsC16AeU9XUZZEwC5JpV69uibI1BH0SHJGviE/WsoCIO+wb142Lc2hmtH93WMQHPbsD3wd
 V2cw16Vx7BfsEJe9F1e/wsgox0808PS6KVKnG4ayl8tJOD/z+kJrfpj4pjKyDXITIHFvE/kHnHW
 4R/LUWFkZFAbc6MVfO3CfTQ2s247WG7nCLrW1G14sWk57Mol8BncxUA+g5L4uZm5WlxKe+DXpHU
 bDjAn8TYZE4g80X5jM5M5KegfZkA3IyWIXuEPNo0e7gY7xzDjeFQ303ScNsHjDx3hsEWa9UekAM
 HRASyZbslg3wHxmkBN94jSZTEnZrlga7wWV1bT6dc9cWYDybzjhbYhAK51pjlZ5urdO2aAPJ57d
 1exYqOEXdKEPHcqnjQCfaP85rxmnUOYJCO5CKGlNUrBZGZy5Si/BaJabcbcAXG8CvOUsWTcVFM2
 vgDOSc2ljHiPdv1LkgKU8V1r1PiH8/RFngCtnf2wl55G1kw2MaNMORrW07Iqg+cuc7My2qq87Tg
 MCUNPpw5j3oNNzfUo+uOigAMYC6N2JYr+dbRfQrS+2SvPZtSxNbDt50Zpy8j39y693WrsOKdo9p
 2iaqQtgll2M=
Received: by matoro.tk (envelope-sender
 <matoro_mailinglist_kernel@matoro.tk>) with ESMTPS id 0f9796cf; Sun, 02 Oct
 2022 15:24:57 -0400
MIME-Version: 1.0
Date:   Sun, 02 Oct 2022 15:24:57 -0400
From:   matoro <matoro_mailinglist_kernel@matoro.tk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk, atenart@kernel.org, jon@solid-run.com
Subject: Re: [net-next] net: mvpp2: Add TX flow control support for jumbo
 frames
In-Reply-To: <1613402622-11451-1-git-send-email-stefanc@marvell.com>
References: <1613402622-11451-1-git-send-email-stefanc@marvell.com>
Message-ID: <69516f245575e5ed09b3e291bcd784e2@matoro.tk>
X-Sender: matoro_mailinglist_kernel@matoro.tk
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all, I know this is kind of an old change but I have got an issue 
with this driver that might be related.  Whenever I change the MTU of 
any interfacing using mvpp2, it immediately results in the following 
crash.  Is this change related?  Is this a known issue with this driver?

[ 1725.925804] mvpp2 f2000000.ethernet eth0: mtu 9000 too high, 
switching to shared buffers
[ 1725.9258[ 1725.935611] mvpp2 f2000000.ethernet eth0: Link is Down
04] mvpp2 f2000000.ethernet eth0: mtu 9000 too high, switching to shared 
buffers
[ 17[ 1725.950079] Unable to handle kernel NULL pointer dereference at 
virtual address 0000000000000000
25.935611]  Mem abort info:
[33mmvpp2 f20000[ 1725.963804]   ESR = 0x0000000096000004
00.ethernet eth0[ 1725.968960]   EC = 0x25: DABT (current EL), IL = 32 
bits
: Link is Do[ 1725.975685]   SET = 0, FnV = 0
wn
[ 1725.980143]   EA = 0, S1PTW = 0
[ 1725.983643]   FSC = 0x04: level 0 translation fault
[ 1725.988539] Data abort info:
[ 1725.991430]   ISV = 0, ISS = 0x00000004
[ 1725.995279]   CM = 0, WnR = 0
[ 1725.998256] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000104b83000
[ 1726.004724] [0000000000000000] pgd=0000000000000000, 
p4d=0000000000000000
[ 1726.011543] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[ 1726.017137] Modules linked in: sfp mdio_i2c marvell mcp3021 mvmdio 
at24 mvpp2 armada_thermal phylink sbsa_gwdt cfg80211 rfkill fuse
[ 1726.029032] CPU: 2 PID: 16253 Comm: ip Not tainted 
5.19.8-1-aarch64-ARCH #1
[ 1726.036024] Hardware name: SolidRun CN9130 based SOM Clearfog Base 
(DT)
[ 1726.042665] pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO -DIT -SSBS 
BTYPE=--)
[ 1726.049656] pc : mvpp2_cm3_read.isra.0+0x8/0x2c [mvpp2]
[ 1726.054915] lr : mvpp2_bm_pool_update_fc+0x40/0x154 [mvpp2]
[ 1726.060515] sp : ffff80000b17b580
[ 1726.063842] x29: ffff80000b17b580 x28: 0000000000000000 x27: 
0000000000000000
[ 1726.071010] x26: ffff8000013ceb60 x25: 0000000000000008 x24: 
ffff0001054b5980
[ 1726.078177] x23: ffff0001021e2480 x22: 0000000000000038 x21: 
0000000000000000
[ 1726.085346] x20: ffff0001049dac80 x19: ffff0001054b4980 x18: 
0000000000000000
[ 1726.092513] x17: 0000000000000000 x16: 0000000000000000 x15: 
0000000000000000
[ 1726.099680] x14: 0000000000000109 x13: 0000000000000109 x12: 
0000000000000000
[ 1726.106847] x11: 0000000000000040 x10: ffff80000a3471b8 x9 : 
ffff80000a3471b0
[ 1726.114015] x8 : ffff000100401b88 x7 : 0000000000000000 x6 : 
0000000000000000
[ 1726.121182] x5 : ffff80000b17b4e0 x4 : 0000000000000000 x3 : 
0000000000000000
[ 1726.128348] x2 : ffff0001021e2480 x1 : 0000000000000000 x0 : 
0000000000000000
[ 1726.135514] Call trace:
[ 1726.137968]  mvpp2_cm3_read.isra.0+0x8/0x2c [mvpp2]
[ 1726.142871]  mvpp2_bm_pool_update_priv_fc+0xc0/0x100 [mvpp2]
[ 1726.148558]  mvpp2_bm_switch_buffers.isra.0+0x1c0/0x1e0 [mvpp2]
[ 1726.154506]  mvpp2_change_mtu+0x184/0x264 [mvpp2]
[ 1726.159233]  dev_set_mtu_ext+0xdc/0x1b4
[ 1726.163087]  do_setlink+0x1d4/0xa90
[ 1726.166593]  __rtnl_newlink+0x4a8/0x4f0
[ 1726.170443]  rtnl_newlink+0x4c/0x80
[ 1726.173944]  rtnetlink_rcv_msg+0x12c/0x37c
[ 1726.178058]  netlink_rcv_skb+0x5c/0x130
[ 1726.181910]  rtnetlink_rcv+0x18/0x2c
[ 1726.185500]  netlink_unicast+0x2c4/0x31c
[ 1726.189438]  netlink_sendmsg+0x1bc/0x410
[ 1726.193377]  sock_sendmsg+0x54/0x60
[ 1726.196879]  ____sys_sendmsg+0x26c/0x290
[ 1726.200817]  ___sys_sendmsg+0x7c/0xc0
[ 1726.204494]  __sys_sendmsg+0x68/0xd0
[ 1726.208083]  __arm64_sys_sendmsg+0x28/0x34
[ 1726.212196]  invoke_syscall+0x48/0x114
[ 1726.215962]  el0_svc_common.constprop.0+0x44/0xec
[ 1726.220686]  do_el0_svc+0x28/0x34
[ 1726.224014]  el0_svc+0x2c/0x84
[ 1726.227082]  el0t_64_sync_handler+0x11c/0x150
[ 1726.231455]  el0t_64_sync+0x18c/0x190
[ 1726.235134] Code: d65f03c0 d65f03c0 d503233f 8b214000 (b9400000)
[ 1726.241253] ---[ end trace 0000000000000000 ]---
[ 1726.245888] note: ip[16253] exited with preempt_count 1

-------- Original Message --------
Subject: [net-next] net: mvpp2: Add TX flow control support for jumbo 
frames
Date: 2021-02-15 10:23
 From: <stefanc@marvell.com>
To: <netdev@vger.kernel.org>

 From: Stefan Chulski <stefanc@marvell.com>

With MTU less than 1500B on all ports, the driver uses per CPU pool 
mode.
If one of the ports set to jumbo frame MTU size, all ports move
to shared pools mode.
Here, buffer manager TX Flow Control reconfigured on all ports.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 26 
++++++++++++++++++++
  1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c 
b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 222e9a3..10c17d1 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -924,6 +924,25 @@ static void mvpp2_bm_pool_update_fc(struct 
mvpp2_port *port,
  	spin_unlock_irqrestore(&port->priv->mss_spinlock, flags);
  }

+/* disable/enable flow control for BM pool on all ports */
+static void mvpp2_bm_pool_update_priv_fc(struct mvpp2 *priv, bool en)
+{
+	struct mvpp2_port *port;
+	int i;
+
+	for (i = 0; i < priv->port_count; i++) {
+		port = priv->port_list[i];
+		if (port->priv->percpu_pools) {
+			for (i = 0; i < port->nrxqs; i++)
+				mvpp2_bm_pool_update_fc(port, &port->priv->bm_pools[i],
+							port->tx_fc & en);
+		} else {
+			mvpp2_bm_pool_update_fc(port, port->pool_long, port->tx_fc & en);
+			mvpp2_bm_pool_update_fc(port, port->pool_short, port->tx_fc & en);
+		}
+	}
+}
+
  static int mvpp2_enable_global_fc(struct mvpp2 *priv)
  {
  	int val, timeout = 0;
@@ -4913,6 +4932,7 @@ static int mvpp2_set_mac_address(struct net_device 
*dev, void *p)
   */
  static int mvpp2_bm_switch_buffers(struct mvpp2 *priv, bool percpu)
  {
+	bool change_percpu = (percpu != priv->percpu_pools);
  	int numbufs = MVPP2_BM_POOLS_NUM, i;
  	struct mvpp2_port *port = NULL;
  	bool status[MVPP2_MAX_PORTS];
@@ -4928,6 +4948,9 @@ static int mvpp2_bm_switch_buffers(struct mvpp2 
*priv, bool percpu)
  	if (priv->percpu_pools)
  		numbufs = port->nrxqs * 2;

+	if (change_percpu)
+		mvpp2_bm_pool_update_priv_fc(priv, false);
+
  	for (i = 0; i < numbufs; i++)
  		mvpp2_bm_pool_destroy(port->dev->dev.parent, priv, 
&priv->bm_pools[i]);

@@ -4942,6 +4965,9 @@ static int mvpp2_bm_switch_buffers(struct mvpp2 
*priv, bool percpu)
  			mvpp2_open(port->dev);
  	}

+	if (change_percpu)
+		mvpp2_bm_pool_update_priv_fc(priv, true);
+
  	return 0;
  }
