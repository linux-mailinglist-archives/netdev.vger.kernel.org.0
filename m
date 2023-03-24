Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B3B6C839D
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbjCXRrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbjCXRr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:47:29 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C1E199E3;
        Fri, 24 Mar 2023 10:47:28 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OHVwQn018470;
        Fri, 24 Mar 2023 10:47:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=pwu8nKOgZfG0gRZ/hteADACC/gSz1pqVQhGE43XUkAU=;
 b=AIC5FZtngcIT7SKOhVL2JmR5kzAV240hpPAc+t2o9M8wJUhk0SAM7V+cedqcAm0Nb4du
 fNyoo/4oTDd/jIJz55IeDeDHM7yNIG5IeW9v+052hLhyaAhfPVlf/3DJIZ6VHADpZpIh
 LdH3w+HaOdAIjO+TQyM/pueN0cDIycjwmsXY59Vijv0OdR3AriW845aDDQv4iOy38IT9
 CyuXHcAv+lhxjTDSPqmkBfrFYVGhKzHZxFK0oyt7MGTlldTrEvgakjmG/WHr0bb2j5XT
 uxoCvdfHHibZVeBExEFgql6gseOda4iIt/w+FhjNGswTrXrt5nqtM0VXP0XMD1gkOwVj GA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3ph6q3td8t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 10:47:17 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 24 Mar
 2023 10:47:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Fri, 24 Mar 2023 10:47:15 -0700
Received: from sburla-PowerEdge-T630.sclab.marvell.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 64C813F7051;
        Fri, 24 Mar 2023 10:47:15 -0700 (PDT)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v5 6/8] octeon_ep: support asynchronous notifications
Date:   Fri, 24 Mar 2023 10:47:01 -0700
Message-ID: <20230324174704.9752-7-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20230324174704.9752-1-vburru@marvell.com>
References: <20230324174704.9752-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: TYDqBa9O_r3n-hh1S3vvmQs6GMuuFpgx
X-Proofpoint-ORIG-GUID: TYDqBa9O_r3n-hh1S3vvmQs6GMuuFpgx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add asynchronous notification support to the control mailbox.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
---
v4 -> v5:
 * no change

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

