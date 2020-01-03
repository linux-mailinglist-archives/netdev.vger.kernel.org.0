Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D93912FBDB
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 18:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgACRz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 12:55:27 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38961 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728110AbgACRz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 12:55:27 -0500
Received: by mail-pf1-f196.google.com with SMTP id q10so23836928pfs.6
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 09:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Rpgp8Qbo8YTkJ7o9V/hmrmF55MqGZvPgztBHYlkkui8=;
        b=MK5NX6EsgD/IFVqNtx+kNBrcBRbDPRNOjiDsz/5ZsRl3X+DGy6dww2HjAvN4TVkDpT
         reeunjN+Uz5h9FMPSbHr6D1vVv9Ya3bTEUHhBcNQ2jPmRrwoSQUTFW9hSWQmxmpDchiv
         UE4JNbQEmGZ7b5o/CzJgjbhQnsq6R1ZMsFZAZnojBZxVqIg7z0DeJHW3wjVQ3oj3X0X7
         9zMMbEJwgKuNLCTWuset8s2W/9BsXHS7IrswezpPMZkQVPZYqNeJvzPU4/XEJvFsfBnD
         jDZLRmXeRiO0JLOGwotli1/BAneVLeONlI9QuZmR0kLXGg+CLezpqZWG75jfudKL8tbb
         4GPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Rpgp8Qbo8YTkJ7o9V/hmrmF55MqGZvPgztBHYlkkui8=;
        b=hzn0nG/m+1slYyJepAmOr5LPwAJ0kNnMA1AXxXs3G9nu6sqCSrRuX6fGiXLGifKsyU
         5EAnfagG61LGAVpF3/6z3v5PIcpzEazFkyohNuvx88vUTKo8SXFGcVyoo+sPUOKlgI6V
         8XLFTjsXvk5G2fU0QUkbJ4hPqDWf5eb6S7qCeFheE2BvCwPOzT04gLekOb4RN5xCaD0O
         T30k7PXeBgTnBZ1Y/yVfAXFdf/+LZV177cUwn6QvjNdQhrJnMCA59NueSJ5qxIk/tGJ9
         +IYt1JKXyfBL1aBDlXjeKPZrtuA5gBwWCEuoIW/T6HSgtHbzwwFZVJEfSrm3UL3Ie9u8
         oKDw==
X-Gm-Message-State: APjAAAVDKZ8t8P4oKat3fFm9ZpzeEXqyGwdjIz8NioOvNM8k2ODQMmcY
        TGNavAKwj/4taRYfdrhiV4UXHTnyJ+9vWw==
X-Google-Smtp-Source: APXvYqy++5P+27O1RPz0egirFCGrCYas5BiF/vuKe2e/d+DT4WuEaThHpRy06GpvxLuGO/V3IlS5yg==
X-Received: by 2002:a63:4006:: with SMTP id n6mr88793694pga.139.1578074126436;
        Fri, 03 Jan 2020 09:55:26 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id u20sm61516655pgf.29.2020.01.03.09.55.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 09:55:26 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     parav@mellanox.com, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 1/2] ionic: ionic_if bits for sr-iov support
Date:   Fri,  3 Jan 2020 09:55:07 -0800
Message-Id: <20200103175508.32176-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200103175508.32176-1-snelson@pensando.io>
References: <20200103175508.32176-1-snelson@pensando.io>
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
index 39317cdfa6cf..f131adad96e3 100644
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

