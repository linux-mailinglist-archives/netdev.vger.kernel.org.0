Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1F7A738E
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 21:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfICTUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 15:20:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60120 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725914AbfICTUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 15:20:43 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x83JHOsn104305;
        Tue, 3 Sep 2019 15:20:40 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2usw0q2dfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 15:20:39 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x83JJeCi003864;
        Tue, 3 Sep 2019 19:20:39 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03dal.us.ibm.com with ESMTP id 2uqgh71nwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 19:20:39 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x83JKcSM54198562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Sep 2019 19:20:38 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CAE8112062;
        Tue,  3 Sep 2019 19:20:38 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EBD1112061;
        Tue,  3 Sep 2019 19:20:37 +0000 (GMT)
Received: from localhost (unknown [9.18.235.139])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  3 Sep 2019 19:20:37 +0000 (GMT)
From:   "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        davem@davemloft.net, Andrew Bowers <andrewx.bowers@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        maurosr@linux.vnet.ibm.com
Subject: [PATCH v2 net-next 2/2] i40e: Implement debug macro hw_dbg using dev_dbg
Date:   Tue,  3 Sep 2019 16:20:21 -0300
Message-Id: <20190903192021.25789-2-maurosr@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190903192021.25789-1-maurosr@linux.vnet.ibm.com>
References: <20190903192021.25789-1-maurosr@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-03_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=21 spamscore=0
 clxscore=1015 lowpriorityscore=21 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909030191
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several uses of hw_dbg in the code, producing no output. This
patch implments it using dev_debug.

Initially the intention was to implement it using netdev_dbg, analogously
to what is done in ixgbe for instance. That approach was avoided due to
some early usages of hw_dbg, like i40e_pf_reset, before the vsi structure
initialization causing NULL pointer dereference during the driver probe if
the dbg messages were turned on as soon as the module is probed.

v2:
 - Use dev_dbg instead of pr_debug, and take advantage of dev_name
instead of crafting pretty much the same device name locally as suggested
by Jakub Kicinski.

Signed-off-by: Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 1 +
 drivers/net/ethernet/intel/i40e/i40e_hmc.c    | 1 +
 drivers/net/ethernet/intel/i40e/i40e_osdep.h  | 5 ++++-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 906cf68d3453..a51678166ff9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
+#include "i40e.h"
 #include "i40e_type.h"
 #include "i40e_adminq.h"
 #include "i40e_prototype.h"
diff --git a/drivers/net/ethernet/intel/i40e/i40e_hmc.c b/drivers/net/ethernet/intel/i40e/i40e_hmc.c
index 19ce93d7fd0a..163ee8c6311c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_hmc.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_hmc.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
+#include "i40e.h"
 #include "i40e_osdep.h"
 #include "i40e_register.h"
 #include "i40e_status.h"
diff --git a/drivers/net/ethernet/intel/i40e/i40e_osdep.h b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
index a07574bff550..c302ef2524f8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_osdep.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
@@ -18,7 +18,10 @@
  * actual OS primitives
  */
 
-#define hw_dbg(hw, S, A...)	do {} while (0)
+#define hw_dbg(hw, S, A...)							\
+do {										\
+	dev_dbg(&((struct i40e_pf *)hw->back)->pdev->dev, S, ##A);		\
+} while (0)
 
 #define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
 #define rd32(a, reg)		readl((a)->hw_addr + (reg))
-- 
2.21.0

