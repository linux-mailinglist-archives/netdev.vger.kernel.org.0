Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911502B14E3
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 04:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgKMDwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 22:52:02 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:35551 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726011AbgKMDwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 22:52:02 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UF8oyGL_1605239519;
Received: from aliy80.localdomain(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0UF8oyGL_1605239519)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 13 Nov 2020 11:52:00 +0800
From:   Alex Shi <alex.shi@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/nfc/nic: refined function nci_hci_resp_received
Date:   Fri, 13 Nov 2020 11:51:57 +0800
Message-Id: <1605239517-49707-1-git-send-email-alex.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't use the parameter result actually, so better to remove it and
skip a gcc warning for unused variable.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: "David S. Miller" <davem@davemloft.net> 
Cc: Jakub Kicinski <kuba@kernel.org> 
Cc: netdev@vger.kernel.org 
Cc: linux-kernel@vger.kernel.org 
---
 net/nfc/nci/hci.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index c18e76d6d8ba..6b275a387a92 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -363,16 +363,13 @@ static void nci_hci_cmd_received(struct nci_dev *ndev, u8 pipe,
 }
 
 static void nci_hci_resp_received(struct nci_dev *ndev, u8 pipe,
-				  u8 result, struct sk_buff *skb)
+				  struct sk_buff *skb)
 {
 	struct nci_conn_info    *conn_info;
-	u8 status = result;
 
 	conn_info = ndev->hci_dev->conn_info;
-	if (!conn_info) {
-		status = NCI_STATUS_REJECTED;
+	if (!conn_info)
 		goto exit;
-	}
 
 	conn_info->rx_skb = skb;
 
@@ -388,7 +385,7 @@ static void nci_hci_hcp_message_rx(struct nci_dev *ndev, u8 pipe,
 {
 	switch (type) {
 	case NCI_HCI_HCP_RESPONSE:
-		nci_hci_resp_received(ndev, pipe, instruction, skb);
+		nci_hci_resp_received(ndev, pipe, skb);
 		break;
 	case NCI_HCI_HCP_COMMAND:
 		nci_hci_cmd_received(ndev, pipe, instruction, skb);
-- 
2.29.GIT

