Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E578549D35
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245739AbiFMTQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 15:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244651AbiFMTPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 15:15:18 -0400
Received: from m12-14.163.com (m12-14.163.com [220.181.12.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C963656767;
        Mon, 13 Jun 2022 10:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=2BFH8
        xHI7ebD5lwTJTG4kC1CqPWyQ4gZ47rEICObrZE=; b=c6/geMZUjBmKXnXEdNLsb
        KRu/emB4CbScTTY73LlAQOAxXVT7NPuzkINQ2GtJ/9Y1jKemlgdMsxI3x8O5HJwH
        KIOwycUJztR8x3N6nsNC0rSjS7/TrmnH0iuFjnZ8ypXl4JNpL4BwMm+irxQAwsN4
        qGjXTsXdK6VonJJxfapULY=
Received: from localhost.localdomain (unknown [113.200.174.72])
        by smtp10 (Coremail) with SMTP id DsCowADH2z3jc6diHIt+Hg--.56491S4;
        Tue, 14 Jun 2022 01:29:38 +0800 (CST)
From:   Wentao_Liang <Wentao_Liang_g@163.com>
To:     jdmason@kudzu.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wentao_Liang <Wentao_Liang_g@163.com>
Subject: [PATCH] Fix a use-after-free bug
Date:   Tue, 14 Jun 2022 09:28:53 +0800
Message-Id: <20220614012853.10560-1-Wentao_Liang_g@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowADH2z3jc6diHIt+Hg--.56491S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF13ZFy5Gw43JF1xKFy5XFb_yoWrJr1Up3
        s5AFyfGryUtryDXw18Jr1DZF98J3yUG345CrykGr1rKF13A34Utr1UJryqqry5CrWjyF45
        tr15J3WrZr1UJw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zKsjbhUUUUU=
X-Originating-IP: [113.200.174.72]
X-CM-SenderInfo: xzhq3t5rboxtpqjbwqqrwthudrp/xtbB0QIfL1zIBWPGVgAAsB
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pointer vdev points to a memory region adjacent to a net_device
structure ndev, which is a field of hldev. At line 4740, the invocation
to vxge_device_unregister unregisters device hldev, and it also releases
the memory region pointed by vdev->bar0. At line 4743, the freed memory
region is referenced (i.e., iounmap(vdev->bar0)), resulting in a
use-after-free vulnerability. We can fix the bug by calling iounmap
before vxge_device_unregister.

4721.      static void vxge_remove(struct pci_dev *pdev)
4722.      {
4723.             struct __vxge_hw_device *hldev;
4724.             struct vxgedev *vdev;
…
4731.             vdev = netdev_priv(hldev->ndev);
…
4740.             vxge_device_unregister(hldev);
4741.             /* Do not call pci_disable_sriov here, as it
						will break child devices */
4742.             vxge_hw_device_terminate(hldev);
4743.             iounmap(vdev->bar0);
…
4749              vxge_debug_init(vdev->level_trace, "%s:%d
								Device unregistered",
4750                            __func__, __LINE__);
4751              vxge_debug_entryexit(vdev->level_trace, "%s:%d
								Exiting...", __func__,
4752                          __LINE__);
4753.      }

This is the screenshot when the vulnerability is triggered by using
KASAN. We can see that there is a use-after-free reported by KASAN.

/***********************report begin***************************/

root@kernel:~# echo 1 > /sys/bus/pci/devices/0000:00:03.0/remove
[  178.296316] vxge_remove
[  182.057081]
 ==================================================================
[  182.057548] BUG: KASAN: use-after-free in vxge_remove+0xe0/0x15c
[  182.057760] Read of size 8 at addr ffff888006c76598 by task bash/119
[  182.057983]
[  182.058747] CPU: 0 PID: 119 Comm: bash Not tainted 5.18.0 #5
[  182.058919] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  182.059463] Call Trace:
[  182.059726]  <TASK>
[  182.060017]  dump_stack_lvl+0x34/0x44
[  182.060316]  print_report.cold+0xb2/0x6b7
[  182.060401]  ? kfree+0x89/0x290
[  182.060478]  ? vxge_remove+0xe0/0x15c
[  182.060545]  kasan_report+0xa9/0x120
...
[  182.070606]
 ==================================================================
[  182.071374] Disabling lock debugging due to kernel taint

/************************report end***************************/

After fixing the bug as done in the patch, we can find KASAN do not report
 the bug and the device(00:03.0) has been successfully removed.

/************************report begin*************************/

root@kernel:~# echo 1 > /sys/bus/pci/devices/0000:00:03.0/remove
root@kernel:~#

/************************report end***************************/

Signed-off-by: Wentao_Liang <Wentao_Liang_g@163.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index fa5d4ddf429b..092fd0ae5831 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -4736,10 +4736,10 @@ static void vxge_remove(struct pci_dev *pdev)
 	for (i = 0; i < vdev->no_of_vpath; i++)
 		vxge_free_mac_add_list(&vdev->vpaths[i]);
 
+	iounmap(vdev->bar0);
 	vxge_device_unregister(hldev);
 	/* Do not call pci_disable_sriov here, as it will break child devices */
 	vxge_hw_device_terminate(hldev);
-	iounmap(vdev->bar0);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
 	driver_config->config_dev_cnt--;
-- 
2.25.1

