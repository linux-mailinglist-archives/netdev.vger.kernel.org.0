Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9AE3F3F30
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 14:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhHVMDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 08:03:43 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53564 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232682AbhHVMDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 08:03:41 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17MBIv6K004018;
        Sun, 22 Aug 2021 05:02:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=O3EjgIMK+nJWlDrxPzmFoOLe0I8nDe2ZPnpJmETsu/8=;
 b=IMvWP+lTMJ9qAyH0VOy6eFPP1B76/Xov7wEpvDTBRJgC74kmuXxb+OnZvqGq2OF/fA/b
 Sq8L5ehDeR9uo/b2641rfbj6Yrq3j73IfO6oPkQd90oCpP0nixdcUSLRkGdl7HjATX4T
 /0Ff+SBIz54sr3bWMzkj2ZEx5ZV0Ycii/T/dBOSR3YGteLWOXczMYjwRz1xMtDhm3iBr
 AC+Gm0MqBMNy1NPvqoon7nMtrnlVAIzV+sdlMfKYBDu3RrB0iQW2q0bs10dmBzP3gCfu
 ET2hvrOLQlGEz/mnVzPbWHSp9IDJ6b0EdGz/uXml1/xaFCHTZglSbgTsiLPEW6ihrGxt aQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ak10mtr6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Aug 2021 05:02:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Sun, 22 Aug
 2021 05:02:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.23 via Frontend
 Transport; Sun, 22 Aug 2021 05:02:56 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id F38683F7076;
        Sun, 22 Aug 2021 05:02:54 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [net PATCH 08/10] octeontx2-pf: Don't install VLAN offload rule if netdev is down
Date:   Sun, 22 Aug 2021 17:32:25 +0530
Message-ID: <1629633747-22061-9-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
References: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: mycazINstExISz-AnxFfMK8oBSYsIF7P
X-Proofpoint-ORIG-GUID: mycazINstExISz-AnxFfMK8oBSYsIF7P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-21_11,2021-08-20_03,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever user changes interface MAC address both default DMAC based
MCAM rule and VLAN offload (for strip) rules are updated with new
MAC address. To update or install VLAN offload rule PF driver needs
interface's receive channel info, which is retrieved from admin
function at the time of NIXLF initialization.

If user changes MAC address before interface is UP, VLAN offload rule
installation will fail and throw error as receive channel is not valid.
To avoid this, skip VLAN offload rule installation if netdev is not UP.
This rule will anyway be reinslatted as part of open() call.

Fixes: fd9d7859db6c ("octeontx2-pf: Implement ingress/egress VLAN offload")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 2112008..4e125d6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -208,7 +208,8 @@ int otx2_set_mac_address(struct net_device *netdev, void *p)
 	if (!otx2_hw_set_mac_addr(pfvf, addr->sa_data)) {
 		memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
 		/* update dmac field in vlan offload rule */
-		if (pfvf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
+		if (netif_running(netdev) &&
+		    pfvf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
 			otx2_install_rxvlan_offload_flow(pfvf);
 		/* update dmac address in ntuple and DMAC filter list */
 		if (pfvf->flags & OTX2_FLAG_DMACFLTR_SUPPORT)
-- 
2.7.4

