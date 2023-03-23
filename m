Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1603A6C6772
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 13:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjCWMBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 08:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjCWMAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 08:00:50 -0400
Received: from out-14.mta0.migadu.com (out-14.mta0.migadu.com [IPv6:2001:41d0:1004:224b::e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FF71FE3
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:59:20 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679572755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uKvdKn+ZKiDobsjJ7G4fisgGAh/FDS+LYl6+K24JBfw=;
        b=TqaYL49AWNaDEeyEUFkQMLxOqt2a9gwPqRb1DEv0OWemw4mXaYiiBzRFJTLaurC/Uuuf4k
        0Li+10xGZppilNfCX6b7oBMlUMs30N7YW2YyeN4lKOozZ6XUhQAyYJcQyOiKH7ZDbwUzWm
        MtXEap5oKGy0Rc1vmsdefdCSbn+O/0A=
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     cai.huoqing@linux.dev
Cc:     Karsten Keil <isdn@linux-pingi.de>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: mISDN: netjet: Remove redundant pci_clear_master
Date:   Thu, 23 Mar 2023 19:59:11 +0800
Message-Id: <20230323115912.14443-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,TO_EQ_FM_DIRECT_MX
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove pci_clear_master to simplify the code,
the bus-mastering is also cleared in do_pci_disable_device,
like this:
./drivers/pci/pci.c:2197
static void do_pci_disable_device(struct pci_dev *dev)
{
	u16 pci_command;

	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
	if (pci_command & PCI_COMMAND_MASTER) {
		pci_command &= ~PCI_COMMAND_MASTER;
		pci_write_config_word(dev, PCI_COMMAND, pci_command);
	}

	pcibios_disable_device(dev);
}.
And dev->is_busmaster is set to 0 in pci_disable_device.

Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
---
 drivers/isdn/hardware/mISDN/netjet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/netjet.c b/drivers/isdn/hardware/mISDN/netjet.c
index f8447135a902..566c790a9481 100644
--- a/drivers/isdn/hardware/mISDN/netjet.c
+++ b/drivers/isdn/hardware/mISDN/netjet.c
@@ -970,7 +970,6 @@ nj_release(struct tiger_hw *card)
 	write_lock_irqsave(&card_lock, flags);
 	list_del(&card->list);
 	write_unlock_irqrestore(&card_lock, flags);
-	pci_clear_master(card->pdev);
 	pci_disable_device(card->pdev);
 	pci_set_drvdata(card->pdev, NULL);
 	kfree(card);
-- 
2.34.1

