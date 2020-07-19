Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF489225417
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 22:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgGSUQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 16:16:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33310 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726854AbgGSUQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 16:16:01 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06JKFm9I017981;
        Sun, 19 Jul 2020 13:15:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=jobk3xeLzTHzvJN0Y5cg0OyORp8n4gGX83l30lQJ68I=;
 b=TKivd/RA4aJ9QkZhRRBPUcyskGwNTKFdo8bz7R7OaxEk0iOE3+FIOiMpy+s4qUPUdd8/
 ccOjl2iQfDNaGMEg7JMMiWwkITZatO9S9y23LpnUryamtcBTDvEOCuZBW8HBS97YWjgH
 c6TdTc9XTYDOjXXwgvt0mYVzgACmpCV0/eMoAEf93V1gGTi10fA+c3bbTM5pWNNdByUT
 GkomckUd2Yqtpy+na1v8YIjBIOiEuMTp21cShUGtVenPvcbHJCAdDBhD3v+Zc71reUCB
 fSzA2yB6Hwy6kSN4HjpEGRTBz9wu+I7ED3fbFPK+sWFRicEDWFQYKLTjbfHgDJaxN09t LQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkbf57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 19 Jul 2020 13:15:57 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 19 Jul
 2020 13:15:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 19 Jul
 2020 13:15:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 19 Jul 2020 13:15:54 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 762FA3F703F;
        Sun, 19 Jul 2020 13:15:50 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net-next 08/14] qede: introduce support for FEC control
Date:   Sun, 19 Jul 2020 23:14:47 +0300
Message-ID: <20200719201453.3648-9-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200719201453.3648-1-alobakin@marvell.com>
References: <20200719201453.3648-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-19_04:2020-07-17,2020-07-19 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Ethtool callbacks for querying and setting FEC parameters if it's
supported by the underlying qed module and MFW version running on the
device.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index f5851a6ae729..12ec80d9247c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -1861,6 +1861,78 @@ static int qede_set_eee(struct net_device *dev, struct ethtool_eee *edata)
 	return 0;
 }
 
+static u32 qede_link_to_ethtool_fec(u32 link_fec)
+{
+	u32 eth_fec = 0;
+
+	if (link_fec & QED_FEC_MODE_NONE)
+		eth_fec |= ETHTOOL_FEC_OFF;
+	if (link_fec & QED_FEC_MODE_FIRECODE)
+		eth_fec |= ETHTOOL_FEC_BASER;
+	if (link_fec & QED_FEC_MODE_RS)
+		eth_fec |= ETHTOOL_FEC_RS;
+	if (link_fec & QED_FEC_MODE_AUTO)
+		eth_fec |= ETHTOOL_FEC_AUTO;
+	if (link_fec & QED_FEC_MODE_UNSUPPORTED)
+		eth_fec |= ETHTOOL_FEC_NONE;
+
+	return eth_fec;
+}
+
+static u32 qede_ethtool_to_link_fec(u32 eth_fec)
+{
+	u32 link_fec = 0;
+
+	if (eth_fec & ETHTOOL_FEC_OFF)
+		link_fec |= QED_FEC_MODE_NONE;
+	if (eth_fec & ETHTOOL_FEC_BASER)
+		link_fec |= QED_FEC_MODE_FIRECODE;
+	if (eth_fec & ETHTOOL_FEC_RS)
+		link_fec |= QED_FEC_MODE_RS;
+	if (eth_fec & ETHTOOL_FEC_AUTO)
+		link_fec |= QED_FEC_MODE_AUTO;
+	if (eth_fec & ETHTOOL_FEC_NONE)
+		link_fec |= QED_FEC_MODE_UNSUPPORTED;
+
+	return link_fec;
+}
+
+static int qede_get_fecparam(struct net_device *dev,
+			     struct ethtool_fecparam *fecparam)
+{
+	struct qede_dev *edev = netdev_priv(dev);
+	struct qed_link_output curr_link;
+
+	memset(&curr_link, 0, sizeof(curr_link));
+	edev->ops->common->get_link(edev->cdev, &curr_link);
+
+	fecparam->active_fec = qede_link_to_ethtool_fec(curr_link.active_fec);
+	fecparam->fec = qede_link_to_ethtool_fec(curr_link.sup_fec);
+
+	return 0;
+}
+
+static int qede_set_fecparam(struct net_device *dev,
+			     struct ethtool_fecparam *fecparam)
+{
+	struct qede_dev *edev = netdev_priv(dev);
+	struct qed_link_params params;
+
+	if (!edev->ops || !edev->ops->common->can_link_change(edev->cdev)) {
+		DP_INFO(edev, "Link settings are not allowed to be changed\n");
+		return -EOPNOTSUPP;
+	}
+
+	memset(&params, 0, sizeof(params));
+	params.override_flags |= QED_LINK_OVERRIDE_FEC_CONFIG;
+	params.fec = qede_ethtool_to_link_fec(fecparam->fec);
+	params.link_up = true;
+
+	edev->ops->common->set_link(edev->cdev, &params);
+
+	return 0;
+}
+
 static int qede_get_module_info(struct net_device *dev,
 				struct ethtool_modinfo *modinfo)
 {
@@ -2097,6 +2169,8 @@ static const struct ethtool_ops qede_ethtool_ops = {
 	.get_module_eeprom		= qede_get_module_eeprom,
 	.get_eee			= qede_get_eee,
 	.set_eee			= qede_set_eee,
+	.get_fecparam			= qede_get_fecparam,
+	.set_fecparam			= qede_set_fecparam,
 	.get_tunable			= qede_get_tunable,
 	.set_tunable			= qede_set_tunable,
 	.flash_device			= qede_flash_device,
-- 
2.25.1

