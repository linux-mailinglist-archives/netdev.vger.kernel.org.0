Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90A2511EAC1
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbfLMSz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:55:26 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45117 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728552AbfLMSzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:55:24 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so1913549pfg.12
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 10:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WQ7i3wEHPVScRF24Du/iSEpENcZHH/jRwDanl3Y3k9o=;
        b=GtzDxJPQ9owEl5Kuh7HS6lF6z+d/A/A0Ed4o/+dp+75lcQNPgOcGl5MWXwMqxwkgQZ
         VtKwv1/h5YJY9Sy7T8qqf8/rzCmi3VsmguekRLz+Q5kkrsOWVbpG/6aZYUqkskwYW7vf
         fl/4FRjjhfA3nbvL6uAs9P7xczthQ22ta09Xp5ZCUMBb7INLTtYCA5WL+F0f+e7F/HTl
         D1c0wK4OWQTawPDeZ062PiLlD7cCTlJ7iZ0Q30P8W/PQo7snwmdzsBnGscB4w9NIWlhM
         Vn7u6LwkKlu66XRP8v/7J87CJg75vnNtcetsDBQKZYV6JaxRuX8E2JnCGNfohCPYVV+K
         0MCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WQ7i3wEHPVScRF24Du/iSEpENcZHH/jRwDanl3Y3k9o=;
        b=knpXB8/l6h/HysSPxV6D6a7CzerwF8sSS7tFPWNe+Q4BBZ7Z8E0dtmEgaCTjKxICbT
         AdKw+12eVw5+7U5IjeIzwaL+cmtbAxRR6JKNLQ1SDLvREcsMgRfFxq3LkV3PzEtcgSQo
         DRqHy8dH9OdbnvYHDmeAYxY30BrbsAAbPt7lrnslY71sk8Z0mlsZs0o2wAviNlN5XSKt
         RY7KcNeE63xhkZUKP/6tSdefUC1hft0pzoSBhzsasbdsHU2nBK/mIY3IYm9iJqjCYEbV
         WHKsiRBuv8IHhaXDYKlgWMP+PwmjIfH7U96Gm352XSWD57IZnd9C9D5Gy2DlYZYzlKBF
         c2+g==
X-Gm-Message-State: APjAAAVyOs+WOZPiizM7x5kd7plL+zUFFGuuzUhlNDAmh7CyY62svivF
        ZUfNKlAro5YYBLoBBQVY7E5TAVOl/is=
X-Google-Smtp-Source: APXvYqyqReqnDgKiugiSoOd/+Pp96uKLkcSIQwWzzB2B0awEaR9tMnpC7GooRzFEEMiA5As2C1nWGw==
X-Received: by 2002:a63:cf41:: with SMTP id b1mr968880pgj.53.1576263323798;
        Fri, 13 Dec 2019 10:55:23 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id n26sm12609003pgd.46.2019.12.13.10.55.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 10:55:23 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     parav@mellanox.com, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 1/2] ionic: ionic_if bits for sr-iov support
Date:   Fri, 13 Dec 2019 10:55:15 -0800
Message-Id: <20191213185516.52087-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191213185516.52087-1-snelson@pensando.io>
References: <20191213185516.52087-1-snelson@pensando.io>
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

