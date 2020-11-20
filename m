Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879902BB8B6
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgKTWNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:13:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbgKTWNd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 17:13:33 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1578022464;
        Fri, 20 Nov 2020 22:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605910410;
        bh=88kC/arAy70AMDEU5lKnkBUu+jBKMqjjeoO3OMQAn/Y=;
        h=From:To:Cc:Subject:Date:From;
        b=o0YJJl04a1Oil+KOhtHYlfrpmgL6+fSpurrFxAC3BIS3JN/PNez5yIBGv0MBzWUl4
         hdcv6+uw+AYKBqVYlaK2QLonx/D0NNrUFZbsvUQhmYCZVAjY0q7ASvZfoUqKgm+vEa
         qcGGxgYQyWD/S92zlKi46v+AS517QTx3j99D/Xdg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, mkubecek@suse.cz,
        linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: don't include ethtool.h from netdevice.h
Date:   Fri, 20 Nov 2020 14:13:28 -0800
Message-Id: <20201120221328.1422925-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

linux/netdevice.h is included in very many places, touching any
of its dependecies causes large incremental builds.

Drop the linux/ethtool.h include, linux/netdevice.h just needs
a forward declaration of struct ethtool_ops.

Fix all the places which made use of this implicit include.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/isdn/capi/capi.c                                 | 1 +
 drivers/media/pci/ttpci/av7110_av.c                      | 1 +
 drivers/net/bonding/bond_procfs.c                        | 1 +
 drivers/net/can/usb/gs_usb.c                             | 1 +
 drivers/net/ethernet/amazon/ena/ena_ethtool.c            | 1 +
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h          | 2 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c          | 1 +
 drivers/net/ethernet/cavium/liquidio/lio_ethtool.c       | 1 +
 drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c      | 1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h               | 1 +
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c           | 1 +
 drivers/net/ethernet/google/gve/gve_ethtool.c            | 1 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h              | 1 +
 drivers/net/ethernet/huawei/hinic/hinic_port.h           | 1 +
 drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c         | 1 +
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h | 1 +
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h             | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h           | 1 +
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c           | 1 +
 drivers/net/ethernet/pensando/ionic/ionic_lif.c          | 1 +
 drivers/net/ethernet/pensando/ionic/ionic_stats.c        | 1 +
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c          | 1 +
 drivers/net/geneve.c                                     | 1 +
 drivers/net/hyperv/netvsc_drv.c                          | 1 +
 drivers/net/hyperv/rndis_filter.c                        | 1 +
 drivers/net/ipvlan/ipvlan_main.c                         | 2 ++
 drivers/net/nlmon.c                                      | 1 +
 drivers/net/team/team.c                                  | 1 +
 drivers/net/vrf.c                                        | 1 +
 drivers/net/vsockmon.c                                   | 1 +
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                        | 2 ++
 drivers/scsi/fcoe/fcoe_transport.c                       | 1 +
 drivers/staging/fsl-dpaa2/ethsw/ethsw-ethtool.c          | 2 ++
 drivers/staging/wimax/i2400m/usb.c                       | 1 +
 include/linux/netdevice.h                                | 2 +-
 include/linux/qed/qed_if.h                               | 1 +
 include/net/cfg80211.h                                   | 1 +
 include/rdma/ib_addr.h                                   | 1 +
 include/rdma/ib_verbs.h                                  | 1 +
 net/packet/af_packet.c                                   | 1 +
 net/sched/sch_cbs.c                                      | 1 +
 net/sched/sch_taprio.c                                   | 1 +
 net/socket.c                                             | 1 +
 44 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 85767f52fe3c..fdf87acccd06 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -11,6 +11,7 @@
 
 #include <linux/compiler.h>
 #include <linux/module.h>
+#include <linux/ethtool.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/major.h>
diff --git a/drivers/media/pci/ttpci/av7110_av.c b/drivers/media/pci/ttpci/av7110_av.c
index ea9f7d0058a2..91f4866c7e59 100644
--- a/drivers/media/pci/ttpci/av7110_av.c
+++ b/drivers/media/pci/ttpci/av7110_av.c
@@ -11,6 +11,7 @@
  * the project's page is at https://linuxtv.org
  */
 
+#include <linux/ethtool.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index fd5c9cbe45b1..56d34be5e797 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/proc_fs.h>
+#include <linux/ethtool.h>
 #include <linux/export.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 3005157059ca..853c7b22aaef 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -9,6 +9,7 @@
  * Many thanks to all socketcan devs!
  */
 
+#include <linux/ethtool.h>
 #include <linux/init.h>
 #include <linux/signal.h>
 #include <linux/module.h>
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 3b2cd28f962d..6cdd9efe8df3 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -3,6 +3,7 @@
  * Copyright 2015-2020 Amazon.com, Inc. or its affiliates. All rights reserved.
  */
 
+#include <linux/ethtool.h>
 #include <linux/pci.h>
 
 #include "ena_netdev.h"
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 926cca9a0c83..1a7148041e3d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -10,6 +10,8 @@
 #ifndef AQ_NIC_H
 #define AQ_NIC_H
 
+#include <linux/ethtool.h>
+
 #include "aq_common.h"
 #include "aq_rss.h"
 #include "aq_hw.h"
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 47b3c3127879..950ea26ae0d2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -20,6 +20,7 @@
 #define DRV_VER_MIN	10
 #define DRV_VER_UPD	1
 
+#include <linux/ethtool.h>
 #include <linux/interrupt.h>
 #include <linux/rhashtable.h>
 #include <linux/crash_dump.h>
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 23b80aa171dd..a217316228f4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -8,6 +8,7 @@
  * the Free Software Foundation.
  */
 
+#include <linux/ethtool.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
index 16eebfc52109..66f2c553370c 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
@@ -15,6 +15,7 @@
  * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, TITLE, or
  * NONINFRINGEMENT.  See the GNU General Public License for more details.
  ***********************************************************************/
+#include <linux/ethtool.h>
 #include <linux/netdevice.h>
 #include <linux/net_tstamp.h>
 #include <linux/pci.h>
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
index c7bdac79299a..2f218fbfed06 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
@@ -5,6 +5,7 @@
 
 /* ETHTOOL Support for VNIC_VF Device*/
 
+#include <linux/ethtool.h>
 #include <linux/pci.h>
 #include <linux/net_tstamp.h>
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 27308600da15..8e681ce72d62 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -39,6 +39,7 @@
 
 #include <linux/bitops.h>
 #include <linux/cache.h>
+#include <linux/ethtool.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
index cd8f9a481d73..d546993bda09 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
@@ -33,6 +33,7 @@
  * SOFTWARE.
  */
 
+#include <linux/ethtool.h>
 #include <linux/pci.h>
 
 #include "t4vf_common.h"
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 7b44769bd87c..2fb197fd3daf 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2015-2019 Google, Inc.
  */
 
+#include <linux/ethtool.h>
 #include <linux/rtnetlink.h>
 #include "gve.h"
 #include "gve_adminq.h"
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index f9d4d234a2af..8cb8f9eb354f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -25,6 +25,7 @@
 #include <linux/dcbnl.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/ethtool.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/pci.h>
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index 9c3cbe45c9ec..c9ae3d4dc547 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -8,6 +8,7 @@
 #define HINIC_PORT_H
 
 #include <linux/types.h>
+#include <linux/ethtool.h>
 #include <linux/etherdevice.h>
 #include <linux/bitops.h>
 
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
index 908fefaa6b85..66776ba7bfb6 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2019 Intel Corporation. */
 
+#include <linux/ethtool.h>
 #include <linux/vmalloc.h>
 
 #include "fm10k.h"
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index b18b45d02165..724040743a6d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -11,6 +11,7 @@
 #ifndef OTX2_COMMON_H
 #define OTX2_COMMON_H
 
+#include <linux/ethtool.h>
 #include <linux/pci.h>
 #include <linux/iommu.h>
 #include <linux/net_tstamp.h>
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index a46efe37cfa9..6e02910f7692 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -36,6 +36,7 @@
 
 #include <linux/bitops.h>
 #include <linux/compiler.h>
+#include <linux/ethtool.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 74b3959b36d4..642099fee380 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -4,6 +4,7 @@
 #ifndef _MLXSW_SPECTRUM_H
 #define _MLXSW_SPECTRUM_H
 
+#include <linux/ethtool.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/rhashtable.h>
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index 5023d91269f4..40e2e79d4517 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/ethtool.h>
 #include <linux/etherdevice.h>
 #include <linux/slab.h>
 #include <linux/device.h>
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index deabd813e3fe..0afec2fa572d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
 
+#include <linux/ethtool.h>
 #include <linux/printk.h>
 #include <linux/dynamic_debug.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index ff20a2ac4c2f..6ae75b771a15 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
 
+#include <linux/ethtool.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index d58b51d277f1..ca1535ebb6e7 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/etherdevice.h>
+#include <linux/ethtool.h>
 #include <linux/if_arp.h>
 #include <net/pkt_sched.h>
 #include "rmnet_config.h"
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index a3c8ce6deb93..26fd3ab54406 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -7,6 +7,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/ethtool.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 261e6e55a907..d17bbc75f5e7 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -10,6 +10,7 @@
 
 #include <linux/init.h>
 #include <linux/atomic.h>
+#include <linux/ethtool.h>
 #include <linux/module.h>
 #include <linux/highmem.h>
 #include <linux/device.h>
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index b22e47bcfeca..2c2b55c32a7a 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -6,6 +6,7 @@
  *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
+#include <linux/ethtool.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 60b7d93bb834..a707502a0c0f 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -2,6 +2,8 @@
 /* Copyright (c) 2014 Mahesh Bandewar <maheshb@google.com>
  */
 
+#include <linux/ethtool.h>
+
 #include "ipvlan.h"
 
 static int ipvlan_set_port_mode(struct ipvl_port *port, u16 nval,
diff --git a/drivers/net/nlmon.c b/drivers/net/nlmon.c
index afb119f38325..5e19a6839dea 100644
--- a/drivers/net/nlmon.c
+++ b/drivers/net/nlmon.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#include <linux/ethtool.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index b4092127a92c..c19dac21c468 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2011 Jiri Pirko <jpirko@redhat.com>
  */
 
+#include <linux/ethtool.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/module.h>
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index f2793ffde191..f8d711a84763 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -9,6 +9,7 @@
  * Based on dummy, team and ipvlan drivers
  */
 
+#include <linux/ethtool.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/vsockmon.c b/drivers/net/vsockmon.c
index e8563acf98e8..b1bb1b04b664 100644
--- a/drivers/net/vsockmon.c
+++ b/drivers/net/vsockmon.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#include <linux/ethtool.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/if_arp.h>
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 6890bbe04a8c..1528ef69a514 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -14,6 +14,8 @@
  * Written by: Bhanu Prakash Gollapudi (bprakash@broadcom.com)
  */
 
+#include <linux/ethtool.h>
+
 #include "bnx2fc.h"
 
 static struct list_head adapter_list;
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 6e187d0e71fd..b927b3d84523 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
+#include <linux/ethtool.h>
 #include <linux/errno.h>
 #include <linux/crc32.h>
 #include <scsi/libfcoe.h>
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw-ethtool.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw-ethtool.c
index ace4a6d28562..ad55cd738847 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw-ethtool.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw-ethtool.c
@@ -7,6 +7,8 @@
  *
  */
 
+#include <linux/ethtool.h>
+
 #include "ethsw.h"
 
 static struct {
diff --git a/drivers/staging/wimax/i2400m/usb.c b/drivers/staging/wimax/i2400m/usb.c
index 3b84dd7b5567..f250d03ce7c7 100644
--- a/drivers/staging/wimax/i2400m/usb.c
+++ b/drivers/staging/wimax/i2400m/usb.c
@@ -51,6 +51,7 @@
 #include "i2400m-usb.h"
 #include "linux-wimax-i2400m.h"
 #include <linux/debugfs.h>
+#include <linux/ethtool.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 03433a4c929e..0049e8fe4905 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -34,7 +34,6 @@
 #include <linux/workqueue.h>
 #include <linux/dynamic_queue_limits.h>
 
-#include <linux/ethtool.h>
 #include <net/net_namespace.h>
 #ifdef CONFIG_DCB
 #include <net/dcbnl.h>
@@ -51,6 +50,7 @@
 
 struct netpoll_info;
 struct device;
+struct ethtool_ops;
 struct phy_device;
 struct dsa_port;
 struct ip_tunnel_parm;
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 57fb295ea41a..68d17a4fbf20 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -7,6 +7,7 @@
 #ifndef _QED_IF_H
 #define _QED_IF_H
 
+#include <linux/ethtool.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ab249ca5d5d1..78c763dfc99a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -10,6 +10,7 @@
  * Copyright (C) 2018-2020 Intel Corporation
  */
 
+#include <linux/ethtool.h>
 #include <linux/netdevice.h>
 #include <linux/debugfs.h>
 #include <linux/list.h>
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index b0e636ac6690..d808dc3d239e 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -7,6 +7,7 @@
 #ifndef IB_ADDR_H
 #define IB_ADDR_H
 
+#include <linux/ethtool.h>
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <linux/if_arp.h>
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 9bf6c319a670..3883efd588aa 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -12,6 +12,7 @@
 #ifndef IB_VERBS_H
 #define IB_VERBS_H
 
+#include <linux/ethtool.h>
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 62ebfaa7adcb..48a0ed836b46 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -46,6 +46,7 @@
  *					Copyright (C) 2011, <lokec@ccs.neu.edu>
  */
 
+#include <linux/ethtool.h>
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/capability.h>
diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index 2eaac2ff380f..459cc240eda9 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -50,6 +50,7 @@
  *	locredit = max_frame_size * (sendslope / port_transmit_rate)
  */
 
+#include <linux/ethtool.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index b0ad7687ee2c..26fb8a62996b 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -6,6 +6,7 @@
  *
  */
 
+#include <linux/ethtool.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
diff --git a/net/socket.c b/net/socket.c
index 152b1dcf93c6..bfef11ba35b8 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -52,6 +52,7 @@
  *	Based upon Swansea University Computer Society NET3.039
  */
 
+#include <linux/ethtool.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
 #include <linux/file.h>
-- 
2.24.1

