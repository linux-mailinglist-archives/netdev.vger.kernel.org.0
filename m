Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7F545EC76
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 12:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242061AbhKZLY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 06:24:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60728 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238040AbhKZLWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 06:22:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637925582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b5B+euxHoxeq4BHRsHhuTgW+67HevHVfYx/AS1YTxvY=;
        b=Sx06YCiDmzYi79bRIVPWMmr4dkRiOAFj5QL5bkDLyb6NppVKXAvBxDYV26r0jXNIg3as9Y
        GXiXg6+2iGLRNlEAkgyGnJfvpD8wrgJus+2se/ODtusU0SNCvQGOot40AkC/7bjy1HeVgh
        6F4yGcc5fz02mZW7DxM894vzbA5+BHk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-LoWbctD8OSGd1NBjQMnGfg-1; Fri, 26 Nov 2021 06:19:39 -0500
X-MC-Unique: LoWbctD8OSGd1NBjQMnGfg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E51DF1023F54;
        Fri, 26 Nov 2021 11:19:37 +0000 (UTC)
Received: from gerbillo.fritz.box (unknown [10.39.194.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61DDB60BF4;
        Fri, 26 Nov 2021 11:19:36 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH net-next v2 2/2] bpf: let bpf_warn_invalid_xdp_action() report more info
Date:   Fri, 26 Nov 2021 12:19:11 +0100
Message-Id: <277a9483b38f9016bc78ce66707753681684fbd7.1637924200.git.pabeni@redhat.com>
In-Reply-To: <cover.1637924200.git.pabeni@redhat.com>
References: <cover.1637924200.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In non trivial scenarios, the action id alone is not sufficient
to identify the program causing the warning. Before the previous
patch, the generated stack-trace pointed out at least the
involved device driver.

Let's additionally include the program name and id, and the
relevant device name.

If the user needs additional infos, he can fetch them via a
kernel probe, leveraging the arguments added here.

v1 -> v2:
 - do not include the device name for maps caller (Toke)

rfc -> v1:
 - do not print the attach type, print the program name

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c           | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c          | 2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c       | 2 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c         | 2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c       | 2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c           | 2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c            | 2 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c             | 2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c              | 2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c               | 2 +-
 drivers/net/ethernet/intel/igb/igb_main.c              | 2 +-
 drivers/net/ethernet/intel/igc/igc_main.c              | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c          | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c           | 2 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c      | 2 +-
 drivers/net/ethernet/marvell/mvneta.c                  | 2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c        | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c             | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c       | 2 +-
 drivers/net/ethernet/microsoft/mana/mana_bpf.c         | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c    | 2 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c             | 2 +-
 drivers/net/ethernet/sfc/rx.c                          | 2 +-
 drivers/net/ethernet/socionext/netsec.c                | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c      | 2 +-
 drivers/net/ethernet/ti/cpsw_priv.c                    | 2 +-
 drivers/net/hyperv/netvsc_bpf.c                        | 2 +-
 drivers/net/tun.c                                      | 2 +-
 drivers/net/veth.c                                     | 4 ++--
 drivers/net/virtio_net.c                               | 4 ++--
 drivers/net/xen-netfront.c                             | 2 +-
 include/linux/filter.h                                 | 2 +-
 kernel/bpf/cpumap.c                                    | 4 ++--
 kernel/bpf/devmap.c                                    | 4 ++--
 net/core/dev.c                                         | 2 +-
 net/core/filter.c                                      | 6 +++---
 37 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 7d5d885d85d5..3b46f1df5609 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -434,7 +434,7 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 		xdp_stat = &rx_ring->rx_stats.xdp_pass;
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(verdict);
+		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, verdict);
 		xdp_stat = &rx_ring->rx_stats.xdp_invalid;
 	}
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index c8083df5e0ab..52fad0fdeacf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -195,7 +195,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		*event |= BNXT_REDIRECT_EVENT;
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(bp->dev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(bp->dev, xdp_prog, act);
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index bb45d5df2856..30450efccad7 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -590,7 +590,7 @@ static inline bool nicvf_xdp_rx(struct nicvf *nic, struct bpf_prog *prog,
 		nicvf_xdp_sq_append_pkt(nic, sq, (u64)xdp.data, dma_addr, len);
 		return true;
 	default:
-		bpf_warn_invalid_xdp_action(action);
+		bpf_warn_invalid_xdp_action(nic->netdev, prog, action);
 		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(nic->netdev, prog, action);
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index d6871437d951..c78883c3a2c8 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2623,7 +2623,7 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 		}
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(xdp_act);
+		bpf_warn_invalid_xdp_action(priv->net_dev, xdp_prog, xdp_act);
 		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 6451c8383639..4ef6b18005d9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -374,7 +374,7 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 		dpaa2_eth_xdp_enqueue(priv, ch, fd, vaddr, rx_fq->flowid);
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(xdp_act);
+		bpf_warn_invalid_xdp_action(priv->net_dev, xdp_prog, xdp_act);
 		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 504e12554079..eacb41f86bdb 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1547,7 +1547,7 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 
 		switch (xdp_act) {
 		default:
-			bpf_warn_invalid_xdp_action(xdp_act);
+			bpf_warn_invalid_xdp_action(rx_ring->ndev, prog, xdp_act);
 			fallthrough;
 		case XDP_ABORTED:
 			trace_xdp_exception(rx_ring->ndev, prog, xdp_act);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 10a83e5385c7..b399ca649f09 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2322,7 +2322,7 @@ static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		result = I40E_XDP_REDIR;
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 out_failure:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index ea06e957393e..945b1bb9c6f4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -176,7 +176,7 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 			goto out_failure;
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 out_failure:
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index bc3ba19dc88f..56940bb908bc 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -561,7 +561,7 @@ ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 			goto out_failure;
 		return ICE_XDP_REDIR;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 out_failure:
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index ff55cb415b11..eb68a5824e9a 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -482,7 +482,7 @@ ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 			goto out_failure;
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 out_failure:
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 18a019a47182..210f785432ab 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8422,7 +8422,7 @@ static struct sk_buff *igb_run_xdp(struct igb_adapter *adapter,
 		result = IGB_XDP_REDIR;
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(adapter->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 out_failure:
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 8e448288ee26..4ea212ddcc9b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2231,7 +2231,7 @@ static int __igc_xdp_run_prog(struct igc_adapter *adapter,
 		return IGC_XDP_REDIRECT;
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(adapter->netdev, prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 out_failure:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 0f9f022260d7..265bc52aacf8 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2235,7 +2235,7 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 		result = IXGBE_XDP_REDIR;
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 out_failure:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index db2bc58dfcfd..b3fd8e5cd85b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -131,7 +131,7 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 			goto out_failure;
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 out_failure:
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index b1dfbaff8b31..2459ecf65125 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1070,7 +1070,7 @@ static struct sk_buff *ixgbevf_run_xdp(struct ixgbevf_adapter *adapter,
 			goto out_failure;
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 out_failure:
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 80e4b500695e..f0ba8d846e28 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2212,7 +2212,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 			mvneta_xdp_put_buff(pp, rxq, xdp, sinfo, sync);
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(pp->dev, prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(pp->dev, prog, act);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 97bd2ee8a010..2880c587a50d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3823,7 +3823,7 @@ mvpp2_run_xdp(struct mvpp2_port *port, struct bpf_prog *prog,
 		}
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(port->dev, prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(port->dev, prog, act);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 0cc6353254bf..7c4068c5d1ac 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -1198,7 +1198,7 @@ static bool otx2_xdp_rcv_pkt_handler(struct otx2_nic *pfvf,
 		put_page(page);
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(pfvf->netdev, prog, act);
 		break;
 	case XDP_ABORTED:
 		trace_xdp_exception(pfvf->netdev, prog, act);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 650e6a1844ae..8cfc649f226b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -812,7 +812,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 				trace_xdp_exception(dev, xdp_prog, act);
 				goto xdp_drop_no_cnt; /* Drop on xmit failure */
 			default:
-				bpf_warn_invalid_xdp_action(act);
+				bpf_warn_invalid_xdp_action(dev, xdp_prog, act);
 				fallthrough;
 			case XDP_ABORTED:
 				trace_xdp_exception(dev, xdp_prog, act);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 2f0df5cc1a2d..338d65e2c9ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -151,7 +151,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 		rq->stats->xdp_redirect++;
 		return true;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(rq->netdev, prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 xdp_abort:
diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 1bc8ff388341..1d2f948b5c00 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -60,7 +60,7 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 		break;
 
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(ndev, prog, act);
 	}
 
 out:
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 6e38da4ad554..79257ec41987 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1944,7 +1944,7 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 							    xdp_prog, act);
 				continue;
 			default:
-				bpf_warn_invalid_xdp_action(act);
+				bpf_warn_invalid_xdp_action(dp->netdev, xdp_prog, act);
 				fallthrough;
 			case XDP_ABORTED:
 				trace_xdp_exception(dp->netdev, xdp_prog, act);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index e113fbd56e86..d1102686b09a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1153,7 +1153,7 @@ static bool qede_rx_xdp(struct qede_dev *edev,
 		qede_rx_bd_ring_consume(rxq);
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(edev->ndev, prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(edev->ndev, prog, act);
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 606750938b89..2375cef577e4 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -338,7 +338,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 		break;
 
 	default:
-		bpf_warn_invalid_xdp_action(xdp_act);
+		bpf_warn_invalid_xdp_action(efx->net_dev, xdp_prog, xdp_act);
 		efx_free_rx_buffers(rx_queue, rx_buf, 1);
 		channel->n_rx_xdp_bad_drops++;
 		trace_xdp_exception(efx->net_dev, xdp_prog, xdp_act);
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index de7d8bf2c226..25dcd8eda5fc 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -933,7 +933,7 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
 		}
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(priv->ndev, prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(priv->ndev, prog, act);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6d86b14c285f..a6ef40576615 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4679,7 +4679,7 @@ static int __stmmac_xdp_run_prog(struct stmmac_priv *priv,
 			res = STMMAC_XDP_REDIRECT;
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(priv->dev, prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(priv->dev, prog, act);
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index c99dd9735087..67c4009fd16c 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1366,7 +1366,7 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
 		xdp_do_flush_map();
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(ndev, prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(ndev, prog, act);
diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
index aa877da113f8..7856905414eb 100644
--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -68,7 +68,7 @@ u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
 		break;
 
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(ndev, prog, act);
 	}
 
 out:
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 1572878c3403..0e5d2272f63a 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1551,7 +1551,7 @@ static int tun_xdp_act(struct tun_struct *tun, struct bpf_prog *xdp_prog,
 	case XDP_PASS:
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(tun->dev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(tun->dev, xdp_prog, act);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 38f6da24f460..700cc9374f9c 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -644,7 +644,7 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
 			rcu_read_unlock();
 			goto xdp_xmit;
 		default:
-			bpf_warn_invalid_xdp_action(act);
+			bpf_warn_invalid_xdp_action(rq->dev, xdp_prog, act);
 			fallthrough;
 		case XDP_ABORTED:
 			trace_xdp_exception(rq->dev, xdp_prog, act);
@@ -794,7 +794,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 		rcu_read_unlock();
 		goto xdp_xmit;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(rq->dev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(rq->dev, xdp_prog, act);
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c74af526d79b..072130c936ea 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -812,7 +812,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			rcu_read_unlock();
 			goto xdp_xmit;
 		default:
-			bpf_warn_invalid_xdp_action(act);
+			bpf_warn_invalid_xdp_action(vi->dev, xdp_prog, act);
 			fallthrough;
 		case XDP_ABORTED:
 			trace_xdp_exception(vi->dev, xdp_prog, act);
@@ -1025,7 +1025,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			rcu_read_unlock();
 			goto xdp_xmit;
 		default:
-			bpf_warn_invalid_xdp_action(act);
+			bpf_warn_invalid_xdp_action(vi->dev, xdp_prog, act);
 			fallthrough;
 		case XDP_ABORTED:
 			trace_xdp_exception(vi->dev, xdp_prog, act);
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 911f43986a8c..7b7eb617051a 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -930,7 +930,7 @@ static u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
 		break;
 
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(queue->info->netdev, prog, act);
 	}
 
 	return act;
diff --git a/include/linux/filter.h b/include/linux/filter.h
index b6a216eb217a..0769d7f18102 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1030,7 +1030,7 @@ void xdp_do_flush(void);
  */
 #define xdp_do_flush_map xdp_do_flush
 
-void bpf_warn_invalid_xdp_action(u32 act);
+void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog, u32 act);
 
 #ifdef CONFIG_INET
 struct sock *bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 585b2b77ccc4..0421061d95f1 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -195,7 +195,7 @@ static void cpu_map_bpf_prog_run_skb(struct bpf_cpu_map_entry *rcpu,
 			}
 			return;
 		default:
-			bpf_warn_invalid_xdp_action(act);
+			bpf_warn_invalid_xdp_action(NULL, rcpu->prog, act);
 			fallthrough;
 		case XDP_ABORTED:
 			trace_xdp_exception(skb->dev, rcpu->prog, act);
@@ -254,7 +254,7 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 			}
 			break;
 		default:
-			bpf_warn_invalid_xdp_action(act);
+			bpf_warn_invalid_xdp_action(NULL, rcpu->prog, act);
 			fallthrough;
 		case XDP_DROP:
 			xdp_return_frame(xdpf);
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f02d04540c0c..6feea293ff10 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -348,7 +348,7 @@ static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
 				frames[nframes++] = xdpf;
 			break;
 		default:
-			bpf_warn_invalid_xdp_action(act);
+			bpf_warn_invalid_xdp_action(NULL, xdp_prog, act);
 			fallthrough;
 		case XDP_ABORTED:
 			trace_xdp_exception(dev, xdp_prog, act);
@@ -507,7 +507,7 @@ static u32 dev_map_bpf_prog_run_skb(struct sk_buff *skb, struct bpf_dtab_netdev
 		__skb_push(skb, skb->mac_len);
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(NULL, dst->xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(dst->dev, dst->xdp_prog, act);
diff --git a/net/core/dev.c b/net/core/dev.c
index 823917de0d2b..26801035c447 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4705,7 +4705,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	case XDP_PASS:
 		break;
 	default:
-		bpf_warn_invalid_xdp_action(act);
+		bpf_warn_invalid_xdp_action(skb->dev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(skb->dev, xdp_prog, act);
diff --git a/net/core/filter.c b/net/core/filter.c
index 5631acf3f10c..75922ff59c3c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8181,13 +8181,13 @@ static bool xdp_is_valid_access(int off, int size,
 	return __is_valid_xdp_access(off, size);
 }
 
-void bpf_warn_invalid_xdp_action(u32 act)
+void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog, u32 act)
 {
 	const u32 act_max = XDP_REDIRECT;
 
-	pr_warn_once("%s XDP return value %u, expect packet loss!\n",
+	pr_warn_once("%s XDP return value %u on prog %s (id %d) dev %s, expect packet loss!\n",
 		     act > act_max ? "Illegal" : "Driver unsupported",
-		     act);
+		     act, prog->aux->name, prog->aux->id, dev->name ? dev->name : "");
 }
 EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
 
-- 
2.33.1

