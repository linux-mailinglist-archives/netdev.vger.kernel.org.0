Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66396B67D6
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 17:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjCLQJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 12:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjCLQJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 12:09:15 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B23AB36454;
        Sun, 12 Mar 2023 09:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=KI84V
        tG+lYqaZnPKW41rtqtNaa7xafoaTjef1FxWfNk=; b=O5JbGqq+arN23HQxkzzqT
        16DPhluNdsKhhWqNAGjvgJcToQ6opfINB3wmSN4fXeJc/1htJfJaDJWI4MSLJUqF
        36WIXaAuxlR3igqyXLTJljNN4fM0BnlmCT2VnDZVVWeUWADVy0kLvE3FvoTNj8/G
        Pz91ZBKEjEUzGqIb5lf2BE=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g4-3 (Coremail) with SMTP id _____wAXRBAG+Q1kULNrDA--.9072S2;
        Mon, 13 Mar 2023 00:08:38 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     krzysztof.kozlowski@linaro.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hackerzheng666@gmail.com, 1395428693sheep@gmail.com,
        alex000young@gmail.com, Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH] nfc: st-nci: Fix use after free bug in ndlc_remove due to race condition
Date:   Mon, 13 Mar 2023 00:08:37 +0800
Message-Id: <20230312160837.2040857-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wAXRBAG+Q1kULNrDA--.9072S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WFyrJFyrKw47KFy7WF18uFg_yoW8XFWkpr
        ZxXryruFWrGF4FyFZ7WF4UGr1YkwsrtryDK3y3W343ZFnayrs0qr92yFW5uF1IqF4IyFW2
        y3yDX3Z8Ja4kCa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziJDGrUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiXQkwU1WBo4he9QAAsj
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bug influences both st_nci_i2c_remove and st_nci_spi_remove.
Take st_nci_i2c_remove as an example.

In st_nci_i2c_probe, it called ndlc_probe and bound &ndlc->sm_work
with llt_ndlc_sm_work.

When it calls ndlc_recv or timeout handler, it will finally call
schedule_work to start the work.

When we call st_nci_i2c_remove to remove the driver, there
may be a sequence as follows:

Fix it by finishing the work before cleanup in ndlc_remove

CPU0                  CPU1

                    |llt_ndlc_sm_work
st_nci_i2c_remove   |
  ndlc_remove       |
     st_nci_remove  |
     nci_free_device|
     kfree(ndev)    |
//free ndlc->ndev   |
                    |llt_ndlc_rcv_queue
                    |nci_recv_frame
                    |//use ndlc->ndev

Fixes: 35630df68d60 ("NFC: st21nfcb: Add driver for STMicroelectronics ST21NFCB NFC chip")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
 drivers/nfc/st-nci/ndlc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/st-nci/ndlc.c b/drivers/nfc/st-nci/ndlc.c
index 755460a73c0d..d2aa9f766738 100644
--- a/drivers/nfc/st-nci/ndlc.c
+++ b/drivers/nfc/st-nci/ndlc.c
@@ -282,13 +282,15 @@ EXPORT_SYMBOL(ndlc_probe);
 
 void ndlc_remove(struct llt_ndlc *ndlc)
 {
-	st_nci_remove(ndlc->ndev);
-
 	/* cancel timers */
 	del_timer_sync(&ndlc->t1_timer);
 	del_timer_sync(&ndlc->t2_timer);
 	ndlc->t2_active = false;
 	ndlc->t1_active = false;
+	/* cancel work */
+	cancel_work_sync(&ndlc->sm_work);
+
+	st_nci_remove(ndlc->ndev);
 
 	skb_queue_purge(&ndlc->rcv_q);
 	skb_queue_purge(&ndlc->send_q);
-- 
2.25.1

