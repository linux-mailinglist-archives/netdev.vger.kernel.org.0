Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9FA1C60B8
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgEETFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:05:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37090 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727083AbgEETFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:05:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588705503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=U4GrP7XNU8L0g24slP3Y9dEDs+NkxIqN98lAYXvDGmU=;
        b=PRh4d0aeq4rTB2eB1x12BqHpVdDkxqOQveZcubcGV+XCGS1wkaGtzwT5anGFvir5Xmx+TR
        7iUB8zuA9J6eHT9HBQtKSKvM1M7O82/+nUNiBbWuO3yySJ4YvBUJ7o/8UX8bfrrj53DjNh
        v/ddbv2wTp64J6PFTfxCaHkbfXFS06E=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-fOKvQ7LNM9GtuHqoYmRgDg-1; Tue, 05 May 2020 15:05:01 -0400
X-MC-Unique: fOKvQ7LNM9GtuHqoYmRgDg-1
Received: by mail-pl1-f200.google.com with SMTP id c13so2661652plq.22
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 12:05:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U4GrP7XNU8L0g24slP3Y9dEDs+NkxIqN98lAYXvDGmU=;
        b=Mk/cCbzqjkO8vtzqWGO0YGcGNdAkksp8D+7MMFIh58M/qQ1plLNDSAnJqNt73v7GbD
         s+70cz7mFUAXVjpQcKT8LZ+jrz8dBH/3cs+9l9oy4i1a1vIglgAdaGUDx5h7PFIXndPL
         1eHomXTAcZieu4lb4GusIr/55qN308u2ftkst3qHDgW8eLPjJn5bYWfS4vGdH7fs3atz
         tW2ajGkrzEI7o+gSRizmrBVcP4nHW+Nrhrac5JNokfirspPFuaqb9U/qvrZTeoNoQymX
         CBrPCqCjMXTYlywE5cZHjcqnBaQUH0mZUGPxoPNAR+4iwJy/a2JyUok0PJ30HbzK8ZjI
         6IRg==
X-Gm-Message-State: AGi0Puay6ak3RBcZTGg0BfLOyCG+rMRP1U/p5XM9wwrAlfWGNoISDPFv
        37WUY5VEPW8SKE5XQ1hLcOPtG5D0qCPLwAyMpfqKJkI36JnXRPCEYcA3OIVwckBL/0r+l/bNaFm
        z1VKp018bEgNfEL8y
X-Received: by 2002:a17:90a:2fc8:: with SMTP id n8mr4931056pjm.159.1588705499337;
        Tue, 05 May 2020 12:04:59 -0700 (PDT)
X-Google-Smtp-Source: APiQypKasw2T0vbZ5atQn/rNAI6ZBPg7B5A29a3CWSro3nVzE6UVzU461CDw6k/5yIaqczr2W1pqXg==
X-Received: by 2002:a17:90a:2fc8:: with SMTP id n8mr4931017pjm.159.1588705499081;
        Tue, 05 May 2020 12:04:59 -0700 (PDT)
Received: from localhost ([122.177.124.216])
        by smtp.gmail.com with ESMTPSA id i128sm2494555pfc.149.2020.05.05.12.04.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 12:04:58 -0700 (PDT)
From:   Bhupesh Sharma <bhsharma@redhat.com>
To:     netdev@vger.kernel.org
Cc:     bhsharma@redhat.com, bhupesh.linux@gmail.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        manishc@marvell.com, davem@davemloft.net
Subject: [PATCH 2/2] net: qed: Disable SRIOV functionality inside kdump kernel
Date:   Wed,  6 May 2020 00:34:41 +0530
Message-Id: <1588705481-18385-3-git-send-email-bhsharma@redhat.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588705481-18385-1-git-send-email-bhsharma@redhat.com>
References: <1588705481-18385-1-git-send-email-bhsharma@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we have kdump kernel(s) running under severe memory constraint
it makes sense to disable the qed SRIOV functionality when running the
kdump kernel as kdump configurations on several distributions don't
support SRIOV targets for saving the vmcore (see [1] for example).

Currently the qed SRIOV functionality ends up consuming memory in
the kdump kernel, when we don't really use the same.

An example log seen in the kdump kernel with the SRIOV functionality
enabled can be seen below (obtained via memstrack tool, see [2]):
 dracut-pre-pivot[676]: ======== Report format module_summary: ========
 dracut-pre-pivot[676]: Module qed using 149.6MB (2394 pages), peak allocation 149.6MB (2394 pages)

This patch disables the SRIOV functionality inside kdump kernel and with
the same applied the memory consumption goes down:
 dracut-pre-pivot[671]: ======== Report format module_summary: ========
 dracut-pre-pivot[671]: Module qed using 124.6MB (1993 pages), peak allocation 124.7MB (1995 pages)

[1]. https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/installing-and-configuring-kdump_managing-monitoring-and-updating-the-kernel#supported-kdump-targets_supported-kdump-configurations-and-targets
[2]. Memstrack tool: https://github.com/ryncsn/memstrack

Cc: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Ariel Elior <aelior@marvell.com>
Cc: GR-everest-linux-l2@marvell.com
Cc: Manish Chopra <manishc@marvell.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.h  | 10 +++++++---
 drivers/net/ethernet/qlogic/qede/qede_main.c |  2 +-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.h b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
index 368e88565783..f2ebd9a76e20 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
@@ -32,6 +32,7 @@
 
 #ifndef _QED_SRIOV_H
 #define _QED_SRIOV_H
+#include <linux/crash_dump.h>
 #include <linux/types.h>
 #include "qed_vf.h"
 
@@ -40,9 +41,12 @@
 #define QED_VF_ARRAY_LENGTH (3)
 
 #ifdef CONFIG_QED_SRIOV
-#define IS_VF(cdev)             ((cdev)->b_is_vf)
-#define IS_PF(cdev)             (!((cdev)->b_is_vf))
-#define IS_PF_SRIOV(p_hwfn)     (!!((p_hwfn)->cdev->p_iov_info))
+#define IS_VF(cdev)             ((is_kdump_kernel()) ? \
+				 (0) : ((cdev)->b_is_vf))
+#define IS_PF(cdev)             ((is_kdump_kernel()) ? \
+				 (1) : !((cdev)->b_is_vf))
+#define IS_PF_SRIOV(p_hwfn)     ((is_kdump_kernel()) ? \
+				 (0) : !!((p_hwfn)->cdev->p_iov_info))
 #else
 #define IS_VF(cdev)             (0)
 #define IS_PF(cdev)             (1)
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 34fa3917eb33..f557ae90ce7c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1187,7 +1187,7 @@ static int qede_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	case QEDE_PRIVATE_VF:
 		if (debug & QED_LOG_VERBOSE_MASK)
 			dev_err(&pdev->dev, "Probing a VF\n");
-		is_vf = true;
+		is_vf = is_kdump_kernel() ? false : true;
 		break;
 	default:
 		if (debug & QED_LOG_VERBOSE_MASK)
-- 
2.7.4

