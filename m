Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFFAB5AECE
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 08:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfF3GGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 02:06:02 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42999 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbfF3GGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 02:06:01 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A357321B01;
        Sun, 30 Jun 2019 02:05:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 Jun 2019 02:05:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=RcFGdq+sSrzoUwXwePUhLbY1ki1s+YHzisCxC3vdszw=; b=Wmur/vMf
        4Pnq83uBb2sj2vHod4fYiV8ZyMtZgJpgVTpyPG9sxLUDq2LAccwJnW5Z9LCrXMrY
        Dgd4yzEuUCxdbq38bs9jOwKmiQwqr3YJ3hIHZi+cE77hbRqXNdkXt+IWaDHPs6Z8
        xI207baSSxWxZt7mpzIE8c626R00uDOTbA7W5ZcU1vSq2trYYzaifgWLseUfDbFP
        kaGfQd6LZXNiZPjTCKluvr/q5aH6CHguzmnD+0M1nc0mJZKow3y04FOu1a29ye2m
        linolVjDMRHCJeLjup5wFW4lTEtYLacp1QDvfU4/Sd164M9Hq+GlTYha2AxaU3gB
        dqqkh9aXf9VAqg==
X-ME-Sender: <xms:R1EYXXH7WA57PmpAz_KxeD4ycGlmdDerzbo29iJnDLVM9vPGC6gkQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdefgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeh
X-ME-Proxy: <xmx:R1EYXdiepyd7MsQ9DLXHDiwnPBhGW9VMypdYM6w3Z5uhIJj1_ebWsw>
    <xmx:R1EYXTST4jcl5bSyglL9ZjnQd5Dgo-ZmJiJFFx1-XJSYODqE3u92lQ>
    <xmx:R1EYXV-4zGSOe9JGyU-2Q-yuBhoG1cCQG7oM6_cKdu9GpPLacdn5DA>
    <xmx:R1EYXbWlajxdvmpEqz5YL8KapFyLXCU3B_fLCpY96WI1KZE26A3xYg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9F4798005A;
        Sun, 30 Jun 2019 02:05:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 07/16] mlxsw: spectrum: PTP: Hook into packet receive path
Date:   Sun, 30 Jun 2019 09:04:51 +0300
Message-Id: <20190630060500.7882-8-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190630060500.7882-1-idosch@idosch.org>
References: <20190630060500.7882-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

When configured, the Spectrum hardware can recognize PTP packets and
trap them to the CPU using dedicated traps, PTP0 and PTP1.

One reason to get PTP packets under dedicated traps is to have a
separate policer suitable for the amount of PTP traffic expected when
switch is operated as a boundary clock. For this, add two new trap
groups, MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0 and _PTP1, and associate the
two PTP traps with these two groups.

In the driver, specifically for Spectrum-1, event PTP packets will need
to be paired up with their timestamps. Those arrive through a different
set of traps, added later in the patch set. To support this future use,
introduce a new PTP op, ptp_receive.

It is possible to configure which PTP messages should be trapped under
which PTP trap. On Spectrum systems, we will use PTP0 for event
packets (which need timestamping), and PTP1 for control packets (which
do not). Thus configure PTP0 trap with a custom callback that defers to
the ptp_receive op.

Additionally, L2 PTP packets are actually trapped through the LLDP trap,
not through any of the PTP traps. So treat the LLDP trap the same way as
the PTP0 trap. Unlike PTP traps, which are currently still disabled,
LLDP trap is active. Correspondingly, have all the implementations of
the ptp_receive op return true, which the handler treats as a signal to
forward the packet immediately.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 49 +++++++++++++++----
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 +
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    |  6 +++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    | 15 ++++++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |  2 +
 6 files changed, 67 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 8de9333e6eb1..76ff5b217c04 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5292,6 +5292,8 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_MLD,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1,
 };
 
 /* reg_htgt_trap_group
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 91486193454a..84f4077b4b37 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -147,6 +147,18 @@ struct mlxsw_sp_mlxfw_dev {
 	struct mlxsw_sp *mlxsw_sp;
 };
 
+struct mlxsw_sp_ptp_ops {
+	struct mlxsw_sp_ptp_clock *
+		(*clock_init)(struct mlxsw_sp *mlxsw_sp, struct device *dev);
+	void (*clock_fini)(struct mlxsw_sp_ptp_clock *clock);
+
+	/* Notify a driver that a packet that might be PTP was received. Driver
+	 * is responsible for freeing the passed-in SKB.
+	 */
+	void (*receive)(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
+			u8 local_port);
+};
+
 static int mlxsw_sp_component_query(struct mlxfw_dev *mlxfw_dev,
 				    u16 component_index, u32 *p_max_size,
 				    u8 *p_align_bits, u16 *p_max_write_size)
@@ -3947,8 +3959,8 @@ static void mlxsw_sp_pude_event_func(const struct mlxsw_reg_info *reg,
 	}
 }
 
-static void mlxsw_sp_rx_listener_no_mark_func(struct sk_buff *skb,
-					      u8 local_port, void *priv)
+void mlxsw_sp_rx_listener_no_mark_func(struct sk_buff *skb,
+				       u8 local_port, void *priv)
 {
 	struct mlxsw_sp *mlxsw_sp = priv;
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp->ports[local_port];
@@ -4022,6 +4034,14 @@ static void mlxsw_sp_rx_listener_sample_func(struct sk_buff *skb, u8 local_port,
 	consume_skb(skb);
 }
 
+static void mlxsw_sp_rx_listener_ptp(struct sk_buff *skb, u8 local_port,
+				     void *priv)
+{
+	struct mlxsw_sp *mlxsw_sp = priv;
+
+	mlxsw_sp->ptp_ops->receive(mlxsw_sp, skb, local_port);
+}
+
 #define MLXSW_SP_RXL_NO_MARK(_trap_id, _action, _trap_group, _is_ctrl)	\
 	MLXSW_RXL(mlxsw_sp_rx_listener_no_mark_func, _trap_id, _action,	\
 		  _is_ctrl, SP_##_trap_group, DISCARD)
@@ -4043,7 +4063,8 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	/* L2 traps */
 	MLXSW_SP_RXL_NO_MARK(STP, TRAP_TO_CPU, STP, true),
 	MLXSW_SP_RXL_NO_MARK(LACP, TRAP_TO_CPU, LACP, true),
-	MLXSW_SP_RXL_NO_MARK(LLDP, TRAP_TO_CPU, LLDP, true),
+	MLXSW_RXL(mlxsw_sp_rx_listener_ptp, LLDP, TRAP_TO_CPU,
+		  false, SP_LLDP, DISCARD),
 	MLXSW_SP_RXL_MARK(DHCP, MIRROR_TO_CPU, DHCP, false),
 	MLXSW_SP_RXL_MARK(IGMP_QUERY, MIRROR_TO_CPU, IGMP, false),
 	MLXSW_SP_RXL_NO_MARK(IGMP_V1_REPORT, TRAP_TO_CPU, IGMP, false),
@@ -4112,6 +4133,10 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	/* NVE traps */
 	MLXSW_SP_RXL_MARK(NVE_ENCAP_ARP, TRAP_TO_CPU, ARP, false),
 	MLXSW_SP_RXL_NO_MARK(NVE_DECAP_ARP, TRAP_TO_CPU, ARP, false),
+	/* PTP traps */
+	MLXSW_RXL(mlxsw_sp_rx_listener_ptp, PTP0, TRAP_TO_CPU,
+		  false, SP_PTP0, DISCARD),
+	MLXSW_SP_RXL_NO_MARK(PTP1, TRAP_TO_CPU, PTP1, false),
 };
 
 static const struct mlxsw_listener mlxsw_sp1_listener[] = {
@@ -4166,6 +4191,14 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 			rate = 1024;
 			burst_size = 7;
 			break;
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0:
+			rate = 24 * 1024;
+			burst_size = 12;
+			break;
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1:
+			rate = 19 * 1024;
+			burst_size = 12;
+			break;
 		default:
 			continue;
 		}
@@ -4204,6 +4237,7 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_LLDP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_OSPF:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PIM:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0:
 			priority = 5;
 			tc = 5;
 			break;
@@ -4221,6 +4255,7 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ARP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_RPF:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1:
 			priority = 2;
 			tc = 2;
 			break;
@@ -4383,20 +4418,16 @@ static int mlxsw_sp_basic_trap_groups_set(struct mlxsw_core *mlxsw_core)
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
 }
 
-struct mlxsw_sp_ptp_ops {
-	struct mlxsw_sp_ptp_clock *
-		(*clock_init)(struct mlxsw_sp *mlxsw_sp, struct device *dev);
-	void (*clock_fini)(struct mlxsw_sp_ptp_clock *clock);
-};
-
 static const struct mlxsw_sp_ptp_ops mlxsw_sp1_ptp_ops = {
 	.clock_init	= mlxsw_sp1_ptp_clock_init,
 	.clock_fini	= mlxsw_sp1_ptp_clock_fini,
+	.receive	= mlxsw_sp1_ptp_receive,
 };
 
 static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
 	.clock_init	= mlxsw_sp2_ptp_clock_init,
 	.clock_fini	= mlxsw_sp2_ptp_clock_fini,
+	.receive	= mlxsw_sp2_ptp_receive,
 };
 
 static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 9136a86dc55f..139fb1c53f96 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -440,6 +440,8 @@ struct mlxsw_sp_fid *mlxsw_sp_bridge_fid_get(struct mlxsw_sp *mlxsw_sp,
 extern struct notifier_block mlxsw_sp_switchdev_notifier;
 
 /* spectrum.c */
+void mlxsw_sp_rx_listener_no_mark_func(struct sk_buff *skb,
+				       u8 local_port, void *priv);
 int mlxsw_sp_port_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			  enum mlxsw_reg_qeec_hr hr, u8 index, u8 next_index,
 			  bool dwrr, u8 dwrr_weight);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index bb6c0cb25771..8eca1ac03e7a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -264,3 +264,9 @@ void mlxsw_sp1_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
 	cancel_delayed_work_sync(&clock->overflow_work);
 	kfree(clock);
 }
+
+void mlxsw_sp1_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
+			   u8 local_port)
+{
+	mlxsw_sp_rx_listener_no_mark_func(skb, local_port, mlxsw_sp);
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index 76fa00a4be75..06bb303b5407 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -17,6 +17,9 @@ mlxsw_sp1_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev);
 
 void mlxsw_sp1_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock);
 
+void mlxsw_sp1_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
+			   u8 local_port);
+
 #else
 
 static inline struct mlxsw_sp_ptp_clock *
@@ -29,6 +32,12 @@ static inline void mlxsw_sp1_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
 {
 }
 
+static inline void mlxsw_sp1_ptp_receive(struct mlxsw_sp *mlxsw_sp,
+					 struct sk_buff *skb, u8 local_port)
+{
+	mlxsw_sp_rx_listener_no_mark_func(skb, local_port, mlxsw_sp);
+}
+
 #endif
 
 static inline struct mlxsw_sp_ptp_clock *
@@ -41,4 +50,10 @@ static inline void mlxsw_sp2_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
 {
 }
 
+static inline void mlxsw_sp2_ptp_receive(struct mlxsw_sp *mlxsw_sp,
+					 struct sk_buff *skb, u8 local_port)
+{
+	mlxsw_sp_rx_listener_no_mark_func(skb, local_port, mlxsw_sp);
+}
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 451216dd7f6b..f05b7ff4b9df 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -17,6 +17,8 @@ enum {
 	MLXSW_TRAP_ID_MVRP = 0x15,
 	MLXSW_TRAP_ID_RPVST = 0x16,
 	MLXSW_TRAP_ID_DHCP = 0x19,
+	MLXSW_TRAP_ID_PTP0 = 0x28,
+	MLXSW_TRAP_ID_PTP1 = 0x29,
 	MLXSW_TRAP_ID_IGMP_QUERY = 0x30,
 	MLXSW_TRAP_ID_IGMP_V1_REPORT = 0x31,
 	MLXSW_TRAP_ID_IGMP_V2_REPORT = 0x32,
-- 
2.20.1

