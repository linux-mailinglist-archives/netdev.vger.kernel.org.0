Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F55B1BF7C9
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 14:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgD3MDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 08:03:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12680 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726127AbgD3MDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 08:03:48 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UC3aP9064308;
        Thu, 30 Apr 2020 08:03:45 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhqasd0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 08:03:44 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UBjjlV004305;
        Thu, 30 Apr 2020 12:03:11 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 30mcu7xjq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 12:03:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UC20pU49938940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 12:02:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D8BDA4040;
        Thu, 30 Apr 2020 12:03:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49F00A4051;
        Thu, 30 Apr 2020 12:03:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 12:03:09 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leon@kernel.org>,
        Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH 1/1] net/mlx5: Call pci_disable_sriov() on remove
Date:   Thu, 30 Apr 2020 14:03:08 +0200
Message-Id: <20200430120308.92773-2-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430120308.92773-1-schnelle@linux.ibm.com>
References: <20200430120308.92773-1-schnelle@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_07:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 adultscore=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=724 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300099
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

as described in Documentation/PCI/pci-iov-howto.rst a driver with SR-IOV
support should call pci_disable_sriov() in the remove handler.
Otherwise removing a PF (e.g. via pci_stop_and_remove_bus_device()) with
attached VFs does not properly shut the VFs down before shutting down
the PF. This leads to the VF drivers handling defunct devices and
accompanying error messages.

In the current code pci_disable_sriov() is already called in
mlx5_sriov_disable() but not in mlx5_sriov_detach() which is called from
the remove handler. Fix this by moving the pci_disable_sriov() call into
mlx5_device_disable_sriov() which is called by both.

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 3094d20297a9..2401961c9f5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -114,6 +114,8 @@ mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
 	int err;
 	int vf;
 
+	pci_disable_sriov(dev->pdev);
+
 	for (vf = num_vfs - 1; vf >= 0; vf--) {
 		if (!sriov->vfs_ctx[vf].enabled)
 			continue;
@@ -156,7 +158,6 @@ static void mlx5_sriov_disable(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	int num_vfs = pci_num_vf(dev->pdev);
 
-	pci_disable_sriov(pdev);
 	mlx5_device_disable_sriov(dev, num_vfs, true);
 }
 
-- 
2.17.1

