Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E011F3407AC
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhCROQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39043 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229508AbhCROQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IEG97F002190;
        Thu, 18 Mar 2021 07:16:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=CheJY+h4JecTl+0IltVb6MPtmSec/TUAxxjUvJUdEd8=;
 b=RSS577oB6vwuoBipR7COXVlQBZLg5LAE/keGuWuhd/3/pyGxkefYpAoZ2CYjgt6RRtzv
 fPwDn7QJrkXyVbpRivpO8KW8lvOnVe5rXUS8RhnHYfYPV95HWY6Unce7CZ/GTr0fEDOI
 FAU1Wazurpin0JszXRhC6zIbq5rQk5iogpUf7r6Y0si0LoEiNcBDiZ8OcKEDIZ8t9n+y
 Y/P7XmRTKG+828qNpjp0KXHmdYM6YQ9v4f5LgVVdRo9Z5dHEIC4WSHT1/h0hOlixVVP0
 PsCOITRDViXiff6ie3KmbAGeoUYeXZjrCLuG+ClqDuONBC4YvHUKZ3i5hGJFno9ADiVn /A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 37c5bf0q7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 07:16:18 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Mar
 2021 07:16:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Mar 2021 07:16:16 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 5F4B93F7048;
        Thu, 18 Mar 2021 07:16:13 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [net PATCH v2 6/8] octeontx2-pf: Clear RSS enable flag on interace down
Date:   Thu, 18 Mar 2021 19:45:47 +0530
Message-ID: <20210318141549.2622-7-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210318141549.2622-1-hkelam@marvell.com>
References: <20210318141549.2622-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

RSS configuration can not be get/set when interface is in down state
as they required mbox communication. RSS enable flag status
is used for set/get configuration. Current code do not clear the
RSS enable flag on interface down which lead to mbox error while
trying to set/get RSS configuration.

Fixes: 85069e95e531 ("octeontx2-pf: Receive side scaling support")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 53ab1814d74..2fd3d235d29 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1672,6 +1672,7 @@ int otx2_stop(struct net_device *netdev)
 	struct otx2_nic *pf = netdev_priv(netdev);
 	struct otx2_cq_poll *cq_poll = NULL;
 	struct otx2_qset *qset = &pf->qset;
+	struct otx2_rss_info *rss;
 	int qidx, vec, wrk;
 
 	netif_carrier_off(netdev);
@@ -1684,6 +1685,10 @@ int otx2_stop(struct net_device *netdev)
 	/* First stop packet Rx/Tx */
 	otx2_rxtx_enable(pf, false);
 
+	/* Clear RSS enable flag */
+	rss = &pf->hw.rss_info;
+	rss->enable = false;
+
 	/* Cleanup Queue IRQ */
 	vec = pci_irq_vector(pf->pdev,
 			     pf->hw.nix_msixoff + NIX_LF_QINT_VEC_START);
-- 
2.17.1

