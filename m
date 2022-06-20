Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758FD55246D
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 21:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245146AbiFTTMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 15:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244329AbiFTTMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 15:12:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B791758E
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 12:12:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA7BD615E9
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 19:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41ADC3411B;
        Mon, 20 Jun 2022 19:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655752367;
        bh=6EBwTfdETNSyZ0L1hy72qtB4j4e4yeEJFcJnwtuDEAg=;
        h=From:To:Cc:Subject:Date:From;
        b=XHDpfsCcTXYYHsmthJX0JKWmqJsaQRz/EQ6q/gQ8CbNdyBoHVVo8Qw86WoQ2S2Umc
         ti/dOoN7h7v15K7SgbIBdXNMNK3ahtJID/GkpLUMk7eX5eqhjIskO02BVPCdphp0QN
         aJAq2xih9XvRSMw7i4KJFYOxggcRnE9h+QtWyKU0u43r82YFJiz50RVgHgv5ZPPgV1
         x9diQdfr9NKnJQiP1pK5yePXRNVVt9Vbyr7zfOzvFbUlqg1CbUj6OBODqx8y4y6q0d
         5X2by5BbkNkMwfop8sh5VdznudWbivLcF/fGAVgB/drXPQHxqs896VWiJn0wQU7x68
         /7LFyfQ1a14zQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, jdmason@kudzu.us,
        christophe.jaillet@wanadoo.fr, Wentao_Liang_g@163.com
Subject: [PATCH net] Revert "drivers/net/ethernet/neterion/vxge: Fix a use-after-free bug in vxge-main.c"
Date:   Mon, 20 Jun 2022 12:12:37 -0700
Message-Id: <20220620191237.1183989-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 8fc74d18639a2402ca52b177e990428e26ea881f.

BAR0 is the main (only?) register bank for this device. We most
obviously can't unmap it before the netdev is unregistered.
This was pointed out in review but the patch got reposted and
merged, anyway.

The author of the patch was only testing it with a QEMU model,
which I presume does not emulate enough for the netdev to be brought
up (author's replies are not visible in lore because they kept sending
their emails in HTML).

Link: https://lore.kernel.org/all/20220616085059.680dc215@kernel.org/
Fixes: 8fc74d18639a ("drivers/net/ethernet/neterion/vxge: Fix a use-after-free bug in vxge-main.c")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jdmason@kudzu.us
CC: christophe.jaillet@wanadoo.fr
CC: Wentao_Liang_g@163.com
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 092fd0ae5831..fa5d4ddf429b 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -4736,10 +4736,10 @@ static void vxge_remove(struct pci_dev *pdev)
 	for (i = 0; i < vdev->no_of_vpath; i++)
 		vxge_free_mac_add_list(&vdev->vpaths[i]);
 
-	iounmap(vdev->bar0);
 	vxge_device_unregister(hldev);
 	/* Do not call pci_disable_sriov here, as it will break child devices */
 	vxge_hw_device_terminate(hldev);
+	iounmap(vdev->bar0);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
 	driver_config->config_dev_cnt--;
-- 
2.36.1

