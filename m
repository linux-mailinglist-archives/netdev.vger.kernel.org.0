Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC0D4A42E7
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359840AbiAaLPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376749AbiAaLNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:13:12 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E277C061759
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 03:10:58 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id m26so3658132wms.0
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 03:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=UUdZgjlPIr8XssL2mF8FEWd/qG9xosyoMz9gRA2BM20=;
        b=UDaOIQjWsetljH2YlpURPAyevxq9hY6Owr4bTciq/l6O5SBEqrSF96SonQ5tdSFfki
         do4fLbm9wVOLfYmZ7Ql9YHH26rbNn1XV5iVZlysVsFLovAwGJf5Sc2MqtcTQ6Uhzrt0L
         4ogfbuTWyE4gYmJ9WyYeODq3Dx5Oc1K9xFvO7UN+vBVaeTwbM056libZ8caXq55+csOv
         b2cLIm7iu8qs+3z0DGpGZXdfGC6qHAtF0Z8FTFPsetbeZkUFHJRp6Nwb5tDyuHmLB5kN
         T/CPyK1PsGlFZiAK2Elb/KLLlYbLwKinwajT14ERdzG27pKHj7WT9+v3lz6D0eNciF+z
         5PdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=UUdZgjlPIr8XssL2mF8FEWd/qG9xosyoMz9gRA2BM20=;
        b=PF1yr6QlWvZUC/kKdRSEo5yAozaMqeh849oFNkxgfxDuZ2OzZL/l124pbH0oz3506L
         8xBxTST6+ahBBpMxJKtt3FlrNvcHyphRxTQrx+PcPAppPTc6lwqvjKKRmPimXtW/lFon
         vlHLfv7gogEspfbdF+3MkgZ47sQNIL5PZMevOCLR/WEv4cGnRjzaqU8cPGLxP1XucNWF
         +Mm8gxOrQaMFZq9gO05wa/dTI0gTqamcAXykbxFB7CKGVk13I7uiCVVbWPXg8KnzHA6Z
         1OvvkmBxLcj5MWcXDRxLXTZJzBHJal77D/n1mWJ8BBYZMr/i1TgE/CD/BH2AraOig7Jb
         4GMQ==
X-Gm-Message-State: AOAM5308o0xn+MevfCdHNFtmhezuzy1ZH0rgzfrapNe6fUUN4XyBJrY3
        7w+SSmV6Lb36kP0OF30AuqxXGv1k+YU=
X-Google-Smtp-Source: ABdhPJwWnZuIDVyve2KprjjSfM//WUWahpUuW2SA9lIAa+6ECEZEQECV640odx3u9GwlWf26JgKZuQ==
X-Received: by 2002:a05:600c:1d14:: with SMTP id l20mr17556382wms.182.1643627456859;
        Mon, 31 Jan 2022 03:10:56 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id n15sm8775869wmr.26.2022.01.31.03.10.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 31 Jan 2022 03:10:56 -0800 (PST)
Date:   Mon, 31 Jan 2022 11:10:54 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        davem@davemloft.net, kuba@kernel.org, ecree.xilinx@gmail.com,
        netdev@vger.kernel.org, dinang@xilinx.com
Subject: [PATCH V2 net-next] sfc: The size of the RX recycle ring should be
 more flexible
Message-ID: <20220131111054.cp4f6foyinaarwbn@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        davem@davemloft.net, kuba@kernel.org, ecree.xilinx@gmail.com,
        netdev@vger.kernel.org, dinang@xilinx.com
References: <CACT4oudChHDKecLfDdA7R8jpQv2Nmz5xBS3hH_jFWeS37CnQGg@mail.gmail.com>
 <20211120083107.z2cm7tkl2rsri2v7@gmail.com>
 <CACT4oufpvQ1Qzg3eC6wDu33_xBo5tVghr9G7Q=d-7F=bZbW4Vg@mail.gmail.com>
 <CACT4ouc=LNnrTdz37YEOAkm3G+02vrmJ5Sxk0JwKSMoCGnLs-w@mail.gmail.com>
 <20220102092207.rxz7kpjii4ermnfo@gmail.com>
 <20220110085820.zi73go4etyyrkixr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220110085820.zi73go4etyyrkixr@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ideally the size would depend on the link speed, but the recycle
ring is created when the interface is brought up before the driver
knows the link speed. So size it for the maximum speed of a given NIC.
PowerPC is only supported on SFN7xxx and SFN8xxx NICs.

With this patch on a 40G NIC the number of calls to alloc_pages and
friends went down from about 18% to under 2%.
On a 10G NIC the number of calls to alloc_pages and friends went down
from about 15% to 0 (perf did not capture any calls during the 60
second test).
On a 100G NIC the number of calls to alloc_pages and friends went down
from about 23% to 4%.

Change from V1:
- Factored out the PowerPC scaling to be outside the swtich.

Reported-by: Íñigo Huguet <ihuguet@redhat.com>
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef10.c       |   26 ++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.c  |    9 +++++++++
 drivers/net/ethernet/sfc/net_driver.h |    2 ++
 drivers/net/ethernet/sfc/nic_common.h |    5 +++++
 drivers/net/ethernet/sfc/rx_common.c  |   18 +-----------------
 drivers/net/ethernet/sfc/rx_common.h  |    6 ++++++
 drivers/net/ethernet/sfc/siena.c      |    8 ++++++++
 7 files changed, 57 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index cf366ed2557c..50d535981a35 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3990,6 +3990,30 @@ static unsigned int ef10_check_caps(const struct efx_nic *efx,
 	}
 }
 
+static unsigned int efx_ef10_recycle_ring_size(const struct efx_nic *efx)
+{
+	unsigned int ret = EFX_RECYCLE_RING_SIZE_10G;
+
+	/* There is no difference between PFs and VFs. The side is based on
+	 * the maximum link speed of a given NIC.
+	 */
+	switch (efx->pci_dev->device & 0xfff) {
+	case 0x0903:	/* Farmingdale can do up to 10G */
+		break;
+	case 0x0923:	/* Greenport can do up to 40G */
+	case 0x0a03:	/* Medford can do up to 40G */
+		ret *= 4;
+		break;
+	default:	/* Medford2 can do up to 100G */
+		ret *= 10;
+	}
+
+	if (IS_ENABLED(CONFIG_PPC64))
+		ret *= 4;
+
+	return ret;
+}
+
 #define EF10_OFFLOAD_FEATURES		\
 	(NETIF_F_IP_CSUM |		\
 	 NETIF_F_HW_VLAN_CTAG_FILTER |	\
@@ -4106,6 +4130,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.check_caps = ef10_check_caps,
 	.print_additional_fwver = efx_ef10_print_additional_fwver,
 	.sensor_event = efx_mcdi_sensor_event,
+	.rx_recycle_ring_size = efx_ef10_recycle_ring_size,
 };
 
 const struct efx_nic_type efx_hunt_a0_nic_type = {
@@ -4243,4 +4268,5 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.check_caps = ef10_check_caps,
 	.print_additional_fwver = efx_ef10_print_additional_fwver,
 	.sensor_event = efx_mcdi_sensor_event,
+	.rx_recycle_ring_size = efx_ef10_recycle_ring_size,
 };
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index f79b14a119ae..a07cbf45a326 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -23,6 +23,7 @@
 #include "ef100_rx.h"
 #include "ef100_tx.h"
 #include "ef100_netdev.h"
+#include "rx_common.h"
 
 #define EF100_MAX_VIS 4096
 #define EF100_NUM_MCDI_BUFFERS	1
@@ -696,6 +697,12 @@ static unsigned int ef100_check_caps(const struct efx_nic *efx,
 	}
 }
 
+static unsigned int efx_ef100_recycle_ring_size(const struct efx_nic *efx)
+{
+	/* Maximum link speed for Riverhead is 100G */
+	return 10 * EFX_RECYCLE_RING_SIZE_10G;
+}
+
 /*	NIC level access functions
  */
 #define EF100_OFFLOAD_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_RXCSUM |	\
@@ -770,6 +777,7 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.rx_push_rss_context_config = efx_mcdi_rx_push_rss_context_config,
 	.rx_pull_rss_context_config = efx_mcdi_rx_pull_rss_context_config,
 	.rx_restore_rss_contexts = efx_mcdi_rx_restore_rss_contexts,
+	.rx_recycle_ring_size = efx_ef100_recycle_ring_size,
 
 	.reconfigure_mac = ef100_reconfigure_mac,
 	.reconfigure_port = efx_mcdi_port_reconfigure,
@@ -849,6 +857,7 @@ const struct efx_nic_type ef100_vf_nic_type = {
 	.rx_pull_rss_config = efx_mcdi_rx_pull_rss_config,
 	.rx_push_rss_config = efx_mcdi_pf_rx_push_rss_config,
 	.rx_restore_rss_contexts = efx_mcdi_rx_restore_rss_contexts,
+	.rx_recycle_ring_size = efx_ef100_recycle_ring_size,
 
 	.reconfigure_mac = ef100_reconfigure_mac,
 	.test_nvram = efx_new_mcdi_nvram_test_all,
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index cc15ee8812d9..c75dc75e2857 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1282,6 +1282,7 @@ struct efx_udp_tunnel {
  * @udp_tnl_has_port: Check if a port has been added as UDP tunnel
  * @print_additional_fwver: Dump NIC-specific additional FW version info
  * @sensor_event: Handle a sensor event from MCDI
+ * @rx_recycle_ring_size: Size of the RX recycle ring
  * @revision: Hardware architecture revision
  * @txd_ptr_tbl_base: TX descriptor ring base address
  * @rxd_ptr_tbl_base: RX descriptor ring base address
@@ -1460,6 +1461,7 @@ struct efx_nic_type {
 	size_t (*print_additional_fwver)(struct efx_nic *efx, char *buf,
 					 size_t len);
 	void (*sensor_event)(struct efx_nic *efx, efx_qword_t *ev);
+	unsigned int (*rx_recycle_ring_size)(const struct efx_nic *efx);
 
 	int revision;
 	unsigned int txd_ptr_tbl_base;
diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet/sfc/nic_common.h
index b9cafe9cd568..0cef35c0c559 100644
--- a/drivers/net/ethernet/sfc/nic_common.h
+++ b/drivers/net/ethernet/sfc/nic_common.h
@@ -195,6 +195,11 @@ static inline void efx_sensor_event(struct efx_nic *efx, efx_qword_t *ev)
 		efx->type->sensor_event(efx, ev);
 }
 
+static inline unsigned int efx_rx_recycle_ring_size(const struct efx_nic *efx)
+{
+	return efx->type->rx_recycle_ring_size(efx);
+}
+
 /* Some statistics are computed as A - B where A and B each increase
  * linearly with some hardware counter(s) and the counters are read
  * asynchronously.  If the counters contributing to B are always read
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 633ca77a26fd..1b22c7be0088 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -23,13 +23,6 @@ module_param(rx_refill_threshold, uint, 0444);
 MODULE_PARM_DESC(rx_refill_threshold,
 		 "RX descriptor ring refill threshold (%)");
 
-/* Number of RX buffers to recycle pages for.  When creating the RX page recycle
- * ring, this number is divided by the number of buffers per page to calculate
- * the number of pages to store in the RX page recycle ring.
- */
-#define EFX_RECYCLE_RING_SIZE_IOMMU 4096
-#define EFX_RECYCLE_RING_SIZE_NOIOMMU (2 * EFX_RX_PREFERRED_BATCH)
-
 /* RX maximum head room required.
  *
  * This must be at least 1 to prevent overflow, plus one packet-worth
@@ -141,16 +134,7 @@ static void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue)
 	unsigned int bufs_in_recycle_ring, page_ring_size;
 	struct efx_nic *efx = rx_queue->efx;
 
-	/* Set the RX recycle ring size */
-#ifdef CONFIG_PPC64
-	bufs_in_recycle_ring = EFX_RECYCLE_RING_SIZE_IOMMU;
-#else
-	if (iommu_present(&pci_bus_type))
-		bufs_in_recycle_ring = EFX_RECYCLE_RING_SIZE_IOMMU;
-	else
-		bufs_in_recycle_ring = EFX_RECYCLE_RING_SIZE_NOIOMMU;
-#endif /* CONFIG_PPC64 */
-
+	bufs_in_recycle_ring = efx_rx_recycle_ring_size(efx);
 	page_ring_size = roundup_pow_of_two(bufs_in_recycle_ring /
 					    efx->rx_bufs_per_page);
 	rx_queue->page_ring = kcalloc(page_ring_size,
diff --git a/drivers/net/ethernet/sfc/rx_common.h b/drivers/net/ethernet/sfc/rx_common.h
index 207ccd8ba062..fbd2769307f9 100644
--- a/drivers/net/ethernet/sfc/rx_common.h
+++ b/drivers/net/ethernet/sfc/rx_common.h
@@ -18,6 +18,12 @@
 #define EFX_RX_MAX_FRAGS DIV_ROUND_UP(EFX_MAX_FRAME_LEN(EFX_MAX_MTU), \
 				      EFX_RX_USR_BUF_SIZE)
 
+/* Number of RX buffers to recycle pages for.  When creating the RX page recycle
+ * ring, this number is divided by the number of buffers per page to calculate
+ * the number of pages to store in the RX page recycle ring.
+ */
+#define EFX_RECYCLE_RING_SIZE_10G	256
+
 static inline u8 *efx_rx_buf_va(struct efx_rx_buffer *buf)
 {
 	return page_address(buf->page) + buf->page_offset;
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index 16347a6d0c47..ce3060e15b54 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -25,6 +25,7 @@
 #include "mcdi_port_common.h"
 #include "selftest.h"
 #include "siena_sriov.h"
+#include "rx_common.h"
 
 /* Hardware control for SFC9000 family including SFL9021 (aka Siena). */
 
@@ -958,6 +959,12 @@ static unsigned int siena_check_caps(const struct efx_nic *efx,
 	return 0;
 }
 
+static unsigned int efx_siena_recycle_ring_size(const struct efx_nic *efx)
+{
+	/* Maximum link speed is 10G */
+	return EFX_RECYCLE_RING_SIZE_10G;
+}
+
 /**************************************************************************
  *
  * Revision-dependent attributes used by efx.c and nic.c
@@ -1098,4 +1105,5 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.rx_hash_key_size = 16,
 	.check_caps = siena_check_caps,
 	.sensor_event = efx_mcdi_sensor_event,
+	.rx_recycle_ring_size = efx_siena_recycle_ring_size,
 };
