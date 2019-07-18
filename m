Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8775A6C4DA
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 04:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388725AbfGRCJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 22:09:10 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38170 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732510AbfGRCJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 22:09:09 -0400
Received: by mail-ot1-f67.google.com with SMTP id d17so27326486oth.5
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 19:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fredlawl-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OcGPHgnMxbI2wU1xT/V0QozYnY7nlRi/cdJFTvYjEvI=;
        b=yDAMvNM9G2xW3IW0xmzcT8InMI5MERjBNmrSwp51Hoa420m8Mm9XuRTbqtYfvP7vK0
         nlkEPsiLCpiErLfpG+gJtl3Guy6jngjiT3ZTKfMf16ZJC/otStBMZNEKqb8CyzPiVwqG
         eGTG+Dh9AkuARboDvIy7rL4h8mc3x1Gm+V8s9t5PVRI2SiFgaAeBb3q6jTV3YAE8q38B
         MhCZoirfl2ymkkF6+xbDMfjTeWcLQX4bFHMOuBkIW4V1LDEMZCrn9jhBWezqGK5jUD5Q
         LOlUrLPSUSoBQcbHzEHqC+SIWA05MhZj0YvzSwtA/XKCMrdMXMSMNsdKLHR5PALS2nCg
         q5EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OcGPHgnMxbI2wU1xT/V0QozYnY7nlRi/cdJFTvYjEvI=;
        b=EoNpPLFruFwELaXD7oeq3vQ8WAUgHUJWhok88X0xHg8IWLdlOVYjdXOkxNUvgpoCPg
         ZAz7+KgYBw7QJRduvlBnXmOiYLKLhksEHYXw75QbGTlrppEODRKUH0YLsp6rP4H6rMDy
         tnpqJX+89VKYJJDjkUvtlqNetjjf1gf+Ep07g+ijUw6ShO5kvo31MV0sxksC7JeSnhIr
         A3HwKZE7fV+dBwCeeG+AogB7pR50oF+nkIqwFUVlkT/ipxqo4LE1G1rOcdYezJh6Es/h
         /nplkHYMqDm0twyTPYgNChhTc2M/+93ce2gcHE6Y/uC0hcj9/wvIdFrnHlvwS4bMRm35
         HYBA==
X-Gm-Message-State: APjAAAX7Psl/0vjVXXV7vCWHghRceZ285pWUU2+dq9tOK+pKuzcgNVq1
        sOh1h4CiM3sVjsj6ONWe8uo=
X-Google-Smtp-Source: APXvYqw92JOeNlZ+0UGonsrxs8jupsg1Scl+YF7mhKztA9j+fbMlWUdrC7J/HxDXpZF3dwfzi5CNgA==
X-Received: by 2002:a9d:70da:: with SMTP id w26mr30907101otj.270.1563415748819;
        Wed, 17 Jul 2019 19:09:08 -0700 (PDT)
Received: from linux.fredlawl.com ([2600:1700:18a0:11d0:18af:e893:6cb0:139a])
        by smtp.gmail.com with ESMTPSA id i11sm8985651oia.9.2019.07.17.19.09.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 19:09:08 -0700 (PDT)
From:   Frederick Lawler <fred@fredlawl.com>
To:     aelior@marvell.com, GR-everest-linux-l2@marvell.com
Cc:     Frederick Lawler <fred@fredlawl.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com
Subject: [PATCH] qed: Prefer pcie_capability_read_word()
Date:   Wed, 17 Jul 2019 21:07:42 -0500
Message-Id: <20190718020745.8867-7-fred@fredlawl.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190718020745.8867-1-fred@fredlawl.com>
References: <20190718020745.8867-1-fred@fredlawl.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 8c0d3a02c130 ("PCI: Add accessors for PCI Express Capability")
added accessors for the PCI Express Capability so that drivers didn't
need to be aware of differences between v1 and v2 of the PCI
Express Capability.

Replace pci_read_config_word() and pci_write_config_word() calls with
pcie_capability_read_word() and pcie_capability_write_word().

Signed-off-by: Frederick Lawler <fred@fredlawl.com>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 7873d6dfd91f..8d8a920c3195 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -530,9 +530,8 @@ static void qed_rdma_init_devinfo(struct qed_hwfn *p_hwfn,
 	SET_FIELD(dev->dev_caps, QED_RDMA_DEV_CAP_LOCAL_INV_FENCE, 1);
 
 	/* Check atomic operations support in PCI configuration space. */
-	pci_read_config_dword(cdev->pdev,
-			      cdev->pdev->pcie_cap + PCI_EXP_DEVCTL2,
-			      &pci_status_control);
+	pcie_capability_read_dword(cdev->pdev, PCI_EXP_DEVCTL2,
+				   &pci_status_control);
 
 	if (pci_status_control & PCI_EXP_DEVCTL2_LTR_EN)
 		SET_FIELD(dev->dev_caps, QED_RDMA_DEV_CAP_ATOMIC_OP, 1);
-- 
2.17.1

