Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559AF229135
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 08:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbgGVGqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 02:46:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7658 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730486AbgGVGqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 02:46:32 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06M6gHV8023614
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 23:46:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=6QoR5pLEUCAUW4slQxy1557B5JsaZ9K5d0ChjiQkG5k=;
 b=eY2qPX1TYUswYH9+JFpZFVVYv3G3vmkZiJcXJa0xgtbGpaCMzvkYaPKyuM0lJ59xhXsb
 Sx4sqniRyagxAyZYT42Mki03a3a8Dt70zpKThgT/39dIXVIPrkcziteSCiNwYNGR4gSW
 0wOBifPE6M8t4iRDbrasfkqO1Fz3SCxJ/34= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 32bvrnr1f8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 23:46:28 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 23:46:28 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 62F302EC494E; Tue, 21 Jul 2020 23:46:24 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <dsahern@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 9/9] bpf, xdp: remove XDP_QUERY_PROG and XDP_QUERY_PROG_HW XDP commands
Date:   Tue, 21 Jul 2020 23:46:02 -0700
Message-ID: <20200722064603.3350758-10-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200722064603.3350758-1-andriin@fb.com>
References: <20200722064603.3350758-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_03:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=25
 mlxlogscore=999 impostorscore=0 clxscore=1015 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007220049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that BPF program/link management is centralized in generic net_device
code, kernel code never queries program id from drivers, so
XDP_QUERY_PROG/XDP_QUERY_PROG_HW commands are unnecessary.

This patch removes all the implementations of those commands in kernel, a=
long
the xdp_attachment_query().

This patch was compile-tested on allyesconfig.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  6 -----
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  4 ----
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  3 ---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  5 ----
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  3 ---
 drivers/net/ethernet/intel/ice/ice_main.c     |  3 ---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  4 ----
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  6 -----
 drivers/net/ethernet/marvell/mvneta.c         |  5 ----
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  3 ---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 24 -------------------
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 18 --------------
 .../ethernet/netronome/nfp/nfp_net_common.c   |  4 ----
 .../net/ethernet/qlogic/qede/qede_filter.c    |  3 ---
 drivers/net/ethernet/sfc/efx.c                |  5 ----
 drivers/net/ethernet/socionext/netsec.c       |  3 ---
 drivers/net/ethernet/ti/cpsw_priv.c           |  3 ---
 drivers/net/hyperv/netvsc_bpf.c               | 21 +---------------
 drivers/net/netdevsim/bpf.c                   |  4 ----
 drivers/net/netdevsim/netdevsim.h             |  2 +-
 drivers/net/tun.c                             | 15 ------------
 drivers/net/veth.c                            | 15 ------------
 drivers/net/virtio_net.c                      | 17 -------------
 drivers/net/xen-netfront.c                    | 21 ----------------
 include/linux/netdevice.h                     |  8 -------
 include/net/xdp.h                             |  2 --
 net/core/dev.c                                |  4 ----
 net/core/xdp.c                                |  9 -------
 28 files changed, 2 insertions(+), 218 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/e=
thernet/amazon/ena/ena_netdev.c
index 91be3ffa1c5c..c1a517166016 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -576,15 +576,9 @@ static int ena_xdp_set(struct net_device *netdev, st=
ruct netdev_bpf *bpf)
  */
 static int ena_xdp(struct net_device *netdev, struct netdev_bpf *bpf)
 {
-	struct ena_adapter *adapter =3D netdev_priv(netdev);
-
 	switch (bpf->command) {
 	case XDP_SETUP_PROG:
 		return ena_xdp_set(netdev, bpf);
-	case XDP_QUERY_PROG:
-		bpf->prog_id =3D adapter->xdp_bpf_prog ?
-			adapter->xdp_bpf_prog->aux->id : 0;
-		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/=
ethernet/broadcom/bnxt/bnxt_xdp.c
index 5e3b4a3b69ea..2704a4709bc7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -330,10 +330,6 @@ int bnxt_xdp(struct net_device *dev, struct netdev_b=
pf *xdp)
 	case XDP_SETUP_PROG:
 		rc =3D bnxt_xdp_set(bp, xdp->prog);
 		break;
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D bp->xdp_prog ? bp->xdp_prog->aux->id : 0;
-		rc =3D 0;
-		break;
 	default:
 		rc =3D -EINVAL;
 		break;
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/n=
et/ethernet/cavium/thunder/nicvf_main.c
index 2ba0ce115e63..1c6163934e20 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1906,9 +1906,6 @@ static int nicvf_xdp(struct net_device *netdev, str=
uct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return nicvf_xdp_setup(nic, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D nic->xdp_prog ? nic->xdp_prog->aux->id : 0;
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/n=
et/ethernet/freescale/dpaa2/dpaa2-eth.c
index d0cc1dc49aaa..7d0198644c35 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2076,14 +2076,9 @@ static int setup_xdp(struct net_device *dev, struc=
t bpf_prog *prog)
=20
 static int dpaa2_eth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
-	struct dpaa2_eth_priv *priv =3D netdev_priv(dev);
-
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return setup_xdp(dev, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D priv->xdp_prog ? priv->xdp_prog->aux->id : 0;
-		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/et=
hernet/intel/i40e/i40e_main.c
index dadbfb3d2a2b..d8315811cbdf 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12923,9 +12923,6 @@ static int i40e_xdp(struct net_device *dev,
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return i40e_xdp_setup(vsi, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D vsi->xdp_prog ? vsi->xdp_prog->aux->id : 0;
-		return 0;
 	case XDP_SETUP_XSK_UMEM:
 		return i40e_xsk_umem_setup(vsi, xdp->xsk.umem,
 					   xdp->xsk.queue_id);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethe=
rnet/intel/ice/ice_main.c
index a1cef089201a..0eb1eb8229d4 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1974,9 +1974,6 @@ static int ice_xdp(struct net_device *dev, struct n=
etdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return ice_xdp_setup_prog(vsi, xdp->prog, xdp->extack);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D vsi->xdp_prog ? vsi->xdp_prog->aux->id : 0;
-		return 0;
 	case XDP_SETUP_XSK_UMEM:
 		return ice_xsk_umem_setup(vsi, xdp->xsk.umem,
 					  xdp->xsk.queue_id);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/=
ethernet/intel/ixgbe/ixgbe_main.c
index 4d898ff21a46..6f32b1706ab9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10190,10 +10190,6 @@ static int ixgbe_xdp(struct net_device *dev, str=
uct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return ixgbe_xdp_setup(dev, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D adapter->xdp_prog ?
-			adapter->xdp_prog->aux->id : 0;
-		return 0;
 	case XDP_SETUP_XSK_UMEM:
 		return ixgbe_xsk_umem_setup(adapter, xdp->xsk.umem,
 					    xdp->xsk.queue_id);
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/=
net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 6e9a397db583..a6267569bfa9 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4502,15 +4502,9 @@ static int ixgbevf_xdp_setup(struct net_device *de=
v, struct bpf_prog *prog)
=20
 static int ixgbevf_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
-	struct ixgbevf_adapter *adapter =3D netdev_priv(dev);
-
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return ixgbevf_xdp_setup(dev, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D adapter->xdp_prog ?
-			       adapter->xdp_prog->aux->id : 0;
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet=
/marvell/mvneta.c
index 7191902f6cfe..044f9e80442d 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4417,14 +4417,9 @@ static int mvneta_xdp_setup(struct net_device *dev=
, struct bpf_prog *prog,
=20
 static int mvneta_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
-	struct mvneta_port *pp =3D netdev_priv(dev);
-
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return mvneta_xdp_setup(dev, xdp->prog, xdp->extack);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D pp->xdp_prog ? pp->xdp_prog->aux->id : 0;
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
index 6a3f356640a0..cd5e9d60307e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4656,9 +4656,6 @@ static int mvpp2_xdp(struct net_device *dev, struct=
 netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return mvpp2_xdp_setup(port, xdp);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D port->xdp_prog ? port->xdp_prog->aux->id : 0;
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net=
/ethernet/mellanox/mlx4/en_netdev.c
index 2b8608f8f0a9..106513f772c3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2802,35 +2802,11 @@ static int mlx4_xdp_set(struct net_device *dev, s=
truct bpf_prog *prog)
 	return err;
 }
=20
-static u32 mlx4_xdp_query(struct net_device *dev)
-{
-	struct mlx4_en_priv *priv =3D netdev_priv(dev);
-	struct mlx4_en_dev *mdev =3D priv->mdev;
-	const struct bpf_prog *xdp_prog;
-	u32 prog_id =3D 0;
-
-	if (!priv->tx_ring_num[TX_XDP])
-		return prog_id;
-
-	mutex_lock(&mdev->state_lock);
-	xdp_prog =3D rcu_dereference_protected(
-		priv->rx_ring[0]->xdp_prog,
-		lockdep_is_held(&mdev->state_lock));
-	if (xdp_prog)
-		prog_id =3D xdp_prog->aux->id;
-	mutex_unlock(&mdev->state_lock);
-
-	return prog_id;
-}
-
 static int mlx4_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return mlx4_xdp_set(dev, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D mlx4_xdp_query(dev);
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_main.c
index 4e5d83f6334a..0a22459807aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4517,29 +4517,11 @@ static int mlx5e_xdp_set(struct net_device *netde=
v, struct bpf_prog *prog)
 	return err;
 }
=20
-static u32 mlx5e_xdp_query(struct net_device *dev)
-{
-	struct mlx5e_priv *priv =3D netdev_priv(dev);
-	const struct bpf_prog *xdp_prog;
-	u32 prog_id =3D 0;
-
-	mutex_lock(&priv->state_lock);
-	xdp_prog =3D priv->channels.params.xdp_prog;
-	if (xdp_prog)
-		prog_id =3D xdp_prog->aux->id;
-	mutex_unlock(&priv->state_lock);
-
-	return prog_id;
-}
-
 static int mlx5e_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return mlx5e_xdp_set(dev, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D mlx5e_xdp_query(dev);
-		return 0;
 	case XDP_SETUP_XSK_UMEM:
 		return mlx5e_xsk_setup_umem(dev, xdp->xsk.umem,
 					    xdp->xsk.queue_id);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/driver=
s/net/ethernet/netronome/nfp/nfp_net_common.c
index 44608873d3d9..39ee23e8c0bf 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3614,10 +3614,6 @@ static int nfp_net_xdp(struct net_device *netdev, =
struct netdev_bpf *xdp)
 		return nfp_net_xdp_setup_drv(nn, xdp);
 	case XDP_SETUP_PROG_HW:
 		return nfp_net_xdp_setup_hw(nn, xdp);
-	case XDP_QUERY_PROG:
-		return xdp_attachment_query(&nn->xdp, xdp);
-	case XDP_QUERY_PROG_HW:
-		return xdp_attachment_query(&nn->xdp_hw, xdp);
 	default:
 		return nfp_app_bpf(nn->app, nn, xdp);
 	}
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net=
/ethernet/qlogic/qede/qede_filter.c
index b7d0b6ccebd3..f961f65d9372 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1045,9 +1045,6 @@ int qede_xdp(struct net_device *dev, struct netdev_=
bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return qede_xdp_set(edev, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D edev->xdp_prog ? edev->xdp_prog->aux->id : 0;
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/ef=
x.c
index befd253af918..ce1a37cc7440 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -721,15 +721,10 @@ static int efx_xdp_setup_prog(struct efx_nic *efx, =
struct bpf_prog *prog)
 static int efx_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	struct efx_nic *efx =3D netdev_priv(dev);
-	struct bpf_prog *xdp_prog;
=20
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return efx_xdp_setup_prog(efx, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp_prog =3D rtnl_dereference(efx->xdp_prog);
-		xdp->prog_id =3D xdp_prog ? xdp_prog->aux->id : 0;
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethern=
et/socionext/netsec.c
index 0f366cc50b74..25db667fa879 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1811,9 +1811,6 @@ static int netsec_xdp(struct net_device *ndev, stru=
ct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return netsec_xdp_setup(priv, xdp->prog, xdp->extack);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D priv->xdp_prog ? priv->xdp_prog->aux->id : 0;
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/t=
i/cpsw_priv.c
index a399f3659346..d6d7a7d9c7ad 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1286,9 +1286,6 @@ int cpsw_ndo_bpf(struct net_device *ndev, struct ne=
tdev_bpf *bpf)
 	case XDP_SETUP_PROG:
 		return cpsw_xdp_prog_setup(priv, bpf);
=20
-	case XDP_QUERY_PROG:
-		return xdp_attachment_query(&priv->xdpi, bpf);
-
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_=
bpf.c
index 8e4141552423..440486d9c999 100644
--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -163,16 +163,6 @@ int netvsc_vf_setxdp(struct net_device *vf_netdev, s=
truct bpf_prog *prog)
 	return ret;
 }
=20
-static u32 netvsc_xdp_query(struct netvsc_device *nvdev)
-{
-	struct bpf_prog *prog =3D netvsc_xdp_get(nvdev);
-
-	if (prog)
-		return prog->aux->id;
-
-	return 0;
-}
-
 int netvsc_bpf(struct net_device *dev, struct netdev_bpf *bpf)
 {
 	struct net_device_context *ndevctx =3D netdev_priv(dev);
@@ -182,12 +172,7 @@ int netvsc_bpf(struct net_device *dev, struct netdev=
_bpf *bpf)
 	int ret;
=20
 	if (!nvdev || nvdev->destroy) {
-		if (bpf->command =3D=3D XDP_QUERY_PROG) {
-			bpf->prog_id =3D 0;
-			return 0; /* Query must always succeed */
-		} else {
-			return -ENODEV;
-		}
+		return -ENODEV;
 	}
=20
 	switch (bpf->command) {
@@ -208,10 +193,6 @@ int netvsc_bpf(struct net_device *dev, struct netdev=
_bpf *bpf)
=20
 		return ret;
=20
-	case XDP_QUERY_PROG:
-		bpf->prog_id =3D netvsc_xdp_query(nvdev);
-		return 0;
-
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index 0b362b8dac17..2e90512f3bbe 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -551,10 +551,6 @@ int nsim_bpf(struct net_device *dev, struct netdev_b=
pf *bpf)
 	ASSERT_RTNL();
=20
 	switch (bpf->command) {
-	case XDP_QUERY_PROG:
-		return xdp_attachment_query(&ns->xdp, bpf);
-	case XDP_QUERY_PROG_HW:
-		return xdp_attachment_query(&ns->xdp_hw, bpf);
 	case XDP_SETUP_PROG:
 		err =3D nsim_setup_prog_checks(ns, bpf);
 		if (err)
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/ne=
tdevsim.h
index d164052e0393..284f7092241d 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -121,7 +121,7 @@ static inline void nsim_bpf_uninit(struct netdevsim *=
ns)
=20
 static inline int nsim_bpf(struct net_device *dev, struct netdev_bpf *bp=
f)
 {
-	return bpf->command =3D=3D XDP_QUERY_PROG ? 0 : -EOPNOTSUPP;
+	return -EOPNOTSUPP;
 }
=20
 static inline int nsim_bpf_disable_tc(struct netdevsim *ns)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7adeb91bd368..061bebe25cb1 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1184,26 +1184,11 @@ static int tun_xdp_set(struct net_device *dev, st=
ruct bpf_prog *prog,
 	return 0;
 }
=20
-static u32 tun_xdp_query(struct net_device *dev)
-{
-	struct tun_struct *tun =3D netdev_priv(dev);
-	const struct bpf_prog *xdp_prog;
-
-	xdp_prog =3D rtnl_dereference(tun->xdp_prog);
-	if (xdp_prog)
-		return xdp_prog->aux->id;
-
-	return 0;
-}
-
 static int tun_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return tun_xdp_set(dev, xdp->prog, xdp->extack);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D tun_xdp_query(dev);
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index b594f03eeddb..e56cd562a664 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1198,26 +1198,11 @@ static int veth_xdp_set(struct net_device *dev, s=
truct bpf_prog *prog,
 	return err;
 }
=20
-static u32 veth_xdp_query(struct net_device *dev)
-{
-	struct veth_priv *priv =3D netdev_priv(dev);
-	const struct bpf_prog *xdp_prog;
-
-	xdp_prog =3D priv->_xdp_prog;
-	if (xdp_prog)
-		return xdp_prog->aux->id;
-
-	return 0;
-}
-
 static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return veth_xdp_set(dev, xdp->prog, xdp->extack);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D veth_xdp_query(dev);
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ba38765dc490..6fa8fe5ef160 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2490,28 +2490,11 @@ static int virtnet_xdp_set(struct net_device *dev=
, struct bpf_prog *prog,
 	return err;
 }
=20
-static u32 virtnet_xdp_query(struct net_device *dev)
-{
-	struct virtnet_info *vi =3D netdev_priv(dev);
-	const struct bpf_prog *xdp_prog;
-	int i;
-
-	for (i =3D 0; i < vi->max_queue_pairs; i++) {
-		xdp_prog =3D rtnl_dereference(vi->rq[i].xdp_prog);
-		if (xdp_prog)
-			return xdp_prog->aux->id;
-	}
-	return 0;
-}
-
 static int virtnet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return virtnet_xdp_set(dev, xdp->prog, xdp->extack);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D virtnet_xdp_query(dev);
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index ed995df19247..895a2a36e441 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1478,32 +1478,11 @@ static int xennet_xdp_set(struct net_device *dev,=
 struct bpf_prog *prog,
 	return 0;
 }
=20
-static u32 xennet_xdp_query(struct net_device *dev)
-{
-	unsigned int num_queues =3D dev->real_num_tx_queues;
-	struct netfront_info *np =3D netdev_priv(dev);
-	const struct bpf_prog *xdp_prog;
-	struct netfront_queue *queue;
-	unsigned int i;
-
-	for (i =3D 0; i < num_queues; ++i) {
-		queue =3D &np->queues[i];
-		xdp_prog =3D rtnl_dereference(queue->xdp_prog);
-		if (xdp_prog)
-			return xdp_prog->aux->id;
-	}
-
-	return 0;
-}
-
 static int xennet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return xennet_xdp_set(dev, xdp->prog, xdp->extack);
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D xennet_xdp_query(dev);
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7d3c412fcfe5..1046763cd0dc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -876,8 +876,6 @@ enum bpf_netdev_command {
 	 */
 	XDP_SETUP_PROG,
 	XDP_SETUP_PROG_HW,
-	XDP_QUERY_PROG,
-	XDP_QUERY_PROG_HW,
 	/* BPF program for offload callbacks, invoked at program load time. */
 	BPF_OFFLOAD_MAP_ALLOC,
 	BPF_OFFLOAD_MAP_FREE,
@@ -911,12 +909,6 @@ struct netdev_bpf {
 			struct bpf_prog *prog;
 			struct netlink_ext_ack *extack;
 		};
-		/* XDP_QUERY_PROG, XDP_QUERY_PROG_HW */
-		struct {
-			u32 prog_id;
-			/* flags with which program was installed */
-			u32 prog_flags;
-		};
 		/* BPF_OFFLOAD_MAP_ALLOC, BPF_OFFLOAD_MAP_FREE */
 		struct {
 			struct bpf_offloaded_map *offmap;
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 5be0d4d65b94..627680b35e31 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -224,8 +224,6 @@ struct xdp_attachment_info {
 };
=20
 struct netdev_bpf;
-int xdp_attachment_query(struct xdp_attachment_info *info,
-			 struct netdev_bpf *bpf);
 bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
 			     struct netdev_bpf *bpf);
 void xdp_attachment_setup(struct xdp_attachment_info *info,
diff --git a/net/core/dev.c b/net/core/dev.c
index 9859dae7d4dc..183965cac45b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5468,10 +5468,6 @@ static int generic_xdp_install(struct net_device *=
dev, struct netdev_bpf *xdp)
 		}
 		break;
=20
-	case XDP_QUERY_PROG:
-		xdp->prog_id =3D old ? old->aux->id : 0;
-		break;
-
 	default:
 		ret =3D -EINVAL;
 		break;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 3c45f99e26d5..48aba933a5a8 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -400,15 +400,6 @@ void __xdp_release_frame(void *data, struct xdp_mem_=
info *mem)
 }
 EXPORT_SYMBOL_GPL(__xdp_release_frame);
=20
-int xdp_attachment_query(struct xdp_attachment_info *info,
-			 struct netdev_bpf *bpf)
-{
-	bpf->prog_id =3D info->prog ? info->prog->aux->id : 0;
-	bpf->prog_flags =3D info->prog ? info->flags : 0;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(xdp_attachment_query);
-
 bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
 			     struct netdev_bpf *bpf)
 {
--=20
2.24.1

