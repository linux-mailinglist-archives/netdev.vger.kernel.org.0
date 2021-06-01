Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC14397091
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 11:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbhFAJvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 05:51:45 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:33241 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233160AbhFAJvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 05:51:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UaupMjV_1622540997;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UaupMjV_1622540997)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Jun 2021 17:49:59 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     krzysztof.kozlowski@canonical.com
Cc:     davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] NFC: nci: Remove redundant assignment to len
Date:   Tue,  1 Jun 2021 17:49:50 +0800
Message-Id: <1622540990-102660-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable 'len' is set to conn_info->max_pkt_payload_len but this
value is never read as it is overwritten with a new value later on,
hence it is a redundant assignment and can be removed.

Clean up the following clang-analyzer warning:

net/nfc/nci/hci.c:164:3: warning: Value stored to 'len' is never read
[clang-analyzer-deadcode.DeadStores]

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 net/nfc/nci/hci.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index 9686514..d6732e5 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -161,8 +161,6 @@ static int nci_hci_send_data(struct nci_dev *ndev, u8 pipe,
 	*(u8 *)skb_push(skb, 1) = data_type;
 
 	do {
-		len = conn_info->max_pkt_payload_len;
-
 		/* If last packet add NCI_HFP_NO_CHAINING */
 		if (i + conn_info->max_pkt_payload_len -
 		    (skb->len + 1) >= data_len) {
-- 
1.8.3.1

