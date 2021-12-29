Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38295480E5E
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 01:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238083AbhL2AtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 19:49:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33882 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbhL2AtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 19:49:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0B1F6116C;
        Wed, 29 Dec 2021 00:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D64DC36AEB;
        Wed, 29 Dec 2021 00:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640738959;
        bh=Dhya06A0fsx6OYnJ8Pjm6y+72X0rTVqijoy15oG2628=;
        h=From:To:Cc:Subject:Date:From;
        b=Dch51jiREzZYD523mD7zioHHOComr1ilsab6W7ZGkrFBwWG0AuJoH5Jc+5mSAZ3bf
         9F6WwefnUarYiyfh8KnJSfn1SiHhDiy6Wf+kyGfNREEbhQUVbg7QoNd3JOHs1NsF95
         BB7jmzOeGW1P6hCtZ8qj4BZA3YyljGiG9kMBYfuvDoeEK2LZZpErMnraqhKqYPvzPx
         tmx3FO6askTKzUqfZzrqadeuupl/hkduOGCOUWK2d3Sto2/QLPrZ8VYlxlx4ykGi7p
         BK4gSMUwI5tnThp1QBt7wlffSUIy1ufVXFFokrYblqtBv+bvmLyVWRU6DhRX1mn6Bh
         iXWWVXMXEp0mg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, dledford@redhat.com,
        jgg@ziepe.ca, mustafa.ismail@intel.com, shiraz.saleem@intel.com,
        leon@kernel.org, ap420073@gmail.com, wg@grandegger.com,
        woojung.huh@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        george.mccollister@gmail.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        hawk@kernel.org, john.fastabend@gmail.com, tariqt@nvidia.com,
        saeedm@nvidia.com, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, jreuter@yaina.de, dsahern@kernel.org,
        kvalo@codeaurora.org, pkshih@realtek.com,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        viro@zeniv.linux.org.uk, andrii@kernel.org, mcgrof@kernel.org,
        keescook@chromium.org, yzaikin@google.com, nikolay@nvidia.com,
        jiri@nvidia.com, wintera@linux.ibm.com, wenjia@linux.ibm.com,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        ralf@linux-mips.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kgraul@linux.ibm.com, sgarzare@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        arnd@arndb.de, linux-bluetooth@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-can@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-hams@vger.kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-s390@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, virtualization@lists.linux-foundation.org
Subject: [PATCH bpf-next v2] net: don't include filter.h from net/sock.h
Date:   Tue, 28 Dec 2021 16:49:13 -0800
Message-Id: <20211229004913.513372-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock.h is pretty heavily used (5k objects rebuilt on x86 after
it's touched). We can drop the include of filter.h from it and
add a forward declaration of struct sk_filter instead.
This decreases the number of rebuilt objects when bpf.h
is touched from ~5k to ~1k.

There's a lot of missing includes this was masking. Primarily
in networking tho, this time.

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2: https://lore.kernel.org/all/20211228192519.386913-1-kuba@kernel.org/
 - fix build in bond on ia64
 - fix build in ip6_fib with randconfig

CC: marcel@holtmann.org
CC: johan.hedberg@gmail.com
CC: luiz.dentz@gmail.com
CC: dledford@redhat.com
CC: jgg@ziepe.ca
CC: mustafa.ismail@intel.com
CC: shiraz.saleem@intel.com
CC: leon@kernel.org
CC: ap420073@gmail.com
CC: wg@grandegger.com
CC: woojung.huh@microchip.com
CC: andrew@lunn.ch
CC: vivien.didelot@gmail.com
CC: f.fainelli@gmail.com
CC: olteanv@gmail.com
CC: george.mccollister@gmail.com
CC: michael.chan@broadcom.com
CC: jesse.brandeburg@intel.com
CC: anthony.l.nguyen@intel.com
CC: ast@kernel.org
CC: daniel@iogearbox.net
CC: hawk@kernel.org
CC: john.fastabend@gmail.com
CC: tariqt@nvidia.com
CC: saeedm@nvidia.com
CC: ecree.xilinx@gmail.com
CC: habetsm.xilinx@gmail.com
CC: jreuter@yaina.de
CC: dsahern@kernel.org
CC: kvalo@codeaurora.org
CC: pkshih@realtek.com
CC: trond.myklebust@hammerspace.com
CC: anna.schumaker@netapp.com
CC: viro@zeniv.linux.org.uk
CC: andrii@kernel.org
CC: mcgrof@kernel.org
CC: keescook@chromium.org
CC: yzaikin@google.com
CC: nikolay@nvidia.com
CC: jiri@nvidia.com
CC: wintera@linux.ibm.com
CC: wenjia@linux.ibm.com
CC: pablo@netfilter.org
CC: kadlec@netfilter.org
CC: fw@strlen.de
CC: ralf@linux-mips.org
CC: jhs@mojatatu.com
CC: xiyou.wangcong@gmail.com
CC: kgraul@linux.ibm.com
CC: sgarzare@redhat.com
CC: steffen.klassert@secunet.com
CC: herbert@gondor.apana.org.au
CC: arnd@arndb.de
CC: linux-bluetooth@vger.kernel.org
CC: linux-rdma@vger.kernel.org
CC: linux-can@vger.kernel.org
CC: intel-wired-lan@lists.osuosl.org
CC: bpf@vger.kernel.org
CC: linux-hams@vger.kernel.org
CC: ath11k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
CC: linux-nfs@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
CC: bridge@lists.linux-foundation.org
CC: linux-decnet-user@lists.sourceforge.net
CC: linux-s390@vger.kernel.org
CC: netfilter-devel@vger.kernel.org
CC: coreteam@netfilter.org
CC: virtualization@lists.linux-foundation.org
---
 drivers/bluetooth/btqca.c                         | 1 +
 drivers/infiniband/core/cache.c                   | 1 +
 drivers/infiniband/hw/irdma/ctrl.c                | 2 ++
 drivers/infiniband/hw/irdma/uda.c                 | 2 ++
 drivers/infiniband/hw/mlx5/doorbell.c             | 1 +
 drivers/infiniband/hw/mlx5/qp.c                   | 1 +
 drivers/net/amt.c                                 | 1 +
 drivers/net/appletalk/ipddp.c                     | 1 +
 drivers/net/bonding/bond_main.c                   | 1 +
 drivers/net/can/usb/peak_usb/pcan_usb.c           | 1 +
 drivers/net/dsa/microchip/ksz8795.c               | 1 +
 drivers/net/dsa/xrs700x/xrs700x.c                 | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 1 +
 drivers/net/ethernet/huawei/hinic/hinic_tx.c      | 1 +
 drivers/net/ethernet/intel/ice/ice_devlink.c      | 2 ++
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c     | 2 ++
 drivers/net/ethernet/intel/igc/igc_xdp.c          | 1 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c    | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c  | 1 +
 drivers/net/ethernet/sfc/efx.c                    | 1 +
 drivers/net/ethernet/sfc/efx_channels.c           | 1 +
 drivers/net/ethernet/sfc/efx_common.c             | 1 +
 drivers/net/hamradio/hdlcdrv.c                    | 1 +
 drivers/net/hamradio/scc.c                        | 1 +
 drivers/net/loopback.c                            | 1 +
 drivers/net/vrf.c                                 | 1 +
 drivers/net/wireless/ath/ath11k/debugfs.c         | 2 ++
 drivers/net/wireless/realtek/rtw89/debug.c        | 2 ++
 fs/nfs/dir.c                                      | 1 +
 fs/nfs/fs_context.c                               | 1 +
 fs/select.c                                       | 1 +
 include/linux/bpf_local_storage.h                 | 1 +
 include/linux/dsa/loop.h                          | 1 +
 include/net/ipv6.h                                | 2 ++
 include/net/route.h                               | 1 +
 include/net/sock.h                                | 2 +-
 include/net/xdp_sock.h                            | 1 +
 kernel/sysctl.c                                   | 1 +
 net/bluetooth/bnep/sock.c                         | 1 +
 net/bluetooth/eir.h                               | 2 ++
 net/bluetooth/hidp/sock.c                         | 1 +
 net/bluetooth/l2cap_sock.c                        | 1 +
 net/bridge/br_ioctl.c                             | 1 +
 net/caif/caif_socket.c                            | 1 +
 net/core/devlink.c                                | 1 +
 net/core/flow_dissector.c                         | 1 +
 net/core/lwt_bpf.c                                | 1 +
 net/core/sock_diag.c                              | 1 +
 net/core/sysctl_net_core.c                        | 1 +
 net/decnet/dn_nsp_in.c                            | 1 +
 net/dsa/dsa_priv.h                                | 1 +
 net/ethtool/ioctl.c                               | 1 +
 net/ipv4/nexthop.c                                | 1 +
 net/ipv6/ip6_fib.c                                | 1 +
 net/ipv6/seg6_local.c                             | 1 +
 net/iucv/af_iucv.c                                | 1 +
 net/kcm/kcmsock.c                                 | 1 +
 net/netfilter/nfnetlink_hook.c                    | 1 +
 net/netfilter/nft_reject_netdev.c                 | 1 +
 net/netlink/af_netlink.c                          | 2 ++
 net/packet/af_packet.c                            | 1 +
 net/rose/rose_in.c                                | 1 +
 net/sched/sch_frag.c                              | 1 +
 net/smc/smc_ib.c                                  | 2 ++
 net/smc/smc_ism.c                                 | 1 +
 net/unix/af_unix.c                                | 1 +
 net/vmw_vsock/af_vsock.c                          | 1 +
 net/xdp/xskmap.c                                  | 1 +
 net/xfrm/xfrm_state.c                             | 1 +
 net/xfrm/xfrm_user.c                              | 1 +
 70 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index be04d74037d2..f7bf311d7910 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -6,6 +6,7 @@
  */
 #include <linux/module.h>
 #include <linux/firmware.h>
+#include <linux/vmalloc.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 0c98dd3dee67..b79f816a7203 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -33,6 +33,7 @@
  * SOFTWARE.
  */
 
+#include <linux/if_vlan.h>
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index 7264f8c2f7d5..3141a9c85de5 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
 /* Copyright (c) 2015 - 2021 Intel Corporation */
+#include <linux/etherdevice.h>
+
 #include "osdep.h"
 #include "status.h"
 #include "hmc.h"
diff --git a/drivers/infiniband/hw/irdma/uda.c b/drivers/infiniband/hw/irdma/uda.c
index f5b1b6150cdc..7a9988ddbd01 100644
--- a/drivers/infiniband/hw/irdma/uda.c
+++ b/drivers/infiniband/hw/irdma/uda.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
 /* Copyright (c) 2016 - 2021 Intel Corporation */
+#include <linux/etherdevice.h>
+
 #include "osdep.h"
 #include "status.h"
 #include "hmc.h"
diff --git a/drivers/infiniband/hw/mlx5/doorbell.c b/drivers/infiniband/hw/mlx5/doorbell.c
index 6398e2f48579..e32111117a5e 100644
--- a/drivers/infiniband/hw/mlx5/doorbell.c
+++ b/drivers/infiniband/hw/mlx5/doorbell.c
@@ -32,6 +32,7 @@
 
 #include <linux/kref.h>
 #include <linux/slab.h>
+#include <linux/sched/mm.h>
 #include <rdma/ib_umem.h>
 
 #include "mlx5_ib.h"
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e5abbcfc1d57..29475cf8c7c3 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -30,6 +30,7 @@
  * SOFTWARE.
  */
 
+#include <linux/etherdevice.h>
 #include <linux/module.h>
 #include <rdma/ib_umem.h>
 #include <rdma/ib_cache.h>
diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index b732ee9a50ef..a1c7a8acd9c8 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -11,6 +11,7 @@
 #include <linux/net.h>
 #include <linux/igmp.h>
 #include <linux/workqueue.h>
+#include <net/sch_generic.h>
 #include <net/net_namespace.h>
 #include <net/ip.h>
 #include <net/udp.h>
diff --git a/drivers/net/appletalk/ipddp.c b/drivers/net/appletalk/ipddp.c
index 5566daefbff4..d558535390f9 100644
--- a/drivers/net/appletalk/ipddp.c
+++ b/drivers/net/appletalk/ipddp.c
@@ -23,6 +23,7 @@
  *      of the GNU General Public License, incorporated herein by reference.
  */
 
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0f39ad2af81c..d483f1102a9e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
+#include <linux/filter.h>
 #include <linux/interrupt.h>
 #include <linux/ptrace.h>
 #include <linux/ioport.h>
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 876218752766..ac6772fe9746 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -8,6 +8,7 @@
  *
  * Many thanks to Klaus Hitschler <klaus.hitschler@gmx.de>
  */
+#include <asm/unaligned.h>
 #include <linux/netdevice.h>
 #include <linux/usb.h>
 #include <linux/module.h>
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 013e9c02be71..991b9c6b6ce7 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -10,6 +10,7 @@
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/gpio.h>
+#include <linux/if_vlan.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_data/microchip-ksz.h>
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 35fa19ddaf19..0730352cdd57 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -5,6 +5,7 @@
  */
 
 #include <net/dsa.h>
+#include <linux/etherdevice.h>
 #include <linux/if_bridge.h>
 #include <linux/of_device.h>
 #include <linux/netdev_features.h>
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 951c4c569a9b..4da31b1b84f9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -9,6 +9,7 @@
 
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/vmalloc.h>
 #include <net/devlink.h>
 #include "bnxt_hsi.h"
 #include "bnxt.h"
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index a984a7a6dd2e..8d59babbf476 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -4,6 +4,7 @@
  * Copyright(c) 2017 Huawei Technologies Co., Ltd
  */
 
+#include <linux/if_vlan.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <linux/u64_stats_sync.h>
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 1cfe918db8b9..716ec8616ff0 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020, Intel Corporation. */
 
+#include <linux/vmalloc.h>
+
 #include "ice.h"
 #include "ice_lib.h"
 #include "ice_devlink.h"
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 1dd7e84f41f8..9520b140bdbf 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019, Intel Corporation. */
 
+#include <linux/filter.h>
+
 #include "ice_txrx_lib.h"
 #include "ice_eswitch.h"
 #include "ice_lib.h"
diff --git a/drivers/net/ethernet/intel/igc/igc_xdp.c b/drivers/net/ethernet/intel/igc/igc_xdp.c
index a8cf5374be47..aeeb34e64610 100644
--- a/drivers/net/ethernet/intel/igc/igc_xdp.c
+++ b/drivers/net/ethernet/intel/igc/igc_xdp.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020, Intel Corporation. */
 
+#include <linux/if_vlan.h>
 #include <net/xdp_sock_drv.h>
 
 #include "igc.h"
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index f1c10f2bda78..40acfe12adc9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -33,6 +33,7 @@
 
 #include <linux/bpf.h>
 #include <linux/etherdevice.h>
+#include <linux/filter.h>
 #include <linux/tcp.h>
 #include <linux/if_vlan.h>
 #include <linux/delay.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 50977f01a050..00449df98a5e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
+#include <net/sch_generic.h>
 
 #include "en.h"
 #include "params.h"
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index a8c252e2b252..302dc835ac3d 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -5,6 +5,7 @@
  * Copyright 2005-2013 Solarflare Communications Inc.
  */
 
+#include <linux/filter.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 3dbea028b325..b015d1f2e204 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -10,6 +10,7 @@
 
 #include "net_driver.h"
 #include <linux/module.h>
+#include <linux/filter.h>
 #include "efx_channels.h"
 #include "efx.h"
 #include "efx_common.h"
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index f187631b2c5c..af37c990217e 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -9,6 +9,7 @@
  */
 
 #include "net_driver.h"
+#include <linux/filter.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <net/gre.h>
diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index b0edb91bb10a..8297411e87ea 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -30,6 +30,7 @@
 /*****************************************************************************/
 
 #include <linux/capability.h>
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/net.h>
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index 3d59dac063ac..f90830d3dfa6 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -148,6 +148,7 @@
 
 /* ----------------------------------------------------------------------- */
 
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index a1c77cc00416..ed0edf5884ef 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -44,6 +44,7 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
+#include <net/sch_generic.h>
 #include <net/sock.h>
 #include <net/checksum.h>
 #include <linux/if_ether.h>	/* For the statistics structure. */
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index b4c64226b7ca..e0b1ab99a359 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -34,6 +34,7 @@
 #include <net/addrconf.h>
 #include <net/l3mdev.h>
 #include <net/fib_rules.h>
+#include <net/sch_generic.h>
 #include <net/netns/generic.h>
 #include <net/netfilter/nf_conntrack.h>
 
diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index dba055d085be..eb8b4f20c95e 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -3,6 +3,8 @@
  * Copyright (c) 2018-2020 The Linux Foundation. All rights reserved.
  */
 
+#include <linux/vmalloc.h>
+
 #include "debugfs.h"
 
 #include "core.h"
diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index 1e85808aaf4b..be761157ea22 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -2,6 +2,8 @@
 /* Copyright(c) 2019-2020  Realtek Corporation
  */
 
+#include <linux/vmalloc.h>
+
 #include "coex.h"
 #include "debug.h"
 #include "fw.h"
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 731d31015b6a..347793626f19 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -18,6 +18,7 @@
  *  6 Jun 1999	Cache readdir lookups in the page cache. -DaveM
  */
 
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/errno.h>
diff --git a/fs/nfs/fs_context.c b/fs/nfs/fs_context.c
index 0d444a90f513..ea17fa1f31ec 100644
--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -10,6 +10,7 @@
  * Split from fs/nfs/super.c by David Howells <dhowells@redhat.com>
  */
 
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
diff --git a/fs/select.c b/fs/select.c
index 945896d0ac9e..02cd8cb5e69f 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -15,6 +15,7 @@
  *     of fds to overcome nfds < 16390 descriptors limit (Tigran Aivazian).
  */
 
+#include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/rt.h>
diff --git a/include/linux/bpf_local_storage.h b/include/linux/bpf_local_storage.h
index 24496bc28e7b..a2b625960ffe 100644
--- a/include/linux/bpf_local_storage.h
+++ b/include/linux/bpf_local_storage.h
@@ -8,6 +8,7 @@
 #define _BPF_LOCAL_STORAGE_H
 
 #include <linux/bpf.h>
+#include <linux/filter.h>
 #include <linux/rculist.h>
 #include <linux/list.h>
 #include <linux/hash.h>
diff --git a/include/linux/dsa/loop.h b/include/linux/dsa/loop.h
index 5a3470bcc8a7..b8fef35591aa 100644
--- a/include/linux/dsa/loop.h
+++ b/include/linux/dsa/loop.h
@@ -2,6 +2,7 @@
 #ifndef DSA_LOOP_H
 #define DSA_LOOP_H
 
+#include <linux/if_vlan.h>
 #include <linux/types.h>
 #include <linux/ethtool.h>
 #include <net/dsa.h>
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 53ac7707ca70..3afcb128e064 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -21,6 +21,8 @@
 #include <net/snmp.h>
 #include <net/netns/hash.h>
 
+struct ip_tunnel_info;
+
 #define SIN6_LEN_RFC2133	24
 
 #define IPV6_MAXPLEN		65535
diff --git a/include/net/route.h b/include/net/route.h
index 2e6c0e153e3a..4c858dcf1aa8 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -43,6 +43,7 @@
 #define RT_CONN_FLAGS(sk)   (RT_TOS(inet_sk(sk)->tos) | sock_flag(sk, SOCK_LOCALROUTE))
 #define RT_CONN_FLAGS_TOS(sk,tos)   (RT_TOS(tos) | sock_flag(sk, SOCK_LOCALROUTE))
 
+struct ip_tunnel_info;
 struct fib_nh;
 struct fib_info;
 struct uncached_list;
diff --git a/include/net/sock.h b/include/net/sock.h
index 37f878564d25..40f6406b9ca5 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -56,7 +56,6 @@
 #include <linux/wait.h>
 #include <linux/cgroup-defs.h>
 #include <linux/rbtree.h>
-#include <linux/filter.h>
 #include <linux/rculist_nulls.h>
 #include <linux/poll.h>
 #include <linux/sockptr.h>
@@ -249,6 +248,7 @@ struct sock_common {
 };
 
 struct bpf_local_storage;
+struct sk_filter;
 
 /**
   *	struct sock - network layer representation of sockets
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index fff069d2ed1b..3057e1a4a11c 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -6,6 +6,7 @@
 #ifndef _LINUX_XDP_SOCK_H
 #define _LINUX_XDP_SOCK_H
 
+#include <linux/bpf.h>
 #include <linux/workqueue.h>
 #include <linux/if_xdp.h>
 #include <linux/mutex.h>
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 083be6af29d7..d7ed1dffa426 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -33,6 +33,7 @@
 #include <linux/security.h>
 #include <linux/ctype.h>
 #include <linux/kmemleak.h>
+#include <linux/filter.h>
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/net/bluetooth/bnep/sock.c b/net/bluetooth/bnep/sock.c
index d515571b2afb..57d509d77cb4 100644
--- a/net/bluetooth/bnep/sock.c
+++ b/net/bluetooth/bnep/sock.c
@@ -24,6 +24,7 @@
    SOFTWARE IS DISCLAIMED.
 */
 
+#include <linux/compat.h>
 #include <linux/export.h>
 #include <linux/file.h>
 
diff --git a/net/bluetooth/eir.h b/net/bluetooth/eir.h
index 724662f8f8b1..05e2e917fc25 100644
--- a/net/bluetooth/eir.h
+++ b/net/bluetooth/eir.h
@@ -5,6 +5,8 @@
  * Copyright (C) 2021 Intel Corporation
  */
 
+#include <asm/unaligned.h>
+
 void eir_create(struct hci_dev *hdev, u8 *data);
 
 u8 eir_create_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr);
diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
index 595fb3c9d6c3..369ed92dac99 100644
--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -20,6 +20,7 @@
    SOFTWARE IS DISCLAIMED.
 */
 
+#include <linux/compat.h>
 #include <linux/export.h>
 #include <linux/file.h>
 
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 4574c5cb1b59..dc50737b785b 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -29,6 +29,7 @@
 
 #include <linux/module.h>
 #include <linux/export.h>
+#include <linux/filter.h>
 #include <linux/sched/signal.h>
 
 #include <net/bluetooth/bluetooth.h>
diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
index db4ab2c2ce18..9b54d7d0bfc4 100644
--- a/net/bridge/br_ioctl.c
+++ b/net/bridge/br_ioctl.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/capability.h>
+#include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/if_bridge.h>
 #include <linux/netdevice.h>
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index e12fd3cad619..2b8892d502f7 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -6,6 +6,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s(): " fmt, __func__
 
+#include <linux/filter.h>
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0a9349a02cad..492a26d3c3f1 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7,6 +7,7 @@
  * Copyright (c) 2016 Jiri Pirko <jiri@mellanox.com>
  */
 
+#include <linux/etherdevice.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 257976cb55ce..de1109f2cfcf 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -5,6 +5,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/if_vlan.h>
+#include <linux/filter.h>
 #include <net/dsa.h>
 #include <net/dst_metadata.h>
 #include <net/ip.h>
diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 2f7940bcf715..349480ef68a5 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2016 Thomas Graf <tgraf@tgraf.ch>
  */
 
+#include <linux/filter.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index c9c45b935f99..f7cf74cdd3db 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -1,5 +1,6 @@
 /* License: GPL */
 
+#include <linux/filter.h>
 #include <linux/mutex.h>
 #include <linux/socket.h>
 #include <linux/skbuff.h>
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 5f88526ad61c..7b4d485aac7a 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -6,6 +6,7 @@
  * Added /proc/sys/net/core directory entry (empty =) ). [MS]
  */
 
+#include <linux/filter.h>
 #include <linux/mm.h>
 #include <linux/sysctl.h>
 #include <linux/module.h>
diff --git a/net/decnet/dn_nsp_in.c b/net/decnet/dn_nsp_in.c
index 7ab788f41a3f..c59be5b04479 100644
--- a/net/decnet/dn_nsp_in.c
+++ b/net/decnet/dn_nsp_in.c
@@ -38,6 +38,7 @@
 *******************************************************************************/
 
 #include <linux/errno.h>
+#include <linux/filter.h>
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/in.h>
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 38ce5129a33d..0194a969c9b5 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -8,6 +8,7 @@
 #define __DSA_PRIV_H
 
 #include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
 #include <linux/phy.h>
 #include <linux/netdevice.h>
 #include <linux/netpoll.h>
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 9a113d893521..b2cdba1b4aae 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/compat.h>
+#include <linux/etherdevice.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/capability.h>
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 1319d093cdda..eeafeccebb8d 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -8,6 +8,7 @@
 #include <linux/nexthop.h>
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
 #include <net/arp.h>
 #include <net/ipv6_stubs.h>
 #include <net/lwtunnel.h>
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 0371d2c14145..463c37dea449 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -15,6 +15,7 @@
 
 #define pr_fmt(fmt) "IPv6: " fmt
 
+#include <linux/bpf.h>
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/net.h>
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 2dc40b3f373e..a5eea182149d 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -7,6 +7,7 @@
  *  eBPF support: Mathieu Xhonneux <m.xhonneux@gmail.com>
  */
 
+#include <linux/filter.h>
 #include <linux/types.h>
 #include <linux/skbuff.h>
 #include <linux/net.h>
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 49ecbe8d176a..a1760add5bf1 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -13,6 +13,7 @@
 #define KMSG_COMPONENT "af_iucv"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
+#include <linux/filter.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/types.h>
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 11a715d76a4f..71899e5a5a11 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -9,6 +9,7 @@
 #include <linux/errno.h>
 #include <linux/errqueue.h>
 #include <linux/file.h>
+#include <linux/filter.h>
 #include <linux/in.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index d5c719c9e36c..71e29adac48b 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/kallsyms.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/skbuff.h>
diff --git a/net/netfilter/nft_reject_netdev.c b/net/netfilter/nft_reject_netdev.c
index d89f68754f42..61cd8c4ac385 100644
--- a/net/netfilter/nft_reject_netdev.c
+++ b/net/netfilter/nft_reject_netdev.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2020 Jose M. Guisado <guigom@riseup.net>
  */
 
+#include <linux/etherdevice.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 4be2d97ff93e..7b344035bfe3 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -20,8 +20,10 @@
 
 #include <linux/module.h>
 
+#include <linux/bpf.h>
 #include <linux/capability.h>
 #include <linux/kernel.h>
+#include <linux/filter.h>
 #include <linux/init.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index a1ffdb48cc47..3ca4f890371a 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -49,6 +49,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/ethtool.h>
+#include <linux/filter.h>
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/capability.h>
diff --git a/net/rose/rose_in.c b/net/rose/rose_in.c
index 6af786d66b03..4d67f36dce1b 100644
--- a/net/rose/rose_in.c
+++ b/net/rose/rose_in.c
@@ -9,6 +9,7 @@
  * diagrams as the code is not obvious and probably very easy to break.
  */
 #include <linux/errno.h>
+#include <linux/filter.h>
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/in.h>
diff --git a/net/sched/sch_frag.c b/net/sched/sch_frag.c
index 8c06381391d6..cd85a69820b1 100644
--- a/net/sched/sch_frag.c
+++ b/net/sched/sch_frag.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+#include <linux/if_vlan.h>
 #include <net/netlink.h>
 #include <net/sch_generic.h>
 #include <net/dst.h>
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index d93055ec17ae..905604c378ad 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -12,6 +12,8 @@
  *  Author(s):  Ursula Braun <ubraun@linux.vnet.ibm.com>
  */
 
+#include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
 #include <linux/random.h>
 #include <linux/workqueue.h>
 #include <linux/scatterlist.h>
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index fd28cc498b98..a2084ecdb97e 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -6,6 +6,7 @@
  * Copyright IBM Corp. 2018
  */
 
+#include <linux/if_vlan.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 4d6e33bbd446..c19569819866 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -89,6 +89,7 @@
 #include <linux/socket.h>
 #include <linux/un.h>
 #include <linux/fcntl.h>
+#include <linux/filter.h>
 #include <linux/termios.h>
 #include <linux/sockios.h>
 #include <linux/net.h>
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ed0df839c38c..3235261f138d 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -85,6 +85,7 @@
  *   TCP_LISTEN - listening
  */
 
+#include <linux/compat.h>
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/cred.h>
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 2e48d0e094d9..65b53fb3de13 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/bpf.h>
+#include <linux/filter.h>
 #include <linux/capability.h>
 #include <net/xdp_sock.h>
 #include <linux/slab.h>
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index a2f4001221d1..0407272a990c 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -14,6 +14,7 @@
  *
  */
 
+#include <linux/compat.h>
 #include <linux/workqueue.h>
 #include <net/xfrm.h>
 #include <linux/pfkeyv2.h>
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 7c36cc1f3d79..e3e26f4da6c2 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -11,6 +11,7 @@
  *
  */
 
+#include <linux/compat.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-- 
2.31.1

