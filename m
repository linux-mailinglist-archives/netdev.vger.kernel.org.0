Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468D42A6B39
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731961AbgKDQ6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731501AbgKDQ5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:57:33 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729E8C0613D3;
        Wed,  4 Nov 2020 08:57:33 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id v4so23193574edi.0;
        Wed, 04 Nov 2020 08:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EDL7iVITnjN2zqIR3rWp5y3OBXWBH+5pWTBqHVdSlTo=;
        b=gtFBMLxZHtZNE0AYm40OxttgGXm7IFqOY0WBvL+G4zWOwdMAD+tt/ftHnu82I5HSpC
         X+JdsywwHoTS28rCwaOvKgb+GJ5mcvVsZaNdl+CGJmdp6iY7Lh8+weCJRQks3esWTNRQ
         QVSN7c4b5HG8mwvIfIKjmVkxnZxywqCgmeAA1xqd2L0YIUGE0ZZPRgc7APjOTiK4luBD
         pCQbcOVcDSqDNqkMyEdejgvmVz3s/aIBj5O1Ntcu0M8Xja87yY/q3/8UJ87Jc+IVv7kG
         g8+SBe6w9ms2HUxfhi69IsUJELh4LDv4tYUalLcciTAlJe7R8Lqn+96FBwZFh39ji5M4
         mZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EDL7iVITnjN2zqIR3rWp5y3OBXWBH+5pWTBqHVdSlTo=;
        b=qIAyjqLzEnhBLHDTMLaAuYsTQeppIstSPCvktLdD0TSmnqrPFt0XnBlM80lsSnUQAx
         vttCfCOMUq3W/74jrLcZf4N+nwfoHaof5nyYjHS3Cy/QULCngjwYehXIDWF6H56mFdw5
         vG6MnwSNnIRjcfwW9RFHkVtkwy3HfxC648Ld3IsIG3lTyl1k427a40WiBGteObp0/hPp
         O92kjF/c57NBpQlfcbPJZCPPqZi+Wd/ObOHMBQcJAAugaL05atnssdIsV/+nIM0Io+7J
         I2DfaTMkQ5FTdzJrLUmNcSwITu/ZoZwJFigJ0LiLcUwc7/Y4cmnI2ix62pu2n7BivnsM
         li3Q==
X-Gm-Message-State: AOAM5334N9A01aRdPKS1766G1VjOZ7jOsp6luevnXhVdQi7+gxhjUqeQ
        aK3pAydgkjhX7muJ+g6o7Up7ARizu6nQiA==
X-Google-Smtp-Source: ABdhPJzTPNJEtTD4JBSI0iHdcYsel5EeOaH7D1I4W5OLcu3F8xeHlVKxMjhrU6/JZugnorjJ4BsgXA==
X-Received: by 2002:a05:6402:b68:: with SMTP id cb8mr6358861edb.198.1604509052131;
        Wed, 04 Nov 2020 08:57:32 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l12sm1354748edt.46.2020.11.04.08.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 08:57:31 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC 3/9] staging: dpaa2-switch: setup RX path rings
Date:   Wed,  4 Nov 2020 18:57:14 +0200
Message-Id: <20201104165720.2566399-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104165720.2566399-1-ciorneiioana@gmail.com>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

On the Rx path, when a pull-dequeue operation is performed on a
software portal, available frame descriptors are put in a ring - a DMA
memory storage - for further usage. Create the needed rings for both
frame queues used on the control interface.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c | 37 +++++++++++++++++++++++++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h |  4 +++
 2 files changed, 41 insertions(+)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 21d3ff6b9f55..d81961d36821 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -1580,6 +1580,33 @@ static void dpaa2_switch_free_dpbp(struct ethsw_core *ethsw)
 	fsl_mc_object_free(ethsw->dpbp_dev);
 }
 
+static int dpaa2_switch_alloc_rings(struct ethsw_core *ethsw)
+{
+	int i;
+
+	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++) {
+		ethsw->fq[i].store =
+			dpaa2_io_store_create(DPAA2_SWITCH_STORE_SIZE,
+					      ethsw->dev);
+		if (!ethsw->fq[i].store) {
+			dev_err(ethsw->dev, "dpaa2_io_store_create failed\n");
+			while (--i >= 0)
+				dpaa2_io_store_destroy(ethsw->fq[i].store);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+static void dpaa2_switch_destroy_rings(struct ethsw_core *ethsw)
+{
+	int i;
+
+	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++)
+		dpaa2_io_store_destroy(ethsw->fq[i].store);
+}
+
 static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 {
 	int err;
@@ -1594,7 +1621,16 @@ static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 	if (err)
 		return err;
 
+	err = dpaa2_switch_alloc_rings(ethsw);
+	if (err)
+		goto err_free_dpbp;
+
 	return 0;
+
+err_free_dpbp:
+	dpaa2_switch_free_dpbp(ethsw);
+
+	return err;
 }
 
 static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
@@ -1777,6 +1813,7 @@ static void dpaa2_switch_takedown(struct fsl_mc_device *sw_dev)
 
 static void dpaa2_switch_ctrl_if_teardown(struct ethsw_core *ethsw)
 {
+	dpaa2_switch_destroy_rings(ethsw);
 	dpaa2_switch_free_dpbp(ethsw);
 }
 
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index 84130134aa67..b476f9ac4c55 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -18,6 +18,7 @@
 #include <net/switchdev.h>
 #include <linux/if_bridge.h>
 #include <linux/fsl/mc.h>
+#include <soc/fsl/dpaa2-io.h>
 
 #include "dpsw.h"
 
@@ -50,6 +51,8 @@
 #define DPAA2_SWITCH_RX_BUF_SIZE \
 	(DPAA2_SWITCH_RX_BUF_RAW_SIZE - DPAA2_SWITCH_RX_BUF_TAILROOM)
 
+#define DPAA2_SWITCH_STORE_SIZE 16
+
 extern const struct ethtool_ops dpaa2_switch_port_ethtool_ops;
 
 struct ethsw_core;
@@ -57,6 +60,7 @@ struct ethsw_core;
 struct dpaa2_switch_fq {
 	struct ethsw_core *ethsw;
 	enum dpsw_queue_type type;
+	struct dpaa2_io_store *store;
 	u32 fqid;
 };
 
-- 
2.28.0

