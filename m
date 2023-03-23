Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B696C62E6
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 10:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjCWJJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 05:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCWJJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 05:09:25 -0400
Received: from out-27.mta1.migadu.com (out-27.mta1.migadu.com [95.215.58.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976C4193F0
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 02:09:24 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679562245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8heerTHq9kX+O1AlscOnshCW0sl+3t4ySnbmUTH08/4=;
        b=SBkUHkqWpaPjzum4QPIb4aVPODL0367StZD4I/ykW1mdvDqjmZKLrtcVWcxHZmnwXzgUhv
        bbWsFsyl4IJ1R7f3c1XobImqKoy7BJ5q4Gtk8mfeAEUBQdilhkez2KCxOAYPZPgp7eKK+F
        3r3urHWu+kTYihhYWuvmFVg9xYTwbjE=
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     cai.huoqing@linux.dev
Cc:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Dariusz Marcinkiewicz <reksio@newterm.pl>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        Brett Creeley <brett.creeley@amd.com>, drivers@pensando.io,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jian Shen <shenjian15@huawei.com>, Hao Lan <lanhao@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Long Li <longli@microsoft.com>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH 4/8] net/fungible: Remove redundant pci_clear_master
Date:   Thu, 23 Mar 2023 17:03:03 +0800
Message-Id: <20230323090314.22431-4-cai.huoqing@linux.dev>
In-Reply-To: <20230323090314.22431-1-cai.huoqing@linux.dev>
References: <20230323090314.22431-1-cai.huoqing@linux.dev>
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
 drivers/net/ethernet/fungible/funcore/fun_dev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/fungible/funcore/fun_dev.c b/drivers/net/ethernet/fungible/funcore/fun_dev.c
index 3680f83feba2..a7fbd4cd560a 100644
--- a/drivers/net/ethernet/fungible/funcore/fun_dev.c
+++ b/drivers/net/ethernet/fungible/funcore/fun_dev.c
@@ -746,7 +746,6 @@ void fun_dev_disable(struct fun_dev *fdev)
 	bitmap_free(fdev->irq_map);
 	pci_free_irq_vectors(pdev);
 
-	pci_clear_master(pdev);
 	pci_disable_device(pdev);
 
 	fun_unmap_bars(fdev);
@@ -821,7 +820,6 @@ int fun_dev_enable(struct fun_dev *fdev, struct pci_dev *pdev,
 disable_admin:
 	fun_disable_admin_queue(fdev);
 free_irq_mgr:
-	pci_clear_master(pdev);
 	bitmap_free(fdev->irq_map);
 free_irqs:
 	pci_free_irq_vectors(pdev);
-- 
2.34.1

