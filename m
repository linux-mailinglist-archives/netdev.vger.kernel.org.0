Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D31E620FB
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 16:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730233AbfGHO6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 10:58:31 -0400
Received: from m12-16.163.com ([220.181.12.16]:41748 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfGHO6a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 10:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=6z3VTbWxejjhdRE/21
        o8AQqRLBIhjdGwpP6Cqvq01LI=; b=VIXFvUUzqkZ0mcKtqnccRI3Fxvr5cXolaJ
        eXyZhrcj1lXIOzxWj74q8vWxMKvhj286UdOHMalsHY/5qrnPzc5aJb9HqgBfKCSV
        pKJfNYLZgAws4x49Y2JsDxXh/t5QIuAJ2R0sBrycSweA37Gfs6OmCIBj1Kybr2Uj
        mfuGNOp+U=
Received: from localhost.localdomain (unknown [119.123.132.78])
        by smtp12 (Coremail) with SMTP id EMCowADnZob5WSNdyi8oAQ--.22104S3;
        Mon, 08 Jul 2019 22:58:03 +0800 (CST)
From:   Yang Wei <albin_yang@163.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, tglx@linutronix.de, albin_yang@163.com
Subject: [PATCH net,v2] nfc: fix potential illegal memory access
Date:   Mon,  8 Jul 2019 22:57:39 +0800
Message-Id: <1562597859-4323-1-git-send-email-albin_yang@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: EMCowADnZob5WSNdyi8oAQ--.22104S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrtFW5tr18CFyfJw45GFWUXFb_yoWxurXE9F
        Z5Za18Kws8WF93CwsIkr4kAFyxGw1FgF1kuFWxt3y0va43A3Z8CrWvqr93uF4DWw47CFyx
        GrZ8Jrn7Aw1UCjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU18nY3UUUUU==
X-Originating-IP: [119.123.132.78]
X-CM-SenderInfo: pdoex0xb1d0wi6rwjhhfrp/1tbiqxHrolUMRY7k2QAAsc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The frags_q is not properly initialized, it may result in illegal memory 
access when conn_info is NULL.
The "goto free_exit" should be replaced by "goto exit".

Signed-off-by: Yang Wei <albin_yang@163.com>
---
 net/nfc/nci/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 0a0c265..ce3382b 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -107,7 +107,7 @@ static int nci_queue_tx_data_frags(struct nci_dev *ndev,
 	conn_info = nci_get_conn_info_by_conn_id(ndev, conn_id);
 	if (!conn_info) {
 		rc = -EPROTO;
-		goto free_exit;
+		goto exit;
 	}
 
 	__skb_queue_head_init(&frags_q);
-- 
2.7.4


