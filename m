Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80AAC6E4434
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjDQJnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjDQJnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:43:15 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96695259;
        Mon, 17 Apr 2023 02:42:26 -0700 (PDT)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33H8uIx8028737;
        Mon, 17 Apr 2023 09:40:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=qcppdkim1;
 bh=gmFjwPOeIRvp54NzkNArds8OCxs3AtN0RRoBSNyeKTI=;
 b=pc/BtBcp2rptCZJ5c0yGBNCd2hl/TZ+7tgTtnowdyAKNTNluBk0mPsyKACiWfOfK2MRY
 DyyvK048Gn8pcGnsNJyLc2gTyEwtzOzizvil+6pl8HC4JdBK1bcswnRvBSmzoRSNw2ts
 UI4e99vlw5Jn8UlvZ3rxjJPAtzHa4ZDRsuYxvdTtoBrkCk4Xxt/SVDcEth0K0tdQxil6
 TMKj1ih4FlcQx96VC/MvhdEA3xTRQvDukaCmRy6HPF6H4bYKkKKiGfAFd9Hh7+jbYTrQ
 G/6a+FwRWIVPBSfAu7ogvWimsaCjCdiFzz6Q+ToGopiVQIzUiWn723Gzty8CG3WoajSv ug== 
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3q11er89mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Apr 2023 09:40:09 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 33H9e80a007215
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Apr 2023 09:40:08 GMT
Received: from zijuhu-gv.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 17 Apr 2023 02:40:04 -0700
From:   Zijun Hu <quic_zijuhu@quicinc.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <quic_zijuhu@quicinc.com>, <abhishekpandit@chromium.org>
Subject: [PATCH v2] Bluetooth: Devcoredump: Fix storing u32 without specifying byte order issue
Date:   Mon, 17 Apr 2023 17:39:59 +0800
Message-ID: <1681724399-28292-1-git-send-email-quic_zijuhu@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1681213778-31754-1-git-send-email-quic_zijuhu@quicinc.com>
References: <1681213778-31754-1-git-send-email-quic_zijuhu@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: fp6i7WSwlnlVP6_7bm54u842youxFVeG
X-Proofpoint-ORIG-GUID: fp6i7WSwlnlVP6_7bm54u842youxFVeG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-17_05,2023-04-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 priorityscore=1501 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304170085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

API hci_devcd_init() stores its u32 type parameter @dump_size into
skb, but it does not specify which byte order is used to store the
integer, let us take little endian to store and parse the integer.

Fixes: f5cc609d09d4 ("Bluetooth: Add support for hci devcoredump")
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

