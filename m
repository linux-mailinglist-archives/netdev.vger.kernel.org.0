Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C16DFAD14C
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 01:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731644AbfIHXzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 19:55:05 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34519 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731610AbfIHXzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 19:55:04 -0400
Received: by mail-qk1-f193.google.com with SMTP id q203so11376634qke.1
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 16:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/x8fezSSUhC/hAIW4Lx/qChUcik2wbuWNo0PZEZhMV4=;
        b=kkHyCbMXPbuK3vmy5/uUDACgVvCNaAxKzGt11bTUtp5jYyfaOkhVjzrDoM2cL707SZ
         zRPFNB/eSDDpYskGgaiWGRy1D8IojwESO8x3bNyRP/0dcsEs63qzDn+Omq4KJ4RFHsEE
         DZku1FSZkygr1B43GJksEKwCM5s0cT2cvycXOF14MglOqdNBplvuWFOILTUlc5vPzw1o
         j8qQAslZoS9A5K6+zU/JPSYMQLvOqnYxs3mElRxf8/0VrKnvRo/00GWgmBLRRr8YL4cW
         oQNfXhqEuOlrPRSZ0pIzvUGw/+kbCfoVzgoW2aGt3zz8YohD1fnYgFOdHor9gLs7XJ0M
         OgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/x8fezSSUhC/hAIW4Lx/qChUcik2wbuWNo0PZEZhMV4=;
        b=H2PlOwtv/mdkx6XLIJlSNSq1OU5v6ByJe1sWNwLhwQ1UFxENsWkovqdngbIfIOHDT1
         BMQLu+Xz0zVzU963O8UmBiji5PHJUeqpV7cubreid8Sfwqt+moE7kxKgFEoHomhQgUDW
         E35xDLwjMldU/dj7BjONt68zIqKv+n1FDldQMKwDPL7fVuYOcK1LCTThvMelPqD3X+dx
         0zaHpmw4gbXVMOdzaMQblQI9jEKOQuja+6/+c4CZmcoTENr6ax0B2pPCbsCOMgqJRRPd
         3ZGfisdhjMQTyazbz7pcovna657Rm2UbY+dxvi34GMDQ2gRjVIYRLJYns9z1p8D+11wd
         fwjQ==
X-Gm-Message-State: APjAAAWlmXzPV52f0aoCJOvfQ06vtqXMEXqwCQb/5j/pj6D5GFICI1I6
        sVGymIJGgqniYnt1Y010Z/paBEdMI83fCA==
X-Google-Smtp-Source: APXvYqwbnKYmabeipR8rVFjfDdx4tnVzSk24/9kYIOJjqJFf+I3+4ctuYZggkyJqK7SlFjR2K71oKg==
X-Received: by 2002:a37:6358:: with SMTP id x85mr21556571qkb.229.1567986902689;
        Sun, 08 Sep 2019 16:55:02 -0700 (PDT)
Received: from penelope.pa.netronome.com (195-23-252-147.net.novis.pt. [195.23.252.147])
        by smtp.gmail.com with ESMTPSA id p27sm5464406qkm.92.2019.09.08.16.55.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 16:55:02 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next v2 07/11] nfp: add devlink param infrastructure
Date:   Mon,  9 Sep 2019 00:54:23 +0100
Message-Id: <20190908235427.9757-8-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190908235427.9757-1-simon.horman@netronome.com>
References: <20190908235427.9757-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Register devlink parameters for driver use. Subsequent patches will add
support for specific parameters.

In order to support devlink parameters, the management firmware needs to
be able to lookup and set hwinfo keys.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/Makefile        |  1 +
 drivers/net/ethernet/netronome/nfp/devlink_param.c | 60 ++++++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfp_main.h      |  3 ++
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c  |  7 +++
 4 files changed, 71 insertions(+)
 create mode 100644 drivers/net/ethernet/netronome/nfp/devlink_param.c

diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index 2805641965f3..d31772ae511d 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -17,6 +17,7 @@ nfp-objs := \
 	    nfpcore/nfp_target.o \
 	    ccm.o \
 	    ccm_mbox.o \
+	    devlink_param.o \
 	    nfp_asm.o \
 	    nfp_app.o \
 	    nfp_app_nic.o \
diff --git a/drivers/net/ethernet/netronome/nfp/devlink_param.c b/drivers/net/ethernet/netronome/nfp/devlink_param.c
new file mode 100644
index 000000000000..aece98586e32
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/devlink_param.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#include <net/devlink.h>
+
+#include "nfpcore/nfp_nsp.h"
+#include "nfp_main.h"
+
+static const struct devlink_param nfp_devlink_params[] = {
+};
+
+static int nfp_devlink_supports_params(struct nfp_pf *pf)
+{
+	struct nfp_nsp *nsp;
+	bool supported;
+	int err;
+
+	nsp = nfp_nsp_open(pf->cpp);
+	if (IS_ERR(nsp)) {
+		err = PTR_ERR(nsp);
+		dev_err(&pf->pdev->dev, "Failed to access the NSP: %d\n", err);
+		return err;
+	}
+
+	supported = nfp_nsp_has_hwinfo_lookup(nsp) &&
+		    nfp_nsp_has_hwinfo_set(nsp);
+
+	nfp_nsp_close(nsp);
+	return supported;
+}
+
+int nfp_devlink_params_register(struct nfp_pf *pf)
+{
+	struct devlink *devlink = priv_to_devlink(pf);
+	int err;
+
+	err = nfp_devlink_supports_params(pf);
+	if (err <= 0)
+		return err;
+
+	err = devlink_params_register(devlink, nfp_devlink_params,
+				      ARRAY_SIZE(nfp_devlink_params));
+	if (err)
+		return err;
+
+	devlink_params_publish(devlink);
+	return 0;
+}
+
+void nfp_devlink_params_unregister(struct nfp_pf *pf)
+{
+	int err;
+
+	err = nfp_devlink_supports_params(pf);
+	if (err <= 0)
+		return;
+
+	devlink_params_unregister(priv_to_devlink(pf), nfp_devlink_params,
+				  ARRAY_SIZE(nfp_devlink_params));
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
index bd6450b0f23f..5d5812fd9317 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -187,4 +187,7 @@ int nfp_shared_buf_pool_get(struct nfp_pf *pf, unsigned int sb, u16 pool_index,
 int nfp_shared_buf_pool_set(struct nfp_pf *pf, unsigned int sb,
 			    u16 pool_index, u32 size,
 			    enum devlink_sb_threshold_type threshold_type);
+
+int nfp_devlink_params_register(struct nfp_pf *pf);
+void nfp_devlink_params_unregister(struct nfp_pf *pf);
 #endif /* NFP_MAIN_H */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index 986464d4a206..47addac104fe 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -711,6 +711,10 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	if (err)
 		goto err_devlink_unreg;
 
+	err = nfp_devlink_params_register(pf);
+	if (err)
+		goto err_shared_buf_unreg;
+
 	mutex_lock(&pf->lock);
 	pf->ddir = nfp_net_debugfs_device_add(pf->pdev);
 
@@ -744,6 +748,8 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 err_clean_ddir:
 	nfp_net_debugfs_dir_clean(&pf->ddir);
 	mutex_unlock(&pf->lock);
+	nfp_devlink_params_unregister(pf);
+err_shared_buf_unreg:
 	nfp_shared_buf_unregister(pf);
 err_devlink_unreg:
 	cancel_work_sync(&pf->port_refresh_work);
@@ -773,6 +779,7 @@ void nfp_net_pci_remove(struct nfp_pf *pf)
 
 	mutex_unlock(&pf->lock);
 
+	nfp_devlink_params_unregister(pf);
 	nfp_shared_buf_unregister(pf);
 	devlink_unregister(priv_to_devlink(pf));
 
-- 
2.11.0

