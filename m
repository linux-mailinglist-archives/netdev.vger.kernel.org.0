Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBB6A2DAD
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfH3Dzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:55:47 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46518 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbfH3Dzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:40 -0400
Received: by mail-pl1-f194.google.com with SMTP id o3so2660111plb.13
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o/CRMXlLikre6goWj0CyJpQp9oXx3DDQwfaW/dX3+j4=;
        b=bkI8p8gZ5APrpyWDheI3Re0X0SMqVqb2FNPeMhxVyHhBon5BsxdIwKsO3Xwc0i9tX6
         2S83yrYxW9XUGa5nB4WtGZHtWGjLIZbZEKlqqmEOBLKyNwUQ9HGctws8JFIJut57aUop
         HKHwdb4xGyszp4aiSkNoS7//L4XGKAlbJn3SM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o/CRMXlLikre6goWj0CyJpQp9oXx3DDQwfaW/dX3+j4=;
        b=et5intyt4wVCsCPxAWYdA2MKaXR1aIF8MGjksR47LOAPq/8RuI8o0xRSxKdDTLGIKU
         zAGj+7cWrRbgRT2OCma97ZaNXmH2FzWaE56A9tjR8zVVYzDaRte1ZlHNvG1u/vdEwI8V
         BDP6ckNNcTHaCEGQdTyJdWziXjNpc8dxoqKZFqwVcRqVcIwwiKRNpOFJRHPyFASfehnj
         cuQQiww3Aq1jGnSXWESPwmGpb2WV+iOOfM3SxfXOWfmXgvqm0wuh+vjIQwKycK8V275+
         bByKDvXazkBQ5Q0WxhRr87rV/TcpeAL8L/6rEpI1+dS0yKJQOjrmyxF5UP6sn5c7rw3c
         GNMw==
X-Gm-Message-State: APjAAAX2JSQwLOs5tKuxsSkuv8BTqSzOIaxLygvdMRBx/L4mEuIy8RtP
        KmIM9fHj56C0IenBXr3X4BkiERv5Oy8=
X-Google-Smtp-Source: APXvYqy5RwwpR58PX6cWb7LQ9EjaUHknS9uDP7VlSyvW3TdmgzSRPHsbEQUDYXhE+lntRJbB41J2vQ==
X-Received: by 2002:a17:902:1105:: with SMTP id d5mr13864809pla.197.1567137339924;
        Thu, 29 Aug 2019 20:55:39 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:39 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 08/22] bnxt_en: Register buffers for VFs before reserving resources.
Date:   Thu, 29 Aug 2019 23:54:51 -0400
Message-Id: <1567137305-5853-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

When VFs need to be reconfigured dynamically after firmwware reset, the
configuration sequence on the PF needs to be changed to register the VF
buffers first.  Otherwise, some VF firmware commands may not succeed as
there may not be PF buffers ready for the re-directed firmware commands.

This sequencing did not matter much before when we only supported
the normal bring-up of VFs.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 7506d20..ac890ca 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -671,6 +671,11 @@ int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs)
 {
 	int rc;
 
+	/* Register buffers for VFs */
+	rc = bnxt_hwrm_func_buf_rgtr(bp);
+	if (rc)
+		return rc;
+
 	/* Reserve resources for VFs */
 	rc = bnxt_func_cfg(bp, *num_vfs);
 	if (rc != *num_vfs) {
@@ -684,11 +689,6 @@ int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs)
 		*num_vfs = rc;
 	}
 
-	/* Register buffers for VFs */
-	rc = bnxt_hwrm_func_buf_rgtr(bp);
-	if (rc)
-		return rc;
-
 	bnxt_ulp_sriov_cfg(bp, *num_vfs);
 	return 0;
 }
-- 
2.5.1

