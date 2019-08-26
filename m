Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45B709C81A
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 05:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbfHZDz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 23:55:57 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35783 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbfHZDzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 23:55:55 -0400
Received: by mail-pg1-f195.google.com with SMTP id n4so9736731pgv.2
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 20:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vMyaFdAPvObaskAaZenkTq2frjcbhzS/NncMLj7qXSc=;
        b=LaC4YG/rDpzeykCjmvu8P1R5Zi+SuAzfJGioZAn6QP57e0j83uf0bhbYJvJb2fgaPe
         1yAmzVQ4Vw1ZrqlYAjWKuo2TmZcZOttVVQmeWYBsrOYXQ+06SKJLqMzimUwL8Zos50Kd
         Z9ZnlkhtFNY7FsEx5YTVON91FwZtU46cT2iQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vMyaFdAPvObaskAaZenkTq2frjcbhzS/NncMLj7qXSc=;
        b=VJfxslfxNteNJO5ioaSy83MfGVP9XDLIiH+GXIbuyc3ipWFY40OWqNdOF1xMPcqjOA
         23J3uoHSRg06ZNI1vEE8ERPIX/15fmfrYDSaFTADueuczxB6sfNXcbf5A+SOegoxlWL3
         21qQlkdsfmGsnxN1SteIVVHSqhcWuR0v8ZNdmm5CZqP0Nm9Rvl+NgJQflTXxO+f2tkrh
         XSX9Y4k1EK0fsGAkCPUdVRJYXGWgouSzzu0ij6mCSLIT+y+vzvwNW5pWDzFnHQ7q4std
         YlsNYdStj+O67Bp2RUyQIRRTJ+09Y7Oqv+51GztvakBvU3urxapLW+y9VUFXq6JlilPq
         RbSQ==
X-Gm-Message-State: APjAAAWAwyOrNdZSMgS6zttwJ2IdWI+brjt9d8ahMBIc6kXJqP/uIBCX
        T78u+kyIGjtUAhqMThlVCp2xIg==
X-Google-Smtp-Source: APXvYqzK2chmZu1fVMMHLVlLEyVuBPAuUOgqt146kwe5e8uhmCyFw+lcbx0PEkE5yQv4blUtv60J2g==
X-Received: by 2002:a17:90a:fe0e:: with SMTP id ck14mr4977964pjb.78.1566791754582;
        Sun, 25 Aug 2019 20:55:54 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm8532975pgf.55.2019.08.25.20.55.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 20:55:54 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: [PATCH net-next 03/14] bnxt_en: Refactor bnxt_sriov_enable().
Date:   Sun, 25 Aug 2019 23:54:54 -0400
Message-Id: <1566791705-20473-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the hardware/firmware configuration portion in
bnxt_sriov_enable() into a new function bnxt_cfg_hw_sriov().  This
new function can be called after a firmware reset to reconfigure the
VFs previously enabled.

When VFs need to be reconfigured dynamically after firmwware reset, the
configuration sequence on the PF needs to be changed to register the VF
buffers first.  Otherwise, some VF firmware commands may not succeed as
there may not be PF buffers ready for the re-directed firmware commands.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c | 50 +++++++++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h |  1 +
 2 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 2b90a2b..93524d7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -687,6 +687,32 @@ static int bnxt_func_cfg(struct bnxt *bp, int num_vfs)
 		return bnxt_hwrm_func_cfg(bp, num_vfs);
 }
 
+int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs)
+{
+	int rc;
+
+	/* Register buffers for VFs */
+	rc = bnxt_hwrm_func_buf_rgtr(bp);
+	if (rc)
+		return rc;
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
+	bnxt_ulp_sriov_cfg(bp, *num_vfs);
+	return 0;
+}
+
 static int bnxt_sriov_enable(struct bnxt *bp, int *num_vfs)
 {
 	int rc = 0, vfs_supported;
@@ -752,25 +778,10 @@ static int bnxt_sriov_enable(struct bnxt *bp, int *num_vfs)
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
@@ -1190,6 +1201,13 @@ int bnxt_approve_mac(struct bnxt *bp, u8 *mac, bool strict)
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

