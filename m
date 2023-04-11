Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD686DDA0D
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjDKLuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjDKLuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:50:01 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3A2E64;
        Tue, 11 Apr 2023 04:49:58 -0700 (PDT)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BB6D4K018215;
        Tue, 11 Apr 2023 11:49:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=jh1p3JHCpb499GjreX3jvhIfnuIXVhOcaLS5n4cneeg=;
 b=j254lQVb4d1b1n40nne3qb+NC4t62R/bN/eGm/jBuqnH8DUf/WjhP7p+KvEOWG7PAnwN
 vuIX0y4B04LtP8Y6moBZecz30NY0rodTanjSptBdciAicqOIXwArFBZcM1jyaOYl7U/6
 f5nysQneUENOV+SPKL5qDQz7WvfK4dEry1l+WH8lRfTvLZbEsgWKeI/LKgFUlbIL528t
 qb/k9+52OGAxUGPQZae7GjfA5GrHb0P/sibxyWT/Wy+SQdZg9Gte9v+4ItYO+Aoi/6TC
 H4LWPP7EZ8pVn20w+AhWHZlW3TX1ZZ5wWnWWOPDjoQbYZxKF2hoYyGQxJKFmVbmPN58W kA== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3pvu4ssdjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Apr 2023 11:49:47 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 33BBnkDw024839
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Apr 2023 11:49:46 GMT
Received: from zijuhu-gv.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Tue, 11 Apr 2023 04:49:43 -0700
From:   Zijun Hu <quic_zijuhu@quicinc.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <quic_zijuhu@quicinc.com>, <abhishekpandit@chromium.org>
Subject: [PATCH v1] Bluetooth: Optimize devcoredump API hci_devcd_init()
Date:   Tue, 11 Apr 2023 19:49:38 +0800
Message-ID: <1681213778-31754-1-git-send-email-quic_zijuhu@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: fdjCsiOQIc8tdVFmh3wynhFQBuildIL2
X-Proofpoint-ORIG-GUID: fdjCsiOQIc8tdVFmh3wynhFQBuildIL2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_07,2023-04-11_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 phishscore=0
 mlxlogscore=934 spamscore=0 bulkscore=0 clxscore=1011 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110111
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

API hci_devcd_init() stores u32 type to memory without specific byte
order, let us store with little endian in order to be loaded and
parsed by devcoredump core rightly.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
---
 net/bluetooth/coredump.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/coredump.c b/net/bluetooth/coredump.c
index 08fa98505454..d2d2624ec708 100644
--- a/net/bluetooth/coredump.c
+++ b/net/bluetooth/coredump.c
@@ -5,6 +5,7 @@
 
 #include <linux/devcoredump.h>
 
+#include <asm/unaligned.h>
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 
@@ -180,25 +181,25 @@ static int hci_devcd_prepare(struct hci_dev *hdev, u32 dump_size)
 
 static void hci_devcd_handle_pkt_init(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	u32 *dump_size;
+	u32 dump_size;
 
 	if (hdev->dump.state != HCI_DEVCOREDUMP_IDLE) {
 		DBG_UNEXPECTED_STATE();
 		return;
 	}
 
-	if (skb->len != sizeof(*dump_size)) {
+	if (skb->len != sizeof(dump_size)) {
 		bt_dev_dbg(hdev, "Invalid dump init pkt");
 		return;
 	}
 
-	dump_size = skb_pull_data(skb, sizeof(*dump_size));
-	if (!*dump_size) {
+	dump_size = get_unaligned_le32(skb_pull_data(skb, 4));
+	if (!dump_size) {
 		bt_dev_err(hdev, "Zero size dump init pkt");
 		return;
 	}
 
-	if (hci_devcd_prepare(hdev, *dump_size)) {
+	if (hci_devcd_prepare(hdev, dump_size)) {
 		bt_dev_err(hdev, "Failed to prepare for dump");
 		return;
 	}
@@ -441,7 +442,7 @@ int hci_devcd_init(struct hci_dev *hdev, u32 dump_size)
 		return -ENOMEM;
 
 	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_INIT;
-	skb_put_data(skb, &dump_size, sizeof(dump_size));
+	put_unaligned_le32(dump_size, skb_put(skb, 4));
 
 	skb_queue_tail(&hdev->dump.dump_q, skb);
 	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

