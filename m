Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19AC29CC41
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1813723AbgJ0Wzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:55:50 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49920 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1795116AbgJ0Wzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:55:48 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603839345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/TW26lQLpozs0XwB5T+mhVlUC9AnO3WZrZ768veDUO0=;
        b=266a3cFBU0gVDAEwLrQXjeHKgXbAOtcj1n3K2Jw0mqabUmNDhl+Cjaiytp65uS8t3giIl7
        VNigi07OKXtfbvGOEKu9i87gn1nYMBygoh7BxJ4n77BxZg/+XxvQbKwyu4Q4+cxeaBP8IZ
        1wOWMFZD+atks/b3j9hJztOWKNpfiiGCZmrPVHGJRGCNWRP/ruprCO7qiCsWvRNBcohXCk
        vlaJpjuF77ad4cKHptCN3Xq5aQ5p1V3lVWpWDN2HRh9ATJVvvKoimRK2yjoIhoSZ8oCmK0
        9g3+n7KVdUxY3HlcLR4BXUjwDtF4e64QNY+aJtRac2f9lKPfP6Tkx/tBsdVVBg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603839345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/TW26lQLpozs0XwB5T+mhVlUC9AnO3WZrZ768veDUO0=;
        b=2ykMjyQByoGZE8+MN3pU0gNhtllD+Ziw3lg+7I/+rhvn+aCZ5JAJnEZY/GgSMu3WsOJiQx
        ZgFYSIDOUPOfb4AA==
To:     netdev@vger.kernel.org
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Daniel Drake <dsd@gentoo.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, Jon Mason <jdmason@kudzu.us>,
        Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@codeaurora.org>,
        Leon Romanovsky <leon@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Samuel Chessman <chessman@tux.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 02/15] net: neterion: s2io: Replace in_interrupt() for context detection
Date:   Tue, 27 Oct 2020 23:54:41 +0100
Message-Id: <20201027225454.3492351-3-bigeasy@linutronix.de>
In-Reply-To: <20201027225454.3492351-1-bigeasy@linutronix.de>
References: <20201027225454.3492351-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wait_for_cmd_complete() uses in_interrupt() to detect whether it is safe to
sleep or not.

The usage of in_interrupt() in drivers is phased out and Linus clearly
requested that code which changes behaviour depending on context should
either be seperated or the context be conveyed in an argument passed by the
caller, which usually knows the context.

in_interrupt() also is only partially correct because it fails to chose the
correct code path when just preemption or interrupts are disabled.

Add an argument 'may_block' to both functions and adjust the callers to
pass the context information.

The following call chains which end up invoking wait_for_cmd_complete()
were analyzed to be safe to sleep:

 s2io_card_up()
   s2io_set_multicast()

 init_nic()
   init_tti()

 s2io_close()
   do_s2io_delete_unicast_mc()
     do_s2io_add_mac()

 s2io_set_mac_addr()
   do_s2io_prog_unicast()
     do_s2io_add_mac()

 s2io_reset()
   do_s2io_restore_unicast_mc()
     do_s2io_add_mc()
       do_s2io_add_mac()

 s2io_open()
   do_s2io_prog_unicast()
     do_s2io_add_mac()

The following call chains which end up invoking wait_for_cmd_complete()
were analyzed to be safe to sleep:

 __dev_set_rx_mode()
    s2io_set_multicast()

 s2io_txpic_intr_handle()
   s2io_link()
     init_tti()

Add a may_sleep argument to wait_for_cmd_complete(), s2io_set_multicast()
and init_tti() and hand the context information in from the call sites.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jon Mason <jdmason@kudzu.us>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/neterion/s2io.c | 41 ++++++++++++++++------------
 drivers/net/ethernet/neterion/s2io.h |  4 +--
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/ne=
terion/s2io.c
index d13d92bf74478..8f2f091bce899 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -1106,7 +1106,7 @@ static int s2io_print_pci_mode(struct s2io_nic *nic)
  *  '-1' on failure
  */
=20
-static int init_tti(struct s2io_nic *nic, int link)
+static int init_tti(struct s2io_nic *nic, int link, bool may_sleep)
 {
 	struct XENA_dev_config __iomem *bar0 =3D nic->bar0;
 	register u64 val64 =3D 0;
@@ -1166,7 +1166,7 @@ static int init_tti(struct s2io_nic *nic, int link)
=20
 		if (wait_for_cmd_complete(&bar0->tti_command_mem,
 					  TTI_CMD_MEM_STROBE_NEW_CMD,
-					  S2IO_BIT_RESET) !=3D SUCCESS)
+					  S2IO_BIT_RESET, may_sleep) !=3D SUCCESS)
 			return FAILURE;
 	}
=20
@@ -1659,7 +1659,7 @@ static int init_nic(struct s2io_nic *nic)
 	 */
=20
 	/* Initialize TTI */
-	if (SUCCESS !=3D init_tti(nic, nic->last_link_state))
+	if (SUCCESS !=3D init_tti(nic, nic->last_link_state, true))
 		return -ENODEV;
=20
 	/* RTI Initialization */
@@ -3331,7 +3331,7 @@ static void s2io_updt_xpak_counter(struct net_device =
*dev)
  */
=20
 static int wait_for_cmd_complete(void __iomem *addr, u64 busy_bit,
-				 int bit_state)
+				 int bit_state, bool may_sleep)
 {
 	int ret =3D FAILURE, cnt =3D 0, delay =3D 1;
 	u64 val64;
@@ -3353,7 +3353,7 @@ static int wait_for_cmd_complete(void __iomem *addr, =
u64 busy_bit,
 			}
 		}
=20
-		if (in_interrupt())
+		if (!may_sleep)
 			mdelay(delay);
 		else
 			msleep(delay);
@@ -4877,8 +4877,7 @@ static struct net_device_stats *s2io_get_stats(struct=
 net_device *dev)
  *  Return value:
  *  void.
  */
-
-static void s2io_set_multicast(struct net_device *dev)
+static void s2io_set_multicast(struct net_device *dev, bool may_sleep)
 {
 	int i, j, prev_cnt;
 	struct netdev_hw_addr *ha;
@@ -4903,7 +4902,7 @@ static void s2io_set_multicast(struct net_device *dev)
 		/* Wait till command completes */
 		wait_for_cmd_complete(&bar0->rmac_addr_cmd_mem,
 				      RMAC_ADDR_CMD_MEM_STROBE_CMD_EXECUTING,
-				      S2IO_BIT_RESET);
+				      S2IO_BIT_RESET, may_sleep);
=20
 		sp->m_cast_flg =3D 1;
 		sp->all_multi_pos =3D config->max_mc_addr - 1;
@@ -4920,7 +4919,7 @@ static void s2io_set_multicast(struct net_device *dev)
 		/* Wait till command completes */
 		wait_for_cmd_complete(&bar0->rmac_addr_cmd_mem,
 				      RMAC_ADDR_CMD_MEM_STROBE_CMD_EXECUTING,
-				      S2IO_BIT_RESET);
+				      S2IO_BIT_RESET, may_sleep);
=20
 		sp->m_cast_flg =3D 0;
 		sp->all_multi_pos =3D 0;
@@ -5000,7 +4999,7 @@ static void s2io_set_multicast(struct net_device *dev)
 			/* Wait for command completes */
 			if (wait_for_cmd_complete(&bar0->rmac_addr_cmd_mem,
 						  RMAC_ADDR_CMD_MEM_STROBE_CMD_EXECUTING,
-						  S2IO_BIT_RESET)) {
+						  S2IO_BIT_RESET, may_sleep)) {
 				DBG_PRINT(ERR_DBG,
 					  "%s: Adding Multicasts failed\n",
 					  dev->name);
@@ -5030,7 +5029,7 @@ static void s2io_set_multicast(struct net_device *dev)
 			/* Wait for command completes */
 			if (wait_for_cmd_complete(&bar0->rmac_addr_cmd_mem,
 						  RMAC_ADDR_CMD_MEM_STROBE_CMD_EXECUTING,
-						  S2IO_BIT_RESET)) {
+						  S2IO_BIT_RESET, may_sleep)) {
 				DBG_PRINT(ERR_DBG,
 					  "%s: Adding Multicasts failed\n",
 					  dev->name);
@@ -5041,6 +5040,12 @@ static void s2io_set_multicast(struct net_device *de=
v)
 	}
 }
=20
+/* NDO wrapper for s2io_set_multicast */
+static void s2io_ndo_set_multicast(struct net_device *dev)
+{
+	s2io_set_multicast(dev, false);
+}
+
 /* read from CAM unicast & multicast addresses and store it in
  * def_mac_addr structure
  */
@@ -5127,7 +5132,7 @@ static int do_s2io_add_mac(struct s2io_nic *sp, u64 a=
ddr, int off)
 	/* Wait till command completes */
 	if (wait_for_cmd_complete(&bar0->rmac_addr_cmd_mem,
 				  RMAC_ADDR_CMD_MEM_STROBE_CMD_EXECUTING,
-				  S2IO_BIT_RESET)) {
+				  S2IO_BIT_RESET, true)) {
 		DBG_PRINT(INFO_DBG, "do_s2io_add_mac failed\n");
 		return FAILURE;
 	}
@@ -5171,7 +5176,7 @@ static u64 do_s2io_read_unicast_mc(struct s2io_nic *s=
p, int offset)
 	/* Wait till command completes */
 	if (wait_for_cmd_complete(&bar0->rmac_addr_cmd_mem,
 				  RMAC_ADDR_CMD_MEM_STROBE_CMD_EXECUTING,
-				  S2IO_BIT_RESET)) {
+				  S2IO_BIT_RESET, true)) {
 		DBG_PRINT(INFO_DBG, "do_s2io_read_unicast_mc failed\n");
 		return FAILURE;
 	}
@@ -7141,7 +7146,7 @@ static int s2io_card_up(struct s2io_nic *sp)
 	}
=20
 	/* Setting its receive mode */
-	s2io_set_multicast(dev);
+	s2io_set_multicast(dev, true);
=20
 	if (dev->features & NETIF_F_LRO) {
 		/* Initialize max aggregatable pkts per session based on MTU */
@@ -7447,7 +7452,7 @@ static void s2io_link(struct s2io_nic *sp, int link)
 	struct swStat *swstats =3D &sp->mac_control.stats_info->sw_stat;
=20
 	if (link !=3D sp->last_link_state) {
-		init_tti(sp, link);
+		init_tti(sp, link, false);
 		if (link =3D=3D LINK_DOWN) {
 			DBG_PRINT(ERR_DBG, "%s: Link down\n", dev->name);
 			s2io_stop_all_tx_queue(sp);
@@ -7604,7 +7609,7 @@ static int rts_ds_steer(struct s2io_nic *nic, u8 ds_c=
odepoint, u8 ring)
=20
 	return wait_for_cmd_complete(&bar0->rts_ds_mem_ctrl,
 				     RTS_DS_MEM_CTRL_STROBE_CMD_BEING_EXECUTED,
-				     S2IO_BIT_RESET);
+				     S2IO_BIT_RESET, true);
 }
=20
 static const struct net_device_ops s2io_netdev_ops =3D {
@@ -7613,7 +7618,7 @@ static const struct net_device_ops s2io_netdev_ops =
=3D {
 	.ndo_get_stats	        =3D s2io_get_stats,
 	.ndo_start_xmit    	=3D s2io_xmit,
 	.ndo_validate_addr	=3D eth_validate_addr,
-	.ndo_set_rx_mode	=3D s2io_set_multicast,
+	.ndo_set_rx_mode	=3D s2io_ndo_set_multicast,
 	.ndo_do_ioctl	   	=3D s2io_ioctl,
 	.ndo_set_mac_address    =3D s2io_set_mac_addr,
 	.ndo_change_mtu	   	=3D s2io_change_mtu,
@@ -7929,7 +7934,7 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_=
device_id *pre)
 	writeq(val64, &bar0->rmac_addr_cmd_mem);
 	wait_for_cmd_complete(&bar0->rmac_addr_cmd_mem,
 			      RMAC_ADDR_CMD_MEM_STROBE_CMD_EXECUTING,
-			      S2IO_BIT_RESET);
+			      S2IO_BIT_RESET, true);
 	tmp64 =3D readq(&bar0->rmac_addr_data0_mem);
 	mac_down =3D (u32)tmp64;
 	mac_up =3D (u32) (tmp64 >> 32);
diff --git a/drivers/net/ethernet/neterion/s2io.h b/drivers/net/ethernet/ne=
terion/s2io.h
index 6fa3159a977fd..5a6032212c19d 100644
--- a/drivers/net/ethernet/neterion/s2io.h
+++ b/drivers/net/ethernet/neterion/s2io.h
@@ -1066,7 +1066,7 @@ static void tx_intr_handler(struct fifo_info *fifo_da=
ta);
 static void s2io_handle_errors(void * dev_id);
=20
 static void s2io_tx_watchdog(struct net_device *dev, unsigned int txqueue);
-static void s2io_set_multicast(struct net_device *dev);
+static void s2io_set_multicast(struct net_device *dev, bool may_sleep);
 static int rx_osm_handler(struct ring_info *ring_data, struct RxD_t * rxdp=
);
 static void s2io_link(struct s2io_nic * sp, int link);
 static void s2io_reset(struct s2io_nic * sp);
@@ -1087,7 +1087,7 @@ static int s2io_set_swapper(struct s2io_nic * sp);
 static void s2io_card_down(struct s2io_nic *nic);
 static int s2io_card_up(struct s2io_nic *nic);
 static int wait_for_cmd_complete(void __iomem *addr, u64 busy_bit,
-					int bit_state);
+				 int bit_state, bool may_sleep);
 static int s2io_add_isr(struct s2io_nic * sp);
 static void s2io_rem_isr(struct s2io_nic * sp);
=20
--=20
2.28.0

