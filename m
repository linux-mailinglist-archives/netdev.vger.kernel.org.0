Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D421B314D5C
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhBIKop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:44:45 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54926 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231424AbhBIKhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:37:01 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 119AZtY2031747;
        Tue, 9 Feb 2021 02:36:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=XpalJ28fWqrsNKp+ifZ7FOE7PR4DTwYENOlL1tFbsrI=;
 b=HKrmELSmQRod3m3DhgDlJrqAGtg12muXmrskSwZAUv6ASYJqFa8rnZDaTlMVV48CjYfC
 359J/uwdEUUqWFEriqhwl9hpWqUCZqfRP3T91QSEBg4x1XL9qag3ILcqa91CG/5HOxq2
 c7IeFZZk+GVxLeeudEuPyPt23gQN2Xrt1QT07FxgdoJvQN7oiMywIRhRzyKqMDp5aikm
 r4d8wcrWhD+qHbTo+hk5tPl5MLAyZRbdLoHvHUZxNVDCiWPant2PgV7ZysBoh4AVsD4n
 DMdvHK+4S/N2aQUPuVyK9eh0MPiadD72OcDFe+NPOEfhMuQa5Fj1mABVBBvjOjQ/C1+V yw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrg14n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 02:36:08 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 02:36:07 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Feb 2021 02:36:07 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id 151793F704A;
        Tue,  9 Feb 2021 02:36:02 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [Patch v4 net-next 7/7] octeontx2-pf: ethtool physical link configuration
Date:   Tue, 9 Feb 2021 16:05:31 +0530
Message-ID: <1612866931-79299-8-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612866931-79299-1-git-send-email-hkelam@marvell.com>
References: <1612866931-79299-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christina Jacob <cjacob@marvell.com>

Register set_link_ksetting callback with driver such that
link configurations parameters like advertised mode,speed, duplex
and autoneg can be configured.

below command
ethtool -s eth0 advertise 0x1 speed 10 duplex full autoneg on

Signed-off-by: Christina Jacob <cjacob@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 63 ++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index d5d9b1d..237e5d3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -1157,6 +1157,68 @@ static int otx2_get_link_ksettings(struct net_device *netdev,
 	return 0;
 }

+static void otx2_get_advertised_mode(const struct ethtool_link_ksettings *cmd,
+				     u64 *mode)
+{
+	u32 bit_pos;
+
+	/* Firmware does not support requesting multiple advertised modes
+	 * return first set bit
+	 */
+	bit_pos = find_first_bit(cmd->link_modes.advertising,
+				 __ETHTOOL_LINK_MODE_MASK_NBITS);
+	if (bit_pos != __ETHTOOL_LINK_MODE_MASK_NBITS)
+		*mode = bit_pos;
+}
+
+static int otx2_set_link_ksettings(struct net_device *netdev,
+				   const struct ethtool_link_ksettings *cmd)
+{
+	struct otx2_nic *pf = netdev_priv(netdev);
+	struct ethtool_link_ksettings cur_ks;
+	struct cgx_set_link_mode_req *req;
+	struct mbox *mbox = &pf->mbox;
+	int err = 0;
+
+	memset(&cur_ks, 0, sizeof(struct ethtool_link_ksettings));
+
+	if (!ethtool_validate_speed(cmd->base.speed) ||
+	    !ethtool_validate_duplex(cmd->base.duplex))
+		return -EINVAL;
+
+	if (cmd->base.autoneg != AUTONEG_ENABLE &&
+	    cmd->base.autoneg != AUTONEG_DISABLE)
+		return -EINVAL;
+
+	otx2_get_link_ksettings(netdev, &cur_ks);
+
+	/* Check requested modes against supported modes by hardware */
+	if (!bitmap_subset(cmd->link_modes.advertising,
+			   cur_ks.link_modes.supported,
+			   __ETHTOOL_LINK_MODE_MASK_NBITS))
+		return -EINVAL;
+
+	mutex_lock(&mbox->lock);
+	req = otx2_mbox_alloc_msg_cgx_set_link_mode(&pf->mbox);
+	if (!req) {
+		err = -ENOMEM;
+		goto end;
+	}
+
+	req->args.speed = cmd->base.speed;
+	/* firmware expects 1 for half duplex and 0 for full duplex
+	 * hence inverting
+	 */
+	req->args.duplex = cmd->base.duplex ^ 0x1;
+	req->args.an = cmd->base.autoneg;
+	otx2_get_advertised_mode(cmd, &req->args.mode);
+
+	err = otx2_sync_mbox_msg(&pf->mbox);
+end:
+	mutex_unlock(&mbox->lock);
+	return err;
+}
+
 static const struct ethtool_ops otx2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
@@ -1187,6 +1249,7 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.get_fecparam		= otx2_get_fecparam,
 	.set_fecparam		= otx2_set_fecparam,
 	.get_link_ksettings     = otx2_get_link_ksettings,
+	.set_link_ksettings     = otx2_set_link_ksettings,
 };

 void otx2_set_ethtool_ops(struct net_device *netdev)
--
2.7.4
