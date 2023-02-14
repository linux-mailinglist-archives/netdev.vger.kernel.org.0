Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87808695853
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 06:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjBNFPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 00:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbjBNFOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 00:14:39 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D53A1BFC;
        Mon, 13 Feb 2023 21:14:38 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31E546P5028965;
        Mon, 13 Feb 2023 21:14:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=UAT1QvF9ZEOx7oGZw4lwBF6wlHg+CmoOdJroreGcbD0=;
 b=dU1zYKCxqGKUZbepBf/NLJsWOG4OlNMRbfQ0wacyZhH+yTI2rWMXr/tbqoS57jNubF1/
 mWdXMuoEo8M0ByEfMhsvT91xukuuQIGWlm9Ylz/d/Q4a1gRlOg/gzU+3GRKTLCcdSB6j
 FSqE6kwooYa0uK7Y47Rn7YmBbV7Clhizh0mKln8mAXAusUhkqjsn0IGJ9QxxhdZGlCGh
 Uyr71S0SqvnzjiXS06DhviM09rx2HNea36QYHATpnILOzViJE6lzYaFFz+obW4DqXhz+
 CAYD3doPePRBuTvcLa/m9J09VS3qEVseoC5+M8zq0CgFGWfI8DIs3HidXTsaxQoVcgb9 Ow== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3np98upmpf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 21:14:33 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 13 Feb
 2023 21:14:31 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 13 Feb 2023 21:14:31 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 7F7D43F707A;
        Mon, 13 Feb 2023 21:14:31 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v3 5/7] octeon_ep: support asynchronous notifications
Date:   Mon, 13 Feb 2023 21:14:20 -0800
Message-ID: <20230214051422.13705-6-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20230214051422.13705-1-vburru@marvell.com>
References: <20230214051422.13705-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: _Ja-cNIBjHY_AktpoVCW2oo_vkifslAe
X-Proofpoint-ORIG-GUID: _Ja-cNIBjHY_AktpoVCW2oo_vkifslAe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_03,2023-02-13_01,2023-02-09_01
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
v2 -> v3:
 * no change

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

