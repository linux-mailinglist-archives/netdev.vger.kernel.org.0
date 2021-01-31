Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7CC309CBC
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 15:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhAaOQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:16:05 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39192 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231785AbhAaN36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 08:29:58 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10VD6m0x022112;
        Sun, 31 Jan 2021 05:11:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=k2W0HGdS52YxBqxCw5+glP2NLyQW59WceMVWV8sZtaE=;
 b=KVLR15JsvWLPpr+O+O0eJmXmUJS5kZxHeIoVIXfmAnapCVRl98EXKduG0PD84LkOIsF4
 ApSrEAHArlBM96wAAvSBuXioxf23NwU5RTa31+hT4redpF4YCeM2DdL7AKh5KeLNDhGv
 FQzHbX5o/IM39SHUCoW45Vun6We7DaAIT9EAmjgjySuartTNBwjHUMyv4FS9TK6W3x2k
 wYdqpbJW6u8XIeuIeEYcxDmqYyWrM/Z3SYz4x2bLF4U62asjH1NXIcKpbDjsuIqdrLyq
 dMsA0PbUnn/v5zoyvSsM6NswBvYJfVq4WFpFY53dyJJvGiz9PGccOuStY6EWvqKouOGN FA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36d5psss6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 05:11:38 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 05:11:37 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 05:11:37 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 31 Jan 2021 05:11:37 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id AB3CE3F703F;
        Sun, 31 Jan 2021 05:11:33 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [Patch v3 net-next 7/7] octeontx2-pf: ethtool physical link configuration
Date:   Sun, 31 Jan 2021 18:41:05 +0530
Message-ID: <1612098665-187767-8-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612098665-187767-1-git-send-email-hkelam@marvell.com>
References: <1612098665-187767-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_04:2021-01-29,2021-01-31 signatures=0
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
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 67 ++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index d637815..74a62de 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -1170,6 +1170,72 @@ static int otx2_get_link_ksettings(struct net_device *netdev,
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
+	struct ethtool_link_ksettings req_ks;
+	struct ethtool_link_ksettings cur_ks;
+	struct cgx_set_link_mode_req *req;
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
+		err = -ENOMEM;
+		goto end;
+	}
+
+	req->args.speed = req_ks.base.speed;
+	/* firmware expects 1 for half duplex and 0 for full duplex
+	 * hence inverting
+	 */
+	req->args.duplex = req_ks.base.duplex ^ 0x1;
+	req->args.an = req_ks.base.autoneg;
+	otx2_get_advertised_mode(&req_ks, &req->args.mode);
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
@@ -1200,6 +1266,7 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.get_fecparam		= otx2_get_fecparam,
 	.set_fecparam		= otx2_set_fecparam,
 	.get_link_ksettings     = otx2_get_link_ksettings,
+	.set_link_ksettings     = otx2_set_link_ksettings,
 };
 
 void otx2_set_ethtool_ops(struct net_device *netdev)
-- 
2.7.4

