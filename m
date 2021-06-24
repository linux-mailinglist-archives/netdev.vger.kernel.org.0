Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96743B3543
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhFXSKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbhFXSKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:10:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E843C061767
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:49 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 67-20020a2514460000b029053a9edba2a6so496589ybu.7
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VpC5416KePNPLsfIAzh6zY8KgAJUuuERD73OLykgX5k=;
        b=Bvw54QRcHgEk91OSgj+smg/DsV79sICEzEQHbf06Ct1ProEZJYp2z+vIBMmMRfzQS7
         xk0oKHetiMrcag5Nqj+w1fkXafVvC2BuSmaDLhbz2PWBINHc8M229NWfMD67DGYYiVOH
         NNtB0yVMmpmYxE3o+koWo2/qOhCfQ6KFG59MClMk5bNLad9LDNpPeEMQaN4LkvfJ1d46
         r2kQFxpLEbDLxoRiVJYqq36/Kqad54XayU9d0XsQg6peBcCik3A0PeiG3VceEKTzAidv
         xyyLopHodF/Ux23qikL5z3IVNlMMkIu341ll+x74ixG5yoFkoYLc782FAZxS/d685WE2
         dIMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VpC5416KePNPLsfIAzh6zY8KgAJUuuERD73OLykgX5k=;
        b=B8YJRZOcYklj6fuRPAKfc5PgLlT22VDDeaPAX3wwo3q3n5mQECyZvAe1dYUYBjuVX3
         pTTGDL+iTiwkyvWsmIm3gnYKd/NhmdnHj6aDulb7tpeYFM0DG49KX3HrQLB6A2XE4gbm
         bS0jyqUNWZbKMthjnkSNdS5KlD2opGuByPcS/1Jfqp27zFYnxMc2tXa9KeGjf1Oxuz6n
         1c2TfHqlnUz/MkMh6Sl1SW1rYuYYx4HhNc+pTUYp0Axyutu/42IEcYd3X+kmiQGgWyic
         zT5odILCRL3XuNjTHvpEtM+5qQG+eAX7OcozllUhYJlUYnyNvmJNLj3KFp0hoHyCccho
         araA==
X-Gm-Message-State: AOAM531dSx3TOZKhXpAWcMRPfC2O+HrAKmlJU6XzzUmC0CKB/sr95yUl
        JPCRBdAHMozAmF0Fv0P3M2Uxots=
X-Google-Smtp-Source: ABdhPJy+zGDehgATRCqJkZnHp6PX6amPntacazLaV80EQNDW2F5C862j2FRw092Bh32b4/RowkcNgp8=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:a5b:384:: with SMTP id k4mr6907923ybp.194.1624558068255;
 Thu, 24 Jun 2021 11:07:48 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:24 -0700
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
Message-Id: <20210624180632.3659809-9-bcf@google.com>
Mime-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 08/16] gve: Add support for DQO RX PTYPE map
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike GQI, DQO RX descriptors do not contain the L3 and L4 type of the
packet. L3 and L4 types are necessary in order to set the hash and csum
on RX SKBs correctly.

DQO RX descriptors instead contain a 10 bit PTYPE index. The PTYPE map
enables the device to tell the driver how to map from PTYPE index to
L3/L4 type.

The device doesn't provide any guarantees about the range of possible
PTYPEs, so we just use a 1024 entry array to implement a fast mapping
structure.

Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        | 15 +++++++
 drivers/net/ethernet/google/gve/gve_adminq.c | 45 +++++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_adminq.h | 44 ++++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_main.c   | 25 +++++++++++
 4 files changed, 127 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 9045b86279cb..e32730f50bf9 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -11,6 +11,7 @@
 #include <linux/netdevice.h>
 #include <linux/pci.h>
 #include <linux/u64_stats_sync.h>
+
 #include "gve_desc.h"
 
 #ifndef PCI_VENDOR_ID_GOOGLE
@@ -40,6 +41,9 @@
 
 #define GVE_DATA_SLOT_ADDR_PAGE_MASK (~(PAGE_SIZE - 1))
 
+/* PTYPEs are always 10 bits. */
+#define GVE_NUM_PTYPES	1024
+
 /* Each slot in the desc ring has a 1:1 mapping to a slot in the data ring */
 struct gve_rx_desc_queue {
 	struct gve_rx_desc *desc_ring; /* the descriptor ring */
@@ -199,6 +203,15 @@ struct gve_options_dqo_rda {
 	u16 rx_buff_ring_entries; /* number of rx_buff descriptors */
 };
 
+struct gve_ptype {
+	u8 l3_type;  /* `gve_l3_type` in gve_adminq.h */
+	u8 l4_type;  /* `gve_l4_type` in gve_adminq.h */
+};
+
+struct gve_ptype_lut {
+	struct gve_ptype ptypes[GVE_NUM_PTYPES];
+};
+
 /* GVE_QUEUE_FORMAT_UNSPECIFIED must be zero since 0 is the default value
  * when the entire configure_device_resources command is zeroed out and the
  * queue_format is not specified.
@@ -266,6 +279,7 @@ struct gve_priv {
 	u32 adminq_set_driver_parameter_cnt;
 	u32 adminq_report_stats_cnt;
 	u32 adminq_report_link_speed_cnt;
+	u32 adminq_get_ptype_map_cnt;
 
 	/* Global stats */
 	u32 interface_up_cnt; /* count of times interface turned up since last reset */
@@ -292,6 +306,7 @@ struct gve_priv {
 	u64 link_speed;
 
 	struct gve_options_dqo_rda options_dqo_rda;
+	struct gve_ptype_lut *ptype_lut_dqo;
 
 	enum gve_queue_format queue_format;
 };
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 9efa60ce34e0..7d8d354f67e2 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -176,6 +176,7 @@ int gve_adminq_alloc(struct device *dev, struct gve_priv *priv)
 	priv->adminq_set_driver_parameter_cnt = 0;
 	priv->adminq_report_stats_cnt = 0;
 	priv->adminq_report_link_speed_cnt = 0;
+	priv->adminq_get_ptype_map_cnt = 0;
 
 	/* Setup Admin queue with the device */
 	iowrite32be(priv->adminq_bus_addr / PAGE_SIZE,
@@ -381,6 +382,9 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 	case GVE_ADMINQ_REPORT_LINK_SPEED:
 		priv->adminq_report_link_speed_cnt++;
 		break;
+	case GVE_ADMINQ_GET_PTYPE_MAP:
+		priv->adminq_get_ptype_map_cnt++;
+		break;
 	default:
 		dev_err(&priv->pdev->dev, "unknown AQ command opcode %d\n", opcode);
 	}
@@ -393,7 +397,8 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
  * The caller is also responsible for making sure there are no commands
  * waiting to be executed.
  */
-static int gve_adminq_execute_cmd(struct gve_priv *priv, union gve_adminq_command *cmd_orig)
+static int gve_adminq_execute_cmd(struct gve_priv *priv,
+				  union gve_adminq_command *cmd_orig)
 {
 	u32 tail, head;
 	int err;
@@ -827,3 +832,41 @@ int gve_adminq_report_link_speed(struct gve_priv *priv)
 			  link_speed_region_bus);
 	return err;
 }
+
+int gve_adminq_get_ptype_map_dqo(struct gve_priv *priv,
+				 struct gve_ptype_lut *ptype_lut)
+{
+	struct gve_ptype_map *ptype_map;
+	union gve_adminq_command cmd;
+	dma_addr_t ptype_map_bus;
+	int err = 0;
+	int i;
+
+	memset(&cmd, 0, sizeof(cmd));
+	ptype_map = dma_alloc_coherent(&priv->pdev->dev, sizeof(*ptype_map),
+				       &ptype_map_bus, GFP_KERNEL);
+	if (!ptype_map)
+		return -ENOMEM;
+
+	cmd.opcode = cpu_to_be32(GVE_ADMINQ_GET_PTYPE_MAP);
+	cmd.get_ptype_map = (struct gve_adminq_get_ptype_map) {
+		.ptype_map_len = cpu_to_be64(sizeof(*ptype_map)),
+		.ptype_map_addr = cpu_to_be64(ptype_map_bus),
+	};
+
+	err = gve_adminq_execute_cmd(priv, &cmd);
+	if (err)
+		goto err;
+
+	/* Populate ptype_lut. */
+	for (i = 0; i < GVE_NUM_PTYPES; i++) {
+		ptype_lut->ptypes[i].l3_type =
+			ptype_map->ptypes[i].l3_type;
+		ptype_lut->ptypes[i].l4_type =
+			ptype_map->ptypes[i].l4_type;
+	}
+err:
+	dma_free_coherent(&priv->pdev->dev, sizeof(*ptype_map), ptype_map,
+			  ptype_map_bus);
+	return err;
+}
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index 4b1485b11a7b..62a7e96af715 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -22,7 +22,8 @@ enum gve_adminq_opcodes {
 	GVE_ADMINQ_DECONFIGURE_DEVICE_RESOURCES	= 0x9,
 	GVE_ADMINQ_SET_DRIVER_PARAMETER		= 0xB,
 	GVE_ADMINQ_REPORT_STATS			= 0xC,
-	GVE_ADMINQ_REPORT_LINK_SPEED	= 0xD
+	GVE_ADMINQ_REPORT_LINK_SPEED		= 0xD,
+	GVE_ADMINQ_GET_PTYPE_MAP		= 0xE,
 };
 
 /* Admin queue status codes */
@@ -266,6 +267,41 @@ enum gve_stat_names {
 	RX_DROPS_INVALID_CHECKSUM	= 68,
 };
 
+enum gve_l3_type {
+	/* Must be zero so zero initialized LUT is unknown. */
+	GVE_L3_TYPE_UNKNOWN = 0,
+	GVE_L3_TYPE_OTHER,
+	GVE_L3_TYPE_IPV4,
+	GVE_L3_TYPE_IPV6,
+};
+
+enum gve_l4_type {
+	/* Must be zero so zero initialized LUT is unknown. */
+	GVE_L4_TYPE_UNKNOWN = 0,
+	GVE_L4_TYPE_OTHER,
+	GVE_L4_TYPE_TCP,
+	GVE_L4_TYPE_UDP,
+	GVE_L4_TYPE_ICMP,
+	GVE_L4_TYPE_SCTP,
+};
+
+/* These are control path types for PTYPE which are the same as the data path
+ * types.
+ */
+struct gve_ptype_entry {
+	u8 l3_type;
+	u8 l4_type;
+};
+
+struct gve_ptype_map {
+	struct gve_ptype_entry ptypes[1 << 10]; /* PTYPES are always 10 bits. */
+};
+
+struct gve_adminq_get_ptype_map {
+	__be64 ptype_map_len;
+	__be64 ptype_map_addr;
+};
+
 union gve_adminq_command {
 	struct {
 		__be32 opcode;
@@ -283,6 +319,7 @@ union gve_adminq_command {
 			struct gve_adminq_set_driver_parameter set_driver_param;
 			struct gve_adminq_report_stats report_stats;
 			struct gve_adminq_report_link_speed report_link_speed;
+			struct gve_adminq_get_ptype_map get_ptype_map;
 		};
 	};
 	u8 reserved[64];
@@ -311,4 +348,9 @@ int gve_adminq_set_mtu(struct gve_priv *priv, u64 mtu);
 int gve_adminq_report_stats(struct gve_priv *priv, u64 stats_report_len,
 			    dma_addr_t stats_report_addr, u64 interval);
 int gve_adminq_report_link_speed(struct gve_priv *priv);
+
+struct gve_ptype_lut;
+int gve_adminq_get_ptype_map_dqo(struct gve_priv *priv,
+				 struct gve_ptype_lut *ptype_lut);
+
 #endif /* _GVE_ADMINQ_H */
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index aa0bff03c6c8..8cc0ac061c93 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -346,6 +346,22 @@ static int gve_setup_device_resources(struct gve_priv *priv)
 		err = -ENXIO;
 		goto abort_with_stats_report;
 	}
+
+	if (priv->queue_format == GVE_DQO_RDA_FORMAT) {
+		priv->ptype_lut_dqo = kvzalloc(sizeof(*priv->ptype_lut_dqo),
+					       GFP_KERNEL);
+		if (!priv->ptype_lut_dqo) {
+			err = -ENOMEM;
+			goto abort_with_stats_report;
+		}
+		err = gve_adminq_get_ptype_map_dqo(priv, priv->ptype_lut_dqo);
+		if (err) {
+			dev_err(&priv->pdev->dev,
+				"Failed to get ptype map: err=%d\n", err);
+			goto abort_with_ptype_lut;
+		}
+	}
+
 	err = gve_adminq_report_stats(priv, priv->stats_report_len,
 				      priv->stats_report_bus,
 				      GVE_STATS_REPORT_TIMER_PERIOD);
@@ -354,12 +370,17 @@ static int gve_setup_device_resources(struct gve_priv *priv)
 			"Failed to report stats: err=%d\n", err);
 	gve_set_device_resources_ok(priv);
 	return 0;
+
+abort_with_ptype_lut:
+	kvfree(priv->ptype_lut_dqo);
+	priv->ptype_lut_dqo = NULL;
 abort_with_stats_report:
 	gve_free_stats_report(priv);
 abort_with_ntfy_blocks:
 	gve_free_notify_blocks(priv);
 abort_with_counter:
 	gve_free_counter_array(priv);
+
 	return err;
 }
 
@@ -386,6 +407,10 @@ static void gve_teardown_device_resources(struct gve_priv *priv)
 			gve_trigger_reset(priv);
 		}
 	}
+
+	kvfree(priv->ptype_lut_dqo);
+	priv->ptype_lut_dqo = NULL;
+
 	gve_free_counter_array(priv);
 	gve_free_notify_blocks(priv);
 	gve_free_stats_report(priv);
-- 
2.32.0.288.g62a8d224e6-goog

