Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117766C66A7
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjCWLdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjCWLdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:33:31 -0400
Received: from out-17.mta1.migadu.com (out-17.mta1.migadu.com [IPv6:2001:41d0:203:375::11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4FD2DE5C
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:33:30 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679571209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LD+4wHknWReXY1ZN3HVGaa4vo8/47rX5RURrjIAJyfI=;
        b=oIZNjjNqvUoureAd5J2qZ8+iUS+rSsgpWoQuJQ7q5AcNBthaZz8hvo+NrKVH4b5mV+A+D+
        SYFXaEpsN1adwQiclxMMVRJ9GDyZOeb4GZnArN0DIs3WfPyIqtosG8YnSjp7poxfD0pklI
        Wm0ktkk4rCQjZNOlB13YypAJRyA3oKE=
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     cai.huoqing@linux.dev
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] can: ctucanfd: Remove redundant pci_clear_master
Date:   Thu, 23 Mar 2023 19:33:16 +0800
Message-Id: <20230323113318.9473-2-cai.huoqing@linux.dev>
In-Reply-To: <20230323113318.9473-1-cai.huoqing@linux.dev>
References: <20230323113318.9473-1-cai.huoqing@linux.dev>
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
 drivers/net/can/ctucanfd/ctucanfd_pci.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/ctucanfd/ctucanfd_pci.c b/drivers/net/can/ctucanfd/ctucanfd_pci.c
index 8f2956a8ae43..9da09e7dd63a 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_pci.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_pci.c
@@ -206,10 +206,8 @@ static int ctucan_pci_probe(struct pci_dev *pdev,
 err_pci_iounmap_bar1:
 	pci_iounmap(pdev, addr);
 err_release_regions:
-	if (msi_ok) {
+	if (msi_ok)
 		pci_disable_msi(pdev);
-		pci_clear_master(pdev);
-	}
 	pci_release_regions(pdev);
 err_disable_device:
 	pci_disable_device(pdev);
@@ -257,10 +255,8 @@ static void ctucan_pci_remove(struct pci_dev *pdev)
 
 	pci_iounmap(pdev, bdata->bar1_base);
 
-	if (bdata->use_msi) {
+	if (bdata->use_msi)
 		pci_disable_msi(pdev);
-		pci_clear_master(pdev);
-	}
 
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-- 
2.34.1

