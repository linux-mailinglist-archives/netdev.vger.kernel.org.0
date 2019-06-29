Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1F25AC20
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 17:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfF2PRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 11:17:21 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37963 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfF2PRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 11:17:21 -0400
Received: by mail-pf1-f193.google.com with SMTP id y15so4420635pfn.5
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 08:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JFOw3VMsdqmGryCD4Peh9hH3bFiND6Nf+7Q9qzwwG6A=;
        b=btV0S71x8zSXS51uilKc6w9hQ9C2+zpNI2Ejd3IUmkI2pk2asBixTMNEXbB/QGuay5
         TXhcimG/KjknGvg+1R4P6RNGgLaybaA4ZU9EBxwPMaPn1dlbtQG8QchAgWce427trvLF
         /ZTjSaQeRbQGPd4lWlXYQybyTM2E5dUtk3wjw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JFOw3VMsdqmGryCD4Peh9hH3bFiND6Nf+7Q9qzwwG6A=;
        b=Xes0tMrqw6hPLei2p0ErmHSlliDaKwycI1Uhb49PacERDjUq2oWeLX0LnAdsLm1wkO
         VAO7YVoWw3RuK6BgO6TJ0oLwD5dcTyB3rjcBEBMAujqKinqYicQT1T/PlZd8j5H2cT6K
         wUlGterMH5t1h1prj6zedF+UhdwVHRqjYv//qgIJJzrKEGx+rcjq5yxDrkuodTwfP1ZH
         VlOFQRSCxDnO0mWxNRitsZJU+bi+QZSXGbXKY/v+jegu5wF6G3nVE/Q5D5xKBnFRFn9E
         0GnTFEFHKbGHF5/yZ0qkUpkDek+6Xs54Dtf0X7+MYivHTUHYGsDNSnYZsRq9XwIlZ5j6
         xRtg==
X-Gm-Message-State: APjAAAUqaJDR2dZl/k6dM16hTpTnccp8khGrVJqWdC0/i+OT3qIppmje
        uo5c39zpWWnTH0TaI6VqAhizPA==
X-Google-Smtp-Source: APXvYqza0/Go/P52ycu0wnXM/iM08lmG2K9aFeUc2cFqNQx16mWBrhQ0X6OqhllPkOi1Nygv3oix1A==
X-Received: by 2002:a63:c342:: with SMTP id e2mr1424770pgd.79.1561821440126;
        Sat, 29 Jun 2019 08:17:20 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z14sm5048233pgs.79.2019.06.29.08.17.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jun 2019 08:17:19 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 4/5] bnxt_en: Cap the returned MSIX vectors to the RDMA driver.
Date:   Sat, 29 Jun 2019 11:16:47 -0400
Message-Id: <1561821408-17418-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561821408-17418-1-git-send-email-michael.chan@broadcom.com>
References: <1561821408-17418-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In an earlier commit to improve NQ reservations on 57500 chips, we
set the resv_irqs on the 57500 VFs to the fixed value assigned by
the PF regardless of how many are actually used.  The current
code assumes that resv_irqs minus the ones used by the network driver
must be the ones for the RDMA driver.  This is no longer true and
we may return more MSIX vectors than requested, causing inconsistency.
Fix it by capping the value.

Fixes: 01989c6b69d9 ("bnxt_en: Improve NQ reservations.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index bfa342a..fc77caf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -157,8 +157,10 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 
 	if (BNXT_NEW_RM(bp)) {
 		struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
+		int resv_msix;
 
-		avail_msix = hw_resc->resv_irqs - bp->cp_nr_rings;
+		resv_msix = hw_resc->resv_irqs - bp->cp_nr_rings;
+		avail_msix = min_t(int, resv_msix, avail_msix);
 		edev->ulp_tbl[ulp_id].msix_requested = avail_msix;
 	}
 	bnxt_fill_msix_vecs(bp, ent);
-- 
2.5.1

