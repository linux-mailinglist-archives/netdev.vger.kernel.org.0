Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8265C58C226
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 05:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbiHHDnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 23:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiHHDnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 23:43:06 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F19FCE0C;
        Sun,  7 Aug 2022 20:43:03 -0700 (PDT)
Received: from localhost.localdomain (unknown [10.12.77.33])
        by mail-app4 (Coremail) with SMTP id cS_KCgBHv04qhvBiSHF2Ag--.32873S4;
        Mon, 08 Aug 2022 11:42:34 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     michael.hennerich@analog.com, alex.aring@gmail.com,
        stefan@datenfreihafen.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v0] ieee802154/adf7242: defer destroy_workqueue call
Date:   Mon,  8 Aug 2022 11:42:24 +0800
Message-Id: <20220808034224.12642-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cS_KCgBHv04qhvBiSHF2Ag--.32873S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tw4rJw1DWF4rur4kur1UAwb_yoW8Xw4DpF
        WrZ345Cw40qr4UJw4FkF48XFyruan5t3y8u3W3Wwsavw1kXrnFyr1xCayjgryrGFW8ZFWS
        vFn8tr15uwn8CrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvl1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28I
        cxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
        1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
        IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
        DU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a possible race condition (use-after-free) like below

  (FREE)                     |  (USE)
  adf7242_remove             |  adf7242_channel
   cancel_delayed_work_sync  |
    destroy_workqueue (1)    |   adf7242_cmd_rx
                             |    mod_delayed_work (2)
                             |

The root cause for this race is that the upper layer (ieee802154) is
unaware of this detaching event and the function adf7242_channel can
be called without any checks.

To fix this, we can add a flag write at the beginning of adf7242_remove
and add flag check in adf7242_channel. Or we can just defer the
destructive operation like other commit 3e0588c291d6 ("hamradio: defer
ax25 kfree after unregister_netdev") which let the
ieee802154_unregister_hw() to handle the synchronization. This patch
takes the second option.

Fixes: 58e9683d1475 ("net: ieee802154: adf7242: Fix OCL calibration
runs")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 drivers/net/ieee802154/adf7242.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/adf7242.c
index 6afdf1622944..efcc45aef508 100644
--- a/drivers/net/ieee802154/adf7242.c
+++ b/drivers/net/ieee802154/adf7242.c
@@ -1310,10 +1310,11 @@ static void adf7242_remove(struct spi_device *spi)
 
 	debugfs_remove_recursive(lp->debugfs_root);
 
+	ieee802154_unregister_hw(lp->hw);
+
 	cancel_delayed_work_sync(&lp->work);
 	destroy_workqueue(lp->wqueue);
-
-	ieee802154_unregister_hw(lp->hw);
+
 	mutex_destroy(&lp->bmux);
 	ieee802154_free_hw(lp->hw);
 }
-- 
2.36.1

