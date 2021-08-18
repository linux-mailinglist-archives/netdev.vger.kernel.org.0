Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C653F3EFD04
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbhHRGnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:43:41 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39068 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238034AbhHRGnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:43:40 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17I5jGJ1009216;
        Tue, 17 Aug 2021 23:43:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=4ZaWvxswEkG+ne2wuX/aTkXnaizgQudK2ZWNXwz8ysQ=;
 b=hrjapjNvkfar+5W09+m5utW50mX/fyro29bs3Ge/in3aL/hXmWwU7LUoQhfTHFBXKn3L
 xYi9NTbVhC7GypVfz3/wF2+cmy/6s8WV4yip5ePZH14xb08rOjoKx6s+Z12uN6vjNth4
 B8tCJBGTJ/sc5eWm5eDRoPfpQRw1HAIaFKLMfXPAsiEhjhclSPswSCHVe9eXSVZjLxAo
 P52Ho3GfMXIOrwWfIRjJhHomDTSAcT7YuPA1qGJGetq/vVzflkwTuWdi59IBKSmdiUq2
 9TZveHCCa4E4UUP3vvpuMUQO6CYg9jQXuXEd9YQpaHQvt1078vXjXvhibDhD5cNPnKmN cA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3agvat8682-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 23:43:03 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 17 Aug
 2021 23:43:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 17 Aug 2021 23:43:01 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 336363F707E;
        Tue, 17 Aug 2021 23:42:58 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [PATCH] octeontx2-pf: Allow VLAN priority also in ntuple filters
Date:   Wed, 18 Aug 2021 12:12:55 +0530
Message-ID: <1629268975-30899-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: yQ4P-cRdapFLEvp80BQGGNYfjHCdC_oZ
X-Proofpoint-GUID: yQ4P-cRdapFLEvp80BQGGNYfjHCdC_oZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-18_02,2021-08-17_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VLAN TCI is a 16 bit field which includes Priority(3 bits),
CFI(1 bit) and VID(12 bits). Currently ntuple filters support
installing rules to steer packets based on VID only.
This patch extends that support such that filters can
be installed for entire VLAN TCI.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 86c305e..2a25588 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -821,11 +821,6 @@ int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 		if (fsp->m_ext.vlan_etype)
 			return -EINVAL;
 		if (fsp->m_ext.vlan_tci) {
-			if (fsp->m_ext.vlan_tci != cpu_to_be16(VLAN_VID_MASK))
-				return -EINVAL;
-			if (be16_to_cpu(fsp->h_ext.vlan_tci) >= VLAN_N_VID)
-				return -EINVAL;
-
 			memcpy(&pkt->vlan_tci, &fsp->h_ext.vlan_tci,
 			       sizeof(pkt->vlan_tci));
 			memcpy(&pmask->vlan_tci, &fsp->m_ext.vlan_tci,
-- 
2.7.4

