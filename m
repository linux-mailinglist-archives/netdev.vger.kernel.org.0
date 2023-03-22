Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631BB6C4624
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 10:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjCVJUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 05:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjCVJUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 05:20:18 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB7528EB5;
        Wed, 22 Mar 2023 02:20:17 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32M8XRtm027403;
        Wed, 22 Mar 2023 02:20:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=3CnO20oRl8KeUuNGsLEFOb7i+1hkGlS2itaxlqrSRtk=;
 b=RQioDFLn//qRMpz1Insyr7yYQhlU6kfZfU5GRICMx/oYm91hotkz1SWyL2Qdkbdz8Sy9
 Dgg+tI4xT/hVjhQZLb5vOIIo3oZY4d1ZiBaVH8KSfV2GALCaFGlG2vtaDvPmtYy02mLA
 2KaI/zJ+3EPJJPxa3+xlyUXYQKQRdNezSRSs5w5d2svVjP5F0qP7MIZuosZnmazUjs73
 7kviaBpploOm9kYvQlEnhFaRMdGzlJQ2+YmbFvP5DYbKgOmH58175zSlpLmpJhkTdcc1
 bk6YFzIpmtGx/LOGvmz3yetb5ITMihndYeNXPZq9xPrmggIo9+iosvUG67WNeD12FR0c qw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3pfx91g553-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 02:20:10 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 22 Mar
 2023 02:20:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 22 Mar 2023 02:20:08 -0700
Received: from sburla-PowerEdge-T630.sclab.marvell.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 98E995B6937;
        Wed, 22 Mar 2023 02:20:08 -0700 (PDT)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v4 6/8] octeon_ep: support asynchronous notifications
Date:   Wed, 22 Mar 2023 02:19:55 -0700
Message-ID: <20230322091958.13103-7-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20230322091958.13103-1-vburru@marvell.com>
References: <20230322091958.13103-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: PhLvetu92eDfOoa3Njf87_ZkvRtHEbju
X-Proofpoint-ORIG-GUID: PhLvetu92eDfOoa3Njf87_ZkvRtHEbju
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_06,2023-03-21_01,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add asynchronous notification support to the control mailbox.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
---
v3 -> v4:
 * 0005-xxx.patch in v3 is 0006-xxx.patch in v4.
 * addressed review comments
   https://lore.kernel.org/all/Y+0J94sowllCe5Gs@boxer/
   - fixed rct violation.
   - process_mbox_notify() now returns void.

v2 -> v3:
 * no change

v1 -> v2:
 * no change

 .../marvell/octeon_ep/octep_ctrl_net.c        | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
index cef4bc3b1ec0..465eef2824e3 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
@@ -271,6 +271,33 @@ static void process_mbox_resp(struct octep_device *oct,
 	}
 }
 
+static int process_mbox_notify(struct octep_device *oct,
+			       struct octep_ctrl_mbox_msg *msg)
+{
+	struct net_device *netdev = oct->netdev;
+	struct octep_ctrl_net_f2h_req *req;
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
 void octep_ctrl_net_recv_fw_messages(struct octep_device *oct)
 {
 	static u16 msg_sz = sizeof(union octep_ctrl_net_max_data);
@@ -291,6 +318,8 @@ void octep_ctrl_net_recv_fw_messages(struct octep_device *oct)
 
 		if (msg.hdr.s.flags & OCTEP_CTRL_MBOX_MSG_HDR_FLAG_RESP)
 			process_mbox_resp(oct, &msg);
+		else if (msg.hdr.s.flags & OCTEP_CTRL_MBOX_MSG_HDR_FLAG_NOTIFY)
+			process_mbox_notify(oct, &msg);
 	}
 }
 
-- 
2.36.0

