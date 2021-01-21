Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7752FE473
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 08:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbhAUH4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 02:56:47 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61474 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727841AbhAUHzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 02:55:24 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10L7f1ND000720;
        Wed, 20 Jan 2021 23:54:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=idCFvRnJPh34PARSI+3IuFtsNGFzJ4bJVs7ac1d1cu8=;
 b=M7ysodF1rf76/pjIfyoUijqiXo1ns4CmuYSivC+0BgO05cS0/abx9Ew5Od/0IWDrOA2P
 UHmLnX2riLh4ZJMq5gRo4XE24ZO3bqurs8Mn2tVnyY/2WDsDz4S8nAlxuWScLY/XiqSC
 Gs4sR6wSRFC8zHVkfUxr/CrFwGzDzc/l16kRNQTLmJaoRoy3eWb6XP3Rz/nP9vQ1WUr0
 diPdpqpioy/AcIv8I9BSHVlb1T1FZxNqi3OtaLl6NkS2BR5dTPJPNsXUCkdjDBMcqhlG
 ciogRmicraoC6XKjgQ013lYtvnPzoO4E2vagzO9xxXLOn6mMfWLxNXvqp3nTpotrxKbR ag== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3668p2wf0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 23:54:42 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 Jan
 2021 23:54:40 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 Jan
 2021 23:54:40 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 Jan 2021 23:54:40 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id 205603F703F;
        Wed, 20 Jan 2021 23:54:36 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, Christina Jacob <cjacob@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: [net-next PATCH 7/7] octeontx2-pf: ethtool physical link configuration
Date:   Thu, 21 Jan 2021 13:23:29 +0530
Message-ID: <1611215609-92301-8-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611215609-92301-1-git-send-email-hkelam@marvell.com>
References: <1611215609-92301-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_03:2021-01-20,2021-01-21 signatures=0
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
---
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 59 ++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index ef79ecf..b928745 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -1134,6 +1134,64 @@ static int otx2_get_link_ksettings(struct net_device *netdev,
 	return 0;
 }
 
+static int otx2_set_link_ksettings(struct net_device *netdev,
+				   const struct ethtool_link_ksettings *cmd)
+{
+	struct otx2_nic *pf = netdev_priv(netdev);
+	struct ethtool_link_ksettings req_ks;
+	struct ethtool_link_ksettings cur_ks;
+	struct cgx_set_link_mode_req *req;
+	struct cgx_set_link_mode_rsp *rsp;
+	struct mbox *mbox = &pf->mbox;
+	int err = 0;
+
+	/* save requested link settings */
+	memcpy(&req_ks, cmd, sizeof(struct ethtool_link_ksettings));
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
+	if (!bitmap_subset(req_ks.link_modes.advertising,
+			   cur_ks.link_modes.supported,
+			   __ETHTOOL_LINK_MODE_MASK_NBITS))
+		return -EINVAL;
+
+	mutex_lock(&mbox->lock);
+	req = otx2_mbox_alloc_msg_cgx_set_link_mode(&pf->mbox);
+	if (!req) {
+		mutex_unlock(&mbox->lock);
+		return -EAGAIN;
+	}
+
+	req->args.speed = req_ks.base.speed;
+	/* firmware expects 1 for half duplex and 0 for full duplex
+	 * hence inverting
+	 */
+	req->args.duplex = req_ks.base.duplex ^ 0x1;
+	req->args.an =  req_ks.base.autoneg;
+	req->args.mode   = *req_ks.link_modes.advertising;
+
+	err =  otx2_sync_mbox_msg(&pf->mbox);
+	if (!err) {
+		rsp = (struct cgx_set_link_mode_rsp *)
+			otx2_mbox_get_rsp(&pf->mbox.mbox, 0, &req->hdr);
+		if (rsp->status)
+			err =  rsp->status;
+	}
+	mutex_unlock(&mbox->lock);
+	return err;
+}
+
 static const struct ethtool_ops otx2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
@@ -1164,6 +1222,7 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.get_fecparam		= otx2_get_fecparam,
 	.set_fecparam		= otx2_set_fecparam,
 	.get_link_ksettings     = otx2_get_link_ksettings,
+	.set_link_ksettings     = otx2_set_link_ksettings,
 };
 
 void otx2_set_ethtool_ops(struct net_device *netdev)
-- 
2.7.4

