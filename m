Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D6AABD3B
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395057AbfIFQB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:01:28 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36778 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395039AbfIFQBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:01:21 -0400
Received: by mail-wm1-f67.google.com with SMTP id p13so7710521wmh.1
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 09:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rE6GAiRBgWW7MnzCoLNjHkiOiFweW/JGgz+JwOySxVo=;
        b=05mR+ajKBHsmdZIKAyC7CifHuPfM7B5W37b53Il3eSb2rn57stApTBY/6TmSfZR3jP
         BRvxwOSHmg7uy2iCujFVOweOsNDGcoruCbwJapG0mJXDxng0MBxiJrehTsssI2RytH8/
         riu36Rjljgwkxhk6uQ+Pwn99cY10Rdm2KVxxdMTkzL3e4aTltrFxpAcGWrFE0Tx2JowK
         00Oorcp4HROvzCFqLNt3VF7gv+2/YvUaJJfXOUW/RKU0Z5ssLoPE/mQDxwNV9w9iqxIX
         MGfFi38tZy9eQ4083pFoL+agttXObcVQ+uw0ePRRVn3tuFHTSwjc1hF5i9tdHRK02j2s
         NZLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rE6GAiRBgWW7MnzCoLNjHkiOiFweW/JGgz+JwOySxVo=;
        b=pASDhOKXolm6u7oflQ5WviKND4Ggju4QzBJ4qBi4baqaz76kWo3pGUZ+HjU0elqXgI
         l5V2YEzKMpGxocjzmqYC+pU0BWNx3i62NONwXVI4+GV0JPmItjaHR1+zf5jEQmnTG3XP
         9AIrR0RWT0oJJvYm7QIV09FAGLMGe8GbxXhAREn6rr0NMeButTmvuHEru/CZ6DXQtAzu
         xJePlH6eT5lsjhs4o3GE3i+Jom+VIMKZmTWH3tkj0ZlRCTRxqRoC5KYu2w2CAgs+EUO3
         OaQWB4dTsUKX93C0VXB4IZEVXF+omf7YKHMr2hEN2AeBIz7g5nMzRtorG8xZQVldVuTa
         aYHQ==
X-Gm-Message-State: APjAAAWItUSzHreeH69jJlz8uSPZ1zwgLKPxTPHP9nt9SG6BjJuIc2wV
        x0EKcy3soGm34e3uOLu8yOd3hA==
X-Google-Smtp-Source: APXvYqx6l2IWAPTswvDoHqbbyPNFJ8Jkl9ldpJNihJEUfOVCtQXqvUJquCu/U60XEp+/ya4Sof5CJg==
X-Received: by 2002:a7b:c752:: with SMTP id w18mr7568879wmk.129.1567785679053;
        Fri, 06 Sep 2019 09:01:19 -0700 (PDT)
Received: from reginn.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id s1sm8524567wrg.80.2019.09.06.09.01.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 09:01:18 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [net-next 07/11] nfp: add devlink param infrastructure
Date:   Fri,  6 Sep 2019 18:00:57 +0200
Message-Id: <20190906160101.14866-8-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906160101.14866-1-simon.horman@netronome.com>
References: <20190906160101.14866-1-simon.horman@netronome.com>
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

