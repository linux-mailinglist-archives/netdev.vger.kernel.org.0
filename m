Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BB329CC72
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832638AbgJ0W5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:57:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50018 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832530AbgJ0Wz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:55:58 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603839354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tcSa5YSrfG4xl3ThzEZbNNTbn7vFa8bF7wp3SbXlfyw=;
        b=tKTPZpxaVJ4ueIxENaTCMjcs82oPAhM9X0ViDPIhrQDfN1CJ45JiU0lTlSgyE5FT3xpzhj
        AtrQgSVIRLImXk3T3LrzKzEZx2yg82g0JWKe0rtKUqHjqUFINyiukEwAjKDGug8k4qScit
        dINLX05imL1aZ/S0R5nqWnVaSizPqvKJuvnF77mOBVUq0pD53WkafBfFpLwS9gBuaArbQ0
        +8abfQunVVjfyWFeHe/bKCyi1ILhIwC8K970LgjlhRrZ83O84O6hbvE0uTfDCnYNmGSeSe
        3Z9NMRwWuQy1ff65arS1mQ51ed8V1wD/or/6ZF4yfZsVbWVhbDcKxV+k/EJ0HA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603839354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tcSa5YSrfG4xl3ThzEZbNNTbn7vFa8bF7wp3SbXlfyw=;
        b=Hw+UJiwYeyLH1r/VLjfzOSxuldeQVIwHCtgT40wTXRX+AnQfE4hyLdl6kElrx05thIhSYK
        91j5F6AsKR7YGiAg==
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
Subject: [PATCH net-next 08/15] net: airo: Replace in_atomic() usage.
Date:   Tue, 27 Oct 2020 23:54:47 +0100
Message-Id: <20201027225454.3492351-9-bigeasy@linutronix.de>
In-Reply-To: <20201027225454.3492351-1-bigeasy@linutronix.de>
References: <20201027225454.3492351-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

issuecommand() is using in_atomic() to decide if it is safe to invoke
schedule() while waiting for the command to be accepted.

Usage of in_atomic() for this is only half correct as it can not detect all
condition where it is not allowed to schedule(). Also Linus clearly
requested that code which changes behaviour depending on context should
either be seperated or the context be conveyed in an argument passed by the
caller, which usually knows the context.

Add an may_sleep argument to issuecommand() indicating when it is save to
sleep and change schedule() to cond_resched() because it's pointless to
invoke schedule() if there is no request to reschedule.

Pass the may_sleep condition through the various call chains leading to
issuecommand().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/cisco/airo.c | 86 +++++++++++++++++--------------
 1 file changed, 47 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco=
/airo.c
index 369a6ca44d1ff..74acf9af2adb1 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -1115,7 +1115,8 @@ static int enable_MAC(struct airo_info *ai, int lock);
 static void disable_MAC(struct airo_info *ai, int lock);
 static void enable_interrupts(struct airo_info*);
 static void disable_interrupts(struct airo_info*);
-static u16 issuecommand(struct airo_info*, Cmd *pCmd, Resp *pRsp);
+static u16 issuecommand(struct airo_info*, Cmd *pCmd, Resp *pRsp,
+			bool may_sleep);
 static int bap_setup(struct airo_info*, u16 rid, u16 offset, int whichbap);
 static int aux_bap_read(struct airo_info*, __le16 *pu16Dst, int bytelen,
 			int whichbap);
@@ -1130,8 +1131,10 @@ static int PC4500_writerid(struct airo_info*, u16 ri=
d, const void
 static int do_writerid(struct airo_info*, u16 rid, const void *rid_data,
 			int len, int dummy);
 static u16 transmit_allocate(struct airo_info*, int lenPayload, int raw);
-static int transmit_802_3_packet(struct airo_info*, int len, char *pPacket=
);
-static int transmit_802_11_packet(struct airo_info*, int len, char *pPacke=
t);
+static int transmit_802_3_packet(struct airo_info*, int len, char *pPacket,
+				 bool may_sleep);
+static int transmit_802_11_packet(struct airo_info*, int len, char *pPacke=
t,
+				  bool may_sleep);
=20
 static int mpi_send_packet(struct net_device *dev);
 static void mpi_unmap_card(struct pci_dev *pci);
@@ -1753,7 +1756,7 @@ static int readBSSListRid(struct airo_info *ai, int f=
irst,
 		if (down_interruptible(&ai->sem))
 			return -ERESTARTSYS;
 		ai->list_bss_task =3D current;
-		issuecommand(ai, &cmd, &rsp);
+		issuecommand(ai, &cmd, &rsp, true);
 		up(&ai->sem);
 		/* Let the command take effect */
 		schedule_timeout_uninterruptible(3 * HZ);
@@ -2096,7 +2099,7 @@ static void get_tx_error(struct airo_info *ai, s32 fi=
d)
 	}
 }
=20
-static void airo_end_xmit(struct net_device *dev)
+static void airo_end_xmit(struct net_device *dev, bool may_sleep)
 {
 	u16 status;
 	int i;
@@ -2107,7 +2110,7 @@ static void airo_end_xmit(struct net_device *dev)
=20
 	clear_bit(JOB_XMIT, &priv->jobs);
 	clear_bit(FLAG_PENDING_XMIT, &priv->flags);
-	status =3D transmit_802_3_packet (priv, fids[fid], skb->data);
+	status =3D transmit_802_3_packet(priv, fids[fid], skb->data, may_sleep);
 	up(&priv->sem);
=20
 	i =3D 0;
@@ -2164,11 +2167,11 @@ static netdev_tx_t airo_start_xmit(struct sk_buff *=
skb,
 		set_bit(JOB_XMIT, &priv->jobs);
 		wake_up_interruptible(&priv->thr_wait);
 	} else
-		airo_end_xmit(dev);
+		airo_end_xmit(dev, false);
 	return NETDEV_TX_OK;
 }
=20
-static void airo_end_xmit11(struct net_device *dev)
+static void airo_end_xmit11(struct net_device *dev, bool may_sleep)
 {
 	u16 status;
 	int i;
@@ -2179,7 +2182,7 @@ static void airo_end_xmit11(struct net_device *dev)
=20
 	clear_bit(JOB_XMIT11, &priv->jobs);
 	clear_bit(FLAG_PENDING_XMIT11, &priv->flags);
-	status =3D transmit_802_11_packet (priv, fids[fid], skb->data);
+	status =3D transmit_802_11_packet(priv, fids[fid], skb->data, may_sleep);
 	up(&priv->sem);
=20
 	i =3D MAX_FIDS / 2;
@@ -2243,7 +2246,7 @@ static netdev_tx_t airo_start_xmit11(struct sk_buff *=
skb,
 		set_bit(JOB_XMIT11, &priv->jobs);
 		wake_up_interruptible(&priv->thr_wait);
 	} else
-		airo_end_xmit11(dev);
+		airo_end_xmit11(dev, false);
 	return NETDEV_TX_OK;
 }
=20
@@ -2293,7 +2296,7 @@ static struct net_device_stats *airo_get_stats(struct=
 net_device *dev)
 	return &dev->stats;
 }
=20
-static void airo_set_promisc(struct airo_info *ai)
+static void airo_set_promisc(struct airo_info *ai, bool may_sleep)
 {
 	Cmd cmd;
 	Resp rsp;
@@ -2302,7 +2305,7 @@ static void airo_set_promisc(struct airo_info *ai)
 	cmd.cmd =3D CMD_SETMODE;
 	clear_bit(JOB_PROMISC, &ai->jobs);
 	cmd.parm0=3D(ai->flags&IFF_PROMISC) ? PROMISC : NOPROMISC;
-	issuecommand(ai, &cmd, &rsp);
+	issuecommand(ai, &cmd, &rsp, may_sleep);
 	up(&ai->sem);
 }
=20
@@ -2316,7 +2319,7 @@ static void airo_set_multicast_list(struct net_device=
 *dev)
 			set_bit(JOB_PROMISC, &ai->jobs);
 			wake_up_interruptible(&ai->thr_wait);
 		} else
-			airo_set_promisc(ai);
+			airo_set_promisc(ai, false);
 	}
=20
 	if ((dev->flags&IFF_ALLMULTI) || !netdev_mc_empty(dev)) {
@@ -2476,7 +2479,7 @@ static int mpi_init_descriptors (struct airo_info *ai)
 	cmd.parm0 =3D FID_RX;
 	cmd.parm1 =3D (ai->rxfids[0].card_ram_off - ai->pciaux);
 	cmd.parm2 =3D MPI_MAX_FIDS;
-	rc =3D issuecommand(ai, &cmd, &rsp);
+	rc =3D issuecommand(ai, &cmd, &rsp, true);
 	if (rc !=3D SUCCESS) {
 		airo_print_err(ai->dev->name, "Couldn't allocate RX FID");
 		return rc;
@@ -2504,7 +2507,7 @@ static int mpi_init_descriptors (struct airo_info *ai)
 	}
 	ai->txfids[i-1].tx_desc.eoc =3D 1; /* Last descriptor has EOC set */
=20
-	rc =3D issuecommand(ai, &cmd, &rsp);
+	rc =3D issuecommand(ai, &cmd, &rsp, true);
 	if (rc !=3D SUCCESS) {
 		airo_print_err(ai->dev->name, "Couldn't allocate TX FID");
 		return rc;
@@ -2518,7 +2521,7 @@ static int mpi_init_descriptors (struct airo_info *ai)
 	cmd.parm0 =3D RID_RW;
 	cmd.parm1 =3D (ai->config_desc.card_ram_off - ai->pciaux);
 	cmd.parm2 =3D 1; /* Magic number... */
-	rc =3D issuecommand(ai, &cmd, &rsp);
+	rc =3D issuecommand(ai, &cmd, &rsp, true);
 	if (rc !=3D SUCCESS) {
 		airo_print_err(ai->dev->name, "Couldn't allocate RID");
 		return rc;
@@ -3144,13 +3147,13 @@ static int airo_thread(void *data)
 		}
=20
 		if (test_bit(JOB_XMIT, &ai->jobs))
-			airo_end_xmit(dev);
+			airo_end_xmit(dev, true);
 		else if (test_bit(JOB_XMIT11, &ai->jobs))
-			airo_end_xmit11(dev);
+			airo_end_xmit11(dev, true);
 		else if (test_bit(JOB_STATS, &ai->jobs))
 			airo_read_stats(dev);
 		else if (test_bit(JOB_PROMISC, &ai->jobs))
-			airo_set_promisc(ai);
+			airo_set_promisc(ai, true);
 		else if (test_bit(JOB_MIC, &ai->jobs))
 			micinit(ai);
 		else if (test_bit(JOB_EVENT, &ai->jobs))
@@ -3599,7 +3602,7 @@ static int enable_MAC(struct airo_info *ai, int lock)
 	if (!test_bit(FLAG_ENABLED, &ai->flags)) {
 		memset(&cmd, 0, sizeof(cmd));
 		cmd.cmd =3D MAC_ENABLE;
-		rc =3D issuecommand(ai, &cmd, &rsp);
+		rc =3D issuecommand(ai, &cmd, &rsp, true);
 		if (rc =3D=3D SUCCESS)
 			set_bit(FLAG_ENABLED, &ai->flags);
 	} else
@@ -3631,7 +3634,7 @@ static void disable_MAC(struct airo_info *ai, int loc=
k)
 			netif_carrier_off(ai->dev);
 		memset(&cmd, 0, sizeof(cmd));
 		cmd.cmd =3D MAC_DISABLE; // disable in case already enabled
-		issuecommand(ai, &cmd, &rsp);
+		issuecommand(ai, &cmd, &rsp, true);
 		clear_bit(FLAG_ENABLED, &ai->flags);
 	}
 	if (lock =3D=3D 1)
@@ -3834,7 +3837,7 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, =
int lock)
 	cmd.parm0 =3D cmd.parm1 =3D cmd.parm2 =3D 0;
 	if (lock && down_interruptible(&ai->sem))
 		return ERROR;
-	if (issuecommand(ai, &cmd, &rsp) !=3D SUCCESS) {
+	if (issuecommand(ai, &cmd, &rsp, true) !=3D SUCCESS) {
 		if (lock)
 			up(&ai->sem);
 		return ERROR;
@@ -3844,7 +3847,7 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, =
int lock)
 	// Let's figure out if we need to use the AUX port
 	if (!test_bit(FLAG_MPI,&ai->flags)) {
 		cmd.cmd =3D CMD_ENABLEAUX;
-		if (issuecommand(ai, &cmd, &rsp) !=3D SUCCESS) {
+		if (issuecommand(ai, &cmd, &rsp, true) !=3D SUCCESS) {
 			if (lock)
 				up(&ai->sem);
 			airo_print_err(ai->dev->name, "Error checking for AUX port");
@@ -3956,7 +3959,8 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, =
int lock)
 	return SUCCESS;
 }
=20
-static u16 issuecommand(struct airo_info *ai, Cmd *pCmd, Resp *pRsp)
+static u16 issuecommand(struct airo_info *ai, Cmd *pCmd, Resp *pRsp,
+			bool may_sleep)
 {
         // Im really paranoid about letting it run forever!
 	int max_tries =3D 600000;
@@ -3973,8 +3977,8 @@ static u16 issuecommand(struct airo_info *ai, Cmd *pC=
md, Resp *pRsp)
 		if ((IN4500(ai, COMMAND)) =3D=3D pCmd->cmd)
 			// PC4500 didn't notice command, try again
 			OUT4500(ai, COMMAND, pCmd->cmd);
-		if (!in_atomic() && (max_tries & 255) =3D=3D 0)
-			schedule();
+		if (may_sleep && (max_tries & 255) =3D=3D 0)
+			cond_resched();
 	}
=20
 	if (max_tries =3D=3D -1) {
@@ -4131,7 +4135,7 @@ static int PC4500_accessrid(struct airo_info *ai, u16=
 rid, u16 accmd)
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.cmd =3D accmd;
 	cmd.parm0 =3D rid;
-	status =3D issuecommand(ai, &cmd, &rsp);
+	status =3D issuecommand(ai, &cmd, &rsp, true);
 	if (status !=3D 0) return status;
 	if ((rsp.status & 0x7F00) !=3D 0) {
 		return (accmd << 8) + (rsp.rsp0 & 0xFF);
@@ -4167,7 +4171,7 @@ static int PC4500_readrid(struct airo_info *ai, u16 r=
id, void *pBuf, int len, in
 		memcpy_toio(ai->config_desc.card_ram_off,
 			&ai->config_desc.rid_desc, sizeof(Rid));
=20
-		rc =3D issuecommand(ai, &cmd, &rsp);
+		rc =3D issuecommand(ai, &cmd, &rsp, true);
=20
 		if (rsp.status & 0x7f00)
 			rc =3D rsp.rsp0;
@@ -4246,7 +4250,7 @@ static int PC4500_writerid(struct airo_info *ai, u16 =
rid,
 			memcpy(ai->config_desc.virtual_host_addr,
 				pBuf, len);
=20
-			rc =3D issuecommand(ai, &cmd, &rsp);
+			rc =3D issuecommand(ai, &cmd, &rsp, true);
 			if ((rc & 0xff00) !=3D 0) {
 				airo_print_err(ai->dev->name, "%s: Write rid Error %d",
 						__func__, rc);
@@ -4292,7 +4296,7 @@ static u16 transmit_allocate(struct airo_info *ai, in=
t lenPayload, int raw)
 	cmd.parm0 =3D lenPayload;
 	if (down_interruptible(&ai->sem))
 		return ERROR;
-	if (issuecommand(ai, &cmd, &rsp) !=3D SUCCESS) {
+	if (issuecommand(ai, &cmd, &rsp, true) !=3D SUCCESS) {
 		txFid =3D ERROR;
 		goto done;
 	}
@@ -4338,7 +4342,8 @@ static u16 transmit_allocate(struct airo_info *ai, in=
t lenPayload, int raw)
 /* In general BAP1 is dedicated to transmiting packets.  However,
    since we need a BAP when accessing RIDs, we also use BAP1 for that.
    Make sure the BAP1 spinlock is held when this is called. */
-static int transmit_802_3_packet(struct airo_info *ai, int len, char *pPac=
ket)
+static int transmit_802_3_packet(struct airo_info *ai, int len, char *pPac=
ket,
+				 bool may_sleep)
 {
 	__le16 payloadLen;
 	Cmd cmd;
@@ -4376,12 +4381,14 @@ static int transmit_802_3_packet(struct airo_info *=
ai, int len, char *pPacket)
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.cmd =3D CMD_TRANSMIT;
 	cmd.parm0 =3D txFid;
-	if (issuecommand(ai, &cmd, &rsp) !=3D SUCCESS) return ERROR;
+	if (issuecommand(ai, &cmd, &rsp, may_sleep) !=3D SUCCESS)
+		return ERROR;
 	if ((rsp.status & 0xFF00) !=3D 0) return ERROR;
 	return SUCCESS;
 }
=20
-static int transmit_802_11_packet(struct airo_info *ai, int len, char *pPa=
cket)
+static int transmit_802_11_packet(struct airo_info *ai, int len, char *pPa=
cket,
+				  bool may_sleep)
 {
 	__le16 fc, payloadLen;
 	Cmd cmd;
@@ -4416,7 +4423,8 @@ static int transmit_802_11_packet(struct airo_info *a=
i, int len, char *pPacket)
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.cmd =3D CMD_TRANSMIT;
 	cmd.parm0 =3D txFid;
-	if (issuecommand(ai, &cmd, &rsp) !=3D SUCCESS) return ERROR;
+	if (issuecommand(ai, &cmd, &rsp, may_sleep) !=3D SUCCESS)
+		return ERROR;
 	if ((rsp.status & 0xFF00) !=3D 0) return ERROR;
 	return SUCCESS;
 }
@@ -5480,7 +5488,7 @@ static int proc_BSSList_open(struct inode *inode, str=
uct file *file)
 				kfree(file->private_data);
 				return -ERESTARTSYS;
 			}
-			issuecommand(ai, &cmd, &rsp);
+			issuecommand(ai, &cmd, &rsp, true);
 			up(&ai->sem);
 			data->readlen =3D 0;
 			return 0;
@@ -5617,7 +5625,7 @@ static int __maybe_unused airo_pci_suspend(struct dev=
ice *dev_d)
 	netif_device_detach(dev);
 	ai->power =3D PMSG_SUSPEND;
 	cmd.cmd =3D HOSTSLEEP;
-	issuecommand(ai, &cmd, &rsp);
+	issuecommand(ai, &cmd, &rsp, true);
=20
 	device_wakeup_enable(dev_d);
 	return 0;
@@ -5960,7 +5968,7 @@ static int airo_set_wap(struct net_device *dev,
 		cmd.cmd =3D CMD_LOSE_SYNC;
 		if (down_interruptible(&local->sem))
 			return -ERESTARTSYS;
-		issuecommand(local, &cmd, &rsp);
+		issuecommand(local, &cmd, &rsp, true);
 		up(&local->sem);
 	} else {
 		memset(APList_rid, 0, sizeof(*APList_rid));
@@ -7258,7 +7266,7 @@ static int airo_set_scan(struct net_device *dev,
 	ai->scan_timeout =3D RUN_AT(3*HZ);
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.cmd =3D CMD_LISTBSS;
-	issuecommand(ai, &cmd, &rsp);
+	issuecommand(ai, &cmd, &rsp, true);
 	wake =3D 1;
=20
 out:
@@ -7525,7 +7533,7 @@ static int airo_config_commit(struct net_device *dev,
 	writeConfigRid(local, 0);
 	enable_MAC(local, 0);
 	if (test_bit (FLAG_RESET, &local->flags))
-		airo_set_promisc(local);
+		airo_set_promisc(local, true);
 	else
 		up(&local->sem);
=20
--=20
2.28.0

