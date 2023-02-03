Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F561688E99
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 05:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjBCEcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 23:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjBCEcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 23:32:45 -0500
X-Greylist: delayed 910 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Feb 2023 20:32:43 PST
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A12DC10FA;
        Thu,  2 Feb 2023 20:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=ZP/G2
        /Wc7Zu5bVyWuLioRq1av3H4XStIgza6mcAOiVM=; b=YJhjVkWntd6e37EVVkgEk
        3p9BjAnddXGF0adc+AJmUfm546JQLGRXB8mT7zYeb2hwlcmJC0HRMt166iaMmeEa
        n3G6tN7/l0gHN1ydsebmCN+/sp9BQ0CGIcsQ0esB7elmbPMSCMTW8vwiUNZmxHgP
        XZ7CIUMoHyX6PLVRW1QoCE=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g2-4 (Coremail) with SMTP id _____wAnLCyvitxjfZi1Cg--.56355S2;
        Fri, 03 Feb 2023 12:16:47 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     srini.raju@purelifi.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH] wifi: plfxlc: fix potential NULL pointer dereference in plfxlc_usb_wreq_async()
Date:   Fri,  3 Feb 2023 12:16:44 +0800
Message-Id: <20230203041644.581649-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wAnLCyvitxjfZi1Cg--.56355S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1rtr43ur4UtryfCw4kWFg_yoW8GrWDpF
        s5GasI9w1UJr47Ja1xJFs2vFWFgan5Kry8KF4xZa98urZ5JwnYy3ySga4aq3W8Zr4UX3W7
        XryUtry3WFnxG3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pE_HUrUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiQhALU1aEEPGiVgAAsN
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although the usb_alloc_urb uses GFP_ATOMIC, tring to make sure the memory
 allocated not to be NULL. But in some low-memory situation, it's still
 possible to return NULL. It'll pass urb as argument in
 usb_fill_bulk_urb, which will finally lead to a NULL pointer dereference.

Fix it by adding additional check.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger.

Fixes: 68d57a07bfe5 ("wireless: add plfxlc driver for pureLiFi X, XL, XC devices")

Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
 drivers/net/wireless/purelifi/plfxlc/usb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
index 76d0a778636a..ac149aa64908 100644
--- a/drivers/net/wireless/purelifi/plfxlc/usb.c
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
@@ -496,10 +496,17 @@ int plfxlc_usb_wreq_async(struct plfxlc_usb *usb, const u8 *buffer,
 	struct urb *urb = usb_alloc_urb(0, GFP_ATOMIC);
 	int r;
 
+	if (!urb) {
+		r = -ENOMEM;
+		kfree(urb);
+		goto out;
+	}
 	usb_fill_bulk_urb(urb, udev, usb_sndbulkpipe(udev, EP_DATA_OUT),
 			  (void *)buffer, buffer_len, complete_fn, context);
 
 	r = usb_submit_urb(urb, GFP_ATOMIC);
+
+out:
 	if (r)
 		dev_err(&udev->dev, "Async write submit failed (%d)\n", r);
 
-- 
2.25.1

