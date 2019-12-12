Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F45711C17E
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 01:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfLLAd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 19:33:57 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33205 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbfLLAd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 19:33:56 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so215165pgk.0
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 16:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WQ7i3wEHPVScRF24Du/iSEpENcZHH/jRwDanl3Y3k9o=;
        b=GwPeuIMVTfNcY774NJ95KKuyN05dThpgmHPeKdo97tEL6Nn59BhAdE45Y02TbUl4jp
         Om3SKEcwwSdaaDwf6tf3hnJFfj/ZQeDaKWRXV4qTDrpgOd1uLV0y6QGG/wXzUonvZLWq
         vF71PaoFXL9b6GSkMeDbSY4QEiMczxP1Z7VJszNSjCH17kuzaPKBzrjM/MQ9kOgdlw1w
         PfuzVxJJw50ErItDqev2ZcP1WaADqcvUxbm7SZxp3t2oF3zTY0g+p7q15GfbBsjs7Rp/
         Qnte9wsdiRfOOSNaCtTzN1WwFpz0tJHFaKFtLekzJd5Y7678kb8VMle212iyjjvGNYm+
         GWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WQ7i3wEHPVScRF24Du/iSEpENcZHH/jRwDanl3Y3k9o=;
        b=DkvNxVfh8ybXYiK8q88F9kKIB4e8bFSOGNrencnVABNHF/uj+fV7NtA3NSUM3abFhq
         uUnU0E3UjEYm411bJtc08L4bvPcIbVU84J0qttj35P2iReK4McaO9WBF5YdtB49Qc7PN
         iQMZKBEcERyS1wtaoBrgGOqx0u+H+BSqLxXef8+85W5ZqqUzF8zbiRIasZwK+peHCJ+J
         9rH6wpEzstnQDfwRiyfQZgVs8yT188m34W79GpXsF6PLL2KANlRmsHmIAKp7Fp9pR7Yz
         83gmVavyzz+bgLk0qPKzqmq5ejOcefY/QzVCbzwPmjSsO1xYAJqws1gIrJzkXwddLhCX
         CIqg==
X-Gm-Message-State: APjAAAX/k2CXPRBgnLKKbXI0ggd65gz00WvagiMRzFeApYxLqmHFHbOV
        vfI6Kq3ytf5+BbbNuvFK8/uudZ1b+9w=
X-Google-Smtp-Source: APXvYqzJCIan1XlBW6Hpt1IzXRBvpEVJFEcO1rahI2LPKv9a/aoqLQ3qaPY6kHkAV8GGlHRG0XhOLw==
X-Received: by 2002:a63:ca4d:: with SMTP id o13mr7307738pgi.360.1576110835498;
        Wed, 11 Dec 2019 16:33:55 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 16sm4343509pfh.182.2019.12.11.16.33.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Dec 2019 16:33:54 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     parav@mellanox.com, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 1/2] ionic: ionic_if bits for sr-iov support
Date:   Wed, 11 Dec 2019 16:33:43 -0800
Message-Id: <20191212003344.5571-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212003344.5571-1-snelson@pensando.io>
References: <20191212003344.5571-1-snelson@pensando.io>
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

