Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87EB63C097
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiK2NJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiK2NJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:09:54 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9307659160;
        Tue, 29 Nov 2022 05:09:53 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATBxieY022509;
        Tue, 29 Nov 2022 05:09:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=qOHmlBNZrt/ESjNhAqgvibQ4IGM9LRRF1u0q2xC6GC8=;
 b=OqPurvB8Icwj5P8H/HHaUHVc9PJeyDTdnxL0WbikZGj179tHYNws9iuP5wsLlXtMjyCf
 bvw4JVr7pUBfW6nJp1AVGnG8nFqKEzmWbIBdX6vO3zF5xXiZ+PIE/Kz8Mj3Gb+nwIaVp
 +nCiqHD/v/IzTocCNywZlkoJ+LLCPkTI37/9T/MceTkRe8MJOJ4GpMxoAfJsdok1fEP+
 ROJmEkY/MW02pymxyLyQTZbGRTjgV4JRMWpqlkdVDTANisXnMfmFdIPOo0ty4lKUnOFa
 mCe3OMYMDGaG8sm2dF+WByqY+59OuFvG7Md2ZiTZ63inUxXKWFXy+pHT2ggco5hbLOQ3 xg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3m3k6wbcnq-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 05:09:46 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 29 Nov
 2022 05:09:43 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 29 Nov 2022 05:09:43 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 9488C3F7084;
        Tue, 29 Nov 2022 05:09:43 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v2 5/9] octeon_ep: support asynchronous notifications
Date:   Tue, 29 Nov 2022 05:09:28 -0800
Message-ID: <20221129130933.25231-6-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221129130933.25231-1-vburru@marvell.com>
References: <20221129130933.25231-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: kHhX36B8sUHspGoB29gPVICq6iHH7kjN
X-Proofpoint-ORIG-GUID: kHhX36B8sUHspGoB29gPVICq6iHH7kjN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_08,2022-11-29_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add asynchronous notification support to the control mailbox.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
---
v1 -> v2:
 * no change

 .../marvell/octeon_ep/octep_ctrl_net.c        | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
index 715af1891d0d..80bcd6cd4732 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
@@ -279,6 +279,33 @@ static int process_mbox_resp(struct octep_device *oct,
 	return 0;
 }
 
+static int process_mbox_notify(struct octep_device *oct,
+			       struct octep_ctrl_mbox_msg *msg)
+{
+	struct octep_ctrl_net_f2h_req *req;
+	struct net_device *netdev = oct->netdev;
+
+	req = (struct octep_ctrl_net_f2h_req *)msg->sg_list[0].msg;
+	switch (req->hdr.s.cmd) {
+	case OCTEP_CTRL_NET_F2H_CMD_LINK_STATUS:
+		if (netif_running(netdev)) {
+			if (req->link.state) {
+				dev_info(&oct->pdev->dev, "netif_carrier_on\n");
+				netif_carrier_on(netdev);
+			} else {
+				dev_info(&oct->pdev->dev, "netif_carrier_off\n");
+				netif_carrier_off(netdev);
+			}
+		}
+		break;
+	default:
+		pr_info("Unknown mbox req : %u\n", req->hdr.s.cmd);
+		break;
+	}
+
+	return 0;
+}
+
 int octep_ctrl_net_recv_fw_messages(struct octep_device *oct)
 {
 	static u16 msg_sz = sizeof(union octep_ctrl_net_max_data);
@@ -303,6 +330,8 @@ int octep_ctrl_net_recv_fw_messages(struct octep_device *oct)
 			process_mbox_req(oct, &msg);
 		else if (msg.hdr.s.flags & OCTEP_CTRL_MBOX_MSG_HDR_FLAG_RESP)
 			process_mbox_resp(oct, &msg);
+		else if (msg.hdr.s.flags & OCTEP_CTRL_MBOX_MSG_HDR_FLAG_NOTIFY)
+			process_mbox_notify(oct, &msg);
 	}
 
 	return 0;
-- 
2.36.0

