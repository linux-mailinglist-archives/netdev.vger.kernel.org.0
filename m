Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5917E1EFE06
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 18:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgFEQas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 12:30:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54442 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726024AbgFEQar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 12:30:47 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 055GM2D2011531;
        Fri, 5 Jun 2020 09:30:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=WaCuyCcxe8GLK+tdTmssoAAVR1/3nXh9Wxvb56TPlYs=;
 b=m5xispef85SFRunH3LnBTOBYCmd2M0a7CjkyBF9EqEjYQ6ZCkmy06cSP8HSZIhc/F5pf
 dMgqYlgnRrNy95auqzweruHSlJM9FmXDWKlGwchlqv7lx6zbg81+RiAPAfpKvD8OVqnf
 oFzllzrXznP+fHuGSvEhwcWbOqq7UWSMKhFnzPlLiAdHCGgwLd2A/VZJJTKZ8j+UlAXi
 XMJNR48KfnrhDnV8ksGEh5dnQalZaeONe494V5Yb1Me17axZGKb4/mpm4lr9mYxs1xuR
 h+hUFS1oVzfJH6QDYKSLJ3oQCqsqxPvqC7EtmwP7oUnkJEdo0+/cNe0kiip75qADEvfL IA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 31f90uk9jn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 09:30:43 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Jun
 2020 09:30:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Jun 2020 09:30:41 -0700
Received: from dell-r720.punelab.qlogic.com032qlogic.org032qlogic.com032mv.qlogic.com032av.na (unknown [10.30.45.91])
        by maili.marvell.com (Postfix) with ESMTP id DB6E23F703F;
        Fri,  5 Jun 2020 09:30:39 -0700 (PDT)
From:   Alok Prasad <palok@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH] net: qed: fixes crash while running driver in kdump kernel
Date:   Fri, 5 Jun 2020 16:30:34 +0000
Message-ID: <20200605163034.26879-1-palok@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-05_04:2020-06-04,2020-06-05 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes a crash introduced by recent is_kdump_kernel() check.
The source of the crash is that kdump kernel can be loaded on a
system with already created VFs. But for such VFs, it will follow
a logic path of PF and eventually crash.

Thus, we are partially reverting back previous changes and instead
use is_kdump_kernel is a single init point of PF init, where we
disable SRIOV explicitly.

Fixes: 37d4f8a6b41f ("net: qed: Disable SRIOV functionality inside kdump kernel")
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c  |  4 ++++
 drivers/net/ethernet/qlogic/qed/qed_sriov.h  | 10 +++-------
 drivers/net/ethernet/qlogic/qede/qede_main.c |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 66876af814c4..20679fd4204b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -33,6 +33,7 @@
 #include <linux/etherdevice.h>
 #include <linux/crc32.h>
 #include <linux/vmalloc.h>
+#include <linux/crash_dump.h>
 #include <linux/qed/qed_iov_if.h>
 #include "qed_cxt.h"
 #include "qed_hsi.h"
@@ -607,6 +608,9 @@ int qed_iov_hw_info(struct qed_hwfn *p_hwfn)
 	int pos;
 	int rc;
 
+	if (is_kdump_kernel())
+		return 0;
+
 	if (IS_VF(p_hwfn->cdev))
 		return 0;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.h b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
index aabeaf03135e..368e88565783 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
@@ -32,7 +32,6 @@
 
 #ifndef _QED_SRIOV_H
 #define _QED_SRIOV_H
-#include <linux/crash_dump.h>
 #include <linux/types.h>
 #include "qed_vf.h"
 
@@ -41,12 +40,9 @@
 #define QED_VF_ARRAY_LENGTH (3)
 
 #ifdef CONFIG_QED_SRIOV
-#define IS_VF(cdev)             (is_kdump_kernel() ? \
-				 (0) : ((cdev)->b_is_vf))
-#define IS_PF(cdev)             (is_kdump_kernel() ? \
-				 (1) : !((cdev)->b_is_vf))
-#define IS_PF_SRIOV(p_hwfn)     (is_kdump_kernel() ? \
-				 (0) : !!((p_hwfn)->cdev->p_iov_info))
+#define IS_VF(cdev)             ((cdev)->b_is_vf)
+#define IS_PF(cdev)             (!((cdev)->b_is_vf))
+#define IS_PF_SRIOV(p_hwfn)     (!!((p_hwfn)->cdev->p_iov_info))
 #else
 #define IS_VF(cdev)             (0)
 #define IS_PF(cdev)             (1)
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index b2d154258b07..756c05eb96f3 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1265,7 +1265,7 @@ static int qede_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	case QEDE_PRIVATE_VF:
 		if (debug & QED_LOG_VERBOSE_MASK)
 			dev_err(&pdev->dev, "Probing a VF\n");
-		is_vf = is_kdump_kernel() ? false : true;
+		is_vf = true;
 		break;
 	default:
 		if (debug & QED_LOG_VERBOSE_MASK)
-- 
2.17.1

