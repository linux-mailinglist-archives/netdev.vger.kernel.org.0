Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A512C351F4C
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbhDATFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbhDATDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:03:22 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653EBC03D203
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 10:56:28 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id j34so25067pgj.12
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 10:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s4+rlrMNeebfP+JdeQjUQYoTMK0iQOZvg25fu6f2Gok=;
        b=kgv0GqfEniFZdFd0BZFAmKdFUlhgXpifz7PpUSbYt5id5Z1phBPo/GhQoPbaxvDxBa
         gyS+7CboGEEZq9wsMSEe+3VmfsRhZ/d1XtE/7jeVFZ7QVKRwQFd2WkUS9MTMLUPccvX1
         pC5IvjTxT2jOygm37XVcoIhSE/+20JPntIeR/55xCZQUGge2QDbwqCAyIXSelAqCMag6
         otjNCmoLFr6IfumsHlJ5I15UkXPTb6u3LiaPF5+61EIz2seR0tnkIbV6uNleTqTkOz1A
         1BAGGpk7WqV9MBueUD2X8/JrZxDPhF0suKC1f5UjPw+ereFPvNuwlPzIA9449MtIfcu6
         Y/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=s4+rlrMNeebfP+JdeQjUQYoTMK0iQOZvg25fu6f2Gok=;
        b=fX+FT+x3SuXUwjOhteBzcw/nf0LP2k7f6Q6IwfjytOLoRtUs7m0TWDe3bznZOqLkwo
         Y1kc1eVMCyQh+o0dJUfDcaL9oJ6pFP0BAv06PmV1+n2FKSVKuJJ9+ypAPpCV2f1ABeAH
         jCQJ75J2Ca+VQVSmdC3kfnMPrNQCFnsXTezmEn+weSev5l0fcMmh28Yu9yuBKaMw23iU
         XSEaquWhHoVg/B6D0d54QQA7Hk0n4XGR13cHBPiNo+eAptXQPlTZ+RJIbgmthgNHoSiQ
         N+u+SgRamRTU47rtiE0R2/PzeO2BxWeM2pXW346kZLL5/wxoqZh/8kCHAPU2a/aFUyRV
         53RA==
X-Gm-Message-State: AOAM5311Yab6rFsMDKkKWLL3NVN8sU3sOGshXBQwM1iz5hS59mbEmSsw
        kvd9eDuLkP4hbGiEi17rNHLZr7eSGU2O/Q==
X-Google-Smtp-Source: ABdhPJw7VAx5cHLzSlYukRx1c6pkMeIxtPYyloQo3cBhWum6lhUlW1uB+KF/k/rAGg28H4+ryMfv3Q==
X-Received: by 2002:a62:e70f:0:b029:1fd:6bae:235d with SMTP id s15-20020a62e70f0000b02901fd6bae235dmr8789800pfh.43.1617299787590;
        Thu, 01 Apr 2021 10:56:27 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n5sm6195909pfq.44.2021.04.01.10.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 10:56:26 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH net-next 06/12] ionic: link in the new hw timestamp code
Date:   Thu,  1 Apr 2021 10:56:04 -0700
Message-Id: <20210401175610.44431-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210401175610.44431-1-snelson@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are changes to compile and link the new code, but no
new feature support is available or advertised yet.

Signed-off-by: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/Makefile  |  1 +
 drivers/net/ethernet/pensando/ionic/ionic.h   |  4 ++
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  2 +
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  1 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 25 +++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   | 72 +++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_main.c  |  2 +
 7 files changed, 107 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
index 8d3c2d3cb10d..4e7642a2d25f 100644
--- a/drivers/net/ethernet/pensando/ionic/Makefile
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_IONIC) := ionic.o
 ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
 	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o \
 	   ionic_txrx.o ionic_stats.o ionic_fw.o
+ionic-$(CONFIG_PTP_1588_CLOCK) += ionic_phc.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 18e92103c711..66204106f83e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -20,6 +20,10 @@ struct ionic_lif;
 
 #define DEVCMD_TIMEOUT  10
 
+#define IONIC_PHC_UPDATE_NS	10000000000	    /* 10s in nanoseconds */
+#define NORMAL_PPB		1000000000	    /* one billion parts per billion */
+#define SCALED_PPM		(1000000ull << 16)  /* 2^16 million parts per 2^16 million */
+
 struct ionic_vf {
 	u16	 index;
 	u8	 macaddr[6];
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 0e8e88c69e1c..1dfe962e22e0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -79,6 +79,8 @@ int ionic_dev_setup(struct ionic *ionic)
 	idev->intr_status = bar->vaddr + IONIC_BAR0_INTR_STATUS_OFFSET;
 	idev->intr_ctrl = bar->vaddr + IONIC_BAR0_INTR_CTRL_OFFSET;
 
+	idev->hwstamp_regs = &idev->dev_info_regs->hwstamp;
+
 	sig = ioread32(&idev->dev_info_regs->signature);
 	if (sig != IONIC_DEV_INFO_SIGNATURE) {
 		dev_err(dev, "Incompatible firmware signature %x", sig);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 25c52c042246..28994e01fa0a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -136,6 +136,7 @@ struct ionic_devinfo {
 struct ionic_dev {
 	union ionic_dev_info_regs __iomem *dev_info_regs;
 	union ionic_dev_cmd_regs __iomem *dev_cmd_regs;
+	struct ionic_hwstamp_regs __iomem *hwstamp_regs;
 
 	atomic_long_t last_check_time;
 	unsigned long last_hb_time;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 9a61b2bbb652..ced80de4d92a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -830,6 +830,31 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	return 0;
 }
 
+int ionic_lif_create_hwstamp_txq(struct ionic_lif *lif)
+{
+	return 0;
+}
+
+int ionic_lif_create_hwstamp_rxq(struct ionic_lif *lif)
+{
+	return 0;
+}
+
+int ionic_lif_config_hwstamp_rxq_all(struct ionic_lif *lif, bool rx_all)
+{
+	return 0;
+}
+
+int ionic_lif_set_hwstamp_txmode(struct ionic_lif *lif, u16 txstamp_mode)
+{
+	return 0;
+}
+
+int ionic_lif_set_hwstamp_rxfilt(struct ionic_lif *lif, u64 pkt_class)
+{
+	return 0;
+}
+
 static bool ionic_notifyq_service(struct ionic_cq *cq,
 				  struct ionic_cq_info *cq_info)
 {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 93d3058aed77..ea3b086af179 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -4,6 +4,9 @@
 #ifndef _IONIC_LIF_H_
 #define _IONIC_LIF_H_
 
+#include <linux/ptp_clock_kernel.h>
+#include <linux/timecounter.h>
+#include <uapi/linux/net_tstamp.h>
 #include <linux/dim.h>
 #include <linux/pci.h>
 #include "ionic_rx_filter.h"
@@ -36,6 +39,8 @@ struct ionic_tx_stats {
 	u64 crc32_csum;
 	u64 sg_cntr[IONIC_MAX_NUM_SG_CNTR];
 	u64 dma_map_err;
+	u64 hwstamp_valid;
+	u64 hwstamp_invalid;
 };
 
 struct ionic_rx_stats {
@@ -49,6 +54,8 @@ struct ionic_rx_stats {
 	u64 csum_error;
 	u64 dma_map_err;
 	u64 alloc_err;
+	u64 hwstamp_valid;
+	u64 hwstamp_invalid;
 };
 
 #define IONIC_QCQ_F_INITED		BIT(0)
@@ -125,6 +132,10 @@ struct ionic_lif_sw_stats {
 	u64 rx_csum_none;
 	u64 rx_csum_complete;
 	u64 rx_csum_error;
+	u64 tx_hwstamp_valid;
+	u64 tx_hwstamp_invalid;
+	u64 rx_hwstamp_valid;
+	u64 rx_hwstamp_invalid;
 	u64 hw_tx_dropped;
 	u64 hw_rx_dropped;
 	u64 hw_rx_over_errors;
@@ -158,6 +169,8 @@ struct ionic_qtype_info {
 	u16 sg_desc_stride;
 };
 
+struct ionic_phc;
+
 #define IONIC_LIF_NAME_MAX_SZ		32
 struct ionic_lif {
 	struct net_device *netdev;
@@ -170,8 +183,10 @@ struct ionic_lif {
 	struct ionic_qcq *adminqcq;
 	struct ionic_qcq *notifyqcq;
 	struct ionic_qcq **txqcqs;
+	struct ionic_qcq *hwstamp_txq;
 	struct ionic_tx_stats *txqstats;
 	struct ionic_qcq **rxqcqs;
+	struct ionic_qcq *hwstamp_rxq;
 	struct ionic_rx_stats *rxqstats;
 	struct ionic_deferred deferred;
 	struct work_struct tx_timeout_work;
@@ -214,9 +229,29 @@ struct ionic_lif {
 	unsigned long *dbid_inuse;
 	unsigned int dbid_count;
 
+	struct ionic_phc *phc;
+
 	struct dentry *dentry;
 };
 
+struct ionic_phc {
+	spinlock_t lock; /* lock for cc and tc */
+	struct cyclecounter cc;
+	struct timecounter tc;
+
+	struct mutex config_lock; /* lock for ts_config */
+	struct hwtstamp_config ts_config;
+	u64 ts_config_rx_filt;
+	u32 ts_config_tx_mode;
+
+	u32 init_cc_mult;
+	long aux_work_delay;
+
+	struct ptp_clock_info ptp_info;
+	struct ptp_clock *ptp;
+	struct ionic_lif *lif;
+};
+
 struct ionic_queue_params {
 	unsigned int nxqs;
 	unsigned int ntxq_descs;
@@ -265,6 +300,43 @@ void ionic_lif_unregister(struct ionic_lif *lif);
 int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 		       union ionic_lif_identity *lif_ident);
 int ionic_lif_size(struct ionic *ionic);
+
+#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
+int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr);
+int ionic_lif_hwstamp_get(struct ionic_lif *lif, struct ifreq *ifr);
+ktime_t ionic_lif_phc_ktime(struct ionic_lif *lif, u64 counter);
+void ionic_lif_register_phc(struct ionic_lif *lif);
+void ionic_lif_unregister_phc(struct ionic_lif *lif);
+void ionic_lif_alloc_phc(struct ionic_lif *lif);
+void ionic_lif_free_phc(struct ionic_lif *lif);
+#else
+static inline int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ionic_lif_hwstamp_get(struct ionic_lif *lif, struct ifreq *ifr)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline ktime_t ionic_lif_phc_ktime(struct ionic_lif *lif, u64 counter)
+{
+	return ns_to_ktime(0);
+}
+
+static inline void ionic_lif_register_phc(struct ionic_lif *lif) {}
+static inline void ionic_lif_unregister_phc(struct ionic_lif *lif) {}
+static inline void ionic_lif_alloc_phc(struct ionic_lif *lif) {}
+static inline void ionic_lif_free_phc(struct ionic_lif *lif) {}
+#endif
+
+int ionic_lif_create_hwstamp_txq(struct ionic_lif *lif);
+int ionic_lif_create_hwstamp_rxq(struct ionic_lif *lif);
+int ionic_lif_config_hwstamp_rxq_all(struct ionic_lif *lif, bool rx_all);
+int ionic_lif_set_hwstamp_txmode(struct ionic_lif *lif, u16 txstamp_mode);
+int ionic_lif_set_hwstamp_rxfilt(struct ionic_lif *lif, u64 pkt_class);
+
 int ionic_lif_rss_config(struct ionic_lif *lif, u16 types,
 			 const u8 *key, const u32 *indir);
 int ionic_reconfigure_queues(struct ionic_lif *lif,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 8c27fbe0e312..61cfe2120817 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -148,6 +148,8 @@ static const char *ionic_opcode_to_str(enum ionic_cmd_opcode opcode)
 		return "IONIC_CMD_LIF_SETATTR";
 	case IONIC_CMD_LIF_GETATTR:
 		return "IONIC_CMD_LIF_GETATTR";
+	case IONIC_CMD_LIF_SETPHC:
+		return "IONIC_CMD_LIF_SETPHC";
 	case IONIC_CMD_RX_MODE_SET:
 		return "IONIC_CMD_RX_MODE_SET";
 	case IONIC_CMD_RX_FILTER_ADD:
-- 
2.17.1

