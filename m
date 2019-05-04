Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C80D13991
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbfEDLr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:47:28 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37302 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbfEDLrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:47:24 -0400
Received: by mail-qt1-f193.google.com with SMTP id e2so8081745qtb.4
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kwC47KAXlgublwhwoDQlII4iy62YOVtvEMI8hnmPmAs=;
        b=BGeHzyE+Y8GAAnoGjPxibiJf5ZUQ2EbO92IoHnb3seNOnkZsLZ+dxTn1sSmxo5B7Nm
         feNyi52Fh8jF8M8BVLozK90qTT+nPvs1lcnG9WA6W4rYsDGCiF+FL4Lvz6BkUXY/KxKL
         0mBBx+80qefV5et0NgCrJ7kiqvDXH8ccaLcxwRWUc+zld+gIqfeH39CECYwmkKwOA4ab
         EWDoPhODAUoqAPz7U0UKnOkqJs8ONbNJthYNB3IVFNl7X6hOkNbWXq6de6TF6KN6YFBv
         yIrG3i2xH659gXHmBHcXpmQZISMeyDPSwGTqC4amIP1RAbPoi+Ud1YyQIWZI/+arIqh+
         U6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kwC47KAXlgublwhwoDQlII4iy62YOVtvEMI8hnmPmAs=;
        b=ZxHgWRMJiEaCIWTj7TbsBF9Ce36VmH0zgUzNJpj+1kw5xyL8nhlcldeKeMwOmmSQn3
         0k8BOWaD3NYmhRuzyQNnQrLjhTAHEmjl+tCYtjalv7w9iXb8NdPdJefESwBKzRninmfO
         9tw+BPn8ReXggSST4ZPQV8/4+QhgEC5AMF3nvqDEGCx9I5Vn6J702Y0oOhKpjvtFw3WE
         7wi/7aayJoe+32PPuNc4brF68BL+U/cEXsNEAcJqpf4ripNJ5BG+i4WVcG6DFixW9V0/
         w5UEW9CUtozsHQ2t9/o7RkQkE0c4gfSa3QMBvl2Q9fCVAKW3aRm6hLv9b6q8ndHpMA/B
         mENw==
X-Gm-Message-State: APjAAAVHroTUSyWtI+V3RrEIAp8vqWQlX0SlqcZv94ef+NPN2ui0v/5e
        IWvUlF2mJaKjctSZfJPW/t/FGg==
X-Google-Smtp-Source: APXvYqwglxQbedzrccBuXMYxEXJpE+KMNze7wYSvHZONFi8/lcGpM/U48izSHN3toUwq6roDIC9m9Q==
X-Received: by 2002:ac8:2924:: with SMTP id y33mr12818884qty.212.1556970442950;
        Sat, 04 May 2019 04:47:22 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2847276qkk.17.2019.05.04.04.47.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:47:22 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        gerlitz.or@gmail.com, simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 11/13] nfp: flower: add qos offload framework
Date:   Sat,  4 May 2019 04:46:26 -0700
Message-Id: <20190504114628.14755-12-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504114628.14755-1-jakub.kicinski@netronome.com>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Introduce matchall filter offload infrastructure that is needed to
offload qos features like policing. Subsequent patches will make
use of police-filters for ingress rate limiting.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/Makefile   |  3 ++-
 .../net/ethernet/netronome/nfp/flower/main.h  |  3 +++
 .../ethernet/netronome/nfp/flower/offload.c   |  3 +++
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 21 +++++++++++++++++++
 4 files changed, 29 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/flower/qos_conf.c

diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index 0673f3aa2c8d..87bf784f8e8f 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -43,7 +43,8 @@ nfp-objs += \
 	    flower/match.o \
 	    flower/metadata.o \
 	    flower/offload.o \
-	    flower/tunnel_conf.o
+	    flower/tunnel_conf.o \
+	    flower/qos_conf.o
 endif
 
 ifeq ($(CONFIG_BPF_SYSCALL),y)
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 675f43f06526..16f0b8dcd8e1 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -39,6 +39,7 @@ struct nfp_app;
 #define NFP_FL_NBI_MTU_SETTING		BIT(1)
 #define NFP_FL_FEATS_GENEVE_OPT		BIT(2)
 #define NFP_FL_FEATS_VLAN_PCP		BIT(3)
+#define NFP_FL_FEATS_VF_RLIM		BIT(4)
 #define NFP_FL_FEATS_FLOW_MOD		BIT(5)
 #define NFP_FL_FEATS_FLOW_MERGE		BIT(30)
 #define NFP_FL_FEATS_LAG		BIT(31)
@@ -366,6 +367,8 @@ int nfp_flower_lag_populate_pre_action(struct nfp_app *app,
 				       struct nfp_fl_pre_lag *pre_act);
 int nfp_flower_lag_get_output_id(struct nfp_app *app,
 				 struct net_device *master);
+int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
+				 struct tc_cls_matchall_offload *flow);
 int nfp_flower_reg_indir_block_handler(struct nfp_app *app,
 				       struct net_device *netdev,
 				       unsigned long event);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index aefe211da82c..9c6bcc6e9d68 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1185,6 +1185,9 @@ static int nfp_flower_setup_tc_block_cb(enum tc_setup_type type,
 	case TC_SETUP_CLSFLOWER:
 		return nfp_flower_repr_offload(repr->app, repr->netdev,
 					       type_data);
+	case TC_SETUP_CLSMATCHALL:
+		return nfp_flower_setup_qos_offload(repr->app, repr->netdev,
+						    type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
new file mode 100644
index 000000000000..82422afa9f8b
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#include <net/pkt_cls.h>
+
+#include "cmsg.h"
+#include "main.h"
+
+int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
+				 struct tc_cls_matchall_offload *flow)
+{
+	struct netlink_ext_ack *extack = flow->common.extack;
+	struct nfp_flower_priv *fl_priv = app->priv;
+
+	if (!(fl_priv->flower_ext_feats & NFP_FL_FEATS_VF_RLIM)) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: loaded firmware does not support qos rate limit offload");
+		return -EOPNOTSUPP;
+	}
+
+	return -EOPNOTSUPP;
+}
-- 
2.21.0

