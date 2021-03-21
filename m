Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F061343249
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 13:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhCUMKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 08:10:39 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47916 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229933AbhCUMKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 08:10:12 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12LC7ho1026466;
        Sun, 21 Mar 2021 05:10:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=8tqe0pkRssSyQQCPvuNbeEEKMkWc5+H222fwXR8tDUk=;
 b=NZ2DeDLpRR+dxmLrmC433yYnwk/me55aEDIdzvbvhdXgU8OxRXuX6wZ8V2OOwHGqA9jN
 1ntbcWtO03GiicQNwCwKgnK9mxBLfOiD4YserhL0WPcfiYSpBuFGI4VdJEhOcQyVWq4s
 +H1EdJcPtFH9kKM/dF/pWkv4B81eRwmJa3mvKvPdHWKjUpSNvjupYdR/u5JA4wjc1NJi
 BzuWKADUNTlsmgquE2ufjPvbEeajAq04TFSxRWnVVgIu3+W5gkPTQyEjPTn5RFdtlWR0
 uNtToQZnADvgjUsZQPyT9vdizMHelQPYwy9GTriTDzKhGw/mRMq75sGD70h35NfRTCqN 5w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 37dedrab2t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 21 Mar 2021 05:10:11 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 21 Mar
 2021 05:10:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 21 Mar 2021 05:10:09 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 10B3F3F704D;
        Sun, 21 Mar 2021 05:10:06 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH 2/8] octeontx2-pf: Add ethtool priv flag to control PAM4 on/off
Date:   Sun, 21 Mar 2021 17:39:52 +0530
Message-ID: <20210321120958.17531-3-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210321120958.17531-1-hkelam@marvell.com>
References: <20210321120958.17531-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-21_01:2021-03-19,2021-03-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Manlunas <fmanlunas@marvell.com>

For PHYs that support changing modulation type (NRZ or PAM4), enable these
commands:

        ethtool --set-priv-flags  ethX pam4 on
        ethtool --set-priv-flags  ethX pam4 off    # means NRZ modulation
        ethtool --show-priv-flags ethX

Signed-off-by: Felix Manlunas <fmanlunas@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/nic/otx2_ethtool.c      | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index f4962a97a07..552ecae1dbe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -22,6 +22,11 @@
 #define DRV_NAME	"octeontx2-nicpf"
 #define DRV_VF_NAME	"octeontx2-nicvf"
 
+static const char otx2_priv_flags_strings[][ETH_GSTRING_LEN] = {
+#define OTX2_PRIV_FLAGS_PAM4 BIT(0)
+	"pam4",
+};
+
 struct otx2_stat {
 	char name[ETH_GSTRING_LEN];
 	unsigned int index;
@@ -112,6 +117,12 @@ static void otx2_get_strings(struct net_device *netdev, u32 sset, u8 *data)
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	int stats;
 
+	if (sset == ETH_SS_PRIV_FLAGS) {
+		memcpy(data, otx2_priv_flags_strings,
+		       ARRAY_SIZE(otx2_priv_flags_strings) * ETH_GSTRING_LEN);
+		return;
+	}
+
 	if (sset != ETH_SS_STATS)
 		return;
 
@@ -250,6 +261,9 @@ static int otx2_get_sset_count(struct net_device *netdev, int sset)
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	int qstats_count;
 
+	if (sset == ETH_SS_PRIV_FLAGS)
+		return ARRAY_SIZE(otx2_priv_flags_strings);
+
 	if (sset != ETH_SS_STATS)
 		return -EINVAL;
 
@@ -1219,6 +1233,52 @@ static int otx2_set_link_ksettings(struct net_device *netdev,
 	return err;
 }
 
+static int otx2_set_priv_flags(struct net_device *netdev, u32 priv_flags)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct cgx_phy_mod_type *req;
+	struct cgx_fw_data *fwd;
+	int rc = -ENOMEM;
+
+	fwd = otx2_get_fwdata(pfvf);
+	if (IS_ERR(fwd))
+		return PTR_ERR(fwd);
+
+	/* ret here if phy does not support this feature */
+	if (!fwd->fwdata.phy.misc.can_change_mod_type)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_cgx_set_phy_mod_type(&pfvf->mbox);
+	if (!req)
+		goto end;
+
+	req->mod = priv_flags & OTX2_PRIV_FLAGS_PAM4;
+	if (!otx2_sync_mbox_msg(&pfvf->mbox))
+		rc = 0;
+
+end:
+	mutex_unlock(&pfvf->mbox.lock);
+	return rc;
+}
+
+static u32 otx2_get_priv_flags(struct net_device *netdev)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct cgx_fw_data *rsp;
+	u32 priv_flags = 0;
+
+	rsp = otx2_get_fwdata(pfvf);
+
+	if (IS_ERR(rsp))
+		return 0;
+
+	if (rsp->fwdata.phy.misc.mod_type)
+		priv_flags |= OTX2_PRIV_FLAGS_PAM4;
+
+	return priv_flags;
+}
+
 static const struct ethtool_ops otx2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
@@ -1250,6 +1310,8 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.set_fecparam		= otx2_set_fecparam,
 	.get_link_ksettings     = otx2_get_link_ksettings,
 	.set_link_ksettings     = otx2_set_link_ksettings,
+	.set_priv_flags		= otx2_set_priv_flags,
+	.get_priv_flags		= otx2_get_priv_flags,
 };
 
 void otx2_set_ethtool_ops(struct net_device *netdev)
-- 
2.17.1

