Return-Path: <netdev+bounces-6458-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B954B716629
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:06:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 593121C20CCF
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA422271F0;
	Tue, 30 May 2023 15:04:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83DA17AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:04:42 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F53F0;
	Tue, 30 May 2023 08:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685459071; x=1716995071;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SAfuq5omA5qC5ERwyk1Qe81dMmdwFwVQv0ntwrSrLvQ=;
  b=fT1bQwJ9wp7yR0Cluu/BY94ldR7uq4/UYmmjG7jrpFShO1j2QuJcUxEJ
   yiLR0HdwK+oRQ8Lfw6uKK2nI/2LHgcV47UKGhYNFEsAyzCN0nLmK8115k
   /JzYjEXjSAvVBEcdjtuW9l0Zm0iaCeiWOjd9mjQV21DzVFPI5fIn2SdmR
   lIkNL+RvrZnZgiiBFJiQMX7kYiFgcTnd1cw2HG9z/D6geKhQgL0/5T7Se
   zJXPYDZuLH3WydQ24PKDZ1ATML1pBbX3JQS0Qd8UGdNlM2ZfowQwM2gXk
   XsPfF87oSbmRRS+eWORuiZ4RQe06yVGrh6vUwGnagn+ldPDX7+REA6qwf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="358192477"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="358192477"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 08:03:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="796304166"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="796304166"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by FMSMGA003.fm.intel.com with ESMTP; 30 May 2023 08:03:27 -0700
From: Alexander Lobakin <aleksander.lobakin@intel.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Alexander Lobakin <aleksander.lobakin@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Christoph Hellwig <hch@lst.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 06/12] net: skbuff: don't include <net/page_pool.h> into <linux/skbuff.h>
Date: Tue, 30 May 2023 17:00:29 +0200
Message-Id: <20230530150035.1943669-7-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530150035.1943669-1-aleksander.lobakin@intel.com>
References: <20230530150035.1943669-1-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently, touching <net/page_pool.h> triggers a rebuild of more than
a half of the kernel. That's because it's included in <linux/skbuff.h>.

In 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling"),
Matteo included it to be able to call a couple functions defined there.
Then, in 57f05bc2ab24 ("page_pool: keep pp info as long as page pool
owns the page") one of the calls was removed, so only one left.
It's call to page_pool_return_skb_page() in napi_frag_unref(). The
function is external and doesn't have any dependencies. Having include
of very niche page_pool.h only for that looks like an overkill.
Instead, move the declaration of that function to skbuff.h itself, with
a small comment that it's a special guest and should not be touched.
Now, after a few include fixes in the drivers, touching page_pool.h
only triggers rebuilding of the drivers using it and a couple core
networking files.

Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c               | 1 +
 drivers/net/ethernet/freescale/fec_main.c                | 1 +
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 1 +
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c     | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c      | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c         | 1 +
 drivers/net/wireless/mediatek/mt76/mt76.h                | 1 +
 include/linux/skbuff.h                                   | 4 +++-
 include/net/page_pool.h                                  | 2 --
 9 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 84751bb303a6..6222aaa5157f 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -28,6 +28,7 @@
 #include <linux/iopoll.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <net/page_pool.h>
 #include <net/xdp_sock_drv.h>
 
 #define TSNEP_RX_OFFSET (max(NET_SKB_PAD, XDP_PACKET_HEADROOM) + NET_IP_ALIGN)
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 632bb4d589d7..0731af62d7dd 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -38,6 +38,7 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <net/ip.h>
+#include <net/page_pool.h>
 #include <net/selftests.h>
 #include <net/tso.h>
 #include <linux/tcp.h>
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index a79cb680bb23..22cb3973f977 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -7,6 +7,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/pci.h>
+#include <net/page_pool.h>
 #include <net/tso.h>
 
 #include "otx2_reg.h"
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index db3fcab1c8cd..93f0c8e3ce91 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -16,6 +16,7 @@
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
 #include <linux/bitfield.h>
+#include <net/page_pool.h>
 
 #include "otx2_reg.h"
 #include "otx2_common.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 9c94807097cb..3235a3a4ed08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -6,6 +6,7 @@
 #include "en/port.h"
 #include "en_accel/en_accel.h"
 #include "en_accel/ipsec.h"
+#include <net/page_pool.h>
 #include <net/xdp_sock_drv.h>
 
 static u8 mlx5e_mpwrq_min_page_shift(struct mlx5_core_dev *mdev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index f0e6095809fa..1bd91bc09eb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -35,6 +35,7 @@
 #include "en/xdp.h"
 #include "en/params.h"
 #include <linux/bitfield.h>
+#include <net/page_pool.h>
 
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 6b07b8fafec2..95c16f11d156 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -15,6 +15,7 @@
 #include <linux/average.h>
 #include <linux/soc/mediatek/mtk_wed.h>
 #include <net/mac80211.h>
+#include <net/page_pool.h>
 #include "util.h"
 #include "testmode.h"
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5951904413ab..6d5eee932b95 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -32,7 +32,6 @@
 #include <linux/if_packet.h>
 #include <linux/llist.h>
 #include <net/flow.h>
-#include <net/page_pool.h>
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <linux/netfilter/nf_conntrack_common.h>
 #endif
@@ -3422,6 +3421,9 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
 	__skb_frag_ref(&skb_shinfo(skb)->frags[f]);
 }
 
+/* Internal from net/core/page_pool.c, do not use in drivers directly */
+bool page_pool_return_skb_page(struct page *page, bool napi_safe);
+
 static inline void
 napi_frag_unref(skb_frag_t *frag, bool recycle, bool napi_safe)
 {
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 126f9e294389..2a9ce2aa6eb2 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -240,8 +240,6 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
 	return pool->p.dma_dir;
 }
 
-bool page_pool_return_skb_page(struct page *page, bool napi_safe);
-
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
 struct xdp_mem_info;
-- 
2.40.1


