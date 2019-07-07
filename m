Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC4C6151E
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 15:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfGGNiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 09:38:25 -0400
Received: from m12-11.163.com ([220.181.12.11]:33682 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbfGGNiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jul 2019 09:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=NrRMf+4UgJGNCNOQlU
        9AVOTl9cgAjMKG/pNqJg2scAM=; b=bswBitiNb2Xh42typddzv1P4VsaUq5X99b
        EQXE8HHEfHgyI9NOGUj7H1Y3RKPDGzMcUlGdZS+XbCL12c2VpkwMdV+BvSJwjPxX
        m5MX503do+LDsLKB9cLgw14hItz4eGEBK+NUi5Kol6BVBcym8AQD7rzjhe5Nwm40
        J75kEHdAc=
Received: from localhost.localdomain (unknown [119.123.132.78])
        by smtp7 (Coremail) with SMTP id C8CowAA3n9+79SFdwUpnDA--.20022S3;
        Sun, 07 Jul 2019 21:38:05 +0800 (CST)
From:   Yang Wei <albin_yang@163.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, tglx@linutronix.de, albin_yang@163.com
Subject: [PATCH net] nfc: fix potential illegal memory access
Date:   Sun,  7 Jul 2019 21:37:40 +0800
Message-Id: <1562506660-15853-1-git-send-email-albin_yang@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: C8CowAA3n9+79SFdwUpnDA--.20022S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw15CFyUKFWkAFWUXr1DJrb_yoWfJrb_Zr
        ySv3W8K398W3s7Cw4Skrs8JFyxGw4IgF1kurWIga1xZa43JFnxGrWvqr93ur4UW3y2kF1k
        Gr4DArZ5Ar1xGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU89jjDUUUUU==
X-Originating-IP: [119.123.132.78]
X-CM-SenderInfo: pdoex0xb1d0wi6rwjhhfrp/1tbiqx3qolUMRXXyeQAAsc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The frags_q is used before __skb_queue_head_init when conn_info is
NULL. It may result in illegal memory access.

Signed-off-by: Yang Wei <albin_yang@163.com>
---
 net/nfc/nci/data.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 0a0c265..b5f16cb 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -104,14 +104,14 @@ static int nci_queue_tx_data_frags(struct nci_dev *ndev,
 
 	pr_debug("conn_id 0x%x, total_len %d\n", conn_id, total_len);
 
+	__skb_queue_head_init(&frags_q);
+
 	conn_info = nci_get_conn_info_by_conn_id(ndev, conn_id);
 	if (!conn_info) {
 		rc = -EPROTO;
 		goto free_exit;
 	}
 
-	__skb_queue_head_init(&frags_q);
-
 	while (total_len) {
 		frag_len =
 			min_t(int, total_len, conn_info->max_pkt_payload_len);
-- 
2.7.4


