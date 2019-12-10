Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18731118180
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfLJHt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:49:29 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36943 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727143AbfLJHt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 02:49:28 -0500
Received: by mail-pl1-f196.google.com with SMTP id c23so1673442plz.4
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 23:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6GYwITJ/hafA9IsMqxAZq/f4KuH0h1Tzagek6KTyspI=;
        b=bRZs/qNHa2NeSywzNwv612OS54b+YcbR/Smr1SPafDKoIeUdp+39T2Z3ol8po0hZA2
         DpYE8M3vnoqRENOC3HOpq4Yj13zsWSmXoeZ6uLAhJ5OZQShZ3RLhBS/x6nGt/R+Ajq9C
         IViKG6rL1rt0xsi3glfxRbaGp1IXbCa+f7duI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6GYwITJ/hafA9IsMqxAZq/f4KuH0h1Tzagek6KTyspI=;
        b=DpozyAqVO5zqefx4ymyt3VMM/AxUq7+h2Ig5e7sw1rx/toU8QEqIHUMTgV0YiqqyWp
         fkuxp7ZCH5w/m2EPRDtcxsVGuxkjxaRGjmBepf10QzE3qubhGH6iuFE6Ams4pGYakbC0
         mUIqEERvtvg5qFzlFw/9h3sCFAcUA2wgfSUOdgt5+cBU3aHdAybqAaj1uhUFurC0drfK
         NGlmSApoLtVBcopdVe6VOffFrQJztgvwRjfX099yPXKyzBxCNQaQ3+p6eqh92RFEuB9e
         ztyo3iG7G6ax5gtmEM7pP0Zf/DUKA9g/86ELscMN9EW53mXNV+H2C9ZcdJ/YbeXAK6CB
         ypXw==
X-Gm-Message-State: APjAAAXQX7EhCRV4b9f3frfmlVlJWHFFPp0QJUTojVKYUxQhV5MTb33M
        Tp9HwCiZwJ3fJaGW33h4NYF33jnNT+0=
X-Google-Smtp-Source: APXvYqzgqRI649lDU7G9BMBXWFrdE53+3yiY8JdurJUxRo1/S8pSqOfUiog06pb4DjIHvxqiP/8/Bw==
X-Received: by 2002:a17:902:6b82:: with SMTP id p2mr32351147plk.4.1575964167979;
        Mon, 09 Dec 2019 23:49:27 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z29sm2108101pge.21.2019.12.09.23.49.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Dec 2019 23:49:27 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 1/7] bnxt_en: Fix MSIX request logic for RDMA driver.
Date:   Tue, 10 Dec 2019 02:49:07 -0500
Message-Id: <1575964153-11299-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1575964153-11299-1-git-send-email-michael.chan@broadcom.com>
References: <1575964153-11299-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The logic needs to check both bp->total_irqs and the reserved IRQs in
hw_resc->resv_irqs if applicable and see if both are enough to cover
the L2 and RDMA requested vectors.  The current code is only checking
bp->total_irqs and can fail in some code paths, such as the TX timeout
code path with the RDMA driver requesting vectors after recovery.  In
this code path, we have not reserved enough MSIX resources for the
RDMA driver yet.

Fixes: 75720e6323a1 ("bnxt_en: Keep track of reserved IRQs.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index c601ff7..4a316c4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -113,8 +113,10 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
+	struct bnxt_hw_resc *hw_resc;
 	int max_idx, max_cp_rings;
 	int avail_msix, idx;
+	int total_vecs;
 	int rc = 0;
 
 	ASSERT_RTNL();
@@ -142,7 +144,10 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 	}
 	edev->ulp_tbl[ulp_id].msix_base = idx;
 	edev->ulp_tbl[ulp_id].msix_requested = avail_msix;
-	if (bp->total_irqs < (idx + avail_msix)) {
+	hw_resc = &bp->hw_resc;
+	total_vecs = idx + avail_msix;
+	if (bp->total_irqs < total_vecs ||
+	    (BNXT_NEW_RM(bp) && hw_resc->resv_irqs < total_vecs)) {
 		if (netif_running(dev)) {
 			bnxt_close_nic(bp, true, false);
 			rc = bnxt_open_nic(bp, true, false);
@@ -156,7 +161,6 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 	}
 
 	if (BNXT_NEW_RM(bp)) {
-		struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
 		int resv_msix;
 
 		resv_msix = hw_resc->resv_irqs - bp->cp_nr_rings;
-- 
2.5.1

