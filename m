Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F282F74E4
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 10:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbhAOJHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 04:07:09 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50012 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727020AbhAOJHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 04:07:07 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10F8xcIv013563;
        Fri, 15 Jan 2021 01:06:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=+Hvy1jKkYVAyMBS9UTbowqwD7DX9YEVH/j6b25q/5BY=;
 b=HjoGBdXTWHMMCyvl3Q5Ab31GDHUeoJ/IO1thH6+pr+6sKw6+hlKgmUN/PCkFEeBUcJKh
 c9yttPm5kBmgwfiokMk5I4thNKMhY9Kh5iou1cG/6Tl40DXZhiUYaLfG7n1ZNpHq0g0B
 uEv0U5JPchxGurBulJZ6Wh1TOhyW1qpOhZ6M2c4RLhubeBBvqnm8UQPTmUjYSr8AtLel
 bM4JXfI/tzjkbWwv0jeYJJOV2XUkrMX17/2C8bJeLKBoCbmhZeaqjTlc9K4quwK6jUZQ
 L3SrOO5XgrwNWIA2gifvE9Qhat1Ru36+2X/xEetFHOMqD5VcrqTRYfd7JE7gbalGpUnG VQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvq2311-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 01:06:24 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 15 Jan
 2021 01:06:22 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 15 Jan
 2021 01:06:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 15 Jan 2021 01:06:22 -0800
Received: from dc5-eodlnx05.marvell.com (dc5-eodlnx05.marvell.com [10.69.113.147])
        by maili.marvell.com (Postfix) with ESMTP id 4BC533F7040;
        Fri, 15 Jan 2021 01:06:22 -0800 (PST)
From:   Bhaskar Upadhaya <bupadhaya@marvell.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>
CC:     <bupadhaya@marvell.com>
Subject: [PATCH  net-next 1/3] qede: add netpoll support for qede driver
Date:   Fri, 15 Jan 2021 01:06:08 -0800
Message-ID: <1610701570-29496-2-git-send-email-bupadhaya@marvell.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610701570-29496-1-git-send-email-bupadhaya@marvell.com>
References: <1610701570-29496-1-git-send-email-bupadhaya@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_06:2021-01-15,2021-01-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add net poll controller support to transmit kernel printks
over UDP

Signed-off-by: Bhaskar Upadhaya <bupadhaya@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h      |  4 ++++
 drivers/net/ethernet/qlogic/qede/qede_fp.c   | 14 ++++++++++++++
 drivers/net/ethernet/qlogic/qede/qede_main.c |  3 +++
 3 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 3efc5899f656..ac12e5beb596 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -582,6 +582,10 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 
 void qede_forced_speed_maps_init(void);
 
+#ifdef CONFIG_NET_POLL_CONTROLLER
+void qede_poll_controller(struct net_device *dev);
+#endif
+
 #define RX_RING_SIZE_POW	13
 #define RX_RING_SIZE		((u16)BIT(RX_RING_SIZE_POW))
 #define NUM_RX_BDS_MAX		(RX_RING_SIZE - 1)
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index a2494bf85007..a626f1f45212 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1804,3 +1804,17 @@ netdev_features_t qede_features_check(struct sk_buff *skb,
 
 	return features;
 }
+
+#ifdef CONFIG_NET_POLL_CONTROLLER
+/* This is used by netconsole to send skbs without having to re-enable
+ * interrupts.It's not called while the normal interrupt routine is executing.
+ */
+void qede_poll_controller(struct net_device *dev)
+{
+	struct qede_dev *edev = netdev_priv(dev);
+	int i;
+
+	for_each_queue(i)
+		napi_schedule(&edev->fp_array[i].napi);
+}
+#endif
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 05e3a3b60269..2ff6c49de745 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -644,6 +644,9 @@ static const struct net_device_ops qede_netdev_ops = {
 	.ndo_set_rx_mode	= qede_set_rx_mode,
 	.ndo_set_mac_address	= qede_set_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	.ndo_poll_controller = qede_poll_controller,
+#endif
 	.ndo_change_mtu		= qede_change_mtu,
 	.ndo_do_ioctl		= qede_ioctl,
 	.ndo_tx_timeout		= qede_tx_timeout,
-- 
2.17.1

