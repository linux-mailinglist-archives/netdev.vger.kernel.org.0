Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C958119E9B
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfLJWyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:54:35 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46364 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfLJWye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 17:54:34 -0500
Received: by mail-pf1-f193.google.com with SMTP id y14so586920pfm.13
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 14:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WQ7i3wEHPVScRF24Du/iSEpENcZHH/jRwDanl3Y3k9o=;
        b=FK+Vcbz+FpFc5K5V7IX0CK43vRtfUfsHa3n2asOiuBSRBjfs6b9wTBVyufl3g53jeH
         24N9HXOl2dDATWFF+UF8Z5JQFVwb32Gc0AVNk4DUnvX7vucLDYHpM+awbNo7r61cROll
         IlnY580JvGRb+L8x/ps8QMTWPGIIHSWldeP78yomZtLZZxerNmQFqfnQqp4KNjImWWi4
         7E4AddcgPer+E8FWuuuNlcqDvPhZy/V7/t9ZdwQfGFTrWwaUuPaAg4JqEaIy1cnIKXFN
         PXuBlNVSEd5+mUvzB83vGUORDaj60NhJzOnhMj2pdIrj8F53Fj+KkCCnmC9YOlMgLDzY
         lnbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WQ7i3wEHPVScRF24Du/iSEpENcZHH/jRwDanl3Y3k9o=;
        b=XImk2jEAuy3TlI8OL21Kkt1KGOGtR7ltcC4GuMwPcCgySK2C6O/wpWTv/VkzGhyzqj
         OO/KH0momCkibgqawuM0rpp4hxGLXPfq2S3vaIulB0hPMr+wHqCZOQ+GBQC2O454PE5e
         CMEX4ZZ07+TX4WftqAM0VAqjJN0F6JpE9vJBMNmtwT82PwxOTjTA+jaE/dW+g9P/Q0S4
         qGe8p9vOMekUR+71T0ZNwoQUbLuW3su/FeJTVhQImPL2+2SSjI9W+XFoFiSJGeGiNHKX
         zXCd+RidasTAM06KZYGPDBIWt7iiQ2bi6V6JKs1aZy9YCGfE/zkxB4azybNaR+FylCvO
         vXFw==
X-Gm-Message-State: APjAAAU3a2EiIRinxTqrqdtwy9vXeTwLAzlstSaXeLM0vZ1FvyOjUBCm
        C1U7S9UN8pYQrYJOTBWhkonGTubJZGE=
X-Google-Smtp-Source: APXvYqxVbKx2I5sWBVou9NWL4S1hihW2KV9bq+/F5cBdbuY3u1t6BCpxgtzAV9XVIl0PtIfhe3FY9A==
X-Received: by 2002:a63:e80d:: with SMTP id s13mr595707pgh.134.1576018473318;
        Tue, 10 Dec 2019 14:54:33 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e12sm46630pjs.3.2019.12.10.14.54.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Dec 2019 14:54:32 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/2] ionic: ionic_if bits for sr-iov support
Date:   Tue, 10 Dec 2019 14:54:20 -0800
Message-Id: <20191210225421.35193-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191210225421.35193-1-snelson@pensando.io>
References: <20191210225421.35193-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds new AdminQ calls and their related structs for
supporting PF controls on VFs:
    CMD_OPCODE_VF_GETATTR
    CMD_OPCODE_VF_SETATTR

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_if.h    | 97 +++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index dbdb7c5ae8f1..ea5c379824c1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -51,6 +51,10 @@ enum ionic_cmd_opcode {
 	IONIC_CMD_RDMA_CREATE_CQ		= 52,
 	IONIC_CMD_RDMA_CREATE_ADMINQ		= 53,
 
+	/* SR/IOV commands */
+	IONIC_CMD_VF_GETATTR			= 60,
+	IONIC_CMD_VF_SETATTR			= 61,
+
 	/* QoS commands */
 	IONIC_CMD_QOS_CLASS_IDENTIFY		= 240,
 	IONIC_CMD_QOS_CLASS_INIT		= 241,
@@ -1639,6 +1643,93 @@ enum ionic_qos_sched_type {
 	IONIC_QOS_SCHED_TYPE_DWRR	= 1,	/* Deficit weighted round-robin */
 };
 
+enum ionic_vf_attr {
+	IONIC_VF_ATTR_SPOOFCHK	= 1,
+	IONIC_VF_ATTR_TRUST	= 2,
+	IONIC_VF_ATTR_MAC	= 3,
+	IONIC_VF_ATTR_LINKSTATE	= 4,
+	IONIC_VF_ATTR_VLAN	= 5,
+	IONIC_VF_ATTR_RATE	= 6,
+	IONIC_VF_ATTR_STATSADDR	= 7,
+};
+
+/**
+ * VF link status
+ */
+enum ionic_vf_link_status {
+	IONIC_VF_LINK_STATUS_AUTO = 0,	/* link state of the uplink */
+	IONIC_VF_LINK_STATUS_UP   = 1,	/* link is always up */
+	IONIC_VF_LINK_STATUS_DOWN = 2,	/* link is always down */
+};
+
+/**
+ * struct ionic_vf_setattr_cmd - Set VF attributes on the NIC
+ * @opcode:     Opcode
+ * @index:      VF index
+ * @attr:       Attribute type (enum ionic_vf_attr)
+ *	macaddr		mac address
+ *	vlanid		vlan ID
+ *	maxrate		max Tx rate in Mbps
+ *	spoofchk	enable address spoof checking
+ *	trust		enable VF trust
+ *	linkstate	set link up or down
+ *	stats_pa	set DMA address for VF stats
+ */
+struct ionic_vf_setattr_cmd {
+	u8     opcode;
+	u8     attr;
+	__le16 vf_index;
+	union {
+		u8     macaddr[6];
+		__le16 vlanid;
+		__le32 maxrate;
+		u8     spoofchk;
+		u8     trust;
+		u8     linkstate;
+		__le64 stats_pa;
+		u8     pad[60];
+	};
+};
+
+struct ionic_vf_setattr_comp {
+	u8     status;
+	u8     attr;
+	__le16 vf_index;
+	__le16 comp_index;
+	u8     rsvd[9];
+	u8     color;
+};
+
+/**
+ * struct ionic_vf_getattr_cmd - Get VF attributes from the NIC
+ * @opcode:     Opcode
+ * @index:      VF index
+ * @attr:       Attribute type (enum ionic_vf_attr)
+ */
+struct ionic_vf_getattr_cmd {
+	u8     opcode;
+	u8     attr;
+	__le16 vf_index;
+	u8     rsvd[60];
+};
+
+struct ionic_vf_getattr_comp {
+	u8     status;
+	u8     attr;
+	__le16 vf_index;
+	union {
+		u8     macaddr[6];
+		__le16 vlanid;
+		__le32 maxrate;
+		u8     spoofchk;
+		u8     trust;
+		u8     linkstate;
+		__le64 stats_pa;
+		u8     pad[11];
+	};
+	u8     color;
+};
+
 /**
  * union ionic_qos_config - Qos configuration structure
  * @flags:		Configuration flags
@@ -2289,6 +2380,9 @@ union ionic_dev_cmd {
 	struct ionic_port_getattr_cmd port_getattr;
 	struct ionic_port_setattr_cmd port_setattr;
 
+	struct ionic_vf_setattr_cmd vf_setattr;
+	struct ionic_vf_getattr_cmd vf_getattr;
+
 	struct ionic_lif_identify_cmd lif_identify;
 	struct ionic_lif_init_cmd lif_init;
 	struct ionic_lif_reset_cmd lif_reset;
@@ -2318,6 +2412,9 @@ union ionic_dev_cmd_comp {
 	struct ionic_port_getattr_comp port_getattr;
 	struct ionic_port_setattr_comp port_setattr;
 
+	struct ionic_vf_setattr_comp vf_setattr;
+	struct ionic_vf_getattr_comp vf_getattr;
+
 	struct ionic_lif_identify_comp lif_identify;
 	struct ionic_lif_init_comp lif_init;
 	ionic_lif_reset_comp lif_reset;
-- 
2.17.1

