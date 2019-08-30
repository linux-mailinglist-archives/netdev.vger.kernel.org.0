Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98289A2DAB
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfH3Dzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:55:43 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43252 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbfH3Dzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:39 -0400
Received: by mail-pl1-f194.google.com with SMTP id 4so2671505pld.10
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cefifApBnyRJ23wAhiPOa4r2DMtLG/vYb5sWdp1MCeE=;
        b=Z73G14v8D6Waw2pfL7xuZgD2vwlWRlg5BIpFFPX74/O7KtP+vsjO1PKftvzyRnRdqf
         2u/595WBVoPrb0+QmhoPej/VtiSbAx2Yc9FIpzNHOxEtigdUqCOXyMmQMN6Xs6hSTPYa
         zQ7DrbMh4elJjFZJQvxbJ4DagMGC+pqEvaUuE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cefifApBnyRJ23wAhiPOa4r2DMtLG/vYb5sWdp1MCeE=;
        b=IxLUkQZvqM2l1Imo20q882tKXx0iiURCnLuuS4+QR7EehXxUv/Qt9SJzGgNdmijKxz
         90cfmi8yKsLlxMNRQJce06OdP4LMDYqzlxXtH/dy+klypsLUPIJthQZ0nlabamePi+8k
         h23HxzX4un2oUGKxDNgHc7QoddYebQ0rXoJGH4OE1W57qHDJI8mCMe4AsOkmnnutzh9W
         ia/5i13qG2cCXyZG4yswmelCNlYyis2Mty89Nw+qTa9qbqhfxPyEdOJbNvf5UyMZ1mUv
         ElhaW1HBRWsHNMu+VIpXWVWgz3qzp18YtzmIfxjXKu63rrWa+AYKrmID1k8/+SitRpJX
         h44A==
X-Gm-Message-State: APjAAAWeX1KY5JZon2mQJ1STBPadw4oV18hRXnk/NUU8KmJpUuvJyM/i
        FtKbrIYikJM8LoVHHw6SjSST40e4tX8=
X-Google-Smtp-Source: APXvYqyA5TJxdL1PbMT5VtI7HgueZle20uXjsxjLXczA9qgm903bXghAMEH8BCQAd/wYgoTYfAmbsQ==
X-Received: by 2002:a17:902:f216:: with SMTP id gn22mr14267066plb.59.1567137339000;
        Thu, 29 Aug 2019 20:55:39 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:38 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 07/22] bnxt_en: Refactor bnxt_sriov_enable().
Date:   Thu, 29 Aug 2019 23:54:50 -0400
Message-Id: <1567137305-5853-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the hardware/firmware configuration portion in
bnxt_sriov_enable() into a new function bnxt_cfg_hw_sriov().  This
new function can be called after a firmware reset to reconfigure the
VFs previously enabled.

v2: straight refactor of the code.  Reordering done in the next patch.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c | 50 +++++++++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h |  1 +
 2 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index b6a84d0..7506d20 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -667,6 +667,32 @@ static int bnxt_func_cfg(struct bnxt *bp, int num_vfs)
 		return bnxt_hwrm_func_cfg(bp, num_vfs);
 }
 
+int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs)
+{
+	int rc;
+
+	/* Reserve resources for VFs */
+	rc = bnxt_func_cfg(bp, *num_vfs);
+	if (rc != *num_vfs) {
+		if (rc <= 0) {
+			netdev_warn(bp->dev, "Unable to reserve resources for SRIOV.\n");
+			*num_vfs = 0;
+			return rc;
+		}
+		netdev_warn(bp->dev, "Only able to reserve resources for %d VFs.\n",
+			    rc);
+		*num_vfs = rc;
+	}
+
+	/* Register buffers for VFs */
+	rc = bnxt_hwrm_func_buf_rgtr(bp);
+	if (rc)
+		return rc;
+
+	bnxt_ulp_sriov_cfg(bp, *num_vfs);
+	return 0;
+}
+
 static int bnxt_sriov_enable(struct bnxt *bp, int *num_vfs)
 {
 	int rc = 0, vfs_supported;
@@ -732,25 +758,10 @@ static int bnxt_sriov_enable(struct bnxt *bp, int *num_vfs)
 	if (rc)
 		goto err_out1;
 
-	/* Reserve resources for VFs */
-	rc = bnxt_func_cfg(bp, *num_vfs);
-	if (rc != *num_vfs) {
-		if (rc <= 0) {
-			netdev_warn(bp->dev, "Unable to reserve resources for SRIOV.\n");
-			*num_vfs = 0;
-			goto err_out2;
-		}
-		netdev_warn(bp->dev, "Only able to reserve resources for %d VFs.\n", rc);
-		*num_vfs = rc;
-	}
-
-	/* Register buffers for VFs */
-	rc = bnxt_hwrm_func_buf_rgtr(bp);
+	rc = bnxt_cfg_hw_sriov(bp, num_vfs);
 	if (rc)
 		goto err_out2;
 
-	bnxt_ulp_sriov_cfg(bp, *num_vfs);
-
 	rc = pci_enable_sriov(bp->pdev, *num_vfs);
 	if (rc)
 		goto err_out2;
@@ -1128,6 +1139,13 @@ int bnxt_approve_mac(struct bnxt *bp, u8 *mac, bool strict)
 }
 #else
 
+int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs)
+{
+	if (*num_vfs)
+		return -EOPNOTSUPP;
+	return 0;
+}
+
 void bnxt_sriov_disable(struct bnxt *bp)
 {
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h
index 2eed9ed..0abf18e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h
@@ -36,6 +36,7 @@ int bnxt_set_vf_link_state(struct net_device *, int, int);
 int bnxt_set_vf_spoofchk(struct net_device *, int, bool);
 int bnxt_set_vf_trust(struct net_device *dev, int vf_id, bool trust);
 int bnxt_sriov_configure(struct pci_dev *pdev, int num_vfs);
+int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs);
 void bnxt_sriov_disable(struct bnxt *);
 void bnxt_hwrm_exec_fwd_req(struct bnxt *);
 void bnxt_update_vf_mac(struct bnxt *);
-- 
2.5.1

